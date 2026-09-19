import 'package:devplanner/workspaces/data/shared/enums/okr_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'okr_models.freezed.dart';
part 'okr_models.g.dart';

/// Payload utworzenia celu OKR.
@freezed
abstract class CreateObjectivePayload with _$CreateObjectivePayload {
  /// Definiuje nazwę, opis i termin celu.
  const factory CreateObjectivePayload({
    required String name,
    String? description,
    DateTime? targetDate,
  }) = _CreateObjectivePayload;

  /// Odtwarza payload z JSON.
  factory CreateObjectivePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateObjectivePayloadFromJson(json);
}

/// Payload aktualizacji celu OKR.
@freezed
abstract class UpdateObjectivePayload with _$UpdateObjectivePayload {
  /// Definiuje nową nazwę, opis i termin celu.
  const factory UpdateObjectivePayload({
    required String name,
    String? description,
    DateTime? targetDate,
  }) = _UpdateObjectivePayload;

  /// Odtwarza payload z JSON.
  factory UpdateObjectivePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateObjectivePayloadFromJson(json);
}

/// Payload utworzenia kluczowego rezultatu.
@freezed
abstract class CreateKeyResultPayload with _$CreateKeyResultPayload {
  /// Definiuje typ, cel i opcjonalne powiązanie automatycznego rezultatu.
  const factory CreateKeyResultPayload({
    required String name,
    required KeyResultType type,
    required double targetValue,
    String? linkedProjectId,
    String? linkedMilestoneId,
    @Default(1.0) double weight,
  }) = _CreateKeyResultPayload;

  /// Odtwarza payload z JSON.
  factory CreateKeyResultPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateKeyResultPayloadFromJson(json);
}

/// Payload aktualizacji kluczowego rezultatu.
@freezed
abstract class UpdateKeyResultPayload with _$UpdateKeyResultPayload {
  /// Aktualizuje nazwę, cel, wagę i ręczną wartość.
  const factory UpdateKeyResultPayload({
    required String name,
    required double targetValue,
    required double weight,
    double? currentValue,
  }) = _UpdateKeyResultPayload;

  /// Odtwarza payload z JSON.
  factory UpdateKeyResultPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateKeyResultPayloadFromJson(json);
}

/// Odpowiedź kluczowego rezultatu.
@freezed
abstract class KeyResultResponse with _$KeyResultResponse {
  /// Zawiera stan i postęp rezultatu.
  const factory KeyResultResponse({
    required String id,
    required String objectiveId,
    required String workspaceId,
    required String name,
    required KeyResultType type,
    required double currentValue,
    required double targetValue,
    String? linkedProjectId,
    String? linkedMilestoneId,
    required double weight,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required int version,
  }) = _KeyResultResponse;

  /// Odtwarza odpowiedź z JSON.
  factory KeyResultResponse.fromJson(Map<String, dynamic> json) =>
      _$KeyResultResponseFromJson(json);
}

/// Odpowiedź celu OKR wraz z kluczowymi rezultatami.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ObjectiveResponse with _$ObjectiveResponse {
  /// Zawiera metadane celu, postęp i rezultaty.
  const factory ObjectiveResponse({
    required String id,
    required String workspaceId,
    required String createdByUserId,
    required String name,
    String? description,
    DateTime? targetDate,
    required double progress,
    required List<KeyResultResponse> keyResults,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required int version,
  }) = _ObjectiveResponse;

  /// Odtwarza odpowiedź z JSON.
  factory ObjectiveResponse.fromJson(Map<String, dynamic> json) =>
      _$ObjectiveResponseFromJson(json);
}
