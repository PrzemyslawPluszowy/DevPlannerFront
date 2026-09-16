import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';

/// Cubit obslugujacy regeneracje snapshotu ST.
class SnapshotRegenerationCubit extends Cubit<SnapshotRegenerationState> {
  /// Tworzy cubit regeneracji snapshotu.
  SnapshotRegenerationCubit({required this._repository})
    : super(const SnapshotRegenerationInitial());

  final InventoriesRepository _repository;

  /// Uruchamia regeneracje snapshotu po sprawdzeniu aktywnych inwentaryzacji.
  Future<void> regenerate() async {
    emit(const SnapshotRegenerationInProgress());

    // Tymczasowo wylaczone: snapshot ma dac sie uruchomic nawet przy
    // aktywnej inwentaryzacji. Zostawiamy guard w komentarzu do latwego
    // przywrocenia po decyzji biznesowej.
    // final activeResult = await _repository.fetchInventories(
    //   GetInwentaryzacjeQuery(status: InwentaryzacjaStatus.wToku.apiValue),
    // );
    //
    // if (isClosed) {
    //   return;
    // }
    //
    // if (activeResult.isLeft()) {
    //   emit(
    //     const SnapshotRegenerationFailure(
    //       message: 'Nie udalo sie sprawdzic aktywnych inwentaryzacji.',
    //     ),
    //   );
    //   return;
    // }
    //
    // final hasActiveInventory = activeResult.fold(
    //   (_) => false,
    //   (data) => data.items.isNotEmpty,
    // );
    // if (hasActiveInventory) {
    //   emit(const SnapshotRegenerationBlockedByActiveInventory());
    //   return;
    // }

    final refreshResult = await _repository.refreshSnapshot();
    if (isClosed) {
      return;
    }

    refreshResult.fold(
      (error) => emit(SnapshotRegenerationFailure(message: error.message)),
      (response) => emit(
        SnapshotRegenerationSuccess(
          okCount: response.okCount,
          errorCount: response.errorCount,
        ),
      ),
    );
  }
}

/// Bazowy stan regeneracji snapshotu.
sealed class SnapshotRegenerationState extends Equatable {
  /// Tworzy bazowy stan regeneracji.
  const SnapshotRegenerationState();

  @override
  List<Object?> get props => [];
}

/// Stan poczatkowy.
final class SnapshotRegenerationInitial extends SnapshotRegenerationState {
  /// Tworzy stan poczatkowy.
  const SnapshotRegenerationInitial();
}

/// Stan trwajacej regeneracji.
final class SnapshotRegenerationInProgress extends SnapshotRegenerationState {
  /// Tworzy stan przetwarzania.
  const SnapshotRegenerationInProgress();
}

/// Stan sukcesu regeneracji.
final class SnapshotRegenerationSuccess extends SnapshotRegenerationState {
  /// Tworzy stan sukcesu.
  const SnapshotRegenerationSuccess({
    required this.okCount,
    required this.errorCount,
  });

  /// Liczba baz zakonczonych sukcesem.
  final int okCount;

  /// Liczba baz zakonczonych bledem.
  final int errorCount;

  @override
  List<Object?> get props => [okCount, errorCount];
}

/// Stan zablokowania przez aktywna inwentaryzacje.
final class SnapshotRegenerationBlockedByActiveInventory
    extends SnapshotRegenerationState {
  /// Tworzy stan blokady.
  const SnapshotRegenerationBlockedByActiveInventory();
}

/// Stan bledu regeneracji.
final class SnapshotRegenerationFailure extends SnapshotRegenerationState {
  /// Tworzy stan bledu.
  const SnapshotRegenerationFailure({required this.message});

  /// Komunikat bledu.
  final String message;

  @override
  List<Object?> get props => [message];
}
