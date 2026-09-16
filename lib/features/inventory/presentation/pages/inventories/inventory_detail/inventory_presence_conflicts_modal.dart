import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_presence_conflicts_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_element_status_ui.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Wynik wyboru konfliktu obecnosci.
final class InventoryPresenceConflictSelection {
  /// Tworzy wybor konfliktu do otwarcia w arkuszu.
  const InventoryPresenceConflictSelection({
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

/// Wynik odswiezenia danych konfliktow obecnosci.
final class InventoryPresenceConflictsRefreshResult {
  /// Tworzy wynik odswiezenia danych konfliktow.
  const InventoryPresenceConflictsRefreshResult({
    required this.data,
    this.errorMessage,
  });

  /// Dane do dalszego wyswietlenia w modalu.
  final GetInwentaryzacjaPresenceConflictsResponseData data;

  /// Ewentualny komunikat bledu po odswiezeniu.
  final String? errorMessage;
}

/// Otwiera modal listy konfliktow obecnosci dla inwentaryzacji.
Future<InventoryPresenceConflictSelection?> showInventoryPresenceConflictsModal(
  BuildContext context, {
  required String inventoryNumber,
  required GetInwentaryzacjaPresenceConflictsResponseData data,
  String? errorMessage,
  Future<InventoryPresenceConflictsRefreshResult> Function()? onRefresh,
}) {
  return AppModalSheet.show<InventoryPresenceConflictSelection>(
    context,
    title: context.l10n.inventoryPresenceConflictsTitle,
    subtitle: context.l10n.inventoryPresenceConflictsSubtitle(inventoryNumber),
    size: AppModalSheetSize.fullscreen,
    minBodyHeight: double.infinity,
    maxBodyHeight: double.infinity,
    scrollBody: false,
    padding: const EdgeInsets.all(Sizes.p20),
    body: _InventoryPresenceConflictsModalBody(
      data: data,
      errorMessage: errorMessage,
      onRefresh: onRefresh,
    ),
  );
}

/// Tresc modala konfliktow obecnosci.
class _InventoryPresenceConflictsModalBody extends StatefulWidget {
  /// Tworzy tresc modala.
  const _InventoryPresenceConflictsModalBody({
    required this.data,
    this.errorMessage,
    this.onRefresh,
  });

  /// Zaladowane dane konfliktow obecnosci.
  final GetInwentaryzacjaPresenceConflictsResponseData data;

  /// Komunikat bledu odswiezenia, gdy modal pokazuje stale dane.
  final String? errorMessage;

  /// Callback odswiezenia z poziomu modala.
  final Future<InventoryPresenceConflictsRefreshResult> Function()? onRefresh;

  @override
  State<_InventoryPresenceConflictsModalBody> createState() =>
      _InventoryPresenceConflictsModalBodyState();
}

/// Stan tresci modala konfliktow obecnosci.
class _InventoryPresenceConflictsModalBodyState
    extends State<_InventoryPresenceConflictsModalBody> {
  late GetInwentaryzacjaPresenceConflictsResponseData _data;
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
    final groups = _data.items;
    final totals = _data.meta.totals;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText(
                context.l10n.inventoryPresenceConflictsResultsCount(
                  totals.itemsCount,
                ),
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
            if (groups.isNotEmpty)
              AppStatusBadge(
                label: context.l10n.inventoryPresenceConflictsDetectedAction(
                  totals.itemsCount,
                ),
                tone: .danger,
                icon: Icons.close_rounded,
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
        if (_errorMessage != null && groups.isNotEmpty) ...[
          Gaps.h12,
          AppEmptyState.error(
            title: context.l10n.inventoryLoadingErrorTitle,
            message: _errorMessage!,
            compact: true,
          ),
        ],
        Gaps.h12,
        Expanded(
          child: groups.isEmpty
              ? (_errorMessage != null
                    ? AppEmptyState.error(
                        title: context.l10n.inventoryLoadingErrorTitle,
                        message: _errorMessage!,
                        compact: true,
                      )
                    : AppEmptyState.noResults(
                        title:
                            context.l10n.inventoryPresenceConflictsEmptyTitle,
                        message:
                            context.l10n.inventoryPresenceConflictsEmptyMessage,
                        compact: true,
                      ))
              : ListView.separated(
                  itemCount: groups.length,
                  separatorBuilder: (_, _) => Gaps.h12,
                  itemBuilder: (context, index) => _ConflictGroupCard(
                    group: groups[index],
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

/// Karta grupy konfliktu z parami arkuszy.
class _ConflictGroupCard extends StatelessWidget {
  /// Tworzy karte grupy konfliktu.
  const _ConflictGroupCard({required this.group});

  /// Grupa konfliktowa zwrocona przez backend.
  final GetInwentaryzacjaPresenceConflictsGroup group;

  @override
  Widget build(BuildContext context) {
    final pairs = _buildPairs(group.matches);

    return Container(
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppText(
                _title(context),
                style: context.text.titleSmall?.copyWith(fontWeight: .w700),
              ),
              if (_registerNumber != null)
                InkWell(
                  borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
                  onTap: () => _copyRegisterNumber(context, _registerNumber!),
                  child: AppStatusBadge(
                    label: _registerNumber!,
                    tone: .info,
                    showBorder: false,
                  ),
                ),
              AppStatusBadge(
                label: context.l10n.inventoryPresenceConflictsDetectedAction(
                  group.presenceCount,
                ),
                tone: .danger,
                icon: Icons.close_rounded,
                showBorder: false,
              ),
              AppStatusBadge(
                label: context.l10n.inventoryPresenceConflictsArkuszeCount(
                  group.arkuszeCount,
                ),
                tone: .warning,
                icon: Icons.layers_rounded,
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
          Column(
            children: [
              for (var i = 0; i < pairs.length; i++) ...[
                _ConflictPairRow(pair: pairs[i]),
                if (i < pairs.length - 1) Gaps.h8,
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _title(BuildContext context) {
    final value = group.nazwa?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
    return context.l10n.inventoryNoName;
  }

  String? get _registerNumber {
    final value = group.nrewid?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
    return null;
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

  String? get _metaLine {
    final parts = <String>[];
    if (group.kodKreskowy != null) {
      parts.add(group.kodKreskowy!.toString());
    }
    final person = group.osoba?.trim();
    if (person != null && person.isNotEmpty) {
      parts.add(person);
    }
    return parts.isEmpty ? null : parts.join('  |  ');
  }

  List<_ConflictPair> _buildPairs(
    List<GetInwentaryzacjaSearchArkuszeMatch> rows,
  ) {
    if (rows.length < 2) {
      return rows
          .map(
            (match) => _ConflictPair(
              left: match,
              right: null,
            ),
          )
          .toList(growable: false);
    }

    final pairs = <_ConflictPair>[];
    for (var i = 0; i < rows.length; i += 2) {
      pairs.add(
        _ConflictPair(
          left: rows[i],
          right: i + 1 < rows.length ? rows[i + 1] : null,
        ),
      );
    }
    return pairs;
  }
}

/// Para rekordow konfliktu do pokazania obok siebie.
final class _ConflictPair {
  /// Tworzy pare rekordow konfliktu.
  const _ConflictPair({
    required this.left,
    required this.right,
  });

  /// Lewy rekord pary.
  final GetInwentaryzacjaSearchArkuszeMatch left;

  /// Prawy rekord pary.
  final GetInwentaryzacjaSearchArkuszeMatch? right;
}

/// Wiersz z dwiema stronami konfliktu.
class _ConflictPairRow extends StatelessWidget {
  /// Tworzy wiersz pary konfliktu.
  const _ConflictPairRow({required this.pair});

  /// Para konfliktowa.
  final _ConflictPair pair;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: _ConflictMatchPane(item: pair.left),
        ),
        Gaps.w8,
        Expanded(
          child: pair.right == null
              ? const SizedBox.shrink()
              : _ConflictMatchPane(item: pair.right!),
        ),
      ],
    );
  }
}

/// Pojedyncza strona konfliktu z akcja przejscia do arkusza.
class _ConflictMatchPane extends StatelessWidget {
  /// Tworzy panel pojedynczego arkusza konfliktowego.
  const _ConflictMatchPane({required this.item});

  /// Match konfliktowy.
  final GetInwentaryzacjaSearchArkuszeMatch item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.p10),
      decoration: BoxDecoration(
        color: context.colors.errorContainer.withValues(alpha: .18),
        borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
        border: Border.all(color: context.colors.error.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  _sheetNumber(context),
                  style: context.text.titleSmall?.copyWith(fontWeight: .w700),
                ),
              ),
              _statusBadgeForUiStatus(
                context,
                item.uiStatus ?? SearchArkuszeUiStatus.brak,
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
          if (_hasValue(item.foundInArkuszNumer))
            _InfoLine(
              label: context.l10n.inventorySearchSheetsTitle,
              value: item.foundInArkuszNumer!.trim(),
            ),
          if (_hasValue(item.foundInMiejsce))
            _InfoLine(
              label: context.l10n.inventoryLocation,
              value: item.foundInMiejsce!.trim(),
            ),
          Gaps.h8,
          Align(
            alignment: .centerRight,
            child: AppActionButton.outlined(
              label: 'Idz do arkusza',
              icon: Icons.arrow_forward_rounded,
              onPressed: item.arkuszId == null
                  ? null
                  : () => Navigator.of(context).pop(
                      InventoryPresenceConflictSelection(
                        arkuszId: item.arkuszId!,
                        arkuszNumber: _sheetNumber(context),
                        elementId: item.elementId,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _sheetNumber(BuildContext context) {
    final value = item.arkuszNumer?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
    return context.l10n.inventoryNoNumber;
  }

  String _display(String? value) {
    final normalized = value?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
    return '-';
  }

  bool _hasValue(String? value) {
    final normalized = value?.trim();
    return normalized != null && normalized.isNotEmpty;
  }
}

/// Jedna linia informacji w panelu konfliktu.
class _InfoLine extends StatelessWidget {
  /// Tworzy linie informacji.
  const _InfoLine({
    required this.label,
    required this.value,
  });

  /// Etykieta pola.
  final String label;

  /// Wyswietlana wartosc.
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p4),
      child: Row(
        crossAxisAlignment: .start,
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
              style: context.text.bodySmall?.copyWith(fontWeight: .w600),
            ),
          ),
        ],
      ),
    );
  }
}

AppStatusBadge _statusBadgeForUiStatus(
  BuildContext context,
  SearchArkuszeUiStatus status,
) {
  return switch (status) {
    SearchArkuszeUiStatus.brak => ArkuszElementInwentStatus.brak.toBadge(
      context,
    ),
    SearchArkuszeUiStatus.potwierdzony =>
      ArkuszElementInwentStatus.zgodny.toBadge(context),
    SearchArkuszeUiStatus.niezgodnosc =>
      ArkuszElementInwentStatus.przeniesiony.toBadge(context),
    SearchArkuszeUiStatus.nadwyzka => ArkuszElementStatusSpisu.nadwyzka.toBadge(
      context,
    ),
    SearchArkuszeUiStatus.nowy => ArkuszElementStatusSpisu.nowy.toBadge(
      context,
    ),
    SearchArkuszeUiStatus.znalezionyWInnejFirmie =>
      ArkuszElementStatusSpisu.znalezionyWInnejFirmie.toBadge(context),
    SearchArkuszeUiStatus.niejednoznacznyKod =>
      ArkuszElementStatusSpisu.niejednoznacznyKod.toBadge(context),
    SearchArkuszeUiStatus.sprzedanyWTrakcie =>
      ArkuszElementStatusSpisu.sprzedanyWTrakcie.toBadge(context),
    SearchArkuszeUiStatus.zakupionyWTrakcie =>
      ArkuszElementStatusSpisu.zakupionyWTrakcie.toBadge(context),
    SearchArkuszeUiStatus.doLikwidacji => AppStatusBadge(
      label: context.l10n.inventorySearchSheetsToDisposeStatus,
      tone: .danger,
      icon: Icons.delete_outline_rounded,
      showBorder: false,
    ),
  };
}
