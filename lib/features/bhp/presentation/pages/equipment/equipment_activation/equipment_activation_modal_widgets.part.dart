part of 'equipment_activation_modal.dart';

/// Lista powiązań, które zostaną wyłączone przy dezaktywacji karty.
class _InactiveImpactList extends StatelessWidget {
  /// Tworzy listę skutków dezaktywacji.
  const _InactiveImpactList({required this.entries});

  /// Pozycje standardów powiązanych z kartą.
  final List<BhpEquipmentActivationEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return AppEmptyState.noData(
        title: context.l10n.bhpEquipmentImpactInactiveEmptyTitle,
        message: context.l10n.bhpEquipmentImpactInactiveEmptyMessage,
      );
    }

    return Column(
      crossAxisAlignment: .start,
      children: [
        _SectionTitle(title: context.l10n.bhpEquipmentImpactInactiveSection),
        Gaps.h8,
        ...entries.map((entry) => _ImpactTile(entry: entry)),
      ],
    );
  }
}

/// Lista przypisań możliwych do przywrócenia przy aktywacji karty.
class _ActiveImpactList extends StatelessWidget {
  /// Tworzy listę skutków aktywacji.
  const _ActiveImpactList({required this.state});

  /// Gotowy stan modala aktywacji.
  final BhpEquipmentActivationReady state;

  @override
  Widget build(BuildContext context) {
    final entries = state.restorableStandards
        .map((standard) => BhpEquipmentActivationEntry(standard: standard))
        .toList(growable: false);

    if (entries.isEmpty) {
      return AppEmptyState.noData(
        title: context.l10n.bhpEquipmentImpactActiveEmptyTitle,
        message: context.l10n.bhpEquipmentImpactActiveEmptyMessage,
      );
    }

    return Column(
      crossAxisAlignment: .start,
      children: [
        _SectionTitle(title: context.l10n.bhpEquipmentImpactActiveSection),
        Gaps.h8,
        Text(
          context.l10n.bhpEquipmentImpactActiveHint,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
            height: 1.3,
          ),
        ),
        Gaps.h12,
        ...entries.map(
          (entry) => _SelectableImpactTile(
            entry: entry,
            value: state.selectedStandardIds.contains(entry.standard.id),
            onChanged: state.isSubmitting
                ? null
                : (_) => context
                      .read<BhpEquipmentActivationCubit>()
                      .toggleSelection(entry.standard.id),
          ),
        ),
      ],
    );
  }
}

/// Kafelek informacyjny pojedynczego powiązania standardu.
class _ImpactTile extends StatelessWidget {
  /// Tworzy kafelek informacyjny.
  const _ImpactTile({required this.entry});

  /// Powiązanie standardu do wyświetlenia.
  final BhpEquipmentActivationEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: Sizes.p8),
      child: _ImpactTileFrame(
        child: ListTile(
          dense: true,
          contentPadding: const .symmetric(
            horizontal: Sizes.p12,
            vertical: Sizes.p4,
          ),
          leading: const Icon(Icons.work_outline_rounded),
          title: Text(
            entry.label,
            style: context.text.bodyMedium?.copyWith(fontWeight: .w600),
          ),
          subtitle: _ImpactSubtitle(entry: entry),
        ),
      ),
    );
  }
}

/// Kafelek wyboru pojedynczego powiązania standardu.
class _SelectableImpactTile extends StatelessWidget {
  /// Tworzy kafelek wyboru.
  const _SelectableImpactTile({
    required this.entry,
    required this.value,
    required this.onChanged,
  });

  /// Powiązanie standardu do wyświetlenia.
  final BhpEquipmentActivationEntry entry;

  /// Aktualna wartość wyboru.
  final bool value;

  /// Obsługa zmiany wyboru.
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: Sizes.p8),
      child: _ImpactTileFrame(
        child: CheckboxListTile(
          value: value,
          onChanged: onChanged,
          dense: true,
          visualDensity: .compact,
          contentPadding: const .symmetric(
            horizontal: Sizes.p12,
            vertical: Sizes.p4,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            entry.label,
            style: context.text.bodyMedium?.copyWith(fontWeight: .w600),
          ),
          subtitle: _ImpactSubtitle(entry: entry),
        ),
      ),
    );
  }
}

/// Ramka wizualna wspólna dla kafelków wpływu statusu.
class _ImpactTileFrame extends StatelessWidget {
  /// Tworzy ramkę kafelka wpływu.
  const _ImpactTileFrame({required this.child});

  /// Zawartość kafelka.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surfaceContainerLow,
      borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
      clipBehavior: .antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
          border: Border.all(
            color: context.colors.outlineVariant.withValues(alpha: .7),
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Zawartość sekcji podrzędnej z opisem wpływu pozycji.
class _ImpactSubtitle extends StatelessWidget {
  /// Tworzy opis wpływu pozycji.
  const _ImpactSubtitle({required this.entry});

  /// Powiązanie standardu do pokazania.
  final BhpEquipmentActivationEntry entry;

  @override
  Widget build(BuildContext context) {
    final subtitle = entry.subtitle.trim();

    return Padding(
      padding: const .only(top: Sizes.p4),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AppStatusBadge(
            label: entry.standard.positionActive
                ? context.l10n.bhpStatusActive
                : context.l10n.bhpStatusInactive,
            tone: entry.standard.positionActive
                ? AppStatusBadgeTone.success
                : AppStatusBadgeTone.warning,
            icon: entry.standard.positionActive
                ? Icons.check_circle_outline_rounded
                : Icons.pause_circle_outline_rounded,
          ),
          if (subtitle.isNotEmpty) ...[
            Gaps.h8,
            Text(
              subtitle,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Nagłówek sekcji na liście wpływu statusu.
class _SectionTitle extends StatelessWidget {
  /// Tworzy nagłówek sekcji.
  const _SectionTitle({required this.title});

  /// Tekst nagłówka.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.text.titleSmall?.copyWith(
        fontWeight: .w700,
        color: context.colors.onSurface,
      ),
    );
  }
}
