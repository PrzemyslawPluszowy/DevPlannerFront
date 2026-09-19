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
    this.openResourceConversation,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  final ValueChanged<String> openConversation;
  final ValueChanged<ResourceChatOpenRequest>? openResourceConversation;

  static ValueChanged<ResourceChatOpenRequest>? openResourceConversationOf(
    BuildContext context,
  ) => context
      .dependOnInheritedWidgetOfExactType<DevPlannerPanelsScope>()
      ?.openResourceConversation;

  /// Zwraca ownera panelu globalnego, aby shell mógł go otworzyć bez trasy.
  static DevPlannerPanelsController? controllerOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DevPlannerPanelsScope>()
          ?.notifier;
}
