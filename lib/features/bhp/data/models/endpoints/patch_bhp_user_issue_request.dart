import 'package:json_annotation/json_annotation.dart';

part 'patch_bhp_user_issue_request.g.dart';

/// Żądanie ręcznej korekty wydania wyposażenia pracownika BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class PatchBhpUserIssueRequest {
  /// Tworzy żądanie korekty wydania.
  const PatchBhpUserIssueRequest({
    required this.kartaWyposazeniaId,
    required this.dataPrzydzialu,
    this.dataZakonczenia,
    required this.ilosc,
    this.uwagi,
  });

  /// Tworzy żądanie z JSON.
  factory PatchBhpUserIssueRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchBhpUserIssueRequestFromJson(json);

  /// Id wybranej karty wyposażenia.
  final int kartaWyposazeniaId;

  /// Data przydziału (YYYY-MM-DD).
  final String dataPrzydzialu;

  /// Data zakończenia (YYYY-MM-DD) albo `null`, jeśli wydanie jest aktywne.
  final String? dataZakonczenia;

  /// Ilość wydawanego wyposażenia.
  final String ilosc;

  /// Dodatkowe uwagi.
  final String? uwagi;

  /// Serializuje żądanie do JSON.
  Map<String, dynamic> toJson() => _$PatchBhpUserIssueRequestToJson(this);
}
