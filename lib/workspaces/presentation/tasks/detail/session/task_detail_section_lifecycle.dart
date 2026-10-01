import 'package:devplanner/foundation/error/api_error.dart';

/// Wspólne reguły aktualności odczytów i dostępu dla lokalnej gałęzi detalu.
final class TaskDetailSectionLifecycle {
  TaskDetailSectionLifecycle({
    required this.isClosed,
    this.canEdit,
    this.onAccessLost,
  });

  final bool Function() isClosed;
  final bool Function()? canEdit;
  final void Function(ApiError)? onAccessLost;
  int _generation = 0;

  int? begin() => isClosed() ? null : ++_generation;

  bool isCurrent(int generation) => !isClosed() && generation == _generation;

  bool get canMutate => !isClosed() && canEdit?.call() != false;

  void reportError(ApiError error) {
    if (isClosed()) return;
    if (error.type == ApiErrorType.unauthorized ||
        error.type == ApiErrorType.forbidden ||
        error.type == ApiErrorType.notFound) {
      onAccessLost?.call(error);
    }
  }

  void invalidate() => _generation++;
}
