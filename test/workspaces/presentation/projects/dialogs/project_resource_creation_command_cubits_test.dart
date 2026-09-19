import 'package:dartz/dartz.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_cubits.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProjectsRepository extends Mock implements ProjectsRepository {}

class _MockProjectResourcesRepository extends Mock
    implements ProjectResourcesRepository {}

void main() {
  const workspaceId = 'workspace-1';
  const projectId = 'project-1';
  const resource = ProjectResourceListItem(
    id: 'resource-1',
    title: 'Zasób',
    kind: ProjectResourceKind.tasks,
  );

  test(
    'CreateProjectCommandCubit przekazuje dane i publikuje identyfikator',
    () async {
      final repository = _MockProjectsRepository();
      final cubit = CreateProjectCommandCubit(repository);
      when(
        () => repository.createProject(
          workspaceId: workspaceId,
          name: 'Plan',
          description: 'Opis',
          icon: 'workflow',
          primaryColor: '#6366f1',
          visibility: ProjectVisibility.private,
        ),
      ).thenAnswer(
        (_) async => const Right(
          ProjectListItem(
            id: projectId,
            workspaceId: workspaceId,
            name: 'Plan',
          ),
        ),
      );

      await cubit.submit(
        workspaceId: workspaceId,
        name: 'Plan',
        description: 'Opis',
        icon: 'workflow',
        primaryColorHex: '#6366f1',
        visibility: ProjectVisibility.private,
      );

      expect(cubit.state.createdResourceId, projectId);
      verify(
        () => repository.createProject(
          workspaceId: workspaceId,
          name: 'Plan',
          description: 'Opis',
          icon: 'workflow',
          primaryColor: '#6366f1',
          visibility: ProjectVisibility.private,
        ),
      ).called(1);
      await cubit.close();
    },
  );

  test('CreateWhiteboardCommandCubit zachowuje typ tablicy', () async {
    final repository = _MockProjectResourcesRepository();
    final cubit = CreateWhiteboardCommandCubit(repository);
    when(
      () => repository.createWhiteboard(
        workspaceId: workspaceId,
        projectId: projectId,
        name: 'Warsztat',
        type: 'A4Document',
      ),
    ).thenAnswer((_) async => const Right(resource));

    await cubit.submit(
      workspaceId: workspaceId,
      projectId: projectId,
      name: 'Warsztat',
      description: null,
      type: 'A4Document',
    );

    expect(cubit.state.createdResourceId, resource.id);
    await cubit.close();
  });

  test('CreateProjectTaskCommandCubit zachowuje priorytet i status', () async {
    final repository = _MockProjectResourcesRepository();
    final cubit = CreateProjectTaskCommandCubit(repository);
    when(
      () => repository.createTask(
        workspaceId: workspaceId,
        projectId: projectId,
        title: 'Wdrożyć',
        priority: 'High',
        status: 'InProgress',
      ),
    ).thenAnswer((_) async => const Right(resource));

    await cubit.submit(
      workspaceId: workspaceId,
      projectId: projectId,
      title: 'Wdrożyć',
      description: null,
      priority: 'High',
      status: 'InProgress',
    );

    expect(cubit.state.createdResourceId, resource.id);
    await cubit.close();
  });

  test('CreateWikiPageCommandCubit publikuje identyfikator strony', () async {
    final repository = _MockProjectResourcesRepository();
    final cubit = CreateWikiPageCommandCubit(repository);
    when(
      () => repository.createWikiPage(
        workspaceId: workspaceId,
        projectId: projectId,
        title: 'Notatki',
      ),
    ).thenAnswer((_) async => const Right(resource));

    await cubit.submit(
      workspaceId: workspaceId,
      projectId: projectId,
      title: 'Notatki',
    );

    expect(cubit.state.createdResourceId, resource.id);
    await cubit.close();
  });

  test('CreateCorkboardCardCommandCubit przekazuje kolor', () async {
    final repository = _MockProjectResourcesRepository();
    final cubit = CreateCorkboardCardCommandCubit(repository);
    when(
      () => repository.createCorkboardCard(
        workspaceId: workspaceId,
        projectId: projectId,
        title: 'Pomysł',
        content: 'Treść',
        colorHex: '#fef08a',
      ),
    ).thenAnswer((_) async => const Right('card-1'));

    await cubit.submit(
      workspaceId: workspaceId,
      projectId: projectId,
      title: 'Pomysł',
      content: 'Treść',
      colorHex: '#fef08a',
    );

    expect(cubit.state.createdResourceId, 'card-1');
    await cubit.close();
  });

  test(
    'CreateProjectFolderCommandCubit publikuje identyfikator folderu',
    () async {
      final repository = _MockProjectResourcesRepository();
      final cubit = CreateProjectFolderCommandCubit(repository);
      when(
        () => repository.createProjectFolder(
          workspaceId: workspaceId,
          projectId: projectId,
          name: 'Materiały',
        ),
      ).thenAnswer((_) async => const Right(resource));

      await cubit.submit(
        workspaceId: workspaceId,
        projectId: projectId,
        name: 'Materiały',
      );

      expect(cubit.state.createdResourceId, resource.id);
      await cubit.close();
    },
  );

  test('stan sukcesu nie jest stanem submitowania', () {
    const state = ProjectResourceCreationCommandState.success('resource-1');

    expect(state.isSubmitting, isFalse);
    expect(state.error, isNull);
  });
}
