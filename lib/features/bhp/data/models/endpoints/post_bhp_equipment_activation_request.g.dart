// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_bhp_equipment_activation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostBhpEquipmentActivationRequest _$PostBhpEquipmentActivationRequestFromJson(
  Map<String, dynamic> json,
) => PostBhpEquipmentActivationRequest(
  selectedStandardIds: (json['selected_standard_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$PostBhpEquipmentActivationRequestToJson(
  PostBhpEquipmentActivationRequest instance,
) => <String, dynamic>{'selected_standard_ids': ?instance.selectedStandardIds};
