import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:equatable/equatable.dart';

/// Sposób prezentacji listy plików.
///
/// Enum żyje w domenie, bo jest zapisywany w preferencjach użytkownika i musi
/// przetrwać restart klienta — nie jest wyłącznie detalem jednego widgetu.
enum StorageViewMode {
  /// Siatka kafelków.
  grid,

  /// Lista wierszy.
  list,
}

/// Gęstość wierszy listy plików.
enum StorageDensity {
  /// Wiersze z pełnym odstępem.
  comfortable,

  /// Wiersze zagęszczone, dla dużych katalogów.
  compact,
}

/// Trwała preferencja widoku modułu Pliki dla użytkownika i zakresu.
///
/// Preferencja obejmuje wyłącznie to, co użytkownik realnie ustawia i widzi:
/// tryb widoku, sortowanie i gęstość wierszy. Widoczne kolumny i ich szerokości
/// dołączą do modelu razem z widokiem tabelarycznym, żeby nie zapisywać ustawień
/// kontrolek, których jeszcze nie ma.
class StorageViewPreference extends Equatable {
  /// Tworzy preferencję widoku.
  const StorageViewPreference({
    this.viewMode = StorageViewMode.list,
    this.sort = const StorageSortCriteria(),
    this.density = StorageDensity.comfortable,
  });

  /// Odtwarza preferencję z zapisu, odpornej na nieznane i brakujące pola.
  ///
  /// Uszkodzony albo starszy wpis nie może wywrócić modułu: nieznana wartość
  /// pola wraca do wartości domyślnej, a brak wpisu oznacza brak preferencji.
  factory StorageViewPreference.fromJson(Map<String, Object?> json) {
    final sortField = json['sortField'];
    final sortDirection = json['sortDirection'];
    return StorageViewPreference(
      viewMode:
          _byName(StorageViewMode.values, json['viewMode']) ??
          StorageViewMode.list,
      sort: StorageSortCriteria(
        field:
            _byName(StorageSortField.values, sortField) ??
            StorageSortField.updatedAt,
        direction:
            _byName(StorageSortDirection.values, sortDirection) ??
            StorageSortDirection.descending,
      ),
      density:
          _byName(StorageDensity.values, json['density']) ??
          StorageDensity.comfortable,
    );
  }

  /// Preferencja domyślna: lista posortowana po dacie, gęstość komfortowa.
  static const StorageViewPreference defaults = StorageViewPreference();

  /// Tryb widoku.
  final StorageViewMode viewMode;

  /// Kryterium sortowania.
  final StorageSortCriteria sort;

  /// Gęstość wierszy.
  final StorageDensity density;

  /// Tworzy kopię z zaktualizowanymi polami.
  StorageViewPreference copyWith({
    StorageViewMode? viewMode,
    StorageSortCriteria? sort,
    StorageDensity? density,
  }) => StorageViewPreference(
    viewMode: viewMode ?? this.viewMode,
    sort: sort ?? this.sort,
    density: density ?? this.density,
  );

  /// Zamienia preferencję na zapis JSON.
  Map<String, Object?> toJson() => {
    'viewMode': viewMode.name,
    'sortField': sort.field.name,
    'sortDirection': sort.direction.name,
    'density': density.name,
  };

  static T? _byName<T extends Enum>(List<T> values, Object? raw) {
    if (raw is! String) return null;
    for (final value in values) {
      if (value.name == raw) return value;
    }
    return null;
  }

  @override
  List<Object?> get props => [viewMode, sort, density];
}
