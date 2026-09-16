import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/storage/hive_helper.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:rxdart/rxdart.dart';

/// Lokalny storage filtrów magazynu oparty o Hive CE.
class StockFilterStorage {
  /// Zwraca wspolna instancje storage filtrów.
  factory StockFilterStorage() => _instance;

  /// Tworzy singleton storage filtrów.
  StockFilterStorage._internal();

  static final StockFilterStorage _instance = StockFilterStorage._internal();
  static const _boxName = 'inventory_runtime_box';
  static const _paramsKey = 'stock_filter_params_v1';

  StockQueryParams _current = StockQueryParams.defaults;
  Future<void>? _initFuture;

  /// Ostatni odczytany stan filtrów.
  StockQueryParams get current => _current;

  /// Inicjalizuje cache storage i odczytuje zapisane filtry.
  Future<void> init({bool forceReload = false}) {
    if (forceReload) {
      _initFuture = null;
    }

    final existing = _initFuture;
    if (existing != null) {
      return existing;
    }

    final future = _load();
    _initFuture = future;
    return future;
  }

  /// Zapisuje aktualne filtry do storage.
  Future<void> save(StockQueryParams params) async {
    _current = params;
    final box = await HiveHelper.openBox<dynamic>(_boxName);
    await box.put(_paramsKey, params.toStorageMap());
  }

  /// Czyści zapisane filtry i resetuje cache do wartości domyślnych.
  Future<void> clear() async {
    _current = StockQueryParams.defaults;
    final box = await HiveHelper.openBox<dynamic>(_boxName);
    await box.delete(_paramsKey);
  }

  Future<void> _load() async {
    final box = await HiveHelper.openBox<dynamic>(_boxName);
    final raw = box.get(_paramsKey);
    _current = switch (raw) {
      final Map<dynamic, dynamic> map => StockQueryParams.fromStorageMap(
        Map<String, dynamic>.from(map),
      ),
      _ => StockQueryParams.defaults,
    };
  }
}

/// Serwis do synchronizacji filtrów i paginacji między widokami.
/// Pozwala na reaktywne reagowanie na zmiany parametrów zapytania.
class StockFilterService extends Cubit<StockQueryParams> {
  /// Tworzy serwis filtrów magazynu z opcjonalnym storage lokalnym.
  StockFilterService({StockFilterStorage? storage})
    : _storage = storage ?? StockFilterStorage(),
      super((storage ?? StockFilterStorage()).current);

  final _refreshSubject = PublishSubject<void>();
  final _companiesSubject = BehaviorSubject<List<GetFirmyItem>>.seeded([]);
  final StockFilterStorage _storage;

  /// Stream zmian wybranej firmy.
  Stream<int?> get firmaStream =>
      paramsStream.map((params) => params.firma).distinct();
  int? get currentFirma => state.firma;

  /// Stream zmian wybranego statusu srodka trwalego.
  Stream<SrodekTrwalyStatus?> get statusStream =>
      paramsStream.map((params) => params.status).distinct();
  SrodekTrwalyStatus? get currentStatus => state.status;

  /// Stream zmian offsetu.
  Stream<int> get offsetStream =>
      paramsStream.map((params) => params.offset).distinct();
  int get currentOffset => state.offset;

  /// Stream zmian limitu.
  Stream<int> get limitStream =>
      paramsStream.map((params) => params.limit).distinct();
  int get currentLimit => state.limit;

  /// Stream zmian zapytania tekstowego.
  Stream<String?> get qStream =>
      paramsStream.map((params) => params.q).distinct();
  String? get currentQuery => state.q;

  /// Stream listy firm.
  Stream<List<GetFirmyItem>> get companiesStream => _companiesSubject.stream;
  List<GetFirmyItem> get companies => _companiesSubject.value;

  /// Stream zbiorczy wszystkich parametrów.
  Stream<StockQueryParams> get paramsStream =>
      Rx.merge([stream.startWith(state), _refreshSubject.map((_) => state)]);

  /// Ostatni emitowany zestaw parametrów.
  StockQueryParams get lastParams => state;

  /// Ostatnia załadowana lista firm (alias dla companies).
  List<GetFirmyItem> get lastCompanies => _companiesSubject.value;

  /// Ustawia nową firmę i resetuje offset.
  void setFirma(int? id) {
    _updateParams(lastParams.copyWith(firma: id, offset: 0));
  }

  /// Ustawia nowy status i resetuje offset.
  void setStatus(SrodekTrwalyStatus? status) {
    _updateParams(lastParams.copyWith(status: status, offset: 0));
  }

  /// Ustawia nowy offset.
  void setOffset(int offset) {
    _updateParams(lastParams.copyWith(offset: offset));
  }

  /// Ustawia nowy limit i resetuje offset.
  void setLimit(int limit) {
    _updateParams(lastParams.copyWith(limit: limit, offset: 0));
  }

  /// Ustawia nowe zapytanie wyszukiwania i resetuje offset.
  void setQuery(String? q) {
    _updateParams(lastParams.copyWith(q: q, offset: 0));
  }

  /// Ustawia listę firm.
  void setCompanies(List<GetFirmyItem> items) {
    _companiesSubject.add(items);
  }

  /// Wymusza odświeżenie danych bez zmiany filtrów.
  void refresh() {
    _refreshSubject.add(null);
  }

  void _updateParams(StockQueryParams nextParams) {
    if (nextParams == lastParams) {
      return;
    }
    emit(nextParams);
    unawaited(_storage.save(nextParams));
  }

  /// Zamyka strumienie.
  void dispose() {
    unawaited(close());
  }

  @override
  Future<void> close() async {
    await _refreshSubject.close();
    await _companiesSubject.close();
    await super.close();
  }
}

/// Parametry zapytania o stany ŚT.
@immutable
class StockQueryParams {
  /// Tworzy parametry zapytania o stany ŚT.
  const StockQueryParams({
    required this.firma,
    required this.status,
    required this.offset,
    required this.limit,
    this.q,
  });

  /// Odtwarza stan filtrów z lokalnego storage.
  factory StockQueryParams.fromStorageMap(Map<String, dynamic> json) {
    final limit =
        (json['limit'] as num?)?.toInt() ?? StockQueryParams.defaults.limit;
    final firma = (json['firma'] as num?)?.toInt();
    final q = (json['q'] as String?)?.trim();

    return StockQueryParams(
      firma: firma,
      status: SrodekTrwalyStatus.fromApi(json['status']),
      offset: 0,
      limit: limit > 0 ? limit : StockQueryParams.defaults.limit,
      q: q == null || q.isEmpty ? null : q,
    );
  }

  static const _unchanged = Object();
  static const defaults = StockQueryParams(
    firma: null,
    status: null,
    offset: 0,
    limit: 50,
  );

  final int? firma;
  final SrodekTrwalyStatus? status;
  final int offset;
  final int limit;
  final String? q;

  StockQueryParams copyWith({
    Object? firma = _unchanged,
    Object? status = _unchanged,
    int? offset,
    int? limit,
    Object? q = _unchanged,
  }) {
    return StockQueryParams(
      firma: identical(firma, _unchanged) ? this.firma : firma as int?,
      status: identical(status, _unchanged)
          ? this.status
          : status as SrodekTrwalyStatus?,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      q: identical(q, _unchanged) ? this.q : q as String?,
    );
  }

  /// Serializuje filtry do prostego formatu mapy dla Hive.
  Map<String, dynamic> toStorageMap() {
    return {
      'firma': firma,
      'status': status?.apiValue,
      'limit': limit,
      'q': q?.trim(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockQueryParams &&
          runtimeType == other.runtimeType &&
          firma == other.firma &&
          status == other.status &&
          offset == other.offset &&
          limit == other.limit &&
          q == other.q;

  @override
  int get hashCode =>
      firma.hashCode ^
      status.hashCode ^
      offset.hashCode ^
      limit.hashCode ^
      q.hashCode;
}
