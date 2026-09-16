import 'dart:convert';

/// Wynik eksportu dokumentu z adresem i rzeczywistym formatem.
typedef OnlyOfficeDownload = ({String url, String fileType});

/// Wynik żądania zapisu kopii dokumentu z adresem, formatem i opcjonalnym tytułem.
typedef OnlyOfficeSaveAs = ({String url, String fileType, String? title});

/// Waliduje zdarzenia DocsAPI bez przekazywania tokenów i adresów do logów.
final class OnlyOfficeBridge {
  const OnlyOfficeBridge._();

  /// Akceptuje wyłącznie adresy wyników z tego samego serwera dokumentów lub lokalnego loopbacku.
  static OnlyOfficeDownload? download(Object? data, Uri server) {
    if (data is! Map || data['url'] is! String) return null;
    final rawUrl = (data['url'] as String).trim();
    if (rawUrl.isEmpty) return null;

    final uri = Uri.tryParse(rawUrl);
    if (uri == null) return null;

    final resolved = uri.hasScheme ? uri : server.resolveUri(uri);
    final rawType = data['fileType'];

    if (!{'https', 'http'}.contains(resolved.scheme) ||
        !_isSameOriginOrLoopback(resolved, server) ||
        resolved.userInfo.isNotEmpty ||
        resolved.hasFragment) {
      return null;
    }

    String? type;
    if (rawType is String && rawType.trim().isNotEmpty) {
      type = rawType.trim().toLowerCase();
      if (type.startsWith('.')) type = type.substring(1);
    } else if (resolved.pathSegments.isNotEmpty) {
      final last = resolved.pathSegments.last;
      final dot = last.lastIndexOf('.');
      if (dot > 0 && dot < last.length - 1) {
        type = last.substring(dot + 1).toLowerCase();
      }
    }

    if (type == null || !RegExp(r'^[a-zA-Z0-9]{1,10}$').hasMatch(type)) {
      return null;
    }

    return (url: resolved.toString(), fileType: type);
  }

  /// Akceptuje zdarzenie zapisu kopii (Save Copy As) i waliduje adres URL oraz typ pliku.
  static OnlyOfficeSaveAs? saveAs(Object? data, Uri server) {
    final downloadResult = download(data, server);
    if (downloadResult == null) return null;

    String? title;
    if (data is Map && data['title'] is String) {
      final rawTitle = (data['title'] as String).trim();
      if (rawTitle.isNotEmpty) {
        title = rawTitle;
      }
    }

    return (
      url: downloadResult.url,
      fileType: downloadResult.fileType,
      title: title,
    );
  }

  static bool _isSameOriginOrLoopback(Uri uri, Uri server) {
    if (uri.scheme != server.scheme) return false;
    if (uri.origin == server.origin) return true;
    if (uri.port == server.port) {
      const loopbacks = {'localhost', '127.0.0.1', '::1'};
      if (loopbacks.contains(uri.host) && loopbacks.contains(server.host)) {
        return true;
      }
    }
    return false;
  }

  /// Ignoruje niepoprawną wiadomość zamiast wywoływać wyjątek w platform channel.
  static Map<String, dynamic>? decode(String message) {
    try {
      final value = jsonDecode(message);
      return value is Map<String, dynamic> ? value : null;
    } on FormatException {
      return null;
    }
  }
}
