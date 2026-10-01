import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_action_result.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_mutation_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dialog zmiany nazwy folderu z zachowaniem szkicu i pełnego błędu API.
abstract final class StorageFolderRenameDialog {
  static Future<bool> show(
    BuildContext context, {
    required StorageFolderMutationCubit source,
    required String folderName,
    required StorageFolderRenameHandler onSave,
  }) async {
    final result = await DevPlannerModalHost.showDialog<bool>(
      context,
      builder: (_) => BlocProvider.value(
        value: source,
        child: _StorageFolderRenameView(
          folderName: folderName,
          onSave: onSave,
        ),
      ),
    );
    return result == true;
  }
}

final class _StorageFolderRenameView extends StatefulWidget {
  const _StorageFolderRenameView({
    required this.folderName,
    required this.onSave,
  });

  final String folderName;
  final StorageFolderRenameHandler onSave;

  @override
  State<_StorageFolderRenameView> createState() =>
      _StorageFolderRenameViewState();
}

final class _StorageFolderRenameViewState
    extends State<_StorageFolderRenameView> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.folderName,
  );
  late final ValueNotifier<int> _viewRevision;
  bool _saving = false;
  bool _attempted = false;

  bool get _hasEmptyName => _nameController.text.trim().isEmpty;
  bool get _isUnchanged => _nameController.text.trim() == widget.folderName;

  @override
  void initState() {
    super.initState();
    _viewRevision = ValueNotifier(0);
  }

  @override
  void dispose() {
    _viewRevision.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged(String _) {
    if (!_hasEmptyName) _attempted = false;
    _refreshView();
  }

  void _refreshView() => _viewRevision.value++;

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (_saving) return;
    if (name.isEmpty) {
      _attempted = true;
      _refreshView();
      return;
    }
    final source = context.read<StorageFolderMutationCubit>();
    if (!source.canMutate || name == widget.folderName) return;
    _saving = true;
    _refreshView();
    final route = ModalRoute.of(context);
    final outcome = await widget.onSave(name);
    if (!mounted || !_isRouteActive(route)) return;
    if (source.isClosed ||
        !identical(context.read<StorageFolderMutationCubit>(), source)) {
      Navigator.of(context).pop(false);
      return;
    }
    if (outcome == StorageFolderActionOutcome.succeeded) {
      Navigator.of(context).pop(true);
    } else if (outcome == StorageFolderActionOutcome.stale) {
      Navigator.of(context).pop(false);
    } else {
      _saving = false;
      _refreshView();
    }
  }

  bool _isRouteActive(ModalRoute<dynamic>? route) =>
      route != null &&
      identical(ModalRoute.of(context), route) &&
      route.isCurrent &&
      route.animation?.status != AnimationStatus.reverse;

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<StorageFolderMutationCubit, StorageFolderMutationState>(
    builder: (context, state) => AnimatedBuilder(
      animation: _viewRevision,
      builder: (context, child) {
        final common = context.filesTheme.common;
        final canSubmit = context.read<StorageFolderMutationCubit>().canMutate;
        final error = state is StorageFolderMutationFailure
            ? state.error
            : null;
        return AlertDialog(
          backgroundColor: context.tasksTheme.canvas,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrollable: true,
          insetPadding: EdgeInsets.all(common.sectionGap),
          constraints: const BoxConstraints(maxWidth: 480),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(common.panelRadius),
            side: BorderSide(color: common.canvasBorder),
          ),
          titlePadding: EdgeInsets.all(common.sectionGap),
          contentPadding: EdgeInsets.fromLTRB(
            common.sectionGap,
            0,
            common.sectionGap,
            common.tightGap,
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            common.sectionGap,
            0,
            common.sectionGap,
            common.sectionGap,
          ),
          titleTextStyle: common.projectTitleText.copyWith(
            color: context.colors.onSurface,
          ),
          contentTextStyle: common.dataText.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
          title: Text(context.l10n.storageRenameFolderDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const ValueKey('storage_folder_rename_name'),
                controller: _nameController,
                autofocus: true,
                enabled: !_saving && canSubmit,
                style: common.dataText.copyWith(
                  color: context.colors.onSurface,
                ),
                decoration: InputDecoration(
                  labelText: context.l10n.workspacesFolderNameLabel,
                  hintText: context.l10n.storageCreateFolderDialogHint,
                  errorText: _attempted && _hasEmptyName
                      ? context.l10n.workspacesNameRequiredError
                      : null,
                  labelStyle: common.controlText.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  hintStyle: common.dataText.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: context.tasksTheme.canvas,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(common.controlRadius),
                    borderSide: BorderSide(color: common.canvasBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(common.controlRadius),
                    borderSide: BorderSide(color: common.canvasBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(common.controlRadius),
                    borderSide: BorderSide(color: context.colors.primary),
                  ),
                ),
                onChanged: _onNameChanged,
                onSubmitted: (_) => _save(),
              ),
              if (error != null) ...[
                SizedBox(height: common.controlGap),
                StorageFolderMutationErrorView(error: error),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: _saving
                  ? null
                  : () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: context.colors.onSurface,
                textStyle: common.controlText,
                minimumSize: Size(0, common.commandRowHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(common.controlRadius),
                ),
              ),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              key: const ValueKey('storage_folder_rename_save'),
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.onSurface,
                foregroundColor: context.colors.surface,
                textStyle: common.controlText,
                minimumSize: Size(0, common.commandRowHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(common.controlRadius),
                ),
              ),
              onPressed: _saving || !canSubmit || _hasEmptyName || _isUnchanged
                  ? null
                  : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(context.l10n.save),
            ),
          ],
        );
      },
    ),
  );
}
