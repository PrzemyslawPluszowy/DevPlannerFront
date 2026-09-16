import 'package:flutter/widgets.dart';
import 'package:ready_next/l10n/app_localizations.dart';

extension ReadyNextL10nContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  AppLocalizations get intl => l10n;
}
