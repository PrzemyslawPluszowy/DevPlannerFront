import 'package:flutter/foundation.dart';

/// Typ panelu kontrolowanego przez sesyjny globalny shell.
enum AppGlobalPanel { chat, notifications }

/// Niewielki stan prezentacji paneli należący wyłącznie do `AppGlobalShell`.
///
/// Nie zna repository ani danych rozmów/powiadomień. Rozdziela wyłącznie
/// decyzję UI: który panel jest widoczny i czy Chat jest przypięty.
class AppGlobalPanelsController extends ChangeNotifier {
  AppGlobalPanel? _activePanel;
  bool _isChatPinned = false;
  bool _isPinnedChatPresentation = false;
  double _chatWidth = 384;
  String? _lastChatConversationId;

  AppGlobalPanel? get activePanel => _activePanel;
  bool get isChatPinned => _isChatPinned;
  double get chatWidth => _chatWidth;
  String? get lastChatConversationId => _lastChatConversationId;

  /// Inicjalizuje UI z lokalnych preferencji już odczytanych przez settings.
  void restore({
    required bool chatPinned,
    required double chatWidth,
    String? lastChatConversationId,
  }) {
    _isChatPinned = chatPinned;
    _chatWidth = chatWidth.clamp(320, 560).toDouble();
    _lastChatConversationId = lastChatConversationId;
  }

  /// Pokazuje Chat i atomowo zamyka ewentualne powiadomienia.
  void showChat({required bool pinned}) {
    _activePanel = AppGlobalPanel.chat;
    _isPinnedChatPresentation = pinned;
    if (pinned) {
      _isChatPinned = true;
    }
    notifyListeners();
  }

  /// Przenosi aktualnie otwarty Chat do modalnego overlay bez zmiany preferencji.
  void showChatInOverlay() {
    _activePanel = AppGlobalPanel.chat;
    _isPinnedChatPresentation = false;
    notifyListeners();
  }

  /// Pokazuje powiadomienia i ukrywa przypięty panel Chat.
  ///
  /// Preferencja przypięcia nie jest tu zmieniana. Dzięki temu przełączenie
  /// Czat → Powiadomienia → Czat nie nadpisuje osobistego wyboru użytkownika.
  void showNotifications() {
    _activePanel = AppGlobalPanel.notifications;
    _isPinnedChatPresentation = false;
    notifyListeners();
  }

  /// Zamknięcie panelu nie dotyka bieżącej trasy.
  void close() {
    if (_activePanel == null) return;
    _activePanel = null;
    _isPinnedChatPresentation = false;
    notifyListeners();
  }

  /// Aktualizuje lokalną szerokość przypiętego panelu w bezpiecznym zakresie.
  void setChatWidth(double width) {
    final normalized = width.clamp(320, 560).toDouble();
    if (_chatWidth == normalized) return;
    _chatWidth = normalized;
    notifyListeners();
  }

  /// Zmienia szerokość na podstawie różnicy z uchwytu przeciągania.
  void adjustChatWidth(double delta) {
    setChatWidth(_chatWidth + delta);
  }

  /// Zapamiętuje ostatnią rozmowę bez ładowania jej danych do kontrolera UI.
  void selectLastConversation(String conversationId) {
    if (conversationId.isEmpty || _lastChatConversationId == conversationId) {
      return;
    }
    _lastChatConversationId = conversationId;
    notifyListeners();
  }

  /// Określa, czy właśnie teraz Chat jest prezentowany jako przypięty pane.
  ///
  /// Sama preferencja [`isChatPinned`] nie wystarcza: po zamknięciu albo po
  /// przełączeniu na powiadomienia panel musi zniknąć, ale ustawienie pozostaje
  /// gotowe na następne otwarcie Chat.
  bool get isPinnedChatVisible =>
      _activePanel == AppGlobalPanel.chat && _isPinnedChatPresentation;
}
