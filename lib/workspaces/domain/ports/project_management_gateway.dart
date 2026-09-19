/// Wąski kontrakt tworzenia projektu z lewego menu.
// ignore: one_member_abstracts
abstract interface class ProjectManagementGateway {
  Future<String> createProject({
    required String workspaceId,
    required String name,
  });
}
