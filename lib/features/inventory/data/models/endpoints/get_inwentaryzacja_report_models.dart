/// Typ raportu inwentaryzacji zgodny z backendowym `reportType`.
enum InwentaryzacjaReportType {
  ogolnyStanSpisu('ogolny_stan_spisu'),
  elementyDoLikwidacji('elementy_do_likwidacji'),
  braki('braki'),
  brakiNieskompensowane('braki_nieskompensowane'),
  brakiZeZmianami('braki_ze_zmianami'),
  brakiSkompensowane('braki_skompensowane'),
  kompensaty('kompensaty'),
  nadwyzkiNieskompensowane('nadwyzki_nieskompensowane'),
  znalezioneWInnejFirmie('znalezione_w_innej_firmie'),
  zakupioneWTrakcie('zakupione_w_trakcie'),
  nadwyzki('nadwyzki'),
  sprzedaneWTrakcie('sprzedane_w_trakcie'),
  nowe('nowe');

  const InwentaryzacjaReportType(this.apiValue);

  /// Wartość używana w ścieżce endpointu.
  final String apiValue;

  /// Tworzy enum z wartości backendowej.
  static InwentaryzacjaReportType? fromApi(String? value) {
    for (final type in InwentaryzacjaReportType.values) {
      if (type.apiValue == value) {
        return type;
      }
    }
    return null;
  }
}

/// Pole sortowania raportu inwentaryzacji.
enum GetInwentaryzacjaReportSortBy {
  id('id'),
  nrewid('nrewid'),
  miejsce('miejsce'),
  statusSpisu('status_spisu'),
  stanInwent('stan_inwent');

  const GetInwentaryzacjaReportSortBy(this.apiValue);

  /// Wartość query zgodna z backendem.
  final String apiValue;
}

/// Kierunek sortowania raportu inwentaryzacji.
enum GetInwentaryzacjaReportSortDirection {
  asc('asc'),
  desc('desc');

  const GetInwentaryzacjaReportSortDirection(this.apiValue);

  /// Wartość query zgodna z backendem.
  final String apiValue;
}

/// Query dla `GET /api/v1/inwentaryzacja/{id}/raporty/{reportType}`.
class GetInwentaryzacjaReportQuery {
  /// Tworzy query raportu inwentaryzacji.
  const GetInwentaryzacjaReportQuery({
    required this.reportType,
    this.includeSummary = true,
    this.sortBy,
    this.sortDir,
  });

  /// Typ raportu.
  final InwentaryzacjaReportType reportType;

  /// Czy backend ma doliczyć sekcję `totals`.
  final bool includeSummary;

  /// Pole sortowania raportu.
  final GetInwentaryzacjaReportSortBy? sortBy;

  /// Kierunek sortowania raportu.
  final GetInwentaryzacjaReportSortDirection? sortDir;
}

/// Dane dla raportu inwentaryzacji.
class GetInwentaryzacjaReportResponseData {
  /// Tworzy dane raportu inwentaryzacji.
  const GetInwentaryzacjaReportResponseData({
    required this.meta,
    required this.elements,
  });

  /// Parsuje dane raportu z JSON.
  factory GetInwentaryzacjaReportResponseData.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetInwentaryzacjaReportResponseData(
      meta: GetInwentaryzacjaReportMeta.fromJson(
        json['meta'] as Map<String, dynamic>? ?? const {},
      ),
      elements: (json['elements'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(GetInwentaryzacjaReportElementItem.fromJson)
          .toList(growable: false),
    );
  }

  /// Metadane raportu.
  final GetInwentaryzacjaReportMeta meta;

  /// Lista elementów raportu.
  final List<GetInwentaryzacjaReportElementItem> elements;
}

/// Zwraca elementy raportu w postaci właściwej do prezentacji użytkownikowi.
///
/// Backend raportu `kompensaty` zwraca obie strony tej samej pary: brak oraz
/// nadwyżkę. UI i PDF pokazują parę jako jeden wiersz, żeby nie wyglądała jak
/// zdublowany środek trwały.
List<GetInwentaryzacjaReportElementItem> displayElementsForInventoryReport({
  required InwentaryzacjaReportType reportType,
  required List<GetInwentaryzacjaReportElementItem> elements,
}) {
  if (reportType != InwentaryzacjaReportType.kompensaty) {
    return elements;
  }

  final result = <GetInwentaryzacjaReportElementItem>[];
  final indexByPairKey = <String, int>{};

  for (final element in elements) {
    final key = _compensationPairKey(element);
    final existingIndex = indexByPairKey[key];

    if (existingIndex == null) {
      indexByPairKey[key] = result.length;
      result.add(element);
      continue;
    }

    if (_isCompensationMissingSide(element) &&
        !_isCompensationMissingSide(result[existingIndex])) {
      result[existingIndex] = element;
    }
  }

  return result;
}

String _compensationPairKey(GetInwentaryzacjaReportElementItem element) {
  final compensation = element.compensation;
  final brakId = compensation?.brakElementId;
  final nadwyzkaId = compensation?.nadwyzkaElementId;

  if (brakId != null && nadwyzkaId != null) {
    return 'compensation:$brakId:$nadwyzkaId';
  }

  return 'element:${element.elementId}';
}

bool _isCompensationMissingSide(GetInwentaryzacjaReportElementItem element) {
  return element.compensation?.brakElementId == element.elementId;
}

/// Metadane raportu inwentaryzacji.
class GetInwentaryzacjaReportMeta {
  /// Tworzy metadane raportu.
  const GetInwentaryzacjaReportMeta({
    required this.scope,
    required this.scopeId,
    required this.reportType,
    this.generatedAt,
    this.inwentaryzacja,
    this.filters,
    this.totals,
  });

  /// Parsuje metadane raportu z JSON.
  factory GetInwentaryzacjaReportMeta.fromJson(Map<String, dynamic> json) {
    return GetInwentaryzacjaReportMeta(
      scope: json['scope'] as String? ?? '',
      scopeId: (json['scope_id'] as num?)?.toInt() ?? 0,
      reportType:
          InwentaryzacjaReportType.fromApi(json['report_type'] as String?) ??
          InwentaryzacjaReportType.ogolnyStanSpisu,
      generatedAt: json['generated_at'] as String?,
      inwentaryzacja: switch (json['inwentaryzacja']) {
        final Map<String, dynamic> value =>
          GetInwentaryzacjaReportInventoryMeta.fromJson(value),
        _ => null,
      },
      filters: switch (json['filters']) {
        final Map<String, dynamic> value =>
          GetInwentaryzacjaReportFilters.fromJson(value),
        _ => null,
      },
      totals: switch (json['totals']) {
        final Map<String, dynamic> value =>
          GetInwentaryzacjaReportTotals.fromJson(value),
        _ => null,
      },
    );
  }

  /// Zakres raportu.
  final String scope;

  /// Id zakresu raportu.
  final int scopeId;

  /// Typ raportu.
  final InwentaryzacjaReportType reportType;

  /// Znacznik czasu wygenerowania raportu.
  final String? generatedAt;

  /// Metadane inwentaryzacji.
  final GetInwentaryzacjaReportInventoryMeta? inwentaryzacja;

  /// Filtry użyte przez backend.
  final GetInwentaryzacjaReportFilters? filters;

  /// Sumy raportu, jeśli backend je dołączył.
  final GetInwentaryzacjaReportTotals? totals;
}

/// Metadane inwentaryzacji zwrócone w raporcie.
class GetInwentaryzacjaReportInventoryMeta {
  /// Tworzy metadane inwentaryzacji.
  const GetInwentaryzacjaReportInventoryMeta({
    required this.id,
    this.numer,
    this.status,
  });

  /// Parsuje metadane inwentaryzacji z JSON.
  factory GetInwentaryzacjaReportInventoryMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetInwentaryzacjaReportInventoryMeta(
      id: (json['id'] as num?)?.toInt() ?? 0,
      numer: json['numer'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );
  }

  /// Id inwentaryzacji.
  final int id;

  /// Numer inwentaryzacji.
  final String? numer;

  /// Surowy status backendowy.
  final int? status;
}

/// Zestaw filtrów raportu zwrócony w `meta`.
class GetInwentaryzacjaReportFilters {
  /// Tworzy filtry raportu.
  const GetInwentaryzacjaReportFilters({
    this.includeSummary,
    this.sortBy,
    this.sortDir,
  });

  /// Parsuje filtry raportu z JSON.
  factory GetInwentaryzacjaReportFilters.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetInwentaryzacjaReportFilters(
      includeSummary: json['include_summary'] as bool?,
      sortBy: json['sort_by'] as String?,
      sortDir: json['sort_dir'] as String?,
    );
  }

  /// Czy backend dołączył podsumowanie.
  final bool? includeSummary;

  /// Pole sortowania.
  final String? sortBy;

  /// Kierunek sortowania.
  final String? sortDir;
}

/// Suma wartości raportu.
class GetInwentaryzacjaReportTotals {
  /// Tworzy sumy raportu.
  const GetInwentaryzacjaReportTotals({
    this.count,
    this.wartoscPSum,
    this.wartoscASum,
  });

  /// Parsuje sumy raportu z JSON.
  factory GetInwentaryzacjaReportTotals.fromJson(Map<String, dynamic> json) {
    return GetInwentaryzacjaReportTotals(
      count: (json['count'] as num?)?.toInt(),
      wartoscPSum: json['wartosc_p_sum'] as String?,
      wartoscASum: json['wartosc_a_sum'] as String?,
    );
  }

  /// Liczba elementów raportu.
  final int? count;

  /// Suma wartości początkowej.
  final String? wartoscPSum;

  /// Suma wartości aktualnej.
  final String? wartoscASum;
}

/// Element raportu inwentaryzacji.
class GetInwentaryzacjaReportElementItem {
  /// Tworzy element raportu.
  const GetInwentaryzacjaReportElementItem({
    required this.elementId,
    required this.arkuszId,
    required this.inwentaryzacjaId,
    this.arkuszNumer,
    this.nrewid,
    this.nazwa,
    this.osoba,
    this.idmiejsce,
    this.miejsce,
    this.lvl,
    this.kodKreskowy,
    this.stanInwent,
    this.statusSpisu,
    this.likwidacja,
    this.nadwyzka,
    this.wartoscP,
    this.wartoscA,
    this.dataZakupu,
    this.nowyKodKreskowy,
    this.nowaOsoba,
    this.nowaNazwa,
    this.nadwIdmiejsce,
    this.nadwMiejsce,
    this.nadwLvl,
    this.nadwIdFirmy,
    this.nadwFirma,
    this.uwagiLoc,
    this.compensation,
  });

  /// Parsuje element raportu z JSON.
  factory GetInwentaryzacjaReportElementItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetInwentaryzacjaReportElementItem(
      elementId: (json['element_id'] as num?)?.toInt() ?? 0,
      arkuszId: (json['arkusz_id'] as num?)?.toInt() ?? 0,
      inwentaryzacjaId: (json['inwentaryzacja_id'] as num?)?.toInt() ?? 0,
      arkuszNumer: json['arkusz_numer'] as String?,
      nrewid: json['nrewid'] as String?,
      nazwa: json['nazwa'] as String?,
      osoba: json['osoba'] as String?,
      idmiejsce: (json['idmiejsce'] as num?)?.toInt(),
      miejsce: json['miejsce'] as String?,
      lvl: json['lvl'] as String?,
      kodKreskowy: (json['kod_kreskowy'] as num?)?.toInt(),
      stanInwent: json['stan_inwent'] as String?,
      statusSpisu: json['status_spisu'] as String?,
      likwidacja: json['likwidacja'] as bool?,
      nadwyzka: json['nadwyzka'] as bool?,
      wartoscP: json['wartosc_p'] as String?,
      wartoscA: json['wartosc_a'] as String?,
      dataZakupu: json['data_zakupu'] as String?,
      nowyKodKreskowy: json['nowy_kod_kreskowy'] as String?,
      nowaOsoba: json['nowa_osoba'] as String?,
      nowaNazwa: json['nowa_nazwa'] as String?,
      nadwIdmiejsce: (json['nadw_idmiejsce'] as num?)?.toInt(),
      nadwMiejsce: json['nadw_miejsce'] as String?,
      nadwLvl: json['nadw_lvl'] as String?,
      nadwIdFirmy: (json['nadw_id_firmy'] as num?)?.toInt(),
      nadwFirma: json['nadw_firma'] as String?,
      uwagiLoc: json['uwagi_loc'] as String?,
      compensation: switch (json['compensation']) {
        final Map<String, dynamic> value =>
          GetInwentaryzacjaReportCompensation.fromJson(value),
        _ => null,
      },
    );
  }

  /// Id elementu raportu.
  final int elementId;

  /// Id arkusza źródłowego.
  final int arkuszId;

  /// Id inwentaryzacji.
  final int inwentaryzacjaId;

  /// Numer arkusza.
  final String? arkuszNumer;

  /// Numer ewidencyjny.
  final String? nrewid;

  /// Nazwa środka trwałego.
  final String? nazwa;

  /// Osoba odpowiedzialna.
  final String? osoba;

  /// Id miejsca.
  final int? idmiejsce;

  /// Nazwa miejsca.
  final String? miejsce;

  /// Ścieżka miejsca.
  final String? lvl;

  /// Kod kreskowy.
  final int? kodKreskowy;

  /// Surowy stan inwentaryzacyjny.
  final String? stanInwent;

  /// Surowy status spisu.
  final String? statusSpisu;

  /// Flaga likwidacji.
  final bool? likwidacja;

  /// Flaga nadwyżki.
  final bool? nadwyzka;

  /// Wartość początkowa.
  final String? wartoscP;

  /// Wartość aktualna.
  final String? wartoscA;

  /// Data zakupu.
  final String? dataZakupu;

  /// Nowy kod kreskowy.
  final String? nowyKodKreskowy;

  /// Nowa osoba.
  final String? nowaOsoba;

  /// Nowa nazwa.
  final String? nowaNazwa;

  /// Id miejsca nadwyżki.
  final int? nadwIdmiejsce;

  /// Nazwa miejsca nadwyżki.
  final String? nadwMiejsce;

  /// Ścieżka miejsca nadwyżki.
  final String? nadwLvl;

  /// Id firmy nadwyżki.
  final int? nadwIdFirmy;

  /// Nazwa firmy nadwyżki.
  final String? nadwFirma;

  /// Uwagi lokalizacyjne.
  final String? uwagiLoc;

  /// Para kompensacyjna, jeśli backend ją znalazł.
  final GetInwentaryzacjaReportCompensation? compensation;
}

/// Dane parowania kompensacyjnego dla raportu.
class GetInwentaryzacjaReportCompensation {
  /// Tworzy dane kompensacji.
  const GetInwentaryzacjaReportCompensation({
    this.pairElementId,
    this.pairArkuszId,
    this.matchKey,
    this.brakElementId,
    this.brakArkuszId,
    this.brakMiejsce,
    this.brakOsoba,
    this.nadwyzkaElementId,
    this.nadwyzkaArkuszId,
    this.nadwyzkaMiejsce,
    this.nadwyzkaOsoba,
  });

  /// Parsuje kompensację z JSON.
  factory GetInwentaryzacjaReportCompensation.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetInwentaryzacjaReportCompensation(
      pairElementId: (json['pair_element_id'] as num?)?.toInt(),
      pairArkuszId: (json['pair_arkusz_id'] as num?)?.toInt(),
      matchKey: json['match_key'] as String?,
      brakElementId: (json['brak_element_id'] as num?)?.toInt(),
      brakArkuszId: (json['brak_arkusz_id'] as num?)?.toInt(),
      brakMiejsce: json['brak_miejsce'] as String?,
      brakOsoba: json['brak_osoba'] as String?,
      nadwyzkaElementId: (json['nadwyzka_element_id'] as num?)?.toInt(),
      nadwyzkaArkuszId: (json['nadwyzka_arkusz_id'] as num?)?.toInt(),
      nadwyzkaMiejsce: json['nadwyzka_miejsce'] as String?,
      nadwyzkaOsoba: json['nadwyzka_osoba'] as String?,
    );
  }

  /// Id sparowanego elementu.
  final int? pairElementId;

  /// Id sparowanego arkusza.
  final int? pairArkuszId;

  /// Klucz dopasowania backendu.
  final String? matchKey;

  /// Id elementu po stronie braku.
  final int? brakElementId;

  /// Id arkusza po stronie braku.
  final int? brakArkuszId;

  /// Miejsce po stronie braku.
  final String? brakMiejsce;

  /// Osoba po stronie braku.
  final String? brakOsoba;

  /// Id elementu po stronie nadwyżki.
  final int? nadwyzkaElementId;

  /// Id arkusza po stronie nadwyżki.
  final int? nadwyzkaArkuszId;

  /// Miejsce po stronie nadwyżki.
  final String? nadwyzkaMiejsce;

  /// Osoba po stronie nadwyżki.
  final String? nadwyzkaOsoba;
}
