import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_response.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/admin/tabs/templates/cubit/project_templates_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProjectTemplatesRepository extends Mock
    implements ProjectTemplatesRepository {}

void main() {
  late _MockProjectTemplatesRepository repository;
  late ProjectTemplatesCubit cubit;

  const workspaceId = 'ws-1';
  const projectId = 'proj-1';
  final template = ProjectTemplateResponse(
    id: 'tmpl-1',
    name: 'Szablon Marketing',
    updatedAtUtc: DateTime.now(),
    version: 1,
  );

  setUp(() {
    repository = _MockProjectTemplatesRepository();
    cubit = ProjectTemplatesCubit(
      workspaceId: workspaceId,
      projectId: projectId,
      repository: repository,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('load pobiera listę szablonów', () async {
    when(
      () => repository.listTemplates(workspaceId),
    ).thenAnswer((_) async => Right([template]));

    await cubit.load();

    expect(cubit.state, isA<ProjectTemplatesReady>());
    final ready = cubit.state as ProjectTemplatesReady;
    expect(ready.templates.length, 1);
    expect(ready.templates.first.name, 'Szablon Marketing');
  });

  test('getTemplateDetails pobiera szczegóły szablonu', () async {
    final detailsResponse = ProjectTemplateDetailsResponse(
      id: 'tmpl-1',
      name: 'Szablon Marketing',
      status: 'Active',
      visibility: 'Shared',
      workflow: [],
      transitions: [],
      labels: [],
      customFields: [],
      tasks: [],
      updatedAtUtc: DateTime.now(),
      version: 1,
    );

    when(
      () => repository.getTemplateDetails(
        workspaceId: workspaceId,
        templateId: 'tmpl-1',
      ),
    ).thenAnswer((_) async => Right(detailsResponse));

    final details = await cubit.getTemplateDetails('tmpl-1');

    expect(details, isNotNull);
    expect(details!.id, 'tmpl-1');
    expect(details.name, 'Szablon Marketing');
  });

  test('createTemplateFromCurrentProject dodaje szablon do listy i emituje actionSuccess', () async {
    when(
      () => repository.listTemplates(workspaceId),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => repository.createTemplateFromProject(
        workspaceId: workspaceId,
        projectId: projectId,
        name: 'Nowy Szablon',
      ),
    ).thenAnswer((_) async => Right(template));

    await cubit.load();
    await cubit.createTemplateFromCurrentProject('Nowy Szablon');

    final ready = cubit.state as ProjectTemplatesReady;
    expect(ready.templates.length, 1);
    expect(ready.templates.first.id, 'tmpl-1');
    expect(ready.actionSuccess, ProjectTemplateActionType.created);
  });

  test(
    'deleteTemplate usuwa szablon z listy i emituje actionSuccess',
    () async {
      when(
        () => repository.listTemplates(workspaceId),
      ).thenAnswer((_) async => Right([template]));

      when(
        () => repository.deleteTemplate(
          workspaceId: workspaceId,
          templateId: 'tmpl-1',
          expectedVersion: 1,
        ),
      ).thenAnswer((_) async => const Right(null));

      await cubit.load();
      await cubit.deleteTemplate(templateId: 'tmpl-1', expectedVersion: 1);

      final ready = cubit.state as ProjectTemplatesReady;
      expect(ready.templates.isEmpty, true);
      expect(ready.actionSuccess, ProjectTemplateActionType.deleted);
    },
  );

  test(
    'applyTemplate tworzy nowy projekt z szablonu i emituje actionSuccess',
    () async {
      when(
        () => repository.listTemplates(workspaceId),
      ).thenAnswer((_) async => Right([template]));

      final applyResponse = ApplyProjectTemplateResponse(
        project: ProjectResponse(
          id: 'new-proj-1',
          workspaceId: workspaceId,
          createdByUserId: 'user-1',
          name: 'Nowy Projekt',
          visibility: ProjectVisibility.shared,
          status: ProjectStatus.active,
          createdAtUtc: DateTime.now(),
          updatedAtUtc: DateTime.now(),
        ),
        taskIdMappings: [],
        labelIdMappings: [],
        customFieldIdMappings: [],
      );

      when(
        () => repository.applyTemplate(
          workspaceId: workspaceId,
          templateId: 'tmpl-1',
          newProjectName: 'Nowy Projekt',
        ),
      ).thenAnswer((_) async => Right(applyResponse));

      await cubit.load();
      final result = await cubit.applyTemplate(
        templateId: 'tmpl-1',
        newProjectName: 'Nowy Projekt',
      );

      expect(result, isNotNull);
      expect(result!.project.name, 'Nowy Projekt');
      final ready = cubit.state as ProjectTemplatesReady;
      expect(ready.actionSuccess, ProjectTemplateActionType.applied);
    },
  );

  test('load emituje ProjectTemplatesFailure przy błędzie', () async {
    when(
      () => repository.listTemplates(workspaceId),
    ).thenAnswer(
      (_) async => const Left(
        ApiError(
          type: ApiErrorType.server,
          message: 'Błąd sieci',
        ),
      ),
    );

    await cubit.load();

    expect(cubit.state, isA<ProjectTemplatesFailure>());
    final failure = cubit.state as ProjectTemplatesFailure;
    expect(failure.message, 'Błąd sieci');
  });
}
