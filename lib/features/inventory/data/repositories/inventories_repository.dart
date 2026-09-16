import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/delete_arkusz_element_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/delete_arkusz_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/delete_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_presence_conflicts_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_surplus_conflicts_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_tree_progress_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_element_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_numer_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_inwentaryzacja_status_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_element_nrewid_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_elementy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_skanuj_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_snapshot_refresh_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/put_komisja_models.dart';

/// Kontrakt repozytorium listy inwentaryzacji.
abstract interface class InventoriesRepository {
  /// Pobiera liste inwentaryzacji na podstawie zadanego query.
  Future<Either<ApiError, GetInwentaryzacjeResponseData>> fetchInventories(
    GetInwentaryzacjeQuery query,
  );

  /// Pobiera szczegoly pojedynczej inwentaryzacji.
  Future<Either<ApiError, GetInwentaryzacjaDetailsResponseData>>
  fetchInventoryDetails(int inventoryId);

  /// Wyszukuje elementy we wszystkich arkuszach wskazanej inwentaryzacji.
  Future<Either<ApiError, GetInwentaryzacjaSearchArkuszeResponseData>>
  searchInventorySheets({
    required int inventoryId,
    required GetInwentaryzacjaSearchArkuszeQuery query,
  });

  /// Pobiera informacyjna liste konfliktow obecnosci dla inwentaryzacji.
  Future<Either<ApiError, GetInwentaryzacjaPresenceConflictsResponseData>>
  fetchInventoryPresenceConflicts(int inventoryId);

  /// Pobiera informacyjna liste konfliktow nadwyzek dla inwentaryzacji.
  Future<Either<ApiError, GetInwentaryzacjaSurplusConflictsResponseData>>
  fetchInventorySurplusConflicts(int inventoryId);

  /// Pobiera drzewo wykonania arkuszy dla wskazanej inwentaryzacji.
  Future<Either<ApiError, GetInwentaryzacjaTreeProgressResponseData>>
  fetchInventoryTreeProgress(int inventoryId);

  /// Pobiera raport dla wskazanej inwentaryzacji.
  Future<Either<ApiError, GetInwentaryzacjaReportResponseData>>
  fetchInventoryReport({
    required int inventoryId,
    required GetInwentaryzacjaReportQuery query,
  });

  /// Usuwa wskazana inwentaryzacje.
  Future<Either<ApiError, DeleteInwentaryzacjaResponseData>> deleteInventory(
    int inventoryId,
  );

  /// Zamyka wskazana inwentaryzacje.
  Future<Either<ApiError, PatchInwentaryzacjaStatusResponseData>>
  closeInventory({
    required int inventoryId,
  });

  /// Aktualizuje daty i naglowek wskazanej inwentaryzacji.
  Future<Either<ApiError, PatchInwentaryzacjaResponseData>> updateInventory({
    required int inventoryId,
    required PatchInwentaryzacjaRequest query,
  });

  /// Usuwa wskazany arkusz.
  Future<Either<ApiError, DeleteArkuszResponseData>> deleteArkusz(int arkuszId);

  /// Pobiera szczegoly pojedynczego arkusza.
  Future<Either<ApiError, GetArkuszDetailsResponseData>> fetchArkuszDetails(
    int arkuszId,
  );

  /// Aktualizuje daty wskazanego arkusza.
  Future<Either<ApiError, UpdateArkuszResponseData>> updateArkusz({
    required int arkuszId,
    required UpdateArkuszRequest query,
  });

  /// Aktualizuje numer wskazanego arkusza.
  Future<Either<ApiError, UpdateArkuszNumerResponseData>> updateArkuszNumer({
    required int arkuszId,
    required UpdateArkuszNumerRequest query,
  });

  /// Tworzy nowa inwentaryzacje na podstawie przekazanego query.
  Future<Either<ApiError, PostInwentaryzacjaResponseData>> createInwentaryzacja(
    PostInwentaryzacjaQuery query,
  );

  /// Tworzy nowy arkusz dla wskazanej inwentaryzacji.
  Future<Either<ApiError, PostArkuszResponseData>> createArkusz({
    required int inventoryId,
    required PostArkuszQuery query,
  });

  /// Podmienia komisje wskazanej inwentaryzacji.
  Future<Either<ApiError, KomisjaUpdateData>> updateInventoryCommittee({
    required int inventoryId,
    required UpdateKomisjaRequest query,
  });

  /// Podmienia komisje wskazanego arkusza.
  Future<Either<ApiError, KomisjaUpdateData>> updateArkuszCommittee({
    required int arkuszId,
    required UpdateKomisjaRequest query,
  });

  /// Aktualizuje dane pojedynczego elementu arkusza.
  Future<Either<ApiError, PatchArkuszElementResponseData>> updateArkuszElement({
    required int arkuszId,
    required int elementId,
    required PatchArkuszElementQuery query,
  });

  /// Dodaje nowy element (nadwyzke) do wskazanego arkusza.
  Future<Either<ApiError, PostArkuszElementyResponseData>> addArkuszNadwyzka({
    required int arkuszId,
    required PostArkuszElementyQuery query,
  });

  /// Usuwa element ze wskazanego arkusza.
  Future<Either<ApiError, DeleteArkuszElementResponseData>>
  deleteArkuszElement({
    required int arkuszId,
    required int elementId,
  });

  /// Tworzy element arkusza po numerze ewidencyjnym.
  Future<Either<ApiError, CreateArkuszElementByNrewidResponseData>>
  createArkuszElementByNrewid({
    required int arkuszId,
    required CreateArkuszElementByNrewidRequest query,
  });

  /// Wykonuje skan kodu kreskowego dla wskazanej inwentaryzacji.
  Future<Either<ApiError, SkanujInwentaryzacjaResponseData>>
  skanujInwentaryzacja({
    required int inventoryId,
    required SkanujInwentaryzacjaRequest query,
  });

  /// Uruchamia odswiezenie snapshotu ST przez Data Bus.
  Future<Either<ApiError, PostSnapshotRefreshResponseData>> refreshSnapshot();
}

/// Implementacja repozytorium listy inwentaryzacji oparta o Retrofit.
class InventoriesRepositoryImpl extends ApiRepository
    implements InventoriesRepository {
  /// Tworzy repozytorium z klientem API inwentaryzacji.
  InventoriesRepositoryImpl({required this._api});

  final InventoryApi _api;

  @override
  Future<Either<ApiError, GetInwentaryzacjeResponseData>> fetchInventories(
    GetInwentaryzacjeQuery query,
  ) async {
    return guardApiCall(
      () async {
        final response = await _api.getInwentaryzacje(
          firma: query.firma,
          status: query.status,
          numer: query.numer,
          dataOdFrom: query.dataOdFrom,
          dataOdTo: query.dataOdTo,
          sortBy: query.sortBy?.apiValue,
          sortDir: query.sortDir?.apiValue,
        );
        return response.data;
      },
      fallbackMessage: 'Nie udało się pobrać listy inwentaryzacji.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane listy inwentaryzacji.',
    );
  }

  @override
  Future<Either<ApiError, GetInwentaryzacjaDetailsResponseData>>
  fetchInventoryDetails(int inventoryId) async {
    return guardApiCall(
      () async {
        final response = await _api.getInwentaryzacjaDetails(inventoryId);
        return response.data;
      },
      fallbackMessage: 'Nie udało się pobrać szczegółów inwentaryzacji.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane szczegółów inwentaryzacji.',
    );
  }

  @override
  Future<Either<ApiError, GetInwentaryzacjaSearchArkuszeResponseData>>
  searchInventorySheets({
    required int inventoryId,
    required GetInwentaryzacjaSearchArkuszeQuery query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.searchInwentaryzacjaArkusze(
          inventoryId,
          q: query.q,
          sortBy: query.sortBy.apiValue,
          sortDir: query.sortDir.apiValue,
        );
        return response.data;
      },
      fallbackMessage: 'Nie udało się przeszukać arkuszy.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane wyszukiwarki arkuszy.',
    );
  }

  @override
  Future<Either<ApiError, GetInwentaryzacjaPresenceConflictsResponseData>>
  fetchInventoryPresenceConflicts(int inventoryId) async {
    return guardApiCall(
      () async {
        final response = await _api.getInwentaryzacjaPresenceConflicts(
          inventoryId,
        );
        return response.data;
      },
      fallbackMessage: 'Nie udało się pobrać konfliktów obecności.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane listy konfliktów obecności.',
    );
  }

  @override
  Future<Either<ApiError, GetInwentaryzacjaSurplusConflictsResponseData>>
  fetchInventorySurplusConflicts(int inventoryId) async {
    return guardApiCall(
      () async {
        final response = await _api.getInwentaryzacjaSurplusConflicts(
          inventoryId,
        );
        return response.data;
      },
      fallbackMessage: 'Nie udało się pobrać konfliktów nadwyżek.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane listy konfliktów nadwyżek.',
    );
  }

  @override
  Future<Either<ApiError, GetInwentaryzacjaTreeProgressResponseData>>
  fetchInventoryTreeProgress(int inventoryId) async {
    return guardApiCall(
      () async {
        final response = await _api.getInwentaryzacjaTreeProgress(inventoryId);
        return response.data;
      },
      fallbackMessage: 'Nie udało się pobrać drzewa wykonania arkuszy.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane drzewa wykonania arkuszy.',
    );
  }

  @override
  Future<Either<ApiError, GetInwentaryzacjaReportResponseData>>
  fetchInventoryReport({
    required int inventoryId,
    required GetInwentaryzacjaReportQuery query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.getInwentaryzacjaReport(
          inventoryId,
          query.reportType.apiValue,
          includeSummary: switch (query.includeSummary) {
            true => null,
            false => '0',
          },
          sortBy: query.sortBy?.apiValue,
          sortDir: query.sortDir?.apiValue,
        );
        return response.data;
      },
      fallbackMessage: 'Nie udało się pobrać raportu inwentaryzacji.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane raportu.',
    );
  }

  @override
  Future<Either<ApiError, DeleteInwentaryzacjaResponseData>> deleteInventory(
    int inventoryId,
  ) async {
    return guardApiCall(
      () async {
        final response = await _api.deleteInwentaryzacja(inventoryId);
        return response.data;
      },
      fallbackMessage: 'Nie udało się usunąć inwentaryzacji.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po usunięciu inwentaryzacji.',
    );
  }

  @override
  Future<Either<ApiError, PatchInwentaryzacjaStatusResponseData>>
  closeInventory({
    required int inventoryId,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.closeInwentaryzacja(inventoryId);
        return response.data;
      },
      fallbackMessage: 'Nie udało się zamknąć inwentaryzacji.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane po zmianie statusu.',
    );
  }

  @override
  Future<Either<ApiError, PatchInwentaryzacjaResponseData>> updateInventory({
    required int inventoryId,
    required PatchInwentaryzacjaRequest query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.updateInwentaryzacja(inventoryId, query);
        return response.data;
      },
      fallbackMessage: 'Nie udało się zaktualizować dat inwentaryzacji.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po aktualizacji inwentaryzacji.',
    );
  }

  @override
  Future<Either<ApiError, DeleteArkuszResponseData>> deleteArkusz(
    int arkuszId,
  ) async {
    return guardApiCall(
      () async {
        final response = await _api.deleteArkusz(arkuszId);
        return response.data;
      },
      fallbackMessage: 'Nie udało się usunąć arkusza.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po usunięciu arkusza.',
    );
  }

  @override
  Future<Either<ApiError, GetArkuszDetailsResponseData>> fetchArkuszDetails(
    int arkuszId,
  ) async {
    return guardApiCall(
      () async {
        final response = await _api.getArkuszDetails(arkuszId);
        return response.data;
      },
      fallbackMessage: 'Nie udało się pobrać szczegółów arkusza.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane szczegółów arkusza.',
    );
  }

  @override
  Future<Either<ApiError, UpdateArkuszResponseData>> updateArkusz({
    required int arkuszId,
    required UpdateArkuszRequest query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.updateArkusz(arkuszId, query);
        return response.data;
      },
      fallbackMessage: 'Nie udało się zaktualizować dat arkusza.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po aktualizacji arkusza.',
    );
  }

  @override
  Future<Either<ApiError, UpdateArkuszNumerResponseData>> updateArkuszNumer({
    required int arkuszId,
    required UpdateArkuszNumerRequest query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.updateArkuszNumer(arkuszId, query);
        return response.data;
      },
      fallbackMessage: 'Nie udało się zaktualizować numeru arkusza.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po aktualizacji numeru arkusza.',
    );
  }

  @override
  Future<Either<ApiError, PostInwentaryzacjaResponseData>> createInwentaryzacja(
    PostInwentaryzacjaQuery query,
  ) async {
    return guardApiCall(
      () async {
        final response = await _api.createInwentaryzacja(query);
        return response.data;
      },
      fallbackMessage: 'Nie udało się utworzyć inwentaryzacji.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po utworzeniu inwentaryzacji.',
    );
  }

  @override
  Future<Either<ApiError, PostArkuszResponseData>> createArkusz({
    required int inventoryId,
    required PostArkuszQuery query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.createArkusz(inventoryId, query);
        return response.data;
      },
      fallbackMessage: 'Nie udało się utworzyć arkusza.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane nowego arkusza.',
    );
  }

  @override
  Future<Either<ApiError, KomisjaUpdateData>> updateInventoryCommittee({
    required int inventoryId,
    required UpdateKomisjaRequest query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.updateInwentaryzacjaKomisja(
          inventoryId,
          query,
        );
        return response.data;
      },
      fallbackMessage: 'Nie udało się zaktualizować komisji inwentaryzacji.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po aktualizacji komisji inwentaryzacji.',
    );
  }

  @override
  Future<Either<ApiError, KomisjaUpdateData>> updateArkuszCommittee({
    required int arkuszId,
    required UpdateKomisjaRequest query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.updateArkuszKomisja(arkuszId, query);
        return response.data;
      },
      fallbackMessage: 'Nie udało się zaktualizować komisji arkusza.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po aktualizacji komisji arkusza.',
    );
  }

  @override
  Future<Either<ApiError, PatchArkuszElementResponseData>> updateArkuszElement({
    required int arkuszId,
    required int elementId,
    required PatchArkuszElementQuery query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.updateArkuszElement(
          arkuszId,
          elementId,
          query,
        );
        return response.data;
      },
      fallbackMessage: 'Nie udało się zaktualizować elementu arkusza.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po aktualizacji elementu arkusza.',
    );
  }

  @override
  Future<Either<ApiError, PostArkuszElementyResponseData>> addArkuszNadwyzka({
    required int arkuszId,
    required PostArkuszElementyQuery query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.addArkuszNadwyzka(arkuszId, query);
        return response.data;
      },
      fallbackMessage: 'Nie udało się dodać nadwyżki do arkusza.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po dodaniu nadwyżki do arkusza.',
    );
  }

  @override
  Future<Either<ApiError, DeleteArkuszElementResponseData>>
  deleteArkuszElement({
    required int arkuszId,
    required int elementId,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.deleteArkuszElement(arkuszId, elementId);
        return response.data;
      },
      fallbackMessage: 'Nie udało się usunąć elementu arkusza.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po usunięciu elementu arkusza.',
    );
  }

  @override
  Future<Either<ApiError, CreateArkuszElementByNrewidResponseData>>
  createArkuszElementByNrewid({
    required int arkuszId,
    required CreateArkuszElementByNrewidRequest query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.createArkuszElementByNrewid(
          arkuszId,
          query,
        );
        return response.data;
      },
      fallbackMessage: 'Nie udało się dodać elementu po numerze ewidencyjnym.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po dodaniu elementu po numerze ewidencyjnym.',
    );
  }

  @override
  Future<Either<ApiError, SkanujInwentaryzacjaResponseData>>
  skanujInwentaryzacja({
    required int inventoryId,
    required SkanujInwentaryzacjaRequest query,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.skanujInwentaryzacja(inventoryId, query);
        return response.data;
      },
      fallbackMessage: 'Nie udało się przetworzyć skanu.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane skanu.',
    );
  }

  @override
  Future<Either<ApiError, PostSnapshotRefreshResponseData>>
  refreshSnapshot() async {
    final result = await guardApiCall(
      () => _api.refreshSnapshot(
        Options(
          receiveTimeout: const Duration(minutes: 3),
        ),
      ),
      fallbackMessage: 'Nie udało się odświeżyć snapshotu ST.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane odświeżenia snapshotu ST.',
    );

    return result.fold(left, (response) {
      if (response.isAtomicSuccess) {
        return right(response);
      }

      final firstFailed = switch (response.failedResults) {
        [final first, ...] => first,
        _ => null,
      };
      final details = switch (firstFailed) {
        final item? when (item.error?.trim().isNotEmpty ?? false) =>
          '${item.baza}: ${item.error!.trim()}',
        final item? => '${item.baza}: status=${item.status}',
        _ => 'error_count=${response.errorCount}',
      };

      return left(
        ApiError(
          type: ApiErrorType.conflict,
          message:
              'Odswiezenie snapshotu ST nie zakonczylo sie atomowo. '
              'Wystapil blad co najmniej jednej bazy ($details).',
        ),
      );
    });
  }
}
