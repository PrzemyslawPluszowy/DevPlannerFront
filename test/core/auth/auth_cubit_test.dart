import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_state.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;

  const user = AuthUser(
    userId: 7,
    username: 'tester',
    displayName: 'Test User',
    email: 'tester@example.com',
  );

  setUp(() {
    repository = _MockAuthRepository();
  });

  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'restoreSession emituje AuthLoading i AuthAuthenticated dla aktywnej sesji',
      setUp: () {
        when(() => repository.restoreSession()).thenAnswer((_) async {});
        when(() => repository.isAuthenticated).thenReturn(true);
        when(() => repository.currentUser).thenReturn(user);
      },
      build: () => AuthCubit(authRepository: repository),
      act: (cubit) => cubit.restoreSession(),
      expect: () => const <AuthState>[
        AuthLoading(),
        AuthAuthenticated(user: user),
      ],
      verify: (_) {
        verify(() => repository.restoreSession()).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'restoreSession emituje AuthLoading i AuthUnauthenticated gdy brak sesji',
      setUp: () {
        when(() => repository.restoreSession()).thenAnswer((_) async {});
        when(() => repository.isAuthenticated).thenReturn(false);
        when(() => repository.currentUser).thenReturn(null);
      },
      build: () => AuthCubit(authRepository: repository),
      act: (cubit) => cubit.restoreSession(),
      expect: () => const <AuthState>[
        AuthLoading(),
        AuthUnauthenticated(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'login emituje AuthLoading i AuthAuthenticated po sukcesie',
      setUp: () {
        when(
          () => repository.login(username: 'tester', password: 'secret'),
        ).thenAnswer((_) async {});
        when(() => repository.currentUser).thenReturn(user);
      },
      build: () => AuthCubit(authRepository: repository),
      act: (cubit) => cubit.login(username: 'tester', password: 'secret'),
      expect: () => const <AuthState>[
        AuthLoading(),
        AuthAuthenticated(user: user),
      ],
      verify: (_) {
        verify(
          () => repository.login(username: 'tester', password: 'secret'),
        ).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'login emituje komunikat backendowy dla AuthLoginException',
      setUp: () {
        when(
          () => repository.login(username: 'tester', password: 'secret'),
        ).thenThrow(const AuthLoginException('Bledny login lub haslo.'));
      },
      build: () => AuthCubit(authRepository: repository),
      act: (cubit) => cubit.login(username: 'tester', password: 'secret'),
      expect: () => const <AuthState>[
        AuthLoading(),
        AuthUnauthenticated(message: 'Bledny login lub haslo.'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'login emituje generyczny komunikat dla nieoczekiwanego bledu',
      setUp: () {
        when(
          () => repository.login(username: 'tester', password: 'secret'),
        ).thenThrow(Exception('network down'));
      },
      build: () => AuthCubit(authRepository: repository),
      act: (cubit) => cubit.login(username: 'tester', password: 'secret'),
      expect: () => const <AuthState>[
        AuthLoading(),
        AuthUnauthenticated(
          message: 'Nie udalo sie zalogowac. Sprobuj ponownie.',
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'logout emituje AuthLoading i AuthUnauthenticated oraz czyści repozytorium',
      setUp: () {
        when(() => repository.logout()).thenAnswer((_) async {});
      },
      build: () => AuthCubit(authRepository: repository),
      act: (cubit) => cubit.logout(),
      expect: () => const <AuthState>[
        AuthLoading(),
        AuthUnauthenticated(),
      ],
      verify: (_) {
        verify(() => repository.logout()).called(1);
      },
    );
  });
}
