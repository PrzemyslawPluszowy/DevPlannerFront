import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_equivalent_command_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_date_picker_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

/// Otwiera modal wypłaty ekwiwalentu za wydanie wyposażenia BHP.
Future<bool?> showRegisterIssueEquivalentModal(
  BuildContext context, {
  required int userId,
  required GetBhpUserIssue issue,
}) {
  final usersRepository = context.read<BhpUsersRepository>();
  return AppModalSheet.show<bool>(
    context,
    title: issue.hasEquivalent
        ? context.l10n.bhpIssueEquivalentEditTitle
        : context.l10n.bhpIssueFormEquivalentTitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => BhpUserIssueEquivalentCommandCubit(
        repository: usersRepository,
        userId: userId,
        inProgressMessage: context.l10n.bhpUserIssueCommandInProgress,
      ),
      child: _RegisterIssueEquivalentModalBody(issue: issue),
    ),
  );
}

/// Treść modala wypłaty ekwiwalentu.
class _RegisterIssueEquivalentModalBody extends StatefulWidget {
  /// Tworzy treść modala.
  const _RegisterIssueEquivalentModalBody({required this.issue});

  final GetBhpUserIssue issue;

  @override
  State<_RegisterIssueEquivalentModalBody> createState() =>
      _RegisterIssueEquivalentModalBodyState();
}

class _RegisterIssueEquivalentModalBodyState
    extends State<_RegisterIssueEquivalentModalBody> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  DateTime? _equivDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _equivDate = _initialEquivalentDate();
    _amountController.text = widget.issue.kwotaEkwiwalent ?? '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  DateTime _initialEquivalentDate() {
    final existingEquivalentDate = widget.issue.dataEkwiwalent == null
        ? null
        : DateTime.tryParse(widget.issue.dataEkwiwalent!);
    if (existingEquivalentDate != null) {
      return existingEquivalentDate;
    }

    final today = DateTime.now();
    final issueDate = DateTime.tryParse(widget.issue.dataPrzydzialu);
    final closeDate = widget.issue.dataZakonczenia == null
        ? null
        : DateTime.tryParse(widget.issue.dataZakonczenia!);
    final baseDate = closeDate ?? today;

    if (issueDate == null) {
      return baseDate;
    }

    final issueDay = DateTime(issueDate.year, issueDate.month, issueDate.day);
    final baseDay = DateTime(baseDate.year, baseDate.month, baseDate.day);
    if (baseDay.isBefore(issueDay)) {
      return issueDay;
    }

    return baseDay;
  }

  String get _helperText {
    if (widget.issue.hasEquivalent) {
      return context.l10n.bhpIssueEquivalentHelperExisting;
    }

    if (widget.issue.dataZakonczenia == null) {
      return context.l10n.bhpIssueEquivalentHelperOpen;
    }

    return context.l10n.bhpIssueEquivalentHelperClosed;
  }

  String? _validateEquivalentDate(DateTime selectedDate) {
    final issueDate = DateTime.tryParse(widget.issue.dataPrzydzialu);
    if (issueDate != null) {
      final issueDay = DateTime(issueDate.year, issueDate.month, issueDate.day);
      if (selectedDate.isBefore(issueDay)) {
        return context.l10n.bhpIssueEquivalentInvalidIssueDate;
      }
    }

    final closeDate = widget.issue.dataZakonczenia == null
        ? null
        : DateTime.tryParse(widget.issue.dataZakonczenia!);
    if (closeDate != null) {
      final closeDay = DateTime(closeDate.year, closeDate.month, closeDate.day);
      if (selectedDate.isBefore(closeDay)) {
        return context.l10n.bhpIssueEquivalentInvalidCloseDate;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDatePickerField(
            value: _equivDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            variant: .filled,
            labelText: intl.bhpIssueFormEquivalentDateLabel,
            helperText: _helperText,
            enabled: !_isSaving,
            onChanged: (value) => setState(() => _equivDate = value),
          ),
          Gaps.h16,
          AppTextField(
            controller: _amountController,
            variant: .filled,
            labelText: intl.bhpIssueFormEquivalentAmountLabel,
            isRequired: true,
            enabled: !_isSaving,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validators: [
              AppValidators.required(),
              AppValidators.positiveNumber(
                message: intl.bhpIssueValidationPositiveAmount,
              ),
            ],
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
    if (!_formKey.currentState!.validate() || _equivDate == null) {
      return;
    }

    final dateValidationError = _validateEquivalentDate(_equivDate!);
    if (dateValidationError != null) {
      AppToast.show(
        context,
        message: dateValidationError,
        tone: AppToastTone.error,
      );
      return;
    }

    setState(() => _isSaving = true);
    final intl = context.l10n;

    final request = PostBhpUserIssueEquivalentRequest(
      dataEkwiwalent: _equivDate!.toApiDate(),
      kwotaEkwiwalent: _amountController.text.trim(),
    );

    final result = await context
        .read<BhpUserIssueEquivalentCommandCubit>()
        .registerEquivalent(widget.issue.id, request);

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
          message: widget.issue.hasEquivalent
              ? context.l10n.bhpIssueEquivalentEditSuccess
              : intl.bhpIssueFormSuccessEquivalent,
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(true);
      },
    );
  }
}
