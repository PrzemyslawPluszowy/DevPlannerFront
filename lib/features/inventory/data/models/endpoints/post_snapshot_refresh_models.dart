/// Odpowiedz endpointu `POST /api/v1/inwentaryzacja/snapshot/refresh`.
class PostSnapshotRefreshResponseData {
  /// Tworzy wynik odswiezenia snapshotu.
  const PostSnapshotRefreshResponseData({
    required this.results,
    required this.okCount,
    required this.errorCount,
  });

  /// Parsuje odpowiedz od Data Bus.
  factory PostSnapshotRefreshResponseData.fromJson(Map<String, dynamic> json) {
    final rawResults = switch (json['results']) {
      final List<dynamic> value => value,
      _ => const <dynamic>[],
    };

    return PostSnapshotRefreshResponseData(
      results: rawResults
          .whereType<Map<String, dynamic>>()
          .map(PostSnapshotRefreshResultItem.fromJson)
          .toList(growable: false),
      okCount: (json['ok_count'] as num?)?.toInt() ?? 0,
      errorCount: (json['error_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Wyniki per baza.
  final List<PostSnapshotRefreshResultItem> results;

  /// Liczba baz zakonczonych sukcesem.
  final int okCount;

  /// Liczba baz zakonczonych bledem.
  final int errorCount;

  /// Czy caly refresh zakonczyl sie atomowo sukcesem.
  bool get isAtomicSuccess {
    return errorCount == 0 &&
        results.every(
          (item) =>
              item.status.trim().toLowerCase() == 'ok' &&
              (item.error?.trim().isEmpty ?? true),
        );
  }

  /// Zwraca wpisy, ktore zakonczono bledem.
  List<PostSnapshotRefreshResultItem> get failedResults {
    return results
        .where(
          (item) =>
              item.status.trim().toLowerCase() != 'ok' ||
              (item.error?.trim().isNotEmpty ?? false),
        )
        .toList(growable: false);
  }
}

/// Wynik odswiezenia dla pojedynczej bazy.
class PostSnapshotRefreshResultItem {
  /// Tworzy wynik per baza.
  const PostSnapshotRefreshResultItem({
    required this.alias,
    required this.baza,
    required this.idFirmy,
    required this.miejscaCount,
    required this.stanStCount,
    required this.status,
    this.error,
  });

  /// Parsuje wpis wyniku.
  factory PostSnapshotRefreshResultItem.fromJson(Map<String, dynamic> json) {
    return PostSnapshotRefreshResultItem(
      alias: (json['alias'] as String?) ?? '',
      baza: (json['baza'] as String?) ?? '',
      idFirmy: (json['id_firmy'] as num?)?.toInt() ?? 0,
      miejscaCount: (json['miejsca_count'] as num?)?.toInt() ?? 0,
      stanStCount: (json['stan_st_count'] as num?)?.toInt() ?? 0,
      status: (json['status'] as String?) ?? '',
      error: json['error'] as String?,
    );
  }

  /// Alias konfiguracji z Data Bus.
  final String alias;

  /// Marker bazy.
  final String baza;

  /// Id firmy.
  final int idFirmy;

  /// Liczba rekordow miejsc.
  final int miejscaCount;

  /// Liczba rekordow ST.
  final int stanStCount;

  /// Status przetwarzania (`ok`, `firebird_error`, ...).
  final String status;

  /// Szczegoly bledu, jesli wystapil.
  final String? error;
}
