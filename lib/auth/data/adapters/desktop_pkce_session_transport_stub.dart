import 'package:devplanner/auth/data/adapters/desktop_pkce_auth_adapter.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';

final class PlatformDesktopPkceSessionTransport
    implements DesktopPkceSessionTransport {
  const PlatformDesktopPkceSessionTransport({required this.baseUrl});
  final String baseUrl;

  AuthFailure get _unavailable => const AuthFailure(
    'Logowanie desktopowe wymaga platformy IO.',
    code: 'auth.pkce.platform_unavailable',
  );

  @override
  Future<DesktopTokenResult> authorizeInteractively() async =>
      throw _unavailable;

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) async =>
      throw _unavailable;
  @override
  Future<DesktopTokenResult> completeAuthorization({
    required String code,
    required String state,
  }) async => throw _unavailable;
  @override
  Future<DesktopTokenResult?> restoreSession({
    required String refreshToken,
  }) async => throw _unavailable;
  @override
  Future<AuthUser> fetchCurrentUser({required String accessToken}) async =>
      throw _unavailable;
  @override
  Future<void> revoke({required String refreshToken}) async =>
      throw _unavailable;
}
