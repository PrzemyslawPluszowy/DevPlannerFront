import 'package:json_annotation/json_annotation.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';

part 'get_inwentaryzacja_presence_conflicts_models.g.dart';

/// Dane odpowiedzi dla `GET /api/v1/inwentaryzacja/{id}/presence-conflicts`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaPresenceConflictsResponseData {
  /// Tworzy odpowiedz listy konfliktow obecnosci.
  const GetInwentaryzacjaPresenceConflictsResponseData({
    required this.meta,
    required this.items,
  });

  /// Parsuje odpowiedz z JSON.
  factory GetInwentaryzacjaPresenceConflictsResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaPresenceConflictsResponseDataFromJson(json);

  /// Metadane odpowiedzi.
  final GetInwentaryzacjaPresenceConflictsMeta meta;

  /// Lista konfliktow obecnosci.
  final List<GetInwentaryzacjaPresenceConflictsGroup> items;

  /// Serializuje odpowiedz do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaPresenceConflictsResponseDataToJson(this);
}

/// Metadane odpowiedzi konfliktow obecnosci.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaPresenceConflictsMeta {
  /// Tworzy metadane odpowiedzi.
  const GetInwentaryzacjaPresenceConflictsMeta({
    required this.scope,
    required this.scopeId,
    required this.generatedAt,
    required this.inwentaryzacja,
    required this.totals,
  });

  /// Parsuje metadane z JSON.
  factory GetInwentaryzacjaPresenceConflictsMeta.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaPresenceConflictsMetaFromJson(json);

  /// Zakres odpowiedzi.
  final String scope;

  /// Id zakresu odpowiedzi.
  final int scopeId;

  /// Znacznik czasu wygenerowania danych.
  final String generatedAt;

  /// Metadane inwentaryzacji.
  final GetInwentaryzacjaSearchArkuszeInventoryMeta inwentaryzacja;

  /// Sumy policzone dla wyniku.
  final GetInwentaryzacjaPresenceConflictsTotals totals;

  /// Serializuje metadane do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaPresenceConflictsMetaToJson(this);
}

/// Sumy zwracane przez backend dla konfliktow obecnosci.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaPresenceConflictsTotals {
  /// Tworzy sumy odpowiedzi.
  const GetInwentaryzacjaPresenceConflictsTotals({
    required this.itemsCount,
  });

  /// Parsuje sumy z JSON.
  factory GetInwentaryzacjaPresenceConflictsTotals.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaPresenceConflictsTotalsFromJson(json);

  /// Liczba konfliktow obecnosci.
  final int itemsCount;

  /// Serializuje sumy do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaPresenceConflictsTotalsToJson(this);
}

/// Grupa konfliktu obecnosci pogrupowana po produkcie.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaPresenceConflictsGroup {
  /// Tworzy grupe konfliktu obecnosci.
  const GetInwentaryzacjaPresenceConflictsGroup({
    required this.identityKey,
    required this.presenceCount,
    required this.arkuszeCount,
    required this.matches,
    this.firma,
    this.nrewid,
    this.kodKreskowy,
    this.nazwa,
    this.osoba,
  });

  /// Parsuje grupe z JSON.
  factory GetInwentaryzacjaPresenceConflictsGroup.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaPresenceConflictsGroupFromJson(json);

  /// Stabilny klucz tozsamosci grupy.
  final String identityKey;

  /// Id firmy produktu.
  final int? firma;

  /// Numer ewidencyjny produktu.
  final String? nrewid;

  /// Kod kreskowy produktu.
  final int? kodKreskowy;

  /// Nazwa produktu.
  final String? nazwa;

  /// Osoba odpowiedzialna.
  final String? osoba;

  /// Liczba wystapien nie-brak.
  final int presenceCount;

  /// Liczba roznych arkuszy w konflikcie.
  final int arkuszeCount;

  /// Konfliktowe trafienia nalezace do grupy.
  final List<GetInwentaryzacjaSearchArkuszeMatch> matches;

  /// Serializuje grupe do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaPresenceConflictsGroupToJson(this);
}
