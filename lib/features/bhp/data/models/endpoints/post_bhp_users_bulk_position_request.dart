/// Model żądania masowej zmiany stanowiska pracowników BHP.
class PostBhpUsersBulkPositionRequest {
  /// Tworzy model żądania masowej zmiany stanowiska.
  const PostBhpUsersBulkPositionRequest({
    required this.employeeIds,
    required this.stanowiskoId,
  });

  /// Lista identyfikatorów pracowników.
  final List<int> employeeIds;

  /// Identyfikator nowego stanowiska.
  final int stanowiskoId;

  /// Serializuje żądanie do formatu backendowego.
  Map<String, dynamic> toJson() => {
    'employee_ids': employeeIds,
    'stanowisko_id': stanowiskoId,
  };
}
