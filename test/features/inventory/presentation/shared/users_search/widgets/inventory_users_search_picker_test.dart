import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/widgets/inventory_users_search_picker.dart';
import 'package:ready_next/l10n/app_localizations.dart';

/// Mock repozytorium wyszukiwarki uzytkownikow.
class _MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  testWidgets(
    'dodaje uzytkownika do wybranych po kliknieciu wyniku',
    (tester) async {
      final repository = _MockUsersRepository();
      final changes = <List<GetReadyUsersSearchItem>>[];
      const user = GetReadyUsersSearchItem(
        usrId: 4,
        firnam: 'Robert',
        lasnam: 'Gawle',
        usrnam: 'rgawle',
      );

      when(
        () => repository.searchUsers(
          search: any(named: 'search'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          includeInactive: any(named: 'includeInactive'),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => const Right([user]));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
          home: Scaffold(
            body: InventoryUsersSearchPicker(
              repository: repository,
              onChanged: changes.add,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'rober');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('Robert Gawle'), findsOneWidget);

      await tester.tap(find.text('Robert Gawle'));
      await tester.pumpAndSettle();

      expect(changes, hasLength(1));
      expect(changes.single.map((user) => user.userId), [4]);
      expect(find.text('Brak wybranych osob'), findsNothing);
      expect(find.text('Robert Gawle'), findsOneWidget);
    },
  );
}
