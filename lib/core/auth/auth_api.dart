import 'package:dio/dio.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

/// Kontrakt używany przez repozytorium do obsługi sesji Core.
abstract interface class AuthApi {
  /// Loguje użytkownika i zwraca parę tokenów Core.
  Future<AuthTokenPair> login(LoginRequest body);

  /// Odświeża lokalną sesję na podstawie refresh tokena Core.
  Future<AuthTokenPair> refreshToken({required String refreshToken});
}

/// Klient Retrofit dla ścisłego kontraktu HTTP Veloryn Core.
///
/// Swagger: http://127.0.0.1:8080/swagger
@RestApi()
abstract class CoreAuthApi {
  /// Tworzy klienta `CoreAuthApi` opartego o wspólne `Dio`.
  factory CoreAuthApi(Dio dio, {String? baseUrl}) = _CoreAuthApi;

  /// Loguje uzytkownika i zwraca token oraz refresh token.
  @POST('/auth/login')
  Future<AuthTokenPair> login(@Body() LoginRequest body);

  /// Odswieza token dostepowy na podstawie refresh tokena.
  @POST('/auth/refresh')
  Future<AuthTokenPair> refreshToken(@Body() RefreshRequest body);
}

/// Adapter oddzielający kod sesji od formatu żądania Retrofit.
class DioAuthApi implements AuthApi {
  /// Tworzy adapter na bazie klienta HTTP Veloryn Core.
  DioAuthApi({required this._api});

  final CoreAuthApi _api;

  @override
  Future<AuthTokenPair> login(LoginRequest body) => _api.login(body);

  @override
  Future<AuthTokenPair> refreshToken({required String refreshToken}) {
    return _api.refreshToken(RefreshRequest(refreshToken: refreshToken));
  }
}

/// Zapytanie odświeżenia lokalnej sesji Core.
class RefreshRequest {
  /// Tworzy payload odświeżenia z aktualnego refresh tokena Core.
  const RefreshRequest({required this.refreshToken});

  /// Jednorazowy refresh token wydany przez Core.
  final String refreshToken;

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}
