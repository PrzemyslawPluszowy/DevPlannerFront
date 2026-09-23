import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_open_request.dart';
import 'package:flutter/material.dart';

enum DevPlannerPanel { chat, notifications }

class DevPlannerPanelsController extends ChangeNotifier {
  DevPlannerPanel? _activePanel;
  DevPlannerPanel? get activePanel => _activePanel;

  void showChat() {
    _activePanel = DevPlannerPanel.chat;
    notifyListeners();
  }

  void showNotifications() {
    _activePanel = DevPlannerPanel.notifications;
    notifyListeners();
  }

  /// Ponowne naciśnięcie przycisku w belce chowa panel, więc przycisk działa
  /// jak przełącznik, a nie jak akcja bez powrotu.
  void toggleChat() =>
      activePanel == DevPlannerPanel.chat ? close() : showChat();

  /// Ponowne naciśnięcie przycisku powiadomień chowa panel.
  void toggleNotifications() => activePanel == DevPlannerPanel.notifications
      ? close()
      : showNotifications();

  void close() {
    if (_activePanel == null) return;
    _activePanel = null;
    notifyListeners();
  }
}

class DevPlannerPanelsScope
    extends InheritedNotifier<DevPlannerPanelsController> {
  const DevPlannerPanelsScope({
    required DevPlannerPanelsController controller,
    required this.openConversation,
    this.reservedWidth = 0,
    this.openResourceConversation,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  final ValueChanged<String> openConversation;
  final ValueChanged<ResourceChatOpenRequest>? openResourceConversation;

  /// Szerokość, którą przypięty panel rezerwuje na treść aplikacji.
  ///
  /// Shell odejmuje tę wartość od swojej treści, a nie od całego okna, dzięki
  /// czemu tapeta pozostaje jedną pełnowymiarową warstwą pod spodem.
  final double reservedWidth;

  static ValueChanged<ResourceChatOpenRequest>? openResourceConversationOf(
    BuildContext context,
  ) => context
      .dependOnInheritedWidgetOfExactType<DevPlannerPanelsScope>()
      ?.openResourceConversation;

  /// Zwraca własną rezerwację miejsca dla przypiętego panelu.
  /// Otwiera rozmowę w panelu czatu; brak scope oznacza brak panelu.
  static ValueChanged<String>? openConversationOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DevPlannerPanelsScope>()
          ?.openConversation;

  static double reservedWidthOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DevPlannerPanelsScope>()
          ?.reservedWidth ??
      0;

  /// Zwraca ownera panelu globalnego, aby shell mógł go otworzyć bez trasy.
  static DevPlannerPanelsController? controllerOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DevPlannerPanelsScope>()
          ?.notifier;

  @override
  bool updateShouldNotify(covariant DevPlannerPanelsScope oldWidget) =>
      super.updateShouldNotify(oldWidget) ||
      oldWidget.reservedWidth != reservedWidth;
}
