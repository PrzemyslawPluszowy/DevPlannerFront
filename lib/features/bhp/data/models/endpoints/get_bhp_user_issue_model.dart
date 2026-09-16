import 'package:json_annotation/json_annotation.dart';

part 'get_bhp_user_issue_model.g.dart';

/// Rekord wydania wyposażenia BHP dla pracownika.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpUserIssue {
  /// Tworzy rekord wydania wyposażenia BHP.
  const GetBhpUserIssue({
    required this.id,
    required this.pracownikId,
    required this.dataPrzydzialu,
    required this.isActive,
    required this.hasEquivalent,
    required this.canClose,
    required this.canEdit,
    required this.canDelete,
    required this.canRegisterEquivalent,
    required this.canRepeat,
    this.kartaWyposazeniaId,
    this.kartaWyposazeniaSymbol,
    this.kartaWyposazeniaNazwa,
    this.ilosc,
    this.kwotaEkwiwalent,
    this.dataZakonczenia,
    this.uwagi,
    this.dataEkwiwalent,
    this.dataWpisu,
    this.dueDate,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpUserIssue.fromJson(Map<String, dynamic> json) =>
      _$GetBhpUserIssueFromJson(json);

  /// Id wydania.
  final int id;

  /// Id pracownika, do którego przypisano wydanie.
  final int pracownikId;

  /// Id powiązanej karty wyposażenia.
  final int? kartaWyposazeniaId;

  /// Symbol karty wyposażenia.
  final String? kartaWyposazeniaSymbol;

  /// Nazwa karty wyposażenia.
  final String? kartaWyposazeniaNazwa;

  /// Data przydziału/wydania wyposażenia.
  final String dataPrzydzialu;

  /// Data zakończenia/zwrotu wydania.
  final String? dataZakonczenia;

  /// Ilość wydanego wyposażenia (zapisana jako String z bazy danych).
  final String? ilosc;

  /// Uwagi do wydania.
  final String? uwagi;

  /// Data wypłaty ekwiwalentu.
  final String? dataEkwiwalent;

  /// Kwota wypłaconego ekwiwalentu.
  final String? kwotaEkwiwalent;

  /// Data wpisu do systemu.
  final String? dataWpisu;

  /// Termin następnego wydania / ważności przydziału.
  final String? dueDate;

  /// Flaga określająca czy wydanie jest aktywne.
  final bool isActive;

  /// Flaga określająca czy wydanie posiada zarejestrowany ekwiwalent.
  final bool hasEquivalent;

  /// Flaga określająca czy wydanie można zamknąć/zwrócić.
  final bool canClose;

  /// Flaga określająca czy można ręcznie edytować to wydanie.
  final bool canEdit;

  /// Flaga określająca czy można usunąć to wydanie.
  final bool canDelete;

  /// Flaga określająca czy można zarejestrować ekwiwalent dla tego wydania.
  final bool canRegisterEquivalent;

  /// Flaga określająca czy można automatycznie powtórzyć to wydanie.
  final bool canRepeat;

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpUserIssueToJson(this);
}
