import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/shared/presentation/widgets/app_global_utility_bar.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  String? get accessToken => null;

  @override
  AuthUser? get currentUser => null;

  @override
  bool get isAuthenticated => false;

  @override
  int get sessionGeneration => 0;

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> restoreSession() async {}

  @override
  Future<bool> tryRefreshSession() async => false;
}

AppRouter _router() {
  final authRepository = _FakeAuthRepository();
  Future<void> restore() async {}
  return AppRouter(
    authRepository: authRepository,
    ensureSessionRestored: restore,
  );
}

void main() {
  testWidgets('topbar pokazuje markę, kontekst i akcje globalne', (
    tester,
  ) async {
    final router = _router();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppGlobalUtilityBar(router: router),
      ),
    );

    expect(find.text('Ready Next'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(2));
  });
}
