import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/create_workspace_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Kompaktowy widok pustego stanu dla menu katalogu Workspaces.
class WorkspaceDirectoryEmptyState extends StatelessWidget {
  const WorkspaceDirectoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const .symmetric(
        horizontal: Sizes.p8,
        vertical: Sizes.p16,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.workspacesEmptyTitle,
            style: context.text.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.h4,
          Text(
            l10n.workspacesEmptyMessage,
            style: context.text.labelSmall?.copyWith(
              color: colors.onSurfaceVariant.withValues(alpha: .75),
              fontSize: 11,
            ),
          ),
          Gaps.h12,
          OutlinedButton.icon(
            onPressed: () => unawaited(CreateWorkspaceDialog.show(context)),
            icon: const Icon(Symbols.add_rounded, size: 14),
            label: Text(l10n.workspacesCreateWorkspace),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const .symmetric(
                horizontal: Sizes.p10,
                vertical: Sizes.p6,
              ),
              textStyle: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: colors.outlineVariant,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: .all(.circular(6)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
