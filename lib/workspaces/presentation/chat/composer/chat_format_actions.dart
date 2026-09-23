import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_format_commands.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Applies one rich-text format command to the current selection.
Future<void> applyFormatCommand(
  BuildContext context, {
  required quill.QuillController controller,
  required ChatFormatCommand command,
}) async {
  if (command == ChatFormatCommand.link) {
    final url = await _askForLink(context);
    if (url == null || !ChatFormatCommands.isSafeLink(url)) return;
    controller.formatSelection(
      quill.Attribute.clone(quill.Attribute.link, url),
    );
    return;
  }
  if (command == ChatFormatCommand.clear) {
    <quill.Attribute<Object?>>[
      quill.Attribute.clone(quill.Attribute.bold, null),
      quill.Attribute.clone(quill.Attribute.italic, null),
      quill.Attribute.clone(quill.Attribute.strikeThrough, null),
      quill.Attribute.clone(quill.Attribute.inlineCode, null),
      quill.Attribute.clone(quill.Attribute.link, null),
    ].forEach(controller.formatSelection);
    return;
  }
  final base = _baseAttribute(command);
  final key = ChatFormatCommands.attributeKeys[command];
  if (base == null || key == null) return;
  final active = ChatFormatCommands.isActive(
    command,
    controller.getSelectionStyle().attributes,
  );
  final value = ChatFormatCommands.toggledValue(
    command,
    currentlyActive: active,
  );
  controller.formatSelection(quill.Attribute.clone(base, value));
}

quill.Attribute<Object?>? _baseAttribute(ChatFormatCommand command) =>
    switch (command) {
      ChatFormatCommand.bold => quill.Attribute.bold,
      ChatFormatCommand.italic => quill.Attribute.italic,
      ChatFormatCommand.strike => quill.Attribute.strikeThrough,
      ChatFormatCommand.inlineCode => quill.Attribute.inlineCode,
      ChatFormatCommand.link => quill.Attribute.link,
      ChatFormatCommand.clear => null,
    };

Future<String?> _askForLink(BuildContext context) async {
  final controller = TextEditingController();
  final result = await DevPlannerModalHost.showDialog<String>(
    context,
    builder: (dialogContext) => ChatSurfaceDialog(
      title: dialogContext.l10n.chatComposerLinkTitle,
      content: TextField(
        controller: controller,
        autofocus: true,
        style: dialogContext.chatTheme.contentStyle.copyWith(
          color: dialogContext.chatTheme.incomingText,
        ),
        decoration: InputDecoration(
          hintText: dialogContext.l10n.chatComposerLinkHint,
          hintStyle: dialogContext.chatTheme.contentStyle.copyWith(
            color: dialogContext.chatTheme.metadataText,
          ),
          filled: true,
          fillColor: dialogContext.chatTheme.composerSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: dialogContext.chatTheme.separator),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: dialogContext.chatTheme.separator),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: dialogContext.chatTheme.focusRing),
          ),
        ),
        onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).maybePop(),
          child: Text(
            MaterialLocalizations.of(dialogContext).cancelButtonLabel,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(controller.text),
          child: Text(dialogContext.l10n.chatComposerLinkApply),
        ),
      ],
    ),
  );
  controller.dispose();
  if (result == null) return null;
  final normalized = ChatFormatCommands.normalizeLink(result);
  return ChatFormatCommands.isSafeLink(normalized) ? normalized : null;
}
