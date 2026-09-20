import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_preview_models.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_request_models.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';

/// Kontrakt atomowego kreatora projektu.
///
/// Dwie operacje celowo odpowiadają dwóm endpointom Backendu: `preview` niczego
/// nie zapisuje i zwraca znormalizowany plan, a `create` wykonuje całość w jednej
/// transakcji pod kluczem idempotencji. Kreator nie składa projektu z sekwencji
/// `create → patch → apply template → add members`.
abstract interface class ProjectSetupsRepository {
  /// Buduje plan utworzenia projektu bez żadnego zapisu.
  ///
  /// Ten sam model żądania trafia do `preview` i do `create`, dzięki czemu
  /// podsumowanie pokazuje dokładnie to, co powstanie.
  Future<Either<ApiError, ProjectSetupPreviewResponse>> previewProjectSetup({
    required String workspaceId,
    required CreateProjectSetupRequest request,
  });

  /// Tworzy projekt z pełną konfiguracją startową w jednej transakcji.
  ///
  /// [idempotencyKey] jest kluczem draftu: ponowienie po timeoucie albo utracie
  /// odpowiedzi musi użyć tej samej wartości, a Backend odtworzy zapisany wynik.
  Future<Either<ApiError, ProjectSetupCreation>> createProjectSetup({
    required String workspaceId,
    required CreateProjectSetupRequest request,
    required String idempotencyKey,
  });
}
