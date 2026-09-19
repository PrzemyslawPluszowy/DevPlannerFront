import 'package:devplanner/shared/presentation/widgets/app_search_text_field.dart';
import 'package:devplanner/shared/presentation/widgets/app_shimmer.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/cubit/workspaces_home_state.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/widgets/workspace_directory_empty_state.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/widgets/workspace_directory_loaded_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Panel boczny katalogu Workspaces z lokalnym filtrem i stanami katalogu.
class WorkspaceDirectoryMenu extends StatefulWidget {
  const WorkspaceDirectoryMenu({super.key});

  @override
  State<WorkspaceDirectoryMenu> createState() => _WorkspaceDirectoryMenuState();
}

class _WorkspaceDirectoryMenuState extends State<WorkspaceDirectoryMenu> {
  final _searchQuery = ValueNotifier<String>('');

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSearchTextField(
            hintText: 'Szukaj w przestrzeniach...',
            onChanged: (value) =>
                _searchQuery.value = value.trim().toLowerCase(),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: _searchQuery,
              builder: (context, searchQuery, _) {
                return SingleChildScrollView(
                  child: BlocBuilder<WorkspacesHomeCubit, WorkspacesHomeState>(
                    builder: (context, state) => switch (state) {
                      WorkspacesHomeInitial() || WorkspacesHomeLoading() =>
                        const AppShimmerMenu(itemCount: 6),
                      WorkspacesHomeFailure(:final message) =>
                        _WorkspaceDirectoryMessage(message: message),
                      WorkspacesHomeEmpty() =>
                        const WorkspaceDirectoryEmptyState(),
                      WorkspacesHomeForbidden(:final message) ||
                      WorkspacesHomeUnauthorized(
                        :final message,
                      ) => _WorkspaceDirectoryMessage(message: message),
                      WorkspacesHomeLoaded(:final items, :final hiddenItems) =>
                        WorkspaceDirectoryLoadedContent(
                          items: items,
                          hiddenItems: hiddenItems,
                          searchQuery: searchQuery,
                        ),
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceDirectoryMessage extends StatelessWidget {
  const _WorkspaceDirectoryMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(message),
    );
  }
}
