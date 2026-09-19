import 'package:devplanner/shared/data/changelog_loader_stub.dart'
    if (dart.library.js_interop) 'package:devplanner/shared/data/changelog_loader_web.dart';

/// Wczytuje aktualną treść changeloga bez korzystania z trwałego cache.
Future<String> loadFreshChangelog(String assetPath) {
  return loadFreshChangelogImpl(assetPath);
}
