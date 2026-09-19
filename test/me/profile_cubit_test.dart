import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:devplanner/me/data/me_api_adapter.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:devplanner/me/domain/models/user_session_item.dart';
import 'package:devplanner/me/domain/ports/me_gateway.dart';
import 'package:devplanner/me/presentation/cubit/profile_cubit.dart';
import 'package:devplanner/me/presentation/cubit/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeMeGateway implements MeGateway {
  _FakeMeGateway({UserProfile? initialProfile})
      : profile = initialProfile ??
            const UserProfile(
              userId: 'u-1',
              login: 'testuser',
              email: 'test@example.com',
              displayName: 'Test User',
              roles: {'Admin'},
              permissions: {'read'},
            );

  UserProfile profile;
  Exception? errorToThrow;

  @override
  Future<UserProfile> getProfile() async {
    if (errorToThrow != null) throw errorToThrow!;
    return profile;
  }

  @override
  Future<UserProfile> updateProfile({
    String? displayName,
    String? avatarFileId,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
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
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<List<UserSessionItem>> getSessions() async => const [];

  @override
  Future<void> revokeSession(String sessionId) async {}

  @override
  Future<void> uploadAvatar(Uint8List bytes, String filename) async {
    if (errorToThrow != null) throw errorToThrow!;
    profile = profile.copyWith(avatarFileId: 'new-avatar-id');
  }

  @override
  Future<void> deleteAvatar() async {
    if (errorToThrow != null) throw errorToThrow!;
    profile = profile.copyWith(clearAvatarFileId: true);
  }
}

void main() {
  group('ProfileCubit', () {
    late _FakeMeGateway gateway;

    setUp(() {
      gateway = _FakeMeGateway();
    });

    blocTest<ProfileCubit, ProfileState>(
      'loadProfile emituje ProfileLoading a potem ProfileLoaded',
      build: () => ProfileCubit(gateway: gateway),
      act: (cubit) => cubit.loadProfile(),
      expect: () => [
        const ProfileLoading(),
        ProfileLoaded(gateway.profile),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'loadProfile emituje ProfileError w przypadku błędu API',
      build: () {
        gateway.errorToThrow = const MeApiException(
          message: 'Błąd pobierania profilu',
          code: 'FETCH_ERROR',
        );
        return ProfileCubit(gateway: gateway);
      },
      act: (cubit) => cubit.loadProfile(),
      expect: () => [
        const ProfileLoading(),
        const ProfileError(
          message: 'Błąd pobierania profilu',
          code: 'FETCH_ERROR',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'updateDisplayName emituje błąd walidacji gdy nazwa jest pusta',
      build: () => ProfileCubit(gateway: gateway),
      seed: () => ProfileLoaded(gateway.profile),
      act: (cubit) => cubit.updateDisplayName('   '),
      expect: () => [
        const ProfileError(
          message: 'Nazwa wyświetlana nie może być pusta.',
          code: 'VALIDATION_ERROR',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'updateDisplayName aktualizuje profil i emituje ProfileUpdateSuccess',
      setUp: () {},
      build: () => ProfileCubit(gateway: gateway),
      seed: () => ProfileLoaded(gateway.profile),
      act: (cubit) => cubit.updateDisplayName('Nowe Imie'),
      expect: () {
        final initial = gateway.profile.copyWith(displayName: 'Test User');
        return [
          ProfileUpdating(initial),
          ProfileUpdateSuccess(
            initial.copyWith(displayName: 'Nowe Imie'),
            message: 'Nazwa wyświetlana została pomyślnie zaktualizowana.',
          ),
        ];
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'uploadAvatar wgrywa zdjęcie i emituje ProfileUpdateSuccess',
      build: () => ProfileCubit(gateway: gateway),
      seed: () => ProfileLoaded(gateway.profile),
      act: (cubit) => cubit.uploadAvatar(Uint8List.fromList([1, 2]), 'avatar.png'),
      expect: () {
        final initial = gateway.profile.copyWith(clearAvatarFileId: true);
        return [
          ProfileAvatarUploading(initial),
          ProfileUpdateSuccess(
            initial.copyWith(avatarFileId: 'new-avatar-id'),
            message: 'Zdjęcie profilowe zostało zaktualizowane.',
          ),
        ];
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'deleteAvatar usuwa zdjęcie i emituje ProfileUpdateSuccess',
      build: () => ProfileCubit(gateway: gateway),
      seed: () => ProfileLoaded(
        gateway.profile.copyWith(avatarFileId: 'existing-avatar'),
      ),
      act: (cubit) => cubit.deleteAvatar(),
      expect: () => [
        ProfileAvatarDeleting(
          gateway.profile.copyWith(avatarFileId: 'existing-avatar'),
        ),
        ProfileUpdateSuccess(
          gateway.profile.copyWith(clearAvatarFileId: true),
          message: 'Zdjęcie profilowe zostało usunięte.',
        ),
      ],
    );
  });
}
