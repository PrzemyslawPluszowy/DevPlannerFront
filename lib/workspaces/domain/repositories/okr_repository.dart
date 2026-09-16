import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/okr/models/okr_models.dart';

/// Kontrakt odczytu celu OKR dla bezpośrednich tras powiadomień.
// ignore: one_member_abstracts
abstract interface class OkrRepository {
  /// Pobiera cel wraz z jego kluczowymi rezultatami.
  Future<Either<ApiError, ObjectiveResponse>> getObjective({
    required String workspaceId,
    required String objectiveId,
  });
}
