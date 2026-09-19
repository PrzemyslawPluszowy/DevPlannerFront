import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:devplanner/me/domain/models/user_session_item.dart';
import 'package:devplanner/me/domain/ports/me_gateway.dart';
import 'package:devplanner/me/presentation/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Atrapa bramy MeGateway przygotowana dla testów widoku profilu.
class _FakeMeGateway implements MeGateway {
  _FakeMeGateway({
    UserProfile? initialProfile,
    List<UserSessionItem>? initialSessions,
  })  : profile = initialProfile ??
            const UserProfile(
              userId: 'u-42',
              login: 'jan.kowalski',
              email: 'jan@example.com',
              displayName: 'Jan Kowalski',
              roles: {'Admin'},
              permissions: {'users.read', 'workspaces.manage'},
            ),
        sessions = initialSessions ??
            [
              UserSessionItem(
                id: 'sess-current',
                deviceName: 'Chrome na macOS',
                platform: 'macOS',
                createdAtUtc: DateTime.utc(2026, 3),
                lastSeenAtUtc: DateTime.utc(2026, 3, 15, 12),
                isCurrent: true,
              ),
              UserSessionItem(
                id: 'sess-other',
                deviceName: 'Firefox na Windows',
                platform: 'Windows',
                createdAtUtc: DateTime.utc(2026, 2, 20),
                lastSeenAtUtc: DateTime.utc(2026, 3, 10, 8),
                isCurrent: false,
              ),
            ];

  UserProfile profile;
  List<UserSessionItem> sessions;

  int updateProfileCalls = 0;
  String? lastUpdatedDisplayName;

  int changePasswordCalls = 0;
  String? lastCurrentPassword;
  String? lastNewPassword;

  int revokeSessionCalls = 0;
  String? lastRevokedSessionId;

  @override
  Future<UserProfile> getProfile() async => profile;

  @override
  Future<UserProfile> updateProfile({
    String? displayName,
    String? avatarFileId,
  }) async {
    updateProfileCalls++;
    lastUpdatedDisplayName = displayName;
    return profile = profile.copyWith(
      displayName: displayName,
      avatarFileId: avatarFileId,
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    changePasswordCalls++;
    lastCurrentPassword = currentPassword;
    lastNewPassword = newPassword;
  }

  @override
  Future<List<UserSessionItem>> getSessions() async => sessions;

  @override
  Future<void> revokeSession(String sessionId) async {
    revokeSessionCalls++;
    lastRevokedSessionId = sessionId;
    sessions = sessions.where((s) => s.id != sessionId).toList();
  }

  @override
  Future<void> uploadAvatar(List<int> bytes, String filename) async {
    profile = profile.copyWith(avatarFileId: 'new-avatar-42');
  }

  @override
  Future<void> deleteAvatar() async {
    profile = profile.copyWith(clearAvatarFileId: true);
  }
}

Widget _buildTestApp({required MeGateway gateway}) {
  return MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: UserProfilePage(gateway: gateway),
    ),
  );
}

void main() {
  group('UserProfilePage - testy widżetowe', () {
    late _FakeMeGateway gateway;

    setUp(() {
      gateway = _FakeMeGateway();
    });

    testWidgets('renderuje nagłówek, dane użytkownika, role oraz sesje', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(gateway: gateway));
      await tester.pumpAndSettle();

      // Nagłówek profilu
      expect(find.text('Mój profil'), findsOneWidget);

      // Dane osobowe
      expect(find.text('Jan Kowalski'), findsWidgets);
      expect(find.text('jan.kowalski'), findsOneWidget);
      expect(find.text('jan@example.com'), findsOneWidget);

      // Role i uprawnienia
      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('users.read'), findsOneWidget);

      // Sesje
      expect(find.text('Chrome na macOS'), findsOneWidget);
      expect(find.text('Firefox na Windows'), findsOneWidget);
      expect(find.text('Bieżąca sesja'), findsOneWidget);
    });

    testWidgets('pozwala edytować nazwę wyświetlaną i wysyła aktualizację', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(gateway: gateway));
      await tester.pumpAndSettle();

      // Klikamy przycisk edycji nazwy
      final editButton = find.byIcon(Icons.edit_outlined);
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Wpisujemy nową nazwę do pola nazwy wyświetlanej (indeks 2: login=0, email=1, displayName=2)
      final displayNameField = find.byType(TextFormField).at(2);
      await tester.enterText(displayNameField, 'Janusz Programista');
      await tester.pumpAndSettle();

      // Zapisujemy
      final saveButton = find.byIcon(Icons.check);
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Weryfikacja wywołania bramy
      expect(gateway.updateProfileCalls, 1);
      expect(gateway.lastUpdatedDisplayName, 'Janusz Programista');
      expect(find.text('Janusz Programista'), findsWidgets);
    });

    testWidgets('formularz zmiany hasła waliduje poprawność i wysyła żądanie', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(gateway: gateway));
      await tester.pumpAndSettle();

      // Sprawdzamy obecność wszystkich pól tekstowych (3 profil + 3 hasło = 6)
      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(6));

      // Wprowadzamy hasła (pola 3, 4, 5 należą do formularza hasła)
      await tester.enterText(textFields.at(3), 'AktualneHaslo123!');
      await tester.enterText(textFields.at(4), 'NoweBardzoBezpieczneHaslo999!');
      await tester.enterText(textFields.at(5), 'NoweBardzoBezpieczneHaslo999!');
      await tester.pumpAndSettle();

      // Klikamy Zmień hasło
      final changePasswordButton = find.widgetWithText(
        FilledButton,
        'Zmień hasło',
      );
      await tester.ensureVisible(changePasswordButton);
      await tester.tap(changePasswordButton);
      await tester.pumpAndSettle();

      expect(gateway.changePasswordCalls, 1);
      expect(gateway.lastCurrentPassword, 'AktualneHaslo123!');
      expect(gateway.lastNewPassword, 'NoweBardzoBezpieczneHaslo999!');
    });

    testWidgets(
        'unieważnienie sesji wymaga potwierdzenia w dialogu i wywołuje bramę', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(gateway: gateway));
      await tester.pumpAndSettle();

      // Szukamy przycisku Zakończ sesję dla sesji niebieżącej
      final revokeButton = find.widgetWithText(
        OutlinedButton,
        'Zakończ sesję',
      );
      expect(revokeButton, findsOneWidget);

      await tester.ensureVisible(revokeButton);
      await tester.tap(revokeButton);
      await tester.pumpAndSettle();

      // Pojawił się dialog potwierdzenia
      expect(find.text('Zakończyć tę sesję?'), findsOneWidget);
      expect(find.text('Zakończ sesję'), findsWidgets);

      // Potwierdzamy w dialogu (przycisk w AlertDialog z akcją)
      final confirmButtonInDialog = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'Zakończ sesję'),
      );
      expect(confirmButtonInDialog, findsOneWidget);
      await tester.tap(confirmButtonInDialog);
      await tester.pumpAndSettle();

      expect(gateway.revokeSessionCalls, 1);
      expect(gateway.lastRevokedSessionId, 'sess-other');
    });
  });
}
