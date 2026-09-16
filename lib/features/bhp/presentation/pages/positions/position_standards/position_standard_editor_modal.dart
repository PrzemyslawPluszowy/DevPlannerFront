import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/cubit/bhp_position_standards_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/cubit/bhp_position_standards_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

/// Otwiera modal dodawania lub edycji pozycji standardu stanowiska BHP.
Future<bool?> showBhpPositionStandardEditorModal(
  BuildContext context, {
  required GetBhpPositionListItem position,
  GetBhpUserStandardItem? standard,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<BhpPositionStandardsCubit>(),
        child: _BhpPositionStandardEditorDialog(
          position: position,
          standard: standard,
        ),
      );
    },
  );
}

/// Dialog formularza pozycji standardu stanowiska BHP.
class _BhpPositionStandardEditorDialog extends StatefulWidget {
  /// Tworzy dialog formularza pozycji standardu stanowiska.
  const _BhpPositionStandardEditorDialog({
    required this.position,
    this.standard,
  });

  /// Stanowisko, którego dotyczy standard.
  final GetBhpPositionListItem position;

  /// Edytowana pozycja standardu, jeśli modal działa w trybie edycji.
  final GetBhpUserStandardItem? standard;

  @override
  State<_BhpPositionStandardEditorDialog> createState() =>
      _BhpPositionStandardEditorDialogState();
}

/// Stan formularza pozycji standardu stanowiska BHP.
class _BhpPositionStandardEditorDialogState
    extends State<_BhpPositionStandardEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _equipmentController = SearchController();
  final _periodController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  int? _selectedEquipmentId;
  bool _submitted = false;

  bool get _isEditing => widget.standard != null;

  @override
  void initState() {
    super.initState();
    final standard = widget.standard;
    if (standard == null) {
      return;
    }

    _selectedEquipmentId = standard.kartaWyposazeniaId;
    _equipmentController.text = [
      standard.kartaWyposazeniaSymbol,
      standard.kartaWyposazeniaNazwa,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' - ');
    _periodController.text = standard.okres?.toString() ?? '';
    _quantityController.text = standard.ilosc ?? '';
    _notesController.text = standard.uwagi ?? '';
  }

  @override
  void dispose() {
    _equipmentController.dispose();
    _periodController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpPositionStandardsCubit, BhpPositionStandardsState>(
      builder: (context, state) {
        final readyState = state is BhpPositionStandardsReady ? state : null;
        final isSubmitting = readyState?.isSubmitting ?? false;
        final submitError = readyState?.actionError;
        final intl = context.l10n;

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: Sizes.p24,
            vertical: Sizes.p24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const .all(Sizes.p20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    AppText(
                      _isEditing
                          ? intl.bhpPositionStandardEditorEditTitle
                          : intl.bhpPositionStandardEditorCreateTitle,
                      style: context.text.titleMedium?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h8,
                    AppText(
                      widget.position.nazwa,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    Gaps.h20,
                    Text.rich(
                      TextSpan(
                        text: intl.bhpPositionStandardEditorEquipmentLabel,
                        style: context.text.labelSmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                          fontWeight: .w600,
                        ),
                        children: [
                          if (!_isEditing)
                            TextSpan(
                              text: ' *',
                              style: context.text.labelSmall?.copyWith(
                                color: context.colors.error,
                                fontWeight: .w700,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Gaps.h4,
                    if (_isEditing)
                      Container(
                        width: double.infinity,
                        padding: const .all(Sizes.p12),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            .circular(Sizes.p12),
                          ),
                          border: Border.all(
                            color: context.colors.outlineVariant,
                          ),
                        ),
                        child: AppText(
                          _equipmentController.text,
                          style: context.text.bodyMedium,
                        ),
                      )
                    else
                      IgnorePointer(
                        ignoring: isSubmitting,
                        child: AppSearchDropdown<int>(
                          searchController: _equipmentController,
                          options: [
                            for (final item
                                in readyState?.equipment ??
                                    <GetBhpEquipmentListItem>[])
                              AppSearchDropdownOption(
                                value: item.id,
                                label: '${item.symbol} - ${item.nazwa}',
                                subtitle: item.okresUzywalnosci == null
                                    ? item.jm
                                    : [
                                        if (item.okresUzywalnosci
                                            case final period?
                                            when period.trim().isNotEmpty)
                                          'okres: $period',
                                        if (item.jm case final unit?
                                            when unit.trim().isNotEmpty)
                                          unit,
                                      ].join(' · '),
                                keywords: [item.symbol, item.nazwa],
                              ),
                          ],
                          hintText: intl.bhpPositionStandardEditorEquipmentHint,
                          onSelected: (option) {
                            final selectedEquipment = readyState?.equipment
                                .where((item) => item.id == option.value)
                                .firstOrNull;
                            setState(() {
                              _selectedEquipmentId = option.value;
                              _applyEquipmentDefaults(selectedEquipment);
                            });
                          },
                        ),
                      ),
                    if (!_isEditing &&
                        _submitted &&
                        _selectedEquipmentId == null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: Sizes.p4,
                          left: Sizes.p12,
                        ),
                        child: Text(
                          intl.bhpPositionStandardEditorEquipmentRequired,
                          style: context.text.bodySmall?.copyWith(
                            color: context.colors.error,
                          ),
                        ),
                      ),
                    Gaps.h16,
                    Row(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _periodController,
                            variant: .filled,
                            labelText:
                                intl.bhpPositionStandardEditorPeriodLabel,
                            enabled: !isSubmitting,
                            validators: [AppValidators.nonNegativeNumber()],
                          ),
                        ),
                        Gaps.w16,
                        Expanded(
                          child: AppTextField(
                            controller: _quantityController,
                            variant: .filled,
                            labelText:
                                intl.bhpPositionStandardEditorQuantityLabel,
                            enabled: !isSubmitting,
                            validators: [AppValidators.positiveNumber()],
                          ),
                        ),
                      ],
                    ),
                    Gaps.h16,
                    AppTextField(
                      controller: _notesController,
                      variant: .filled,
                      labelText: intl.bhpTableNotes,
                      enabled: !isSubmitting,
                      maxLines: 3,
                      minLines: 2,
                    ),
                    if (submitError case final message?
                        when message.trim().isNotEmpty) ...[
                      Gaps.h12,
                      AppText(
                        message,
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.error,
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                    Gaps.h24,
                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        AppActionButton.text(
                          label: intl.cancel,
                          icon: Icons.close_rounded,
                          tone: .neutral,
                          onPressed: isSubmitting
                              ? null
                              : () => Navigator.of(context).pop(false),
                        ),
                        Gaps.w8,
                        AppActionButton.filled(
                          label: _isEditing ? intl.save : intl.inventoryAdd,
                          icon: _isEditing
                              ? Icons.save_outlined
                              : Icons.add_rounded,
                          onPressedAsync: isSubmitting ? null : _submit,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _applyEquipmentDefaults(GetBhpEquipmentListItem? equipment) {
    if (equipment == null || _isEditing) {
      return;
    }

    _periodController.text = equipment.okresUzywalnosci?.trim() ?? '';
    _quantityController.text = equipment.iloscDomyslna?.trim() ?? '';
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_isEditing && _selectedEquipmentId == null) {
      return;
    }

    final cubit = context.read<BhpPositionStandardsCubit>();
    final result = _isEditing
        ? await cubit.updateStandard(
            widget.standard!.id,
            PatchBhpPositionStandardRequest(
              okres: _nullableInt(_periodController.text),
              ilosc: _nullableNumber(_quantityController.text),
              uwagi: _nullableText(_notesController.text),
            ),
          )
        : await cubit.createStandard(
            PostBhpPositionStandardRequest(
              kartaWyposazeniaId: _selectedEquipmentId!,
              okres: _nullableInt(_periodController.text),
              ilosc: _nullableNumber(_quantityController.text),
              uwagi: _nullableText(_notesController.text),
            ),
          );

    if (!mounted) {
      return;
    }

    result.fold(
      (_) {},
      (_) {
        AppToast.show(
          context,
          message: _isEditing
              ? context.l10n.bhpPositionStandardEditorEditSuccess
              : context.l10n.bhpPositionStandardEditorCreateSuccess,
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(true);
      },
    );
  }

  int? _nullableInt(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }

    return int.tryParse(normalized);
  }

  String? _nullableNumber(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    return normalized.isEmpty ? null : normalized;
  }

  String? _nullableText(String value) {
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}
