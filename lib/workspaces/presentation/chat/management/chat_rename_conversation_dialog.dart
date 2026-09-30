import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Edytuje nazwę rozmowy w powierzchni i kontrolkach motywu Chat.
final class ChatRenameConversationDialog extends StatefulWidget {
  const ChatRenameConversationDialog({required this.initialName, super.key});

  final String initialName;

  @override
  State<ChatRenameConversationDialog> createState() =>
      _ChatRenameConversationDialogState();
}

final class _ChatRenameConversationDialogState
    extends State<ChatRenameConversationDialog> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _controller.text.trim();
    final isValid = name.isNotEmpty && name.length <= 240;
    return ChatSurfaceDialog(
      title: context.l10n.chatConversationRenameTitle,
      leading: Icon(
        Symbols.edit,
        color: context.chatTheme.metadataText,
      ),
      content: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        maxLength: 240,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) {
          if (isValid) Navigator.of(context).pop(name);
        },
        decoration: InputDecoration(
          labelText: context.l10n.chatConversationNameLabel,
          hintText: context.l10n.chatConversationNameHint,
          counterText: '',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.chatCreationCancel),
        ),
        FilledButton(
          onPressed: isValid ? () => Navigator.of(context).pop(name) : null,
          child: Text(context.l10n.frameworkSave),
        ),
      ],
    );
  }
}
