import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const empty = ChatComposerDraft(text: '');
  const plain = ChatComposerDraft(text: 'tekst');

  test('zmiana kolejnej litery nie przebudowuje całego composera', () {
    const previous = ChatComposerState(
      draft: ChatComposerDraft(text: 'tek'),
      mode: ChatComposerMode.richText,
    );
    const current = ChatComposerState(
      draft: ChatComposerDraft(
        text: 'tekst',
        deltaJson: '[{"insert":"tekst"}]',
      ),
      mode: ChatComposerMode.richText,
    );

    expect(current.shouldRebuildComparedTo(previous), isFalse);
  });

  test('zmiana trybu lub przejście pusty/niepusty przebudowuje composer', () {
    const emptyPlain = ChatComposerState(draft: empty);
    const nonemptyPlain = ChatComposerState(draft: plain);
    const rich = ChatComposerState(
      draft: plain,
      mode: ChatComposerMode.richText,
    );

    expect(nonemptyPlain.shouldRebuildComparedTo(emptyPlain), isTrue);
    expect(rich.shouldRebuildComparedTo(nonemptyPlain), isTrue);
  });
}
