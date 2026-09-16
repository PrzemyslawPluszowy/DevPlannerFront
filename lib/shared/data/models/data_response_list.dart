import 'package:json_annotation/json_annotation.dart';

part 'data_response_list.g.dart';

/// Uniwersalny wrapper odpowiedzi API w formacie `{ "data": [ ... ] }`.
///
/// Uzywa typu generycznego `T`, aby trzymac pojedynczy element listy.
@JsonSerializable(genericArgumentFactories: true)
class DataResponseList<T> {
  /// Tworzy wrapper odpowiedzi z lista danych.
  const DataResponseList({required this.data});

  /// Tworzy obiekt z mapy JSON.
  factory DataResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$DataResponseListFromJson(json, fromJsonT);

  /// Lista danych zwrocona przez endpoint.
  final List<T> data;

  /// Serializuje obiekt do mapy JSON.
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$DataResponseListToJson(this, toJsonT);
}
