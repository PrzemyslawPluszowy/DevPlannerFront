import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_pill.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_create_document_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_create_folder_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_scope_route_codec.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Pierwszy wiersz chrome'u Plików: kontekst, licznik i akcje nadrzędne.
///
/// Ten sam podział co w Tasks: kontekst po lewej, CTA i menu po prawej, wysokość
/// z tokenów modułów danych. Akcje tworzące są bramkowane uprawnieniami
/// kompozycji, więc brak portu nie zostawia widocznej, martwej kontrolki.
///
/// Uwaga o etykietach: moduł używa dziś kilku istniejących, neutralnych
/// tekstowo kluczy ARB („Dodaj”, „Odśwież”), których nazwy pochodzą z innych
/// modułów. Wspólne klucze powierzchni danych zostaną wydzielone w pakiecie
/// porządkowym; do tego czasu zmiana ich tutaj wymagałaby edycji ARB
/// równolegle z pracą innego agenta.
final class StorageChromeContextRow extends StatelessWidget {
  /// Tworzy wiersz kontekstu.
  const StorageChromeContextRow({
    this.capabilities = StorageShellCapabilities.readOnly,
    this.filePicker,
    this.isNarrow = false,
    super.key,
  });

  /// Uprawnienia kompozycji decydujące o widoczności akcji.
  final StorageShellCapabilities capabilities;

  /// Picker plików wymagany przez akcję wysyłania.
  final FilePickerPort? filePicker;

  /// Czy chrome działa w trybie wąskim, w którym akcje drugorzędne zwijają się
  /// do jednego menu.
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final files = context.filesTheme;
    final common = files.common;
    final colors = context.colors;
    final cubit = context.read<StorageBrowserCubit>();

    return BlocBuilder<StorageBrowserCubit, StorageBrowserState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        final scope = cubit.currentScope;
        final canCreateFolder =
            scope.canCreateContent && capabilities.canCreateFolder;
        final canCreateDocument =
            capabilities.canCreateDocument && _supportsDocuments(scope);
        final canCreate = canCreateFolder || canCreateDocument;
        final canUpload = capabilities.canUpload && filePicker != null;
        final count = _completeItemCount(state);
        final returnTo = StorageScopeRouteCodec.returnLocation(
          StorageScopeRouteCodec.routeUri(context),
        );

        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: common.contextRowHeight),
          child: Row(
            children: [
              if (returnTo != null) ...[
                StorageChromePill(
                  icon: AppIcons.arrowLeft,
                  tooltip: MaterialLocalizations.of(
                    context,
                  ).backButtonTooltip,
                  onTap: () => context.go(returnTo),
                ),
                SizedBox(width: common.controlGap),
              ],
              Icon(
                AppIcons.folders,
                size: files.rowIconSize,
                color: colors.primary,
              ),
              SizedBox(width: common.controlGap),
              Expanded(
                child: Text(
                  _scopeTitle(scope, context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: common.projectTitleText.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
              if (count case final count?) ...[
                SizedBox(width: common.controlGap),
                _CountPill(count: count),
              ],
              SizedBox(width: common.sectionGap),
              if (!isNarrow && canCreate) ...[
                _ChromeMenu(
                  menuKey: const ValueKey('storage_create_menu'),
                  icon: AppIcons.add,
                  label: context.l10n.tasksListAddOptionButton,
                  tooltip: context.l10n.tasksListAddOptionButton,
                  showCaret: true,
                  optionsBuilder: (context) => createOptions(
                    context,
                    canCreateFolder: canCreateFolder,
                    canCreateDocument: canCreateDocument,
                  ),
                ),
                SizedBox(width: common.controlGap),
              ],
              if (canUpload) ...[
                StorageChromePill(
                  key: const ValueKey('storage_upload_action'),
                  icon: AppIcons.upload,
                  label: isNarrow ? null : context.l10n.storageUploadFiles,
                  tooltip: context.l10n.storageUploadFiles,
                  isPrimary: true,
                  onTap: () =>
                      unawaited(_pickAndUpload(context, cubit.currentScope)),
                ),
                SizedBox(width: common.controlGap),
              ],
              _ChromeMenu(
                menuKey: const ValueKey('storage_more_menu'),
                icon: AppIcons.moreVertical,
                tooltip: context.l10n.storageMoreOptionsTooltip,
                // Na małym ekranie akcje drugorzędne zwijają się tutaj, więc
                // wyszukiwanie i CTA zostają bez konkurencji o miejsce.
                optionsBuilder: (context) => _moreOptions(
                  context,
                  canCreateFolder: canCreateFolder,
                  canCreateDocument: canCreateDocument,
                  includeCreate: isNarrow && canCreate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static bool _supportsDocuments(StorageScope scope) =>
      scope.isPersonal ||
      scope is StorageWorkspaceScope ||
      scope is StorageProjectScope;

  /// Liczba elementów bieżącego katalogu, ale wyłącznie wtedy, gdy lista jest
  /// kompletna. Przy stronicowaniu liczba sugerowałaby sumę, której nie znamy.
  static int? _completeItemCount(StorageBrowserState state) => switch (state) {
    StorageBrowserEmpty() => 0,
    StorageBrowserReady(:final folders, :final files, :final hasMore) =>
      hasMore ? null : folders.length + files.length,
    _ => null,
  };

  static String _scopeTitle(StorageScope scope, BuildContext context) {
    final l10n = context.l10n;
    if (scope.folderId != null) return l10n.storageFolderTitle;
    if (scope.isTrash) return l10n.storageTrash;
    if (scope.isFavorites) return l10n.storageFavorites;
    if (scope.isRecent) return l10n.storageRecent;
    if (scope.isSharedWithMe) return l10n.storageSharedWithMe;
    return switch (scope) {
      StorageWorkspaceScope() => l10n.storageWorkspaceFilesTitle,
      StorageProjectScope() => l10n.storageProjectFilesTitle,
      StorageResourceScope() => l10n.storageAttachmentsTitle,
      _ => l10n.storageMyFiles,
    };
  }

  static List<AppContextMenuOption<StorageChromeAction>> createOptions(
    BuildContext context, {
    required bool canCreateFolder,
    required bool canCreateDocument,
  }) => [
    if (canCreateFolder)
      AppContextMenuOption<StorageChromeAction>(
        value: StorageChromeAction.newFolder,
        label: context.l10n.storageNewFolder,
        icon: AppIcons.folder,
      ),
    if (canCreateDocument)
      AppContextMenuOption<StorageChromeAction>(
        value: StorageChromeAction.newDocument,
        label: context.l10n.storageNewDocument,
        icon: AppIcons.document,
      ),
  ];

  static List<AppContextMenuOption<StorageChromeAction>> _moreOptions(
    BuildContext context, {
    required bool canCreateFolder,
    required bool canCreateDocument,
    required bool includeCreate,
  }) {
    final l10n = context.l10n;
    final density = context.read<StorageBrowserCubit>().currentDensity;
    final create = includeCreate
        ? createOptions(
            context,
            canCreateFolder: canCreateFolder,
            canCreateDocument: canCreateDocument,
          )
        : const <AppContextMenuOption<StorageChromeAction>>[];
    return [
      ...create,
      AppContextMenuOption<StorageChromeAction>(
        value: StorageChromeAction.refresh,
        label: l10n.tasksViewErrorRefresh,
        icon: AppIcons.refresh,
        separatorBefore: create.isNotEmpty,
      ),
      AppContextMenuOption<StorageChromeAction>(
        value: StorageChromeAction.densityComfortable,
        label: l10n.storageViewDensityComfortable,
        icon: AppIcons.list,
        selected: density == StorageDensity.comfortable,
        separatorBefore: true,
        sectionTitle: l10n.storageViewDensityLabel,
      ),
      AppContextMenuOption<StorageChromeAction>(
        value: StorageChromeAction.densityCompact,
        label: l10n.storageViewDensityCompact,
        icon: AppIcons.list,
        selected: density == StorageDensity.compact,
      ),
    ];
  }

  Future<void> _pickAndUpload(
    BuildContext context,
    StorageScope scope,
  ) async {
    final picker = filePicker;
    if (picker == null) return;
    final pickedFiles = await picker.pickFiles();
    if (pickedFiles.isEmpty || !context.mounted) return;
    context.read<StorageUploadCubit>().enqueue(pickedFiles, scope);
  }
}

/// Akcje chrome'u Plików wybierane z wspólnego menu.
enum StorageChromeAction {
  /// Nowy folder w bieżącym katalogu.
  newFolder,

  /// Nowy pusty dokument biurowy.
  newDocument,

  /// Ponowne wczytanie bieżącego zakresu.
  refresh,

  /// Wygodna gęstość wierszy.
  densityComfortable,

  /// Kompaktowa gęstość wierszy.
  densityCompact,
}

/// Wykonuje akcję chrome'u wybraną z menu.
Future<void> runStorageChromeAction(
  BuildContext context,
  StorageChromeAction action,
) async {
  final cubit = context.read<StorageBrowserCubit>();
  final scope = cubit.currentScope;
  switch (action) {
    case StorageChromeAction.newFolder:
      final name = await StorageCreateFolderDialog.show(context);
      if (name == null || !context.mounted) return;
      await context.read<StorageFolderMutationCubit>().createFolder(
        scope: scope,
        name: name,
        parentFolderId: scope.folderId,
      );
    case StorageChromeAction.newDocument:
      final request = await StorageCreateDocumentDialog.show(context);
      if (request == null || !context.mounted) return;
      await context.read<StorageDocumentMutationCubit>().createDocument(
        scope: scope,
        name: request.name,
        format: request.format,
      );
    case StorageChromeAction.refresh:
      await cubit.load(showLoading: false);
    case StorageChromeAction.densityComfortable:
      cubit.setDensity(StorageDensity.comfortable);
    case StorageChromeAction.densityCompact:
      cubit.setDensity(StorageDensity.compact);
  }
}

/// Pigułka otwierająca wspólne menu chrome'u.
class _ChromeMenu extends StatelessWidget {
  const _ChromeMenu({
    required this.menuKey,
    required this.icon,
    required this.tooltip,
    required this.optionsBuilder,
    this.label,
    this.showCaret = false,
  });

  final Key menuKey;
  final IconData icon;
  final String tooltip;

  /// Pozycje budowane przy otwarciu menu, więc stan zaznaczenia (np. aktywna
  /// gęstość) jest aktualny nawet wtedy, gdy chrome nie był przebudowany.
  final List<AppContextMenuOption<StorageChromeAction>> Function(BuildContext)
  optionsBuilder;

  final String? label;
  final bool showCaret;

  @override
  Widget build(BuildContext context) => StorageChromePill(
    key: menuKey,
    icon: icon,
    label: label,
    tooltip: tooltip,
    showCaret: showCaret,
    onTap: () => unawaited(_select(context)),
  );

  Future<void> _select(BuildContext context) async {
    final options = optionsBuilder(context);
    if (options.isEmpty) return;
    final selected = await AppContextMenu.select<StorageChromeAction>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: tooltip,
      options: options,
    );
    if (selected == null || !context.mounted) return;
    await runStorageChromeAction(context, selected);
  }
}

/// Licznik elementów katalogu w formie pigułki, jak w nagłówku Tasks.
class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: common.controlGap,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(common.controlRadius),
      ),
      child: Text(
        '$count',
        style: common.metaText.copyWith(
          fontWeight: FontWeight.w700,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
