import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/storage/payloads/storage_payloads.dart';
import 'package:ready_next/workspaces/data/storage/responses/storage_responses.dart';
import 'package:retrofit/retrofit.dart';

part 'task_operations_api.g.dart';

/// Klient Retrofit operacji checklisty, obserwatorów, etykiet i pól zadań.
@RestApi()
abstract class TaskOperationsApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory TaskOperationsApi(Dio dio, {String? baseUrl}) = _TaskOperationsApi;

  /// Atomowo zastępuje wykonawców zadania.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/assignees',
  )
  Future<TaskMutationResponse<ProjectTaskResponse>> replaceAssignees(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() UpdateTaskAssigneesPayload body,
  );

  /// Dodaje pozycję checklisty do zadania.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/checklist',
  )
  Future<TaskMutationResponse<TaskChecklistItemResponse>> addChecklistItem(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() CreateTaskChecklistItemPayload body,
  );

  /// Aktualizuje pozycję checklisty.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/checklist/{itemId}',
  )
  Future<TaskMutationResponse<TaskChecklistItemResponse>> updateChecklistItem(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Path('itemId') String itemId,
    @Body() UpdateTaskChecklistItemPayload body,
  );

  /// Usuwa pozycję checklisty.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/checklist/{itemId}',
  )
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  deleteChecklistItem(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Path('itemId') String itemId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Pobiera obserwatorów zadania.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/watchers',
  )
  Future<List<TaskWatcherResponse>> listWatchers(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );

  /// Rozpoczyna obserwowanie zadania przez bieżącego użytkownika.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/watchers/me',
  )
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>> followTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Kończy obserwowanie zadania przez bieżącego użytkownika.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/watchers/me',
  )
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  unfollowTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Pobiera kryteria akceptacji zadania.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/acceptance-criteria',
  )
  Future<List<TaskAcceptanceCriterionResponse>> listAcceptanceCriteria(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );

  /// Dodaje kryterium akceptacji zadania.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/acceptance-criteria',
  )
  Future<TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  createAcceptanceCriterion(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() CreateTaskAcceptanceCriterionPayload body,
  );

  /// Aktualizuje kryterium akceptacji zadania.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/acceptance-criteria/{criterionId}',
  )
  Future<TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  updateAcceptanceCriterion(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Path('criterionId') String criterionId,
    @Body() UpdateTaskAcceptanceCriterionPayload body,
  );

  /// Usuwa kryterium akceptacji zadania.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/acceptance-criteria/{criterionId}',
  )
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  deleteAcceptanceCriterion(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Path('criterionId') String criterionId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Zmienia osobiste przypięcie zadania.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/preference',
  )
  Future<void> updateTaskPreference(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() UpdateTaskUserPreferencePayload body,
  );

  /// Pobiera aktywne pliki przypisane do zadania.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/attachments',
  )
  Future<List<StorageFileResponse>> listTaskAttachments(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );

  /// Generuje zbiorcze bilety uploadu załączników zadania.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/attachments/bulk-tickets',
  )
  Future<BulkStorageUploadTicketResponse> requestBulkAttachmentTickets(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() BulkTaskUploadTicketPayload body,
  );

  /// Zatwierdza zbiorczo przesłane załączniki zadania.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/attachments/bulk-complete',
  )
  Future<BulkCompleteUploadResponse> completeBulkAttachments(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() BulkCompleteUploadPayload body,
  );

  /// Pobiera aktywne etykiety projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-labels/')
  Future<List<TaskLabelResponse>> listLabels(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Tworzy etykietę projektu.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-labels/')
  Future<TaskLabelResponse> createLabel(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateTaskLabelPayload body,
  );

  /// Aktualizuje etykietę projektu.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-labels/{labelId}',
  )
  Future<TaskLabelResponse> updateLabel(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('labelId') String labelId,
    @Body() UpdateTaskLabelPayload body,
  );

  /// Archiwizuje etykietę projektu.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-labels/{labelId}',
  )
  Future<void> archiveLabel(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('labelId') String labelId,
  );

  /// Zastępuje etykiety przypisane do zadania.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/labels',
  )
  Future<TaskMutationResponse<List<TaskLabelResponse>>> replaceLabels(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() ReplaceTaskLabelsPayload body,
  );

  /// Pobiera aktywne definicje pól niestandardowych projektu.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-custom-fields/',
  )
  Future<List<TaskCustomFieldResponse>> listCustomFields(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Tworzy definicję pola niestandardowego.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-custom-fields/',
  )
  Future<TaskCustomFieldResponse> createCustomField(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateTaskCustomFieldPayload body,
  );

  /// Aktualizuje definicję pola niestandardowego.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-custom-fields/{fieldId}',
  )
  Future<TaskCustomFieldResponse> updateCustomField(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('fieldId') String fieldId,
    @Body() UpdateTaskCustomFieldPayload body,
  );

  /// Archiwizuje definicję pola niestandardowego.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-custom-fields/{fieldId}',
  )
  Future<void> archiveCustomField(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('fieldId') String fieldId,
  );

  /// Zastępuje wartości wszystkich pól niestandardowych zadania.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/custom-fields',
  )
  Future<TaskMutationResponse<List<TaskCustomFieldValueResponse>>>
  replaceCustomFieldValues(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() ReplaceTaskCustomFieldValuesPayload body,
  );
}
