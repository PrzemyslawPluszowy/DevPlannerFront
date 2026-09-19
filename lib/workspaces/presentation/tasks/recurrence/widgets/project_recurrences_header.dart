import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nagłówek arkusza reguł cyklicznych wraz z odświeżeniem danych.
final class ProjectRecurrencesHeader extends StatelessWidget {
  const ProjectRecurrencesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectRecurrencesCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p20,
        vertical: Sizes.p12,
      ),
      child: Row(
        children: [
          Container(
            width: Sizes.p36,
            height: Sizes.p36,
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(Sizes.p10)),
            ),
            child: Icon(
              Symbols.repeat_rounded,
              color: context.colors.onPrimaryContainer,
              size: Sizes.p20,
            ),
          ),
          Gaps.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.tasksRecurrenceTitle,
                  style: context.text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.2,
                  ),
                ),
                Gaps.h2,
                Text(
                  context.l10n.tasksRecurrenceDescription,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: context.l10n.workspacesRefresh,
            onPressed: () => unawaited(cubit.load()),
            icon: const Icon(Symbols.refresh_rounded, size: Sizes.p18),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
