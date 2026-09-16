import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/ready_next_app.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_session_storage.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/inventory/presentation/inventory_home_page.dart';
import 'package:ready_next/features/orders/presentation/orders_home_page.dart';
import 'package:ready_next/shared/presentation/widgets/app_shell_wallpaper.dart';
import 'package:ready_next/shared/presentation/widgets/app_shimmer.dart';
import 'package:ready_next/shared/presentation/widgets/app_wallpaper_background.dart';
import 'package:ready_next/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home_page.dart';

import 'test_support/test_hive.dart';

class _MemoryAuthSessionStorage implements AuthSessionStorage {
  _MemoryAuthSessionStorage({this.session});

  StoredAuthSession? session;
  String? rememberedUsername;

  @override
  Future<void> clear() async {
    session = null;
  }

  @override
  Future<StoredAuthSession?> read() async => session;

  @override
  Future<String?> readRememberedUsername() async => rememberedUsername;

  @override
  Future<void> write({
    required String accessToken,
    required String refreshToken,
    String? userJson,
  }) async {
    session = StoredAuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userJson: userJson,
      rememberedUsername: rememberedUsername,
    );
  }

  @override
  Future<void> writeRememberedUsername(String username) async {
    rememberedUsername = username.trim();
  }
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    this._accessToken,
    this._currentUser,
  });

  String? _accessToken;
  AuthUser? _currentUser;

  @override
  String? get accessToken => _accessToken;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _accessToken != null && _accessToken!.isNotEmpty;

  @override
  int get sessionGeneration => 0;

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {}

  @override
  Future<void> logout() async {
    _accessToken = null;
    _currentUser = null;
  }

  @override
  Future<void> restoreSession() async {}

  @override
  Future<bool> tryRefreshSession() async => false;
}

class _MemoryDashboardPreferencesRepository
    implements DashboardPreferencesRepository {
  final Map<String, DashboardPreferences> _preferences = {};

  @override
  Future<void> close() async {}

  @override
  Future<DashboardPreferences> getPreferences({
    required String readyUserId,
  }) async =>
      _preferences[readyUserId] ??
      DashboardPreferences.defaults(readyUserId: readyUserId);

  @override
  Future<DashboardPreferences> savePreferences(
    DashboardPreferences preferences,
  ) async {
    _preferences[preferences.readyUserId] = preferences;
    return preferences;
  }

  @override
  Future<DashboardPreferences> updatePreferences({
    required String readyUserId,
    required DashboardPreferences Function(DashboardPreferences current) update,
  }) async {
    final next = update(await getPreferences(readyUserId: readyUserId));
    return savePreferences(next);
  }
}

Future<void> _disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  late Directory tempDir;
  late _MemoryAuthSessionStorage authSessionStorage;
  late _FakeAuthRepository authRepository;

  setUpAll(() async {
    tempDir = await initTestHive();
  });

  tearDownAll(() async {
    await disposeTestHive(tempDir);
  });

  setUp(() {
    authSessionStorage = _MemoryAuthSessionStorage(
      session: const StoredAuthSession(
        accessToken: 'token',
        refreshToken: 'refresh-token',
      ),
    );
    authRepository = _FakeAuthRepository(
      accessToken: 'token',
      currentUser: const AuthUser(
        userId: 42,
        username: 'jan',
        displayName: 'Jan Kowalski',
        email: 'jan@example.com',
      ),
    );
  });

  testWidgets('orders module starts from launch context', (
    tester,
  ) async {
    const launchContext = HostLaunchContext(
      initialRoute: '/orders',
      userId: '42',
      userDisplayName: 'Jan Kowalski',
    );

    await tester.pumpWidget(
      ReadyNextApp(
        launchContext: launchContext,
        authSessionStorage: authSessionStorage,
        authRepository: authRepository,
        dashboardPreferencesRepository: _MemoryDashboardPreferencesRepository(),
        enableNotificationsRealtime: false,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    final ordersTitle = find.descendant(
      of: find.byType(OrdersHomePage),
      matching: find.text('Zamówienia'),
    );
    expect(ordersTitle, findsOneWidget);
    expect(
      find.text('To jest drugi feature uruchamiany z tej samej aplikacji.'),
      findsOneWidget,
    );
    await _disposeApp(tester);
  });

  testWidgets('po logout z poziomu auth cubit wraca do ekranu logowania', (
    tester,
  ) async {
    const launchContext = HostLaunchContext(
      initialRoute: '/orders',
      userId: '42',
      userDisplayName: 'Jan Kowalski',
    );

    await tester.pumpWidget(
      ReadyNextApp(
        launchContext: launchContext,
        authSessionStorage: authSessionStorage,
        authRepository: authRepository,
        dashboardPreferencesRepository: _MemoryDashboardPreferencesRepository(),
        enableNotificationsRealtime: false,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    final ordersTitle = find.descendant(
      of: find.byType(OrdersHomePage),
      matching: find.text('Zamówienia'),
    );
    expect(ordersTitle, findsOneWidget);

    final ordersTitleContext = tester.element(ordersTitle);
    final authCubit = ordersTitleContext.read<AuthCubit>();

    await authCubit.logout();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Zaloguj się, aby przejść do modułów.'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Hasło'), findsOneWidget);
    await _disposeApp(tester);
  });

  testWidgets('workspaces uruchamia ładowanie i zachowuje wspólne tło', (
    tester,
  ) async {
    const launchContext = HostLaunchContext(
      initialRoute: '/workspaces',
      userId: '42',
      userDisplayName: 'Jan Kowalski',
    );

    await tester.pumpWidget(
      ReadyNextApp(
        launchContext: launchContext,
        authSessionStorage: authSessionStorage,
        authRepository: authRepository,
        dashboardPreferencesRepository: _MemoryDashboardPreferencesRepository(),
        enableNotificationsRealtime: false,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(WorkspacesHomePage), findsOneWidget);
    expect(find.byType(AppShellWallpaper), findsOneWidget);
    expect(find.byType(AppWallpaperBackground), findsOneWidget);
    expect(
      tester
          .element(find.byType(WorkspacesHomePage))
          .read<WorkspaceScopedRealtimeFactory>(),
      isA<WorkspaceScopedRealtimeFactory>(),
    );
    expect(
      find.descendant(
        of: find.byType(WorkspacesHomePage),
        matching: find.byType(AppShimmerContent),
      ),
      findsNothing,
    );
    await _disposeApp(tester);
  });

  testWidgets('zapisany modul startowy nadpisuje top-level trase hosta', (
    tester,
  ) async {
    const readyUserId = '84';
    final repository = _MemoryDashboardPreferencesRepository();
    final startupAuthRepository = _FakeAuthRepository(
      accessToken: 'token',
      currentUser: const AuthUser(
        userId: 84,
        username: 'jan',
        displayName: 'Jan Kowalski',
        permissions: {ReadyPermissions.inventory},
      ),
    );
    await repository.savePreferences(
      DashboardPreferences.defaults(
        readyUserId: readyUserId,
      ).copyWith(startupModule: DashboardStartupModule.inventory),
    );

    const launchContext = HostLaunchContext(
      initialRoute: '/orders',
      userId: readyUserId,
      userDisplayName: 'Jan Kowalski',
    );

    await tester.pumpWidget(
      ReadyNextApp(
        launchContext: launchContext,
        authSessionStorage: authSessionStorage,
        authRepository: startupAuthRepository,
        dashboardPreferencesRepository: repository,
        enableNotificationsRealtime: false,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(InventoryHomePage), findsOneWidget);
    expect(find.byType(OrdersHomePage), findsNothing);
    await _disposeApp(tester);
  });
}
