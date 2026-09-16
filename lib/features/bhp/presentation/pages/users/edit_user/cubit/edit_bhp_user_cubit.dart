import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/edit_user/cubit/edit_bhp_user_state.dart';

/// Cubit formularza edycji pracownika BHP.
class EditBhpUserCubit extends Cubit<EditBhpUserState> {
  /// Tworzy cubit formularza edycji pracownika.
  EditBhpUserCubit({
    required this._user,
    required this._usersRepository,
    required this._positionsRepository,
  }) : super(const EditBhpUserLoading());

  final GetBhpUserListItem _user;
  final BhpUsersRepository _usersRepository;
  final BhpPositionsRepository _positionsRepository;

  List<GetBhpPositionListItem> _positions = const [];
  GetBhpUserDetail? _userDetail;

  /// Ładuje dane potrzebne do formularza.
  Future<void> load() async {
    emit(const EditBhpUserLoading());

    final detailResult = await _usersRepository.getUserDetails(_user.id);
    final positionsResult = await _positionsRepository.getPositions(
      active: true,
    );

    detailResult.fold(
      (error) => emit(EditBhpUserLoadError(message: error.message)),
      (detail) {
        positionsResult.fold(
          (error) => emit(EditBhpUserLoadError(message: error.message)),
          (positions) {
            _userDetail = detail;
            _positions = positions
                .where((item) => item.aktywny)
                .toList(
                  growable: false,
                );
            emit(
              EditBhpUserReady(
                userDetail: detail,
                positions: _positions,
              ),
            );
          },
        );
      },
    );
  }

  /// Wysyła formularz edycji pracownika do backendu.
  Future<void> submit(PostBhpUserRequest request) async {
    final detail = _userDetail;
    if (state is EditBhpUserSubmitting || detail == null) {
      return;
    }

    emit(
      EditBhpUserSubmitting(
        userDetail: detail,
        positions: _positions,
      ),
    );

    final result = await _usersRepository.updateUser(_user.id, request);
    result.fold(
      (error) => emit(
        EditBhpUserReady(
          userDetail: detail,
          positions: _positions,
          submitError: error.message,
        ),
      ),
      (user) => emit(EditBhpUserSuccess(user: user)),
    );
  }
}
