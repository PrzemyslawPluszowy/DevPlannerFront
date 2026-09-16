import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_shortcut_preference.freezed.dart';
part 'dashboard_shortcut_preference.g.dart';

/// Preferencje pojedynczego skrotu dashboardu zapisane dla uzytkownika.
@freezed
abstract class DashboardShortcutPreference with _$DashboardShortcutPreference {
  /// Tworzy preferencje pojedynczego skrotu dashboardu.
  const factory DashboardShortcutPreference({
    required String shortcutId,
    String? userLabel,
    required bool isVisible,
    required int position,
    required int gridColumn,
    required int gridRow,
    double? exactDx,
    double? exactDy,
  }) = _DashboardShortcutPreference;

  /// Odtwarza preferencje skrotu z mapy JSON.
  factory DashboardShortcutPreference.fromJson(Map<String, dynamic> json) =>
      _$DashboardShortcutPreferenceFromJson(json);
}
