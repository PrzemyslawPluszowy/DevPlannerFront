import 'package:json_annotation/json_annotation.dart';

import 'package:ready_next/features/bhp/data/models/endpoints/get_bhp_user_issue_model.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/get_bhp_user_operation_model.dart';

part 'get_bhp_user_detail_models.g.dart';

/// Rekord pozycji standardu stanowiska przypisanej do pracownika.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpUserStandardItem {
  /// Tworzy rekord pozycji standardu stanowiska.
  const GetBhpUserStandardItem({
    required this.id,
    required this.stanowiskoId,
    required this.kartaWyposazeniaId,
    required this.kartaWyposazeniaSymbol,
    required this.kartaWyposazeniaNazwa,
    required this.kartaWyposazeniaJm,
    required this.kartaAktywna,
    required this.kartaOkresUzywalnosci,
    required this.kartaIloscDomyslna,
    required this.kartaEkwiwalent,
    required this.kartaCena,
    required this.okres,
    required this.ilosc,
    required this.uwagi,
    required this.aktywny,
    required this.legacyStatus,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpUserStandardItem.fromJson(Map<String, dynamic> json) =>
      _$GetBhpUserStandardItemFromJson(json);

  /// Id pozycji standardu.
  final int id;

  /// Id stanowiska.
  final int? stanowiskoId;

  /// Id karty wyposażenia.
  final int? kartaWyposazeniaId;

  /// Symbol karty wyposażenia.
  final String? kartaWyposazeniaSymbol;

  /// Nazwa karty wyposażenia.
  final String? kartaWyposazeniaNazwa;

  /// Jednostka miary karty.
  final String? kartaWyposazeniaJm;

  /// Flaga aktywności karty wyposażenia.
  @JsonKey(defaultValue: true)
  final bool kartaAktywna;

  /// Okres użytkowania karty.
  final String? kartaOkresUzywalnosci;

  /// Domyślna ilość karty.
  final String? kartaIloscDomyslna;

  /// Ekwiwalent karty.
  final String? kartaEkwiwalent;

  /// Cena karty.
  final String? kartaCena;

  /// Okres pozycji standardu.
  final int? okres;

  /// Ilość pozycji standardu.
  final String? ilosc;

  /// Uwagi do pozycji standardu.
  final String? uwagi;

  /// Flaga aktywności pozycji standardu.
  final bool aktywny;

  /// Legacy status.
  final int? legacyStatus;

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpUserStandardItemToJson(this);
}

/// Detal pracownika BHP wykorzystywany do wyboru wydania ze standardu.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpUserDetail {
  /// Tworzy detal pracownika BHP.
  const GetBhpUserDetail({
    required this.nrEwidencyjny,
    required this.pesel,
    required this.numerTelefonu,
    required this.readyId,
    required this.imie,
    required this.nazwisko,
    required this.aktywny,
    required this.dataRozpPracy,
    required this.dataZakPracy,
    required this.miejsceZamieszkania,
    required this.wzrost,
    required this.obwodKlatkiPiers,
    required this.obwodPasa,
    required this.obwodGlowy,
    required this.dlStopy,
    required this.uwagi,
    required this.stanowiskoId,
    required this.stanowiskoNazwa,
    required this.stanowiskoLegacyLabel,
    required this.legacyStatus,
    required this.archivedAt,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    required this.stanowisko,
    required this.standardWyposazenia,
    required this.wydaniaAktywne,
    required this.historiaWydan,
    required this.operacje,
    required this.liczbaPozycjiStandardu,
    required this.liczbaAktywnychWydan,
    required this.maAktywneWydania,
    required this.canReceiveIssues,
  });

  /// Tworzy detal z JSON.
  factory GetBhpUserDetail.fromJson(Map<String, dynamic> json) =>
      _$GetBhpUserDetailFromJson(json);

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

  /// Miejsce zamieszkania.
  final String? miejsceZamieszkania;

  /// Wzrost.
  final String? wzrost;

  /// Obwód klatki piersiowej.
  final String? obwodKlatkiPiers;

  /// Obwód pasa.
  final String? obwodPasa;

  /// Obwód głowy.
  final String? obwodGlowy;

  /// Długość stopy.
  final String? dlStopy;

  /// Uwagi.
  final String? uwagi;

  /// Id stanowiska.
  final int? stanowiskoId;

  /// Nazwa stanowiska.
  final String? stanowiskoNazwa;

  /// Legacy label stanowiska.
  final String? stanowiskoLegacyLabel;

  /// Legacy status.
  final int? legacyStatus;

  /// Data archiwizacji.
  final String? archivedAt;

  /// Czy pracownik jest zarchiwizowany.
  final bool isArchived;

  /// Data utworzenia.
  final String? createdAt;

  /// Data aktualizacji.
  final String? updatedAt;

  /// Dane stanowiska powiązanego z pracownikiem.
  final GetBhpUserPosition? stanowisko;

  /// Pozycje standardu przypisane do stanowiska pracownika.
  final List<GetBhpUserStandardItem> standardWyposazenia;

  /// Aktywne wydania pracownika.
  final List<GetBhpUserIssue> wydaniaAktywne;

  /// Pełna historia wydań pracownika.
  final List<GetBhpUserIssue> historiaWydan;

  /// Chronologiczna historia operacji dla pracownika.
  final List<GetBhpUserOperation> operacje;

  /// Liczba pozycji standardu.
  final int liczbaPozycjiStandardu;

  /// Liczba aktywnych wydań.
  final int liczbaAktywnychWydan;

  /// Czy pracownik ma aktywne wydania.
  final bool maAktywneWydania;

  /// Czy pracownik może otrzymywać wydania.
  final bool canReceiveIssues;

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpUserDetailToJson(this);
}

/// Dane stanowiska pracownika w detalu BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpUserPosition {
  /// Tworzy dane stanowiska pracownika.
  const GetBhpUserPosition({
    required this.id,
    required this.nazwa,
    required this.aktywny,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpUserPosition.fromJson(Map<String, dynamic> json) =>
      _$GetBhpUserPositionFromJson(json);

  /// Id stanowiska.
  final int id;

  /// Nazwa stanowiska.
  final String nazwa;

  /// Flaga aktywności.
  final bool aktywny;

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpUserPositionToJson(this);
}
