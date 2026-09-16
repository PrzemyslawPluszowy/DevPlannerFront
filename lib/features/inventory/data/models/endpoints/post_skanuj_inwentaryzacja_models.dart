import 'package:json_annotation/json_annotation.dart';

import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';

part 'post_skanuj_inwentaryzacja_models.g.dart';

/// Body dla `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/skanuj`.
@JsonSerializable(fieldRename: FieldRename.snake)
class SkanujInwentaryzacjaRequest {
  const SkanujInwentaryzacjaRequest({
    required this.kodKreskowy,
    required this.arkuszId,
  });

  factory SkanujInwentaryzacjaRequest.fromJson(Map<String, dynamic> json) =>
      _$SkanujInwentaryzacjaRequestFromJson(json);

  final int kodKreskowy;
  final int arkuszId;
  Map<String, dynamic> toJson() => _$SkanujInwentaryzacjaRequestToJson(this);
}

/// Data odpowiedzi dla `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/skanuj`.
@JsonSerializable(fieldRename: FieldRename.snake)
class SkanujInwentaryzacjaResponseData {
  const SkanujInwentaryzacjaResponseData({
    required this.status,
    this.element,
    this.arkuszId,
    this.kodKreskowy,
    this.nazwa,
    this.nrewid,
    this.miejsceEwidencja,
    this.firma,
    this.firmaNazwa,
    this.requiresConfirmation,
  });

  factory SkanujInwentaryzacjaResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$SkanujInwentaryzacjaResponseDataFromJson(json);

  final String status;
  final GetArkuszDetailsElementItem? element;
  final int? arkuszId;
  final int? kodKreskowy;
  final String? nazwa;
  final String? nrewid;
  final String? miejsceEwidencja;
  final int? firma;
  final String? firmaNazwa;
  final bool? requiresConfirmation;
  Map<String, dynamic> toJson() =>
      _$SkanujInwentaryzacjaResponseDataToJson(this);
}
