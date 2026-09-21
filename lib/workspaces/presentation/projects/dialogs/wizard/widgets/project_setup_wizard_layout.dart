import 'dart:math' as math;

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Geometria modala kreatora wyliczona z rozmiaru okna.
///
/// Wartości są czystą funkcją viewportu, więc kontrakt responsywności da się
/// sprawdzić w teście jednostkowym, bez uruchamiania widgetów. Layout nie używa
/// stałego `maxWidth`/`maxHeight` — modal nigdy nie wychodzi poza viewport.
final class ProjectSetupWizardMetrics {
  const ProjectSetupWizardMetrics._({
    required this.width,
    required this.height,
    required this.isTwoPanel,
    required this.controlsWidth,
  });

  /// Wylicza geometrię dla danego viewportu.
  factory ProjectSetupWizardMetrics.forViewport(Size viewport) {
    final isTwoPanel = viewport.width >= twoPanelBreakpoint;
    final inset = isTwoPanel ? wideViewportInset : narrowViewportInset;
    final width = math.max(
      minWidth,
      math.min(
        isTwoPanel ? maxWideWidth : viewport.width,
        viewport.width - inset,
      ),
    );
    final height = math.max(0.0, math.min(maxHeight, viewport.height - inset));
    final controlsWidth = isTwoPanel
        ? (width * 0.34).clamp(controlsMinWidth, controlsMaxWidth)
        : width;
    return ProjectSetupWizardMetrics._(
      width: width,
      height: height,
      isTwoPanel: isTwoPanel,
      controlsWidth: controlsWidth,
    );
  }

  /// Szerokość, od której kreator przechodzi w układ dwupanelowy.
  static const double twoPanelBreakpoint = 960;

  /// Docelowa szerokość panelu kreatora na szerokim ekranie.
  static const double maxWideWidth = 1120;

  /// Docelowa wysokość modala na szerokim ekranie.
  static const double maxHeight = 780;

  /// Margines viewportu zostawiany na szerokim ekranie.
  static const double wideViewportInset = 48;

  /// Margines viewportu zostawiany w wąskim oknie.
  static const double narrowViewportInset = 32;

  /// Zakres szerokości lewego panelu z kontrolkami.
  static const double controlsMinWidth = 340;

  /// Górna granica szerokości lewego panelu z kontrolkami.
  static const double controlsMaxWidth = 400;

  /// Minimalna szerokość, poniżej której modal nie próbuje się kurczyć.
  static const double minWidth = 280;

  /// Szerokość modala w pikselach logicznych.
  final double width;

  /// Wysokość modala w pikselach logicznych.
  final double height;

  /// Czy modal pokazuje kontrolki i podgląd obok siebie.
  final bool isTwoPanel;

  /// Szerokość kolumny z kontrolkami.
  final double controlsWidth;
}

/// Układ treści kreatora: dwa panele na szerokim ekranie, jedna kolumna w wąskim.
///
/// Widget nie zna Cubita ani portów — dostaje gotowe kontrolki i gotowy podgląd,
/// a odpowiada wyłącznie za ich rozmieszczenie.
class ProjectSetupWizardLayout extends StatelessWidget {
  /// Tworzy układ kreatora.
  const ProjectSetupWizardLayout({
    required this.controls,
    required this.preview,
    super.key,
  });

  /// Treść kroku: kontrolki i ustawienia.
  final Widget controls;

  /// Panel podglądu skutków ustawień.
  final Widget preview;

  /// Klucz sekcji podglądu w wąskim oknie.
  static const Key narrowPreviewKey = ValueKey('project-setup-preview-section');

  /// Klucz prawego panelu podglądu w układzie dwupanelowym.
  static const Key widePreviewKey = ValueKey('project-setup-preview-panel');

  /// Klucz obszaru kontrolek bieżącego kroku.
  ///
  /// Testy szukają tekstów kroku właśnie tutaj: podgląd celowo powtarza część
  /// danych (nazwę szablonu, tytuły zadań), więc bez tego zakresu ten sam tekst
  /// występowałby dwa razy.
  static const Key controlsKey = ValueKey('project-setup-controls');

  @override
  Widget build(BuildContext context) {
    final metrics = ProjectSetupWizardMetrics.forViewport(
      MediaQuery.sizeOf(context),
    );
    final controls = KeyedSubtree(key: controlsKey, child: this.controls);
    if (!metrics.isTwoPanel) {
      return _NarrowLayout(controls: controls, preview: preview);
    }
    return _TwoPanelLayout(
      controls: controls,
      preview: preview,
      controlsWidth: metrics.controlsWidth,
    );
  }
}

class _TwoPanelLayout extends StatelessWidget {
  const _TwoPanelLayout({
    required this.controls,
    required this.preview,
    required this.controlsWidth,
  });

  final Widget controls;
  final Widget preview;
  final double controlsWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: controlsWidth,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p24,
              Sizes.p20,
              Sizes.p20,
              Sizes.p20,
            ),
            child: controls,
          ),
        ),
        VerticalDivider(width: 1, color: colors.outlineVariant),
        Expanded(
          child: ColoredBox(
            color: context.surfaceRoles.tintedBackground,
            child: SingleChildScrollView(
              key: ProjectSetupWizardLayout.widePreviewKey,
              padding: const EdgeInsets.fromLTRB(
                Sizes.p20,
                Sizes.p20,
                Sizes.p24,
                Sizes.p20,
              ),
              child: preview,
            ),
          ),
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({required this.controls, required this.preview});

  final Widget controls;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        Sizes.p16,
        Sizes.p12,
        Sizes.p16,
        Sizes.p12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          controls,
          Gaps.h16,
          _CollapsiblePreviewSection(child: preview),
        ],
      ),
    );
  }
}

/// Zwijana sekcja podglądu w wąskim oknie.
///
/// Sekcja jest domyślnie otwarta, żeby podgląd był widoczny bez dodatkowego
/// kliknięcia, ale można ją zwinąć i oddać całą wysokość kontrolkom.
class _CollapsiblePreviewSection extends StatefulWidget {
  const _CollapsiblePreviewSection({required this.child});

  final Widget child;

  @override
  State<_CollapsiblePreviewSection> createState() =>
      _CollapsiblePreviewSectionState();
}

class _CollapsiblePreviewSectionState
    extends State<_CollapsiblePreviewSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      key: ProjectSetupWizardLayout.narrowPreviewKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: const BorderRadius.all(Radius.circular(Sizes.p8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
            child: Row(
              children: [
                Icon(Symbols.preview, size: 16, color: colors.onSurfaceVariant),
                Gaps.w8,
                Expanded(
                  child: Text(
                    l10n.projectSetupPreviewLegend,
                    style: context.text.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  _expanded ? Symbols.expand_less : Symbols.expand_more,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[Gaps.h8, widget.child],
      ],
    );
  }
}
