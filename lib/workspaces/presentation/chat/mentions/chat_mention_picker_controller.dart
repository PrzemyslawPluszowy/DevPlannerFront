import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:flutter/foundation.dart';

/// Stan zakotwiczonej listy podpowiedzi wzmianki `@`.
///
/// Kontroler sam debounce'uje frazę i odrzuca spóźnione odpowiedzi, więc lista
/// nigdy nie pokazuje kandydatów z poprzedniego wywołania. Nie zna widgetów ani
/// nawigacji: composer czyta z niego stan i przekazuje wybór dalej.
final class ChatMentionPickerController extends ChangeNotifier {
  /// Tworzy kontroler na porcie wyszukiwania rozmowy.
  ChatMentionPickerController({
    required this.repository,
    required this.conversationId,
    this.debounce = const Duration(milliseconds: 220),
    this.limit = 6,
    this.allTokenEnabled = false,
  });

  /// Minimalna długość frazy wymagana przez backend podpowiedzi.
  static const int minQueryLength = 2;

  final ChatSearchRepository repository;
  final String conversationId;
  final Duration debounce;
  final int limit;

  /// Czy wolno proponować wzmiankę `@all`.
  ///
  /// Zależy od roli i typu rozmowy, bo serwer odrzuca `@all` poza grupą/kanałem
  /// i poza rolą Owner/Moderator; UI nie pokazuje wtedy opcji, której nie da się
  /// wysłać. Zmiana flagi odświeża listę.
  bool allTokenEnabled;

  Timer? _timer;
  int _requestId = 0;
  ChatMentionQuery? _query;
  List<ChatMentionSuggestion> _suggestions = const <ChatMentionSuggestion>[];
  bool _isLoading = false;
  String? _failureCode;
  int _activeIndex = 0;
  bool _disposed = false;

  /// Czy wywołanie `@` jest aktywne, a więc czy lista ma się pokazać.
  bool get isOpen => _query != null;

  /// Czy fraza jest za krótka, żeby pytać backend.
  bool get isQueryTooShort =>
      (_query?.term.trim().length ?? 0) < minQueryLength;

  List<ChatMentionSuggestion> get suggestions => _suggestions;
  bool get isLoading => _isLoading;

  /// Kod domenowy błędu podpowiedzi albo `null`.
  String? get failureCode => _failureCode;

  int get activeIndex => _activeIndex;

  /// Aktualnie podświetlony kandydat.
  ChatMentionSuggestion? get active {
    if (_suggestions.isEmpty) return null;
    return _suggestions[_activeIndex.clamp(0, _suggestions.length - 1)];
  }

  /// Aktywne wywołanie `@` albo `null`, gdy lista jest zamknięta.
  ChatMentionQuery? get query => _query;

  /// Czy lista może zaproponować wzmiankę `@all`.
  ///
  /// Propozycja zależy od roli i typu rozmowy, bo serwer odrzuca `@all` poza
  /// grupą/kanałem i poza rolą Owner/Moderator; UI nie pokazuje wtedy opcji,
  /// której nie da się wysłać.
  /// Ustawia, czy wolno proponować `@all`; zmiana odświeża listę.
  void setAllTokenEnabled(bool value) {
    if (allTokenEnabled == value) return;
    allTokenEnabled = value;
    _notify();
  }

  /// Czy bieżąca fraza pasuje do tokenu `@all`.
  ///
  /// Puste `@` też pokazuje propozycję, żeby użytkownik nie musiał znać składni.
  bool get suggestsAll {
    if (!allTokenEnabled || _query == null) return false;
    final term = _query!.term.trim().toLowerCase();
    return term.isEmpty ||
        ChatMentionCodec.allToken.toLowerCase().startsWith('@$term');
  }

  /// Ustawia aktywne wywołanie wzmianki albo zamyka listę (`null`).
  void updateQuery(ChatMentionQuery? query) {
    _timer?.cancel();
    final requestId = ++_requestId;
    if (query == null) {
      _query = null;
      _suggestions = const <ChatMentionSuggestion>[];
      _failureCode = null;
      _isLoading = false;
      _activeIndex = 0;
      _notify();
      return;
    }
    _query = query;
    _failureCode = null;
    _activeIndex = 0;
    _suggestions = const <ChatMentionSuggestion>[];
    if (isQueryTooShort) {
      _isLoading = false;
      _notify();
      return;
    }
    _isLoading = true;
    _notify();
    _timer = Timer(debounce, () => unawaited(_load(query.term, requestId)));
  }

  /// Ponawia ostatnie zapytanie bez czekania na debounce.
  Future<void> retry() {
    final query = _query;
    if (query == null) return Future<void>.value();
    _timer?.cancel();
    _failureCode = null;
    _isLoading = true;
    _notify();
    return _load(query.term, ++_requestId);
  }

  /// Przesuwa podświetlenie w górę listy (z zawijaniem).
  void moveUp() => _move(-1);

  /// Przesuwa podświetlenie w dół listy (z zawijaniem).
  void moveDown() => _move(1);

  /// Wybiera podświetlonego kandydata; `null`, gdy lista jest pusta.
  ChatMentionSuggestion? confirmActive() => active;

  /// Zamyka listę bez zmiany tekstu.
  void close() => updateQuery(null);

  Future<void> _load(String term, int requestId) async {
    final result = await repository.suggestMentions(
      conversationId: conversationId,
      term: term,
    );
    // Spóźniona odpowiedź starszej frazy nie może nadpisać nowszej.
    if (_disposed || requestId != _requestId) return;
    result.fold(
      (error) {
        _isLoading = false;
        _failureCode = error.apiCode ?? error.message;
        _notify();
      },
      (items) {
        _isLoading = false;
        _suggestions = items;
        _activeIndex = 0;
        _notify();
      },
    );
  }

  void _move(int delta) {
    if (_suggestions.isEmpty) return;
    final next = _activeIndex + delta;
    _activeIndex = next < 0
        ? _suggestions.length - 1
        : next >= _suggestions.length
        ? 0
        : next;
    _notify();
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
