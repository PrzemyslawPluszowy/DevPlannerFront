import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

/// Cubit sekcji "Inwentaryzacje" oparty o wspolny wrapper stanu.
class InventoriesCubit extends LoadableCubit<GetInwentaryzacjeResponseData> {
  /// Tworzy cubit sekcji "Inwentaryzacje".
  InventoriesCubit({required this._repository});

  final InventoriesRepository _repository;
  static const GetInwentaryzacjeSortBy _defaultSortBy =
      GetInwentaryzacjeSortBy.dataOd;
  static const GetInwentaryzacjeSortDirection _defaultSortDir =
      GetInwentaryzacjeSortDirection.desc;

  String? _numer;
  int? _status;
  String? _dataOdFrom;
  String? _dataOdTo;

  /// Aktualnie ustawiony filtr numeru.
  String? get numerFilter => _numer;

  /// Aktualnie ustawiony filtr statusu API.
  int? get statusFilter => _status;

  /// Aktualnie ustawiona data poczatkowa zakresu.
  String? get dataOdFromFilter => _dataOdFrom;

  /// Aktualnie ustawiona data koncowa zakresu.
  String? get dataOdToFilter => _dataOdTo;

  /// Laduje liste inwentaryzacji z domyslnym sortowaniem malejacym po id.
  Future<void> load() async {
    emitLoading();

    final result = await _repository.fetchInventories(
      GetInwentaryzacjeQuery(
        numer: _numer,
        status: _status,
        dataOdFrom: _dataOdFrom,
        dataOdTo: _dataOdTo,
        sortBy: _defaultSortBy,
        sortDir: _defaultSortDir,
      ),
    );

    result.fold((error) => emitError(error.message), (data) {
      emitSuccess(_moveFinishedToEnd(data));
    });
  }

  /// Ustawia filtry numeru i statusu, a nastepnie odswieza liste.
  Future<void> applyFilters({String? numer, int? status}) async {
    _numer = _normalizeText(numer);
    _status = status;
    await load();
  }

  /// Ustawia zakres dat dla pola `data_od` i odswieza liste.
  Future<void> applyDateRange({String? dataOdFrom, String? dataOdTo}) async {
    _dataOdFrom = _normalizeText(dataOdFrom);
    _dataOdTo = _normalizeText(dataOdTo);
    await load();
  }

  /// Czyci wszystkie aktywne filtry i odswieza liste.
  Future<void> clearAllFilters() async {
    _numer = null;
    _status = null;
    _dataOdFrom = null;
    _dataOdTo = null;
    await load();
  }

  String? _normalizeText(String? value) {
    final normalized = value?.trim();
    return switch (normalized) {
      final String text when text.isNotEmpty => text,
      _ => null,
    };
  }

  GetInwentaryzacjeResponseData _moveFinishedToEnd(
    GetInwentaryzacjeResponseData data,
  ) {
    final active = <GetInwentaryzacjeItem>[];
    final finished = <GetInwentaryzacjeItem>[];

    for (final item in data.items) {
      if (item.status == InwentaryzacjaStatus.zakonczona) {
        finished.add(item);
      } else {
        active.add(item);
      }
    }

    return GetInwentaryzacjeResponseData(
      items: [...active, ...finished],
      meta: data.meta,
    );
  }
}
