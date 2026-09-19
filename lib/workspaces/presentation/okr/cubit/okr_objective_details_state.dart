import 'package:devplanner/workspaces/data/okr/models/okr_models.dart';

/// Stany szczegółu celu OKR z deep-linku.
sealed class OkrObjectiveDetailsState {
  const OkrObjectiveDetailsState();
}

final class OkrObjectiveDetailsInitial extends OkrObjectiveDetailsState {
  const OkrObjectiveDetailsInitial();
}

final class OkrObjectiveDetailsLoading extends OkrObjectiveDetailsState {
  const OkrObjectiveDetailsLoading();
}

final class OkrObjectiveDetailsLoaded extends OkrObjectiveDetailsState {
  const OkrObjectiveDetailsLoaded(this.objective);

  final ObjectiveResponse objective;
}

final class OkrObjectiveDetailsFailure extends OkrObjectiveDetailsState {
  const OkrObjectiveDetailsFailure({required this.message, this.backendCode});

  final String message;
  final Object? backendCode;
}
