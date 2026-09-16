import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_surplus_conflicts_models.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Wynik wyboru konfliktu nadwyzki.
final class InventorySurplusConflictSelection {
  /// Tworzy wybor konfliktu do otwarcia w arkuszu.
  const InventorySurplusConflictSelection({
    required this.arkuszId,
    required this.arkuszNumber,
    required this.elementId,
  });

  /// Id docelowego arkusza.
  final int arkuszId;

  /// Numer docelowego arkusza.
  final String arkuszNumber;

  /// Id elementu do podswietlenia.
  final int elementId;
}

/// Wynik odswiezenia danych konfliktow nadwyzek.
final class InventorySurplusConflictsRefreshResult {
  /// Tworzy wynik odswiezenia danych konfliktow.
  const InventorySurplusConflictsRefreshResult({
    required this.data,
    this.errorMessage,
  });

  /// Dane do dalszego wyswietlenia w modalu.
  final GetInwentaryzacjaSurplusConflictsResponseData data;

  /// Ewentualny komunikat bledu po odswiezeniu.
  final String? errorMessage;
}

/// Otwiera modal listy konfliktow nadwyzek dla inwentaryzacji.
Future<InventorySurplusConflictSelection?> showInventorySurplusConflictsModal(
  BuildContext context, {
  required String inventoryNumber,
  required GetInwentaryzacjaSurplusConflictsResponseData data,
  String? errorMessage,
  Future<InventorySurplusConflictsRefreshResult> Function()? onRefresh,
}) {
  return AppModalSheet.show<InventorySurplusConflictSelection>(
    context,
    title: context.l10n.inventorySurplusConflictsTitle,
    subtitle: context.l10n.inventorySurplusConflictsSubtitle(inventoryNumber),
    size: AppModalSheetSize.fullscreen,
    minBodyHeight: double.infinity,
    maxBodyHeight: double.infinity,
    scrollBody: false,
    padding: const EdgeInsets.all(Sizes.p20),
    body: _InventorySurplusConflictsModalBody(
      data: data,
      errorMessage: errorMessage,
      onRefresh: onRefresh,
    ),
  );
}

class _InventorySurplusConflictsModalBody extends StatefulWidget {
  const _InventorySurplusConflictsModalBody({
    required this.data,
    this.errorMessage,
    this.onRefresh,
  });

  final GetInwentaryzacjaSurplusConflictsResponseData data;
  final String? errorMessage;
  final Future<InventorySurplusConflictsRefreshResult> Function()? onRefresh;

  @override
  State<_InventorySurplusConflictsModalBody> createState() =>
      _InventorySurplusConflictsModalBodyState();
}

class _InventorySurplusConflictsModalBodyState
    extends State<_InventorySurplusConflictsModalBody> {
  late GetInwentaryzacjaSurplusConflictsResponseData _data;
  String? _errorMessage;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _errorMessage = widget.errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    final items = _data.items;
    final totals = _data.meta.totals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText(
                context.l10n.inventorySurplusConflictsResultsCount(
                  totals.itemsCount,
                ),
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
            if (items.isNotEmpty)
              AppStatusBadge(
                label: context.l10n.inventorySurplusConflictsDetectedAction(
                  totals.itemsCount,
                ),
                tone: .danger,
                icon: Icons.warning_amber_rounded,
                showBorder: false,
              ),
            if (widget.onRefresh != null) ...[
              Gaps.w8,
              AppActionPill(
                label: context.l10n.inventoryRefresh,
                icon: Icons.refresh_rounded,
                tone: .contrast,
                selected: true,
                onPressed: _isRefreshing ? null : _refresh,
              ),
            ],
          ],
        ),
        if (_errorMessage != null && items.isNotEmpty) ...[
          Gaps.h12,
          AppEmptyState.error(
            title: context.l10n.inventoryLoadingErrorTitle,
            message: _errorMessage!,
            compact: true,
          ),
        ],
        Gaps.h12,
        Expanded(
          child: items.isEmpty
              ? (_errorMessage != null
                    ? AppEmptyState.error(
                        title: context.l10n.inventoryLoadingErrorTitle,
                        message: _errorMessage!,
                        compact: true,
                      )
                    : AppEmptyState.noResults(
                        title: context.l10n.inventorySurplusConflictsEmptyTitle,
                        message:
                            context.l10n.inventorySurplusConflictsEmptyMessage,
                        compact: true,
                      ))
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => Gaps.h12,
                  itemBuilder: (context, index) => _SurplusConflictCard(
                    item: items[index],
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _refresh() async {
    final onRefresh = widget.onRefresh;
    if (onRefresh == null || _isRefreshing) {
      return;
    }

    setState(() => _isRefreshing = true);
    try {
      final result = await onRefresh();
      if (!mounted) {
        return;
      }
      setState(() {
        _data = result.data;
        _errorMessage = result.errorMessage;
      });
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }
}

class _SurplusConflictCard extends StatelessWidget {
  const _SurplusConflictCard({required this.item});

  final GetInwentaryzacjaSurplusConflictItem item;

  @override
  Widget build(BuildContext context) {
    final registerNumber = _normalized(item.nrewid);

    return Container(
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppText(
                _title(context),
                style: context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (registerNumber != null)
                InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Sizes.p999),
                  ),
                  onTap: () => _copyRegisterNumber(context, registerNumber),
                  child: AppStatusBadge(
                    label: registerNumber,
                    tone: .info,
                    showBorder: false,
                  ),
                ),
              AppStatusBadge(
                label: context.l10n.inventorySurplusConflictsDetectedAction(1),
                tone: .danger,
                icon: Icons.warning_amber_rounded,
                showBorder: false,
              ),
            ],
          ),
          if (_metaLine != null) ...[
            Gaps.h8,
            AppText(
              _metaLine,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          Gaps.h12,
          Container(
            padding: const EdgeInsets.all(Sizes.p10),
            decoration: BoxDecoration(
              color: context.colors.errorContainer.withValues(alpha: .18),
              borderRadius: const BorderRadius.all(Radius.circular(Sizes.p10)),
              border: Border.all(
                color: context.colors.error.withValues(alpha: .2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        _sheetNumber(context),
                        style: context.text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    AppStatusBadge(
                      label: context.l10n.inventorySurplusConflictsTitle,
                      tone: .danger,
                      showBorder: false,
                    ),
                  ],
                ),
                Gaps.h8,
                _InfoLine(
                  label: context.l10n.inventoryLocation,
                  value: _display(item.arkuszMiejsce),
                ),
                _InfoLine(
                  label: context.l10n.inventoryBarcode,
                  value: item.kodKreskowy?.toString() ?? '-',
                ),
                _InfoLine(
                  label: context.l10n.inventoryPerson,
                  value: _display(item.osoba),
                ),
                _InfoLine(
                  label: context.l10n.inventorySurplusConflictsMatchBasisLabel,
                  value: _matchBasisLabel(context),
                ),
                Gaps.h8,
                Align(
                  alignment: Alignment.centerRight,
                  child: AppActionButton.outlined(
                    label: context.l10n.inventorySearchSheetsOpenSheetAction,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: item.arkuszId == null
                        ? null
                        : () => Navigator.of(context).pop(
                            InventorySurplusConflictSelection(
                              arkuszId: item.arkuszId!,
                              arkuszNumber: _sheetNumber(context),
                              elementId: item.elementId,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _title(BuildContext context) {
    final value = _normalized(item.nazwa);
    if (value != null) {
      return value;
    }
    return context.l10n.inventoryNoName;
  }

  String? get _metaLine {
    final parts = <String>[];
    if (item.firma != null) {
      parts.add('Firma ${item.firma}');
    }
    final state = _normalized(item.stanInwent);
    if (state != null) {
      parts.add(state);
    }
    return parts.isEmpty ? null : parts.join('  |  ');
  }

  String _sheetNumber(BuildContext context) {
    final value = _normalized(item.arkuszNumer);
    if (value != null) {
      return value;
    }
    return context.l10n.inventoryNoNumber;
  }

  String _display(String? value) => _normalized(value) ?? '-';

  String _matchBasisLabel(BuildContext context) {
    return switch (item.matchBasis) {
      'kod_kreskowy' => context.l10n.inventorySurplusConflictsMatchBasisBarcode,
      _ => context.l10n.inventorySurplusConflictsMatchBasisRegisterNumber,
    };
  }

  String? _normalized(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  Future<void> _copyRegisterNumber(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) {
      return;
    }
    AppBubbleToast.show(
      context,
      message: context.l10n.inventoryDuplicateCopiedRegisterToast,
      tone: AppBubbleToastTone.success,
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: AppText(
              label,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: AppText(
              value,
              style: context.text.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
