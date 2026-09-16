// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bhp_missing_equipment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBhpMissingEquipmentResponseData _$GetBhpMissingEquipmentResponseDataFromJson(
  Map<String, dynamic> json,
) => GetBhpMissingEquipmentResponseData(
  generatedAt: json['generated_at'] as String,
  usersCount: (json['users_count'] as num).toInt(),
  missingItemsCount: (json['missing_items_count'] as num).toInt(),
  distinctCardsCount: (json['distinct_cards_count'] as num).toInt(),
  topMissingCardLabel: json['top_missing_card_label'] as String?,
  topMissingCardCount: (json['top_missing_card_count'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => GetBhpMissingEquipmentItem.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$GetBhpMissingEquipmentResponseDataToJson(
  GetBhpMissingEquipmentResponseData instance,
) => <String, dynamic>{
  'generated_at': instance.generatedAt,
  'users_count': instance.usersCount,
  'missing_items_count': instance.missingItemsCount,
  'distinct_cards_count': instance.distinctCardsCount,
  'top_missing_card_label': instance.topMissingCardLabel,
  'top_missing_card_count': instance.topMissingCardCount,
  'items': instance.items,
};

GetBhpMissingEquipmentItem _$GetBhpMissingEquipmentItemFromJson(
  Map<String, dynamic> json,
) => GetBhpMissingEquipmentItem(
  id: json['id'] as String,
  userId: (json['user_id'] as num).toInt(),
  userFullName: json['user_full_name'] as String,
  standardId: (json['standard_id'] as num).toInt(),
  kartaWyposazeniaId: (json['karta_wyposazenia_id'] as num).toInt(),
  details: json['details'] as String,
  stanowiskoId: (json['stanowisko_id'] as num?)?.toInt(),
  stanowiskoNazwa: json['stanowisko_nazwa'] as String?,
  kartaWyposazeniaSymbol: json['karta_wyposazenia_symbol'] as String?,
  kartaWyposazeniaNazwa: json['karta_wyposazenia_nazwa'] as String?,
  standardQuantity: json['standard_quantity'] as String?,
  latestIssueClosedAt: json['latest_issue_closed_at'] as String?,
);

Map<String, dynamic> _$GetBhpMissingEquipmentItemToJson(
  GetBhpMissingEquipmentItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'user_full_name': instance.userFullName,
  'stanowisko_id': instance.stanowiskoId,
  'stanowisko_nazwa': instance.stanowiskoNazwa,
  'standard_id': instance.standardId,
  'karta_wyposazenia_id': instance.kartaWyposazeniaId,
  'karta_wyposazenia_symbol': instance.kartaWyposazeniaSymbol,
  'karta_wyposazenia_nazwa': instance.kartaWyposazeniaNazwa,
  'standard_quantity': instance.standardQuantity,
  'latest_issue_closed_at': instance.latestIssueClosedAt,
  'details': instance.details,
};
