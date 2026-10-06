import 'package:devplanner/workspaces/domain/models/project_people_request.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_people_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Jeden katalog dla właściwości i obserwatorów; nie zależy od includedUsers
/// ostatniej odpowiedzi zapisu zadania.
final class TaskDetailPeopleScope extends StatefulWidget {
  const TaskDetailPeopleScope({required this.child, super.key});
  final Widget child;

  static ProjectPeopleCubit? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PeopleData>()?.cubit;

  @override
  State<TaskDetailPeopleScope> createState() => _TaskDetailPeopleScopeState();
}

final class _TaskDetailPeopleScopeState extends State<TaskDetailPeopleScope> {
  ProjectPeopleCubit? _cubit;
  TaskDetailsCubit? _source;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final source = context.watch<TaskDetailsCubit>();
    final repository = context.watch<ProjectMemberProfilesRepository?>();
    if (identical(_source, source) &&
        identical(_cubit?.request.repository, repository)) {
      return;
    }
    unawaited(_cubit?.close());
    _source = source;
    _cubit = repository == null
        ? null
        : ProjectPeopleCubit(
            ProjectPeopleRequest(
              repository: repository,
              workspaceId: source.workspaceId,
              projectId: source.projectId,
              projectName: '',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = _cubit;
    if (cubit == null) return widget.child;
    return BlocBuilder<ProjectPeopleCubit, ProjectPeopleState>(
      bloc: cubit,
      builder: (context, state) => _PeopleData(
        cubit: cubit,
        state: state,
        child: Column(
          children: [
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.taskDetailsPeopleLoadFailed,
                        style: context.tasksTheme.metaText,
                      ),
                    ),
                    TextButton(
                      onPressed: () => unawaited(cubit.refresh()),
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit?.close());
    super.dispose();
  }
}

final class _PeopleData extends InheritedWidget {
  const _PeopleData({
    required this.cubit,
    required this.state,
    required super.child,
  });
  final ProjectPeopleCubit cubit;
  final ProjectPeopleState state;
  @override
  bool updateShouldNotify(_PeopleData oldWidget) =>
      !identical(oldWidget.state, state) || !identical(oldWidget.cubit, cubit);
}
