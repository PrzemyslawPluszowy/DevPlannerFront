import 'dart:js_interop';

@JS('Intl.DateTimeFormat')
extension type _DateTimeFormat._(JSObject _) implements JSObject {
  external _DateTimeFormat();
  external _ResolvedOptions resolvedOptions();
}

extension type _ResolvedOptions._(JSObject _) implements JSObject {
  external String get timeZone;
}

/// Odczytuje strefę IANA przeglądarki wraz z regułami zmiany czasu.
final class CalendarTimeZone {
  const CalendarTimeZone();

  String read() => _DateTimeFormat().resolvedOptions().timeZone;
}
