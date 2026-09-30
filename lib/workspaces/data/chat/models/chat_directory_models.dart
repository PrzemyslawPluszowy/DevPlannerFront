import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_directory_models.freezed.dart';
part 'chat_directory_models.g.dart';

/// Kandydat z lokalnego katalogu kont do rozpoczęcia rozmowy Chat.
@freezed
abstract class ChatDirectoryUserResponse with _$ChatDirectoryUserResponse {
  /// Zawiera login, nazwę i awatar; katalog nigdy nie zwraca adresu e-mail.
  const factory ChatDirectoryUserResponse({
    required String userId,
    required String login,
    required String displayName,
    String? avatarUrl,
  }) = _ChatDirectoryUserResponse;

  /// Odtwarza kandydata z JSON.
  factory ChatDirectoryUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatDirectoryUserResponseFromJson(json);
}
