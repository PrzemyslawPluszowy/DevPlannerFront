import 'package:flutter/services.dart';

/// Wczytuje changelog z pakietu aplikacji na platformach innych niż Web.
Future<String> loadFreshChangelogImpl(String assetPath) {
  return rootBundle.loadString(assetPath, cache: false);
}
