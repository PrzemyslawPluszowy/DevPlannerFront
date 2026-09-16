import 'package:json_annotation/json_annotation.dart';

part 'data_response.g.dart';

/// Uniwersalny wrapper odpowiedzi API w formacie `{ "data": ... }`.
///
/// Uzywa typu generycznego `T`, aby trzymac docelowy model danych.
@JsonSerializable(genericArgumentFactories: true)
class DataResponse<T> {
  /// Tworzy wrapper odpowiedzi z polem `data`.
  const DataResponse({required this.data});

  /// Tworzy obiekt z mapy JSON.
  factory DataResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$DataResponseFromJson(json, fromJsonT);

  /// Wlasciwe dane biznesowe zwrocone przez endpoint.
  final T data;

  /// Serializuje obiekt do mapy JSON.
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$DataResponseToJson(this, toJsonT);
}
