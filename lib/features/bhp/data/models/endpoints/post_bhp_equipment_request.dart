/// Model żądania utworzenia lub edycji karty wyposażenia BHP.
class PostBhpEquipmentRequest {
  /// Tworzy model żądania karty wyposażenia.
  const PostBhpEquipmentRequest({
    required this.symbol,
    required this.nazwa,
    this.procentPrzydatnosci,
    this.okresUzywalnosci,
    this.jm,
    this.nrDowoduWydania,
    this.iloscDomyslna,
    this.ekwiwalent,
    this.cena,
  });

  /// Symbol karty wyposażenia.
  final String symbol;

  /// Nazwa karty wyposażenia.
  final String nazwa;

  /// Procent przydatności.
  final int? procentPrzydatnosci;

  /// Okres użytkowania w miesiącach.
  final String? okresUzywalnosci;

  /// Jednostka miary.
  final String? jm;

  /// Numer dowodu wydania.
  final String? nrDowoduWydania;

  /// Ilość domyślna.
  final String? iloscDomyslna;

  /// Wartość ekwiwalentu.
  final String? ekwiwalent;

  /// Cena jednostkowa.
  final String? cena;

  /// Serializuje żądanie do formatu backendowego.
  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'nazwa': nazwa,
    'procent_przydatnosci': procentPrzydatnosci,
    'okres_uzywalnosci': okresUzywalnosci,
    'jm': jm,
    'nr_dowodu_wydania': nrDowoduWydania,
    'ilosc_domyslna': iloscDomyslna,
    'ekwiwalent': ekwiwalent,
    'cena': cena,
  };
}
