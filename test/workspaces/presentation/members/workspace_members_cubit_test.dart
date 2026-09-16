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
import 'package:ready_next/workspaces/presentation/members/cubit/workspace_members_cubit.dart';
import 'package:ready_next/workspaces/presentation/members/cubit/workspace_members_state.dart';

class _Repository implements WorkspacesRepository {
  _Repository(this.result);

  final Either<ApiError, List<WorkspaceMemberResponse>> result;

  @override
  Future<Either<ApiError, List<WorkspaceMemberResponse>>> listMembers(
    String workspaceId,
  ) async => result;

  @override
  Future<Either<ApiError, List<WorkspaceListItem>>> listWorkspaces({
    bool includeHidden = false,
  }) async => const Right([]);

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
  ) async => const Right([]);

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
  blocTest<WorkspaceMembersCubit, WorkspaceMembersState>(
    'ładuje role członków workspace’u',
    build: () => WorkspaceMembersCubit(
      repository: _Repository(
        Right([
          WorkspaceMemberResponse(
            id: 'membership-1',
            coreUserId: 'user-1',
            role: WorkspaceRole.owner,
            createdAtUtc: DateTime(2026),
            updatedAtUtc: DateTime(2026),
          ),
        ]),
      ),
      workspaceId: 'workspace-1',
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkspaceMembersLoading>(),
      isA<WorkspaceMembersLoaded>().having(
        (state) => state.members.single.role,
        'role',
        WorkspaceRole.owner,
      ),
    ],
  );
}
