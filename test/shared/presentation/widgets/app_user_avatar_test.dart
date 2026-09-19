import 'package:devplanner/foundation/config/app_env.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUserAvatar - Testy wyświetlania awatara i fallbacku', () {
    testWidgets('renderuje inicjały dwuliterowe z imienia i nazwiska', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppUserAvatar(
                displayName: 'Jan Kowalski',
                hasCustomAvatar: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('JK'), findsOneWidget);
    });

    testWidgets('renderuje pojedynczy inicjał gdy singleInitial jest true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppUserAvatar(
                displayName: 'Jan Kowalski',
                singleInitial: true,
                hasCustomAvatar: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('J'), findsOneWidget);
      expect(find.text('JK'), findsNothing);
    });

    testWidgets('renderuje znak zapytania gdy brak displayName i brak login', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppUserAvatar(
                hasCustomAvatar: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('poprawnie wylicza URL awatara dla użytkownika i bieżącego konta', (tester) async {
      final userUrl = AppEnv.userAvatarUrl('user-123-uuid');
      expect(userUrl, contains('/api/v1/users/user-123-uuid/avatar'));

      final meUrl = AppEnv.currentUserAvatarUrl();
      expect(meUrl, contains('/api/v1/me/avatar'));
    });

    testWidgets('renderuje wskaźnik online gdy isOnline jest true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppUserAvatar(
                displayName: 'Anna Nowak',
                isOnline: true,
                hasCustomAvatar: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('AN'), findsOneWidget);
      // Znajduje pozycjonowany wskaźnik obecności
      expect(
        find.descendant(
          of: find.byType(AppUserAvatar),
          matching: find.byType(Positioned),
        ),
        findsOneWidget,
      );
    });

    testWidgets('wyświetla tooltip i semantics label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppUserAvatar(
                displayName: 'Piotr Zieliński',
                tooltip: 'Piotr Zieliński (Online)',
                semanticsLabel: 'Awatar: Piotr Zieliński',
                hasCustomAvatar: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Piotr Zieliński (Online)'), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('Piotr Zieliński')), findsOneWidget);

      handle.dispose();
    });
  });
}
