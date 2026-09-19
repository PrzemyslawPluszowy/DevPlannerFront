import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';

/// Bazowy stan jednej, lokalnej gałęzi zasobów projektu.
sealed class ProjectResourcesState {
  const ProjectResourcesState();
}

final class ProjectResourcesInitial extends ProjectResourcesState {
  const ProjectResourcesInitial();
}

final class ProjectResourcesLoading extends ProjectResourcesState {
  const ProjectResourcesLoading();
}

final class ProjectResourcesReady extends ProjectResourcesState {
  const ProjectResourcesReady(this.items);

  final List<ProjectResourceListItem> items;
}

final class ProjectResourcesEmpty extends ProjectResourcesState {
  const ProjectResourcesEmpty();
}

final class ProjectResourcesFailure extends ProjectResourcesState {
  const ProjectResourcesFailure({required this.message, this.backendCode});

  final String message;
  final String? backendCode;
}
