import 'package:json_annotation/json_annotation.dart';

part 'get_bhp_user_operation_model.g.dart';

/// Rekord operacji wykonanej na wydaniu wyposażenia pracownika BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpUserOperation {
  /// Tworzy rekord operacji.
  const GetBhpUserOperation({
    required this.id,
    required this.issueId,
    required this.pracownikId,
    required this.type,
    required this.typeLabel,
    required this.occurredAt,
    required this.details,
    this.kartaWyposazeniaId,
    this.kartaWyposazeniaSymbol,
    this.kartaWyposazeniaNazwa,
    this.quantity,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpUserOperation.fromJson(Map<String, dynamic> json) =>
      _$GetBhpUserOperationFromJson(json);

  /// Stabilny identyfikator operacji.
  final String id;

  /// Id wydania, którego dotyczy operacja.
  final int issueId;

  /// Id pracownika.
  final int pracownikId;

  /// Typ operacji.
  final String type;

  /// Czytelna etykieta typu operacji.
  final String typeLabel;

  /// Data operacji w formacie `yyyy-MM-dd`.
  final String? occurredAt;

  /// Id karty wyposażenia.
  final int? kartaWyposazeniaId;

  /// Symbol karty wyposażenia.
  final String? kartaWyposazeniaSymbol;

  /// Nazwa karty wyposażenia.
  final String? kartaWyposazeniaNazwa;

  /// Ilość powiązana z operacją.
  final String? quantity;

  /// Czytelny opis operacji.
  final String details;

  /// Zwraca datę operacji jako `DateTime`, jeśli zapis jest poprawny.
  DateTime? get occurredAtDate => DateTime.tryParse(occurredAt ?? '');

  /// Buduje czytelną nazwę wyposażenia.
  String get equipmentLabel {
    final symbol = kartaWyposazeniaSymbol?.trim();
    final name = kartaWyposazeniaNazwa?.trim();

    if ((symbol ?? '').isNotEmpty && (name ?? '').isNotEmpty) {
      return '$symbol - $name';
    }

    return symbol?.isNotEmpty == true ? symbol! : (name ?? '—');
  }

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpUserOperationToJson(this);
}
