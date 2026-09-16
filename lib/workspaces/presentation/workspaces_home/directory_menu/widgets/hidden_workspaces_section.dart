import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/domain/models/workspace_list_item.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:ready_next/workspaces/shared/helpers/workspace_icon_helper.dart';

/// Rozwijana sekcja ukrytych workspace’ów w menu katalogu z możliwością ich przywrócenia.
class HiddenWorkspacesSection extends StatefulWidget {
  const HiddenWorkspacesSection({
    required this.hiddenWorkspaces,
    super.key,
  });

  /// Lista ukrytych przestrzeni.
  final List<WorkspaceListItem> hiddenWorkspaces;

  @override
  State<HiddenWorkspacesSection> createState() =>
      _HiddenWorkspacesSectionState();
}

class _HiddenWorkspacesSectionState extends State<HiddenWorkspacesSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.hiddenWorkspaces.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final cubit = context.read<WorkspacesHomeCubit>();
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Gaps.h12,
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const .all(.circular(6)),
            hoverColor: colors.primary.withValues(alpha: .06),
            child: Padding(
              padding: const .symmetric(
                horizontal: Sizes.p4,
                vertical: 4,
              ),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: _isExpanded ? .25 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Symbols.chevron_right_rounded,
                      size: 14,
                      color: colors.onSurfaceVariant.withValues(alpha: .6),
                    ),
                  ),
                  Gaps.w4,
                  Icon(
                    Symbols.visibility_off_rounded,
                    size: 13,
                    color: colors.onSurfaceVariant.withValues(alpha: .6),
                  ),
                  Gaps.w6,
                  Expanded(
                    child: Text(
                      '${l10n.workspacesHiddenWorkspacesLabel} (${widget.hiddenWorkspaces.length})',
                      style: context.text.labelSmall?.copyWith(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurfaceVariant.withValues(alpha: .7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const .only(top: 4),
            child: Column(
              children: widget.hiddenWorkspaces.map((item) {
                final accentColor = WorkspaceIconHelper.parseColor(
                  item.accentColorHex,
                );
                return Padding(
                  padding: const .only(bottom: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow.withValues(alpha: .5),
                      borderRadius: const .all(.circular(6)),
                    ),
                    padding: const .symmetric(
                      horizontal: Sizes.p8,
                      vertical: 3,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: .15),
                            borderRadius: const .all(.circular(4)),
                          ),
                          alignment: .center,
                          child: Icon(
                            WorkspaceIconHelper.getIcon(item.iconKey),
                            size: 10,
                            color: accentColor,
                          ),
                        ),
                        Gaps.w8,
                        Expanded(
                          child: Text(
                            item.name,
                            style: context.text.bodySmall?.copyWith(
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => unawaited(
                            cubit.setHidden(item.id, false),
                          ),
                          icon: const Icon(Symbols.restore_rounded),
                          iconSize: 14,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 22,
                            minHeight: 22,
                          ),
                          tooltip: l10n.workspacesShowAction,
                          style: IconButton.styleFrom(
                            foregroundColor: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
