import 'package:devplanner/workspaces/domain/repositories/okr_repository.dart';
import 'package:devplanner/workspaces/presentation/okr/cubit/okr_objective_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Ładuje jeden cel OKR bez wywołań sieciowych w widgetach.
final class OkrObjectiveDetailsCubit extends Cubit<OkrObjectiveDetailsState> {
  OkrObjectiveDetailsCubit({
    required this._repository,
    required this.workspaceId,
    required this.objectiveId,
  }) : super(const OkrObjectiveDetailsInitial());

  final OkrRepository _repository;
  final String workspaceId;
  final String objectiveId;

  /// Pobiera dane ponownie po błędzie backendu.
  Future<void> load() async {
    emit(const OkrObjectiveDetailsLoading());
    final result = await _repository.getObjective(
      workspaceId: workspaceId,
      objectiveId: objectiveId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        OkrObjectiveDetailsFailure(
          message: error.message,
          backendCode: error.backendCode,
        ),
      ),
      (objective) => emit(OkrObjectiveDetailsLoaded(objective)),
    );
  }
}
