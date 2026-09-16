// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bhp_dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBhpDashboardResponseData _$GetBhpDashboardResponseDataFromJson(
  Map<String, dynamic> json,
) => GetBhpDashboardResponseData(
  generatedAt: json['generated_at'] as String,
  monthsAhead: (json['months_ahead'] as num).toInt(),
  overdueCount: (json['overdue_count'] as num).toInt(),
  upcomingCount: (json['upcoming_count'] as num).toInt(),
  overdue: (json['overdue'] as List<dynamic>)
      .map((e) => GetBhpIssueAlertItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  upcoming: (json['upcoming'] as List<dynamic>)
      .map((e) => GetBhpIssueAlertItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetBhpDashboardResponseDataToJson(
  GetBhpDashboardResponseData instance,
) => <String, dynamic>{
  'generated_at': instance.generatedAt,
  'months_ahead': instance.monthsAhead,
  'overdue_count': instance.overdueCount,
  'upcoming_count': instance.upcomingCount,
  'overdue': instance.overdue,
  'upcoming': instance.upcoming,
};

GetBhpIssueAlertItem _$GetBhpIssueAlertItemFromJson(
  Map<String, dynamic> json,
) => GetBhpIssueAlertItem(
  issueId: (json['issue_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  userFullName: json['user_full_name'] as String,
  dataPrzydzialu: json['data_przydzialu'] as String,
  okresMiesiace: (json['okres_miesiace'] as num).toInt(),
  okresSource: json['okres_source'] as String,
  dueDate: json['due_date'] as String,
  daysToDue: (json['days_to_due'] as num).toInt(),
  stanowiskoId: (json['stanowisko_id'] as num?)?.toInt(),
  stanowiskoNazwa: json['stanowisko_nazwa'] as String?,
  kartaWyposazeniaId: (json['karta_wyposazenia_id'] as num?)?.toInt(),
  kartaWyposazeniaSymbol: json['karta_wyposazenia_symbol'] as String?,
  kartaWyposazeniaNazwa: json['karta_wyposazenia_nazwa'] as String?,
);

Map<String, dynamic> _$GetBhpIssueAlertItemToJson(
  GetBhpIssueAlertItem instance,
) => <String, dynamic>{
  'issue_id': instance.issueId,
  'user_id': instance.userId,
  'user_full_name': instance.userFullName,
  'stanowisko_id': instance.stanowiskoId,
  'stanowisko_nazwa': instance.stanowiskoNazwa,
  'karta_wyposazenia_id': instance.kartaWyposazeniaId,
  'karta_wyposazenia_symbol': instance.kartaWyposazeniaSymbol,
  'karta_wyposazenia_nazwa': instance.kartaWyposazeniaNazwa,
  'data_przydzialu': instance.dataPrzydzialu,
  'okres_miesiace': instance.okresMiesiace,
  'okres_source': instance.okresSource,
  'due_date': instance.dueDate,
  'days_to_due': instance.daysToDue,
};
