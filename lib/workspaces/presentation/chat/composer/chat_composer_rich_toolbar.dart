import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_format_actions.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_format_commands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:material_symbols_icons/symbols.dart';

/// Pasek rozbudowanego edytora: historia zmian, formatowanie i struktura linii.
///
/// W wąskim panelu zachowuje podstawowe akcje, a formatowanie bloków mieści w
/// menu; szeroki panel pokazuje cały zestaw. Nie dodaje formatów, których
/// backend nie przenosi (np. koloru ani rozmiaru tekstu).
class ChatComposerRichToolbar extends StatelessWidget {
  /// Tworzy pasek dla kontrolera edytora.
  const ChatComposerRichToolbar({required this.controller, super.key});

  final quill.QuillController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final attributes = controller.getSelectionStyle().attributes;
      return Padding(
        padding: const EdgeInsets.only(bottom: Sizes.p4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 480;
            return Row(
              children: [
                _ToolbarAction(
                  id: 'undo',
                  icon: Symbols.undo,
                  label: context.l10n.chatComposerUndo,
                  active: false,
                  onPressed: controller.hasUndo ? controller.undo : null,
                ),
                _ToolbarAction(
                  id: 'redo',
                  icon: Symbols.redo,
                  label: context.l10n.chatComposerRedo,
                  active: false,
                  onPressed: controller.hasRedo ? controller.redo : null,
                ),
                const _ToolbarDivider(),
                for (final command in const <ChatFormatCommand>[
                  ChatFormatCommand.bold,
                  ChatFormatCommand.italic,
                  ChatFormatCommand.strike,
                  ChatFormatCommand.inlineCode,
                  ChatFormatCommand.link,
                ])
                  _ToolbarAction(
                    id: command.name,
                    icon: _formatIcon(command),
                    label: _formatLabel(context, command),
                    active: ChatFormatCommands.isActive(command, attributes),
                    onPressed: () => applyFormatCommand(
                      context,
                      controller: controller,
                      command: command,
                    ),
                  ),
                if (compact)
                  _OverflowActions(
                    attributes: attributes,
                    controller: controller,
                  )
                else ...[
                  const _ToolbarDivider(),
                  for (final command in ChatLineFormatCommands.toolbar)
                    _ToolbarAction(
                      id: command.name,
                      icon: _lineIcon(command),
                      label: _lineLabel(context, command),
                      active: ChatLineFormatCommands.isActive(
                        command,
                        attributes,
                      ),
                      onPressed: () => applyLineFormatCommand(
                        controller: controller,
                        command: command,
                      ),
                    ),
                  _ToolbarAction(
                    id: ChatFormatCommand.clear.name,
                    icon: _formatIcon(ChatFormatCommand.clear),
                    label: _formatLabel(context, ChatFormatCommand.clear),
                    active: false,
                    onPressed: () => applyFormatCommand(
                      context,
                      controller: controller,
                      command: ChatFormatCommand.clear,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      );
    },
  );
}

/// Zbiera rzadziej używane formaty w menu, gdy composer ma małą szerokość.
class _OverflowActions extends StatelessWidget {
  const _OverflowActions({required this.attributes, required this.controller});

  final Map<String, quill.Attribute<dynamic>> attributes;
  final quill.QuillController controller;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (anchorContext) => IconButton(
      tooltip: context.l10n.chatComposerMoreFormatting,
      icon: const Icon(Symbols.more_horiz_rounded),
      iconSize: 18,
      padding: EdgeInsets.zero,
      onPressed: () => unawaited(
        AppContextMenu.show(
          anchorContext,
          globalPosition: AppContextMenu.positionFor(anchorContext),
          actions: [
            for (final action in _OverflowAction.values)
              AppContextMenuAction(
                label: action.label(anchorContext),
                icon: action.icon,
                selected: action.active(attributes),
                onTap: (_) => _applyAction(anchorContext, action),
              ),
          ],
        ),
      ),
    ),
  );

  void _applyAction(BuildContext context, _OverflowAction action) {
    switch (action) {
      case _OverflowAction.bulletList:
        applyLineFormatCommand(
          controller: controller,
          command: ChatLineFormatCommand.bulletList,
        );
      case _OverflowAction.orderedList:
        applyLineFormatCommand(
          controller: controller,
          command: ChatLineFormatCommand.orderedList,
        );
      case _OverflowAction.quote:
        applyLineFormatCommand(
          controller: controller,
          command: ChatLineFormatCommand.quote,
        );
      case _OverflowAction.codeBlock:
        applyLineFormatCommand(
          controller: controller,
          command: ChatLineFormatCommand.codeBlock,
        );
      case _OverflowAction.clearFormat:
        unawaited(
          applyFormatCommand(
            context,
            controller: controller,
            command: ChatFormatCommand.clear,
          ),
        );
    }
  }
}

enum _OverflowAction { bulletList, orderedList, quote, codeBlock, clearFormat }

extension on _OverflowAction {
  IconData get icon => switch (this) {
    _OverflowAction.bulletList => Symbols.format_list_bulleted,
    _OverflowAction.orderedList => Symbols.format_list_numbered,
    _OverflowAction.quote => Symbols.format_quote,
    _OverflowAction.codeBlock => Symbols.code_blocks,
    _OverflowAction.clearFormat => Symbols.format_clear,
  };

  String label(BuildContext context) => switch (this) {
    _OverflowAction.bulletList => context.l10n.chatComposerBulletList,
    _OverflowAction.orderedList => context.l10n.chatComposerOrderedList,
    _OverflowAction.quote => context.l10n.chatComposerQuote,
    _OverflowAction.codeBlock => context.l10n.chatComposerCodeBlock,
    _OverflowAction.clearFormat => context.l10n.chatComposerClearFormat,
  };

  bool active(Map<String, quill.Attribute<dynamic>> attributes) =>
      switch (this) {
        _OverflowAction.bulletList => ChatLineFormatCommands.isActive(
          ChatLineFormatCommand.bulletList,
          attributes,
        ),
        _OverflowAction.orderedList => ChatLineFormatCommands.isActive(
          ChatLineFormatCommand.orderedList,
          attributes,
        ),
        _OverflowAction.quote => ChatLineFormatCommands.isActive(
          ChatLineFormatCommand.quote,
          attributes,
        ),
        _OverflowAction.codeBlock => ChatLineFormatCommands.isActive(
          ChatLineFormatCommand.codeBlock,
          attributes,
        ),
        _OverflowAction.clearFormat => false,
      };
}

/// Stosuje akcję struktury linii do bieżącego zaznaczenia lub akapitu.
void applyLineFormatCommand({
  required quill.QuillController controller,
  required ChatLineFormatCommand command,
}) {
  final active = ChatLineFormatCommands.isActive(
    command,
    controller.getSelectionStyle().attributes,
  );
  final value = ChatLineFormatCommands.toggledValue(
    command,
    currentlyActive: active,
  );
  // Wartości muszą mieć typ zgodny z atrybutem Quill: format listy jest
  // tekstowym atrybutem `ul`/`ol`, a cytat i blok kodu są wartościami logicznymi.
  final attribute = switch (command) {
    ChatLineFormatCommand.bulletList =>
      value == null
          ? quill.Attribute.clone(quill.Attribute.ul, null)
          : quill.Attribute.ul,
    ChatLineFormatCommand.orderedList =>
      value == null
          ? quill.Attribute.clone(quill.Attribute.ol, null)
          : quill.Attribute.ol,
    ChatLineFormatCommand.quote =>
      value == null
          ? quill.Attribute.clone(quill.Attribute.blockQuote, null)
          : quill.Attribute.clone(quill.Attribute.blockQuote, true),
    ChatLineFormatCommand.codeBlock =>
      value == null
          ? quill.Attribute.clone(quill.Attribute.codeBlock, null)
          : quill.Attribute.clone(quill.Attribute.codeBlock, true),
  };
  controller.formatSelection(attribute);
}

IconData _formatIcon(ChatFormatCommand command) => switch (command) {
  ChatFormatCommand.bold => Symbols.format_bold,
  ChatFormatCommand.italic => Symbols.format_italic,
  ChatFormatCommand.strike => Symbols.format_strikethrough,
  ChatFormatCommand.inlineCode => Symbols.code,
  ChatFormatCommand.link => Symbols.link,
  ChatFormatCommand.clear => Symbols.format_clear,
};

String _formatLabel(BuildContext context, ChatFormatCommand command) =>
    switch (command) {
      ChatFormatCommand.bold => context.l10n.chatComposerBold,
      ChatFormatCommand.italic => context.l10n.chatComposerItalic,
      ChatFormatCommand.strike => context.l10n.chatComposerStrike,
      ChatFormatCommand.inlineCode => context.l10n.chatComposerInlineCode,
      ChatFormatCommand.link => context.l10n.chatComposerLink,
      ChatFormatCommand.clear => context.l10n.chatComposerClearFormat,
    };

IconData _lineIcon(ChatLineFormatCommand command) => switch (command) {
  ChatLineFormatCommand.bulletList => Symbols.format_list_bulleted,
  ChatLineFormatCommand.orderedList => Symbols.format_list_numbered,
  ChatLineFormatCommand.quote => Symbols.format_quote,
  ChatLineFormatCommand.codeBlock => Symbols.code_blocks,
};

String _lineLabel(BuildContext context, ChatLineFormatCommand command) =>
    switch (command) {
      ChatLineFormatCommand.bulletList => context.l10n.chatComposerBulletList,
      ChatLineFormatCommand.orderedList => context.l10n.chatComposerOrderedList,
      ChatLineFormatCommand.quote => context.l10n.chatComposerQuote,
      ChatLineFormatCommand.codeBlock => context.l10n.chatComposerCodeBlock,
    };

class _ToolbarAction extends StatelessWidget {
  const _ToolbarAction({
    required this.id,
    required this.icon,
    required this.label,
    required this.active,
    required this.onPressed,
  });

  final String id;
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        key: ValueKey<String>('chat-rich-toolbar-$id'),
        onPressed: onPressed,
        tooltip: label,
        padding: EdgeInsets.zero,
        iconSize: 18,
        color: onPressed == null
            ? chat.metadataText.withValues(alpha: .4)
            : active
            ? chat.focusRing
            : chat.metadataText,
        style: active
            ? IconButton.styleFrom(backgroundColor: chat.selectedSurface)
            : null,
        icon: Icon(icon),
      ),
    );
  }
}

class _ToolbarDivider extends StatelessWidget {
  const _ToolbarDivider();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
    child: SizedBox(
      height: 20,
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: context.chatTheme.separator,
      ),
    ),
  );
}
