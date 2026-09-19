import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lokalny Cubit jednego rozwiniętego workspace’u.
///
/// Nie pobiera projektów globalnie. Dzięki temu duże katalogi nie wykonują
/// lawiny żądań przy starcie aplikacji, a błąd jest przypięty do właściwego
/// węzła menu.
final class WorkspaceProjectsCubit extends Cubit<WorkspaceProjectsState> {
  WorkspaceProjectsCubit({
    required this._gateway,
    required this.workspaceId,
  }) : super(const WorkspaceProjectsInitial());

  final ProjectsGateway _gateway;
  final String workspaceId;

  Future<void> load({bool force = false}) async {
    if (isClosed) return;
    if (!force &&
        (state is WorkspaceProjectsLoading ||
            state is WorkspaceProjectsReady)) {
      return;
    }
    emit(const WorkspaceProjectsLoading());
    try {
      final items = await _gateway.listProjects(workspaceId);
      if (isClosed) return;
      emit(
        items.isEmpty
            ? const WorkspaceProjectsEmpty()
            : WorkspaceProjectsReady(List.unmodifiable(items)),
      );
    } on ProjectsGatewayException catch (error) {
      if (isClosed) return;
      emit(
        WorkspaceProjectsFailure(
          reason: error.reason,
          statusCode: error.statusCode,
          backendCode: error.backendCode,
          message: error.message,
        ),
      );
    } on Exception catch (_) {
      if (isClosed) return;
      emit(
        const WorkspaceProjectsFailure(
          reason: ProjectsFailureReason.requestFailed,
        ),
      );
    }
  }
}
