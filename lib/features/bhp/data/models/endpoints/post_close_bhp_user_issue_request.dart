import 'package:json_annotation/json_annotation.dart';

part 'post_close_bhp_user_issue_request.g.dart';

/// Żądanie zamknięcia/zwrotu wydanego wyposażenia.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostCloseBhpUserIssueRequest {
  /// Tworzy żądanie zamknięcia wydanego wyposażenia.
  const PostCloseBhpUserIssueRequest({
    required this.dataZakonczenia,
    this.uwagi,
  });

  /// Tworzy żądanie z JSON.
  factory PostCloseBhpUserIssueRequest.fromJson(Map<String, dynamic> json) =>
      _$PostCloseBhpUserIssueRequestFromJson(json);

  /// Data zakończenia/zwrotu (YYYY-MM-DD).
  final String dataZakonczenia;

  /// Dodatkowe uwagi przy zwrocie.
  final String? uwagi;

  /// Serializuje żądanie do JSON.
  Map<String, dynamic> toJson() => _$PostCloseBhpUserIssueRequestToJson(this);
}
