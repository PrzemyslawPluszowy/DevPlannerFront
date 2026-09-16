import 'package:json_annotation/json_annotation.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';

part 'get_inwentaryzacja_search_arkusze_models.g.dart';

/// Pole sortowania dla wyszukiwarki produktow w arkuszach inwentaryzacji.
enum GetInwentaryzacjaSearchArkuszeSortBy {
  nrewid('nrewid'),
  nazwa('nazwa'),
  matchesCount('matches_count');

  const GetInwentaryzacjaSearchArkuszeSortBy(this.apiValue);

  /// Wartosc query zgodna z backendem.
  final String apiValue;
}

/// Kierunek sortowania dla wyszukiwarki produktow w arkuszach.
enum GetInwentaryzacjaSearchArkuszeSortDirection {
  asc('asc'),
  desc('desc');

  const GetInwentaryzacjaSearchArkuszeSortDirection(this.apiValue);

  /// Wartosc query zgodna z backendem.
  final String apiValue;
}

/// Query dla `GET /api/v1/inwentaryzacja/{id}/search/arkusze`.
class GetInwentaryzacjaSearchArkuszeQuery {
  /// Tworzy query wyszukiwarki arkuszy.
  const GetInwentaryzacjaSearchArkuszeQuery({
    required this.q,
    this.sortBy = GetInwentaryzacjaSearchArkuszeSortBy.nrewid,
    this.sortDir = GetInwentaryzacjaSearchArkuszeSortDirection.asc,
  });

  /// Fraza wyszukiwania po produkcie lub arkuszu.
  final String q;

  /// Pole sortowania grup wynikowych.
  final GetInwentaryzacjaSearchArkuszeSortBy sortBy;

  /// Kierunek sortowania grup wynikowych.
  final GetInwentaryzacjaSearchArkuszeSortDirection sortDir;
}

/// Status UI grup i trafien zwracany przez backend wyszukiwarki arkuszy.
enum SearchArkuszeUiStatus {
  brak('brak'),
  potwierdzony('potwierdzony'),
  niezgodnosc('niezgodnosc'),
  nadwyzka('nadwyzka'),
  nowy('nowy'),
  znalezionyWInnejFirmie('znaleziony_w_innej_firmie'),
  niejednoznacznyKod('niejednoznaczny_kod'),
  sprzedanyWTrakcie('sprzedany_w_trakcie'),
  zakupionyWTrakcie('zakupiony_w_trakcie'),
  doLikwidacji('do_likwidacji');

  const SearchArkuszeUiStatus(this.apiValue);

  /// Wartosc surowa zgodna z backendem.
  final String apiValue;

  /// Parsuje status z odpowiedzi API.
  static SearchArkuszeUiStatus? fromApi(String? value) {
    for (final status in SearchArkuszeUiStatus.values) {
      if (status.apiValue == value) {
        return status;
      }
    }
    return null;
  }
}

/// Konwerter JSON dla [SearchArkuszeUiStatus].
class SearchArkuszeUiStatusConverter
    implements JsonConverter<SearchArkuszeUiStatus?, String?> {
  /// Tworzy konwerter statusu UI wyszukiwarki arkuszy.
  const SearchArkuszeUiStatusConverter();

  @override
  SearchArkuszeUiStatus? fromJson(String? json) =>
      SearchArkuszeUiStatus.fromApi(json);

  @override
  String? toJson(SearchArkuszeUiStatus? object) => object?.apiValue;
}

/// Odpowiedz danych dla wyszukiwarki produktow w arkuszach inwentaryzacji.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSearchArkuszeResponseData {
  /// Tworzy odpowiedz wyszukiwarki arkuszy.
  const GetInwentaryzacjaSearchArkuszeResponseData({
    required this.meta,
    required this.items,
  });

  /// Parsuje odpowiedz wyszukiwarki z JSON.
  factory GetInwentaryzacjaSearchArkuszeResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSearchArkuszeResponseDataFromJson(json);

  /// Metadane odpowiedzi.
  final GetInwentaryzacjaSearchArkuszeMeta meta;

  /// Grupy trafien pogrupowane po produkcie.
  final List<GetInwentaryzacjaSearchArkuszeGroup> items;

  /// Serializuje odpowiedz do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSearchArkuszeResponseDataToJson(this);
}

/// Metadane wyszukiwarki produktow w arkuszach.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSearchArkuszeMeta {
  /// Tworzy metadane odpowiedzi wyszukiwarki arkuszy.
  const GetInwentaryzacjaSearchArkuszeMeta({
    required this.scope,
    required this.scopeId,
    required this.generatedAt,
    required this.inwentaryzacja,
    required this.filters,
    required this.totals,
  });

  /// Parsuje metadane z JSON.
  factory GetInwentaryzacjaSearchArkuszeMeta.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSearchArkuszeMetaFromJson(json);

  /// Zakres odpowiedzi.
  final String scope;

  /// Id zakresu odpowiedzi.
  final int scopeId;

  /// Znacznik czasu wygenerowania danych.
  final String generatedAt;

  /// Metadane inwentaryzacji.
  final GetInwentaryzacjaSearchArkuszeInventoryMeta inwentaryzacja;

  /// Filtry uzyte po stronie backendu.
  final GetInwentaryzacjaSearchArkuszeFilters filters;

  /// Sumy policzone dla wyniku.
  final GetInwentaryzacjaSearchArkuszeTotals totals;

  /// Serializuje metadane do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSearchArkuszeMetaToJson(this);
}

/// Metadane inwentaryzacji zwracane przez wyszukiwarke arkuszy.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSearchArkuszeInventoryMeta {
  /// Tworzy metadane inwentaryzacji.
  const GetInwentaryzacjaSearchArkuszeInventoryMeta({
    required this.id,
    this.numer,
    this.status,
  });

  /// Parsuje metadane inwentaryzacji z JSON.
  factory GetInwentaryzacjaSearchArkuszeInventoryMeta.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSearchArkuszeInventoryMetaFromJson(json);

  /// Id inwentaryzacji.
  final int id;

  /// Numer inwentaryzacji.
  final String? numer;

  /// Status backendowy inwentaryzacji.
  final int? status;

  /// Serializuje metadane do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSearchArkuszeInventoryMetaToJson(this);
}

/// Zestaw filtrow przekazanych do wyszukiwarki arkuszy.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSearchArkuszeFilters {
  /// Tworzy filtry odpowiedzi wyszukiwarki.
  const GetInwentaryzacjaSearchArkuszeFilters({
    required this.q,
    required this.sortBy,
    required this.sortDir,
  });

  /// Parsuje filtry z JSON.
  factory GetInwentaryzacjaSearchArkuszeFilters.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSearchArkuszeFiltersFromJson(json);

  /// Fraza wyszukiwania zwrocona przez backend.
  final String q;

  /// Uzyte pole sortowania.
  final String sortBy;

  /// Uzyty kierunek sortowania.
  final String sortDir;

  /// Serializuje filtry do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSearchArkuszeFiltersToJson(this);
}

/// Sumy zwracane przez backend dla wyszukiwarki arkuszy.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSearchArkuszeTotals {
  /// Tworzy sumy wyniku wyszukiwarki.
  const GetInwentaryzacjaSearchArkuszeTotals({
    required this.groupsCount,
    required this.matchesCount,
  });

  /// Parsuje sumy z JSON.
  factory GetInwentaryzacjaSearchArkuszeTotals.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSearchArkuszeTotalsFromJson(json);

  /// Liczba grup wynikowych.
  final int groupsCount;

  /// Liczba trafien lacznie.
  final int matchesCount;

  /// Serializuje sumy do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSearchArkuszeTotalsToJson(this);
}

/// Grupa trafien pogrupowana po produkcie.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSearchArkuszeGroup {
  /// Tworzy grupe trafien wyszukiwarki arkuszy.
  const GetInwentaryzacjaSearchArkuszeGroup({
    required this.identityKey,
    required this.matchesCount,
    required this.hasMultipleMatches,
    required this.hasMixedStatuses,
    required this.uiStatuses,
    required this.matches,
    this.firma,
    this.nrewid,
    this.kodKreskowy,
    this.nazwa,
    this.osoba,
  });

  /// Parsuje grupe trafien z JSON.
  factory GetInwentaryzacjaSearchArkuszeGroup.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSearchArkuszeGroupFromJson(json);

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

  /// Liczba trafien w grupie.
  final int matchesCount;

  /// Czy grupa zawiera wiecej niz jedno trafienie.
  final bool hasMultipleMatches;

  /// Czy grupa laczy rozne statusy UI.
  final bool hasMixedStatuses;

  /// Zestaw statusow UI widocznych w grupie.
  @SearchArkuszeUiStatusConverter()
  final List<SearchArkuszeUiStatus?> uiStatuses;

  /// Trafienia nalezace do grupy.
  final List<GetInwentaryzacjaSearchArkuszeMatch> matches;

  /// Serializuje grupe do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSearchArkuszeGroupToJson(this);
}

/// Pojedyncze trafienie w wynikach wyszukiwarki arkuszy.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaSearchArkuszeMatch {
  /// Tworzy pojedyncze trafienie wyszukiwarki arkuszy.
  const GetInwentaryzacjaSearchArkuszeMatch({
    required this.elementId,
    required this.uiStatus,
    this.arkuszId,
    this.arkuszNumer,
    this.arkuszMiejsce,
    this.firma,
    this.nrewid,
    this.nazwa,
    this.osoba,
    this.kodKreskowy,
    this.stanInwent,
    this.statusSpisu,
    this.likwidacja,
    this.nadwyzka,
    this.foundInArkuszNumer,
    this.foundInMiejsce,
  });

  /// Parsuje trafienie z JSON.
  factory GetInwentaryzacjaSearchArkuszeMatch.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaSearchArkuszeMatchFromJson(json);

  /// Id elementu arkusza.
  final int elementId;

  /// Id arkusza zawierajacego element.
  final int? arkuszId;

  /// Numer arkusza zawierajacego element.
  final String? arkuszNumer;

  /// Miejsce arkusza zawierajacego element.
  final String? arkuszMiejsce;

  /// Id firmy elementu.
  final int? firma;

  /// Numer ewidencyjny elementu.
  final String? nrewid;

  /// Nazwa elementu.
  final String? nazwa;

  /// Osoba odpowiedzialna za element.
  final String? osoba;

  /// Kod kreskowy elementu.
  final int? kodKreskowy;

  /// Status inwentaryzacyjny elementu zgodny z `stan_inwent`.
  @JsonKey(
    name: 'stan_inwent',
    fromJson: _arkuszElementInwentStatusFromJson,
    toJson: _arkuszElementInwentStatusToJson,
  )
  final ArkuszElementInwentStatus? stanInwent;

  /// Status spisu zgodny z `status_spisu`.
  @JsonKey(name: 'status_spisu')
  @ArkuszElementStatusSpisuConverter()
  final ArkuszElementStatusSpisu? statusSpisu;

  /// Flaga likwidacji.
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool? likwidacja;

  /// Flaga nadwyzki.
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool? nadwyzka;

  /// Numer arkusza znalezionego przez backend przy konflikcie.
  final String? foundInArkuszNumer;

  /// Miejsce znalezione przez backend przy konflikcie.
  final String? foundInMiejsce;

  /// Status UI pojedynczego trafienia.
  @SearchArkuszeUiStatusConverter()
  final SearchArkuszeUiStatus? uiStatus;

  /// Serializuje trafienie do JSON.
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaSearchArkuszeMatchToJson(this);
}

ArkuszElementInwentStatus? _arkuszElementInwentStatusFromJson(Object? value) =>
    ArkuszElementInwentStatus.fromApi(value);

String? _arkuszElementInwentStatusToJson(ArkuszElementInwentStatus? value) =>
    value?.apiValue;

bool? _boolFromJson(Object? value) => switch (value) {
  null => null,
  final bool boolValue => boolValue,
  final num numValue => numValue != 0,
  final String stringValue => switch (stringValue.trim().toLowerCase()) {
    '1' || 'true' || 't' || 'yes' || 'y' => true,
    '0' || 'false' || 'f' || 'no' || 'n' => false,
    _ => null,
  },
  _ => null,
};

Object? _boolToJson(bool? value) => value;
