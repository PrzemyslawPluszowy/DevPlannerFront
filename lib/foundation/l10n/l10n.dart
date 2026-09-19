import 'package:devplanner/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Udostępnia lokalizację aplikacji przez lokalny kontrakt foundation.
extension DevPlannerL10nContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  AppLocalizations get intl => l10n;
}
