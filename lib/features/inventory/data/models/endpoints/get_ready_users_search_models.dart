import 'package:json_annotation/json_annotation.dart';

part 'get_ready_users_search_models.g.dart';

/// Rekord uzytkownika zwracany przez endpoint wyszukiwarki.
@JsonSerializable()
class GetReadyUsersSearchItem {
  /// Tworzy rekord uzytkownika z wyszukiwarki.
  const GetReadyUsersSearchItem({
    required this.usrId,
    this.usrnam,
    this.firnam,
    this.lasnam,
    this.eMail,
    this.initls,
    this.usrsym,
    this.phone,
    this.iphone,
    this.ephone,
    this.ustype,
    this.isDel,
    this.isCnt,
    this.lastlg,
    this.lastse,
    this.room,
    this.locatn,
    this.magnit,
    this.adddat,
  });

  /// Tworzy model z mapy JSON.
  factory GetReadyUsersSearchItem.fromJson(Map<String, dynamic> json) =>
      _$GetReadyUsersSearchItemFromJson(json);

  /// Id uzytkownika.
  @JsonKey(name: 'usr_id')
  final int usrId;

  /// Nazwa uzytkownika (login wg backendu).
  final String? usrnam;

  /// Imie.
  final String? firnam;

  /// Nazwisko.
  final String? lasnam;

  /// Email.
  @JsonKey(name: 'e_mail')
  final String? eMail;

  /// Inicjaly.
  final String? initls;

  /// Symbol uzytkownika.
  final String? usrsym;

  /// Telefon.
  @JsonKey(name: 'phone_')
  final String? phone;

  /// Telefon wewnetrzny.
  final String? iphone;

  /// Telefon awaryjny.
  final String? ephone;

  /// Typ uzytkownika.
  final String? ustype;

  /// Flaga usuniecia.
  @JsonKey(name: 'is_del')
  final bool? isDel;

  /// Flaga kontaktu.
  @JsonKey(name: 'is_cnt')
  final bool? isCnt;

  /// Data ostatniego logowania.
  final String? lastlg;

  /// Data ostatniej sesji.
  final String? lastse;

  /// Pokoj.
  @JsonKey(name: 'room__')
  final String? room;

  /// Lokalizacja.
  final String? locatn;

  /// Znacznik modyfikacji.
  final String? magnit;

  /// Data dodania.
  final String? adddat;

  /// Kompatybilne aliasy do warstwy UI.
  int get userId => usrId;

  /// Kompatybilne aliasy do warstwy UI.
  String get displayName {
    final full = '${firnam ?? ''} ${lasnam ?? ''}'.trim();
    if (full.isNotEmpty) {
      return full;
    }
    final login = (usrnam ?? '').trim();
    if (login.isNotEmpty) {
      return login;
    }
    return 'Uzytkownik #$usrId';
  }

  /// Kompatybilne aliasy do warstwy UI.
  String? get login => usrnam;

  /// Kompatybilne aliasy do warstwy UI.
  String? get email => eMail;

  /// Serializuje model do JSON.
  Map<String, dynamic> toJson() => _$GetReadyUsersSearchItemToJson(this);
}
