import 'package:web/web.dart' as web;

/// Odczytuje wartość tokenu CSRF z ciasteczka `devplanner.csrf` w przeglądarce.
///
/// Backend BFF ustawia to ciasteczko bez flagi `HttpOnly`, aby kod Flutter Web
/// mógł przesłać nagłówek synchronizacyjny `X-DevPlanner-CSRF` przy żądaniach mutujących.
final class CsrfCookieReader {
  const CsrfCookieReader();

  String? read() {
    final cookieString = web.document.cookie;
    if (cookieString.isEmpty) {
      return null;
    }

    final cookies = cookieString.split(';');
    for (final cookie in cookies) {
      final trimmed = cookie.trim();
      if (trimmed.startsWith('devplanner.csrf=')) {
        final value = trimmed.substring('devplanner.csrf='.length).trim();
        return value.isNotEmpty ? value : null;
      }
    }

    return null;
  }
}
