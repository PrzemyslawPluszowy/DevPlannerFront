import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/bhp_user_issues_modal.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';

/// Otwiera panel boczny z aktywnymi pracownikami przypisanymi do stanowiska.
Future<void> showBhpPositionUsersModal(
  BuildContext context, {
  required GetBhpPositionListItem position,
}) {
  return AppModalSheet.showSideSheet<void>(
    context,
    title: 'Pracownicy stanowiska',
    subtitle: position.nazwa,
    width: 1080,
    scrollBody: false,
    body: _BhpPositionUsersModalBody(position: position),
  );
}

class _BhpPositionUsersModalBody extends StatefulWidget {
  const _BhpPositionUsersModalBody({required this.position});

  final GetBhpPositionListItem position;

  @override
  State<_BhpPositionUsersModalBody> createState() =>
      _BhpPositionUsersModalBodyState();
}

class _BhpPositionUsersModalBodyState
    extends State<_BhpPositionUsersModalBody> {
  List<GetBhpUserListItem>? _users;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    unawaited(_loadUsers());
  }

  Future<void> _loadUsers() async {
    final repository = context.read<BhpPositionsRepository>();
    final result = await repository.getPositionUsers(
      widget.position.id,
      active: true,
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (error) => setState(() => _errorMessage = error.message),
      (users) => setState(() => _users = users),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = _users;
    final errorMessage = _errorMessage;

    return AppModuleSection(
      title: 'Aktywni pracownicy',
      subtitle:
          'Lista aktywnych pracowników przypisanych do stanowiska ${widget.position.nazwa}.',
      child: switch ((users, errorMessage)) {
        (_, final String message) => Center(
          child: AppEmptyState.error(
            title: 'Nie udało się pobrać pracowników',
            message: message,
          ),
        ),
        (null, _) => const Center(child: AppSpinner()),
        (final List<GetBhpUserListItem> rows, _) => AppSectionCard(
          expandChild: true,
          child: rows.isEmpty
              ? AppEmptyState.noData(
                  title: 'Brak aktywnych pracowników',
                  message:
                      'Do tego stanowiska nie są obecnie przypisani aktywni pracownicy.',
                )
              : AppSimpleTable<GetBhpUserListItem>(
                  rows: rows,
                  height: null,
                  stateId: 'bhp_position_users_${widget.position.id}',
                  showSearch: true,
                  searchHintText: context.l10n.bhpUsersSearchHint,
                  onRowTap: (context, row, sourceIndex) =>
                      showBhpUserIssuesModal(context, user: row),
                  searchMatcher: (row, query) {
                    final phrase = query.toLowerCase();
                    return row.fullName.toLowerCase().contains(phrase) ||
                        (row.nrEwidencyjny ?? '').toLowerCase().contains(
                          phrase,
                        ) ||
                        (row.pesel ?? '').toLowerCase().contains(phrase) ||
                        (row.numerTelefonu ?? '').toLowerCase().contains(
                          phrase,
                        );
                  },
                  columns: [
                    AppSimpleTableColumn(
                      label: 'Lp.',
                      width: 72,
                      sortable: false,
                      numeric: true,
                      indexedCellBuilder:
                          (context, row, sourceIndex, visibleIndex) =>
                              Text('${visibleIndex + 1}'),
                      cellBuilder: (context, row) => const SizedBox.shrink(),
                    ),
                    AppSimpleTableColumn(
                      label: 'Pracownik',
                      width: 260,
                      sortValue: (row) => row.fullName.toLowerCase(),
                      cellBuilder: (context, row) => Text(row.fullName),
                    ),
                    AppSimpleTableColumn(
                      label: 'Nr ewid.',
                      width: 120,
                      sortValue: (row) => row.nrEwidencyjny ?? '',
                      cellBuilder: (context, row) =>
                          Text(row.nrEwidencyjny ?? '—'),
                    ),
                    AppSimpleTableColumn(
                      label: 'PESEL',
                      width: 150,
                      sortValue: (row) => row.pesel ?? '',
                      cellBuilder: (context, row) => Text(row.pesel ?? '—'),
                    ),
                    AppSimpleTableColumn(
                      label: 'Telefon',
                      width: 150,
                      sortValue: (row) => row.numerTelefonu ?? '',
                      cellBuilder: (context, row) =>
                          Text(row.numerTelefonu ?? '—'),
                    ),
                    AppSimpleTableColumn(
                      label: context.l10n.bhpTableStatus,
                      width: 120,
                      sortable: false,
                      cellBuilder: (context, row) => AppStatusBadge(
                        label: context.l10n.bhpStatusActive,
                        tone: AppStatusBadgeTone.success,
                        icon: Icons.check_circle_outline_rounded,
                      ),
                    ),
                  ],
                ),
        ),
      },
    );
  }
}
