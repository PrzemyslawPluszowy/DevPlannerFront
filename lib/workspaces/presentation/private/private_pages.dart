import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/private/cubit/personal_section_cubit.dart';
import 'package:devplanner/workspaces/presentation/private/my_tasks_filters.dart';
import 'package:devplanner/workspaces/presentation/private/my_tasks_filters_dialog.dart';
import 'package:devplanner/workspaces/presentation/private/private_section_view.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  final ValueNotifier<MyTasksFilters> _filters = ValueNotifier(
    const MyTasksFilters(),
  );

  PersonalSectionKind get _kind => widget.section == 'files'
      ? PersonalSectionKind.files
      : PersonalSectionKind.tasks;

  @override
  Widget build(BuildContext context) {
    final kind = _kind;
    if (kind == PersonalSectionKind.files) {
      return StorageShellPage(initialScope: widget.initialStorageScope);
    }
    return ValueListenableBuilder(
      valueListenable: _filters,
      builder: (context, filters, _) => Scaffold(
        appBar: AppBar(
          title: Text(kind.title),
          actions: [
            if (kind == PersonalSectionKind.tasks)
              IconButton(
                tooltip: context.l10n.myTasksFilter,
                onPressed: _showFilters,
                icon: Badge(
                  isLabelVisible:
                      filters.status != null ||
                      filters.priority != null ||
                      filters.involvement != null ||
                      filters.dueFromUtc != null ||
                      filters.dueToUtc != null,
                  child: const Icon(Symbols.filter_list_rounded),
                ),
              ),
          ],
        ),
        body: BlocProvider(
          key: ValueKey([
            filters.status,
            filters.priority,
            filters.involvement,
            filters.dueFromUtc,
            filters.dueToUtc,
          ]),
          create: (_) {
            final cubit = PersonalSectionCubit.myTasks(
              repository: context.read<TaskViewRepository>(),
              status: filters.status,
              priority: filters.priority,
              involvement: filters.involvement,
              dueFromUtc: filters.dueFromUtc,
              dueToUtc: filters.dueToUtc,
            );
            unawaited(cubit.load());
            return cubit;
          },
          child: PersonalSectionView(kind: kind),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _filters.dispose();
    super.dispose();
  }

  Future<void> _showFilters() async {
    final filters = await showDialog<MyTasksFilters>(
      context: context,
      builder: (_) => MyTasksFiltersDialog(
        initial: _filters.value,
      ),
    );
    if (filters == null || !mounted) return;
    _filters.value = filters;
  }
}
