import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/position_standard/cubit/bhp_user_position_standard_state.dart';

/// Lokalny cubit flow stanowiska i standardu pracownika BHP.
class BhpUserPositionStandardCubit extends Cubit<BhpUserPositionStandardState> {
  /// Tworzy cubit stanowiska i standardu dla wskazanego pracownika.
  BhpUserPositionStandardCubit({
    required this._user,
    required this._usersRepository,
    required this._positionsRepository,
  }) : super(const BhpUserPositionStandardLoading());

  final GetBhpUserListItem _user;
  final BhpUsersRepository _usersRepository;
  final BhpPositionsRepository _positionsRepository;
  int _standardsRequestId = 0;

  /// Ładuje szczegóły pracownika oraz listę stanowisk.
  Future<void> load() async {
    emit(const BhpUserPositionStandardLoading());

    final detailResult = await _usersRepository.getUserDetails(_user.id);
    final positionsResult = await _positionsRepository.getPositions(
      active: true,
    );

    final nextState = detailResult.fold<BhpUserPositionStandardState>(
      (error) => BhpUserPositionStandardError(message: error.message),
      (detail) => positionsResult.fold<BhpUserPositionStandardState>(
        (error) => BhpUserPositionStandardError(message: error.message),
        (positions) {
          final selectedPositionId = _resolveInitialPositionId(
            positions: positions,
            detail: detail,
          );
          return BhpUserPositionStandardReady(
            detail: detail,
            positions: positions,
            standards: const [],
            selectedPositionId: selectedPositionId,
            isLoadingStandards: selectedPositionId != null,
            isSaving: false,
          );
        },
      ),
    );

    emit(nextState);

    if (nextState case final BhpUserPositionStandardReady ready
        when ready.selectedPositionId != null) {
      await loadStandards(ready.selectedPositionId);
    }
  }

  /// Zmienia aktualnie wybrane stanowisko i przeładowuje standard.
  Future<void> changePosition(int? value) async {
    final currentState = state;
    if (currentState is! BhpUserPositionStandardReady ||
        value == null ||
        value == currentState.selectedPositionId ||
        currentState.isSaving) {
      return;
    }

    emit(
      currentState.copyWith(
        selectedPositionId: value,
        standards: const [],
        isLoadingStandards: true,
      ),
    );
    await loadStandards(value);
  }

  /// Ładuje standard dla wskazanego stanowiska.
  Future<void> loadStandards(int? positionId) async {
    final currentState = state;
    if (currentState is! BhpUserPositionStandardReady) {
      return;
    }

    if (positionId == null) {
      emit(
        currentState.copyWith(
          standards: const [],
          isLoadingStandards: false,
          clearSelectedPositionId: true,
        ),
      );
      return;
    }

    final requestId = ++_standardsRequestId;
    final result = await _positionsRepository.getPositionStandards(positionId);
    if (state case final BhpUserPositionStandardReady latestState) {
      if (latestState.selectedPositionId != positionId ||
          requestId != _standardsRequestId) {
        return;
      }
      result.fold(
        (error) => emit(
          latestState.copyWith(
            standards: const [],
            isLoadingStandards: false,
            standardsError: error.message,
          ),
        ),
        (standards) => emit(
          latestState.copyWith(
            standards: standards,
            isLoadingStandards: false,
            clearStandardsError: true,
          ),
        ),
      );
    }
  }

  /// Zapisuje zmianę stanowiska pracownika.
  Future<Either<ApiError, GetBhpUserListItem>> save() async {
    final currentState = state;
    if (currentState is! BhpUserPositionStandardReady ||
        currentState.selectedPositionId == null ||
        currentState.isSaving) {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Brak danych do zapisania stanowiska.',
        ),
      );
    }

    final detail = currentState.detail;
    final imie = detail.imie?.trim().isNotEmpty == true
        ? detail.imie!.trim()
        : _user.imie?.trim() ?? '';
    final nazwisko = detail.nazwisko?.trim().isNotEmpty == true
        ? detail.nazwisko!.trim()
        : _user.nazwisko?.trim() ?? '';

    if (imie.isEmpty || nazwisko.isEmpty) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message: 'Nie udało się zapisać zmian, brakuje imienia lub nazwiska.',
        ),
      );
    }

    final selectedPositionId = currentState.selectedPositionId;
    if (selectedPositionId == null) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message: 'Nie wybrano stanowiska do zapisania.',
        ),
      );
    }

    emit(currentState.copyWith(isSaving: true));
    final result = await _usersRepository.updateUser(
      _user.id,
      PostBhpUserRequest(
        imie: imie,
        nazwisko: nazwisko,
        stanowiskoId: selectedPositionId,
        pesel: detail.pesel,
        numerTelefonu: detail.numerTelefonu,
        readyId: detail.readyId,
        dataRozpPracy: detail.dataRozpPracy,
        dataZakPracy: detail.dataZakPracy,
        miejsceZamieszkania: detail.miejsceZamieszkania,
        wzrost: detail.wzrost,
        obwodKlatkiPiers: detail.obwodKlatkiPiers,
        obwodPasa: detail.obwodPasa,
        obwodGlowy: detail.obwodGlowy,
        dlStopy: detail.dlStopy,
        uwagi: detail.uwagi,
      ),
    );
    emit(currentState.copyWith(isSaving: false));
    return result;
  }

  int? _resolveInitialPositionId({
    required List<GetBhpPositionListItem> positions,
    required GetBhpUserDetail detail,
  }) {
    final currentId = detail.stanowiskoId ?? _user.stanowiskoId;
    if (currentId case final id? when positions.any((item) => item.id == id)) {
      return id;
    }
    return null;
  }
}
