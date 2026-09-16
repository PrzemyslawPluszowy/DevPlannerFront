/// Minimalny placeholder pod przyszla warstwe komunikacji HTTP.
///
/// Na razie trzyma tylko konfiguracje potrzebna do wywolan API.
class ApiClient {
  const ApiClient({required this.baseUrl, required this.accessToken});

  final String? baseUrl;
  final String? accessToken;
}
