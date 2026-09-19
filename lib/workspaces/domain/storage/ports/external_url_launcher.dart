import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';

/// Otwiera bezpieczny adres HTTP(S) w przeglądarce systemowej.
// ignore: one_member_abstracts, typed port keeps platform code outside presentation
abstract interface class ExternalUrlLauncher {
  /// Otwiera URL poza bieżącym widokiem aplikacji.
  Future<Either<ApiError, Unit>> open(String url);
}
