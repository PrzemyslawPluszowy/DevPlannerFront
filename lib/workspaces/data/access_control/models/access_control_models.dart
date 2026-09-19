import 'package:devplanner/workspaces/data/shared/enums/access_control_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'access_control_models.freezed.dart';
part 'access_control_models.g.dart';

/// Payload nadania lub zmiany bezpośredniego dostępu do zasobu.
@freezed
abstract class GrantResourceAccessPayload with _$GrantResourceAccessPayload {
  /// Przekazuje poziom dostępu i wersję optimistic concurrency.
  const factory GrantResourceAccessPayload({
    required ResourceAccessLevel accessLevel,
    required int expectedVersion,
  }) = _GrantResourceAccessPayload;

  /// Odtwarza payload z JSON.
  factory GrantResourceAccessPayload.fromJson(Map<String, dynamic> json) =>
      _$GrantResourceAccessPayloadFromJson(json);
}

/// Wpis ACL strony Wiki.
@freezed
abstract class WikiPageAccessGrantResponse with _$WikiPageAccessGrantResponse {
  /// Zawiera odbiorcę, poziom dostępu i wersję grantu.
  const factory WikiPageAccessGrantResponse({
    required String id,
    required String wikiPageId,
    required String coreUserId,
    required ResourceAccessLevel accessLevel,
    required String grantedByUserId,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required int version,
  }) = _WikiPageAccessGrantResponse;

  /// Odtwarza odpowiedź z JSON.
  factory WikiPageAccessGrantResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiPageAccessGrantResponseFromJson(json);
}

/// Wpis ACL whiteboardu.
@freezed
abstract class WhiteboardAccessGrantResponse
    with _$WhiteboardAccessGrantResponse {
  /// Zawiera odbiorcę, poziom dostępu i wersję grantu.
  const factory WhiteboardAccessGrantResponse({
    required String id,
    required String whiteboardId,
    required String coreUserId,
    required ResourceAccessLevel accessLevel,
    required String grantedByUserId,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required int version,
  }) = _WhiteboardAccessGrantResponse;

  /// Odtwarza odpowiedź z JSON.
  factory WhiteboardAccessGrantResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardAccessGrantResponseFromJson(json);
}
