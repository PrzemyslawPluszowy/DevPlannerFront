import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:ready_next/workspaces/presentation/chat/composer/cubit/chat_composer_cubit.dart';

void main() {
  group('ChatComposerCubit', () {
    test('zachowuje Delta i reply target w snapshotie draftu', () async {
      final cubit = ChatComposerCubit();

      cubit.selectMode(ChatComposerMode.richText);
      cubit.updateRichText(
        text: 'Pogrubiona wiadomość',
        deltaJson: '[{"insert":"Pogrubiona wiadomość"}]',
      );
      cubit.replyTo('message-42');

      expect(cubit.state.mode, ChatComposerMode.richText);
      expect(cubit.state.draft.text, 'Pogrubiona wiadomość');
      expect(
        cubit.state.draft.deltaJson,
        '[{"insert":"Pogrubiona wiadomość"}]',
      );
      expect(cubit.state.draft.replyToMessageId, 'message-42');
      await cubit.close();
    });

    test('czyszczenie po wysłaniu nie zmienia wybranego trybu', () async {
      final cubit = ChatComposerCubit();
      cubit.selectMode(ChatComposerMode.richText);
      cubit.updateRichText(text: 'Treść', deltaJson: '[{"insert":"Treść"}]');
      cubit.replyTo('message-42');

      cubit.clearAfterSubmit();

      expect(cubit.state.mode, ChatComposerMode.richText);
      expect(cubit.state.draft, const ChatComposerDraft(text: ''));
      await cubit.close();
    });
  });
}
