import 'package:json_annotation/json_annotation.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';

part 'get_inwentaryzacja_tree_progress_models.g.dart';

/// Dane odpowiedzi dla `GET /api/v1/inwentaryzacja/{id}/arkusze/tree-progress`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaTreeProgressResponseData {
  /// Tworzy odpowiedz postepu drzewka arkuszy.
  const GetInwentaryzacjaTreeProgressResponseData({
    required this.meta,
    required this.items,
  });

  /// Parsuje odpowiedz z JSON.
  factory GetInwentaryzacjaTreeProgressResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaTreeProgressResponseDataFromJson(json);

  /// Metadane odpowiedzi.
  final GetInwentaryzacjaTreeProgressMeta meta;

  /// Plaska lista wezlow drzewa.
  final List<GetInwentaryzacjaTreeProgressItem> items;

  /// Serializuje odpowiedz do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaTreeProgressResponseDataToJson(this);
}

/// Metadane odpowiedzi postepu drzewka arkuszy.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaTreeProgressMeta {
  /// Tworzy metadane odpowiedzi.
  const GetInwentaryzacjaTreeProgressMeta({
    required this.scope,
    required this.scopeId,
    required this.generatedAt,
    required this.inwentaryzacja,
    required this.firmyScope,
    required this.totals,
  });

  /// Parsuje metadane z JSON.
  factory GetInwentaryzacjaTreeProgressMeta.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaTreeProgressMetaFromJson(json);

  /// Zakres odpowiedzi.
  final String scope;

  /// Id zakresu odpowiedzi.
  final int scopeId;

  /// Znacznik czasu wygenerowania danych.
  final String generatedAt;

  /// Metadane inwentaryzacji.
  final GetInwentaryzacjaSearchArkuszeInventoryMeta inwentaryzacja;

  /// Firmy nalezace do zakresu inwentaryzacji.
  final List<int> firmyScope;

  /// Sumy odpowiedzi.
  final GetInwentaryzacjaTreeProgressTotals totals;

  /// Serializuje metadane do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaTreeProgressMetaToJson(this);
}

/// Sumy zwracane przez backend dla postepu drzewa.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaTreeProgressTotals {
  /// Tworzy sumy odpowiedzi.
  const GetInwentaryzacjaTreeProgressTotals({
    required this.itemsCount,
    this.ambiguousPlacesCount = 0,
  });

  /// Parsuje sumy z JSON.
  factory GetInwentaryzacjaTreeProgressTotals.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaTreeProgressTotalsFromJson(json);

  /// Liczba wezlow zwroconych przez backend.
  final int itemsCount;

  /// Liczba miejsc z niejednoznacznym statusem arkusza.
  @JsonKey(defaultValue: 0)
  final int ambiguousPlacesCount;

  /// Serializuje sumy do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaTreeProgressTotalsToJson(this);
}

/// Wezel drzewa wykonania arkuszy.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaTreeProgressItem {
  /// Tworzy pojedynczy wezel odpowiedzi.
  const GetInwentaryzacjaTreeProgressItem({
    required this.id,
    required this.idMiejsca,
    required this.idFirmy,
    required this.baza,
    required this.productsCount,
    required this.isAmbiguous,
    required this.arkuszExists,
    this.idparent,
    this.nazwa,
    this.lvl,
    this.arkuszId,
    this.arkuszNumer,
  });

  /// Parsuje wezel z JSON.
  factory GetInwentaryzacjaTreeProgressItem.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaTreeProgressItemFromJson(json);

  /// Id rekordu miejsca.
  final int id;

  /// Id logiczne miejsca.
  final int idMiejsca;

  /// Id rodzica.
  final int? idparent;

  /// Id firmy.
  final int idFirmy;

  /// Kod bazy.
  final String baza;

  /// Nazwa miejsca.
  final String? nazwa;

  /// Poziom miejsca.
  final String? lvl;

  /// Liczba produktow przypietych bezposrednio do miejsca.
  final int productsCount;

  /// Czy status arkusza jest niejednoznaczny dla tego miejsca.
  final bool isAmbiguous;

  /// Czy istnieje arkusz dla tego miejsca.
  final bool arkuszExists;

  /// Id istniejacego arkusza.
  final int? arkuszId;

  /// Numer istniejacego arkusza.
  final String? arkuszNumer;

  /// Serializuje wezel do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaTreeProgressItemToJson(this);
}
