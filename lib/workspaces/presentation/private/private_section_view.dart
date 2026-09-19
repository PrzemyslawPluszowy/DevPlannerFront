import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/private/cubit/personal_section_cubit.dart';
import 'package:devplanner/workspaces/presentation/private/cubit/personal_section_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Rodzaj prywatnego katalogu widocznego w menu użytkownika.
enum PersonalSectionKind {
  tasks(
    icon: Symbols.task_alt,
    title: 'Moje zadania',
    description: 'Zadania przypisane do Ciebie we wszystkich kontekstach.',
  ),
  files(
    icon: Symbols.folder_copy,
    title: 'Moje pliki',
    description: 'Pliki prywatne i udostępnione Tobie.',
  );

  const PersonalSectionKind({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

/// Treść prywatnego katalogu z kompletnymi stanami Cubita.
class PersonalSectionView extends StatelessWidget {
  const PersonalSectionView({required this.kind, super.key});

  final PersonalSectionKind kind;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PersonalSectionCubit, PersonalSectionState>(
        builder: (context, state) => switch (state) {
          PersonalSectionInitial() || PersonalSectionLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          PersonalSectionReady() => _ReadyView(
            kind: kind,
            state: state,
          ),
          PersonalSectionUnavailable(:final message) => _MessageView(
            kind: kind,
            title: 'Ten widok jest jeszcze niedostępny',
            message: message,
            action: 'Odśwież',
            onAction: () => context.read<PersonalSectionCubit>().load(),
          ),
          PersonalSectionFailure(:final message, :final code) => _MessageView(
            kind: kind,
            title: 'Nie udało się wczytać danych',
            message: code == null ? message : '$message (kod: $code)',
            action: context.l10n.myTasksRetry,
            onAction: () => context.read<PersonalSectionCubit>().load(),
          ),
        },
      );
}

class _ReadyView extends StatelessWidget {
  const _ReadyView({
    required this.kind,
    required this.state,
  });

  final PersonalSectionKind kind;
  final PersonalSectionReady state;

  @override
  Widget build(BuildContext context) {
    if (kind == PersonalSectionKind.tasks) {
      return _MyTasksList(state: state);
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(kind.icon, size: 48, color: context.colors.primary),
                Gaps.h12,
                Text(kind.title, style: context.text.headlineSmall),
                Gaps.h8,
                Text('Elementów: ${state.itemCount}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyTasksList extends StatelessWidget {
  const _MyTasksList({required this.state});

  final PersonalSectionReady state;

  @override
  Widget build(BuildContext context) {
    if (state.tasks.isEmpty) {
      return Center(
        child: Text(
          context.l10n.myTasksEmpty,
          style: context.text.bodyLarge,
        ),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 160) {
          unawaited(context.read<PersonalSectionCubit>().loadMore());
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: state.tasks.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == state.tasks.length) {
            return _MyTasksFooter(state: state);
          }
          return _MyTaskTile(task: state.tasks[index]);
        },
      ),
    );
  }
}

class _MyTasksFooter extends StatelessWidget {
  const _MyTasksFooter({required this.state});

  final PersonalSectionReady state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.loadMoreError != null) {
      return Center(
        child: TextButton.icon(
          onPressed: () => context.read<PersonalSectionCubit>().loadMore(),
          icon: const Icon(Symbols.refresh_rounded),
          label: Text(context.l10n.myTasksRetry),
        ),
      );
    }
    return state.hasMore ? const SizedBox(height: 44) : const SizedBox.shrink();
  }
}

class _MyTaskTile extends StatelessWidget {
  const _MyTaskTile({required this.task});

  final MyTaskListItemResponse task;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      onTap: () => unawaited(
        context.plannerNavigation.go(
          '/workspaces/${task.workspaceId}/projects/${task.projectId}/tasks/${task.id}',
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: context.colors.primaryContainer,
        foregroundColor: context.colors.onPrimaryContainer,
        child: const Icon(Symbols.task_alt_rounded),
      ),
      title: Text(
        task.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${task.key} · ${task.workspaceName} · ${task.projectName}',
      ),
      trailing: task.dueAtUtc == null
          ? null
          : Text(
              MaterialLocalizations.of(context).formatMediumDate(
                task.dueAtUtc!.toLocal(),
              ),
              style: context.text.labelMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
    ),
  );
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.kind,
    required this.title,
    required this.message,
    required this.action,
    required this.onAction,
  });

  final PersonalSectionKind kind;
  final String title;
  final String message;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(kind.icon, size: 48, color: context.colors.primary),
            Gaps.h12,
            Text(
              title,
              style: context.text.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Gaps.h8,
            Text(message, textAlign: TextAlign.center),
            Gaps.h20,
            FilledButton.tonalIcon(
              onPressed: onAction,
              icon: const Icon(Symbols.refresh),
              label: Text(action),
            ),
          ],
        ),
      ),
    ),
  );
}
