import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';

/// Podsekcja wyboru przypisanych osób w filtrach zapisanego widoku.
class TaskSavedViewPeopleFilter extends StatelessWidget {
  const TaskSavedViewPeopleFilter({
    required this.selectedAssigneeIds,
    required this.memberProfiles,
    required this.onAssigneesChanged,
    super.key,
  });

  final List<String> selectedAssigneeIds;
  final Map<String, ProjectMemberProfile> memberProfiles;
  final ValueChanged<List<String>> onAssigneesChanged;

  @override
  Widget build(BuildContext context) {
    if (memberProfiles.isEmpty) return const SizedBox.shrink();
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Przypisane osoby',
          style: context.text.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final entry in memberProfiles.entries)
              FilterChip(
                avatar: const Icon(Symbols.person_rounded, size: 16),
                label: Text(
                  entry.value.displayName != null &&
                          entry.value.displayName!.isNotEmpty
                      ? entry.value.displayName!
                      : entry.value.coreUserId,
                ),
                selected: selectedAssigneeIds.contains(entry.key),
                onSelected: (selected) {
                  final updated = List<String>.from(selectedAssigneeIds);
                  if (selected) {
                    updated.add(entry.key);
                  } else {
                    updated.remove(entry.key);
                  }
                  onAssigneesChanged(updated);
                },
              ),
          ],
        ),
      ],
    );
  }
}
