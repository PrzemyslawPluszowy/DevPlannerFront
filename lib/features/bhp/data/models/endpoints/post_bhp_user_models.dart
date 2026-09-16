/// Model żądania utworzenia pracownika BHP.
class PostBhpUserRequest {
  /// Tworzy model żądania utworzenia pracownika.
  const PostBhpUserRequest({
    required this.imie,
    required this.nazwisko,
    required this.stanowiskoId,
    this.pesel,
    this.numerTelefonu,
    this.readyId,
    this.dataRozpPracy,
    this.dataZakPracy,
    this.miejsceZamieszkania,
    this.wzrost,
    this.obwodKlatkiPiers,
    this.obwodPasa,
    this.obwodGlowy,
    this.dlStopy,
    this.uwagi,
  });

  /// Imię pracownika.
  final String imie;

  /// Nazwisko pracownika.
  final String nazwisko;

  /// Id stanowiska.
  final int stanowiskoId;

  /// Numer PESEL.
  final String? pesel;

  /// Numer telefonu.
  final String? numerTelefonu;

  /// Id użytkownika READY.
  final int? readyId;

  /// Data rozpoczęcia pracy w formacie `yyyy-MM-dd`.
  final String? dataRozpPracy;

  /// Data zakończenia pracy w formacie `yyyy-MM-dd`.
  final String? dataZakPracy;

  /// Miejsce zamieszkania.
  final String? miejsceZamieszkania;

  /// Wzrost.
  final String? wzrost;

  /// Obwód klatki piersiowej.
  final String? obwodKlatkiPiers;

  /// Obwód pasa.
  final String? obwodPasa;

  /// Obwód głowy.
  final String? obwodGlowy;

  /// Długość stopy.
  final String? dlStopy;

  /// Uwagi.
  final String? uwagi;

  /// Serializuje żądanie do formatu backendowego.
  Map<String, dynamic> toJson() => {
    'imie': imie,
    'nazwisko': nazwisko,
    'stanowisko_id': stanowiskoId,
    'pesel': pesel,
    'numer_telefonu': numerTelefonu,
    'ready_id': readyId,
    'data_rozp_pracy': dataRozpPracy,
    'data_zak_pracy': dataZakPracy,
    'miejsce_zamieszkania': miejsceZamieszkania,
    'wzrost': wzrost,
    'obwod_klatki_piers': obwodKlatkiPiers,
    'obwod_pasa': obwodPasa,
    'obwod_glowy': obwodGlowy,
    'dl_stopy': dlStopy,
    'uwagi': uwagi,
  };
}
