import 'package:devplanner/foundation/error/api_error.dart';

/// Niemutowalny wynik pojedynczej komendy tworzenia zasobu projektu.
///
/// Stan nie zawiera `BuildContext` ani danych formularza. Formularz pozostaje
/// lokalny dla dialogu, a Cubit publikuje wyłącznie lifecycle zapisu.
final class ProjectResourceCreationCommandState {
  const ProjectResourceCreationCommandState._({
    required this.isSubmitting,
    this.error,
    this.createdResourceId,
  });

  const ProjectResourceCreationCommandState.idle()
    : this._(isSubmitting: false);

  const ProjectResourceCreationCommandState.submitting()
    : this._(isSubmitting: true);

  const ProjectResourceCreationCommandState.failure(ApiError error)
    : this._(isSubmitting: false, error: error);

  const ProjectResourceCreationCommandState.success(String resourceId)
    : this._(isSubmitting: false, createdResourceId: resourceId);

  final bool isSubmitting;
  final ApiError? error;
  final String? createdResourceId;
}
