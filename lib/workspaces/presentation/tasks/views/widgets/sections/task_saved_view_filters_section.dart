import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/helpers/task_saved_view_labels.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_date_range_filter.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_people_filter.dart';

/// Kompletna sekcja wyboru filtrów zapisanego widoku.
///
/// Obsługuje statusy, priorytety, osoby, daty, zaangażowanie, frazę wyszukiwania
/// oraz przełączniki przypiętych/zarchiwizowane bez gubienia pozostałych filtrów.
class TaskSavedViewFiltersSection extends StatelessWidget {
  const TaskSavedViewFiltersSection({
    required this.filter,
    required this.searchController,
    required this.memberProfiles,
    this.availableLabels = const [],
    required this.onFilterChanged,
    this.dateErrorMessage,
    super.key,
  });

  final TaskSavedViewFilter filter;
  final TextEditingController searchController;
  final Map<String, ProjectMemberProfile> memberProfiles;
  final List<TaskLabelResponse> availableLabels;
  final ValueChanged<TaskSavedViewFilter> onFilterChanged;
  final String? dateErrorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final statuses = filter.statuses ?? const [];
    final priorities = filter.priorities ?? const [];
    final assigneeIds = filter.assigneeCoreUserIds ?? const [];
    final labelIds = filter.labelIds ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: searchController,
          maxLength: 160,
          decoration: InputDecoration(
            labelText: l10n.tasksSavedViewsSearch,
            prefixIcon: const Icon(Symbols.search_rounded),
          ),
          onChanged: (val) {
            final trimmed = val.trim();
            onFilterChanged(
              filter.copyWith(search: trimmed.isEmpty ? null : trimmed),
            );
          },
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TaskInvolvementFilter?>(
          initialValue: filter.myInvolvement,
          decoration: InputDecoration(
            labelText: l10n.myTasksInvolvement,
          ),
          items: [
            DropdownMenuItem(child: Text(l10n.myTasksAll)),
            for (final item in TaskInvolvementFilter.values)
              DropdownMenuItem(
                value: item,
                child: Text(TaskSavedViewLabels.involvement(context, item)),
              ),
          ],
          onChanged: (value) =>
              onFilterChanged(filter.copyWith(myInvolvement: value)),
        ),
        const SizedBox(height: 12),
        TaskSavedViewDateRangeFilter(
          dueFrom: filter.dueFromUtc,
          dueTo: filter.dueToUtc,
          errorMessage: dateErrorMessage,
          onDueFromChanged: (val) =>
              onFilterChanged(filter.copyWith(dueFromUtc: val)),
          onDueToChanged: (val) =>
              onFilterChanged(filter.copyWith(dueToUtc: val)),
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: filter.pinnedOnly,
          onChanged: (value) =>
              onFilterChanged(filter.copyWith(pinnedOnly: value)),
          title: Text(l10n.tasksSavedViewsPinnedOnly),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: filter.includeArchived,
          onChanged: (value) =>
              onFilterChanged(filter.copyWith(includeArchived: value)),
          title: Text(l10n.tasksSavedViewsIncludeArchived),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.tasksSavedViewsStatuses,
          style: context.text.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final status in ProjectTaskStatus.values)
              FilterChip(
                label: Text(TaskSavedViewLabels.status(context, status)),
                selected: statuses.contains(status),
                onSelected: (selected) {
                  final updated = List<ProjectTaskStatus>.from(statuses);
                  if (selected) {
                    updated.add(status);
                  } else {
                    updated.remove(status);
                  }
                  onFilterChanged(
                    filter.copyWith(
                      statuses: updated.isEmpty ? null : updated,
                    ),
                  );
                },
              ),
          ],
        ),
        if (availableLabels.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l10n.taskDetailsLabels,
            style: context.text.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final label in availableLabels)
                FilterChip(
                  label: Text(label.name),
                  selected: labelIds.contains(label.id),
                  onSelected: (selected) {
                    final updated = List<String>.from(labelIds);
                    if (selected) {
                      updated.add(label.id);
                    } else {
                      updated.remove(label.id);
                    }
                    onFilterChanged(
                      filter.copyWith(
                        labelIds: updated.isEmpty ? null : updated,
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        Text(
          l10n.tasksSavedViewsPriorities,
          style: context.text.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final priority in TaskPriority.values)
              FilterChip(
                label: Text(TaskSavedViewLabels.priority(context, priority)),
                selected: priorities.contains(priority),
                onSelected: (selected) {
                  final updated = List<TaskPriority>.from(priorities);
                  if (selected) {
                    updated.add(priority);
                  } else {
                    updated.remove(priority);
                  }
                  onFilterChanged(
                    filter.copyWith(
                      priorities: updated.isEmpty ? null : updated,
                    ),
                  );
                },
              ),
          ],
        ),
        if (memberProfiles.isNotEmpty) ...[
          const SizedBox(height: 12),
          TaskSavedViewPeopleFilter(
            selectedAssigneeIds: assigneeIds,
            memberProfiles: memberProfiles,
            onAssigneesChanged: (updated) {
              onFilterChanged(
                filter.copyWith(
                  assigneeCoreUserIds: updated.isEmpty ? null : updated,
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
