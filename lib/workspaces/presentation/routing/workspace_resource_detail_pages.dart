import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/okr/models/okr_models.dart';
import 'package:ready_next/workspaces/domain/models/project_resource_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/okr_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_resource_access_cubit.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_resource_access_state.dart';
import 'package:ready_next/workspaces/presentation/okr/cubit/okr_objective_details_cubit.dart';
import 'package:ready_next/workspaces/presentation/okr/cubit/okr_objective_details_state.dart';
import 'package:ready_next/workspaces/shared/helpers/workspace_visual_helpers.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_feature_wrapper.dart';

part 'workspace_resource_detail_widgets.dart';
part 'workspace_resource_extra_pages.dart';

/// Ogólny punkt wejścia zasobu z parametrami URL.
class WorkspaceResourcePage extends StatelessWidget {
  const WorkspaceResourcePage({
    required this.workspaceId,
    this.projectId,
    this.resourceId,
    required this.resourceKind,
    super.key,
  });

  final String workspaceId;
  final String? projectId;
  final String? resourceId;
  final String resourceKind;

  @override
  Widget build(BuildContext context) => WorkspaceFeatureWrapper(
    title: _resourceTitle(resourceKind),
    icon: WorkspaceVisualHelpers.iconFor(resourceKind),
    subtitle: _resourceTitleText,
    isEmpty: true,
    emptyTitle: _resourceTitle(resourceKind),
    emptyMessage: 'Dane tego zasobu zostaną załadowane z dedykowanego modułu.',
  );

  String get _resourceTitleText => [
    resourceKind,
    ?projectId,
    ?resourceId,
  ].join(' · ');
}

/// Zasób projektu z własnym identyfikatorem, np. task albo whiteboard.
class WorkspaceProjectResourcePage extends StatelessWidget {
  const WorkspaceProjectResourcePage({
    required this.workspaceId,
    required this.projectId,
    required this.resourceKind,
    required this.resourceId,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String resourceKind;
  final String resourceId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = WorkspaceResourceAccessCubit(
        repository: context.read<ProjectResourcesRepository>(),
        workspaceId: workspaceId,
        projectId: projectId,
        resourceKind: resourceKind,
        resourceId: resourceId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child:
        BlocBuilder<WorkspaceResourceAccessCubit, WorkspaceResourceAccessState>(
          builder: (context, state) => WorkspaceFeatureWrapper(
            title: switch (state) {
              WorkspaceResourceAccessGranted(:final item) => item.title,
              _ => _resourceLabel,
            },
            icon: WorkspaceVisualHelpers.iconFor(resourceKind),
            subtitle: 'Zasób projektu',
            isLoading:
                state is WorkspaceResourceAccessInitial ||
                state is WorkspaceResourceAccessLoading,
            isEmpty: state is WorkspaceResourceAccessNotFound,
            emptyTitle: 'Nie znaleziono zasobu',
            emptyMessage: 'Ten element nie należy już do wybranego projektu.',
            errorMessage: switch (state) {
              WorkspaceResourceAccessFailure(
                :final message,
                :final backendCode,
              ) =>
                backendCode == null ? message : '$message (kod: $backendCode)',
              _ => null,
            },
            onRetry: () =>
                unawaited(context.read<WorkspaceResourceAccessCubit>().load()),
            child: switch (state) {
              WorkspaceResourceAccessGranted(:final item) => _ResourceDetails(
                item: item,
                workspaceId: workspaceId,
                projectId: projectId,
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        ),
  );

  String get _resourceLabel => '$resourceKind · $resourceId';
}

/// Jawny ekran nieznanej sekcji zamiast przyjmowania dowolnych segmentów URL.
class WorkspaceRouteNotFoundPage extends StatelessWidget {
  const WorkspaceRouteNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        'Nie znaleziono tej sekcji workspace’u.',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
  );
}

String _resourceTitle(String resourceKind) => switch (resourceKind) {
  'tasks' => 'Zadanie',
  'whiteboards' => 'Whiteboard',
  'wiki' => 'Wiki',
  'files' => 'Plik',
  _ => 'Zasób workspace',
};
