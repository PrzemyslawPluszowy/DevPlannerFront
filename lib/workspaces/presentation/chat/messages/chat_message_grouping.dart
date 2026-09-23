import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';

/// Seria dymków jednego autora w jednym oddechu rozmowy.
///
/// Seria odpowiada jednej nazwie autora i jednemu awatarowi; kolejne dymki
/// w serii nie powtarzają ani nazwy, ani awatara, tylko odstęp.
final class ChatMessageSeries {
  ChatMessageSeries({
    required this.authorUserId,
    required this.isOwnAuthor,
    required List<ChatMessage> messages,
  }) : messages = List.unmodifiable(messages);

  /// Autor serii; identyfikuje ją razem z sesją.
  final String authorUserId;

  /// Czy serię wysłał bieżący użytkownik, czyli czy dymki idą na prawo.
  final bool isOwnAuthor;

  /// Wiadomości serii w kolejności historii.
  final List<ChatMessage> messages;

  /// Pierwsza wiadomość serii; tylko ona pokazuje autora i awatar.
  ChatMessage get first => messages.first;

  /// Ostatnia wiadomość serii; tylko ona zamyka stopkę metadanych.
  ChatMessage get last => messages.last;
}

/// Dzieli historię na serie dymków bez zgadywania stanu serwera.
///
/// Seria trwa, dopóki wiadomości mają tego samego autora, mieszczą się w oknie
/// czasu i nie przecinają granicy dnia; separator daty albo wiadomość systemowa
/// startuje nową serię, więc grupowanie resetuje się razem z historią.
abstract final class ChatMessageGrouping {
  /// Maksymalna przerwa, przy której kolejna wiadomość zostaje w serii.
  static const Duration defaultWindow = Duration(minutes: 5);

  /// Liczy nowe wiadomości nowsze od dotychczasowego końca historii.
  ///
  /// Starsza strona dodana przy paginacji nie może zostać pokazana jako
  /// „nowe wiadomości”; identyfikator odfiltrowuje też aktualizacje/duplikaty.
  static int countNewArrivals(
    List<ChatMessage> previous,
    List<ChatMessage> current,
  ) {
    if (previous.isEmpty || current.length <= previous.length) return 0;
    final previousIds = previous.map((message) => message.id).toSet();
    final previousNewest = previous
        .map((message) => message.createdAtUtc)
        .reduce((left, right) => left.isAfter(right) ? left : right);
    return current
        .where(
          (message) =>
              !previousIds.contains(message.id) &&
              !message.createdAtUtc.isBefore(previousNewest),
        )
        .length;
  }

  /// Buduje serie dla historii widocznej na ekranie.
  static List<ChatMessageSeries> group(
    List<ChatMessage> messages, {
    required String currentUserId,
    Duration window = defaultWindow,
    DateTime Function(DateTime utc)? toLocal,
  }) {
    if (messages.isEmpty) return const <ChatMessageSeries>[];
    final local = toLocal ?? (value) => value.toLocal();
    final series = <ChatMessageSeries>[];
    var current = <ChatMessage>[messages.first];

    for (final message in messages.skip(1)) {
      if (_continues(current.last, message, window: window, toLocal: local)) {
        current.add(message);
        continue;
      }
      series.add(_build(current, currentUserId));
      current = <ChatMessage>[message];
    }
    series.add(_build(current, currentUserId));
    return series;
  }

  static bool _continues(
    ChatMessage previous,
    ChatMessage next, {
    required Duration window,
    required DateTime Function(DateTime utc) toLocal,
  }) {
    if (previous.authorUserId != next.authorUserId) return false;
    if (previous.isDeleted != next.isDeleted) return false;
    final previousLocal = toLocal(previous.createdAtUtc);
    final nextLocal = toLocal(next.createdAtUtc);
    if (previousLocal.year != nextLocal.year ||
        previousLocal.month != nextLocal.month ||
        previousLocal.day != nextLocal.day) {
      return false;
    }
    final gap = nextLocal.difference(previousLocal);
    return !gap.isNegative && gap <= window;
  }

  static ChatMessageSeries _build(List<ChatMessage> messages, String userId) =>
      ChatMessageSeries(
        authorUserId: messages.first.authorUserId,
        isOwnAuthor: userId.isNotEmpty && messages.first.authorUserId == userId,
        messages: messages,
      );

  /// Buduje historię z separatorami dni między seriami.
  ///
  /// Separator jest osobnym elementem listy, więc grupowanie resetuje się na
  /// granicy dnia dokładnie tak samo, jak przy zmianie autora czy okna czasu.
  static List<ChatTimelineEntry> timeline(
    List<ChatMessage> messages, {
    required String currentUserId,
    Duration window = defaultWindow,
    DateTime Function(DateTime utc)? toLocal,
  }) {
    final local = toLocal ?? (value) => value.toLocal();
    final entries = <ChatTimelineEntry>[];
    DateTime? previousDay;
    for (final series in group(
      messages,
      currentUserId: currentUserId,
      window: window,
      toLocal: local,
    )) {
      final first = local(series.first.createdAtUtc);
      final day = DateTime(first.year, first.month, first.day);
      if (previousDay == null || day != previousDay) {
        entries.add(ChatTimelineDate(day));
        previousDay = day;
      }
      entries.add(ChatTimelineSeries(series));
    }
    return entries;
  }
}

/// Element historii: seria dymków albo separator dnia.
sealed class ChatTimelineEntry {
  const ChatTimelineEntry();
}

/// Separator dnia poprzedzający serie z tego dnia.
final class ChatTimelineDate extends ChatTimelineEntry {
  /// Tworzy separator dla lokalnego początku dnia.
  const ChatTimelineDate(this.day);

  final DateTime day;
}

/// Seria dymków jednego autora.
final class ChatTimelineSeries extends ChatTimelineEntry {
  /// Tworzy element historii z jedną serią.
  const ChatTimelineSeries(this.series);

  final ChatMessageSeries series;
}
