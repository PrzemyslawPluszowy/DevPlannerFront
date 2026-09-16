// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bhp_user_issue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBhpUserIssue _$GetBhpUserIssueFromJson(Map<String, dynamic> json) =>
    GetBhpUserIssue(
      id: (json['id'] as num).toInt(),
      pracownikId: (json['pracownik_id'] as num).toInt(),
      dataPrzydzialu: json['data_przydzialu'] as String,
      isActive: json['is_active'] as bool,
      hasEquivalent: json['has_equivalent'] as bool,
      canClose: json['can_close'] as bool,
      canEdit: json['can_edit'] as bool,
      canDelete: json['can_delete'] as bool,
      canRegisterEquivalent: json['can_register_equivalent'] as bool,
      canRepeat: json['can_repeat'] as bool,
      kartaWyposazeniaId: (json['karta_wyposazenia_id'] as num?)?.toInt(),
      kartaWyposazeniaSymbol: json['karta_wyposazenia_symbol'] as String?,
      kartaWyposazeniaNazwa: json['karta_wyposazenia_nazwa'] as String?,
      ilosc: json['ilosc'] as String?,
      kwotaEkwiwalent: json['kwota_ekwiwalent'] as String?,
      dataZakonczenia: json['data_zakonczenia'] as String?,
      uwagi: json['uwagi'] as String?,
      dataEkwiwalent: json['data_ekwiwalent'] as String?,
      dataWpisu: json['data_wpisu'] as String?,
      dueDate: json['due_date'] as String?,
    );

Map<String, dynamic> _$GetBhpUserIssueToJson(GetBhpUserIssue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pracownik_id': instance.pracownikId,
      'karta_wyposazenia_id': instance.kartaWyposazeniaId,
      'karta_wyposazenia_symbol': instance.kartaWyposazeniaSymbol,
      'karta_wyposazenia_nazwa': instance.kartaWyposazeniaNazwa,
      'data_przydzialu': instance.dataPrzydzialu,
      'data_zakonczenia': instance.dataZakonczenia,
      'ilosc': instance.ilosc,
      'uwagi': instance.uwagi,
      'data_ekwiwalent': instance.dataEkwiwalent,
      'kwota_ekwiwalent': instance.kwotaEkwiwalent,
      'data_wpisu': instance.dataWpisu,
      'due_date': instance.dueDate,
      'is_active': instance.isActive,
      'has_equivalent': instance.hasEquivalent,
      'can_close': instance.canClose,
      'can_edit': instance.canEdit,
      'can_delete': instance.canDelete,
      'can_register_equivalent': instance.canRegisterEquivalent,
      'can_repeat': instance.canRepeat,
    };
