import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Dokument Blob zachowuje origin aplikacji, potrzebny protokołowi DocsAPI.
/// Srcdoc ma location.origin=null, mimo że dziedziczy dostęp rodzica.
final class OnlyOfficeHostDocument {
  String? _url;

  Uri create(String html) {
    dispose();
    final blob = web.Blob(
      [html.toJS].toJS,
      web.BlobPropertyBag(type: 'text/html;charset=utf-8'),
    );
    final url = web.URL.createObjectURL(blob);
    _url = url;
    return Uri.parse(url);
  }

  bool owns(Uri uri) => _url != null && uri.toString() == _url;

  void dispose() {
    final url = _url;
    _url = null;
    if (url != null) web.URL.revokeObjectURL(url);
  }
}
