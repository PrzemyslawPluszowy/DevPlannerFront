import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_bulk_repeat_command_state.dart';

/// Lokalny cubit komendy zbiorczego ponownego wydania pozycji BHP.
class BhpUserIssueBulkRepeatCommandCubit
    extends Cubit<BhpUserIssueBulkRepeatCommandState> {
  /// Tworzy lokalny cubit komendy zbiorczego ponownego wydania.
  BhpUserIssueBulkRepeatCommandCubit({
    required this._repository,
    required this._userId,
    required this._inProgressMessage,
  }) : super(const BhpUserIssueBulkRepeatCommandIdle());

  final BhpUsersRepository _repository;
  final int _userId;
  final String _inProgressMessage;

  /// Ponownie wystawia wybrane pozycje z jedną wspólną datą.
  Future<Either<ApiError, int>> repeatIssues(
    PostBhpUserIssuesRepeatRequest request,
  ) async {
    if (state.isSubmitting) {
      return Left(
        ApiError(
          type: ApiErrorType.conflict,
          message: _inProgressMessage,
        ),
      );
    }

    emit(const BhpUserIssueBulkRepeatCommandSubmitting());
    final result = await _repository.repeatUserIssues(_userId, request);
    emit(const BhpUserIssueBulkRepeatCommandIdle());

    return result.fold(
      Left.new,
      (items) => Right(items.length),
    );
  }
}
