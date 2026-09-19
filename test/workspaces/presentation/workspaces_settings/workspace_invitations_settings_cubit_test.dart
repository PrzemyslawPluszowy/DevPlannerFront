import 'package:dartz/dartz.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/invitations/cubit/workspace_invitations_settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _WorkspacesRepositoryMock extends Mock implements WorkspacesRepository {}

void main() {
  group('WorkspaceInvitationsSettingsCubit', () {
    test('wyszukuje użytkowników przez aktualny lokalny katalog', () async {
      final repository = _WorkspacesRepositoryMock();
      const user = LocalUserDirectoryResponse(
        userId: 'user-1',
        login: 'anna',
        displayName: 'Anna Kowalska',
        emailVerified: true,
      );
      when(
        () => repository.searchLocalUsers(
          workspaceId: 'workspace-1',
          query: 'anna',
        ),
      ).thenAnswer((_) async => const Right([user]));
      final cubit = WorkspaceInvitationsSettingsCubit(
        workspaceId: 'workspace-1',
        repository: repository,
      );
      addTearDown(cubit.close);

      final users = await cubit.searchLocalUsers('anna');

      expect(users, [user]);
      verify(
        () => repository.searchLocalUsers(
          workspaceId: 'workspace-1',
          query: 'anna',
        ),
      ).called(1);
    });
  });
}
