import 'dart:ui' show lerpDouble;

import 'package:devplanner/foundation/theme/menu_theme.dart';
import 'package:flutter/material.dart';

/// Tokeny wyglądu komunikatora: role powierzchni, dymków, metadanych i miar.
///
/// Powstają z jednego, jawnego mapowania palety DevPlanner, żeby widgety czatu
/// nie używały przypadkowo `primaryContainer`/`secondaryContainer` ani
/// domyślnego fioletu Material. Miary żyją tutaj razem z kolorami, bo dymek,
/// composer i rail muszą trzymać te same wartości w panelu, historii i wątku.
final class DevPlannerChatTheme extends ThemeExtension<DevPlannerChatTheme> {
  const DevPlannerChatTheme({
    required this.panelSurface,
    required this.listSurface,
    required this.conversationSurface,
    required this.composerSurface,
    required this.incomingBubble,
    required this.outgoingBubble,
    required this.incomingText,
    required this.outgoingText,
    required this.metadataText,
    required this.linkText,
    required this.actionText,
    required this.mentionSurface,
    required this.mentionText,
    required this.codeSurface,
    required this.separator,
    required this.hoverSurface,
    required this.selectedSurface,
    required this.focusRing,
    required this.presenceOnline,
    required this.presenceAway,
    required this.presenceDnd,
    required this.presenceUnknown,
    required this.deliveryRead,
    required this.error,
    required this.sendButtonSurface,
    required this.sendButtonForeground,
    required this.contentStyle,
    required this.authorStyle,
    required this.metadataStyle,
    required this.monospaceStyle,
    required this.bubbleRadius,
    required this.bubblePadding,
    required this.composerRadius,
    required this.seriesGap,
    required this.authorGap,
    required this.historyGutter,
    required this.compactHistoryGutter,
    required this.maxBubbleWidthFactor,
    required this.compactMaxBubbleWidthFactor,
    required this.maxBubbleWidth,
    required this.railWidth,
    required this.railButtonSize,
    required this.railIconSize,
    required this.railGap,
    required this.composerActionSize,
    required this.composerIconSize,
    required this.composerMinLines,
    required this.composerMaxLines,
    required this.composerMaxHeight,
    required this.avatarInbox,
    required this.avatarHeader,
    required this.avatarBubble,
    required this.avatarList,
  });

  /// Buduje niezależne tokeny komunikatora dla aktywnego trybu jasnego/ciemnego.
  factory DevPlannerChatTheme.of(TextTheme text, ColorScheme colors) {
    final body = text.bodyMedium ?? const TextStyle();
    final label = text.labelSmall ?? body;
    final isDark = colors.brightness == Brightness.dark;
    // Dedykowana paleta czatu: neutralne grafity, wyraźna zieleń wysyłania i
    // odczytu oraz spokojne powierzchnie rozmowy. Nie dziedziczy niebieskiego
    // primaryContainer Material, które wcześniej przebijało w dymkach/menu.
    final panel = isDark ? const Color(0xff111b21) : const Color(0xfff0f2f5);
    final list = isDark ? const Color(0xff111b21) : const Color(0xffffffff);
    final conversation = isDark
        ? const Color(0xff0b141a)
        : const Color(0xffefeae2);
    final composer = isDark ? const Color(0xff202c33) : const Color(0xffffffff);
    final incoming = isDark ? const Color(0xff202c33) : const Color(0xffffffff);
    final outgoing = isDark ? const Color(0xff005c4b) : const Color(0xffd9fdd3);
    const accent = Color(0xff00a884);
    final foreground = isDark
        ? const Color(0xffe9edef)
        : const Color(0xff111b21);
    final metadata = isDark ? const Color(0xff8696a0) : const Color(0xff667781);
    final separator = isDark
        ? const Color(0xff2a3942)
        : const Color(0xffe9edef);
    final code = isDark ? const Color(0xff182229) : const Color(0xfff5f6f6);
    final link = isDark ? const Color(0xff53bdeb) : const Color(0xff027eb5);
    final subtle = isDark ? const Color(0xff2a3942) : const Color(0xfff5f6f6);
    return DevPlannerChatTheme(
      panelSurface: panel,
      listSurface: list,
      conversationSurface: conversation,
      composerSurface: composer,
      incomingBubble: incoming,
      outgoingBubble: outgoing,
      incomingText: foreground,
      outgoingText: isDark ? const Color(0xffe9edef) : const Color(0xff111b21),
      metadataText: metadata,
      linkText: link,
      // Tekst akcji ma kontrastowy zielony; linki w wiadomościach zachowują
      // niebieski odcień właściwy dla treści, nie dla kontrolek.
      actionText: isDark ? const Color(0xff25d366) : const Color(0xff008069),
      mentionSurface: accent.withValues(alpha: .14),
      mentionText: accent,
      codeSurface: code,
      separator: separator,
      hoverSurface: subtle,
      selectedSurface: isDark
          ? const Color(0xff233138)
          : const Color(0xffe9edef),
      focusRing: accent,
      presenceOnline: const Color(0xff25d366),
      presenceAway: const Color(0xffffb74d),
      presenceDnd: colors.error,
      presenceUnknown: metadata,
      deliveryRead: isDark ? const Color(0xff53bdeb) : const Color(0xff34b7f1),
      error: colors.error,
      sendButtonSurface: accent,
      sendButtonForeground: const Color(0xffffffff),
      contentStyle: body.copyWith(fontSize: 14, height: 1.4),
      authorStyle: (text.bodySmall ?? body).copyWith(
        fontSize: 12.5,
        height: 1.2,
        fontWeight: FontWeight.w500,
      ),
      metadataStyle: label.copyWith(fontSize: 11.5, height: 1.25),
      monospaceStyle: body.copyWith(
        fontSize: 13,
        height: 1.4,
        fontFamily: 'monospace',
        fontFamilyFallback: const ['Menlo', 'Consolas', 'Courier New'],
      ),
      bubbleRadius: 16,
      bubblePadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      composerRadius: 20,
      seriesGap: 4,
      authorGap: 12,
      historyGutter: 16,
      compactHistoryGutter: 12,
      maxBubbleWidthFactor: .78,
      compactMaxBubbleWidthFactor: .88,
      maxBubbleWidth: 560,
      railWidth: 56,
      railButtonSize: 40,
      railIconSize: 22,
      railGap: 8,
      composerActionSize: 40,
      composerIconSize: 20,
      composerMinLines: 1,
      composerMaxLines: 6,
      composerMaxHeight: 160,
      avatarInbox: 44,
      avatarHeader: 36,
      avatarBubble: 30,
      avatarList: 36,
    );
  }

  /// Nakłada wygląd kontrolek komunikatora na bazowy motyw aplikacji.
  ///
  /// Używane wyłącznie wewnątrz globalnego panelu Chat, aby przyciski,
  /// formularze i wskaźniki ładowania nie odziedziczyły przypadkowych
  /// stylów z pozostałych modułów.
  ThemeData applyControls(ThemeData base) {
    final controls = base.copyWith(
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: metadataText,
          disabledForegroundColor: metadataText.withValues(alpha: .5),
          hoverColor: hoverSurface,
          highlightColor: hoverSurface,
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.all(8),
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textSelectionTheme: base.textSelectionTheme.copyWith(
        cursorColor: focusRing,
        selectionColor: focusRing.withValues(alpha: .24),
        selectionHandleColor: focusRing,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: actionText,
          disabledForegroundColor: metadataText,
          textStyle: authorStyle.copyWith(fontSize: 13),
          minimumSize: const Size(36, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          overlayColor: hoverSurface,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sendButtonSurface,
          foregroundColor: sendButtonForeground,
          disabledBackgroundColor: separator,
          disabledForegroundColor: metadataText,
          textStyle: authorStyle.copyWith(fontSize: 13),
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          overlayColor: hoverSurface,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: incomingText,
          backgroundColor: listSurface,
          disabledForegroundColor: metadataText,
          side: BorderSide(color: separator),
          textStyle: authorStyle.copyWith(fontSize: 13),
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          overlayColor: hoverSurface,
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: composerSurface,
        hintStyle: contentStyle.copyWith(color: metadataText),
        labelStyle: metadataStyle.copyWith(color: metadataText),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: separator),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: focusRing, width: 1.5),
        ),
        errorStyle: metadataStyle.copyWith(color: error),
      ),
      progressIndicatorTheme: base.progressIndicatorTheme.copyWith(
        color: focusRing,
      ),
    );
    final baseMenu = base.extension<DevPlannerMenuTheme>();
    if (baseMenu == null) return controls;
    return controls.copyWith(
      extensions: [
        for (final extension in controls.extensions.values)
          if (extension is! DevPlannerMenuTheme) extension,
        applyMenuTheme(baseMenu),
      ],
    );
  }

  /// Dopasowuje wspólne menu kontekstowe do powierzchni i akcentów Chatu.
  DevPlannerMenuTheme applyMenuTheme(DevPlannerMenuTheme base) => base.copyWith(
    itemText: contentStyle.copyWith(fontSize: 13, height: 18 / 13),
    sectionText: metadataStyle.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: .4,
    ),
    shortcutText: metadataStyle.copyWith(fontSize: 11),
    rowHeight: 40,
    iconSize: 18,
    minWidth: 232,
    maxWidth: 340,
    radius: 14,
    padding: 6,
    surface: panelSurface,
    border: separator,
    shadow: Colors.black,
    divider: separator,
    itemForeground: incomingText,
    itemHover: hoverSurface,
    itemSelectedForeground: focusRing,
    itemSelectedSurface: selectedSurface,
    sectionForeground: metadataText,
    destructive: error,
    destructiveHover: error.withValues(alpha: .12),
  );

  /// Tło całego panelu komunikatora.
  final Color panelSurface;

  /// Powierzchnia listy rozmów.
  final Color listSurface;

  /// Tło obszaru historii wiadomości.
  final Color conversationSurface;

  /// Powierzchnia pola pisania.
  final Color composerSurface;

  /// Dymek wiadomości przychodzącej.
  final Color incomingBubble;

  /// Dymek wiadomości wychodzącej.
  final Color outgoingBubble;

  /// Kolor treści w dymku przychodzącym.
  final Color incomingText;

  /// Kolor treści w dymku wychodzącym.
  final Color outgoingText;

  /// Kolor czasu, edycji i statusu dostawy.
  final Color metadataText;

  /// Kolor linku w treści.
  final Color linkText;

  /// Kolor tekstowych akcji w dialogach i kontrolkach Chat.
  final Color actionText;

  /// Tło wzmianki `@osoba`.
  final Color mentionSurface;

  /// Kolor tekstu wzmianki.
  final Color mentionText;

  /// Tło bloku kodu.
  final Color codeSurface;

  /// Kolor separatorów i delikatnych obramowań.
  final Color separator;

  /// Tło pod kursorem lub fokusem.
  final Color hoverSurface;

  /// Tło wybranej pozycji.
  final Color selectedSurface;

  /// Obwódka fokusu aktywnej kontrolki.
  final Color focusRing;

  /// Znacznik obecności: online.
  final Color presenceOnline;

  /// Znacznik obecności: zaraz wracam.
  final Color presenceAway;

  /// Znacznik obecności: nie przeszkadzać.
  final Color presenceDnd;

  /// Znacznik obecności, gdy brak danych.
  final Color presenceUnknown;

  /// Znacznik potwierdzonego odczytu.
  final Color deliveryRead;

  /// Kolor błędu i akcji destrukcyjnych.
  final Color error;

  /// Tło okrągłego przycisku wysyłki.
  final Color sendButtonSurface;

  /// Ikona na tle przycisku wysyłki.
  final Color sendButtonForeground;

  /// Styl treści wiadomości i pola pisania.
  final TextStyle contentStyle;

  /// Styl nazwy autora w dymku.
  final TextStyle authorStyle;

  /// Styl czasu, edycji i statusu.
  final TextStyle metadataStyle;

  /// Styl kodu; monospace wyłącznie dla kodu.
  final TextStyle monospaceStyle;

  /// Promień dymka.
  final double bubbleRadius;

  /// Wewnętrzny odstęp dymka.
  final EdgeInsets bubblePadding;

  /// Promień powierzchni pisania.
  final double composerRadius;

  /// Odstęp między dymkami jednej serii.
  final double seriesGap;

  /// Odstęp między seriami różnych autorów.
  final double authorGap;

  /// Boczny gutter historii.
  final double historyGutter;

  /// Boczny gutter historii w trybie compact.
  final double compactHistoryGutter;

  /// Maksymalna szerokość dymka jako udział szerokości historii.
  final double maxBubbleWidthFactor;

  /// Maksymalna szerokość dymka w trybie compact.
  final double compactMaxBubbleWidthFactor;

  /// Twardy limit szerokości dymka w pikselach.
  final double maxBubbleWidth;

  /// Szerokość belki sekcji.
  final double railWidth;

  /// Bok przycisku belki sekcji.
  final double railButtonSize;

  /// Rozmiar ikony belki sekcji.
  final double railIconSize;

  /// Odstęp między przyciskami belki sekcji.
  final double railGap;

  /// Bok akcji composera (dotyk 44).
  final double composerActionSize;

  /// Rozmiar ikony akcji composera.
  final double composerIconSize;

  /// Minimalna liczba linii pola pisania.
  final int composerMinLines;

  /// Liczba linii, po której pole pisania przewija wnętrze.
  final int composerMaxLines;

  /// Twardy limit wysokości pola pisania.
  final double composerMaxHeight;

  /// Bok awatara na liście rozmów.
  final double avatarInbox;

  /// Bok awatara w nagłówku rozmowy.
  final double avatarHeader;

  /// Bok awatara w dymku.
  final double avatarBubble;

  /// Bok awatara na liście osób.
  final double avatarList;

  @override
  DevPlannerChatTheme copyWith({
    Color? panelSurface,
    Color? listSurface,
    Color? conversationSurface,
    Color? composerSurface,
    Color? incomingBubble,
    Color? outgoingBubble,
    Color? incomingText,
    Color? outgoingText,
    Color? metadataText,
    Color? linkText,
    Color? actionText,
    Color? mentionSurface,
    Color? mentionText,
    Color? codeSurface,
    Color? separator,
    Color? hoverSurface,
    Color? selectedSurface,
    Color? focusRing,
    Color? presenceOnline,
    Color? presenceAway,
    Color? presenceDnd,
    Color? presenceUnknown,
    Color? deliveryRead,
    Color? error,
    Color? sendButtonSurface,
    Color? sendButtonForeground,
    TextStyle? contentStyle,
    TextStyle? authorStyle,
    TextStyle? metadataStyle,
    TextStyle? monospaceStyle,
    double? bubbleRadius,
    EdgeInsets? bubblePadding,
    double? composerRadius,
    double? seriesGap,
    double? authorGap,
    double? historyGutter,
    double? compactHistoryGutter,
    double? maxBubbleWidthFactor,
    double? compactMaxBubbleWidthFactor,
    double? maxBubbleWidth,
    double? railWidth,
    double? railButtonSize,
    double? railIconSize,
    double? railGap,
    double? composerActionSize,
    double? composerIconSize,
    int? composerMinLines,
    int? composerMaxLines,
    double? composerMaxHeight,
    double? avatarInbox,
    double? avatarHeader,
    double? avatarBubble,
    double? avatarList,
  }) => DevPlannerChatTheme(
    panelSurface: panelSurface ?? this.panelSurface,
    listSurface: listSurface ?? this.listSurface,
    conversationSurface: conversationSurface ?? this.conversationSurface,
    composerSurface: composerSurface ?? this.composerSurface,
    incomingBubble: incomingBubble ?? this.incomingBubble,
    outgoingBubble: outgoingBubble ?? this.outgoingBubble,
    incomingText: incomingText ?? this.incomingText,
    outgoingText: outgoingText ?? this.outgoingText,
    metadataText: metadataText ?? this.metadataText,
    linkText: linkText ?? this.linkText,
    actionText: actionText ?? this.actionText,
    mentionSurface: mentionSurface ?? this.mentionSurface,
    mentionText: mentionText ?? this.mentionText,
    codeSurface: codeSurface ?? this.codeSurface,
    separator: separator ?? this.separator,
    hoverSurface: hoverSurface ?? this.hoverSurface,
    selectedSurface: selectedSurface ?? this.selectedSurface,
    focusRing: focusRing ?? this.focusRing,
    presenceOnline: presenceOnline ?? this.presenceOnline,
    presenceAway: presenceAway ?? this.presenceAway,
    presenceDnd: presenceDnd ?? this.presenceDnd,
    presenceUnknown: presenceUnknown ?? this.presenceUnknown,
    deliveryRead: deliveryRead ?? this.deliveryRead,
    error: error ?? this.error,
    sendButtonSurface: sendButtonSurface ?? this.sendButtonSurface,
    sendButtonForeground: sendButtonForeground ?? this.sendButtonForeground,
    contentStyle: contentStyle ?? this.contentStyle,
    authorStyle: authorStyle ?? this.authorStyle,
    metadataStyle: metadataStyle ?? this.metadataStyle,
    monospaceStyle: monospaceStyle ?? this.monospaceStyle,
    bubbleRadius: bubbleRadius ?? this.bubbleRadius,
    bubblePadding: bubblePadding ?? this.bubblePadding,
    composerRadius: composerRadius ?? this.composerRadius,
    seriesGap: seriesGap ?? this.seriesGap,
    authorGap: authorGap ?? this.authorGap,
    historyGutter: historyGutter ?? this.historyGutter,
    compactHistoryGutter: compactHistoryGutter ?? this.compactHistoryGutter,
    maxBubbleWidthFactor: maxBubbleWidthFactor ?? this.maxBubbleWidthFactor,
    compactMaxBubbleWidthFactor:
        compactMaxBubbleWidthFactor ?? this.compactMaxBubbleWidthFactor,
    maxBubbleWidth: maxBubbleWidth ?? this.maxBubbleWidth,
    railWidth: railWidth ?? this.railWidth,
    railButtonSize: railButtonSize ?? this.railButtonSize,
    railIconSize: railIconSize ?? this.railIconSize,
    railGap: railGap ?? this.railGap,
    composerActionSize: composerActionSize ?? this.composerActionSize,
    composerIconSize: composerIconSize ?? this.composerIconSize,
    composerMinLines: composerMinLines ?? this.composerMinLines,
    composerMaxLines: composerMaxLines ?? this.composerMaxLines,
    composerMaxHeight: composerMaxHeight ?? this.composerMaxHeight,
    avatarInbox: avatarInbox ?? this.avatarInbox,
    avatarHeader: avatarHeader ?? this.avatarHeader,
    avatarBubble: avatarBubble ?? this.avatarBubble,
    avatarList: avatarList ?? this.avatarList,
  );

  @override
  DevPlannerChatTheme lerp(
    ThemeExtension<DevPlannerChatTheme>? other,
    double t,
  ) {
    if (other is! DevPlannerChatTheme) return this;
    return DevPlannerChatTheme(
      panelSurface: Color.lerp(panelSurface, other.panelSurface, t)!,
      listSurface: Color.lerp(listSurface, other.listSurface, t)!,
      conversationSurface: Color.lerp(
        conversationSurface,
        other.conversationSurface,
        t,
      )!,
      composerSurface: Color.lerp(composerSurface, other.composerSurface, t)!,
      incomingBubble: Color.lerp(incomingBubble, other.incomingBubble, t)!,
      outgoingBubble: Color.lerp(outgoingBubble, other.outgoingBubble, t)!,
      incomingText: Color.lerp(incomingText, other.incomingText, t)!,
      outgoingText: Color.lerp(outgoingText, other.outgoingText, t)!,
      metadataText: Color.lerp(metadataText, other.metadataText, t)!,
      linkText: Color.lerp(linkText, other.linkText, t)!,
      actionText: Color.lerp(actionText, other.actionText, t)!,
      mentionSurface: Color.lerp(mentionSurface, other.mentionSurface, t)!,
      mentionText: Color.lerp(mentionText, other.mentionText, t)!,
      codeSurface: Color.lerp(codeSurface, other.codeSurface, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      hoverSurface: Color.lerp(hoverSurface, other.hoverSurface, t)!,
      selectedSurface: Color.lerp(selectedSurface, other.selectedSurface, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      presenceOnline: Color.lerp(presenceOnline, other.presenceOnline, t)!,
      presenceAway: Color.lerp(presenceAway, other.presenceAway, t)!,
      presenceDnd: Color.lerp(presenceDnd, other.presenceDnd, t)!,
      presenceUnknown: Color.lerp(presenceUnknown, other.presenceUnknown, t)!,
      deliveryRead: Color.lerp(deliveryRead, other.deliveryRead, t)!,
      error: Color.lerp(error, other.error, t)!,
      sendButtonSurface: Color.lerp(
        sendButtonSurface,
        other.sendButtonSurface,
        t,
      )!,
      sendButtonForeground: Color.lerp(
        sendButtonForeground,
        other.sendButtonForeground,
        t,
      )!,
      contentStyle: TextStyle.lerp(contentStyle, other.contentStyle, t)!,
      authorStyle: TextStyle.lerp(authorStyle, other.authorStyle, t)!,
      metadataStyle: TextStyle.lerp(metadataStyle, other.metadataStyle, t)!,
      monospaceStyle: TextStyle.lerp(monospaceStyle, other.monospaceStyle, t)!,
      bubbleRadius: lerpDouble(bubbleRadius, other.bubbleRadius, t)!,
      bubblePadding: EdgeInsets.lerp(bubblePadding, other.bubblePadding, t)!,
      composerRadius: lerpDouble(composerRadius, other.composerRadius, t)!,
      seriesGap: lerpDouble(seriesGap, other.seriesGap, t)!,
      authorGap: lerpDouble(authorGap, other.authorGap, t)!,
      historyGutter: lerpDouble(historyGutter, other.historyGutter, t)!,
      compactHistoryGutter: lerpDouble(
        compactHistoryGutter,
        other.compactHistoryGutter,
        t,
      )!,
      maxBubbleWidthFactor: lerpDouble(
        maxBubbleWidthFactor,
        other.maxBubbleWidthFactor,
        t,
      )!,
      compactMaxBubbleWidthFactor: lerpDouble(
        compactMaxBubbleWidthFactor,
        other.compactMaxBubbleWidthFactor,
        t,
      )!,
      maxBubbleWidth: lerpDouble(maxBubbleWidth, other.maxBubbleWidth, t)!,
      railWidth: lerpDouble(railWidth, other.railWidth, t)!,
      railButtonSize: lerpDouble(railButtonSize, other.railButtonSize, t)!,
      railIconSize: lerpDouble(railIconSize, other.railIconSize, t)!,
      railGap: lerpDouble(railGap, other.railGap, t)!,
      composerActionSize: lerpDouble(
        composerActionSize,
        other.composerActionSize,
        t,
      )!,
      composerIconSize: lerpDouble(
        composerIconSize,
        other.composerIconSize,
        t,
      )!,
      composerMinLines: composerMinLines,
      composerMaxLines: composerMaxLines,
      composerMaxHeight: lerpDouble(
        composerMaxHeight,
        other.composerMaxHeight,
        t,
      )!,
      avatarInbox: lerpDouble(avatarInbox, other.avatarInbox, t)!,
      avatarHeader: lerpDouble(avatarHeader, other.avatarHeader, t)!,
      avatarBubble: lerpDouble(avatarBubble, other.avatarBubble, t)!,
      avatarList: lerpDouble(avatarList, other.avatarList, t)!,
    );
  }
}

/// Odczyt tokenów czatu bez kopiowania ról i miar do widgetów.
extension DevPlannerChatThemeContextX on BuildContext {
  DevPlannerChatTheme get chatTheme {
    final theme = Theme.of(this);
    return theme.extension<DevPlannerChatTheme>() ??
        DevPlannerChatTheme.of(theme.textTheme, theme.colorScheme);
  }
}
