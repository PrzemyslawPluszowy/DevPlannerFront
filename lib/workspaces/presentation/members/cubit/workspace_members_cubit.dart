import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:devplanner/workspaces/presentation/members/cubit/workspace_members_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lokalny Cubit listy członków jednego workspace’u.
final class WorkspaceMembersCubit extends Cubit<WorkspaceMembersState> {
  WorkspaceMembersCubit({required this.repository, required this.workspaceId})
    : super(const WorkspaceMembersInitial());

  final WorkspacesRepository repository;
  final String workspaceId;

  /// Ładuje członków lub ponawia żądanie po błędzie.
  Future<void> load() async {
    emit(const WorkspaceMembersLoading());
    final result = await repository.listMembers(workspaceId);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        WorkspaceMembersFailure(
          message: error.message,
          backendCode: error.backendCode,
        ),
      ),
      (members) => emit(WorkspaceMembersLoaded(List.unmodifiable(members))),
    );
  }
}
