import 'package:json_annotation/json_annotation.dart';

part 'put_komisja_models.g.dart';

/// `UpdateKomisjaRequest` ze Swagger/OpenAPI.
@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateKomisjaRequest {
  /// Tworzy body podmiany komisji.
  const UpdateKomisjaRequest({required this.komisja});

  /// Tworzy model z mapy JSON.
  factory UpdateKomisjaRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateKomisjaRequestFromJson(json);

  /// Nowa lista `usr_id` czlonkow komisji, minimum 2 po stronie Swaggera.
  final List<int> komisja;

  /// Serializuje model do JSON.
  Map<String, dynamic> toJson() => _$UpdateKomisjaRequestToJson(this);
}

/// `KomisjaUpdateData` ze Swagger/OpenAPI.
@JsonSerializable(fieldRename: FieldRename.snake)
class KomisjaUpdateData {
  /// Tworzy dane odpowiedzi podmiany komisji.
  const KomisjaUpdateData({
    required this.id,
    required this.komisjaCount,
    this.success = true,
  });

  /// Tworzy model z mapy JSON.
  factory KomisjaUpdateData.fromJson(Map<String, dynamic> json) =>
      _$KomisjaUpdateDataFromJson(json);

  /// Czy operacja zakonczyla sie sukcesem.
  final bool success;

  /// Identyfikator aktualizowanego zasobu.
  final int id;

  /// Nowa liczba czlonkow komisji.
  final int komisjaCount;

  /// Serializuje model do JSON.
  Map<String, dynamic> toJson() => _$KomisjaUpdateDataToJson(this);
}
