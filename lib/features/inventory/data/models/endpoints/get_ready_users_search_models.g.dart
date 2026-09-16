// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_ready_users_search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetReadyUsersSearchItem _$GetReadyUsersSearchItemFromJson(
  Map<String, dynamic> json,
) => GetReadyUsersSearchItem(
  usrId: (json['usr_id'] as num).toInt(),
  usrnam: json['usrnam'] as String?,
  firnam: json['firnam'] as String?,
  lasnam: json['lasnam'] as String?,
  eMail: json['e_mail'] as String?,
  initls: json['initls'] as String?,
  usrsym: json['usrsym'] as String?,
  phone: json['phone_'] as String?,
  iphone: json['iphone'] as String?,
  ephone: json['ephone'] as String?,
  ustype: json['ustype'] as String?,
  isDel: json['is_del'] as bool?,
  isCnt: json['is_cnt'] as bool?,
  lastlg: json['lastlg'] as String?,
  lastse: json['lastse'] as String?,
  room: json['room__'] as String?,
  locatn: json['locatn'] as String?,
  magnit: json['magnit'] as String?,
  adddat: json['adddat'] as String?,
);

Map<String, dynamic> _$GetReadyUsersSearchItemToJson(
  GetReadyUsersSearchItem instance,
) => <String, dynamic>{
  'usr_id': instance.usrId,
  'usrnam': instance.usrnam,
  'firnam': instance.firnam,
  'lasnam': instance.lasnam,
  'e_mail': instance.eMail,
  'initls': instance.initls,
  'usrsym': instance.usrsym,
  'phone_': instance.phone,
  'iphone': instance.iphone,
  'ephone': instance.ephone,
  'ustype': instance.ustype,
  'is_del': instance.isDel,
  'is_cnt': instance.isCnt,
  'lastlg': instance.lastlg,
  'lastse': instance.lastse,
  'room__': instance.room,
  'locatn': instance.locatn,
  'magnit': instance.magnit,
  'adddat': instance.adddat,
};
