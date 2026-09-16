// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bhp_users_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBhpUserListItem _$GetBhpUserListItemFromJson(Map<String, dynamic> json) =>
    GetBhpUserListItem(
      id: (json['id'] as num).toInt(),
      aktywny: json['aktywny'] as bool,
      isArchived: json['is_archived'] as bool,
      nrEwidencyjny: json['nr_ewidencyjny'] as String?,
      pesel: json['pesel'] as String?,
      numerTelefonu: json['numer_telefonu'] as String?,
      readyId: (json['ready_id'] as num?)?.toInt(),
      imie: json['imie'] as String?,
      nazwisko: json['nazwisko'] as String?,
      dataRozpPracy: json['data_rozp_pracy'] as String?,
      dataZakPracy: json['data_zak_pracy'] as String?,
      stanowiskoId: (json['stanowisko_id'] as num?)?.toInt(),
      stanowiskoNazwa: json['stanowisko_nazwa'] as String?,
      nearestDueDate: json['nearest_due_date'] as String?,
      daysUntilDue: (json['days_until_due'] as num?)?.toInt(),
      daysOverdue: (json['days_overdue'] as num?)?.toInt(),
      overdueCount: (json['overdue_count'] as num?)?.toInt() ?? 0,
      upcomingCount: (json['upcoming_count'] as num?)?.toInt() ?? 0,
      nearestOverdueDays: (json['nearest_overdue_days'] as num?)?.toInt(),
      nearestUpcomingDays: (json['nearest_upcoming_days'] as num?)?.toInt(),
      archivedAt: json['archived_at'] as String?,
    );

Map<String, dynamic> _$GetBhpUserListItemToJson(GetBhpUserListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nr_ewidencyjny': instance.nrEwidencyjny,
      'pesel': instance.pesel,
      'numer_telefonu': instance.numerTelefonu,
      'ready_id': instance.readyId,
      'imie': instance.imie,
      'nazwisko': instance.nazwisko,
      'aktywny': instance.aktywny,
      'data_rozp_pracy': instance.dataRozpPracy,
      'data_zak_pracy': instance.dataZakPracy,
      'stanowisko_id': instance.stanowiskoId,
      'stanowisko_nazwa': instance.stanowiskoNazwa,
      'nearest_due_date': instance.nearestDueDate,
      'days_until_due': instance.daysUntilDue,
      'days_overdue': instance.daysOverdue,
      'overdue_count': instance.overdueCount,
      'upcoming_count': instance.upcomingCount,
      'nearest_overdue_days': instance.nearestOverdueDays,
      'nearest_upcoming_days': instance.nearestUpcomingDays,
      'archived_at': instance.archivedAt,
      'is_archived': instance.isArchived,
    };
