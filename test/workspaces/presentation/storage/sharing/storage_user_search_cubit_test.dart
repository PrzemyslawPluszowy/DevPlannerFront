import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/user_search/cubit/storage_user_search_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/user_search/cubit/storage_user_search_state.dart';

class _MockWorkspacesRepository extends Mock implements WorkspacesRepository {}

void main() {
  test('search debouncuje i odrzuca użytkowników bez CoreUserId', () async {
    final repository = _MockWorkspacesRepository();
    when(
      () => repository.searchReadyUsers(
        workspaceId: 'workspace-1',
        query: 'anna',
      ),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<ReadyDirectoryUserResponse>>([
        ReadyDirectoryUserResponse(
          readyUserId: 1,
          coreUserId: 'core-1',
          login: 'anna',
          displayName: 'Anna Kowalska',
          emailVerified: true,
        ),
        ReadyDirectoryUserResponse(
          readyUserId: 2,
          login: 'legacy',
          displayName: 'Legacy User',
          emailVerified: true,
        ),
      ]),
    );
    final cubit = StorageUserSearchCubit(
      workspaceId: 'workspace-1',
      repository: repository,
    );
    addTearDown(cubit.close);

    cubit
      ..search('an')
      ..search('anna');
    await Future<void>.delayed(const Duration(milliseconds: 350));

    verify(
      () => repository.searchReadyUsers(
        workspaceId: 'workspace-1',
        query: 'anna',
      ),
    ).called(1);
    final state = cubit.state as StorageUserSearchReady;
    expect(state.users.map((user) => user.coreUserId), ['core-1']);
  });

  test('private scope nie wykonuje zapytania do katalogu workspace', () {
    final repository = _MockWorkspacesRepository();
    final cubit = StorageUserSearchCubit(
      workspaceId: null,
      repository: repository,
    );
    addTearDown(cubit.close);

    cubit.search('anna');

    expect(cubit.state, isA<StorageUserSearchUnavailable>());
    verifyNever(
      () => repository.searchReadyUsers(
        workspaceId: any(named: 'workspaceId'),
        query: any(named: 'query'),
      ),
    );
  });
}
