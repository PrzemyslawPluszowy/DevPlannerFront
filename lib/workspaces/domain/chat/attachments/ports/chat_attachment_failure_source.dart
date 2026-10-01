import 'package:devplanner/foundation/error/api_error.dart';

/// Bezpieczny błąd przygotowania pliku, odczytywany przed unieważnieniem ownera.
abstract interface class ChatAttachmentFailureSource {
  ApiError? get uploadError;
}
