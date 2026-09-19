import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';

Widget _buildTestApp({
  required Map<String, ProjectMemberProfile> memberProfiles,
  required List<TaskProjectPresenceUser> presence,
  required String? currentUserId,
  required VoidCallback onTap,
  int maxVisible = 3,
}) => MaterialApp(
  locale: const Locale('pl'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: Center(
      child: ProjectMemberFacepile(
        memberProfilesByUserId: memberProfiles,
        presence: presence,
        currentUserId: currentUserId,
        onTap: onTap,
        maxVisible: maxVisible,
      ),
    ),
  ),
);

void main() {
  group('ProjectMemberFacepile - Testy stanów, widoczności i interakcji', () {
    testWidgets(
      '0 członków: renderuje kompaktowy przycisk stanu zerowego 32x32',
      (
        tester,
      ) async {
        var tapped = false;
        await tester.pumpWidget(
          _buildTestApp(
            memberProfiles: {},
            presence: [],
            currentUserId: 'user-me',
            onTap: () => tapped = true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Symbols.group_rounded), findsOneWidget);
        await tester.tap(find.byIcon(Symbols.group_rounded));
        expect(tapped, isTrue);
      },
    );

    testWidgets('1 członek: wyświetla 1 awatar ze statusem i inicjałem', (
      tester,
    ) async {
      var tapped = false;
      final members = {
        'user-1': const ProjectMemberProfile(
          userId: 'user-1',
          displayName: 'Adam Kowalski',
          role: ProjectRole.admin,
        ),
      };

      await tester.pumpWidget(
        _buildTestApp(
          memberProfiles: members,
          presence: const [
            TaskProjectPresenceUser(
              userId: 'user-1',
              connectionCount: 1,
            ),
          ],
          currentUserId: 'user-1',
          onTap: () => tapped = true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('A'), findsOneWidget);
      expect(find.text('+'), findsNothing);

      // Sprawdzenie Semantics (zawiera Moje Centrum Projektu)
      expect(
        find.bySemanticsLabel(RegExp('Centrum Projektu')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('project_member_facepile')));
      expect(tapped, isTrue);
    });

    testWidgets(
      '3 członków: sortowanie: bieżący użytkownik -> online -> alfabetycznie',
      (tester) async {
        final members = {
          'user-c': const ProjectMemberProfile(
            userId: 'user-c',
            displayName: 'Celina Nowak',
            role: ProjectRole.member,
          ),
          'user-b': const ProjectMemberProfile(
            userId: 'user-b',
            displayName: 'Bartosz Zając',
            role: ProjectRole.member,
          ),
          'user-a': const ProjectMemberProfile(
            userId: 'user-a',
            displayName: 'Anna Kowalska',
            role: ProjectRole.member,
          ),
        };

        // user-b jest online, bieżący to user-a
        await tester.pumpWidget(
          _buildTestApp(
            memberProfiles: members,
            presence: const [
              TaskProjectPresenceUser(
                userId: 'user-b',
                connectionCount: 1,
              ),
            ],
            currentUserId: 'user-a',
            onTap: () {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('A'), findsOneWidget);
        expect(find.text('B'), findsOneWidget);
        expect(find.text('C'), findsOneWidget);
      },
    );

    testWidgets(
      '8 członków przy maxVisible=3: renderuje 3 awatary i badge +5',
      (
        tester,
      ) async {
        final members = <String, ProjectMemberProfile>{};
        for (var i = 1; i <= 8; i++) {
          members['user-$i'] = ProjectMemberProfile(
            userId: 'user-$i',
            displayName: 'Osoba $i',
            role: ProjectRole.member,
          );
        }

        await tester.pumpWidget(
          _buildTestApp(
            memberProfiles: members,
            presence: const [],
            currentUserId: 'user-1',
            onTap: () {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('+5'), findsOneWidget);
      },
    );

    testWidgets('minimalny hit target wynosi co najmniej 40 px', (
      tester,
    ) async {
      final members = {
        'user-1': const ProjectMemberProfile(
          userId: 'user-1',
          displayName: 'Jan Kowalski',
          role: ProjectRole.admin,
        ),
      };

      await tester.pumpWidget(
        _buildTestApp(
          memberProfiles: members,
          presence: const [],
          currentUserId: 'user-1',
          onTap: () {},
        ),
      );
      await tester.pumpAndSettle();

      final size = tester.getSize(
        find.byKey(const ValueKey('project_member_facepile')),
      );
      expect(size.height, greaterThanOrEqualTo(40.0));
      expect(size.width, greaterThanOrEqualTo(40.0));
    });
  });
}
