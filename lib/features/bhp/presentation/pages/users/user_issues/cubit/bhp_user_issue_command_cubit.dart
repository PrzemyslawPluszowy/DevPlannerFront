import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_command_state.dart';

/// Lokalny cubit komend modyfikujących wydania BHP w scope konkretnego modala.
class BhpUserIssueCommandCubit extends Cubit<BhpUserIssueCommandState> {
  /// Tworzy lokalny cubit komend dla wskazanego pracownika.
  BhpUserIssueCommandCubit({
    required this._repository,
    required this._userId,
    required this._inProgressMessage,
  }) : super(const BhpUserIssueCommandIdle());

  final BhpUsersRepository _repository;
  final int _userId;
  final String _inProgressMessage;

  /// Dodaje nowe wydanie wyposażenia pracownika.
  Future<Either<ApiError, Unit>> addIssue(
    PostBhpUserIssueRequest request,
  ) {
    return _run(() => _repository.createUserIssue(_userId, request));
  }

  /// Aktualizuje istniejące wydanie wyposażenia pracownika.
  Future<Either<ApiError, Unit>> updateIssue(
    int issueId,
    PatchBhpUserIssueRequest request,
  ) {
    return _run(() => _repository.updateUserIssue(_userId, issueId, request));
  }

  /// Usuwa błędnie zapisane wydanie wyposażenia pracownika.
  Future<Either<ApiError, Unit>> deleteIssue(int issueId) {
    return _run(() => _repository.deleteUserIssue(_userId, issueId));
  }

  /// Powtarza zakończone wydanie wyposażenia pracownika.
  Future<Either<ApiError, Unit>> repeatIssue(int issueId) {
    return _run(() => _repository.repeatUserIssue(_userId, issueId));
  }

  /// Zamyka aktywne wydanie wyposażenia.
  Future<Either<ApiError, Unit>> closeIssue(
    int issueId,
    PostCloseBhpUserIssueRequest request,
  ) {
    return _run(() => _repository.closeIssue(_userId, issueId, request));
  }

  Future<Either<ApiError, Unit>> _run<T>(
    Future<Either<ApiError, T>> Function() operation,
  ) async {
    if (state.isSubmitting) {
      return Left(
        ApiError(
          type: ApiErrorType.conflict,
          message: _inProgressMessage,
        ),
      );
    }

    emit(const BhpUserIssueCommandSubmitting());
    final result = await operation();
    emit(const BhpUserIssueCommandIdle());
    return result.fold(Left.new, (_) => const Right(unit));
  }
}
