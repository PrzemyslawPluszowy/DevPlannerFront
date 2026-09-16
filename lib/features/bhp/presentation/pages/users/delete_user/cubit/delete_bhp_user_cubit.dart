import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/delete_user/cubit/delete_bhp_user_state.dart';

/// Cubit obsługujący usuwanie pracownika BHP przez archiwizację.
class DeleteBhpUserCubit extends Cubit<DeleteBhpUserState> {
  /// Tworzy cubit modalu usuwania pracownika.
  DeleteBhpUserCubit({required this._repository})
    : super(const DeleteBhpUserInitial());

  final BhpUsersRepository _repository;

  /// Archiwizuje wskazanego pracownika.
  Future<void> submit({required int userId}) async {
    emit(const DeleteBhpUserSubmitting());

    final result = await _repository.archiveUser(userId);
    result.fold(
      (error) => emit(DeleteBhpUserError(message: error.message)),
      (_) => emit(const DeleteBhpUserSuccess()),
    );
  }

  /// Usuwa pracownika z bazy danych (hard delete).
  Future<void> submitForceDelete({required int userId}) async {
    emit(const DeleteBhpUserSubmitting());

    final result = await _repository.destroyUser(userId);
    result.fold(
      (error) => emit(DeleteBhpUserError(message: error.message)),
      (_) => emit(const DeleteBhpUserSuccess()),
    );
  }
}
