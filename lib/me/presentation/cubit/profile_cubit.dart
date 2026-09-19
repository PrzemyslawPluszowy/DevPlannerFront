import 'dart:typed_data';

import 'package:devplanner/me/data/me_api_adapter.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:devplanner/me/domain/ports/me_gateway.dart';
import 'package:devplanner/me/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit odpowiedzialny za zarządzanie stanem profilu użytkownika oraz awatara.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.gateway}) : super(const ProfileInitial());

  final MeGateway gateway;

  /// Pobiera aktualne dane profilowe użytkownika.
  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      final profile = await gateway.getProfile();
      emit(ProfileLoaded(profile));
    } on MeApiException catch (e) {
      emit(
        ProfileError(
          message: e.message,
          code: e.code,
          traceId: e.traceId,
        ),
      );
    } catch (e) {
      emit(ProfileError(message: 'Nie udało się pobrać danych profilu: $e'));
    }
  }

  /// Aktualizuje nazwę wyświetlaną użytkownika.
  Future<void> updateDisplayName(String displayName) async {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) {
      emit(
        const ProfileError(
          message: 'Nazwa wyświetlana nie może być pusta.',
          code: 'VALIDATION_ERROR',
        ),
      );
      return;
    }

    final currentProfile = _currentProfile;
    if (currentProfile == null) return;

    emit(ProfileUpdating(currentProfile));
    try {
      final updated = await gateway.updateProfile(displayName: trimmed);
      emit(
        ProfileUpdateSuccess(
          updated,
          message: 'Nazwa wyświetlana została pomyślnie zaktualizowana.',
        ),
      );
    } on MeApiException catch (e) {
      emit(
        ProfileError(
          message: e.message,
          code: e.code,
          traceId: e.traceId,
          lastProfile: currentProfile,
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          message: 'Nie udało się zaktualizować profilu: $e',
          lastProfile: currentProfile,
        ),
      );
    }
  }

  /// Przesyła nowe zdjęcie awatara użytkownika.
  Future<void> uploadAvatar(Uint8List bytes, String filename) async {
    final currentProfile = _currentProfile;
    if (currentProfile == null) return;

    emit(ProfileAvatarUploading(currentProfile));
    try {
      await gateway.uploadAvatar(bytes, filename);
      // Pobieramy świeże dane profilu po wgraniu awatara
      final updated = await gateway.getProfile();
      emit(
        ProfileUpdateSuccess(
          updated,
          message: 'Zdjęcie profilowe zostało zaktualizowane.',
        ),
      );
    } on MeApiException catch (e) {
      emit(
        ProfileError(
          message: e.message,
          code: e.code,
          traceId: e.traceId,
          lastProfile: currentProfile,
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          message: 'Nie udało się przesłać zdjęcia profilowego: $e',
          lastProfile: currentProfile,
        ),
      );
    }
  }

  /// Usuwa zdjęcie awatara użytkownika.
  Future<void> deleteAvatar() async {
    final currentProfile = _currentProfile;
    if (currentProfile == null) return;

    emit(ProfileAvatarDeleting(currentProfile));
    try {
      await gateway.deleteAvatar();
      final updated = await gateway.getProfile();
      emit(
        ProfileUpdateSuccess(
          updated,
          message: 'Zdjęcie profilowe zostało usunięte.',
        ),
      );
    } on MeApiException catch (e) {
      emit(
        ProfileError(
          message: e.message,
          code: e.code,
          traceId: e.traceId,
          lastProfile: currentProfile,
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          message: 'Nie udało się usunąć zdjęcia profilowego: $e',
          lastProfile: currentProfile,
        ),
      );
    }
  }

  UserProfile? get _currentProfile => switch (state) {
    ProfileLoaded(:final profile) => profile,
    ProfileUpdating(:final profile) => profile,
    ProfileAvatarUploading(:final profile) => profile,
    ProfileAvatarDeleting(:final profile) => profile,
    ProfileUpdateSuccess(:final profile) => profile,
    ProfileError(:final lastProfile) => lastProfile,
    _ => null,
  };
}
