import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_list_api.dart';
import 'package:devplanner/workspaces/data/projects/repositories/projects_gateway_impl.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Transport extends DevPlannerHttpTransport {
  _Transport(this.response) : super(dio: Dio());

  final DevPlannerHttpResponse response;
  DevPlannerHttpRequest? request;

  @override
  Future<DevPlannerHttpResponse> execute(DevPlannerHttpRequest request) async {
    this.request = request;
    return response;
  }
}

/// Rejestrująca atrapa portu listy projektów; zapisuje cały filtr zapytania.
final class _Api implements ProjectsListApi {
  _Api(this.response);

  final DevPlannerHttpResponse response;
  String? workspaceId;
  ProjectListState? state;
  ProjectListVisibility? visibility;
  bool? includeHidden;

  @override
  Future<DevPlannerHttpResponse> listProjects({
    required String workspaceId,
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    bool? includeHidden,
  }) async {
    this.workspaceId = workspaceId;
    this.state = state;
    this.visibility = visibility;
    this.includeHidden = includeHidden;
    return response;
  }
}

Map<String, Object?> _projectJson({
  String workspaceId = 'workspace-1',
  String id = 'project-1',
}) => {
  'id': id,
  'workspaceId': workspaceId,
  'name': 'Alpha',
  'description': 'Opis',
  'icon': null,
  'primaryColor': '#2A9D8F',
  'visibility': 'Shared',
  'status': 'Active',
  'myRole': 'Member',
  'isPinned': true,
  'sortPosition': 2,
  'isHidden': false,
  'archivedAtUtc': null,
  'version': 7,
  'capabilities': {
    'canManage': true,
    'canArchive': true,
    'canDelete': false,
    'canManageMembers': true,
    'canCreateTemplate': false,
    'canLeave': true,
    'canTransfer': false,
  },
};

void main() {
  test('API wysyła dokładne wartości state i visibility w query', () async {
    final transport = _Transport(
      const DevPlannerHttpResponse(statusCode: 200, body: <Object?>[]),
    );
    final api = DevPlannerProjectsListApi(transport: transport);

    await api.listProjects(
      workspaceId: 'workspace-7',
      state: ProjectListState.archived,
      visibility: ProjectListVisibility.hidden,
    );

    expect(transport.request?.path, '/api/v1/workspaces/workspace-7/projects/');
    // Wartości są tokenami backendu, a nie nazwami elementów enuma w Dartcie.
    expect(transport.request?.query, {
      'state': 'archived',
      'visibility': 'hidden',
    });
  });

  test('API mapuje przestarzały includeHidden na visibility=all', () async {
    final transport = _Transport(
      const DevPlannerHttpResponse(statusCode: 200, body: <Object?>[]),
    );
    final api = DevPlannerProjectsListApi(transport: transport);

    await api.listProjects(workspaceId: 'workspace-7', includeHidden: true);

    expect(transport.request?.query, {
      'state': 'active',
      'visibility': 'all',
    });
  });

  test('jawna visibility ma pierwszeństwo nad includeHidden', () async {
    final transport = _Transport(
      const DevPlannerHttpResponse(statusCode: 200, body: <Object?>[]),
    );
    final api = DevPlannerProjectsListApi(transport: transport);

    await api.listProjects(
      workspaceId: 'workspace-7',
      visibility: ProjectListVisibility.hidden,
      includeHidden: true,
    );

    expect(transport.request?.query['visibility'], 'hidden');
  });

  test('listuje tylko wskazany workspace i mapuje lokalny DTO', () async {
    final api = _Api(
      DevPlannerHttpResponse(statusCode: 200, body: [_projectJson()]),
    );
    final gateway = ProjectsGatewayImpl(api: api);

    final projects = await gateway.listProjects(
      'workspace-1',
      state: ProjectListState.all,
      visibility: ProjectListVisibility.hidden,
    );

    expect(api.workspaceId, 'workspace-1');
    expect(api.state, ProjectListState.all);
    expect(api.visibility, ProjectListVisibility.hidden);
    expect(projects.single.id, 'project-1');
    expect(projects.single.workspaceId, 'workspace-1');
    expect(projects.single.isPinned, isTrue);
  });

  test('gateway przekazuje przestarzały includeHidden jako alias', () async {
    final api = _Api(
      DevPlannerHttpResponse(statusCode: 200, body: [_projectJson()]),
    );
    final gateway = ProjectsGatewayImpl(api: api);

    await gateway.listProjects('workspace-1', includeHidden: true);

    expect(api.includeHidden, isTrue);
    expect(api.state, ProjectListState.active);
  });

  test('mapuje 403 na typed forbidden bez udawania pustej listy', () async {
    final gateway = ProjectsGatewayImpl(
      api: _Api(
        const DevPlannerHttpResponse(
          statusCode: 403,
          body: {
            'code': 'workspace.forbidden',
            'message': 'Brak dostępu.',
          },
        ),
      ),
    );

    expect(
      () => gateway.listProjects('workspace-1'),
      throwsA(
        isA<ProjectsGatewayException>().having(
          (error) => error.reason,
          'reason',
          ProjectsFailureReason.forbidden,
        ),
      ),
    );
  });

  test('mapuje 404 na typed notFound z kodem backendu', () async {
    final gateway = ProjectsGatewayImpl(
      api: _Api(
        const DevPlannerHttpResponse(
          statusCode: 404,
          body: {'code': 'workspace.not_found'},
        ),
      ),
    );

    await expectLater(
      gateway.listProjects('workspace-missing'),
      throwsA(
        isA<ProjectsGatewayException>()
            .having(
              (error) => error.reason,
              'reason',
              ProjectsFailureReason.notFound,
            )
            .having(
              (error) => error.backendCode,
              'backendCode',
              'workspace.not_found',
            ),
      ),
    );
  });

  test('odrzuca odpowiedź bez prawdziwych danych projektu', () async {
    final gateway = ProjectsGatewayImpl(
      api: _Api(
        const DevPlannerHttpResponse(
          statusCode: 200,
          body: <Object?>[<String, Object?>{}],
        ),
      ),
    );

    await expectLater(
      gateway.listProjects('workspace-1'),
      throwsA(
        isA<ProjectsGatewayException>().having(
          (error) => error.reason,
          'reason',
          ProjectsFailureReason.invalidResponse,
        ),
      ),
    );
  });

  test(
    'odrzuca element spoza żądanego workspace zamiast mieszać gałęzie',
    () async {
      final gateway = ProjectsGatewayImpl(
        api: _Api(
          DevPlannerHttpResponse(
            statusCode: 200,
            body: [_projectJson(workspaceId: 'workspace-other')],
          ),
        ),
      );

      await expectLater(
        gateway.listProjects('workspace-1'),
        throwsA(
          isA<ProjectsGatewayException>().having(
            (error) => error.reason,
            'reason',
            ProjectsFailureReason.invalidResponse,
          ),
        ),
      );
    },
  );
}
