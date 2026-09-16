import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/auth_redirect_policy.dart';
import 'package:ready_next/core/auth/auth_state.dart';

void main() {
  group('auth redirect policy', () {
    test(
      'zachowuje deep link przeglądarki zamiast nadpisywać go launch path',
      () {
        expect(
          resolveInitialDeepLinkPath(
            incomingPath: '/workspaces/11111111-1111-4111-8111-111111111111',
            launchPath: '/dashboard',
          ),
          '/workspaces/11111111-1111-4111-8111-111111111111',
        );
      },
    );

    test('używa launch path przy wejściu na root', () {
      expect(
        resolveInitialDeepLinkPath(
          incomingPath: '/',
          launchPath: '/dashboard',
        ),
        '/dashboard',
      );
    });

    test('desktop ignoruje Uri.base i przechodzi przez ekran startowy', () {
      expect(
        resolvePlatformInitialLocation(
          platformUri: Uri.parse(
            'file:///Users/example/projects/ready_next/',
          ),
          isWeb: false,
          launchPath: '/orders',
        ),
        '/',
      );
    });

    test('web zachowuje path, query i fragment z adresu przeglądarki', () {
      expect(
        resolvePlatformInitialLocation(
          platformUri: Uri.parse(
            'https://ready.example/workspaces/11111111-1111-4111-8111-111111111111?view=list#task',
          ),
          isWeb: true,
          launchPath: '/dashboard',
        ),
        '/workspaces/11111111-1111-4111-8111-111111111111?view=list#task',
      );
    });

    test('zachowuje query i fragment platformowego deep linku', () {
      expect(
        resolveInitialDeepLinkPath(
          incomingPath: '/inventory/stock?tab=expired#filters',
          launchPath: '/dashboard',
        ),
        '/inventory/stock?tab=expired#filters',
      );
    });

    test('buildLoginPath dokleja redirect dla chronionej trasy', () {
      expect(
        buildLoginPath(redirectTo: AppRoutePaths.orders),
        '/login?redirect=%2Forders',
      );
    });

    test('buildLoginPath nie dokleja redirectu dla samego loginu', () {
      expect(
        buildLoginPath(redirectTo: AppRoutePaths.login),
        AppRoutePaths.login,
      );
    });

    test('resolvePostLoginPath zwraca redirect z query gdy istnieje', () {
      expect(
        resolvePostLoginPath(
          currentLocation: '/login?redirect=%2Finventory%2Fstock',
          fallbackPath: AppRoutePaths.dashboard,
        ),
        AppRoutePaths.inventoryStock,
      );
    });

    test('resolvePostLoginPath wraca do fallbacku gdy brak redirectu', () {
      expect(
        resolvePostLoginPath(
          currentLocation: AppRoutePaths.login,
          fallbackPath: AppRoutePaths.orders,
        ),
        AppRoutePaths.orders,
      );
    });

    test('redirect zachowuje query params i fragment', () {
      final loginPath = buildLoginPath(
        redirectTo: '/inventory/stock?tab=expired&sort=asc#filters',
      );

      expect(
        resolvePostLoginPath(
          currentLocation: loginPath,
          fallbackPath: AppRoutePaths.dashboard,
        ),
        '/inventory/stock?tab=expired&sort=asc#filters',
      );
    });

    test('shouldRedirectToLoginOnUnauthenticated ignoruje ekran loginu', () {
      expect(
        shouldRedirectToLoginOnUnauthenticated(
          state: const AuthUnauthenticated(),
          currentPath: AppRoutePaths.login,
        ),
        isFalse,
      );
    });
  });
}
