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

/// Potwierdzenie usunięcia folderu z błędem pozostającym nad dialogiem.
abstract final class StorageFolderDeleteDialog {
  static Future<bool> show(
    BuildContext context, {
    required StorageFolderMutationCubit source,
    required String folderName,
    required StorageFolderDeleteHandler onDelete,
  }) async {
    final result = await DevPlannerModalHost.showDialog<bool>(
      context,
      builder: (_) => BlocProvider.value(
        value: source,
        child: _StorageFolderDeleteView(
          folderName: folderName,
          onDelete: onDelete,
        ),
      ),
    );
    return result == true;
  }
}

final class _StorageFolderDeleteView extends StatefulWidget {
  const _StorageFolderDeleteView({
    required this.folderName,
    required this.onDelete,
  });

  final String folderName;
  final StorageFolderDeleteHandler onDelete;

  @override
  State<_StorageFolderDeleteView> createState() =>
      _StorageFolderDeleteViewState();
}

final class _StorageFolderDeleteViewState
    extends State<_StorageFolderDeleteView> {
  bool _deleting = false;

  Future<void> _delete() async {
    if (_deleting) return;
    setState(() => _deleting = true);
    final route = ModalRoute.of(context);
    final outcome = await widget.onDelete();
    if (!mounted || !_isRouteActive(route)) return;
    if (outcome == StorageFolderActionOutcome.succeeded) {
      Navigator.of(context).pop(true);
    } else if (outcome == StorageFolderActionOutcome.stale) {
      Navigator.of(context).pop(false);
    } else {
      setState(() => _deleting = false);
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
    builder: (context, state) {
      final common = context.filesTheme.common;
      final canSubmit = context.read<StorageFolderMutationCubit>().canMutate;
      final error = state is StorageFolderMutationFailure ? state.error : null;
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
        title: Text(context.l10n.storageDeleteConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.storageDeleteConfirmMessage),
            SizedBox(height: common.tightGap),
            SelectableText(
              widget.folderName,
              style: common.dataStrongText.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            if (error != null) ...[
              SizedBox(height: common.controlGap),
              StorageFolderMutationErrorView(error: error),
            ],
          ],
        ),
        actions: [
          TextButton(
            autofocus: true,
            onPressed: _deleting
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
            key: const ValueKey('storage_folder_delete_confirm'),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: context.colors.onError,
              textStyle: common.controlText,
              minimumSize: Size(0, common.commandRowHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(common.controlRadius),
              ),
            ),
            onPressed: _deleting || !canSubmit ? null : _delete,
            child: _deleting
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.l10n.delete),
          ),
        ],
      );
    },
  );
}
