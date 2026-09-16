import 'package:json_annotation/json_annotation.dart';

part 'post_bhp_user_issues_repeat_request.g.dart';

/// Żądanie zbiorczego ponownego wydania wskazanych pozycji wyposażenia.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PostBhpUserIssuesRepeatRequest {
  /// Tworzy żądanie zbiorczego ponownego wydania.
  const PostBhpUserIssuesRepeatRequest({
    required this.selectedIssueIds,
    required this.dataPrzydzialu,
  });

  /// Tworzy żądanie z JSON.
  factory PostBhpUserIssuesRepeatRequest.fromJson(Map<String, dynamic> json) =>
      _$PostBhpUserIssuesRepeatRequestFromJson(json);

  /// Identyfikatory wydań wybranych do ponownego wystawienia.
  final List<int> selectedIssueIds;

  /// Wspólna data przydziału dla wszystkich nowych wydań.
  final String dataPrzydzialu;

  /// Serializuje żądanie do JSON.
  Map<String, dynamic> toJson() => _$PostBhpUserIssuesRepeatRequestToJson(this);
}
