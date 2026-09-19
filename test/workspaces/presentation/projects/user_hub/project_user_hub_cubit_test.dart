import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_user_preference_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/cubit/project_user_hub_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProjectsRepository extends Mock implements ProjectsRepository {}

void main() {
  late _MockProjectsRepository repository;
  late ProjectUserHubCubit cubit;

  const workspaceId = 'ws-1';
  const projectId = 'proj-1';
  const project = ProjectListItem(
    id: projectId,
    workspaceId: workspaceId,
    name: 'Test Project',
    myRole: ProjectRole.member,
  );

  setUp(() {
    repository = _MockProjectsRepository();
    cubit = ProjectUserHubCubit(
      workspaceId: workspaceId,
      projectId: projectId,
      repository: repository,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('load pobiera dane projektu z repozytorium', () async {
    when(
      () => repository.getProject(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer((_) async => const Right(project));

    await cubit.load();

    expect(cubit.state, isA<ProjectUserHubReady>());
    final readyState = cubit.state as ProjectUserHubReady;
    expect(readyState.project.name, 'Test Project');
    expect(readyState.isPinned, false);
    expect(readyState.isHidden, false);
  });

  test('load z initialProject zachowuje preferencje isPinned i isHidden po pobraniu projektu', () async {
    const pinnedProject = ProjectListItem(
      id: projectId,
      workspaceId: workspaceId,
      name: 'Pinned Project',
      myRole: ProjectRole.member,
      isPinned: true,
      isHidden: true,
      visibility: ProjectVisibility.private,
    );

    when(
      () => repository.getProject(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer((_) async => const Right(project));

    await cubit.load(initialProject: pinnedProject);

    expect(cubit.state, isA<ProjectUserHubReady>());
    final readyState = cubit.state as ProjectUserHubReady;
    expect(readyState.isPinned, true);
    expect(readyState.isHidden, true);
    expect(readyState.project.isPinned, true);
    expect(readyState.project.isHidden, true);
  });

  test('togglePin wysyła nową wartość i zachowuje isHidden', () async {
    when(
      () => repository.getProject(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer((_) async => const Right(project));

    when(
      () => repository.updateProjectPreference(
        workspaceId: workspaceId,
        projectId: projectId,
        isPinned: true,
        isHidden: false,
      ),
    ).thenAnswer(
      (_) async => Right(
        ProjectUserPreferenceResponse(
          projectId: projectId,
          isHidden: false,
          isPinned: true,
          sortPosition: 0,
          updatedAtUtc: DateTime.now(),
        ),
      ),
    );

    await cubit.load();
    await cubit.togglePin(true);

    final readyState = cubit.state as ProjectUserHubReady;
    expect(readyState.isPinned, true);
    expect(readyState.isHidden, false);
    expect(readyState.successMessage, isNotNull);
  });

  test('toggleHide wysyła nową wartość i zachowuje isPinned', () async {
    when(
      () => repository.getProject(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer((_) async => const Right(project));

    when(
      () => repository.updateProjectPreference(
        workspaceId: workspaceId,
        projectId: projectId,
        isPinned: false,
        isHidden: true,
      ),
    ).thenAnswer(
      (_) async => Right(
        ProjectUserPreferenceResponse(
          projectId: projectId,
          isHidden: true,
          isPinned: false,
          sortPosition: 0,
          updatedAtUtc: DateTime.now(),
        ),
      ),
    );

    await cubit.load();
    await cubit.toggleHide(true);

    final readyState = cubit.state as ProjectUserHubReady;
    expect(readyState.isHidden, true);
    expect(readyState.isPinned, false);
    expect(readyState.successMessage, isNotNull);
  });

  test('leaveProject emituje ProjectUserHubLeftSuccess po sukcesie z właściwym visibility', () async {
    when(
      () => repository.getProject(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer((_) async => const Right(project));

    when(
      () => repository.leaveProject(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async => Right(
        ProjectMemberResponse(
          id: 'mem-1',
          workspaceMembershipId: 'ws-mem-1',
          userId: 'user-1',
          role: ProjectRole.member,
          createdAtUtc: DateTime.now(),
        ),
      ),
    );

    await cubit.load();
    await cubit.leaveProject();

    expect(cubit.state, isA<ProjectUserHubLeftSuccess>());
    final success = cubit.state as ProjectUserHubLeftSuccess;
    expect(success.visibility, ProjectVisibility.shared);
  });

  test('leaveProject emituje błąd przy niepowodzeniu', () async {
    when(
      () => repository.getProject(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer((_) async => const Right(project));

    when(
      () => repository.leaveProject(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async => const Left(
        ApiError(
          type: ApiErrorType.badResponse,
          message: 'Nie można opuścić ostatniego ownera.',
        ),
      ),
    );

    await cubit.load();
    await cubit.leaveProject();

    expect(cubit.state, isA<ProjectUserHubReady>());
    final readyState = cubit.state as ProjectUserHubReady;
    expect(readyState.error, 'Nie można opuścić ostatniego ownera.');
    expect(readyState.isLeaving, false);
  });
}
