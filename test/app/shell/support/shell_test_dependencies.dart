import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_session_storage.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/settings/application/current_user_avatar_cubit.dart';
import 'package:ready_next/features/settings/data/repositories/local_settings_repository.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/services/task_attachment_upload_transport.dart';

/// Kontrolowane repozytorium sesji dla testów prawdziwego app shellu.
class ShellTestAuthRepository implements AuthRepository {
  ShellTestAuthRepository({this.authenticated = true});

  final bool authenticated;

  @override
  String? get accessToken => authenticated ? 'test-token' : null;

  @override
  AuthUser? get currentUser => authenticated
      ? const AuthUser(userId: 7, login: 'tester', displayName: 'Test User')
      : null;

  @override
  bool get isAuthenticated => authenticated;

  @override
  int get sessionGeneration => 0;

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> restoreSession() async {}

  @override
  Future<bool> tryRefreshSession() async => false;
}

/// Pamięciowy magazyn sesji publicznego logowania w testach routera.
class ShellTestAuthSessionStorage implements AuthSessionStorage {
  @override
  Future<void> clear() async {}

  @override
  Future<StoredAuthSession?> read() async => null;

  @override
  Future<String?> readRememberedUsername() async => null;

  @override
  Future<void> write({
    required String accessToken,
    required String refreshToken,
    String? userJson,
  }) async {}

  @override
  Future<void> writeRememberedUsername(String username) async {}
}

/// Pamięciowe ustawienia lokalne dla raila i topbara w testach shellu.
class ShellTestSettingsRepository implements LocalSettingsRepository {
  LocalSettingsModel settings = const LocalSettingsModel.defaults();

  @override
  Future<void> close() async {}

  @override
  Future<LocalSettingsModel> getSettings() async => settings;

  @override
  Future<LocalSettingsModel> saveSettings(LocalSettingsModel value) async {
    settings = value;
    return value;
  }

  @override
  Future<LocalSettingsModel> updateSettings(
    LocalSettingsModel Function(LocalSettingsModel current) update,
  ) async => settings = update(settings);
}

/// Bezpieczny fake preferencji dashboardu wymaganych przez prywatny shell.
class ShellTestDashboardPreferencesRepository
    implements DashboardPreferencesRepository {
  @override
  Future<void> close() async {}

  @override
  Future<DashboardPreferences> getPreferences({
    required String readyUserId,
  }) async => DashboardPreferences.defaults(readyUserId: readyUserId);

  @override
  Future<DashboardPreferences> savePreferences(
    DashboardPreferences preferences,
  ) async => preferences;

  @override
  Future<DashboardPreferences> updatePreferences({
    required String readyUserId,
    required DashboardPreferences Function(DashboardPreferences current) update,
  }) async => update(DashboardPreferences.defaults(readyUserId: readyUserId));
}

/// Storage avatara zwracający brak pliku i nieobsługujący nieużytych operacji.
class ShellTestAvatarStorageRepository implements StorageRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<ApiError, StorageFileResponse>> getCurrentUserAvatar() async =>
      const Left(
        ApiError(type: ApiErrorType.notFound, message: 'Brak avatara.'),
      );

  @override
  Future<Either<ApiError, StorageFileDetailsResponse>> getFileDetails(
    String fileId,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, StorageDownloadTicketResponse>> getDownloadTicket(
    String fileId,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, StorageUploadTicketResponse>>
  requestAvatarUploadTicket(
    StorageUploadTicketItemPayload payload,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, StorageFileResponse>> completeUpload({
    required String fileId,
    required int fileSizeBytes,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, StorageFileResponse>> setCurrentUserAvatar(
    String fileId,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> deleteCurrentUserAvatar() =>
      throw UnimplementedError();
}

/// Transport uploadu avatara, którego testy chrome'u nie wywołują.
class ShellTestAvatarUploadTransport implements TaskAttachmentUploadTransport {
  @override
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required Uint8List bytes,
    String? mimeType,
  }) => throw UnimplementedError();
}

/// Fabryka zależności zgrupowana w klasie zamiast globalnych funkcji testowych.
abstract final class ShellTestDependencies {
  /// Buduje cubit avatara z bezpiecznymi zależnościami pamięciowymi.
  static CurrentUserAvatarCubit createAvatarCubit() => CurrentUserAvatarCubit(
    storageRepository: ShellTestAvatarStorageRepository(),
    uploadTransport: ShellTestAvatarUploadTransport(),
  );

  /// Buduje router aplikacji z kontrolowanym stanem uwierzytelnienia.
  static AppRouter createRouter({
    ShellTestAuthRepository? authRepository,
    String? initialLocation,
  }) => AppRouter(
    authRepository: authRepository ?? ShellTestAuthRepository(),
    ensureSessionRestored: () async {},
    initialLocation: initialLocation,
  );
}
