import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/repositories/task_view_repository.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_scope.dart';
import 'package:ready_next/workspaces/presentation/private/cubit/personal_section_cubit.dart';
import 'package:ready_next/workspaces/presentation/private/my_tasks_filters_dialog.dart';
import 'package:ready_next/workspaces/presentation/private/private_section_view.dart';
import 'package:ready_next/workspaces/presentation/storage/shell/storage_shell_page.dart';

/// Globalna prywatna przestrzeń użytkownika niezależna od workspace’u.
class PersonalSectionPage extends StatefulWidget {
  /// Tworzy ekran prywatnej sekcji z parametru URL.
  const PersonalSectionPage({
    required this.section,
    this.initialStorageScope = const StorageScope.personal(),
    super.key,
  });

  /// `tasks` albo `files`.
  final String section;

  /// Zakres odtworzony przez router dla ekranu plików.
  final StorageScope initialStorageScope;

  @override
  State<PersonalSectionPage> createState() => _PersonalSectionPageState();
}

class _PersonalSectionPageState extends State<PersonalSectionPage> {
  ProjectTaskStatus? _status;
  TaskPriority? _priority;
  TaskInvolvementFilter? _involvement;
  DateTime? _dueFromUtc;
  DateTime? _dueToUtc;

  PersonalSectionKind get _kind => widget.section == 'files'
      ? PersonalSectionKind.files
      : PersonalSectionKind.tasks;

  @override
  Widget build(BuildContext context) {
    final kind = _kind;
    if (kind == PersonalSectionKind.files) {
      return StorageShellPage(initialScope: widget.initialStorageScope);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(kind.title),
        actions: [
          if (kind == PersonalSectionKind.tasks)
            IconButton(
              tooltip: context.l10n.myTasksFilter,
              onPressed: _showFilters,
              icon: Badge(
                isLabelVisible:
                    _status != null ||
                    _priority != null ||
                    _involvement != null ||
                    _dueFromUtc != null ||
                    _dueToUtc != null,
                child: const Icon(Symbols.filter_list_rounded),
              ),
            ),
        ],
      ),
      body: BlocProvider(
        key: ValueKey([
          _status,
          _priority,
          _involvement,
          _dueFromUtc,
          _dueToUtc,
        ]),
        create: (_) {
          final cubit = PersonalSectionCubit(
            loader: kind == PersonalSectionKind.tasks
                ? (cursor) => _loadMyTasks(
                    context.read<TaskViewRepository>(),
                    cursor,
                    status: _status,
                    priority: _priority,
                    involvement: _involvement,
                    dueFromUtc: _dueFromUtc,
                    dueToUtc: _dueToUtc,
                  )
                : _unavailableLoader,
          );
          unawaited(cubit.load());
          return cubit;
        },
        child: PersonalSectionView(kind: kind),
      ),
    );
  }

  Future<void> _showFilters() async {
    final filters = await showDialog<MyTasksFilters>(
      context: context,
      builder: (_) => MyTasksFiltersDialog(
        initial: MyTasksFilters(
          status: _status,
          priority: _priority,
          involvement: _involvement,
          dueFromUtc: _dueFromUtc,
          dueToUtc: _dueToUtc,
        ),
      ),
    );
    if (filters == null || !mounted) return;
    setState(() {
      _status = filters.status;
      _priority = filters.priority;
      _involvement = filters.involvement;
      _dueFromUtc = filters.dueFromUtc;
      _dueToUtc = filters.dueToUtc;
    });
  }

  /// Pliki nie mają jeszcze globalnego endpointu prywatnej sekcji.
  static Future<PersonalSectionLoadResult> _unavailableLoader(
    String? cursor,
  ) async => const PersonalSectionContractUnavailable(
    message: 'Backend Workspaces udostępnia te dane wyłącznie w kontekście workspace’u. Globalny endpoint prywatny nie jest jeszcze dostępny.',
  );

  static Future<PersonalSectionLoadResult> _loadMyTasks(
    TaskViewRepository repository,
    String? cursor, {
    ProjectTaskStatus? status,
    TaskPriority? priority,
    TaskInvolvementFilter? involvement,
    DateTime? dueFromUtc,
    DateTime? dueToUtc,
  }) async {
    final result = await repository.listMyTasks(
      query: MyTasksQuery(
        cursor: cursor,
        status: myTasksStatusValue(status),
        priority: myTasksPriorityValue(priority),
        involvement: myTasksInvolvementValue(involvement),
        dueFromUtc: dueFromUtc,
        dueToUtc: dueToUtc,
      ),
    );
    return result.fold(
      (error) => PersonalSectionLoadFailure(
        message: error.message,
        code: error.backendCode?.toString(),
      ),
      (page) => PersonalSectionData(
        itemCount: page.items.length,
        tasks: page.items,
        nextCursor: page.nextCursor,
      ),
    );
  }
}
