import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_operation_error_normalizer.dart';

typedef TaskTimeReviewerNameLookupResult = ({
  Map<String, String> names,
  ApiError? failure,
});

typedef TaskTimeReviewerLookupRequest = ({
  Set<String> reviewerIds,
  bool shouldRefresh,
  TaskTimeReviewerNameLookupResult? result,
});

/// Odczytuje nazwy weryfikujących przez port profili ograniczony uprawnieniami projektu.
final class TaskTimeEntryReviewerNameLookup {
  const TaskTimeEntryReviewerNameLookup._();

  static Future<TaskTimeReviewerNameLookupResult> load({
    required ProjectMemberProfilesRepository? repository,
    required String workspaceId,
    required String projectId,
    required Set<String> reviewerIds,
    required bool forceRefresh,
  }) async {
    if (repository == null) {
      return (
        names: const <String, String>{},
        failure: const ApiError(type: ApiErrorType.unknown, message: ''),
      );
    }
    try {
      final result = await repository.listProfiles(
        workspaceId: workspaceId,
        projectId: projectId,
        forceRefresh: forceRefresh,
      );
      final lookup = result.fold(
        (error) => (names: const <String, String>{}, failure: error),
        (members) => (
          names: Map<String, String>.unmodifiable({
            for (final member in members)
              if (reviewerIds.contains(member.userId) &&
                  member.displayName?.trim().isNotEmpty == true)
                member.userId: member.displayName!.trim(),
          }),
          failure: null,
        ),
      );
      return lookup;
    } on Object catch (error) {
      return (
        names: const <String, String>{},
        failure: TaskDetailOperationErrorNormalizer.fromThrown(
          error,
          fallbackMessage: '',
        ),
      );
    }
  }

  /// Przygotowuje listę autorów i pobiera profile poza cyklem budowania UI.
  static Future<TaskTimeReviewerLookupRequest> loadForEntries({
    required ProjectMemberProfilesRepository? repository,
    required String workspaceId,
    required String projectId,
    required List<TaskTimeEntryResponse> entries,
    required Set<String> alreadyLookedUp,
    required bool refreshUnseen,
    required bool forceRefresh,
  }) async {
    final reviewerIds = entries
        .map((entry) => entry.reviewedByUserId?.trim())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();
    final pendingIds = reviewerIds.difference(alreadyLookedUp);
    final shouldRefresh =
        forceRefresh ||
        (pendingIds.isNotEmpty &&
            (refreshUnseen || alreadyLookedUp.isNotEmpty));
    if (reviewerIds.isEmpty || (pendingIds.isEmpty && !forceRefresh)) {
      return (
        reviewerIds: reviewerIds,
        shouldRefresh: shouldRefresh,
        result: null,
      );
    }
    return (
      reviewerIds: reviewerIds,
      shouldRefresh: shouldRefresh,
      result: await load(
        repository: repository,
        workspaceId: workspaceId,
        projectId: projectId,
        reviewerIds: reviewerIds,
        forceRefresh: shouldRefresh,
      ),
    );
  }
}
