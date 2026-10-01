import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Uses the Tasks palette for shared Chat controls rendered in a task modal.
/// Global Chat keeps its dedicated palette outside this scope.
final class TaskDetailChatThemeScope extends StatelessWidget {
  const TaskDetailChatThemeScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final tasks = context.tasksTheme;
    final foreground = base.colorScheme.onSurface;
    final metadata = base.colorScheme.onSurfaceVariant;
    final chat = context.chatTheme.copyWith(
      panelSurface: tasks.canvas,
      listSurface: tasks.cardSurface,
      conversationSurface: tasks.canvas,
      composerSurface: tasks.cardSurface,
      incomingBubble: tasks.cardSurface,
      outgoingBubble: tasks.rowSelected,
      incomingText: foreground,
      outgoingText: foreground,
      metadataText: metadata,
      linkText: tasks.selectionAccent,
      actionText: tasks.selectionAccent,
      mentionSurface: tasks.rowSelected,
      mentionText: tasks.selectionAccent,
      codeSurface: tasks.cardSurface,
      separator: tasks.canvasBorder,
      hoverSurface: tasks.rowHover,
      selectedSurface: tasks.rowSelected,
      focusRing: tasks.selectionAccent,
      deliveryRead: tasks.selectionAccent,
      sendButtonSurface: tasks.selectionAccent,
      sendButtonForeground: tasks.onAccent,
      contentStyle: tasks.dataText.copyWith(color: foreground),
      authorStyle: tasks.dataStrongText.copyWith(color: foreground),
      metadataStyle: tasks.metaText.copyWith(color: metadata),
      monospaceStyle: context.chatTheme.monospaceStyle.copyWith(
        color: foreground,
      ),
      bubbleRadius: tasks.panelRadius,
      composerRadius: tasks.controlRadius,
      composerActionSize: 32,
      composerIconSize: 18,
    );
    final menu = chat.applyMenuTheme(context.menuTheme);
    final controls = chat
        .applyControls(base)
        .copyWith(
          iconButtonTheme: IconButtonThemeData(
            style: IconButton.styleFrom(
              minimumSize: const Size(32, 32),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tasks.controlRadius),
              ),
            ),
          ),
          extensions: [
            for (final extension in base.extensions.values)
              if (extension is! DevPlannerChatTheme &&
                  extension is! DevPlannerMenuTheme)
                extension,
            chat,
            menu,
          ],
        );
    return Theme(data: controls, child: child);
  }
}
