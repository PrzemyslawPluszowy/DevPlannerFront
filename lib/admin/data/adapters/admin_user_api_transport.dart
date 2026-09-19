/// Transport BFF/API dla chronionych zasobów administracji.
///
/// Implementacja pozostaje właścicielem cookies `HttpOnly`, CSRF i polityki
/// odświeżania sesji. Ten kontrakt celowo nie przyjmuje access/refresh tokenu.
// ignore: one_member_abstracts
abstract interface class AdminUserApiTransport {
  Future<AdminUserApiResponse> send(AdminUserApiRequest request);
}

enum AdminUserApiMethod { get, post, patch, put }

/// Niskopoziomowe, ale typowane żądanie przekazywane do istniejącej granicy
/// BFF/cookie. Ścieżka jest zawsze względna względem hosta API.
final class AdminUserApiRequest {
  const AdminUserApiRequest({
    required this.method,
    required this.path,
    this.query = const <String, String>{},
    this.body,
  });

  final AdminUserApiMethod method;
  final String path;
  final Map<String, String> query;
  final Map<String, Object?>? body;
}

/// Surowa odpowiedź transportu bez zależności od Dio/HTTP w domenie lub UI.
final class AdminUserApiResponse {
  const AdminUserApiResponse({
    required this.statusCode,
    this.body,
  });

  final int statusCode;
  final Object? body;
}
