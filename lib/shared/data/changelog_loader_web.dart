import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Pobiera changelog na Web z pominięciem cache przeglądarki.
Future<String> loadFreshChangelogImpl(String assetPath) async {
  final assetUri = Uri.parse(web.document.baseURI)
      .resolve('assets/$assetPath')
      .replace(
        queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
  final response = await web.window
      .fetch(
        assetUri.toString().toJS,
        web.RequestInit(cache: 'no-store'),
      )
      .toDart;

  if (!response.ok) {
    throw StateError(
      'Nie udało się pobrać changeloga (HTTP ${response.status}).',
    );
  }

  return (await response.text().toDart).toDart;
}
