import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';

/// Port lokalnego katalogu użytkowników dla modułu Pliki.
///
/// Udostępnianie osobie i filtr właściciela potrzebują tego samego źródła
/// kandydatów, więc oba czytają jeden port. Port celowo nie zwraca profili
/// spoza wskazanego workspace'u: katalog jest lokalny i zakresowy, więc nie
/// może ujawniać użytkowników, do których autor nie ma dostępu.
// Jedna operacja wystarcza: port opisuje dokładnie jedno źródło kandydatów.
// ignore: one_member_abstracts
abstract interface class StorageUserDirectoryPort {
  /// Szuka lokalnych użytkowników workspace'u po loginu, e-mailu albo nazwie.
  Future<Either<ApiError, List<LocalUserDirectoryResponse>>> search({
    required String workspaceId,
    required String query,
  });
}
