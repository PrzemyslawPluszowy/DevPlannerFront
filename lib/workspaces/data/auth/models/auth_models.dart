import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// Zweryfikowana tożsamość bieżącego lokalnego użytkownika.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CurrentUserResponse with _$CurrentUserResponse {
  /// Zawiera identyfikatory, login i prawa użytkownika.
  const factory CurrentUserResponse({
    required String userId,
    int? readyUserId,
    String? login,
    required List<String> permissions,
  }) = _CurrentUserResponse;

  /// Odtwarza tożsamość z JSON.
  factory CurrentUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserResponseFromJson(json);
}
