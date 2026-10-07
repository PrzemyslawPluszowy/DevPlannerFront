/// Potwierdzenie konkretnego żądania zapisu, a nie dowolnej nowej wersji.
final class OnlyOfficeSaveResponse {
  const OnlyOfficeSaveResponse({
    required this.operationId,
    required this.confirmed,
    this.version,
  });

  factory OnlyOfficeSaveResponse.fromJson(Map<String, dynamic> json) {
    final operationId = json['operationId'];
    final confirmed = json['confirmed'];
    final version = json['version'];
    if (operationId is! String ||
        operationId.isEmpty ||
        confirmed is! bool ||
        (confirmed ? version is! int || version < 1 : version != null)) {
      throw const FormatException('Invalid office save confirmation.');
    }
    return OnlyOfficeSaveResponse(
      operationId: operationId,
      confirmed: confirmed,
      version: version as int?,
    );
  }
  final String operationId;
  final bool confirmed;
  final int? version;
}
