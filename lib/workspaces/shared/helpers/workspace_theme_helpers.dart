import 'package:flutter/material.dart';

/// Pomocnicze style motywu dla paneli Workspaces.
///
/// Każdy kolor pochodzi z aktualnego `ColorScheme`, dlatego przezroczyste
/// powierzchnie i gradienty zachowują kontrast w jasnym oraz ciemnym motywie.
extension WorkspaceThemeHelpers on BuildContext {
  /// Subtelny gradient powierzchni panelu overlay.
  LinearGradient get workspaceGlassGradient {
    final scheme = Theme.of(this).colorScheme;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        scheme.surface.withValues(alpha: .96),
        Color.alphaBlend(
          scheme.primary.withValues(alpha: .055),
          scheme.surface,
        ).withValues(alpha: .94),
      ],
    );
  }

  /// Obramowanie panelu oparte o kontur motywu.
  Border get workspaceGlassBorder => Border.all(
    color: Theme.of(this).colorScheme.outlineVariant.withValues(alpha: .72),
  );

  /// Delikatny cień używany wyłącznie na warstwie unoszącej się nad treścią.
  List<BoxShadow> get workspaceGlassShadow {
    final scheme = Theme.of(this).colorScheme;
    return [
      BoxShadow(
        color: scheme.shadow.withValues(alpha: .16),
        blurRadius: 28,
        offset: const Offset(0, 12),
      ),
    ];
  }
}
