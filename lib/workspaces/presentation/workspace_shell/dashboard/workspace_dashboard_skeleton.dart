import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Statyczny dashboard startowy workspace’u bez danych domenowych.
class WorkspaceDashboardSkeleton extends StatelessWidget {
  const WorkspaceDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.workspaceShellDashboard,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.h8,
              Text(
                context.l10n.workspaceShellDashboardDescription,
                style: context.text.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              Gaps.h16,
              Wrap(
                spacing: Sizes.p12,
                runSpacing: Sizes.p12,
                children: [
                  for (final item in [
                    context.l10n.workspaceShellWidgetProjects,
                    context.l10n.workspaceShellWidgetTasks,
                    context.l10n.workspaceShellWidgetActivity,
                  ])
                    _DashboardPlaceholder(label: item),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 260,
    height: 140,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Text(label, style: context.text.bodyMedium),
      ),
    ),
  );
}
