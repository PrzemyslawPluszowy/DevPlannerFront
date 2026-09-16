import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_equivalent_command_state.dart';

/// Lokalny cubit komend biznesowych związanych z ekwiwalentem wydania BHP.
class BhpUserIssueEquivalentCommandCubit
    extends Cubit<BhpUserIssueEquivalentCommandState> {
  /// Tworzy lokalny cubit komend ekwiwalentu dla wskazanego pracownika.
  BhpUserIssueEquivalentCommandCubit({
    required this._repository,
    required this._userId,
    required this._inProgressMessage,
  }) : super(const BhpUserIssueEquivalentCommandIdle());

  final BhpUsersRepository _repository;
  final int _userId;
  final String _inProgressMessage;

  /// Rejestruje lub aktualizuje ekwiwalent dla wydania wyposażenia.
  Future<Either<ApiError, Unit>> registerEquivalent(
    int issueId,
    PostBhpUserIssueEquivalentRequest request,
  ) {
    return _run(
      () => _repository.registerIssueEquivalent(_userId, issueId, request),
    );
  }

  /// Usuwa zarejestrowany ekwiwalent z wydania wyposażenia.
  Future<Either<ApiError, Unit>> deleteEquivalent(int issueId) {
    return _run(() => _repository.deleteIssueEquivalent(_userId, issueId));
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

    emit(const BhpUserIssueEquivalentCommandSubmitting());
    final result = await operation();
    emit(const BhpUserIssueEquivalentCommandIdle());
    return result.fold(Left.new, (_) => const Right(unit));
  }
}
