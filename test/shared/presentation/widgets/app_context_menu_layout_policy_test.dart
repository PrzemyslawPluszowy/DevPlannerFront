import 'package:devplanner/shared/presentation/widgets/app_context_menu_layout_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppContextMenuLayoutPolicy', () {
    test('ogranicza szeroki popover do viewportu i zachowuje margines', () {
      final constraints = AppContextMenuLayoutPolicy.constraints(
        availableWidth: 390,
        availableHeight: 900,
        requestedMaxWidth: 420,
        requestedMaxHeight: 630,
        viewportMargin: 12,
        preferredMinWidth: 220,
      );

      expect(constraints.minWidth, 220);
      expect(constraints.maxWidth, 366);
      expect(constraints.maxHeight, 630);
    });

    test('na wąskim ekranie obniża też minimalną szerokość', () {
      final constraints = AppContextMenuLayoutPolicy.constraints(
        availableWidth: 200,
        availableHeight: 500,
        requestedMaxWidth: 420,
        requestedMaxHeight: 350,
        viewportMargin: 12,
        preferredMinWidth: 220,
      );

      expect(constraints.minWidth, 176);
      expect(constraints.maxWidth, 176);
      expect(constraints.minWidth, lessThanOrEqualTo(constraints.maxWidth));
    });

    test('ogranicza wysokość do widocznego obszaru, również bez limitu', () {
      final requested = AppContextMenuLayoutPolicy.constraints(
        availableWidth: 800,
        availableHeight: 300,
        requestedMaxWidth: 420,
        requestedMaxHeight: 420,
        viewportMargin: 12,
        preferredMinWidth: 220,
      );
      final unspecified = AppContextMenuLayoutPolicy.constraints(
        availableWidth: 800,
        availableHeight: 300,
        requestedMaxWidth: 420,
        requestedMaxHeight: null,
        viewportMargin: 12,
        preferredMinWidth: 220,
      );

      expect(requested.maxHeight, 276);
      expect(unspecified.maxHeight, 276);
    });

    test('widok mniejszy od marginesów nie tworzy ujemnych constraintów', () {
      final constraints = AppContextMenuLayoutPolicy.constraints(
        availableWidth: 16,
        availableHeight: 16,
        requestedMaxWidth: 420,
        requestedMaxHeight: null,
        viewportMargin: 12,
        preferredMinWidth: 220,
      );

      expect(constraints.minWidth, 0);
      expect(constraints.maxWidth, 0);
      expect(constraints.maxHeight, 0);
    });
  });
}
