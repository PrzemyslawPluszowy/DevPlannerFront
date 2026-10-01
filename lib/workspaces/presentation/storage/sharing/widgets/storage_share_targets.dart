import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_share_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Szybkie granty dla całego workspace'u albo projektu pliku.
final class StorageShareTargets extends StatelessWidget {
  const StorageShareTargets({required this.file, super.key});

  final StorageFileResponse file;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: context.filesTheme.common.tightGap * 2,
    runSpacing: context.filesTheme.common.tightGap * 2,
    children: [
      if (file.workspaceId case final workspace?)
        StorageShareTargetButton(
          key: const ValueKey('share-workspace'),
          label: context.l10n.storageShareWorkspaceLabel(workspace),
          onPressed: (cubit) => cubit.shareWithWorkspace(
            workspaceId: workspace,
            accessLevel: StorageShareAccessLevel.reader,
          ),
        ),
      if (file.projectId case final project?)
        StorageShareTargetButton(
          key: const ValueKey('share-project'),
          label: context.l10n.storageShareProjectLabel(project),
          onPressed: (cubit) => cubit.shareWithProject(
            projectId: project,
            accessLevel: StorageShareAccessLevel.reader,
          ),
        ),
    ],
  );
}

final class StorageShareTargetButton extends StatelessWidget {
  const StorageShareTargetButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Future<bool> Function(StorageSharingCubit source) onPressed;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageSharingCubit, StorageSharingState>(
        builder: (context, state) {
          final source = context.read<StorageSharingCubit>();
          final common = context.filesTheme.common;
          return OutlinedButton.icon(
            icon: const Icon(AppIcons.share, size: 16),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.onSurface,
              side: BorderSide(color: context.colors.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(common.controlRadius),
              ),
            ),
            onPressed: state is StorageSharingReady && source.canMutate
                ? () => _confirmAndShare(context, source)
                : null,
          );
        },
      );

  Future<void> _confirmAndShare(
    BuildContext context,
    StorageSharingCubit source,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => StorageShareConfirmationDialog(
        title: context.l10n.storageShareAction,
        message: label,
        action: context.l10n.storageShareAction,
      ),
    );
    if (!context.mounted ||
        source.isClosed ||
        confirmed != true ||
        !identical(context.read<StorageSharingCubit>(), source)) {
      return;
    }
    await onPressed(source);
  }
}
