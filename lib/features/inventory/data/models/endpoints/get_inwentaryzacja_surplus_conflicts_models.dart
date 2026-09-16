import 'package:json_annotation/json_annotation.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';

part 'get_inwentaryzacja_surplus_conflicts_models.g.dart';

/// Dane odpowiedzi dla `GET /api/v1/inwentaryzacja/{id}/surplus-conflicts`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSurplusConflictsResponseData {
  /// Tworzy odpowiedz listy konfliktow nadwyzek.
  const GetInwentaryzacjaSurplusConflictsResponseData({
    required this.meta,
    required this.items,
  });

  /// Parsuje odpowiedz z JSON.
  factory GetInwentaryzacjaSurplusConflictsResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSurplusConflictsResponseDataFromJson(json);

  /// Metadane odpowiedzi.
  final GetInwentaryzacjaSurplusConflictsMeta meta;

  /// Lista niesparowanych nadwyzek.
  final List<GetInwentaryzacjaSurplusConflictItem> items;

  /// Serializuje odpowiedz do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSurplusConflictsResponseDataToJson(this);
}

/// Metadane odpowiedzi konfliktow nadwyzek.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSurplusConflictsMeta {
  /// Tworzy metadane odpowiedzi.
  const GetInwentaryzacjaSurplusConflictsMeta({
    required this.scope,
    required this.scopeId,
    required this.generatedAt,
    required this.inwentaryzacja,
    required this.totals,
  });

  /// Parsuje metadane z JSON.
  factory GetInwentaryzacjaSurplusConflictsMeta.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSurplusConflictsMetaFromJson(json);

  /// Zakres odpowiedzi.
  final String scope;

  /// Id zakresu odpowiedzi.
  final int scopeId;

  /// Znacznik czasu wygenerowania danych.
  final String generatedAt;

  /// Metadane inwentaryzacji.
  final GetInwentaryzacjaSearchArkuszeInventoryMeta inwentaryzacja;

  /// Sumy policzone dla wyniku.
  final GetInwentaryzacjaSurplusConflictsTotals totals;

  /// Serializuje metadane do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSurplusConflictsMetaToJson(this);
}

/// Sumy zwracane przez backend dla konfliktow nadwyzek.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSurplusConflictsTotals {
  /// Tworzy sumy odpowiedzi.
  const GetInwentaryzacjaSurplusConflictsTotals({
    required this.itemsCount,
  });

  /// Parsuje sumy z JSON.
  factory GetInwentaryzacjaSurplusConflictsTotals.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSurplusConflictsTotalsFromJson(json);

  /// Liczba konfliktow nadwyzek.
  final int itemsCount;

  /// Serializuje sumy do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSurplusConflictsTotalsToJson(this);
}

/// Pojedyncza niesparowana nadwyzka zwrocona przez backend.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSurplusConflictItem {
  /// Tworzy element listy konfliktow nadwyzek.
  const GetInwentaryzacjaSurplusConflictItem({
    required this.elementId,
    this.arkuszId,
    this.arkuszNumer,
    this.arkuszMiejsce,
    this.firma,
    this.nrewid,
    this.kodKreskowy,
    this.nazwa,
    this.osoba,
    this.stanInwent,
    this.statusSpisu,
    this.nadwyzka,
    this.matchBasis,
  });

  /// Parsuje element z JSON.
  factory GetInwentaryzacjaSurplusConflictItem.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSurplusConflictItemFromJson(json);

  /// Id elementu.
  final int elementId;

  /// Id arkusza, jesli backend je zwrocil.
  final int? arkuszId;

  /// Numer arkusza.
  final String? arkuszNumer;

  /// Miejsce arkusza.
  final String? arkuszMiejsce;

  /// Id firmy.
  final int? firma;

  /// Numer ewidencyjny.
  final String? nrewid;

  /// Kod kreskowy.
  final int? kodKreskowy;

  /// Nazwa srodka trwalego.
  final String? nazwa;

  /// Osoba odpowiedzialna.
  final String? osoba;

  /// Stan inwentaryzacyjny.
  final String? stanInwent;

  /// Status spisu.
  final String? statusSpisu;

  /// Flaga nadwyzki.
  final bool? nadwyzka;

  /// Podstawa szukania pary: `nrewid` albo `kod_kreskowy`.
  final String? matchBasis;

  /// Serializuje element do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSurplusConflictItemToJson(this);
}
