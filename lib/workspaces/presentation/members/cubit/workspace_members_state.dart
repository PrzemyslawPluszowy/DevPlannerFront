import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';

/// Stany listy członków workspace’u.
sealed class WorkspaceMembersState {
  const WorkspaceMembersState();
}

final class WorkspaceMembersInitial extends WorkspaceMembersState {
  const WorkspaceMembersInitial();
}

final class WorkspaceMembersLoading extends WorkspaceMembersState {
  const WorkspaceMembersLoading();
}

final class WorkspaceMembersLoaded extends WorkspaceMembersState {
  const WorkspaceMembersLoaded(this.members);

  final List<WorkspaceMemberResponse> members;
}

final class WorkspaceMembersFailure extends WorkspaceMembersState {
  const WorkspaceMembersFailure({required this.message, this.backendCode});

  final String message;
  final Object? backendCode;
}
