import 'package:flutter/material.dart';

/// Definicja katalogowa pojedynczego skrotu dashboardu.
class DashboardShortcutDefinition {
  /// Tworzy definicje pojedynczego skrotu dashboardu.
  const DashboardShortcutDefinition({
    required this.id,
    required this.routePath,
    required this.icon,
    required this.originalLabel,
  });

  /// Stabilny identyfikator skrotu.
  final String id;

  /// Docelowa sciezka routera.
  final String routePath;

  /// Ikona skrotu.
  final IconData icon;

  /// Domyslna etykieta skrotu.
  final String originalLabel;
}
