import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const kinds = {
    TaskTimeEntryKind.manual: 'Manual',
    TaskTimeEntryKind.timer: 'Timer',
  };
  const approvals = {
    TaskTimeEntryApprovalStatus.draft: 'Draft',
    TaskTimeEntryApprovalStatus.submitted: 'Submitted',
    TaskTimeEntryApprovalStatus.approved: 'Approved',
    TaskTimeEntryApprovalStatus.rejected: 'Rejected',
  };

  Map<String, dynamic> response(String kind, String approval) => {
    'id': 'entry',
    'taskId': 'task',
    'userId': 'author',
    'kind': kind,
    'startedAtUtc': '2026-10-02T01:00:00Z',
    'durationMinutes': 5,
    'isBillable': false,
    'createdAtUtc': '2026-10-02T01:00:00Z',
    'approvalStatus': approval,
    'reviewedByUserId': 'reviewer',
    'reviewedAtUtc': '2026-10-02T02:00:00Z',
    'reviewComment': 'Full review comment — zaakceptowane',
    'version': 2,
    'canSubmit': false,
    'canReview': false,
    'canStopTimer': false,
  };

  test(
    'every time response enum round trips with complete review metadata',
    () {
      expect(kinds.keys, orderedEquals(TaskTimeEntryKind.values));
      expect(approvals.keys, orderedEquals(TaskTimeEntryApprovalStatus.values));
      for (final kind in kinds.entries) {
        for (final approval in approvals.entries) {
          final entry = TaskTimeEntryResponse.fromJson(
            response(kind.value, approval.value),
          );
          expect(entry.kind, kind.key);
          expect(entry.approvalStatus, approval.key);
          expect(entry.isBillable, isFalse);
          final encoded = entry.toJson();
          expect(encoded['kind'], kind.value);
          expect(encoded['approvalStatus'], approval.value);
          expect(encoded['reviewedByUserId'], 'reviewer');
          expect(encoded['reviewComment'], entry.reviewComment);
          expect(
            DateTime.parse(encoded['reviewedAtUtc']! as String),
            DateTime.utc(2026, 10, 2, 2),
          );
        }
      }
    },
  );

  test(
    'unknown time kind or approval does not become a valid review state',
    () {
      for (final wire in ['manual', 'FutureKind']) {
        expect(
          () => TaskTimeEntryResponse.fromJson(response(wire, 'Approved')),
          throwsArgumentError,
        );
      }
      for (final wire in ['approved', 'FutureApproval']) {
        expect(
          () => TaskTimeEntryResponse.fromJson(response('Manual', wire)),
          throwsArgumentError,
        );
      }
    },
  );
}
