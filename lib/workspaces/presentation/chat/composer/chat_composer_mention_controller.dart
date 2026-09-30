import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/mentions/chat_mention_picker_controller.dart';
import 'package:flutter/material.dart';

/// Łączy kursor edytora z podpowiedziami i stabilnymi identyfikatorami wzmianek.
final class ChatComposerMentionController {
  ChatComposerMentionController({
    required this._cubit,
    required this._textController,
    required ChatSearchRepository repository,
    required String conversationId,
    required bool allTokenEnabled,
    required this.contextProvider,
  }) : picker = ChatMentionPickerController(
         repository: repository,
         conversationId: conversationId,
         allTokenEnabled: allTokenEnabled,
       ) {
    _textController.addListener(_syncQuery);
  }

  final ChatComposerCubit _cubit;
  final TextEditingController _textController;
  final BuildContext Function() contextProvider;
  final ChatMentionPickerController picker;

  void _syncQuery() {
    final value = _textController.value;
    final caret = value.selection.isValid
        ? value.selection.baseOffset
        : value.text.length;
    picker.updateQuery(ChatMentionCodec.activeQuery(value.text, caret));
  }

  void accept(ChatMentionSuggestion suggestion) {
    final query = picker.query;
    if (query == null) return;
    final label = ChatMentionCodec.labelFor(
      userId: suggestion.userId,
      displayName: suggestion.displayName,
      login: suggestion.login,
      fallbackLabel: contextProvider().l10n.chatMentionUnknownMember,
    );
    final text = ChatMentionCodec.applyMention(
      text: _textController.text,
      query: query,
      label: label,
    );
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: query.start + label.length + 2,
      ),
    );
    _cubit.updatePlainText(text);
    _cubit.setMentions([
      ..._cubit.state.draft.mentions,
      ChatMentionReference(userId: suggestion.userId, label: label),
    ]);
    picker.close();
  }

  void acceptAll() {
    final query = picker.query;
    if (query == null) return;
    final text = ChatMentionCodec.applyMention(
      text: _textController.text,
      query: query,
      label: ChatMentionCodec.allToken.substring(1),
    );
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: query.start + ChatMentionCodec.allToken.length + 1,
      ),
    );
    _cubit.updatePlainText(text);
    picker.close();
  }

  void dispose() {
    _textController.removeListener(_syncQuery);
    picker.dispose();
  }
}
