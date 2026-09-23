/// Gotowe statusy do wybrania jednym kliknięciem.
///
/// Preset niesie wyłącznie emoji i treść; etykiety i terminy są rozstrzygane
/// osobno, więc karta statusu nie wymaga ręcznego wpisywania emoji ani opisu.
enum ChatStatusPreset {
  /// Skupiona praca bez rozpraszania.
  focus,

  /// Udział w spotkaniu.
  inMeeting,

  /// Zaraz wracam.
  brb,

  /// W drodze.
  commuting,

  /// Przerwa na posiłek.
  lunch;

  /// Emoji presetu wybierane razem z treścią.
  String get emoji => switch (this) {
    ChatStatusPreset.focus => '🎯',
    ChatStatusPreset.inMeeting => '📅',
    ChatStatusPreset.brb => '⏳',
    ChatStatusPreset.commuting => '🚗',
    ChatStatusPreset.lunch => '🍽️',
  };
}

/// Warianty terminu wygaśnięcia statusu.
enum ChatStatusDurationOption {
  /// Status wygasa po godzinie.
  oneHour,

  /// Status wygasa z końcem lokalnego dnia.
  today,

  /// Status bez terminu.
  none,
}

/// Liczy termin wygaśnięcia statusu w czasie lokalnym.
///
/// „Dzisiaj” oznacza koniec lokalnego dnia, a nie +24 godziny, więc status
/// znika o północy także przy zmianie czasu; edycja istniejącego statusu bez
/// wyboru terminu nie zeruje go, bo decyzję podejmuje karta, nie ta funkcja.
abstract final class ChatStatusDurations {
  /// Termin wygaśnięcia dla wybranej opcji; `null` oznacza brak terminu.
  static DateTime? expiresAtLocal(
    ChatStatusDurationOption option,
    DateTime nowLocal,
  ) => switch (option) {
    ChatStatusDurationOption.oneHour => nowLocal.add(const Duration(hours: 1)),
    ChatStatusDurationOption.today => DateTime(
      nowLocal.year,
      nowLocal.month,
      nowLocal.day + 1,
    ),
    ChatStatusDurationOption.none => null,
  };
}
