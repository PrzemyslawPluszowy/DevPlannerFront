import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_folder_picker_content.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_folder_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wybór folderu docelowego w bieżącym zakresie.
///
/// Picker pokazuje wyłącznie foldery osiągalne w tym samym zakresie, więc nie
/// pozwala wskazać celu, którego przeniesienie i tak zostałoby odrzucone przez
/// walidację kontekstu. Samo przeniesienie należy do wywołującego — dialog
/// zwraca tylko identyfikator i nie zna Cubitów modułu.
final class StorageFolderPickerDialog extends StatefulWidget {
  /// Tworzy picker folderu.
  const StorageFolderPickerDialog({
    required this.repository,
    required this.scope,
    this.disabledFolderIds = const {},
    super.key,
  });

  /// Pokazuje picker i zwraca wybrany folder albo `null`.
  static Future<StorageFolderResponse?> show(
    BuildContext context, {
    required StorageRepository repository,
    required StorageScope scope,
    Set<String> disabledFolderIds = const {},
  }) => showDialog<StorageFolderResponse>(
    context: context,
    builder: (_) => StorageFolderPickerDialog(
      repository: repository,
      scope: scope,
      disabledFolderIds: disabledFolderIds,
    ),
  );

  /// Repozytorium z composition rootu.
  final StorageRepository repository;

  /// Zakres, w którym wolno wybierać foldery.
  final StorageScope scope;

  /// Foldery, których nie można wskazać (np. obecny folder elementu).
  final Set<String> disabledFolderIds;

  @override
  State<StorageFolderPickerDialog> createState() =>
      _StorageFolderPickerDialogState();
}

final class _StorageFolderPickerDialogState
    extends State<StorageFolderPickerDialog> {
  late StorageFolderPickerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _createOwner();
  }

  void _createOwner() {
    _cubit = StorageFolderPickerCubit(
      repository: widget.repository,
      scope: widget.scope,
    );
    unawaited(_cubit.load());
  }

  @override
  void didUpdateWidget(covariant StorageFolderPickerDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.repository, widget.repository) ||
        oldWidget.scope != widget.scope) {
      unawaited(_cubit.close());
      _createOwner();
    }
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  void _cancel() => Navigator.of(context).pop();

  void _confirm() {
    final state = _cubit.state;
    final selected = state.selected;
    if (state.loading ||
        state.error != null ||
        selected == null ||
        !selected.canEdit ||
        widget.disabledFolderIds.contains(selected.id)) {
      return;
    }
    Navigator.of(context).pop(selected);
  }

  void _up() => unawaited(_cubit.up());
  void _open(StorageFolderResponse folder) => unawaited(_cubit.open(folder));
  void _retry() => unawaited(_cubit.load());

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageFolderPickerCubit, StorageFolderPickerState>(
        bloc: _cubit,
        builder: (context, state) {
          final tasks = context.filesTheme.common;
          final colors = context.colors;
          final selected = state.selected;
          final canConfirm =
              !state.loading &&
              state.error == null &&
              selected != null &&
              selected.canEdit &&
              !widget.disabledFolderIds.contains(selected.id);
          return AlertDialog(
            backgroundColor: tasks.canvas,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            insetPadding: EdgeInsets.all(tasks.sectionGap),
            constraints: const BoxConstraints(maxWidth: 520),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tasks.panelRadius),
              side: BorderSide(color: tasks.canvasBorder),
            ),
            titleTextStyle: tasks.projectTitleText.copyWith(
              color: colors.onSurface,
            ),
            title: Text(context.l10n.storageMoveDialogTitle),
            content: SizedBox(
              width: 420,
              height: (MediaQuery.sizeOf(context).height * .45).clamp(
                120.0,
                320.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        key: const ValueKey('storage_picker_up'),
                        icon: const Icon(AppIcons.arrowLeft, size: 18),
                        tooltip: MaterialLocalizations.of(context)
                            .backButtonTooltip,
                        onPressed: state.path.isEmpty ? null : _up,
                      ),
                      Expanded(
                        child: Text(
                          selected?.name ?? context.l10n.storageMoveDialogRoot,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tasks.controlText.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: tasks.controlGap),
                  Expanded(
                    child: StorageFolderPickerContent(
                      state: state,
                      disabledFolderIds: widget.disabledFolderIds,
                      onOpen: _open,
                      onRetry: _retry,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                autofocus: true,
                style: TextButton.styleFrom(
                  foregroundColor: colors.onSurface,
                  textStyle: tasks.controlText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tasks.controlRadius),
                  ),
                ),
                onPressed: _cancel,
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                key: const ValueKey('storage_picker_confirm'),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.onSurface,
                  foregroundColor: colors.surface,
                  textStyle: tasks.controlText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tasks.controlRadius),
                  ),
                ),
                onPressed: canConfirm ? _confirm : null,
                child: Text(context.l10n.storageMoveConfirm),
              ),
            ],
          );
        },
      );
}
