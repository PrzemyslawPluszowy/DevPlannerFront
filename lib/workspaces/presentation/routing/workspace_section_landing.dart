import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:ready_next/workspaces/presentation/members/cubit/workspace_members_cubit.dart';
import 'package:ready_next/workspaces/presentation/members/cubit/workspace_members_state.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_feature_wrapper.dart';

/// Czytelny ekran sekcji workspace'u, gdy właściwy moduł nie ma jeszcze
/// własnego widoku danych. Nie udaje załadowanych rekordów ani nie pokazuje ID.
class WorkspaceSectionLanding extends StatelessWidget {
  const WorkspaceSectionLanding({
    required this.workspaceId,
    required this.section,
    super.key,
  });

  final String workspaceId;
  final String section;

  @override
  Widget build(BuildContext context) {
    final definition = _definitionFor(section);
    return WorkspaceFeatureWrapper(
      title: definition.title,
      icon: definition.icon,
      subtitle: definition.description,
      child: switch (section) {
        'overview' => _OverviewCards(workspaceId: workspaceId),
        'members' => _MembersSection(workspaceId: workspaceId),
        _ => _SectionStatusCard(definition: definition),
      },
    );
  }

  _SectionDefinition _definitionFor(String value) => switch (value) {
    'files' => const _SectionDefinition(
      title: 'Pliki workspace’u',
      description: 'Wspólne pliki i foldery będą dostępne w kontekście tego workspace’u.',
      icon: WorkspaceIcons.file,
    ),
    'wiki' => const _SectionDefinition(
      title: 'Wiki workspace’u',
      description: 'Dokumentacja i wiedza zespołu w jednym miejscu.',
      icon: WorkspaceIcons.wiki,
    ),
    'activity' => const _SectionDefinition(
      title: 'Aktywność',
      description: 'Tutaj pojawi się chronologiczna aktywność workspace’u.',
      icon: WorkspaceIcons.activity,
    ),
    'members' => const _SectionDefinition(
      title: 'Członkowie',
      description: 'Zarządzanie członkami i rolami workspace’u.',
      icon: WorkspaceIcons.members,
    ),
    'settings' => const _SectionDefinition(
      title: 'Ustawienia workspace’u',
      description: 'Konfiguracja przestrzeni i preferencji zespołu.',
      icon: WorkspaceIcons.settings,
    ),
    'invitations' => const _SectionDefinition(
      title: 'Zaproszenia',
      description: 'Zaproszenia wysłane do tego workspace’u.',
      icon: WorkspaceIcons.members,
    ),
    'okr' => const _SectionDefinition(
      title: 'Cele OKR',
      description: 'Cele i kluczowe rezultaty workspace’u.',
      icon: WorkspaceIcons.workflow,
    ),
    _ => const _SectionDefinition(
      title: 'Workspace',
      description: 'Wybierz sekcję z menu, aby rozpocząć pracę.',
      icon: WorkspaceIcons.workspaces,
    ),
  };
}

class _MembersSection extends StatelessWidget {
  const _MembersSection({required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = WorkspaceMembersCubit(
        repository: context.read<WorkspacesRepository>(),
        workspaceId: workspaceId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: BlocBuilder<WorkspaceMembersCubit, WorkspaceMembersState>(
      builder: (context, state) => switch (state) {
        WorkspaceMembersInitial() || WorkspaceMembersLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        WorkspaceMembersLoaded(:final members) =>
          members.isEmpty
              ? const _SectionStatusCard(
                  definition: _SectionDefinition(
                    title: 'Członkowie',
                    description: 'Workspace nie ma jeszcze członków.',
                    icon: WorkspaceIcons.members,
                  ),
                )
              : Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      for (var index = 0; index < members.length; index++)
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(WorkspaceIcons.members),
                          ),
                          title: Text('Członek ${index + 1}'),
                          subtitle: Text('Rola: ${members[index].role.name}'),
                        ),
                    ],
                  ),
                ),
        WorkspaceMembersFailure(:final message, :final backendCode) =>
          _SectionErrorCard(
            message: backendCode == null
                ? message
                : '$message (kod: $backendCode)',
            onRetry: () => context.read<WorkspaceMembersCubit>().load(),
          ),
      },
    ),
  );
}

class _SectionErrorCard extends StatelessWidget {
  const _SectionErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onRetry,
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    ),
  );
}

class _OverviewCards extends StatelessWidget {
  const _OverviewCards({required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: Sizes.p12,
    runSpacing: Sizes.p12,
    children: [
      _OverviewCard(
        workspaceId: workspaceId,
        title: 'Projekty',
        icon: WorkspaceIcons.folders,
        section: 'projects',
      ),
      _OverviewCard(
        workspaceId: workspaceId,
        title: 'Pliki',
        icon: WorkspaceIcons.file,
        section: 'files',
      ),
      _OverviewCard(
        workspaceId: workspaceId,
        title: 'Wiki',
        icon: WorkspaceIcons.wiki,
        section: 'wiki',
      ),
      _OverviewCard(
        workspaceId: workspaceId,
        title: 'Aktywność',
        icon: WorkspaceIcons.activity,
        section: 'activity',
      ),
    ],
  );
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.workspaceId,
    required this.title,
    required this.icon,
    required this.section,
  });

  final String workspaceId;
  final String title;
  final IconData icon;
  final String section;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 220,
    child: Card(
      elevation: 0,
      child: InkWell(
        onTap: () => context.router.navigatePath(
          '/workspaces/$workspaceId/$section',
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Row(
            children: [
              Icon(icon, color: context.colors.primary),
              Gaps.w12,
              Expanded(child: Text(title)),
              const Icon(Symbols.chevron_right),
            ],
          ),
        ),
      ),
    ),
  );
}

class _SectionStatusCard extends StatelessWidget {
  const _SectionStatusCard({required this.definition});

  final _SectionDefinition definition;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p20),
      child: Row(
        children: [
          Icon(definition.icon, size: 28, color: context.colors.primary),
          Gaps.w12,
          const Expanded(
            child: Text(
              'Moduł jest przygotowany do podłączenia danych backendu.',
            ),
          ),
        ],
      ),
    ),
  );
}

final class _SectionDefinition {
  const _SectionDefinition({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
