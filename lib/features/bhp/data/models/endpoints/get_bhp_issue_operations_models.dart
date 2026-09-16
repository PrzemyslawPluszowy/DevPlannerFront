import 'package:json_annotation/json_annotation.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/bhp_employee_name.dart';

part 'get_bhp_issue_operations_models.g.dart';

/// Dane odpowiedzi dla `GET /api/v1/bhp/dashboard/issue-operations`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpIssueOperationsResponseData {
  /// Tworzy odpowiedź listy operacji BHP.
  const GetBhpIssueOperationsResponseData({
    required this.generatedAt,
    required this.year,
    required this.count,
    required this.items,
  });

  /// Tworzy odpowiedź z JSON.
  factory GetBhpIssueOperationsResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$GetBhpIssueOperationsResponseDataFromJson(json);

  /// Czas wygenerowania danych.
  final String generatedAt;

  /// Rok, dla którego pobrano feed.
  final int year;

  /// Liczba operacji.
  final int count;

  /// Lista operacji.
  final List<GetBhpIssueOperationItem> items;

  /// Serializuje odpowiedź do JSON.
  Map<String, dynamic> toJson() =>
      _$GetBhpIssueOperationsResponseDataToJson(this);
}

/// Pojedyncza operacja BHP w globalnym feedzie.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpIssueOperationItem {
  /// Tworzy rekord operacji BHP.
  const GetBhpIssueOperationItem({
    required this.id,
    required this.issueId,
    required this.userId,
    required this.userFullName,
    required this.type,
    required this.typeLabel,
    required this.occurredAt,
    required this.details,
    this.equivalentAmount,
    this.stanowiskoId,
    this.stanowiskoNazwa,
    this.kartaWyposazeniaId,
    this.kartaWyposazeniaSymbol,
    this.kartaWyposazeniaNazwa,
    this.quantity,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpIssueOperationItem.fromJson(Map<String, dynamic> json) =>
      _$GetBhpIssueOperationItemFromJson(json);

  /// Stabilny identyfikator operacji.
  final String id;

  /// Id wydania.
  final int issueId;

  /// Id pracownika.
  final int userId;

  /// Imię i nazwisko pracownika.
  final String userFullName;

  /// Nazwisko i imię pracownika do wyświetlenia w UI.
  String get formattedUserFullName =>
      formatBhpEmployeeNameLastFirst(userFullName);

  /// Id stanowiska.
  final int? stanowiskoId;

  /// Nazwa stanowiska.
  final String? stanowiskoNazwa;

  /// Id karty wyposażenia.
  final int? kartaWyposazeniaId;

  /// Symbol karty wyposażenia.
  final String? kartaWyposazeniaSymbol;

  /// Nazwa karty wyposażenia.
  final String? kartaWyposazeniaNazwa;

  /// Typ operacji.
  final String type;

  /// Czytelna etykieta typu operacji.
  final String typeLabel;

  /// Data operacji w formacie `yyyy-MM-dd`.
  final String occurredAt;

  /// Ilość związana z operacją.
  final String? quantity;

  /// Kwota ekwiwalentu związana z operacją.
  final String? equivalentAmount;

  /// Czytelny opis operacji.
  final String details;

  /// Zwraca datę operacji jako `DateTime`.
  DateTime? get occurredAtDate => DateTime.tryParse(occurredAt);

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
  Map<String, dynamic> toJson() => _$GetBhpIssueOperationItemToJson(this);
}
