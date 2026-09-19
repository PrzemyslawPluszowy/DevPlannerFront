import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';

/// Dane osoby, które można bezpiecznie pokazać w obrębie jednego projektu.
final class ProjectMemberProfile {
  const ProjectMemberProfile({
    required this.userId,
    required this.role,
    this.displayName,
    this.avatarUrl,
  });

  /// Stabilny identyfikator używany przez zdarzenia realtime.
  final String userId;

  /// Nazwa prezentowana użytkownikowi, jeśli katalog Core ją udostępnił.
  final String? displayName;

  /// Bezpieczny URL avatara, jeśli katalog Core go udostępnił.
  final String? avatarUrl;

  /// Skuteczna rola osoby w projekcie.
  final ProjectRole role;
}

/// Jedna access-safe strona osób dostępnych w konkretnym projekcie.
final class ProjectMemberProfilePage {
  const ProjectMemberProfilePage({required this.items, this.nextCursor});

  final List<ProjectMemberProfile> items;
  final String? nextCursor;
}
