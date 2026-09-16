import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_widget_preference.freezed.dart';
part 'dashboard_widget_preference.g.dart';

/// Preferencje pojedynczego widgetu na pulpicie.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class DashboardWidgetPreference with _$DashboardWidgetPreference {
  /// Tworzy preferencje pojedynczego widgetu.
  const factory DashboardWidgetPreference({
    /// Unikalny identyfikator instancji widgetu (np. UUID).
    required String id,

    /// Identyfikator typu widgetu (np. 'quick_actions').
    required String widgetTypeId,

    /// Kolumna siatki zajmowana przez lewy górny róg widgetu.
    required int gridColumn,

    /// Wiersz siatki zajmowany przez lewy górny róg widgetu.
    required int gridRow,

    /// Logiczna szerokość widgetu.
    required int width,

    /// Logiczna wysokość widgetu.
    required int height,

    /// Preferowana szerokość wybrana przez użytkownika (używana przy auto-restore).
    int? preferredWidth,

    /// Preferowana wysokość wybrana przez użytkownika (używana przy auto-restore).
    int? preferredHeight,

    /// Dokładna pozycja X na pulpicie (piksele), używana gdy wyłączona jest siatka.
    double? exactDx,

    /// Dokładna pozycja Y na pulpicie (piksele), używana gdy wyłączona jest siatka.
    double? exactDy,

    /// Dodatkowe opcje konfiguracyjne specyficzne dla danego widgetu.
    Map<String, dynamic>? settings,
  }) = _DashboardWidgetPreference;

  /// Odtwarza preferencje widgetu z mapy JSON.
  factory DashboardWidgetPreference.fromJson(Map<String, dynamic> json) =>
      _$DashboardWidgetPreferenceFromJson(json);
}
