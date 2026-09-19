import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_error_messages.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('kod blokady ruchu przez filtr ma tekst w ARB, nie w Cubicie', () async {
    final pl = await AppLocalizations.delegate.load(const Locale('pl'));
    final en = await AppLocalizations.delegate.load(const Locale('en'));

    final polish = tasksBoardMutationErrorText(
      pl,
      TasksBoardErrorCodes.moveBlockedByFilter,
    );
    final english = tasksBoardMutationErrorText(
      en,
      TasksBoardErrorCodes.moveBlockedByFilter,
    );

    expect(polish, pl.tasksBoardMoveBlockedByFilter);
    expect(english, en.tasksBoardMoveBlockedByFilter);
    expect(polish, isNot(contains('kanban.')));
    expect(english, isNot(contains('kanban.')));
  });

  test('komunikaty spoza katalogu kodów wracają bez zmian', () async {
    final pl = await AppLocalizations.delegate.load(const Locale('pl'));

    expect(
      tasksBoardMutationErrorText(
        pl,
        'To przejście statusu nie jest dozwolone.',
      ),
      'To przejście statusu nie jest dozwolone.',
    );
  });
}
