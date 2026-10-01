import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/collaboration/cubit/task_member_profiles_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock
    implements ProjectMemberProfilesRepository {}

void main() {
  test('ignores an older failure after a successful retry', () async {
    final repository = _Repository();
    final pending = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
    when(
      () => repository.listProfiles(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) => pending.future);
    final cubit = TaskMemberProfilesCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    final initialLoad = cubit.load();
    const expectedError = ApiError(
      type: ApiErrorType.forbidden,
      message: 'Members are unavailable.',
      contractCode: 'project_members_forbidden',
      traceId: 'profile-trace',
    );
    when(
      () => repository.listProfiles(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer(
      (_) async => const Right([
        ProjectMemberProfile(
          userId: 'member-1',
          role: ProjectRole.member,
          displayName: 'Ala',
        ),
      ]),
    );
    await cubit.load();
    pending.complete(const Left(expectedError));
    await initialLoad;

    expect(cubit.state, isA<TaskMemberProfilesReady>());
    expect(
      (cubit.state as TaskMemberProfilesReady).profiles.single.userId,
      'member-1',
    );
    await cubit.close();
  });

  test('keeps a typed API error for the dialog retry surface', () async {
    final repository = _Repository();
    const error = ApiError(
      type: ApiErrorType.forbidden,
      message: 'Members are unavailable.',
      contractCode: 'project_members_forbidden',
      traceId: 'profile-trace',
    );
    when(
      () => repository.listProfiles(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) async => const Left(error));
    final cubit = TaskMemberProfilesCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );

    await cubit.load();

    expect(cubit.state, isA<TaskMemberProfilesFailure>());
    expect((cubit.state as TaskMemberProfilesFailure).error, error);
    await cubit.close();
  });
}
