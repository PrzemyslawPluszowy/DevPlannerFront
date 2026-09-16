import 'package:json_annotation/json_annotation.dart';

part 'post_bhp_user_issue_request.g.dart';

/// Żądanie dodania nowego wydania wyposażenia dla pracownika.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostBhpUserIssueRequest {
  /// Tworzy żądanie dodania nowego wydania wyposażenia.
  const PostBhpUserIssueRequest({
    required this.kartaWyposazeniaId,
    required this.dataPrzydzialu,
    required this.ilosc,
    this.uwagi,
  });

  /// Tworzy żądanie z JSON.
  factory PostBhpUserIssueRequest.fromJson(Map<String, dynamic> json) =>
      _$PostBhpUserIssueRequestFromJson(json);

  /// Id wybranej karty wyposażenia.
  final int kartaWyposazeniaId;

  /// Data przydziału (YYYY-MM-DD).
  final String dataPrzydzialu;

  /// Ilość wydawanego wyposażenia.
  final String ilosc;

  /// Dodatkowe uwagi.
  final String? uwagi;

  /// Serializuje żądanie do JSON.
  Map<String, dynamic> toJson() => _$PostBhpUserIssueRequestToJson(this);
}
