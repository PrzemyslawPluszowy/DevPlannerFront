import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_command_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_date_picker_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Typ edytowanego pola w wydaniu pracownika.
enum BhpUserIssueFieldEditKind {
  /// Edycja daty przydziału.
  issueDate,

  /// Edycja daty zakończenia.
  endDate,

  /// Edycja ilości.
  quantity,

  /// Edycja uwag.
  notes,
}

/// Otwiera modal edycji pojedynczego pola wydania pracownika.
Future<bool?> showEditUserIssueFieldModal(
  BuildContext context, {
  required int userId,
  required GetBhpUserIssue issue,
  required BhpUserIssueFieldEditKind kind,
}) {
  final usersRepository = context.read<BhpUsersRepository>();
  final title = switch (kind) {
    BhpUserIssueFieldEditKind.issueDate => context.l10n.bhpIssueEditDateTitle,
    BhpUserIssueFieldEditKind.endDate => context.l10n.bhpIssueEditEndDateTitle,
    BhpUserIssueFieldEditKind.quantity =>
      context.l10n.bhpIssueEditQuantityTitle,
    BhpUserIssueFieldEditKind.notes => context.l10n.bhpIssueEditNotesTitle,
  };

  return AppModalSheet.show<bool>(
    context,
    title: title,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => BhpUserIssueCommandCubit(
        repository: usersRepository,
        userId: userId,
        inProgressMessage: context.l10n.bhpUserIssueCommandInProgress,
      ),
      child: _EditUserIssueFieldModalBody(
        issue: issue,
        kind: kind,
      ),
    ),
  );
}

/// Treść modala edycji pojedynczego pola wydania.
class _EditUserIssueFieldModalBody extends StatefulWidget {
  /// Tworzy treść modala edycji pola.
  const _EditUserIssueFieldModalBody({
    required this.issue,
    required this.kind,
  });

  final GetBhpUserIssue issue;
  final BhpUserIssueFieldEditKind kind;

  @override
  State<_EditUserIssueFieldModalBody> createState() =>
      _EditUserIssueFieldModalBodyState();
}

/// Stan modala edycji pojedynczego pola wydania.
class _EditUserIssueFieldModalBodyState
    extends State<_EditUserIssueFieldModalBody> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _issueDate;
  DateTime? _endDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _issueDate = DateTime.tryParse(widget.issue.dataPrzydzialu);
    _endDate = DateTime.tryParse(widget.issue.dataZakonczenia ?? '');
    _quantityController.text = widget.issue.ilosc ?? '';
    _notesController.text = widget.issue.uwagi ?? '';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final assignmentDate = DateTime.tryParse(widget.issue.dataPrzydzialu);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: .start,
        children: [
          switch (widget.kind) {
            BhpUserIssueFieldEditKind.issueDate => AppDatePickerField(
              value: _issueDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              variant: .filled,
              labelText: intl.bhpIssueFormDateLabel,
              enabled: !_isSaving,
              onChanged: (value) => setState(() => _issueDate = value),
            ),
            BhpUserIssueFieldEditKind.endDate => AppDatePickerField(
              value: _endDate,
              firstDate: assignmentDate ?? DateTime(1900),
              lastDate: DateTime(2100),
              variant: .filled,
              labelText: intl.bhpIssueFormEndDateLabel,
              helperText: intl.bhpIssueEditEndDateHelperText,
              enabled: !_isSaving,
              onChanged: (value) => setState(() => _endDate = value),
            ),
            BhpUserIssueFieldEditKind.quantity => AppTextField(
              controller: _quantityController,
              variant: .filled,
              labelText: intl.bhpIssueFormQuantityLabel,
              enabled: !_isSaving,
              validators: [
                (value) {
                  final normalized = value?.replaceAll(',', '.').trim() ?? '';
                  final parsed = double.tryParse(normalized);
                  if (parsed == null || parsed <= 0) {
                    return intl.bhpIssueValidationPositiveQuantity;
                  }
                  return null;
                },
              ],
            ),
            BhpUserIssueFieldEditKind.notes => AppTextField(
              controller: _notesController,
              variant: .filled,
              labelText: intl.bhpIssueFormNotesLabel,
              enabled: !_isSaving,
              minLines: 3,
              maxLines: 5,
            ),
          },
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
    final intl = context.l10n;
    final assignmentDate = DateTime.tryParse(widget.issue.dataPrzydzialu);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.kind == BhpUserIssueFieldEditKind.issueDate &&
        _issueDate == null) {
      AppToast.show(
        context,
        message: intl.bhpIssueEditInvalidDateMessage,
        tone: AppToastTone.error,
      );
      return;
    }

    final cardId = widget.issue.kartaWyposazeniaId;
    final issueDate = assignmentDate;
    final quantity = switch (widget.kind) {
      BhpUserIssueFieldEditKind.quantity =>
        _quantityController.text.replaceAll(',', '.').trim(),
      _ => widget.issue.ilosc,
    };

    if (cardId == null || quantity == null || issueDate == null) {
      AppToast.show(
        context,
        message: intl.bhpIssueEditMissingSourceMessage,
        tone: AppToastTone.error,
      );
      return;
    }

    if (widget.kind == BhpUserIssueFieldEditKind.endDate) {
      final endDate = _endDate;
      if (endDate != null &&
          DateUtils.dateOnly(endDate).isBefore(DateUtils.dateOnly(issueDate))) {
        AppToast.show(
          context,
          message: intl.inventoryCloseDateValidationMessage,
          tone: AppToastTone.error,
        );
        return;
      }
    }

    setState(() => _isSaving = true);
    final effectiveIssueDate = switch (widget.kind) {
      BhpUserIssueFieldEditKind.issueDate => _issueDate!,
      BhpUserIssueFieldEditKind.endDate => issueDate,
      BhpUserIssueFieldEditKind.quantity => issueDate,
      BhpUserIssueFieldEditKind.notes => issueDate,
    };

    final request = PatchBhpUserIssueRequest(
      kartaWyposazeniaId: cardId,
      dataPrzydzialu: effectiveIssueDate.toApiDate(),
      dataZakonczenia: switch (widget.kind) {
        BhpUserIssueFieldEditKind.endDate => _endDate?.toApiDate(),
        _ => widget.issue.dataZakonczenia,
      },
      ilosc: quantity,
      uwagi: switch (widget.kind) {
        BhpUserIssueFieldEditKind.issueDate => widget.issue.uwagi,
        BhpUserIssueFieldEditKind.endDate => widget.issue.uwagi,
        BhpUserIssueFieldEditKind.quantity => widget.issue.uwagi,
        BhpUserIssueFieldEditKind.notes =>
          _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
      },
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
