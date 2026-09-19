import 'package:bloc_test/bloc_test.dart';
import 'package:devplanner/me/data/me_api_adapter.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:devplanner/me/domain/models/user_session_item.dart';
import 'package:devplanner/me/domain/ports/me_gateway.dart';
import 'package:devplanner/me/presentation/cubit/change_password_cubit.dart';
import 'package:devplanner/me/presentation/cubit/change_password_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Atrapa bramy MeGateway do testów jednostkowych zmiany hasła.
class _FakeMeGateway implements MeGateway {
  Exception? errorToThrow;
  String? lastCurrentPassword;
  String? lastNewPassword;

  @override
  Future<UserProfile> getProfile() async => throw UnimplementedError();

  @override
  Future<UserProfile> updateProfile({
    String? displayName,
    String? avatarFileId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    lastCurrentPassword = currentPassword;
    lastNewPassword = newPassword;
  }

  @override
  Future<List<UserSessionItem>> getSessions() async => const [];

  @override
  Future<void> revokeSession(String sessionId) async {}

  @override
  Future<void> uploadAvatar(List<int> bytes, String filename) async {}

  @override
  Future<void> deleteAvatar() async {}
}

void main() {
  group('ChangePasswordCubit', () {
    late _FakeMeGateway gateway;

    setUp(() {
      gateway = _FakeMeGateway();
    });

    test('stan początkowy to ChangePasswordInitial', () {
      final cubit = ChangePasswordCubit(gateway: gateway);
      expect(cubit.state, equals(const ChangePasswordInitial()));
    });

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emituje błąd gdy brakuje bieżącego hasła',
      build: () => ChangePasswordCubit(gateway: gateway),
      act: (cubit) => cubit.changePassword(
        currentPassword: '',
        newPassword: 'SuperSecret1234567!',
        confirmPassword: 'SuperSecret1234567!',
      ),
      expect: () => [
        const ChangePasswordFailure(
          message: 'Podaj aktualne hasło.',
          code: 'CURRENT_PASSWORD_REQUIRED',
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emituje błąd gdy nowe hasło ma mniej niż 15 znaków',
      build: () => ChangePasswordCubit(gateway: gateway),
      act: (cubit) => cubit.changePassword(
        currentPassword: 'CurrentPassword123!',
        newPassword: 'ShortPass123!',
        confirmPassword: 'ShortPass123!',
      ),
      expect: () => [
        const ChangePasswordFailure(
          message: 'Nowe hasło musi zawierać co najmniej 15 znaków.',
          code: 'PASSWORD_TOO_SHORT',
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emituje błąd gdy nowe hasło przekracza 128 znaków',
      build: () => ChangePasswordCubit(gateway: gateway),
      act: (cubit) => cubit.changePassword(
        currentPassword: 'CurrentPassword123!',
        newPassword: 'A' * 129,
        confirmPassword: 'A' * 129,
      ),
      expect: () => [
        const ChangePasswordFailure(
          message: 'Nowe hasło może zawierać maksymalnie 128 znaków.',
          code: 'PASSWORD_TOO_LONG',
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emituje błąd gdy nowe hasło jest identyczne z bieżącym',
      build: () => ChangePasswordCubit(gateway: gateway),
      act: (cubit) => cubit.changePassword(
        currentPassword: 'IdenticalPassword123!',
        newPassword: 'IdenticalPassword123!',
        confirmPassword: 'IdenticalPassword123!',
      ),
      expect: () => [
        const ChangePasswordFailure(
          message: 'Nowe hasło musi różnić się od aktualnego.',
          code: 'PASSWORD_SAME_AS_CURRENT',
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emituje błąd gdy powtórzone hasło różni się od nowego',
      build: () => ChangePasswordCubit(gateway: gateway),
      act: (cubit) => cubit.changePassword(
        currentPassword: 'CurrentPassword123!',
        newPassword: 'NewValidPassword123!',
        confirmPassword: 'DifferentPassword123!',
      ),
      expect: () => [
        const ChangePasswordFailure(
          message: 'Wprowadzone hasła nie są identyczne.',
          code: 'PASSWORDS_DO_NOT_MATCH',
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'poprawna zmiana hasła emituje Submitting oraz Success',
      build: () => ChangePasswordCubit(gateway: gateway),
      act: (cubit) => cubit.changePassword(
        currentPassword: 'OldSecretPassword123!',
        newPassword: 'NewSuperSecurePassword456!',
        confirmPassword: 'NewSuperSecurePassword456!',
      ),
      expect: () => [
        const ChangePasswordSubmitting(),
        const ChangePasswordSuccess(
          message: 'Hasło zostało pomyślnie zmienione.',
        ),
      ],
      verify: (_) {
        expect(gateway.lastCurrentPassword, equals('OldSecretPassword123!'));
        expect(gateway.lastNewPassword, equals('NewSuperSecurePassword456!'));
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emituje ChangePasswordFailure w przypadku błędu API (MeApiException)',
      build: () {
        gateway.errorToThrow = const MeApiException(
          message: 'Nieprawidłowe dotychczasowe hasło.',
          code: 'INVALID_CURRENT_PASSWORD',
          traceId: 'trace-pwd-123',
        );
        return ChangePasswordCubit(gateway: gateway);
      },
      act: (cubit) => cubit.changePassword(
        currentPassword: 'WrongPassword123!',
        newPassword: 'NewSuperSecurePassword456!',
        confirmPassword: 'NewSuperSecurePassword456!',
      ),
      expect: () => [
        const ChangePasswordSubmitting(),
        const ChangePasswordFailure(
          message: 'Nieprawidłowe dotychczasowe hasło.',
          code: 'INVALID_CURRENT_PASSWORD',
          traceId: 'trace-pwd-123',
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emituje ChangePasswordFailure w przypadku nieoczekiwanego wyjątku',
      build: () {
        gateway.errorToThrow = Exception('Brak połączenia');
        return ChangePasswordCubit(gateway: gateway);
      },
      act: (cubit) => cubit.changePassword(
        currentPassword: 'OldPassword123!',
        newPassword: 'NewSuperSecurePassword456!',
        confirmPassword: 'NewSuperSecurePassword456!',
      ),
      expect: () => [
        const ChangePasswordSubmitting(),
        isA<ChangePasswordFailure>().having(
          (f) => f.message,
          'message',
          contains('Brak połączenia'),
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'reset() przywraca stan początkowy ChangePasswordInitial',
      build: () => ChangePasswordCubit(gateway: gateway),
      seed: () => const ChangePasswordFailure(
        message: 'Błąd',
        code: 'ERR',
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [
        const ChangePasswordInitial(),
      ],
    );
  });
}
