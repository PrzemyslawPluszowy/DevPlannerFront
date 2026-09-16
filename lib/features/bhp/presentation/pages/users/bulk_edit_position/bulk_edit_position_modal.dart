import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';

/// Pokazuje modal masowej zmiany stanowisk dla zaznaczonych pracowników.
/// Zwraca identyfikator wybranego stanowiska lub `null` w przypadku anulowania.
Future<int?> showBulkEditPositionModal(
  BuildContext context, {
  required int selectedEmployeesCount,
}) {
  return AppModalSheet.showSideSheet<int>(
    context,
    title: context.l10n.bhpUsersBulkChangePositionTitle,
    subtitle: context.l10n.bhpUsersBulkSelectedCount(selectedEmployeesCount),
    size: AppModalSheetSize.small,
    padding: EdgeInsets.zero,
    scrollBody: false,
    body: _BulkEditPositionModalBody(
      selectedEmployeesCount: selectedEmployeesCount,
    ),
  );
}

/// Treść modala masowej zmiany stanowisk.
class _BulkEditPositionModalBody extends StatefulWidget {
  /// Tworzy treść modala masowej zmiany stanowisk.
  const _BulkEditPositionModalBody({required this.selectedEmployeesCount});

  /// Liczba zaznaczonych pracowników.
  final int selectedEmployeesCount;

  @override
  State<_BulkEditPositionModalBody> createState() =>
      _BulkEditPositionModalBodyState();
}

class _BulkEditPositionModalBodyState extends State<_BulkEditPositionModalBody> {
  List<GetBhpPositionListItem>? _positions;
  String? _errorMessage;
  int? _selectedPositionId;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPositions());
  }

  Future<void> _loadPositions() async {
    final repository = context.read<BhpPositionsRepository>();
    final result = await repository.getPositions(active: true);

    if (!mounted) return;

    result.fold(
      (error) => setState(() => _errorMessage = error.message),
      (positions) => setState(() => _positions = positions),
    );
  }

  void _handleSave() {
    setState(() => _submitted = true);

    final positionId = _selectedPositionId;
    if (positionId == null) {
      return;
    }

    Navigator.of(context).pop(positionId);
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final errorMessage = _errorMessage;
    final positions = _positions;

    if (errorMessage != null) {
      return AppEmptyState.error(
        title: intl.bhpPositionsErrorTitle,
        message: errorMessage,
      );
    }

    if (positions == null) {
      return const Center(child: AppSpinner());
    }

    return Column(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const .all(Sizes.p24),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  intl.bhpUsersBulkChangePositionConfirm(
                    widget.selectedEmployeesCount,
                  ),
                  style: context.text.bodyLarge?.copyWith(
                    fontWeight: .w500,
                  ),
                ),
                Gaps.h24,
                AppDropdown<int>(
                  options: [
                    for (final pos in positions)
                      AppDropdownOption(
                        value: pos.id,
                        label: pos.nazwa,
                      ),
                  ],
                  value: _selectedPositionId,
                  variant: .filled,
                  labelText: intl.bhpTablePosition,
                  hintText: intl.bhpAddUserSelectPositionHint,
                  errorText: _submitted && _selectedPositionId == null
                      ? intl.bhpAddUserPositionRequiredError
                      : null,
                  onChanged: (val) => setState(() => _selectedPositionId = val),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const .all(Sizes.p24),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: context.colors.outlineVariant,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppActionButton.text(
                label: intl.cancel,
                icon: Icons.close_rounded,
                tone: .neutral,
                onPressed: () => Navigator.of(context).pop(),
              ),
              Gaps.w12,
              AppActionButton.filled(
                label: intl.save,
                icon: Icons.check_rounded,
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
