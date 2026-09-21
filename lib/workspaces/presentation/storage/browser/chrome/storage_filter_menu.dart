import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_pill.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wybór filtrów eksploratora: typ pliku, status analizy, data dodania i właściciel.
///
/// Filtr właściciela korzysta z tego samego katalogu lokalnych użytkowników, co
/// udostępnianie osobie: katalog jest zakresowy, więc pokazuje wyłącznie osoby
/// z workspace'u plików. Poza workspace'em (pliki osobiste) sekcja mówi wprost,
/// że katalog nie jest dostępny, zamiast pokazywać pole bez wyników.
final class StorageFilterMenu extends StatelessWidget {
  /// Tworzy kontrolkę filtrów.
  const StorageFilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StorageBrowserCubit>();

    return BlocSelector<StorageBrowserCubit, StorageBrowserState, bool>(
      selector: (_) => cubit.currentFilter.hasActiveFilters,
      builder: (context, isActive) => StorageChromePill(
        key: const ValueKey('storage_filter_menu'),
        icon: Symbols.filter_alt_rounded,
        label: context.l10n.storageFilterMenuLabel,
        tooltip: context.l10n.storageFilterMenuLabel,
        isActive: isActive,
        onTap: () => unawaited(_open(context, cubit)),
      ),
    );
  }

  /// Rozszerzenia obecne w bieżącym widoku, a gdy filtr już zawęża listę —
  /// także wybrane, żeby nie zniknęło ono z panelu razem z wynikami.
  static List<String> _extensionOptions(StorageBrowserCubit cubit) {
    final state = cubit.state;
    final extensions = <String>{
      if (state is StorageBrowserReady)
        for (final file in state.files) ?_normalize(file.extension),
      ?_normalize(cubit.currentFilter.extension),
    };
    return extensions.toList()..sort();
  }

  static String? _normalize(String? extension) {
    if (extension == null) return null;
    final normalized = extension.replaceFirst('.', '').trim().toLowerCase();
    return normalized.isEmpty ? null : normalized;
  }

  Future<void> _open(BuildContext context, StorageBrowserCubit cubit) async {
    final scope = cubit.currentScope;
    final workspaceId = switch (scope) {
      StorageWorkspaceScope(:final workspaceId) => workspaceId,
      StorageProjectScope(:final workspaceId) => workspaceId,
      _ => null,
    };
    await AppContextMenu.showCustom(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: context.l10n.storageFilterMenuLabel,
      // Menu jest montowane na rootowym overlayu, więc panel nie może czytać
      // Cubita z kontekstu — opcje i filtr przekazuje mu wywołujący, który
      // stoi wewnątrz drzewa modułu.
      contentBuilder: (context, dismiss) => _StorageFilterPanel(
        initial: cubit.currentFilter,
        extensionOptions: _extensionOptions(cubit),
        workspaceId: workspaceId,
        userDirectory: context.read<StorageUserDirectoryPort?>(),
        onApply: (filter) {
          dismiss();
          unawaited(cubit.setFilter(filter));
        },
      ),
    );
  }
}

/// Panel filtrów w powierzchni wspólnego menu.
class _StorageFilterPanel extends StatefulWidget {
  const _StorageFilterPanel({
    required this.initial,
    required this.extensionOptions,
    required this.workspaceId,
    required this.userDirectory,
    required this.onApply,
  });

  final StorageBrowserFilter initial;
  final List<String> extensionOptions;
  final String? workspaceId;
  final StorageUserDirectoryPort? userDirectory;
  final ValueChanged<StorageBrowserFilter> onApply;

  @override
  State<_StorageFilterPanel> createState() => _StorageFilterPanelState();
}

class _StorageFilterPanelState extends State<_StorageFilterPanel> {
  late StorageBrowserFilter _draft = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final common = context.filesTheme.common;
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Section(
          title: l10n.storageFilterTypeSection,
          child: Wrap(
            spacing: common.controlGap,
            runSpacing: common.controlGap,
            children: [
              _Choice(
                label: l10n.storageFilterAll,
                selected: _draft.extension == null,
                onTap: () => setState(
                  () => _draft = _draft.copyWith(clearExtension: true),
                ),
              ),
              for (final extension in widget.extensionOptions)
                _Choice(
                  label: extension.toUpperCase(),
                  selected: _draft.extension == extension,
                  onTap: () => setState(
                    () => _draft = _draft.copyWith(extension: extension),
                  ),
                ),
            ],
          ),
        ),
        _Section(
          title: l10n.storageAccessOwner,
          child: _OwnerFilter(
            workspaceId: widget.workspaceId,
            userDirectory: widget.userDirectory,
            selectedUserId: _draft.ownerUserId,
            onSelected: (userId) => setState(
              () => _draft = userId == null
                  ? _draft.copyWith(clearOwnerUserId: true)
                  : _draft.copyWith(ownerUserId: userId),
            ),
          ),
        ),
        _Section(
          title: l10n.storageFilterStatusSection,
          child: Wrap(
            spacing: common.controlGap,
            runSpacing: common.controlGap,
            children: [
              _Choice(
                label: l10n.storageFilterAll,
                selected: _draft.aiStatus == null,
                onTap: () => setState(
                  () => _draft = _draft.copyWith(clearAiStatus: true),
                ),
              ),
              for (final status in StorageAiStatus.values)
                _Choice(
                  label: _statusLabel(status, l10n),
                  selected: _draft.aiStatus == status,
                  onTap: () => setState(
                    () => _draft = _draft.copyWith(aiStatus: status),
                  ),
                ),
            ],
          ),
        ),
        _Section(
          title: l10n.storageFilterDateSection,
          child: Wrap(
            spacing: common.controlGap,
            runSpacing: common.controlGap,
            children: [
              _Choice(
                label: l10n.storageFilterAll,
                selected: _draft.createdFromUtc == null,
                onTap: () => setState(
                  () => _draft = _draft.copyWith(clearCreatedFromUtc: true),
                ),
              ),
              _Choice(
                label: l10n.storageFilterDateToday,
                selected: _isWithin(_draft, const Duration(days: 1)),
                onTap: () => setState(
                  () => _draft = _draft.copyWith(
                    createdFromUtc: DateTime.now().toUtc().subtract(
                      const Duration(days: 1),
                    ),
                  ),
                ),
              ),
              _Choice(
                label: l10n.storageFilterDateWeek,
                selected: _isWithin(_draft, const Duration(days: 7)),
                onTap: () => setState(
                  () => _draft = _draft.copyWith(
                    createdFromUtc: DateTime.now().toUtc().subtract(
                      const Duration(days: 7),
                    ),
                  ),
                ),
              ),
              _Choice(
                label: l10n.storageFilterDateMonth,
                selected: _isWithin(_draft, const Duration(days: 30)),
                onTap: () => setState(
                  () => _draft = _draft.copyWith(
                    createdFromUtc: DateTime.now().toUtc().subtract(
                      const Duration(days: 30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: common.controlGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              key: const ValueKey('storage_filter_clear'),
              onPressed: _draft.hasActiveFilters
                  ? () => setState(
                      () => _draft = const StorageBrowserFilter(),
                    )
                  : null,
              child: Text(l10n.storageFilterClear),
            ),
            SizedBox(width: common.controlGap),
            FilledButton(
              key: const ValueKey('storage_filter_apply'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
              ),
              onPressed: () => widget.onApply(_draft),
              child: Text(l10n.save),
            ),
          ],
        ),
      ],
    );
  }

  static bool _isWithin(StorageBrowserFilter filter, Duration window) {
    final from = filter.createdFromUtc;
    if (from == null) return false;
    final delta = DateTime.now().toUtc().difference(from);
    // Dzień, tydzień i miesiąc mają rozłączne okna, więc zaznaczona jest
    // dokładnie jedna opcja.
    return switch (window) {
      const Duration(days: 1) => delta <= const Duration(days: 1),
      const Duration(days: 7) =>
        delta > const Duration(days: 1) && delta <= const Duration(days: 7),
      _ => delta > const Duration(days: 7),
    };
  }

  static String _statusLabel(StorageAiStatus status, AppLocalizations l10n) =>
      switch (status) {
        StorageAiStatus.none => l10n.storageFilterStatusNone,
        StorageAiStatus.queued => l10n.storageFilterStatusQueued,
        StorageAiStatus.processing => l10n.storageFilterStatusProcessing,
        StorageAiStatus.completed => l10n.storageFilterStatusCompleted,
        StorageAiStatus.failed => l10n.storageFilterStatusFailed,
      };
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.menuTheme.sectionText.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    ),
  );
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(common.controlRadius),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: common.controlGap,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: selected ? common.rowSelected : common.commandBarSurface,
          borderRadius: BorderRadius.circular(common.controlRadius),
          border: Border.all(
            color: selected
                ? common.selectionAccent.withValues(alpha: 0.45)
                : common.commandBarBorder.withValues(alpha: 0.6),
          ),
        ),
        child: Text(
          label,
          style: common.controlText.copyWith(
            color: selected ? colors.primary : colors.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Sekcja filtra właściciela plików.
class _OwnerFilter extends StatefulWidget {
  const _OwnerFilter({
    required this.workspaceId,
    required this.userDirectory,
    required this.selectedUserId,
    required this.onSelected,
  });

  final String? workspaceId;
  final StorageUserDirectoryPort? userDirectory;
  final String? selectedUserId;
  final ValueChanged<String?> onSelected;

  @override
  State<_OwnerFilter> createState() => _OwnerFilterState();
}

class _OwnerFilterState extends State<_OwnerFilter> {
  final _controller = TextEditingController();
  List<LocalUserDirectoryResponse> _results = const [];
  String? _selectedName;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final workspaceId = widget.workspaceId;
    final directory = widget.userDirectory;
    final trimmed = query.trim();
    if (workspaceId == null || directory == null || trimmed.length < 2) {
      setState(() => _results = const []);
      return;
    }
    final result = await directory.search(
      workspaceId: workspaceId,
      query: trimmed,
    );
    if (!mounted) return;
    // Odczyt katalogu bez wyników jest tym samym co brak trafień, więc pusta
    // lista nie udaje błędu sieci.
    result.fold(
      (_) => setState(() => _results = const []),
      (users) => setState(() => _results = users),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (widget.workspaceId == null || widget.userDirectory == null) {
      return Text(
        l10n.storageUserSearchWorkspaceRequired,
        style: context.filesTheme.common.metaText.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('storage_filter_owner_search'),
          controller: _controller,
          decoration: InputDecoration(
            hintText: l10n.storageUserInputHint,
            isDense: true,
          ),
          onChanged: (value) => unawaited(_search(value)),
        ),
        if (_selectedName case final name?) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: context.filesTheme.common.controlText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                key: const ValueKey('storage_filter_owner_clear'),
                onPressed: () {
                  _controller.clear();
                  setState(() {
                    _results = const [];
                    _selectedName = null;
                  });
                  widget.onSelected(null);
                },
                child: Text(l10n.storageFilterClear),
              ),
            ],
          ),
        ],
        if (_results.isNotEmpty) ...[
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 140),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final user = _results[index];
                return ListTile(
                  key: ValueKey('storage_filter_owner-${user.userId}'),
                  dense: true,
                  selected: widget.selectedUserId == user.userId,
                  title: Text(user.displayName, maxLines: 1),
                  subtitle: Text(user.login, maxLines: 1),
                  onTap: () {
                    setState(() {
                      _selectedName = user.displayName;
                      _results = const [];
                    });
                    widget.onSelected(user.userId);
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
