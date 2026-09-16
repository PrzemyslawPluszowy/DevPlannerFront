part of '../bhp_user_issues_modal.dart';

/// Obsługa akcji modala wydań pracownika.
extension _BhpUserIssuesModalActions on _BhpUserIssuesModalBodyState {
  String _formatQuantity(String quantity) {
    final parsed = double.tryParse(quantity);
    if (parsed == null) {
      return quantity;
    }
    if (parsed == parsed.toInt()) {
      return parsed.toInt().toString();
    }
    return parsed.toStringAsFixed(2);
  }

  Future<void> _handleAddIssue(
    BuildContext context,
    BhpUserIssuesCubit cubit,
  ) async {
    final added = await showAddUserIssueModal(context, userId: _currentUser.id);
    if (added == true) {
      await cubit.load();
    }
  }

  Future<void> _handleEditUser(
    BuildContext context,
    BhpUserIssuesCubit cubit,
  ) async {
    final updatedUser = await showEditBhpUserModal(context, user: _currentUser);
    if (!context.mounted || updatedUser == null) {
      return;
    }

    _updateCurrentUser(updatedUser);
    await cubit.load();
  }

  List<AppContextMenuAction> _buildIssueActions(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) {
    final intl = context.l10n;

    return [
      if (issue.canClose)
        AppContextMenuAction(
          label: intl.bhpUserIssuesActionClose,
          icon: Icons.assignment_return_outlined,
          onTap: (menuContext) =>
              _handleCloseIssue(menuContext, cubit, issue.id),
        ),
      if (issue.isActive)
        AppContextMenuAction(
          label: intl.bhpUserIssuesRenewAction,
          icon: Icons.refresh_rounded,
          onTap: (menuContext) =>
              _handleRenewActiveIssue(menuContext, cubit, issue),
        ),
      if (issue.canRepeat)
        AppContextMenuAction(
          label: intl.bhpUserIssuesRepeatAction,
          icon: Icons.copy_rounded,
          onTap: (menuContext) => _handleReAddIssue(menuContext, cubit, issue),
        ),
      if (issue.hasEquivalent)
        AppContextMenuAction(
          label: intl.bhpUserIssuesActionDeleteEquivalent,
          icon: Icons.payments_outlined,
          isDestructive: true,
          onTap: (menuContext) =>
              _handleDeleteEquivalent(menuContext, cubit, issue),
        ),
      if (issue.canDelete)
        AppContextMenuAction(
          label: intl.delete,
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
          onTap: (menuContext) => _handleDeleteIssue(menuContext, cubit, issue),
        ),
    ];
  }

  Future<void> _showIssueActionsMenu(
    BuildContext context, {
    required GetBhpUserIssue row,
    required List<AppContextMenuAction> actions,
    Offset? fromPointer,
  }) async {
    if (actions.isEmpty) {
      return;
    }

    final overlayBox =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final pointer = fromPointer == null
        ? Offset(overlayBox.size.width / 2, overlayBox.size.height / 2)
        : overlayBox.globalToLocal(fromPointer);
    final position = RelativeRect.fromLTRB(
      pointer.dx,
      pointer.dy,
      overlayBox.size.width - pointer.dx,
      overlayBox.size.height - pointer.dy,
    );

    final selectedIndex = await showMenu<int>(
      context: context,
      position: position,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(.circular(Sizes.p12)),
      ),
      color: context.colors.surfaceContainerLowest,
      items: [
        PopupMenuItem<int>(
          enabled: false,
          height: 56,
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .center,
            children: [
              Text(
                _getIssueActionsMenuTitle(context, row),
                maxLines: 1,
                overflow: .ellipsis,
                style: context.text.labelLarge?.copyWith(fontWeight: .w700),
              ),
              if (_getIssueActionsMenuSubtitle(row) case final subtitle?) ...[
                Gaps.h2,
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        const PopupMenuDivider(),
        for (var i = 0; i < actions.length; i++)
          PopupMenuItem<int>(
            value: i,
            enabled: actions[i].enabled,
            height: 38,
            child: Row(
              children: [
                if (actions[i].icon case final icon?) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: actions[i].isDestructive
                        ? context.colors.error
                        : context.colors.primary,
                  ),
                  Gaps.w8,
                ],
                Text(
                  actions[i].label,
                  style: context.text.labelLarge?.copyWith(
                    color: actions[i].isDestructive
                        ? context.colors.error
                        : context.colors.primary,
                    fontWeight: .w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    if (selectedIndex case final index?) {
      if (!context.mounted) {
        return;
      }
      await actions[index].onTap(context);
    }
  }

  String _getIssueActionsMenuTitle(
    BuildContext context,
    GetBhpUserIssue issue,
  ) {
    final symbol = issue.kartaWyposazeniaSymbol?.trim();
    if (symbol case final value? when value.isNotEmpty) {
      return context.l10n.bhpUserIssuesActionsForSymbol(value);
    }
    return context.l10n.bhpUserIssuesActionsForIssue;
  }

  String? _getIssueActionsMenuSubtitle(GetBhpUserIssue issue) {
    final name = issue.kartaWyposazeniaNazwa?.trim();
    if (name case final value? when value.isNotEmpty) {
      return value;
    }
    return null;
  }

  Future<void> _handleShowPositionModal(
    BuildContext context, [
    BhpUserIssuesCubit? cubit,
  ]) async {
    final updatedUser = await showBhpUserPositionStandardModal(
      context,
      user: _currentUser,
    );

    if (!context.mounted || updatedUser == null) {
      return;
    }

    _updateCurrentUser(updatedUser);
    if (cubit != null) {
      await cubit.load();
    }
  }

  Future<void> _handleIssueFromStandard(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserStandardItem standard,
  ) async {
    final itemLabel = [
      standard.kartaWyposazeniaSymbol,
      standard.kartaWyposazeniaNazwa,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' - ');
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.bhpUserIssuesIssueStandardConfirmTitle,
      message: context.l10n.bhpUserIssuesIssueStandardConfirmMessage(
        itemLabel.isEmpty ? '#${standard.id}' : itemLabel,
      ),
      confirmLabel: context.l10n.bhpUserIssuesIssueStandardConfirmAction,
      tone: .warning,
    );

    if (!context.mounted || !confirmed) {
      return;
    }

    final result = await cubit.assignFromStandard(
      selectedStandardIds: [standard.id],
    );

    if (!context.mounted) {
      return;
    }

    result.fold(
      (error) => AppToast.show(context, message: error.message, tone: .error),
      (_) => AppToast.show(
        context,
        message: context.l10n.bhpUserIssuesIssueStandardSuccess,
        tone: .success,
      ),
    );
  }

  Future<void> _handleCloseIssue(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    int issueId,
  ) async {
    final closed = await showCloseUserIssueModal(
      context,
      userId: _currentUser.id,
      issueId: issueId,
    );
    if (closed == true) {
      await cubit.load();
    }
  }

  Future<void> _handleEditIssueDate(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) async {
    final saved = await showEditUserIssueFieldModal(
      context,
      userId: _currentUser.id,
      issue: issue,
      kind: BhpUserIssueFieldEditKind.issueDate,
    );
    if (saved == true) {
      await cubit.load();
    }
  }

  Future<void> _handleEditIssueEndDate(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) async {
    final saved = await showEditUserIssueFieldModal(
      context,
      userId: _currentUser.id,
      issue: issue,
      kind: BhpUserIssueFieldEditKind.endDate,
    );
    if (saved == true) {
      await cubit.load();
    }
  }

  Future<void> _handleEditIssueNotes(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) async {
    final saved = await showEditUserIssueFieldModal(
      context,
      userId: _currentUser.id,
      issue: issue,
      kind: BhpUserIssueFieldEditKind.notes,
    );
    if (saved == true) {
      await cubit.load();
    }
  }

  Future<void> _handleEditIssueQuantity(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) async {
    final saved = await showEditUserIssueFieldModal(
      context,
      userId: _currentUser.id,
      issue: issue,
      kind: BhpUserIssueFieldEditKind.quantity,
    );
    if (saved == true) {
      await cubit.load();
    }
  }

  Future<void> _handleDeleteIssue(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) async {
    final issueLabel =
        issue.kartaWyposazeniaSymbol ??
        issue.kartaWyposazeniaNazwa ??
        issue.id.toString();
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.bhpUserIssuesDeleteIssueTitle,
      message: context.l10n.bhpUserIssuesDeleteIssueMessage(issueLabel),
      confirmLabel: context.l10n.delete,
      cancelLabel: context.l10n.cancel,
      tone: AppConfirmDialogTone.danger,
    );

    if (!confirmed) {
      return;
    }

    final result = await cubit.deleteIssue(issue.id);
    if (!context.mounted) {
      return;
    }

    result.fold(
      (error) => AppToast.show(
        context,
        message: error.message,
        tone: AppToastTone.error,
      ),
      (_) => AppToast.show(
        context,
        message: context.l10n.bhpUserIssuesDeleteIssueSuccess,
        tone: AppToastTone.success,
      ),
    );
  }

  Future<void> _handleRegisterEquivalent(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) async {
    final saved = await showRegisterIssueEquivalentModal(
      context,
      userId: _currentUser.id,
      issue: issue,
    );
    if (saved == true) {
      await cubit.load();
    }
  }

  Future<void> _handleDeleteEquivalent(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) async {
    final deleted = await showDeleteIssueEquivalentModal(
      context,
      userId: _currentUser.id,
      issue: issue,
    );
    if (deleted) {
      await cubit.load();
    }
  }

  Future<void> _handleShowIssueInfo(
    BuildContext context,
    GetBhpUserIssue issue,
  ) async {
    await showBhpUserIssueInfoModal(context, issue: issue);
  }

  Future<void> _handleReAddIssue(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) async {
    final issueLabel =
        issue.kartaWyposazeniaSymbol ??
        issue.kartaWyposazeniaNazwa ??
        issue.id.toString();
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.bhpUserIssuesRepeatIssueTitle,
      message: context.l10n.bhpUserIssuesRepeatIssueMessage(issueLabel),
      confirmLabel: context.l10n.bhpUserIssuesRepeatAction,
      cancelLabel: context.l10n.cancel,
      tone: AppConfirmDialogTone.warning,
    );

    if (!confirmed) {
      return;
    }

    final result = await cubit.repeatIssue(issue.id);
    if (!context.mounted) {
      return;
    }

    result.fold(
      (error) => AppToast.show(
        context,
        message: error.message,
        tone: AppToastTone.error,
      ),
      (_) => AppToast.show(
        context,
        message: context.l10n.bhpUserIssuesRepeatIssueSuccess,
        tone: AppToastTone.success,
      ),
    );
  }

  Future<void> _handleBulkRepeatIssues(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    List<GetBhpUserIssue> issues,
  ) async {
    final repeated = await showRepeatUserIssuesBulkModal(
      context,
      userId: _currentUser.id,
      issues: issues,
    );
    if (repeated == true) {
      _resetBulkRenewSelection();
      await cubit.load();
    }
  }

  Future<void> _handleRenewActiveIssue(
    BuildContext context,
    BhpUserIssuesCubit cubit,
    GetBhpUserIssue issue,
  ) async {
    final issueLabel =
        issue.kartaWyposazeniaSymbol ??
        issue.kartaWyposazeniaNazwa ??
        issue.id.toString();
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.bhpUserIssuesRenewActiveTitle,
      message: context.l10n.bhpUserIssuesRenewActiveMessage(issueLabel),
      confirmLabel: context.l10n.bhpUserIssuesRenewActiveAction,
      cancelLabel: context.l10n.cancel,
      tone: AppConfirmDialogTone.warning,
    );

    if (!confirmed || issue.kartaWyposazeniaId == null) {
      return;
    }

    final quantity = issue.ilosc?.trim().isNotEmpty == true
        ? issue.ilosc!
        : '1';
    final result = await cubit.addIssue(
      PostBhpUserIssueRequest(
        kartaWyposazeniaId: issue.kartaWyposazeniaId!,
        dataPrzydzialu: DateTime.now().toIso8601String().split('T').first,
        ilosc: quantity,
        uwagi: issue.uwagi,
      ),
    );

    if (!context.mounted) {
      return;
    }

    result.fold(
      (error) => AppToast.show(context, message: error.message, tone: .error),
      (_) => AppToast.show(
        context,
        message: context.l10n.bhpUserIssuesRenewActiveSuccess,
        tone: .success,
      ),
    );
  }

  /// Przywraca zarchiwizowanego pracownika.
  Future<void> _handleRestoreUser(
    BuildContext context,
    BhpUserIssuesCubit cubit,
  ) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.bhpPreviewRestoreAction,
      message: context.l10n.bhpPreviewRestoreEmployeeMessage,
      confirmLabel: context.l10n.bhpPreviewRestoreAction,
      tone: .warning,
    );

    if (!context.mounted || !confirmed) {
      return;
    }

    final repository = context.read<BhpUsersRepository>();
    final result = await repository.unarchiveUser(_currentUser.id);

    if (!context.mounted) {
      return;
    }

    result.fold(
      (error) => AppToast.show(
        context,
        message: error.message,
        tone: .error,
      ),
      (updatedUser) {
        AppToast.show(
          context,
          message: context.l10n.bhpPreviewRestoredMessage(updatedUser.fullName),
          tone: .success,
        );
        _updateCurrentUser(updatedUser);
        unawaited(cubit.load());
      },
    );
  }

  /// Trwale usuwa pracownika z bazy danych.
  Future<void> _handleForceDeleteUser(
    BuildContext context,
    BhpUserIssuesCubit cubit,
  ) async {
    final deleted = await showForceDeleteBhpUserModal(
      context,
      user: _currentUser,
    );
    if (!context.mounted || deleted != true) {
      return;
    }

    AppToast.show(
      context,
      message: context.l10n.bhpPreviewForceDeletedMessage(
        _currentUser.fullName,
      ),
      tone: .success,
    );
    Navigator.of(context).pop();
  }
}
