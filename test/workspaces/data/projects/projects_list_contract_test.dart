import 'package:devplanner/workspaces/data/projects/api/projects_api.dart';
import 'package:devplanner/workspaces/data/projects/mappers/project_list_item_mapper.dart';
import 'package:devplanner/workspaces/data/projects/payloads/update_project_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/update_project_user_preference_payload.dart';
import 'package:devplanner/workspaces/data/projects/repositories/projects_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/responses/devplanner_project_list_item_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_capabilities_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_list_item_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_user_preference_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Odpowiedź listy projektów dokładnie w kształcie kontraktu C#
/// (`ProjectListItemResponse`, camelCase).
Map<String, Object?> projectListJson({
  String id = 'project-1',
  bool isHidden = false,
  String? archivedAtUtc,
  int? version = 12,
  Map<String, Object?>? capabilities = const <String, Object?>{
    'canManage': true,
    'canArchive': true,
    'canDelete': false,
    'canManageMembers': true,
    'canCreateTemplate': false,
    'canLeave': true,
    'canTransfer': false,
  },
}) => <String, Object?>{
  'id': id,
  'workspaceId': 'workspace-1',
  'name': 'Alpha',
  'description': 'Opis',
  'icon': 'folder',
  'primaryColor': '#2563EB',
  'visibility': 'Private',
  'status': 'OnHold',
  'myRole': 'Admin',
  'isPinned': true,
  'sortPosition': 3,
  'isHidden': isHidden,
  'archivedAtUtc': archivedAtUtc,
  'version': version,
  'capabilities': capabilities,
};

final class _ProjectsApi extends Mock implements ProjectsApi {}

void main() {
  setUpAll(() {
    // Mocktail wymaga wartości zastępczej dla typów, na które łapiemy
    // argumenty `any()`/`captureAny()` w metodach Retrofit.
    registerFallbackValue(
      const UpdateProjectPayload(
        name: 'placeholder',
        visibility: ProjectVisibility.shared,
        status: ProjectStatus.active,
      ),
    );
    registerFallbackValue(
      const UpdateProjectUserPreferencePayload(
        isHidden: false,
        isPinned: false,
      ),
    );
  });

  group('kontrakt JSON listy projektów', () {
    test('czyta isHidden, version, capabilities i archivedAtUtc', () {
      final response = ProjectListItemResponse.fromJson(
        projectListJson(isHidden: true, archivedAtUtc: '2026-09-19T10:00:00Z'),
      );

      expect(response.isHidden, isTrue);
      expect(response.version, 12);
      expect(response.archivedAtUtc, DateTime.utc(2026, 9, 19, 10));
      expect(response.capabilities?.canManage, isTrue);
      expect(response.capabilities?.canArchive, isTrue);
      expect(response.capabilities?.canDelete, isFalse);
      expect(response.capabilities?.canManageMembers, isTrue);
      expect(response.capabilities?.canCreateTemplate, isFalse);
      expect(response.capabilities?.canLeave, isTrue);
      expect(response.capabilities?.canTransfer, isFalse);
    });

    test('starszy backend bez nowych pól nie wywraca mapowania', () {
      final json = projectListJson()
        ..remove('isHidden')
        ..remove('version')
        ..remove('capabilities')
        ..remove('archivedAtUtc');

      final response = ProjectListItemResponse.fromJson(json);

      expect(response.isHidden, isFalse);
      expect(response.version, isNull);
      expect(response.capabilities, isNull);
      expect(response.archivedAtUtc, isNull);
    });

    test(
      'częściowe capabilities degradują się do zachowania zachowawczego',
      () {
        final capabilities = ProjectCapabilitiesResponse.fromJson(
          const <String, Object?>{'canManage': true},
        );

        expect(capabilities.canManage, isTrue);
        expect(capabilities.canArchive, isFalse);
        expect(capabilities.canTransfer, isFalse);
      },
    );

    test('lokalny DTO listy przenosi nowe pola na model domenowy', () {
      final dto = DevPlannerProjectListItemResponse.fromJson(
        projectListJson(isHidden: true, archivedAtUtc: '2026-09-19T10:00:00Z'),
      );

      final project = ProjectListItemMapper.toDomain(dto);

      expect(project.isHidden, isTrue);
      expect(project.version, 12);
      expect(project.isArchived, isTrue);
      expect(project.capabilities?.canArchive, isTrue);
      expect(project.capabilities?.canTransfer, isFalse);
    });

    test('lokalny DTO bez capabilities zwraca null zamiast wyjątku', () {
      final json = projectListJson()
        ..remove('capabilities')
        ..remove('version')
        ..remove('isHidden');

      final dto = DevPlannerProjectListItemResponse.fromJson(json);
      final project = ProjectListItemMapper.toDomain(dto);

      expect(project.capabilities, isNull);
      expect(project.version, isNull);
      expect(project.isHidden, isFalse);
    });

    test('pełny widok projektu przenosi version i capabilities', () {
      final response = ProjectResponse.fromJson(projectResponseJson());

      final project = ProjectListItemMapper.fromProjectResponse(response);

      expect(project.version, 13);
      expect(project.capabilities, isNotNull);
      expect(project.capabilities?.canArchive, isTrue);
      expect(project.capabilities?.canManage, isFalse);
    });
  });

  group('zapytanie listy przez repozytorium', () {
    late _ProjectsApi api;
    late ProjectsRepositoryImpl repository;

    setUp(() {
      api = _ProjectsApi();
      repository = ProjectsRepositoryImpl(api: api);
    });

    void stubList(List<Map<String, Object?>> items) {
      when(
        () => api.listProjects(
          any(),
          state: any(named: 'state'),
          visibility: any(named: 'visibility'),
        ),
      ).thenAnswer(
        (_) async => items.map(ProjectListItemResponse.fromJson).toList(),
      );
    }

    test('wysyła dokładne tokeny state i visibility do backendu', () async {
      stubList(<Map<String, Object?>>[]);

      await repository.listProjects(
        'workspace-1',
        state: ProjectListState.archived,
        visibility: ProjectListVisibility.hidden,
      );

      verify(
        () => api.listProjects(
          'workspace-1',
          state: 'archived',
          visibility: 'hidden',
        ),
      ).called(1);
    });

    test(
      'includeHidden działa jako przestarzały alias do visibility=all',
      () async {
        stubList(<Map<String, Object?>>[]);

        await repository.listProjects('workspace-1', includeHidden: true);

        verify(
          () => api.listProjects(
            'workspace-1',
            state: 'active',
            visibility: 'all',
          ),
        ).called(1);
      },
    );

    test('mapuje capabilities i wersję z listy na model domenowy', () async {
      stubList(<Map<String, Object?>>[
        projectListJson(isHidden: true, archivedAtUtc: '2026-09-19T10:00:00Z'),
      ]);

      final result = await repository.listProjects('workspace-1');

      result.fold(
        (error) => fail('Nieoczekiwany błąd: $error'),
        (projects) {
          final project = projects.single;
          expect(project.isHidden, isTrue);
          expect(project.version, 12);
          expect(project.isArchived, isTrue);
          expect(
            project.capabilities?.canManage,
            isTrue,
            reason: 'capabilities pochodzą z serwera, a nie z roli',
          );
        },
      );
    });
  });

  group('expectedVersion w mutacjach', () {
    late _ProjectsApi api;
    late ProjectsRepositoryImpl repository;

    setUp(() {
      api = _ProjectsApi();
      repository = ProjectsRepositoryImpl(api: api);
      when(
        () => api.archiveProject(
          any(),
          any(),
          expectedVersion: any(named: 'expectedVersion'),
        ),
      ).thenAnswer(
        (_) async => ProjectResponse.fromJson(projectResponseJson()),
      );
      when(
        () => api.restoreProject(
          any(),
          any(),
          expectedVersion: any(named: 'expectedVersion'),
        ),
      ).thenAnswer(
        (_) async => ProjectResponse.fromJson(projectResponseJson()),
      );
      when(() => api.updateProject(any(), any(), any())).thenAnswer(
        (_) async => ProjectResponse.fromJson(projectResponseJson()),
      );
      when(() => api.updateProjectUserPreference(any(), any(), any()))
          .thenAnswer(
            (_) async => ProjectUserPreferenceResponse(
              projectId: 'project-1',
              isHidden: true,
              isPinned: false,
              updatedAtUtc: DateTime.utc(2026, 9, 19),
              version: 6,
            ),
          );
    });

    test('archiwizacja przekazuje wersję projektu', () async {
      await repository.archiveProject(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        expectedVersion: 12,
      );

      verify(
        () => api.archiveProject(
          'workspace-1',
          'project-1',
          expectedVersion: 12,
        ),
      ).called(1);
    });

    test('przywrócenie przekazuje wersję projektu', () async {
      await repository.restoreProject(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        expectedVersion: 13,
      );

      verify(
        () => api.restoreProject(
          'workspace-1',
          'project-1',
          expectedVersion: 13,
        ),
      ).called(1);
    });

    test(
      'zmiana danych projektu niesie expectedVersion w payloadzie',
      () async {
        await repository.updateProject(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          name: 'Nowa nazwa',
          visibility: ProjectVisibility.shared,
          status: ProjectStatus.active,
          expectedVersion: 14,
        );

        final payload =
            verify(
                  () => api.updateProject(
                    'workspace-1',
                    'project-1',
                    captureAny(),
                  ),
                ).captured.single
                as UpdateProjectPayload;
        expect(payload.expectedVersion, 14);
      },
    );

    test('preferencje niosą wersję preferencji, nie projektu', () async {
      await repository.updateProjectPreference(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        isHidden: true,
        isPinned: false,
        expectedVersion: 5,
      );

      final payload =
          verify(
                () => api.updateProjectUserPreference(
                  'workspace-1',
                  'project-1',
                  captureAny(),
                ),
              ).captured.single
              as UpdateProjectUserPreferencePayload;
      expect(payload.expectedVersion, 5);
    });

    test('odpowiedź preferencji niesie wersję do kolejnego zapisu', () async {
      final result = await repository.updateProjectPreference(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        isHidden: true,
        isPinned: false,
      );

      result.fold(
        (error) => fail('Nieoczekiwany błąd: $error'),
        (preference) => expect(preference.version, 6),
      );
    });

    test('konflikt wersji zwraca typed 409 z kodem kontraktu', () async {
      when(
        () => api.archiveProject(
          any(),
          any(),
          expectedVersion: any(named: 'expectedVersion'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/projects/project-1/archive'),
          response: Response<Object?>(
            requestOptions: RequestOptions(path: '/projects/project-1/archive'),
            statusCode: 409,
            data: const <String, Object?>{
              'code': 'project.version_conflict',
              'message': 'Projekt zmienił się w innej sesji.',
              'traceId': 'trace-409',
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.archiveProject(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        expectedVersion: 1,
      );

      result.fold(
        (error) {
          expect(error.statusCode, 409);
          expect(error.apiCode, 'project.version_conflict');
          expect(error.traceId, 'trace-409');
        },
        (_) => fail('Konflikt 409 nie może być cichym sukcesem'),
      );
    });
  });
}

/// Pełny widok projektu w kształcie `ProjectResponse` z `ArchivedAtUtc`.
Map<String, Object?> projectResponseJson() => <String, Object?>{
  'id': 'project-1',
  'workspaceId': 'workspace-1',
  'name': 'Alpha',
  'description': null,
  'icon': null,
  'primaryColor': null,
  'visibility': 'Shared',
  'status': 'Active',
  'createdByUserId': 'user-1',
  'myRole': 'Owner',
  'createdAtUtc': '2026-09-01T10:00:00Z',
  'updatedAtUtc': '2026-09-02T10:00:00Z',
  'archivedAtUtc': '2026-09-19T10:00:00Z',
  'version': 13,
  'capabilities': <String, Object?>{'canArchive': true},
};
