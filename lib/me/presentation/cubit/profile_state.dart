import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:equatable/equatable.dart';

/// Bazowy stan zarządzania profilem użytkownika.
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy przed załadowaniem danych profilu.
final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Stan ładowania danych profilu z serwera.
final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Stan z pomyślnie załadowanymi danymi profilu.
final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

/// Stan podczas aktualizacji nazwy wyświetlanej profilu.
final class ProfileUpdating extends ProfileState {
  const ProfileUpdating(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

/// Stan podczas przesyłania nowego awatara na serwer.
final class ProfileAvatarUploading extends ProfileState {
  const ProfileAvatarUploading(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

/// Stan podczas usuwania awatara z serwera.
final class ProfileAvatarDeleting extends ProfileState {
  const ProfileAvatarDeleting(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

/// Stan po pomyślnej aktualizacji danych profilu.
final class ProfileUpdateSuccess extends ProfileState {
  const ProfileUpdateSuccess(this.profile, {required this.message});

  final UserProfile profile;
  final String message;

  @override
  List<Object?> get props => [profile, message];
}

/// Stan błędu operacji na profilu użytkownika.
final class ProfileError extends ProfileState {
  const ProfileError({
    required this.message,
    this.code,
    this.traceId,
    this.lastProfile,
  });

  final String message;
  final String? code;
  final String? traceId;
  final UserProfile? lastProfile;

  @override
  List<Object?> get props => [message, code, traceId, lastProfile];
}
