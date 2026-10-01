import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  int _generation = 0;

  /// Pobiera sesję dokumentu OnlyOffice z backendu.
  Future<void> initSession() async {
    if (isClosed || state is StorageOfficeLoading) return;
    final retryAfter = switch (state) {
      StorageOfficeFailure(:final error) => error?.retryAfterUtc,
      _ => null,
    };
    if (retryAfter != null && DateTime.now().toUtc().isBefore(retryAfter)) {
      return;
    }
    final generation = ++_generation;
    emit(const StorageOfficeLoading());

    final result = await repository.getOfficeSession(fileId);
    if (isClosed || generation != _generation) return;

    result.fold(
      (error) => emit(
        StorageOfficeFailure(
          message: error.message,
          code: error.backendCode?.toString(),
          error: error,
        ),
      ),
      (session) => emit(StorageOfficeReady(session: session)),
    );
  }

  /// Zamyka aktywną sesję dokumentu.
  void closeSession() {
    if (isClosed) return;
    _generation++;
    emit(const StorageOfficeInitial());
  }

  @override
  Future<void> close() {
    _generation++;
    return super.close();
  }
}
