import 'package:dartz/dartz.dart';
import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:devplanner/admin/domain/ports/admin_user_gateway.dart';
import 'package:devplanner/admin/presentation/admin_users_page.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_form_cubit.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_form_state.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_roles_cubit.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_roles_state.dart';
import 'package:devplanner/admin/presentation/cubit/admin_users_cubit.dart';
import 'package:devplanner/admin/presentation/cubit/admin_users_state.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdminUsersCubit', () {
    test('loads the page through the typed gateway', () async {
      final gateway = _FakeAdminUserGateway();
      final cubit = AdminUsersCubit(
        composition: _composition(gateway),
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state, isA<AdminUsersReady>());
      expect((cubit.state as AdminUsersReady).users.single.userId, 'user-1');
      expect(gateway.lastQuery, const AdminUserQuery());
    });
  });

  group('AdminUserRolesCubit', () {
    test(
      'blocks self privilege escalation before gateway invocation',
      () async {
        final gateway = _FakeAdminUserGateway();
        final cubit = AdminUserRolesCubit(
          composition: _composition(gateway),
        );
        addTearDown(cubit.close);

        await cubit.save(
          userId: 'admin-1',
          roles: const {AdminRoleCodes.systemAdmin},
        );

        expect(cubit.state, isA<AdminUserRolesFailure>());
        expect((cubit.state as AdminUserRolesFailure).isSelfEscalation, isTrue);
        expect(gateway.setRolesCalls, 0);
      },
    );
  });

  group('AdminUserFormCubit', () {
    test('does not submit an invalid local form', () async {
      final gateway = _FakeAdminUserGateway();
      final cubit = AdminUserFormCubit(composition: _composition(gateway));
      addTearDown(cubit.close);

      await cubit.create(login: '', email: '', displayName: '');

      expect(cubit.state, isA<AdminUserFormFailure>());
      expect((cubit.state as AdminUserFormFailure).isValidation, isTrue);
      expect(gateway.createCalls, 0);
    });
  });

  testWidgets('unavailable composition renders a fail-closed state', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _LocalizedApp(child: AdminUsersUnavailablePage()),
    );

    expect(
      find.text('Administracja użytkownikami niedostępna'),
      findsOneWidget,
    );
    expect(find.textContaining('Transport administracji'), findsOneWidget);
  });

  testWidgets('missing read permission does not render account controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      _LocalizedApp(
        child: AdminUsersPage(
          composition: _composition(
            _FakeAdminUserGateway(),
            permissions: const <String>{},
          ),
        ),
      ),
    );

    expect(find.text('Brak uprawnień'), findsOneWidget);
    expect(find.text('Utwórz konto'), findsNothing);
  });
}

AdminUsersComposition _composition(
  _FakeAdminUserGateway gateway, {
  String currentUserId = 'admin-1',
  Set<String> permissions = const {'users.read', 'users.manage'},
}) => AdminUsersComposition(
  gateway: gateway,
  currentUserId: currentUserId,
  permissions: permissions,
);

final class _FakeAdminUserGateway implements AdminUserGateway {
  int createCalls = 0;
  int setRolesCalls = 0;
  AdminUserQuery? lastQuery;

  @override
  Future<Either<ApiError, AdminUserPage>> list(AdminUserQuery query) async {
    lastQuery = query;
    return const Right<ApiError, AdminUserPage>(
      AdminUserPage(
        users: [
          AdminUser(
            userId: 'user-1',
            login: 'user',
            email: 'user@example.test',
            displayName: 'User',
            status: AdminUserStatus.active,
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<ApiError, AdminUser>> create(
    AdminUserCreateCommand command,
  ) async {
    createCalls++;
    return const Left<ApiError, AdminUser>(
      ApiError(type: ApiErrorType.unknown, message: 'unused'),
    );
  }

  @override
  Future<Either<ApiError, AdminUser>> update(
    AdminUserUpdateCommand command,
  ) async => const Left<ApiError, AdminUser>(
    ApiError(type: ApiErrorType.unknown, message: 'unused'),
  );

  @override
  Future<Either<ApiError, AdminUserRolesResult>> setRoles(
    AdminUserRoleCommand command,
  ) async {
    setRolesCalls++;
    return const Left<ApiError, AdminUserRolesResult>(
      ApiError(type: ApiErrorType.unknown, message: 'unused'),
    );
  }

  @override
  Future<Either<ApiError, AdminUserLifecycleResult>> lifecycle(
    AdminUserLifecycleCommand command,
  ) async => const Left<ApiError, AdminUserLifecycleResult>(
    ApiError(type: ApiErrorType.unknown, message: 'unused'),
  );
}

class _LocalizedApp extends StatelessWidget {
  const _LocalizedApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}
