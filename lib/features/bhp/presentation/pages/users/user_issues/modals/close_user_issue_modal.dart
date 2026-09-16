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

/// Otwiera modal zamknięcia (zwrotu) wydania wyposażenia BHP.
Future<bool?> showCloseUserIssueModal(
  BuildContext context, {
  required int userId,
  required int issueId,
}) {
  final usersRepository = context.read<BhpUsersRepository>();
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.bhpIssueFormCloseTitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => BhpUserIssueCommandCubit(
        repository: usersRepository,
        userId: userId,
        inProgressMessage: context.l10n.bhpUserIssueCommandInProgress,
      ),
      child: _CloseUserIssueModalBody(issueId: issueId),
    ),
  );
}

/// Treść modala zamknięcia wydania wyposażenia.
class _CloseUserIssueModalBody extends StatefulWidget {
  /// Tworzy treść modala.
  const _CloseUserIssueModalBody({required this.issueId});

  final int issueId;

  @override
  State<_CloseUserIssueModalBody> createState() =>
      _CloseUserIssueModalBodyState();
}

class _CloseUserIssueModalBodyState extends State<_CloseUserIssueModalBody> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  DateTime? _endDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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
            value: _endDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            variant: .filled,
            labelText: intl.bhpIssueFormEndDateLabel,
            enabled: !_isSaving,
            onChanged: (value) => setState(() => _endDate = value),
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
    if (!_formKey.currentState!.validate() || _endDate == null) {
      return;
    }

    setState(() => _isSaving = true);
    final intl = context.l10n;

    final request = PostCloseBhpUserIssueRequest(
      dataZakonczenia: _endDate!.toApiDate(),
      uwagi: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final result = await context.read<BhpUserIssueCommandCubit>().closeIssue(
      widget.issueId,
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
          message: intl.bhpIssueFormSuccessClose,
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(true);
      },
    );
  }
}
