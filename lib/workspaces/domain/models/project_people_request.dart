import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';

/// Jawny zakres panelu osób; nie przechowuje kontekstu widoku ani transportu.
final class ProjectPeopleRequest {
  const ProjectPeopleRequest({
    required this.workspaceId,
    required this.projectId,
    required this.projectName,
    required this.repository,
    this.ownerUserId,
    this.initialProfiles = const [],
    this.presenceIsFresh = false,
  });

  final String workspaceId;
  final String projectId;
  final String projectName;
  final String? ownerUserId;
  final ProjectMemberProfilesRepository repository;
  final List<ProjectMemberProfile> initialProfiles;
  final bool presenceIsFresh;
}
