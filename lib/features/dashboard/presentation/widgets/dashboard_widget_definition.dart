import 'package:flutter/material.dart';

/// Styl ramki używany przez widget pulpitu.
enum DashboardWidgetFrameStyle {
  /// Standardowa karta z nagłówkiem i szklistym tłem.
  standard,

  /// Minimalistyczny wariant bez pełnej karty i bez widocznego nagłówka.
  minimal,
}

/// Reprezentuje logiczny rozmiar widgetu w jednostkach siatki.
@immutable
class DashboardWidgetSize {
  /// Tworzy reprezentację rozmiaru widgetu.
  const DashboardWidgetSize(this.width, this.height);

  /// Szerokość widgetu wyrażona w liczbie kolumn (np. 4, 6, 8, 12).
  final int width;

  /// Wysokość widgetu wyrażona w liczbie wierszy siatki (np. 1, 2, 3).
  final int height;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardWidgetSize &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;

  /// Przyjazna dla użytkownika etykieta rozmiaru.
  String get label => switch ((width.isEven, height.isEven)) {
    (true, true) => '${width ~/ 2}x${height ~/ 2}',
    _ => '${width}x$height',
  };
}

/// Abstrakcyjna definicja pojedynczego typu widgetu pulpitu.
///
/// Każdy nowy widget dodawany do pulpitu musi implementować tę klasę.
abstract class DashboardWidgetDefinition {
  /// Tworzy definicję widgetu pulpitu.
  const DashboardWidgetDefinition();

  /// Unikalny identyfikator typu widgetu (np. 'quick_actions').
  String get typeId;

  /// Uprawnienie Ready wymagane do wyświetlenia widgetu.
  /// Brak wartości oznacza widget ogólnodostępny po zalogowaniu.
  String? get requiredPermission => null;

  /// Określa, czy bieżąca sesja może wyświetlić ten widget.
  bool isAvailableTo(Set<String> permissions) {
    final permission = requiredPermission;
    return permission == null || permissions.contains(permission);
  }

  /// Nazwa widgetu wyświetlana w panelu wyboru (np. 'Szybkie akcje').
  String name(BuildContext context);

  /// Krótki opis przeznaczenia widgetu.
  String description(BuildContext context);

  /// Kategoria widgetu do filtrowania w panelu wyboru (np. 'Inwentaryzacja', 'BHP', 'Ogólne').
  String category(BuildContext context);

  /// Ikona reprezentująca widget.
  IconData get icon;

  /// Lista wspieranych rozmiarów przez dany widget.
  List<DashboardWidgetSize> get supportedSizes;

  /// Określa sposób renderowania ramki widgetu na pulpicie.
  DashboardWidgetFrameStyle get frameStyle => .standard;

  /// Domyślny rozmiar widgetu po dodaniu na pulpit.
  DashboardWidgetSize get defaultSize => supportedSizes.first;

  /// Buduje interfejs graficzny widgetu dla określonego rozmiaru.
  Widget build(BuildContext context, DashboardWidgetSize size);
}

/// Scope udostępniający opcje konfiguracyjne i identyfikator widgetu dla jego zawartości.
class DashboardWidgetSettingsScope extends InheritedWidget {
  /// Tworzy scope ustawień widgetu.
  const DashboardWidgetSettingsScope({
    required this.id,
    required this.settings,
    required super.child,
    super.key,
  });

  /// Unikalny identyfikator instancji widgetu.
  final String id;

  /// Ustawienia specyficzne dla danego widgetu.
  final Map<String, dynamic>? settings;

  /// Zwraca najbliższy scope ustawień widgetu z kontekstu.
  static DashboardWidgetSettingsScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DashboardWidgetSettingsScope>();
  }

  @override
  bool updateShouldNotify(covariant DashboardWidgetSettingsScope oldWidget) {
    return oldWidget.id != id || oldWidget.settings != settings;
  }
}
