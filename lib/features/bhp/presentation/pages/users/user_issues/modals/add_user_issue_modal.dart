import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_command_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_date_picker_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

/// Otwiera modal dodawania nowego wydania wyposażenia dla pracownika.
Future<bool?> showAddUserIssueModal(
  BuildContext context, {
  required int userId,
  String? title,
  int? initialEquipmentId,
  DateTime? initialIssueDate,
  String? initialQuantity,
  String? initialNotes,
}) {
  final equipmentRepository = context.read<BhpEquipmentRepository>();
  final usersRepository = context.read<BhpUsersRepository>();

  return AppModalSheet.show<bool>(
    context,
    title: title ?? context.l10n.bhpIssueFormAddTitle,
    body: BlocProvider(
      create: (_) => BhpUserIssueCommandCubit(
        repository: usersRepository,
        userId: userId,
        inProgressMessage: context.l10n.bhpUserIssueCommandInProgress,
      ),
      child: _AddUserIssueModalBody(
        equipmentRepository: equipmentRepository,
        initialEquipmentId: initialEquipmentId,
        initialIssueDate: initialIssueDate,
        initialQuantity: initialQuantity,
        initialNotes: initialNotes,
      ),
    ),
  );
}

/// Treść modala dodawania wydania wyposażenia.
class _AddUserIssueModalBody extends StatefulWidget {
  /// Tworzy treść modala.
  const _AddUserIssueModalBody({
    required this.equipmentRepository,
    this.initialEquipmentId,
    this.initialIssueDate,
    this.initialQuantity,
    this.initialNotes,
  });

  final BhpEquipmentRepository equipmentRepository;
  final int? initialEquipmentId;
  final DateTime? initialIssueDate;
  final String? initialQuantity;
  final String? initialNotes;

  @override
  State<_AddUserIssueModalBody> createState() => _AddUserIssueModalBodyState();
}

class _AddUserIssueModalBodyState extends State<_AddUserIssueModalBody> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  List<GetBhpEquipmentListItem>? _equipmentList;
  bool _isLoadingEquipment = true;
  String? _equipmentLoadError;

  int? _selectedEquipmentId;
  DateTime? _issueDate = DateTime.now();
  bool _submitted = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedEquipmentId = widget.initialEquipmentId;
    _issueDate = widget.initialIssueDate ?? DateTime.now();
    _quantityController.text = widget.initialQuantity ?? '';
    _notesController.text = widget.initialNotes ?? '';
    unawaited(_loadEquipment());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadEquipment() async {
    final result = await widget.equipmentRepository.getEquipment(active: true);
    if (!mounted) {
      return;
    }

    result.fold(
      (error) => setState(() {
        _equipmentLoadError = error.message;
        _isLoadingEquipment = false;
      }),
      (list) => setState(() {
        _equipmentList = list;
        _isLoadingEquipment = false;
        _applyDefaultQuantityIfNeeded();
      }),
    );
  }

  void _applyDefaultQuantityIfNeeded() {
    if (_quantityController.text.trim().isNotEmpty) {
      return;
    }

    final selected = _equipmentList?.firstWhere(
      (item) => item.id == _selectedEquipmentId,
      orElse: () => const GetBhpEquipmentListItem(
        id: -1,
        symbol: '',
        nazwa: '',
        aktywny: true,
      ),
    );

    final defaultQuantity = selected?.iloscDomyslna?.trim();
    if (defaultQuantity case final qty? when qty.isNotEmpty) {
      _quantityController.text = qty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    if (_isLoadingEquipment) {
      return const SizedBox(
        height: 200,
        child: Center(child: AppSpinner()),
      );
    }

    if (_equipmentLoadError case final message?) {
      return AppEmptyState.error(
        title: intl.bhpEquipmentErrorTitle,
        message: message,
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: intl.bhpIssueFormEquipmentLabel,
              style: context.text.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: .w600,
                height: 1,
              ),
              children: [
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
          IgnorePointer(
            ignoring: _isSaving,
            child: AppSearchDropdown<int>(
              options: [
                for (final eq in _equipmentList ?? <GetBhpEquipmentListItem>[])
                  AppSearchDropdownOption(
                    value: eq.id,
                    label: '${eq.symbol} - ${eq.nazwa}',
                    keywords: [eq.symbol, eq.nazwa],
                  ),
              ],
              hintText: intl.bhpIssueFormEquipmentHint,
              onSelected: (option) {
                setState(() {
                  _selectedEquipmentId = option.value;
                  final selected = _equipmentList?.firstWhere(
                    (e) => e.id == option.value,
                  );
                  if (selected?.iloscDomyslna case final qty?
                      when qty.isNotEmpty) {
                    _quantityController.text = qty;
                  }
                });
              },
            ),
          ),
          if (_submitted && _selectedEquipmentId == null)
            Padding(
              padding: const EdgeInsets.only(top: Sizes.p4, left: Sizes.p12),
              child: Text(
                intl.bhpIssueFormEquipmentRequired,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
          Gaps.h16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppDatePickerField(
                  value: _issueDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  variant: .filled,
                  labelText: intl.bhpIssueFormDateLabel,
                  enabled: !_isSaving,
                  onChanged: (value) => setState(() => _issueDate = value),
                ),
              ),
              Gaps.w16,
              Expanded(
                child: AppTextField(
                  controller: _quantityController,
                  variant: .filled,
                  labelText: intl.bhpIssueFormQuantityLabel,
                  isRequired: true,
                  enabled: !_isSaving,
                  validators: [
                    AppValidators.required(),
                    (value) {
                      final val = value?.replaceAll(',', '.') ?? '';
                      final parsed = double.tryParse(val);
                      if (parsed == null || parsed <= 0) {
                        return intl.bhpIssueValidationPositiveQuantity;
                      }
                      return null;
                    },
                  ],
                ),
              ),
            ],
          ),
          Gaps.h16,
          AppTextField(
            controller: _notesController,
            variant: .filled,
            labelText: intl.bhpIssueFormNotesLabel,
            enabled: !_isSaving,
            maxLines: 3,
            minLines: 2,
          ),
          Gaps.h24,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppActionButton.text(
                label: intl.cancel,
                icon: Icons.close_rounded,
                tone: .neutral,
                onPressed: _isSaving
                    ? null
                    : () => Navigator.of(context).pop(false),
              ),
              Gaps.w8,
              AppActionButton.filled(
                label: intl.save,
                icon: Icons.save_outlined,
                onPressedAsync: _isSaving ? null : _submit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);

    if (!_formKey.currentState!.validate() ||
        _selectedEquipmentId == null ||
        _issueDate == null) {
      return;
    }

    setState(() => _isSaving = true);
    final intl = context.l10n;

    final request = PostBhpUserIssueRequest(
      kartaWyposazeniaId: _selectedEquipmentId!,
      dataPrzydzialu: _issueDate!.toApiDate(),
      ilosc: _quantityController.text.trim(),
      uwagi: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final result = await context.read<BhpUserIssueCommandCubit>().addIssue(
      request,
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (error) {
        setState(() => _isSaving = false);
        AppToast.show(
          context,
          message: error.message,
          tone: AppToastTone.error,
        );
      },
      (_) {
        AppToast.show(
          context,
          message: intl.bhpIssueFormSuccessAdd,
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(true);
      },
    );
  }
}
