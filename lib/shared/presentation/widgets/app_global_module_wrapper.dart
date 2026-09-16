import 'package:ready_next/app/shell/app_shell_export.dart';

/// Zgodny wstecz alias dla przeniesionego globalnego shellu.
///
/// Nowy kod powinien importować [AppGlobalShell] z `lib/app/shell`. Alias
/// pozostaje tymczasowo, aby współdzielone integracje nie otrzymały łamiącej
/// zmiany API podczas migracji routera.
class AppGlobalModuleWrapper extends AppGlobalShell {
  const AppGlobalModuleWrapper({
    required super.child,
    required super.appRouter,
    super.key,
  });
}
