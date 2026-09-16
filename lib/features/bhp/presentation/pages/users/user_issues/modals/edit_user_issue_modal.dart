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

/// Otwiera modal ręcznej korekty wydania wyposażenia dla pracownika.
Future<bool?> showEditUserIssueModal(
  BuildContext context, {
  required int userId,
  required GetBhpUserIssue issue,
}) {
  final equipmentRepository = context.read<BhpEquipmentRepository>();
  final usersRepository = context.read<BhpUsersRepository>();

  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.bhpIssueEditTitle,
    body: BlocProvider(
      create: (_) => BhpUserIssueCommandCubit(
        repository: usersRepository,
        userId: userId,
        inProgressMessage: context.l10n.bhpUserIssueCommandInProgress,
      ),
      child: _EditUserIssueModalBody(
        equipmentRepository: equipmentRepository,
        issue: issue,
      ),
    ),
  );
}

/// Treść modala korekty wydania wyposażenia.
class _EditUserIssueModalBody extends StatefulWidget {
  /// Tworzy treść modala korekty wydania.
  const _EditUserIssueModalBody({
    required this.equipmentRepository,
    required this.issue,
  });

  final BhpEquipmentRepository equipmentRepository;
  final GetBhpUserIssue issue;

  @override
  State<_EditUserIssueModalBody> createState() =>
      _EditUserIssueModalBodyState();
}

/// Stan formularza korekty wydania.
class _EditUserIssueModalBodyState extends State<_EditUserIssueModalBody> {
  final _formKey = GlobalKey<FormState>();
  final _equipmentSearchController = SearchController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  List<GetBhpEquipmentListItem>? _equipmentList;
  bool _isLoadingEquipment = true;
  String? _equipmentLoadError;

  int? _selectedEquipmentId;
  DateTime? _issueDate;
  bool _submitted = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedEquipmentId = widget.issue.kartaWyposazeniaId;
    _issueDate =
        DateTime.tryParse(widget.issue.dataPrzydzialu) ?? DateTime.now();
    _quantityController.text = widget.issue.ilosc ?? '';
    _notesController.text = widget.issue.uwagi ?? '';
    _equipmentSearchController.text = _selectedEquipmentLabel;
    unawaited(_loadEquipment());
  }

  @override
  void dispose() {
    _equipmentSearchController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String get _selectedEquipmentLabel {
    final symbol = widget.issue.kartaWyposazeniaSymbol?.trim();
    final name = widget.issue.kartaWyposazeniaNazwa?.trim();

    if ((symbol ?? '').isNotEmpty && (name ?? '').isNotEmpty) {
      return '$symbol - $name';
    }

    if ((symbol ?? '').isNotEmpty) {
      return symbol!;
    }

    if ((name ?? '').isNotEmpty) {
      return name!;
    }

    final id = widget.issue.kartaWyposazeniaId;
    return id == null
        ? context.l10n.bhpIssueNoEquipmentFallback
        : context.l10n.bhpIssueCardFallback(id);
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
      (list) {
        final equipment = list.toList(growable: true);
        final currentId = widget.issue.kartaWyposazeniaId;
        if (currentId != null &&
            equipment.every((item) => item.id != currentId)) {
          equipment.add(
            GetBhpEquipmentListItem(
              id: currentId,
              symbol: widget.issue.kartaWyposazeniaSymbol ?? 'BRK',
              nazwa:
                  widget.issue.kartaWyposazeniaNazwa ??
                  context.l10n.bhpIssueUnknownEquipmentFallback,
              aktywny: false,
            ),
          );
        }

        setState(() {
          _equipmentList = equipment;
          _isLoadingEquipment = false;
        });
      },
    );
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
              searchController: _equipmentSearchController,
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
                    AppValidators.positiveNumber(
                      message: intl.bhpIssueValidationPositiveQuantity,
                    ),
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
    final request = PatchBhpUserIssueRequest(
      kartaWyposazeniaId: _selectedEquipmentId!,
      dataPrzydzialu: _issueDate!.toApiDate(),
      dataZakonczenia: widget.issue.dataZakonczenia,
      ilosc: _quantityController.text.trim(),
      uwagi: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final result = await context.read<BhpUserIssueCommandCubit>().updateIssue(
      widget.issue.id,
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
          message: context.l10n.bhpIssueEditSuccess,
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(true);
      },
    );
  }
}
