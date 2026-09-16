import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/cubit/bhp_users_state.dart';

/// Cubit sekcji pracowników BHP.
class BhpUsersCubit extends Cubit<BhpUsersState> {
  /// Tworzy cubit sekcji pracowników BHP.
  BhpUsersCubit({required this._repository}) : super(const BhpUsersInitial());

  final BhpUsersRepository _repository;

  /// Ładuje listę pracowników BHP.
  Future<void> load() async {
    if (isClosed) {
      return;
    }

    emit(const BhpUsersLoading());

    final result = await _repository.getUsers();
    if (isClosed) {
      return;
    }

    result.fold(
      (error) => emit(BhpUsersError(message: error.message)),
      (items) => emit(BhpUsersSuccess(items: items)),
    );
  }

  /// Masowo aktualizuje stanowisko dla pracowników.
  Future<Either<String, void>> bulkUpdatePosition({
    required List<int> employeeIds,
    required int stanowiskoId,
  }) async {
    final result = await _repository.bulkUpdatePosition(
      employeeIds: employeeIds,
      stanowiskoId: stanowiskoId,
    );
    return result.fold(
      (error) => Left(error.message),
      (_) async {
        await load();
        return const Right(null);
      },
    );
  }
}
