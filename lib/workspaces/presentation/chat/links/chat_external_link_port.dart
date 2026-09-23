/// Port otwierania bezpiecznego adresu poza aplikacją.
///
/// Presentation nie używa bezpośrednio launcherów platformy: port zwraca wynik
/// otwarcia, a brak implementacji oznacza, że akcja „Otwórz” jest jawnie
/// niedostępna, a nie że udaje wykonaną.
// Interfejs ma jednego członka celowo: to seam kompozycji (adapter platformy
// w produkcji, fake w testach), a nie funkcja przekazywana argumentem.
// ignore: one_member_abstracts
abstract interface class ChatExternalLinkPort {
  /// Otwiera adres; `false` oznacza, że system go nie przyjął.
  Future<bool> open(String url);
}
