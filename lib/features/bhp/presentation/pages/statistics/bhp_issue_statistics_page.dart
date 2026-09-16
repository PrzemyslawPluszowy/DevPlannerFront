import 'package:flutter/cupertino.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/bhp_issue_statistics_comparisons_section.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/issues/bhp_issue_statistics_issues_section.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/missing/bhp_issue_statistics_missing_section.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/structure/bhp_issue_statistics_structure_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';

/// Osobny ekran statystyk operacji BHP.
class BhpIssueStatisticsPage extends StatelessWidget {
  /// Tworzy osobny ekran statystyk operacji BHP.
  const BhpIssueStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BhpIssueStatisticsContent();
  }
}

/// Zawartość ekranu statystyk BHP.
class _BhpIssueStatisticsContent extends StatelessWidget {
  /// Tworzy zawartość ekranu statystyk BHP.
  const _BhpIssueStatisticsContent();

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    return AppModuleSection(
      title: intl.bhpStatisticsTitle,
      subtitle: intl.bhpStatisticsSubtitle,
      child: const _StatisticsWorkspace(),
    );
  }
}

/// Segmenty nowego widoku statystyk.
enum _StatisticsSegment {
  /// Statystyki podstawowe wydań.
  issues,

  /// Struktura i przekroje danych.
  structure,

  /// Braki względem standardu.
  missing,

  /// Porównania okresów.
  comparisons,
}

/// Obszar roboczy zakładki statystyk.
class _StatisticsWorkspace extends StatefulWidget {
  /// Tworzy obszar roboczy statystyk.
  const _StatisticsWorkspace();

  @override
  State<_StatisticsWorkspace> createState() => _StatisticsWorkspaceState();
}

/// Stan obszaru roboczego statystyk.
class _StatisticsWorkspaceState extends State<_StatisticsWorkspace> {
  _StatisticsSegment _selectedSegment = _StatisticsSegment.issues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        _StatisticsSegmentSwitch(
          selectedSegment: _selectedSegment,
          onChanged: (segment) => setState(() => _selectedSegment = segment),
        ),
        Gaps.h12,
        Expanded(child: _buildSegmentBody()),
      ],
    );
  }

  Widget _buildSegmentBody() {
    return switch (_selectedSegment) {
      _StatisticsSegment.issues => const _ScrollableStatisticsSegment(
        child: BhpIssueStatisticsIssuesSection(),
      ),
      _StatisticsSegment.structure => const _ScrollableStatisticsSegment(
        child: BhpIssueStatisticsStructureSection(),
      ),
      _StatisticsSegment.missing => const BhpIssueStatisticsMissingSection(),
      _StatisticsSegment.comparisons => const _ScrollableStatisticsSegment(
        child: BhpIssueStatisticsComparisonsSection(),
      ),
    };
  }
}

/// Obszar segmentu ze scrollowaniem ograniczonym do wnętrza sekcji.
class _ScrollableStatisticsSegment extends StatelessWidget {
  /// Tworzy wrapper przewijalnego segmentu statystyk.
  const _ScrollableStatisticsSegment({required this.child});

  /// Właściwa zawartość segmentu.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: child,
    );
  }
}

/// Górny przełącznik segmentów statystyk.
class _StatisticsSegmentSwitch extends StatelessWidget {
  /// Tworzy przełącznik segmentów.
  const _StatisticsSegmentSwitch({
    required this.selectedSegment,
    required this.onChanged,
  });

  /// Aktualnie wybrany segment.
  final _StatisticsSegment selectedSegment;

  /// Obsługa zmiany segmentu.
  final ValueChanged<_StatisticsSegment> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppSectionCard(
      padding: const .all(Sizes.p12),
      child: CupertinoSlidingSegmentedControl<_StatisticsSegment>(
        groupValue: selectedSegment,
        thumbColor: colors.primary,
        backgroundColor: colors.surfaceContainerHighest,
        children: {
          _StatisticsSegment.issues: _SegmentLabel(
            label: context.l10n.bhpStatisticsIssuesTab,
            selected: selectedSegment == _StatisticsSegment.issues,
          ),
          _StatisticsSegment.structure: _SegmentLabel(
            label: context.l10n.bhpStatisticsStructureTab,
            selected: selectedSegment == _StatisticsSegment.structure,
          ),
          _StatisticsSegment.missing: _SegmentLabel(
            label: context.l10n.bhpStatisticsMissingTab,
            selected: selectedSegment == _StatisticsSegment.missing,
          ),
          _StatisticsSegment.comparisons: _SegmentLabel(
            label: context.l10n.bhpStatisticsComparisonsTab,
            selected: selectedSegment == _StatisticsSegment.comparisons,
          ),
        },
        onValueChanged: (value) {
          if (value case final segment?) {
            onChanged(segment);
          }
        },
      ),
    );
  }
}

/// Etykieta pojedynczego segmentu.
class _SegmentLabel extends StatelessWidget {
  /// Tworzy etykietę segmentu.
  const _SegmentLabel({
    required this.label,
    required this.selected,
  });

  /// Tekst etykiety.
  final String label;

  /// Czy segment jest aktywny.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p10,
      ),
      child: Text(
        label,
        style: context.text.labelLarge?.copyWith(
          fontWeight: .w700,
          color: selected ? context.colors.onPrimary : context.colors.onSurface,
        ),
      ),
    );
  }
}
