import 'package:json_annotation/json_annotation.dart';

part 'post_bhp_user_issues_from_standard_request.g.dart';

/// Żądanie dopisania wydań pracownika ze standardu stanowiska.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PostBhpUserIssuesFromStandardRequest {
  /// Tworzy żądanie dopisania wydań ze standardu.
  const PostBhpUserIssuesFromStandardRequest({
    this.selectedStandardIds,
  });

  /// Tworzy żądanie z JSON.
  factory PostBhpUserIssuesFromStandardRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$PostBhpUserIssuesFromStandardRequestFromJson(json);

  /// Wybrane identyfikatory pozycji standardu.
  final List<int>? selectedStandardIds;

  /// Serializuje żądanie do JSON.
  Map<String, dynamic> toJson() =>
      _$PostBhpUserIssuesFromStandardRequestToJson(this);
}
