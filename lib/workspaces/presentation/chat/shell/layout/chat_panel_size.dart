import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// Rozmiar i tryb panelu komunikatora.
///
/// Panel startuje z około 30% szerokości okna, więc nie dominuje ekranu; dopóki
/// użytkownik nie użyje uchwytu, szerokość idzie za oknem. Uchwyt zmienia ją
/// w granicach 320–1120 px i jest ponownie ograniczany do okna po zmianie jego
/// rozmiaru. Powyżej progu 760 px panel pokazuje trzy kolumny, poniżej — rail
/// i jedną kolumnę.
///
/// Zwijanie gestem: przeciągnięcie uchwytu poza minimum zbiera nadwyżkę ruchu,
/// a gdy przekroczy 5% szerokości okna, panel zamyka się animacją. Dzięki temu
/// gest „odciągnij w lewo” zamyka komunikator, a samo dojście do minimum nie
/// zamyka go przypadkiem.
final class ChatPanelSizeController extends ChangeNotifier {
  /// Domyślna szerokość panelu jako część szerokości okna.
  static const double defaultWidthFraction = .3;

  /// Minimalna szerokość panelu.
  static const double minWidth = 320;

  /// Maksymalna szerokość panelu.
  static const double maxWidth = 1120;

  /// Szerokość railu w trybie szerokim.
  static const double wideRailWidth = 56;

  /// Szerokość railu w trybie compact.
  static const double compactRailWidth = 52;

  /// Minimalna szerokość kolumny listy.
  static const double listMinWidth = 304;

  /// Maksymalna szerokość kolumny listy.
  static const double listMaxWidth = 344;

  /// Minimalna szerokość kolumny rozmowy w trybie szerokim.
  static const double conversationMinWidth = 360;

  /// Poniżej tej szerokości panel pokazuje rail i jedną kolumnę.
  static const double compactBreakpoint = 760;

  /// Minimalna użyteczna szerokość treści aplikacji obok przypiętego panelu.
  ///
  /// Gdy okno nie mieści panelu i tej szerokości razem, przypięcie schodzi
  /// tymczasowo do nakładki zamiast zgniatać treść aplikacji.
  static const double minAppContentWidth = 480;

  /// Szerokość uchwytu zmiany rozmiaru.
  static const double resizeHandleWidth = 12;

  /// Nadwyżka przeciągnięcia poza minimum, która zwija panel (5% szerokości okna).
  static const double collapseDragFraction = .05;

  double? _rememberedWidth;
  bool _pinned = false;
  double _collapseDrag = 0;

  /// Czy panel jest przypięty i rezerwuje miejsce w layoucie.
  bool get pinned => _pinned;

  /// Czy użytkownik wybrał własną szerokość uchwytem.
  bool get hasCustomWidth => _rememberedWidth != null;

  /// Szerokość panelu ograniczona do dostępnej przestrzeni.
  ///
  /// Metoda jest czysta: wywołanie w `build` nie emituje zmiany stanu i nie
  /// może wywołać pętli przebudowy.
  double effectiveWidth(double available) {
    if (available <= 0) return 0;
    final target = _rememberedWidth ?? available * defaultWidthFraction;
    return _clamp(target, available);
  }

  /// Czy w oknie jest miejsce na przypięcie panelu obok użytecznej treści.
  ///
  /// Liczba kolumn czatu zależy od szerokości panelu, a ta decyzja od szerokości
  /// okna: wąski panel na szerokim ekranie nadal może się przypiąć, a szeroki
  /// panel w ciasnym oknie nie może, bo zgniótłby treść aplikacji.
  bool canPinAt(double available) {
    if (available <= 0) return false;
    return available - effectiveWidth(available) >= minAppContentWidth;
  }

  /// Ustawia tryb przypięcia panelu.
  void setPinned({required bool pinned}) {
    if (_pinned == pinned) return;
    _pinned = pinned;
    notifyListeners();
  }

  /// Zaczyna przeciąganie uchwytu; nadwyżka zwijania liczy się od nowa.
  void beginResize() => _collapseDrag = 0;

  /// Zmienia szerokość o przyrost z uchwytu.
  ///
  /// Panel nie schodzi poniżej minimum, ale nadwyżka ruchu w lewo jest liczona
  /// i rozstrzyga o zwinięciu po zakończeniu gestu.
  void resizeBy(double delta, {required double available}) {
    if (delta == 0 || available <= 0) return;
    final lower = _lowerBound(available);
    final upper = _upperBound(available);
    final current = effectiveWidth(available);
    final next = current + delta;
    final excess = next < lower ? lower - next : 0;
    final clamped = next.clamp(lower, upper);
    final changed = clamped != current;
    if (changed) _rememberedWidth = clamped;
    // Nadwyżka rośnie tylko przy ruchu w lewo: ruch w prawo kasuje kandydata
    // na zwinięcie, żeby gest był jednoznaczny.
    if (excess > 0) {
      _collapseDrag += excess;
    } else if (delta > 0) {
      _collapseDrag = 0;
    }
    if (changed || excess > 0 || delta > 0) notifyListeners();
  }

  /// Kończy przeciąganie i mówi, czy gest przekroczył próg zwinięcia.
  bool endResize({required double available}) {
    final collapse =
        available > 0 && _collapseDrag > available * collapseDragFraction;
    _collapseDrag = 0;
    return collapse;
  }

  /// Wraca do szerokości domyślnej (30% okna).
  void reset() {
    if (_rememberedWidth == null) return;
    _rememberedWidth = null;
    notifyListeners();
  }

  static double _lowerBound(double available) => math.min(minWidth, available);

  static double _upperBound(double available) =>
      math.max(_lowerBound(available), math.min(maxWidth, available));

  /// Ogranicza szerokość do okna i do dopuszczalnego zakresu panelu.
  static double _clamp(double value, double available) =>
      value.clamp(_lowerBound(available), _upperBound(available));
}
