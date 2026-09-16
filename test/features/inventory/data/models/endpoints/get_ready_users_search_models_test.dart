import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';

void main() {
  group('GetReadyUsersSearchItem', () {
    test(
      'displayName: preferuje imie+nazwisko, potem login, na koncu fallback (wykrywa puste etykiety uzytkownikow)',
      () {
        const withFullName = GetReadyUsersSearchItem(
          usrId: 1,
          firnam: 'Jan',
          lasnam: 'Nowak',
          usrnam: 'jnowak',
        );
        const withLogin = GetReadyUsersSearchItem(usrId: 2, usrnam: 'alogin');
        const withFallback = GetReadyUsersSearchItem(usrId: 3);

        expect(withFullName.displayName, 'Jan Nowak');
        expect(withLogin.displayName, 'alogin');
        expect(withFallback.displayName, 'Uzytkownik #3');
      },
    );

    test(
      'aliasy userId/login/email wskazuja pola transportowe (wykrywa rozjazd miedzy modelem a UI)',
      () {
        const item = GetReadyUsersSearchItem(
          usrId: 3759,
          usrnam: 'jnowak',
          eMail: 'j.nowak@example.com',
        );

        expect(item.userId, 3759);
        expect(item.login, 'jnowak');
        expect(item.email, 'j.nowak@example.com');
      },
    );
  });
}
