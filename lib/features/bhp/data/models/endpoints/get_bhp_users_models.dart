import 'package:json_annotation/json_annotation.dart';

part 'get_bhp_users_models.g.dart';

/// Rekord listy pracowników BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpUserListItem {
  /// Tworzy rekord pracownika BHP.
  const GetBhpUserListItem({
    required this.id,
    required this.aktywny,
    required this.isArchived,
    this.nrEwidencyjny,
    this.pesel,
    this.numerTelefonu,
    this.readyId,
    this.imie,
    this.nazwisko,
    this.dataRozpPracy,
    this.dataZakPracy,
    this.stanowiskoId,
    this.stanowiskoNazwa,
    this.nearestDueDate,
    this.daysUntilDue,
    this.daysOverdue,
    this.overdueCount = 0,
    this.upcomingCount = 0,
    this.nearestOverdueDays,
    this.nearestUpcomingDays,
    this.archivedAt,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpUserListItem.fromJson(Map<String, dynamic> json) =>
      _$GetBhpUserListItemFromJson(json);

  /// Id pracownika.
  final int id;

  /// Numer ewidencyjny.
  final String? nrEwidencyjny;

  /// Numer PESEL.
  final String? pesel;

  /// Numer telefonu.
  final String? numerTelefonu;

  /// Id użytkownika READY.
  final int? readyId;

  /// Imię.
  final String? imie;

  /// Nazwisko.
  final String? nazwisko;

  /// Flaga aktywności.
  final bool aktywny;

  /// Data rozpoczęcia pracy.
  final String? dataRozpPracy;

  /// Data zakończenia pracy.
  final String? dataZakPracy;

  /// Id stanowiska.
  final int? stanowiskoId;

  /// Nazwa stanowiska.
  final String? stanowiskoNazwa;

  /// Najbliższy termin aktywnego wyposażenia.
  final String? nearestDueDate;

  /// Liczba dni do najbliższego terminu.
  final int? daysUntilDue;

  /// Liczba dni po najbliższym terminie.
  final int? daysOverdue;

  /// Liczba aktywnych wydań po terminie.
  final int overdueCount;

  /// Liczba aktywnych wydań z terminem w ciągu 30 dni.
  final int upcomingCount;

  /// Najbliższa liczba dni po terminie.
  final int? nearestOverdueDays;

  /// Najbliższa liczba dni do terminu.
  final int? nearestUpcomingDays;

  /// Data archiwizacji.
  final String? archivedAt;

  /// Flaga archiwizacji.
  final bool isArchived;

  /// Zwraca nazwisko i imię w kolejności używanej na listach pracowników.
  String get fullName {
    final parts = [nazwisko, imie]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
    return parts.isEmpty ? 'Brak imienia i nazwiska' : parts.join(' ');
  }

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpUserListItemToJson(this);
}
