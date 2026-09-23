import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// Rozmiar i tryb panelu komunikatora.
///
/// Panel startuje tak szeroko, by na desktopie od razu pokazać rail, inbox i
/// rozmowę. Cel to 75% okna, z minimum obejmującym układ trzech kolumn oraz
/// uchwyt; szerokość jest ograniczana do 1120 px. Uchwyt pozwala zmienić ją
/// w granicach 320–1120 px. Próg modalności dotyczy całego okna, nie liczby
/// kolumn.
///
/// Zwijanie gestem: przeciągnięcie uchwytu poza minimum zbiera nadwyżkę ruchu,
/// a gdy przekroczy 5% szerokości okna, panel zamyka się animacją. Dzięki temu
/// gest „odciągnij w lewo” zamyka komunikator, a samo dojście do minimum nie
/// zamyka go przypadkiem.
final class ChatPanelSizeController extends ChangeNotifier {
  /// Domyślna szerokość panelu jako część szerokości okna.
  static const double defaultWidthFraction = .75;

  /// Uchwyt plus minimalna szerokość railu, inboxa i rozmowy.
  static const double defaultMultiColumnWidth = 734;

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

  /// Próg szerokości okna, poniżej którego host pokazuje modalny panel.
  static const double compactBreakpoint = 960;

  /// Poniżej tej szerokości panel zastępuje rail przyciskiem sekcji w treści.
  ///
  /// 56-pikselowej belki nie ściskamy do kilku pikseli: przy tak wąskim oknie
  /// wybór sekcji przenosi się do przycisku nad listą albo rozmową.
  static const double narrowBreakpoint = 400;

  /// Szerokość separatora między kolumnami panelu.
  static const double separatorWidth = 1;

  /// Szerokość belki sekcji; nigdy nie skaluje się z szerokością okna.
  static double railWidth(bool compact) =>
      compact ? compactRailWidth : wideRailWidth;

  /// Czy w dostępnej szerokości mieszczą się dwie kolumny treści panelu.
  ///
  /// Breakpoint liczymy z faktycznych constraints, a nie z rozmiaru monitora:
  /// dwie kolumny wchodzą dopiero, gdy po belce zostaje miejsce na listę
  /// minimum 304 px i rozmowę minimum 360 px razem z separatorami.
  static bool fitsTwoColumns({
    required double available,
    required bool compactRail,
  }) {
    if (available <= 0) return false;
    return available >= twoColumnMinimumWidth(compactRail: compactRail);
  }

  /// Minimalna szerokość całego panelu potrzebna dla listy i rozmowy obok.
  static double twoColumnMinimumWidth({required bool compactRail}) =>
      railWidth(compactRail) +
      separatorWidth * 2 +
      listMinWidth +
      conversationMinWidth;

  /// Szerokość kolumny listy dla dostępnej szerokości całego panelu.
  ///
  /// Gdy układ ledwo mieści dwa widoki, lista dostaje dokładnie minimum;
  /// dopiero nadwyżka powiększa ją do wygodnego maksimum. Bez tego próg
  /// trzykolumnowy i faktyczna szerokość `ChatPanelListPane` rozjeżdżają się.
  static double listColumnWidth({
    required double available,
    required bool compactRail,
  }) {
    final contentWidth =
        available -
        railWidth(compactRail) -
        separatorWidth * 2 -
        conversationMinWidth;
    return contentWidth.clamp(listMinWidth, listMaxWidth);
  }

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
    final target =
        _rememberedWidth ??
        math.max(
          available * defaultWidthFraction,
          defaultMultiColumnWidth,
        );
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

  /// Wraca do domyślnej szerokości wielokolumnowego panelu.
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
