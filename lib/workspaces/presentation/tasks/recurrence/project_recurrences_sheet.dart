import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_header.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_sub_nav.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nowoczesny arkusz / widok zarządzania zadaniami cyklicznymi w projekcie.
class ProjectRecurrencesSheet extends StatefulWidget {
  /// Tworzy widok dla wskazanego projektu.
  const ProjectRecurrencesSheet({
    super.key,
    required this.workspaceId,
    required this.projectId,
  });

  final String workspaceId;
  final String projectId;

  @override
  State<ProjectRecurrencesSheet> createState() =>
      _ProjectRecurrencesSheetState();
}

class _ProjectRecurrencesSheetState extends State<ProjectRecurrencesSheet> {
  final _selectedTab = ValueNotifier<int>(0);

  @override
  void dispose() {
    _selectedTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.surface,
    child: BlocConsumer<ProjectRecurrencesCubit, ProjectRecurrencesState>(
      listener: (context, state) {
        if (state is ProjectRecurrencesError) {
          AppBubbleToast.show(
            context,
            message: state.message,
            tone: AppBubbleToastTone.error,
          );
        } else if (state is ProjectRecurrencesLoaded &&
            state.feedback != null) {
          switch (state.feedback!) {
            case ProjectRecurrenceFeedbackSuccess(:final message):
              AppBubbleToast.show(
                context,
                message: message,
                tone: AppBubbleToastTone.success,
              );
            case ProjectRecurrenceFeedbackError(:final message):
              AppBubbleToast.show(
                context,
                message: message,
                tone: AppBubbleToastTone.error,
              );
          }
        }
      },
      builder: (context, state) => Column(
        crossAxisAlignment: .stretch,
        children: [
          const ProjectRecurrencesHeader(),
          ValueListenableBuilder<int>(
            valueListenable: _selectedTab,
            builder: (context, selectedTab, _) => ProjectRecurrencesSubNav(
              state: state,
              selectedTab: selectedTab,
              onSelected: (value) => _selectedTab.value = value,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: switch (state) {
              ProjectRecurrencesInitial() ||
              ProjectRecurrencesLoading(previousRules: null) ||
              ProjectRecurrencesLoading(
                previousRuns: null,
              ) => const Center(child: CircularProgressIndicator()),
              ProjectRecurrencesError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      liveRegion: true,
                      child: Text(message, textAlign: TextAlign.center),
                    ),
                    Gaps.h12,
                    OutlinedButton.icon(
                      onPressed: () => unawaited(
                        context.read<ProjectRecurrencesCubit>().load(),
                      ),
                      icon: const Icon(Symbols.refresh_rounded),
                      label: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ),
              ProjectRecurrencesLoaded(
                :final rules,
                :final runs,
                :final isActionInProgress,
              ) =>
                ValueListenableBuilder<int>(
                  valueListenable: _selectedTab,
                  builder: (context, selectedTab, _) =>
                      ProjectRecurrencesTabContent(
                        selectedTab: selectedTab,
                        rules: rules,
                        runs: runs,
                        isActionInProgress: isActionInProgress,
                        workspaceId: widget.workspaceId,
                        projectId: widget.projectId,
                      ),
                ),
              ProjectRecurrencesLoading(
                :final previousRules?,
                :final previousRuns?,
              ) =>
                ValueListenableBuilder<int>(
                  valueListenable: _selectedTab,
                  builder: (context, selectedTab, _) =>
                      ProjectRecurrencesTabContent(
                        selectedTab: selectedTab,
                        rules: previousRules,
                        runs: previousRuns,
                        isActionInProgress: true,
                        workspaceId: widget.workspaceId,
                        projectId: widget.projectId,
                      ),
                ),
            },
          ),
        ],
      ),
    ),
  );
}
