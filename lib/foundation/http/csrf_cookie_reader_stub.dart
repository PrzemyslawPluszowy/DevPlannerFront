/// Domyślny stub odczytu ciasteczka CSRF dla środowisk innych niż przeglądarka.
///
/// Poza przeglądarką ciasteczka sesyjne przeglądarki i token CSRF nie występują.
final class CsrfCookieReader {
  const CsrfCookieReader();

  String? read() => null;
}
