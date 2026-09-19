import 'package:devplanner/foundation/config/app_api_module.dart';
import 'package:devplanner/foundation/config/app_env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolves every logical client to the standalone API origin', () {
    final origins = {
      for (final module in AppApiModule.values) AppEnv.apiBaseUrlFor(module),
    };

    expect(origins, {AppEnv.apiBaseUrl});
    expect(AppEnv.apiBaseUrl, startsWith('http://localhost:5072'));
  });
}
