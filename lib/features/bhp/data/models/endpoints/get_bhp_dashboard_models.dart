import 'package:json_annotation/json_annotation.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/bhp_employee_name.dart';

part 'get_bhp_dashboard_models.g.dart';

/// Dane odpowiedzi dla `GET /api/v1/bhp/dashboard/issue-alerts`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpDashboardResponseData {
  /// Tworzy model danych dashboardu BHP.
  const GetBhpDashboardResponseData({
    required this.generatedAt,
    required this.monthsAhead,
    required this.overdueCount,
    required this.upcomingCount,
    required this.overdue,
    required this.upcoming,
  });

  /// Tworzy model z JSON.
  factory GetBhpDashboardResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetBhpDashboardResponseDataFromJson(json);

  /// Czas wygenerowania danych.
  final String generatedAt;

  /// Okno alertów w miesiącach.
  final int monthsAhead;

  /// Liczba rekordów po terminie.
  final int overdueCount;

  /// Liczba rekordów zbliżających się do terminu.
  final int upcomingCount;

  /// Lista rekordów po terminie.
  final List<GetBhpIssueAlertItem> overdue;

  /// Lista rekordów zbliżających się do terminu.
  final List<GetBhpIssueAlertItem> upcoming;

  /// Serializuje model do JSON.
  Map<String, dynamic> toJson() => _$GetBhpDashboardResponseDataToJson(this);
}

/// Rekord alertu dashboardu BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpIssueAlertItem {
  /// Tworzy rekord alertu dashboardu BHP.
  const GetBhpIssueAlertItem({
    required this.issueId,
    required this.userId,
    required this.userFullName,
    required this.dataPrzydzialu,
    required this.okresMiesiace,
    required this.okresSource,
    required this.dueDate,
    required this.daysToDue,
    this.stanowiskoId,
    this.stanowiskoNazwa,
    this.kartaWyposazeniaId,
    this.kartaWyposazeniaSymbol,
    this.kartaWyposazeniaNazwa,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpIssueAlertItem.fromJson(Map<String, dynamic> json) =>
      _$GetBhpIssueAlertItemFromJson(json);

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

  /// Symbol wyposażenia.
  final String? kartaWyposazeniaSymbol;

  /// Nazwa wyposażenia.
  final String? kartaWyposazeniaNazwa;

  /// Data przydziału.
  final String dataPrzydzialu;

  /// Okres użytkowania w miesiącach.
  final int okresMiesiace;

  /// Źródło okresu użytkowania.
  final String okresSource;

  /// Data graniczna.
  final String dueDate;

  /// Liczba dni do terminu.
  final int daysToDue;

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpIssueAlertItemToJson(this);
}
