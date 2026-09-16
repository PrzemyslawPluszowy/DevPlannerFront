import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/presentation/storage/office/cubit/storage_office_state.dart';

/// Cubit odpowiedzialny za cykl życia sesji OnlyOffice dla edytowalnych dokumentów.
///
/// Obsługuje:
/// - Pobranie tokenu sesji i konfiguracji (getOfficeSession)
/// - Rozpoznawanie uprawnień canEdit
/// - Bezpieczne zamknięcie sesji
class StorageOfficeCubit extends Cubit<StorageOfficeState> {
  /// Tworzy cubit sesji OnlyOffice.
  StorageOfficeCubit({
    required this.fileId,
    required this.repository,
  }) : super(const StorageOfficeInitial());

  /// Identyfikator otwieranego pliku.
  final String fileId;

  /// Repozytorium storage.
  final StorageRepository repository;

  /// Pobiera sesję dokumentu OnlyOffice z backendu.
  Future<void> initSession() async {
    emit(const StorageOfficeLoading());

    final result = await repository.getOfficeSession(fileId);
    if (isClosed) return;

    result.fold(
      (error) => emit(
        StorageOfficeFailure(
          message: error.message,
          code: error.backendCode?.toString(),
        ),
      ),
      (session) => emit(StorageOfficeReady(session: session)),
    );
  }

  /// Zamyka aktywną sesję dokumentu.
  void closeSession() {
    emit(const StorageOfficeInitial());
  }
}
