import 'dart:typed_data';

import 'package:devplanner/me/data/me_api_adapter.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:devplanner/me/domain/models/user_session_item.dart';

/// Port bramy domeny profilu, hasła i aktywnych sesji zalogowanego użytkownika.
///
/// Warstwa prezentacji nie importuje klientów HTTP, Dio ani ciasteczek;
/// cała komunikacja z backendem jest realizowana przez ten port.
abstract interface class MeGateway {
  /// Pobiera profil zalogowanego użytkownika wraz z rolami i uprawnieniami.
  Future<UserProfile> getProfile();

  /// Aktualizuje dane profilowe użytkownika (nazwa wyświetlana, ID pliku awatara).
  Future<UserProfile> updateProfile({
    String? displayName,
    String? avatarFileId,
  });

  /// Dokonuje zmiany hasła użytkownika po weryfikacji aktualnego hasła.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Pobiera listę wszystkich aktywnych sesji urządzeń powiązanych z kontem.
  Future<List<UserSessionItem>> getSessions();

  /// Unieważnia wskazaną sesję urządzenia użytkownika.
  Future<void> revokeSession(String sessionId);

  /// Przesyła i ustawia nowe zdjęcie awatara użytkownika.
  Future<void> uploadAvatar(Uint8List bytes, String filename);

  /// Usuwa aktywny awatar zalogowanego użytkownika.
  Future<void> deleteAvatar();
}

/// Bezpieczna, domyślna implementacja portu [MeGateway], gdy usługa nie została skonfigurowana.
final class UnavailableMeGateway implements MeGateway {
  const UnavailableMeGateway();

  static const _error = MeApiException(
    message: 'Usługa profilu nie została skonfigurowana w aplikacji.',
    code: 'ME_SERVICE_UNAVAILABLE',
  );

  @override
  Future<UserProfile> getProfile() async => throw _error;

  @override
  Future<UserProfile> updateProfile({
    String? displayName,
    String? avatarFileId,
  }) async => throw _error;

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async => throw _error;

  @override
  Future<List<UserSessionItem>> getSessions() async => throw _error;

  @override
  Future<void> revokeSession(String sessionId) async => throw _error;

  @override
  Future<void> uploadAvatar(Uint8List bytes, String filename) async =>
      throw _error;

  @override
  Future<void> deleteAvatar() async => throw _error;
}
