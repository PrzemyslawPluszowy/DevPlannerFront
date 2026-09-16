import 'package:flutter/material.dart';

import 'package:ready_next/app/shell/panels/app_global_panels_controller.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_open_request.dart';

/// Udostępnia sesyjny kontroler paneli wyłącznie prywatnemu shellowi.
class AppGlobalPanelsScope
    extends InheritedNotifier<AppGlobalPanelsController> {
  const AppGlobalPanelsScope({
    required AppGlobalPanelsController controller,
    required this.openConversation,
    this.openResourceConversation,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  /// Otwiera już autoryzowaną rozmowę w prezentacji globalnego shellu.
  final ValueChanged<String> openConversation;

  /// Otwiera Resource Chat z efemerycznym, już autoryzowanym nagłówkiem pliku.
  final ValueChanged<ResourceChatOpenRequest>? openResourceConversation;

  /// Odczytuje kontroler wtedy, gdy wywołanie znajduje się pod shell route.
  static AppGlobalPanelsController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppGlobalPanelsScope>()
        ?.notifier;
  }

  /// Zwraca most UI do shella bez globalnego singletonu ani routera w Cubicie.
  static ValueChanged<String>? openConversationOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppGlobalPanelsScope>()
        ?.openConversation;
  }

  /// Zwraca most Resource Chat bez zapisywania prywatnych metadanych w singletonie.
  static ValueChanged<ResourceChatOpenRequest>? openResourceConversationOf(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<AppGlobalPanelsScope>()
        ?.openResourceConversation;
  }
}
