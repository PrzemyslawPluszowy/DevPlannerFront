part of 'workspace_resource_detail_pages.dart';

/// Parametryczna trasa celu OKR w workspace.
class WorkspaceOkrResourcePage extends StatelessWidget {
  const WorkspaceOkrResourcePage({
    required this.workspaceId,
    required this.resourceType,
    required this.resourceId,
    super.key,
  });

  final String workspaceId;
  final String resourceType;
  final String resourceId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = OkrObjectiveDetailsCubit(
        repository: context.read<OkrRepository>(),
        workspaceId: workspaceId,
        objectiveId: resourceId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: BlocBuilder<OkrObjectiveDetailsCubit, OkrObjectiveDetailsState>(
      builder: (context, state) => WorkspaceFeatureWrapper(
        title: 'Cel OKR',
        icon: WorkspaceIcons.workflow,
        subtitle: 'Postęp i kluczowe rezultaty',
        isLoading:
            state is OkrObjectiveDetailsInitial ||
            state is OkrObjectiveDetailsLoading,
        errorMessage: switch (state) {
          OkrObjectiveDetailsFailure(:final message, :final backendCode) =>
            backendCode == null ? message : '$message (kod: $backendCode)',
          _ => null,
        },
        onRetry: () =>
            unawaited(context.read<OkrObjectiveDetailsCubit>().load()),
        child: switch (state) {
          OkrObjectiveDetailsLoaded(:final objective) => _OkrObjectiveDetails(
            objective: objective,
            resourceType: resourceType,
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    ),
  );
}

class _OkrObjectiveDetails extends StatelessWidget {
  const _OkrObjectiveDetails({
    required this.objective,
    required this.resourceType,
  });

  final ObjectiveResponse objective;
  final String resourceType;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Text(objective.name, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 8),
      Text(objective.description ?? 'Brak opisu celu.'),
      const SizedBox(height: 20),
      LinearProgressIndicator(value: objective.progress.clamp(0, 1)),
      const SizedBox(height: 8),
      Text(
        'Postęp: ${(objective.progress * 100).round()}% · typ: $resourceType',
      ),
      const SizedBox(height: 20),
      for (final result in objective.keyResults)
        Card(
          elevation: 0,
          child: ListTile(
            title: Text(result.name),
            subtitle: Text(
              'Postęp: ${((result.targetValue == 0 ? 0 : result.currentValue / result.targetValue) * 100).round()}%',
            ),
          ),
        ),
    ],
  );
}

/// Strona Wiki projektu z dodatkowym segmentem `pages`.
class WorkspaceProjectWikiPage extends StatelessWidget {
  const WorkspaceProjectWikiPage({
    required this.workspaceId,
    required this.projectId,
    required this.resourceId,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String resourceId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = WorkspaceResourceAccessCubit(
        repository: context.read<ProjectResourcesRepository>(),
        workspaceId: workspaceId,
        projectId: projectId,
        resourceKind: 'wiki',
        resourceId: resourceId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('Wiki')),
      body:
          BlocBuilder<
            WorkspaceResourceAccessCubit,
            WorkspaceResourceAccessState
          >(
            builder: (context, state) => switch (state) {
              WorkspaceResourceAccessInitial() ||
              WorkspaceResourceAccessLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              WorkspaceResourceAccessGranted(:final item) => _ResourceDetails(
                item: item,
                workspaceId: workspaceId,
                projectId: projectId,
              ),
              WorkspaceResourceAccessNotFound() => const _ResourceMessage(
                title: 'Nie znaleziono strony Wiki',
                message: 'Ta strona nie należy już do wybranego projektu.',
              ),
              WorkspaceResourceAccessFailure(
                :final message,
                :final backendCode,
              ) =>
                _ResourceMessage(
                  title: 'Nie udało się pobrać strony Wiki',
                  message: backendCode == null
                      ? message
                      : '$message (kod: $backendCode)',
                  onRetry: () => unawaited(
                    context.read<WorkspaceResourceAccessCubit>().load(),
                  ),
                ),
            },
          ),
    ),
  );
}

/// Strona Wiki należąca bezpośrednio do workspace’u.
class WorkspaceWikiResourcePage extends StatelessWidget {
  const WorkspaceWikiResourcePage({
    required this.workspaceId,
    required this.resourceId,
    super.key,
  });

  final String workspaceId;
  final String resourceId;

  @override
  Widget build(BuildContext context) => const WorkspaceFeatureWrapper(
    title: 'Wiki workspace’u',
    icon: WorkspaceIcons.wiki,
    subtitle: 'Baza wiedzy i dokumentacja zespołu',
    isEmpty: true,
    emptyTitle: 'Strona Wiki workspace’u',
    emptyMessage:
        'Ten typ strony wymaga jeszcze kontekstowego endpointu szczegółów.',
  );
}

/// Szczegół zaproszenia do workspace’u wskazany z powiadomienia.
class WorkspaceInvitationResourcePage extends StatelessWidget {
  const WorkspaceInvitationResourcePage({
    required this.workspaceId,
    required this.resourceId,
    super.key,
  });

  final String workspaceId;
  final String resourceId;

  @override
  Widget build(BuildContext context) => const WorkspaceFeatureWrapper(
    title: 'Zaproszenie',
    icon: WorkspaceIcons.members,
    subtitle: 'Członkostwo w zespole',
    isEmpty: true,
    emptyTitle: 'Zaproszenie do workspace’u',
    emptyMessage:
        'Szczegóły zaproszenia są dostępne w module zaproszeń workspace’u.',
  );
}
