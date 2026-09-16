import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issues_state.dart';

/// Cubit obsługujący stan wydań BHP konkretnego pracownika.
class BhpUserIssuesCubit extends Cubit<BhpUserIssuesState> {
  /// Tworzy cubit wydań pracownika BHP.
  BhpUserIssuesCubit({
    required this._userId,
    required this._repository,
  }) : super(const BhpUserIssuesInitial());

  final int _userId;
  final BhpUsersRepository _repository;

  /// Id pracownika, którego wydania są zarządzane.
  int get userId => _userId;

  /// Ładuje historię wydań pracownika BHP.
  Future<void> load() async {
    emit(const BhpUserIssuesLoading());

    final result = await _repository.getUserDetails(_userId);
    result.fold(
      (error) => emit(BhpUserIssuesError(message: error.message)),
      (detail) => emit(BhpUserIssuesSuccess(detail: detail)),
    );
  }

  /// Tworzy nowe ręczne wydanie wyposażenia dla pracownika.
  Future<Either<ApiError, Unit>> addIssue(
    PostBhpUserIssueRequest request,
  ) async {
    final result = await _repository.createUserIssue(_userId, request);
    return result.fold(
      Left.new,
      (_) async {
        await load();
        return const Right(unit);
      },
    );
  }

  /// Aktualizuje istniejące wydanie wyposażenia pracownika.
  Future<Either<ApiError, Unit>> updateIssue(
    int issueId,
    PatchBhpUserIssueRequest request,
  ) async {
    final result = await _repository.updateUserIssue(_userId, issueId, request);
    return result.fold(
      Left.new,
      (_) async {
        await load();
        return const Right(unit);
      },
    );
  }

  /// Usuwa błędnie zapisane wydanie wyposażenia pracownika.
  Future<Either<ApiError, Unit>> deleteIssue(int issueId) async {
    final result = await _repository.deleteUserIssue(_userId, issueId);
    return result.fold(
      Left.new,
      (_) async {
        await load();
        return const Right(unit);
      },
    );
  }

  /// Generuje brakujące wydania ze standardu stanowiska pracownika.
  Future<Either<ApiError, Unit>> assignFromStandard({
    List<int>? selectedStandardIds,
  }) async {
    final result = await _repository.assignIssuesFromStandard(
      _userId,
      selectedStandardIds,
    );
    return result.fold(
      Left.new,
      (_) async {
        await load();
        return const Right(unit);
      },
    );
  }

  /// Powtarza zakończone wydanie wyposażenia pracownika.
  Future<Either<ApiError, Unit>> repeatIssue(int issueId) async {
    final result = await _repository.repeatUserIssue(_userId, issueId);
    return result.fold(
      Left.new,
      (_) async {
        await load();
        return const Right(unit);
      },
    );
  }

  /// Zamyka aktywne wydanie wyposażenia (zwrot).
  Future<Either<ApiError, Unit>> closeIssue(
    int issueId,
    PostCloseBhpUserIssueRequest request,
  ) async {
    final result = await _repository.closeIssue(_userId, issueId, request);
    return result.fold(
      Left.new,
      (_) async {
        await load();
        return const Right(unit);
      },
    );
  }
}
