import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_equipment_info_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_equipment_info_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';

/// Otwiera modal z informacjami o karcie wyposażenia powiązanej z wydaniem.
Future<void> showBhpUserIssueInfoModal(
  BuildContext context, {
  required GetBhpUserIssue issue,
}) {
  final equipmentId = issue.kartaWyposazeniaId;
  if (equipmentId == null) {
    return AppModalSheet.show<void>(
      context,
      title: _buildFallbackTitle(context, issue),
      subtitle: context.l10n.bhpUserIssueInfoSubtitle,
      size: AppModalSheetSize.small,
      minBodyHeight: 0,
      maxBodyHeight: 220,
      scrollBody: false,
      body: AppEmptyState.error(
        title: context.l10n.bhpUserIssueInfoNoEquipmentTitle,
        message: context.l10n.bhpUserIssueInfoNoEquipmentMessage,
        compact: true,
      ),
    );
  }

  final repository = context.read<BhpEquipmentRepository>();

  return AppModalSheet.show<void>(
    context,
    title: _buildFallbackTitle(context, issue),
    subtitle: context.l10n.bhpUserIssueInfoSubtitle,
    size: AppModalSheetSize.small,
    minBodyHeight: 0,
    maxBodyHeight: 420,
    scrollBody: false,
    body: BlocProvider(
      create: (_) {
        final cubit = BhpUserIssueEquipmentInfoCubit(repository: repository);
        unawaited(cubit.load(equipmentId));
        return cubit;
      },
      child: _BhpUserIssueInfoModalBody(equipmentId: equipmentId),
    ),
  );
}

String _buildFallbackTitle(BuildContext context, GetBhpUserIssue issue) {
  final symbol = issue.kartaWyposazeniaSymbol?.trim();
  final name = issue.kartaWyposazeniaNazwa?.trim();

  if ((symbol ?? '').isNotEmpty && (name ?? '').isNotEmpty) {
    return '$symbol - $name';
  }

  if ((symbol ?? '').isNotEmpty) {
    return symbol!;
  }

  if ((name ?? '').isNotEmpty) {
    return name!;
  }

  return context.l10n.bhpUserIssueInfoSubtitle;
}

/// Treść modala informacji o karcie wyposażenia.
class _BhpUserIssueInfoModalBody extends StatelessWidget {
  /// Tworzy treść modala informacji o karcie wyposażenia.
  const _BhpUserIssueInfoModalBody({required this.equipmentId});

  final int equipmentId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BhpUserIssueEquipmentInfoCubit,
      BhpUserIssueEquipmentInfoState
    >(
      builder: (context, state) {
        return switch (state) {
          BhpUserIssueEquipmentInfoInitial() ||
          BhpUserIssueEquipmentInfoLoading() => const SizedBox(
            height: 220,
            child: Center(child: AppSpinner()),
          ),
          BhpUserIssueEquipmentInfoError(:final message) => AppEmptyState.error(
            title: context.l10n.bhpUserIssueInfoLoadErrorTitle,
            message: message,
            compact: true,
            action: AppActionButton.outlined(
              label: context.l10n.bhpUserIssueInfoRetryAction,
              icon: Icons.refresh_rounded,
              onPressed: () => context
                  .read<BhpUserIssueEquipmentInfoCubit>()
                  .load(equipmentId),
            ),
          ),
          BhpUserIssueEquipmentInfoSuccess(:final item) =>
            _EquipmentDetailsView(item: item),
        };
      },
    );
  }
}

/// Widok szczegółów karty wyposażenia.
class _EquipmentDetailsView extends StatelessWidget {
  /// Tworzy widok szczegółów karty wyposażenia.
  const _EquipmentDetailsView({required this.item});

  final GetBhpEquipmentDetails item;

  @override
  Widget build(BuildContext context) {
    final rows = <_EquipmentInfoRowData>[
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoSymbolLabel,
        value: item.symbol,
      ),
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoNameLabel,
        value: item.nazwa,
      ),
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoUnitLabel,
        value: item.jm ?? '—',
      ),
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoPeriodLabel,
        value: _formatPeriod(context, item.okresUzywalnosci),
      ),
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoDefaultQuantityLabel,
        value: _formatNumber(item.iloscDomyslna),
      ),
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoEvidenceNumberLabel,
        value: item.nrDowoduWydania ?? '—',
      ),
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoEquivalentLabel,
        value: _formatCurrency(item.ekwiwalent),
      ),
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoPriceLabel,
        value: _formatCurrency(item.cena),
      ),
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoPercentLabel,
        value: item.procentPrzydatnosci == null
            ? '—'
            : '${item.procentPrzydatnosci}%',
      ),
      _EquipmentInfoRowData(
        label: context.l10n.bhpUserIssueInfoStatusLabel,
        value: item.aktywny
            ? context.l10n.bhpStatusActive
            : context.l10n.bhpStatusInactive,
      ),
    ];

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Text(
          context.l10n.bhpUserIssueInfoDescription,
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Gaps.h12,
        for (var index = 0; index < rows.length; index++) ...[
          _EquipmentInfoRow(row: rows[index]),
          if (index < rows.length - 1)
            Divider(
              height: Sizes.p12,
              color: context.colors.outlineVariant,
            ),
        ],
      ],
    );
  }

  String _formatPeriod(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    return '$value ${context.l10n.bhpUserIssueInfoMonthSuffix}';
  }

  String _formatNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) {
      return value;
    }

    if (parsed == parsed.toInt()) {
      return parsed.toInt().toString();
    }

    return parsed.toStringAsFixed(2);
  }

  String _formatCurrency(String? value) {
    final normalized = _formatNumber(value);
    return normalized == '—' ? normalized : '$normalized zł';
  }
}

/// Dane pojedynczego wiersza szczegółów wyposażenia.
class _EquipmentInfoRowData {
  /// Tworzy dane pojedynczego wiersza szczegółów wyposażenia.
  const _EquipmentInfoRowData({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

/// Pojedynczy wiersz szczegółów wyposażenia.
class _EquipmentInfoRow extends StatelessWidget {
  /// Tworzy pojedynczy wiersz szczegółów wyposażenia.
  const _EquipmentInfoRow({required this.row});

  final _EquipmentInfoRowData row;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        SizedBox(
          width: 128,
          child: Text(
            row.label,
            style: context.text.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: .w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            row.value,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurface,
              fontWeight: .w500,
            ),
          ),
        ),
      ],
    );
  }
}
