import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskTimeEntryReviewDetails extends StatelessWidget {
  const TaskTimeEntryReviewDetails({
    required this.entry,
    required this.reviewerName,
    super.key,
  });

  final TaskTimeEntryResponse entry;
  final String? reviewerName;

  @override
  Widget build(BuildContext context) {
    final name = reviewerName?.trim();
    final reviewerLabel = name?.isNotEmpty == true
        ? context.l10n.taskDetailsTimeReviewedBy(name!)
        : context.l10n.taskDetailsTimeReviewerUnavailable;
    final reviewedAt = entry.reviewedAtUtc;
    final comment = entry.reviewComment?.trim();
    final locale = Localizations.localeOf(context).toString();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reviewerLabel,
            softWrap: true,
          ),
          Text(
            reviewedAt == null
                ? context.l10n.taskDetailsTimeReviewDateUnavailable
                : DateFormat.yMMMd(locale)
                      .add_jm()
                      .format(reviewedAt.toLocal()),
            softWrap: true,
          ),
          if (comment?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(comment!, softWrap: true),
            ),
        ],
      ),
    );
  }
}
