// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bhp_user_operation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBhpUserOperation _$GetBhpUserOperationFromJson(Map<String, dynamic> json) =>
    GetBhpUserOperation(
      id: json['id'] as String,
      issueId: (json['issue_id'] as num).toInt(),
      pracownikId: (json['pracownik_id'] as num).toInt(),
      type: json['type'] as String,
      typeLabel: json['type_label'] as String,
      occurredAt: json['occurred_at'] as String?,
      details: json['details'] as String,
      kartaWyposazeniaId: (json['karta_wyposazenia_id'] as num?)?.toInt(),
      kartaWyposazeniaSymbol: json['karta_wyposazenia_symbol'] as String?,
      kartaWyposazeniaNazwa: json['karta_wyposazenia_nazwa'] as String?,
      quantity: json['quantity'] as String?,
    );

Map<String, dynamic> _$GetBhpUserOperationToJson(
  GetBhpUserOperation instance,
) => <String, dynamic>{
  'id': instance.id,
  'issue_id': instance.issueId,
  'pracownik_id': instance.pracownikId,
  'type': instance.type,
  'type_label': instance.typeLabel,
  'occurred_at': instance.occurredAt,
  'karta_wyposazenia_id': instance.kartaWyposazeniaId,
  'karta_wyposazenia_symbol': instance.kartaWyposazeniaSymbol,
  'karta_wyposazenia_nazwa': instance.kartaWyposazeniaNazwa,
  'quantity': instance.quantity,
  'details': instance.details,
};
