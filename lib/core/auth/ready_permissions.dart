/// Oryginalne identyfikatory uprawnień Ready wykorzystywane przez Ready Next.
///
/// Wartości muszą być zgodne z definicjami `right_def` w Ready. Trzymanie ich
/// w jednym miejscu zapobiega rozbieżnościom między menu, widgetami i guardami.
abstract final class ReadyPermissions {
  /// Dostęp do całego modułu inwentaryzacji Ready Next.
  static const inventory = 'bswfms.custom_modules.RNext-inwentaryzacja';

  /// Dostęp do całego modułu BHP Ready Next.
  static const bhp = 'bswfms.custom_modules.RNext-bhp';

  /// Zbiór praw modułowych znanych aktualnej wersji aplikacji.
  static const modulePermissions = <String>{inventory, bhp};
}
