import 'package:bloc/bloc.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';

sealed class DevPlannerWorkspacesState {
  const DevPlannerWorkspacesState();
}

final class DevPlannerWorkspacesInitial extends DevPlannerWorkspacesState {
  const DevPlannerWorkspacesInitial();
}

final class DevPlannerWorkspacesLoading extends DevPlannerWorkspacesState {
  const DevPlannerWorkspacesLoading();
}

final class DevPlannerWorkspacesReady extends DevPlannerWorkspacesState {
  const DevPlannerWorkspacesReady(this.items);

  final List<WorkspaceSummary> items;
}

final class DevPlannerWorkspacesFailure extends DevPlannerWorkspacesState {
  const DevPlannerWorkspacesFailure({
    required this.reason,
    this.statusCode,
    this.backendCode,
  });

  final WorkspacesFailureReason reason;
  final int? statusCode;
  final String? backendCode;
}

final class DevPlannerWorkspacesCubit extends Cubit<DevPlannerWorkspacesState> {
  DevPlannerWorkspacesCubit({required this.gateway})
    : super(const DevPlannerWorkspacesInitial());

  final WorkspacesGateway? gateway;

  Future<void> load() async {
    final currentGateway = gateway;
    if (currentGateway == null) {
      emit(
        const DevPlannerWorkspacesFailure(
          reason: WorkspacesFailureReason.transportUnavailable,
        ),
      );
      return;
    }
    emit(const DevPlannerWorkspacesLoading());
    try {
      emit(DevPlannerWorkspacesReady(await currentGateway.listWorkspaces()));
    } on WorkspacesGatewayException catch (error) {
      emit(
        DevPlannerWorkspacesFailure(
          reason: error.reason,
          statusCode: error.statusCode,
          backendCode: error.backendCode,
        ),
      );
    } on Exception catch (_) {
      emit(
        const DevPlannerWorkspacesFailure(
          reason: WorkspacesFailureReason.requestFailed,
        ),
      );
    }
  }
}
