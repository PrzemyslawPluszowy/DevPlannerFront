import 'package:devplanner/me/data/me_api_adapter.dart';
import 'package:devplanner/me/domain/ports/me_gateway.dart';
import 'package:devplanner/me/presentation/cubit/change_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit obsługujący walidację i wysyłkę formularza zmiany hasła.
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({required this.gateway})
    : super(const ChangePasswordInitial());

  final MeGateway gateway;

  /// Waliduje dane wejściowe i wysyła polecenie zmiany hasła do serwera.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty) {
      emit(
        const ChangePasswordFailure(
          message: 'Podaj aktualne hasło.',
          code: 'CURRENT_PASSWORD_REQUIRED',
        ),
      );
      return;
    }

    if (newPassword.length < 15) {
      emit(
        const ChangePasswordFailure(
          message: 'Nowe hasło musi zawierać co najmniej 15 znaków.',
          code: 'PASSWORD_TOO_SHORT',
        ),
      );
      return;
    }

    if (newPassword.length > 128) {
      emit(
        const ChangePasswordFailure(
          message: 'Nowe hasło może zawierać maksymalnie 128 znaków.',
          code: 'PASSWORD_TOO_LONG',
        ),
      );
      return;
    }

    if (newPassword == currentPassword) {
      emit(
        const ChangePasswordFailure(
          message: 'Nowe hasło musi różnić się od aktualnego.',
          code: 'PASSWORD_SAME_AS_CURRENT',
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      emit(
        const ChangePasswordFailure(
          message: 'Wprowadzone hasła nie są identyczne.',
          code: 'PASSWORDS_DO_NOT_MATCH',
        ),
      );
      return;
    }

    emit(const ChangePasswordSubmitting());
    try {
      await gateway.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      emit(
        const ChangePasswordSuccess(
          message: 'Hasło zostało pomyślnie zmienione.',
        ),
      );
    } on MeApiException catch (e) {
      emit(
        ChangePasswordFailure(
          message: e.message,
          code: e.code,
          traceId: e.traceId,
        ),
      );
    } catch (e) {
      emit(
        ChangePasswordFailure(
          message: 'Wystąpił błąd podczas zmiany hasła: $e',
        ),
      );
    }
  }

  /// Resetuje formularz i stan do wartości początkowej.
  void reset() {
    emit(const ChangePasswordInitial());
  }
}
