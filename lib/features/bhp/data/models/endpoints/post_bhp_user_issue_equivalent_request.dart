import 'package:json_annotation/json_annotation.dart';

part 'post_bhp_user_issue_equivalent_request.g.dart';

/// Żądanie rejestracji ekwiwalentu za wydanie wyposażenia BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostBhpUserIssueEquivalentRequest {
  /// Tworzy żądanie rejestracji ekwiwalentu.
  const PostBhpUserIssueEquivalentRequest({
    required this.dataEkwiwalent,
    required this.kwotaEkwiwalent,
  });

  /// Tworzy żądanie z JSON.
  factory PostBhpUserIssueEquivalentRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$PostBhpUserIssueEquivalentRequestFromJson(json);

  /// Data przyznania ekwiwalentu (YYYY-MM-DD).
  final String dataEkwiwalent;

  /// Kwota wypłaconego ekwiwalentu.
  final String kwotaEkwiwalent;

  /// Serializuje żądanie do JSON.
  Map<String, dynamic> toJson() =>
      _$PostBhpUserIssueEquivalentRequestToJson(this);
}
