// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bhp_issue_operations_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBhpIssueOperationsResponseData _$GetBhpIssueOperationsResponseDataFromJson(
  Map<String, dynamic> json,
) => GetBhpIssueOperationsResponseData(
  generatedAt: json['generated_at'] as String,
  year: (json['year'] as num).toInt(),
  count: (json['count'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => GetBhpIssueOperationItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetBhpIssueOperationsResponseDataToJson(
  GetBhpIssueOperationsResponseData instance,
) => <String, dynamic>{
  'generated_at': instance.generatedAt,
  'year': instance.year,
  'count': instance.count,
  'items': instance.items,
};

GetBhpIssueOperationItem _$GetBhpIssueOperationItemFromJson(
  Map<String, dynamic> json,
) => GetBhpIssueOperationItem(
  id: json['id'] as String,
  issueId: (json['issue_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  userFullName: json['user_full_name'] as String,
  type: json['type'] as String,
  typeLabel: json['type_label'] as String,
  occurredAt: json['occurred_at'] as String,
  details: json['details'] as String,
  equivalentAmount: json['equivalent_amount'] as String?,
  stanowiskoId: (json['stanowisko_id'] as num?)?.toInt(),
  stanowiskoNazwa: json['stanowisko_nazwa'] as String?,
  kartaWyposazeniaId: (json['karta_wyposazenia_id'] as num?)?.toInt(),
  kartaWyposazeniaSymbol: json['karta_wyposazenia_symbol'] as String?,
  kartaWyposazeniaNazwa: json['karta_wyposazenia_nazwa'] as String?,
  quantity: json['quantity'] as String?,
);

Map<String, dynamic> _$GetBhpIssueOperationItemToJson(
  GetBhpIssueOperationItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'issue_id': instance.issueId,
  'user_id': instance.userId,
  'user_full_name': instance.userFullName,
  'stanowisko_id': instance.stanowiskoId,
  'stanowisko_nazwa': instance.stanowiskoNazwa,
  'karta_wyposazenia_id': instance.kartaWyposazeniaId,
  'karta_wyposazenia_symbol': instance.kartaWyposazeniaSymbol,
  'karta_wyposazenia_nazwa': instance.kartaWyposazeniaNazwa,
  'type': instance.type,
  'type_label': instance.typeLabel,
  'occurred_at': instance.occurredAt,
  'quantity': instance.quantity,
  'equivalent_amount': instance.equivalentAmount,
  'details': instance.details,
};
