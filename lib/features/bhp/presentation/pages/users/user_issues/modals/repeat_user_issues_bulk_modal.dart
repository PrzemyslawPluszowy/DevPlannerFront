import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_bulk_repeat_command_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_date_picker_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera modal zbiorczego ponownego wydania wskazanych pozycji pracownika.
Future<bool?> showRepeatUserIssuesBulkModal(
  BuildContext context, {
  required int userId,
  required List<GetBhpUserIssue> issues,
}) {
  final usersRepository = context.read<BhpUsersRepository>();

  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.bhpUserIssuesBulkRepeatTitle,
    subtitle: context.l10n.bhpUserIssuesBulkRepeatSubtitle,
    body: BlocProvider(
      create: (_) => BhpUserIssueBulkRepeatCommandCubit(
        repository: usersRepository,
        userId: userId,
        inProgressMessage: context.l10n.bhpUserIssueCommandInProgress,
      ),
      child: _RepeatUserIssuesBulkModalBody(issues: issues),
    ),
  );
}

/// Treść modala zbiorczego ponownego wydania pozycji pracownika.
class _RepeatUserIssuesBulkModalBody extends StatefulWidget {
  /// Tworzy treść modala zbiorczego ponownego wydania.
  const _RepeatUserIssuesBulkModalBody({required this.issues});

  final List<GetBhpUserIssue> issues;

  @override
  State<_RepeatUserIssuesBulkModalBody> createState() =>
      _RepeatUserIssuesBulkModalBodyState();
}

/// Stan formularza zbiorczego ponownego wydania.
class _RepeatUserIssuesBulkModalBodyState
    extends State<_RepeatUserIssuesBulkModalBody> {
  DateTime? _assignmentDate;
  bool _isSaving = false;

  List<GetBhpUserIssue> get _selectedIssues => widget.issues;

  @override
  void initState() {
    super.initState();
    _assignmentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    if (_selectedIssues.isEmpty) {
      return AppEmptyState.noData(
        title: intl.bhpUserIssuesBulkRepeatEmptyTitle,
        message: intl.bhpUserIssuesBulkRepeatEmptyMessage,
      );
    }

    final selectedCount = _selectedIssues.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: .start,
      children: [
        Text(
          intl.bhpUserIssuesBulkRepeatDescription,
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Gaps.h16,
        AppDatePickerField(
          value: _assignmentDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          variant: .filled,
          labelText: intl.bhpIssueFormDateLabel,
          helperText: intl.bhpUserIssuesBulkRepeatDateHelper,
          enabled: !_isSaving,
          onChanged: (value) => setState(() => _assignmentDate = value),
        ),
        Gaps.h16,
        Container(
          constraints: const BoxConstraints(maxHeight: 420),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLowest,
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            border: Border.all(color: context.colors.outlineVariant),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const .all(Sizes.p12),
            itemCount: _selectedIssues.length,
            separatorBuilder: (_, _) => Gaps.h8,
            itemBuilder: (context, index) {
              final issue = _selectedIssues[index];

              return Material(
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  contentPadding: const .symmetric(
                    horizontal: Sizes.p8,
                    vertical: Sizes.p4,
                  ),
                  leading: Icon(
                    Icons.assignment_return_rounded,
                    color: context.colors.primary,
                  ),
                  title: Text(
                    _issueTitle(issue),
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: .w600,
                    ),
                  ),
                  subtitle: Text(
                    _issueSubtitle(context, issue),
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Gaps.h16,
        Text(
          intl.bhpUserIssuesBulkRepeatSelectedCount(selectedCount),
          style: context.text.labelMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
            fontWeight: .w600,
          ),
        ),
        Gaps.h24,
        Row(
          mainAxisAlignment: .end,
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
              label: intl.bhpUserIssuesBulkRepeatSubmitAction,
              icon: Icons.refresh_rounded,
              onPressedAsync: _isSaving ? null : _submit,
            ),
          ],
        ),
      ],
    );
  }

  String _issueTitle(GetBhpUserIssue issue) {
    final symbol = issue.kartaWyposazeniaSymbol?.trim();
    final name = issue.kartaWyposazeniaNazwa?.trim();

    if (symbol case final symbolValue? when symbolValue.isNotEmpty) {
      if (name case final nameValue? when nameValue.isNotEmpty) {
        return '$symbolValue - $nameValue';
      }

      return symbolValue;
    }

    if (name case final nameValue? when nameValue.isNotEmpty) {
      return nameValue;
    }

    return '#${issue.id}';
  }

  String _issueSubtitle(BuildContext context, GetBhpUserIssue issue) {
    final assignedAt = issue.dataPrzydzialu.toAppDate(placeholder: '—');
    final closedAt = issue.dataZakonczenia.toAppDate(placeholder: '—');
    final quantity = issue.ilosc?.trim().isNotEmpty == true
        ? issue.ilosc!
        : '1';
    return context.l10n.bhpUserIssuesBulkRepeatItemSubtitle(
      assignedAt,
      closedAt,
      quantity,
    );
  }

  Future<void> _submit() async {
    final intl = context.l10n;

    if (_assignmentDate == null) {
      AppToast.show(
        context,
        message: intl.bhpIssueEditInvalidDateMessage,
        tone: .error,
      );
      return;
    }

    setState(() => _isSaving = true);

    final result = await context
        .read<BhpUserIssueBulkRepeatCommandCubit>()
        .repeatIssues(
          PostBhpUserIssuesRepeatRequest(
            selectedIssueIds:
                (_selectedIssues
                    .map((issue) => issue.id)
                    .toList(growable: false)
                  ..sort()),
            dataPrzydzialu: _assignmentDate!.toApiDate(),
          ),
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
          tone: .error,
        );
      },
      (createdCount) {
        AppToast.show(
          context,
          message: intl.bhpUserIssuesBulkRepeatSuccess(createdCount),
          tone: .success,
        );
        Navigator.of(context).pop(true);
      },
    );
  }
}
