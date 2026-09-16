// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_response_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataResponseList<T> _$DataResponseListFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => DataResponseList<T>(
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$DataResponseListToJson<T>(
  DataResponseList<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'data': instance.data.map(toJsonT).toList()};
