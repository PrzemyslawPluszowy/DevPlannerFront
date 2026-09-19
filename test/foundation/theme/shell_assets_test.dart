import 'dart:ui' as ui;

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('tło ramy wskazuje zadeklarowany asset obrazu', () {
    expect(DevPlannerShellTheme.backdropImageAsset, 'assets/images/bg.jpeg');
    expect(
      DevPlannerShellTheme.backdropImage.assetName,
      DevPlannerShellTheme.backdropImageAsset,
    );
  });

  test('logotyp ramy wskazuje zadeklarowany asset obrazu', () {
    expect(DevPlannerShellTheme.logoAsset, 'assets/images/logo-small.png');
    expect(
      DevPlannerShellTheme.logoImage.assetName,
      DevPlannerShellTheme.logoAsset,
    );
  });

  test('assety ramy są w bundlu i dają się zdekodować', () async {
    final assets = [
      DevPlannerShellTheme.backdropImageAsset,
      DevPlannerShellTheme.logoAsset,
    ];
    for (final asset in assets) {
      final data = await rootBundle.load(asset);
      final bytes = data.buffer.asUint8List();
      expect(bytes, isNotEmpty, reason: asset);

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      expect(frame.image.width, greaterThan(0), reason: asset);
      expect(frame.image.height, greaterThan(0), reason: asset);
      codec.dispose();
    }
  });
}
