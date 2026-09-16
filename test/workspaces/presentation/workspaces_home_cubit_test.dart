import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/workspace_role.dart';
import 'package:ready_next/workspaces/data/workspaces/payloads/workspace_payloads.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/domain/models/workspace_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_state.dart';

class _FakeWorkspacesRepository implements WorkspacesRepository {
  const _FakeWorkspacesRepository(this.result, {this.orderCalls = const []});

  final Either<ApiError, List<WorkspaceListItem>> result;
  final List<List<String>> orderCalls;

  @override
  Future<Either<ApiError, List<WorkspaceListItem>>> listWorkspaces({
    bool includeHidden = false,
  }) async => result;

  @override
  Future<Either<ApiError, List<WorkspaceMemberResponse>>> listMembers(
    String workspaceId,
  ) async => const Right([]);

  @override
  Future<Either<ApiError, WorkspaceListItem>> getWorkspace(
    String workspaceId,
  ) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy getWorkspace.'),
  );

  @override
  Future<Either<ApiError, WorkspaceListItem>> createWorkspace({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy tworzenia.'),
  );

  @override
  Future<Either<ApiError, void>> updateWorkspacePreference({
    required String workspaceId,
    bool? isHidden,
    bool? isPinned,
  }) async => const Right(null);

  @override
  Future<Either<ApiError, List<WorkspaceListItem>>> updateWorkspaceOrder(
    List<String> workspaceIds,
  ) async {
    orderCalls.add(List<String>.of(workspaceIds));
    return result;
  }

  @override
  Future<Either<ApiError, WorkspaceListItem>> updateWorkspace({
    required String workspaceId,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy edycji.'),
  );

  @override
  Future<Either<ApiError, WorkspaceListItem>> archiveWorkspace(
    String workspaceId,
  ) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, WorkspaceListItem>> restoreWorkspace(
    String workspaceId,
  ) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, WorkspaceMemberResponse>> changeMemberRole({
    required String workspaceId,
    required String memberId,
    required WorkspaceRole role,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, WorkspaceMemberRevocationResponse>> revokeMember({
    required String workspaceId,
    required String memberId,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, List<ReadyDirectoryUserResponse>>> searchReadyUsers({
    required String workspaceId,
    required String query,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> createInvitation({
    required String workspaceId,
    required CreateWorkspaceInvitationPayload payload,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceInvitationResponse>>>
  listSentInvitations({
    required String workspaceId,
    int limit = 30,
    String? cursor,
  }) async => const Right(CursorPageResponse(items: []));

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> cancelInvitation({
    required String workspaceId,
    required String invitationId,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> resendInvitation({
    required String workspaceId,
    required String invitationId,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, WorkspaceNotificationPreferenceResponse>>
  getNotificationPreference(String workspaceId) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, WorkspaceNotificationPreferenceResponse>>
  updateNotificationPreference({
    required String workspaceId,
    required UpdateWorkspaceNotificationPreferencePayload payload,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceInvitationResponse>>>
  listReceivedInvitations({int limit = 30, String? cursor}) async =>
      const Right(CursorPageResponse(items: []));

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> acceptInvitation({
    required String workspaceId,
    required String invitationId,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> declineInvitation({
    required String workspaceId,
    required String invitationId,
  }) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );

  @override
  Future<Either<ApiError, WorkspaceMemberRevocationResponse>> leaveWorkspace(
    String workspaceId,
  ) async => const Left(
    ApiError(type: ApiErrorType.server, message: 'Nie testujemy.'),
  );
}

void main() {
  const item = WorkspaceListItem(
    id: 'workspace-1',
    name: 'Marketing',
    isPinned: true,
  );

  blocTest<WorkspacesHomeCubit, WorkspacesHomeState>(
    'emituje loading i listę workspace’ów',
    build: () => WorkspacesHomeCubit(
      repository: const _FakeWorkspacesRepository(Right([item])),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkspacesHomeLoading>(),
      isA<WorkspacesHomeLoaded>(),
    ],
  );

  blocTest<WorkspacesHomeCubit, WorkspacesHomeState>(
    'emituje jawny stan pustej listy',
    build: () => WorkspacesHomeCubit(
      repository: const _FakeWorkspacesRepository(Right([])),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkspacesHomeLoading>(),
      isA<WorkspacesHomeEmpty>(),
    ],
  );

  blocTest<WorkspacesHomeCubit, WorkspacesHomeState>(
    'oddziela ukryte workspace’y od widocznego katalogu',
    build: () => WorkspacesHomeCubit(
      repository: const _FakeWorkspacesRepository(
        Right([
          item,
          WorkspaceListItem(
            id: 'workspace-hidden',
            name: 'Archiwum marketingu',
            isPinned: false,
            isHidden: true,
          ),
        ]),
      ),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkspacesHomeLoading>(),
      isA<WorkspacesHomeLoaded>(),
    ],
    verify: (cubit) {
      final state = cubit.state as WorkspacesHomeLoaded;
      expect(state.items.map((entry) => entry.id), ['workspace-1']);
      expect(state.hiddenItems.map((entry) => entry.id), ['workspace-hidden']);
    },
  );

  blocTest<WorkspacesHomeCubit, WorkspacesHomeState>(
    'emituje komunikat backendu przy błędzie',
    build: () => WorkspacesHomeCubit(
      repository: const _FakeWorkspacesRepository(
        Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'Brak dostępu do Workspaces.',
            backendCode: 403,
          ),
        ),
      ),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkspacesHomeLoading>(),
      isA<WorkspacesHomeForbidden>(),
    ],
    verify: (cubit) {
      final state = cubit.state;
      expect(state, isA<WorkspacesHomeForbidden>());
      expect(
        (state as WorkspacesHomeForbidden).message,
        'Brak dostępu do Workspaces.',
      );
      expect(state.backendCode, '403');
    },
  );

  blocTest<WorkspacesHomeCubit, WorkspacesHomeState>(
    'zachowuje ukryte workspace’y podczas optymistycznego przypinania',
    build: () => WorkspacesHomeCubit(
      repository: const _FakeWorkspacesRepository(
        Right([
          item,
          WorkspaceListItem(
            id: 'workspace-hidden',
            name: 'Archiwum marketingu',
            isPinned: false,
            isHidden: true,
          ),
        ]),
      ),
    ),
    act: (cubit) async {
      await cubit.load();
      await cubit.setPinned(item.id, false);
    },
    verify: (cubit) {
      final state = cubit.state as WorkspacesHomeLoaded;
      // Sprawdza, czy optymistyczna zmiana natychmiast aktualizuje stan bez reloadu
      expect(state.items.single.isPinned, isFalse);
    },
  );

  final orderCalls = <List<String>>[];
  blocTest<WorkspacesHomeCubit, WorkspacesHomeState>(
    'wysyła pełną listę widocznych workspace’ów przy zmianie kolejności',
    build: () => WorkspacesHomeCubit(
      repository: _FakeWorkspacesRepository(
        const Right([
          item,
          WorkspaceListItem(
            id: 'workspace-2',
            name: 'Sprzedaż',
            isPinned: false,
          ),
        ]),
        orderCalls: orderCalls,
      ),
    ),
    act: (cubit) async {
      await cubit.load();
      await cubit.reorderWorkspaces(['workspace-2']);
    },
    verify: (cubit) {
      final state = cubit.state as WorkspacesHomeLoaded;
      expect(state.items.map((entry) => entry.id), [
        'workspace-1',
        'workspace-2',
      ]);
      expect(orderCalls, [
        ['workspace-2', 'workspace-1'],
      ]);
    },
  );

  blocTest<WorkspacesHomeCubit, WorkspacesHomeState>(
    'rozróżnia brak dostępu od zwykłego błędu',
    build: () => WorkspacesHomeCubit(
      repository: const _FakeWorkspacesRepository(
        Left(
          ApiError(
            type: ApiErrorType.server,
            message: 'Błąd serwera.',
            backendCode: 500,
          ),
        ),
      ),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkspacesHomeLoading>(),
      isA<WorkspacesHomeFailure>(),
    ],
  );

  blocTest<WorkspacesHomeCubit, WorkspacesHomeState>(
    'rozróżnia wygasłą sesję od braku dostępu',
    build: () => WorkspacesHomeCubit(
      repository: const _FakeWorkspacesRepository(
        Left(
          ApiError(
            type: ApiErrorType.unauthorized,
            message: 'Sesja wygasła.',
            backendCode: 401,
          ),
        ),
      ),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkspacesHomeLoading>(),
      isA<WorkspacesHomeUnauthorized>(),
    ],
  );
}
