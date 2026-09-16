import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/assign_from_standard/cubit/bhp_assign_user_issues_from_standard_state.dart';

/// Lokalny cubit flow dopisywania wydań ze standardu stanowiska.
class BhpAssignUserIssuesFromStandardCubit
    extends Cubit<BhpAssignUserIssuesFromStandardState> {
  /// Tworzy cubit dopisywania wydań dla wskazanego pracownika.
  BhpAssignUserIssuesFromStandardCubit({
    required this._repository,
    required this._userId,
  }) : super(const BhpAssignUserIssuesFromStandardLoading());

  final BhpUsersRepository _repository;
  final int _userId;

  /// Ładuje szczegóły pracownika oraz standard stanowiska.
  Future<void> load() async {
    emit(const BhpAssignUserIssuesFromStandardLoading());

    final result = await _repository.getUserDetails(_userId);
    result.fold(
      (error) => emit(
        BhpAssignUserIssuesFromStandardError(message: error.message),
      ),
      (detail) {
        final activeIssueCardIds = detail.wydaniaAktywne
            .map((issue) => issue.kartaWyposazeniaId)
            .whereType<int>()
            .toSet();
        final entries = detail.standardWyposazenia
            .map(
              (standard) => BhpStandardIssueSelectionEntry(
                standard: standard,
                activeIssueCardIds: activeIssueCardIds,
              ),
            )
            .toList(growable: false);
        final selectedIds = entries
            .where((entry) => entry.isSelectable)
            .map((entry) => entry.standard.id)
            .toSet();

        emit(
          BhpAssignUserIssuesFromStandardReady(
            detail: detail,
            entries: entries,
            selectedStandardIds: selectedIds,
            isSaving: false,
          ),
        );
      },
    );
  }

  /// Przełącza zaznaczenie wskazanej pozycji standardu.
  void toggleSelection(int standardId) {
    if (state case final BhpAssignUserIssuesFromStandardReady ready
        when !ready.isSaving) {
      final selected = Set<int>.of(ready.selectedStandardIds);
      if (!selected.add(standardId)) {
        selected.remove(standardId);
      }
      emit(ready.copyWith(selectedStandardIds: selected));
    }
  }

  /// Wysyła zaznaczone pozycje standardu do backendu.
  Future<Either<ApiError, Unit>> submit() async {
    final currentState = state;
    if (currentState is! BhpAssignUserIssuesFromStandardReady ||
        currentState.isSaving ||
        currentState.selectedStandardIds.isEmpty) {
      return const Right(unit);
    }

    emit(currentState.copyWith(isSaving: true));
    final result = await _repository.assignIssuesFromStandard(
      _userId,
      currentState.selectedStandardIds.toList(growable: false),
    );
    emit(currentState.copyWith(isSaving: false));

    return result.fold(Left.new, (_) => const Right(unit));
  }
}
