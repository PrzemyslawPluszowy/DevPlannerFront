import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/auth/auth_models.dart';

void main() {
  group('AuthTokenPair', () {
    test('mapuje odpowiedź logowania Veloryn Core bez utraty uprawnień', () {
      final response = AuthTokenPair.fromJson({
        'accessToken': 'core-access-token',
        'tokenType': 'Bearer',
        'expiresIn': 900,
        'refreshToken': 'core-refresh-token',
        'permissions': [
          'bswfms.custom_modules.RNext-bhp',
          'bswfms.custom_modules.RNext-inwentaryzacja',
        ],
        'user': {
          'id': '576439ca-ca89-4867-a463-7c05721629cc',
          'readyUserId': 3547,
          'login': 'przemyslaw.nowak',
          'displayName': 'Przemysław Nowak',
        },
      });

      expect(response.accessToken, 'core-access-token');
      expect(response.refreshToken, 'core-refresh-token');
      expect(
        response.permissions,
        containsAll([
          'bswfms.custom_modules.RNext-bhp',
          'bswfms.custom_modules.RNext-inwentaryzacja',
        ]),
      );
      expect(response.user?.userId, 3547);
      expect(response.user?.coreUserId, '576439ca-ca89-4867-a463-7c05721629cc');
      expect(response.user?.login, 'przemyslaw.nowak');
      expect(response.user?.displayName, 'Przemysław Nowak');
      expect(response.user?.permissions, response.permissions);
    });

    test('odtwarza uprawnienia zapisane lokalnie wraz z sesją', () {
      final user = AuthUser.fromJson({
        'id': '576439ca-ca89-4867-a463-7c05721629cc',
        'readyUserId': 3547,
        'login': 'przemyslaw.nowak',
        'displayName': 'Przemysław Nowak',
        'permissions': ['bswfms.custom_modules.RNext-bhp'],
      });

      expect(user.permissions, {'bswfms.custom_modules.RNext-bhp'});
    });
  });
}
