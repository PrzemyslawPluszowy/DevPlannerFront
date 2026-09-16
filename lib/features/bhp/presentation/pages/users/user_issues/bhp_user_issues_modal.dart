import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/delete_user/delete_user_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/edit_user/edit_user_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issues_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issues_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/add_user_issue_modal.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/close_user_issue_modal.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/delete_issue_equivalent_modal.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/edit_user_issue_field_modal.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/position_standard/user_position_standard_modal.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/register_issue_equivalent_modal.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/repeat_user_issues_bulk_modal.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/user_issue_info_modal.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/print/bhp_user_issues_pdf_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_banner.dart';
import 'package:ready_next/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

part 'actions/bhp_user_issues_modal_actions.part.dart';
part 'print/bhp_user_issues_modal_print.part.dart';
part 'styles/bhp_user_issues_modal_styles.part.dart';
part 'table/bhp_user_issues_modal_columns.part.dart';
part 'widgets/bhp_user_issues_modal_widgets.part.dart';

/// Otwiera panel boczny z historią wydań BHP pracownika.
Future<void> showBhpUserIssuesModal(
  BuildContext context, {
  required GetBhpUserListItem user,
}) {
  final repository = context.read<BhpUsersRepository>();
  final equipmentRepository = context.read<BhpEquipmentRepository>();
  final positionsRepository = context.read<BhpPositionsRepository>();

  return AppModalSheet.showSideSheet<void>(
    context,
    title: context.l10n.bhpUserIssuesTitle,
    subtitle: context.l10n.bhpUserIssuesSubtitle(user.fullName),
    size: AppModalSheetSize.large,
    width: 1850,
    scrollBody: false,
    body: RepositoryProvider.value(
      value: repository,
      child: RepositoryProvider.value(
        value: equipmentRepository,
        child: RepositoryProvider.value(
          value: positionsRepository,
          child: BlocProvider(
            create: (_) {
              final cubit = BhpUserIssuesCubit(
                userId: user.id,
                repository: repository,
              );
              unawaited(cubit.load());
              return cubit;
            },
            child: _BhpUserIssuesModalBody(user: user),
          ),
        ),
      ),
    ),
  );
}

/// Treść modala wydań BHP.
class _BhpUserIssuesModalBody extends StatefulWidget {
  /// Tworzy treść modala wydań.
  const _BhpUserIssuesModalBody({required this.user});

  /// Pracownik, dla którego pokazujemy wydania.
  final GetBhpUserListItem user;

  @override
  State<_BhpUserIssuesModalBody> createState() =>
      _BhpUserIssuesModalBodyState();
}

/// Stan modala wydań pracownika BHP.
class _BhpUserIssuesModalBodyState extends State<_BhpUserIssuesModalBody> {
  late GetBhpUserListItem _currentUser;
  String? _userPositionName;
  BhpUserIssuesView _selectedView = BhpUserIssuesView.aktywne;
  final Set<int> _selectedBulkRenewIssueIds = <int>{};
  bool _didEditBulkRenewSelection = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _userPositionName = widget.user.stanowiskoNazwa;
  }

  void _updateCurrentUser(GetBhpUserListItem user) {
    setState(() {
      _currentUser = user;
      _userPositionName = user.stanowiskoNazwa;
    });
  }

  void _setSelectedView(BhpUserIssuesView view) {
    setState(() {
      _selectedView = view;
    });
  }

  void _syncBulkRenewSelection(List<GetBhpUserIssue> activeItems) {
    if (!_didEditBulkRenewSelection) {
      _selectedBulkRenewIssueIds
        ..clear()
        ..addAll(_buildAutoSelectedBulkRenewIssueIds(activeItems));
      return;
    }

    final activeIds = activeItems.map((item) => item.id).toSet();
    _selectedBulkRenewIssueIds.removeWhere((id) => !activeIds.contains(id));
    final sanitizedSelection = _sanitizeBulkRenewSelection(
      activeItems,
      _selectedBulkRenewIssueIds,
    );
    _selectedBulkRenewIssueIds
      ..clear()
      ..addAll(sanitizedSelection);
  }

  Set<int> _buildAutoSelectedBulkRenewIssueIds(
    List<GetBhpUserIssue> activeItems,
  ) {
    return _sanitizeBulkRenewSelection(
      activeItems,
      activeItems
          .where((item) => (_getDueDateDifference(item) ?? 1) < 0)
          .map((item) => item.id)
          .toSet(),
    );
  }

  Set<int> _sanitizeBulkRenewSelection(
    List<GetBhpUserIssue> activeItems,
    Set<int> selectedIds,
  ) {
    final byId = {
      for (final item in activeItems) item.id: item,
    };
    final selectedItems =
        selectedIds
            .map((id) => byId[id])
            .whereType<GetBhpUserIssue>()
            .toList(growable: false)
          ..sort(_compareBulkRenewIssues);
    final keptIds = <int>{};
    final usedCardIds = <int>{};

    for (final item in selectedItems) {
      final cardId = item.kartaWyposazeniaId;
      if (cardId != null && usedCardIds.contains(cardId)) {
        continue;
      }

      keptIds.add(item.id);
      if (cardId != null) {
        usedCardIds.add(cardId);
      }
    }

    return keptIds;
  }

  List<GetBhpUserIssue> _resolveSelectedBulkRenewIssues(
    List<GetBhpUserIssue> activeItems,
  ) {
    final selectedIds = _sanitizeBulkRenewSelection(
      activeItems,
      _selectedBulkRenewIssueIds,
    );

    return activeItems
        .where((issue) => selectedIds.contains(issue.id))
        .toList(growable: false)
      ..sort(_compareBulkRenewIssues);
  }

  int _compareBulkRenewIssues(GetBhpUserIssue left, GetBhpUserIssue right) {
    final leftCardId = left.kartaWyposazeniaId ?? 1 << 30;
    final rightCardId = right.kartaWyposazeniaId ?? 1 << 30;
    final byCard = leftCardId.compareTo(rightCardId);
    if (byCard != 0) {
      return byCard;
    }

    final byDueDate = (left.dueDate ?? '').compareTo(right.dueDate ?? '');
    if (byDueDate != 0) {
      return byDueDate;
    }

    return left.id.compareTo(right.id);
  }

  void _toggleBulkRenewIssueSelection(
    GetBhpUserIssue issue,
    bool isSelected,
    List<GetBhpUserIssue> activeItems,
  ) {
    setState(() {
      _didEditBulkRenewSelection = true;
      if (isSelected) {
        final cardId = issue.kartaWyposazeniaId;
        if (cardId != null) {
          _selectedBulkRenewIssueIds.removeWhere((selectedId) {
            GetBhpUserIssue? selectedIssue;
            for (final item in activeItems) {
              if (item.id == selectedId) {
                selectedIssue = item;
                break;
              }
            }
            return selectedIssue?.kartaWyposazeniaId == cardId;
          });
        }
        _selectedBulkRenewIssueIds.add(issue.id);
      } else {
        _selectedBulkRenewIssueIds.remove(issue.id);
      }

      final sanitized = _sanitizeBulkRenewSelection(
        activeItems,
        _selectedBulkRenewIssueIds,
      );
      _selectedBulkRenewIssueIds
        ..clear()
        ..addAll(sanitized);
    });
  }

  void _resetBulkRenewSelection() {
    setState(() {
      _didEditBulkRenewSelection = false;
      _selectedBulkRenewIssueIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    return BlocBuilder<BhpUserIssuesCubit, BhpUserIssuesState>(
      builder: (context, state) {
        final cubit = context.read<BhpUserIssuesCubit>();
        if (state case BhpUserIssuesSuccess(:final detail)) {
          _syncBulkRenewSelection(detail.wydaniaAktywne);
        }

        return AppModuleSection(
          title: intl.bhpUserIssuesTitle,
          subtitle: intl.bhpUserIssuesSectionSubtitle,
          actions: _buildModuleActions(context, state, cubit),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              if (_isArchivedUser(_currentUser)) ...[
                Padding(
                  padding: const .only(bottom: Sizes.p12),
                  child: AppBanner(
                    tone: .warning,
                    title: context.l10n.bhpStatusArchived,
                    message: context.l10n.bhpUserIssuesReadOnlyArchivedMessage,
                    trailing: Row(
                      mainAxisSize: .min,
                      children: [
                        AppActionButton.filled(
                          label: context.l10n.bhpPreviewRestoreAction,
                          icon: Icons.restore_from_trash_rounded,
                          onPressed: () => _handleRestoreUser(context, cubit),
                        ),
                        Gaps.w8,
                        AppActionButton.filled(
                          label: context.l10n.bhpPreviewForceDeleteAction,
                          icon: Icons.delete_forever_rounded,
                          tone: .danger,
                          onPressed: () =>
                              _handleForceDeleteUser(context, cubit),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              _buildUserSummary(context),
              Expanded(
                child: _buildStateContent(
                  context,
                  state: state,
                  cubit: cubit,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widok tabeli w modalu wydań pracownika.
enum BhpUserIssuesView { aktywne, historia, operacje, standard }
