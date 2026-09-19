import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/okr/models/okr_models.dart';
import 'package:devplanner/workspaces/domain/repositories/okr_repository.dart';
import 'package:devplanner/workspaces/presentation/okr/cubit/okr_objective_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/okr/cubit/okr_objective_details_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _OkrRepository implements OkrRepository {
  _OkrRepository(this.result);

  final Either<ApiError, ObjectiveResponse> result;

  @override
  Future<Either<ApiError, ObjectiveResponse>> getObjective({
    required String workspaceId,
    required String objectiveId,
  }) async => result;
}

void main() {
  blocTest<OkrObjectiveDetailsCubit, OkrObjectiveDetailsState>(
    'emituje cel OKR wraz z rezultatami',
    build: () => OkrObjectiveDetailsCubit(
      repository: _OkrRepository(
        Right(
          ObjectiveResponse(
            id: 'objective-1',
            workspaceId: 'workspace-1',
            createdByUserId: 'user-1',
            name: 'Stabilny produkt',
            progress: .5,
            keyResults: const [],
            createdAtUtc: DateTime(2026),
            updatedAtUtc: DateTime(2026),
            version: 1,
          ),
        ),
      ),
      workspaceId: 'workspace-1',
      objectiveId: 'objective-1',
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<OkrObjectiveDetailsLoading>(),
      isA<OkrObjectiveDetailsLoaded>().having(
        (state) => state.objective.name,
        'name',
        'Stabilny produkt',
      ),
    ],
  );
}
