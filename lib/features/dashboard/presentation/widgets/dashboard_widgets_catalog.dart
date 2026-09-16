import 'package:ready_next/features/dashboard/presentation/widgets/active_inventories/active_inventories_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_equipment_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_overdue_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_positions_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_upcoming_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_users_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/clock/clock_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/quick_actions/quick_actions_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/startup_module/startup_module_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/weather/weather_widget_definition.dart';

/// Centralny katalog rejestrujący wszystkie dostępne widgety w systemie.
abstract final class DashboardWidgetsCatalog {
  /// Lista wszystkich definicji widgetów zarejestrowanych w aplikacji.
  static final List<DashboardWidgetDefinition> definitions = [
    const ClockWidgetDefinition(),
    const QuickActionsWidgetDefinition(),
    const WeatherWidgetDefinition(),
    const BhpDashboardUsersWidgetDefinition(),
    const BhpDashboardPositionsWidgetDefinition(),
    const BhpDashboardEquipmentWidgetDefinition(),
    const BhpDashboardOverdueWidgetDefinition(),
    const BhpDashboardUpcomingWidgetDefinition(),
    const ActiveInventoriesWidgetDefinition(),
    const StartupModuleWidgetDefinition(),
  ];

  /// Zwraca widgety dostępne dla praw bieżącej sesji.
  static List<DashboardWidgetDefinition> definitionsFor(
    Set<String> permissions,
  ) => [
    for (final definition in definitions)
      if (definition.isAvailableTo(permissions)) definition,
  ];

  /// Zwraca dostępną definicję widgetu na podstawie jego typu [typeId].
  static DashboardWidgetDefinition? getById(
    String typeId,
    Set<String> permissions,
  ) {
    for (final definition in definitions) {
      if (definition.typeId == typeId &&
          definition.isAvailableTo(permissions)) {
        return definition;
      }
    }
    return null;
  }
}
