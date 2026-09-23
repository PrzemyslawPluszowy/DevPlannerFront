import 'package:devplanner/l10n/app_localizations_pl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsPl();

  test('Polish chat plural labels interpolate counts instead of showing #', () {
    expect(l10n.chatHeaderParticipantCount(3), '3 uczestników');
    expect(l10n.chatNewMessages(2), '2 nowe wiadomości');
    expect(l10n.chatTypingMany('Anna', 2), 'Anna i 2 inne osoby piszą…');
  });
}
