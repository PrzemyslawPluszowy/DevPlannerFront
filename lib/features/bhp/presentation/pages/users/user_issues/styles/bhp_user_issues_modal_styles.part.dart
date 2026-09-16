part of '../bhp_user_issues_modal.dart';

/// Style i pomocnicze wyliczenia dla tabeli wydań pracownika.
extension _BhpUserIssuesModalStyles on _BhpUserIssuesModalBodyState {
  Color? _getDueDateCellColor(BuildContext context, GetBhpUserIssue row) {
    if (!row.isActive || row.dataZakonczenia != null || row.dueDate == null) {
      return null;
    }

    final difference = _getDueDateDifference(row);
    if (difference == null) {
      return null;
    }
    if (difference < 0) {
      return context.feedback.errorBackground;
    }
    if (difference <= 14) {
      return context.feedback.warningBackground;
    }
    return null;
  }

  TextStyle? _getDueDateTextStyle(BuildContext context, GetBhpUserIssue row) {
    if (!row.isActive || row.dataZakonczenia != null || row.dueDate == null) {
      return null;
    }

    final difference = _getDueDateDifference(row);
    if (difference == null) {
      return null;
    }
    if (difference < 0) {
      return TextStyle(
        color: context.feedback.errorForeground,
        fontWeight: .bold,
        fontSize: 13,
      );
    }
    if (difference <= 14) {
      return TextStyle(
        color: context.feedback.warningForeground,
        fontWeight: .bold,
        fontSize: 13,
      );
    }
    return null;
  }

  String? _buildDueDateDeltaLabel(GetBhpUserIssue row) {
    if (!row.isActive || row.dataZakonczenia != null || row.dueDate == null) {
      return null;
    }

    final difference = _getDueDateDifference(row);
    if (difference == null) {
      return null;
    }
    if (difference == 0) {
      return '(0)';
    }
    if (difference > 0) {
      return '(+$difference)';
    }
    return '(-${difference.abs()})';
  }

  TextStyle? _getDueDateDeltaTextStyle(
    BuildContext context,
    GetBhpUserIssue row,
  ) {
    if (!row.isActive || row.dataZakonczenia != null || row.dueDate == null) {
      return null;
    }

    final difference = _getDueDateDifference(row);
    if (difference == null) {
      return null;
    }
    if (difference < 0) {
      return context.text.labelSmall?.copyWith(
        color: context.feedback.errorForeground,
        fontWeight: .w700,
        fontSize: 10,
      );
    }
    if (difference <= 14) {
      return context.text.labelSmall?.copyWith(
        color: context.feedback.warningForeground,
        fontWeight: .w700,
        fontSize: 10,
      );
    }
    return context.text.labelSmall?.copyWith(
      color: context.feedback.successForeground,
      fontWeight: .w700,
      fontSize: 10,
    );
  }

  int? _getDueDateDifference(GetBhpUserIssue row) {
    final due = DateTime.tryParse(row.dueDate ?? '');
    if (due == null) {
      return null;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(due.year, due.month, due.day);
    return dueDate.difference(today).inDays;
  }

  TextStyle? _getRowInfoTextStyle(BuildContext context, GetBhpUserIssue row) {
    final colors = context.colors;
    return context.text.bodyMedium?.copyWith(
      fontSize: 12,
      color: row.isActive
          ? colors.primary
          : colors.primary.withValues(alpha: .72),
      fontWeight: .w600,
      decoration: TextDecoration.underline,
      decorationColor: colors.primary.withValues(alpha: .72),
    );
  }

  TextStyle? _getRowTextStyle(BuildContext context, GetBhpUserIssue row) {
    final colors = context.colors;
    return context.text.bodyMedium?.copyWith(
      fontSize: 12,
      color: row.isActive
          ? colors.onSurface
          : colors.onSurfaceVariant.withValues(alpha: .72),
    );
  }

  Color _getRowIconColor(BuildContext context, GetBhpUserIssue row) {
    final colors = context.colors;
    return row.isActive ? colors.primary : colors.primary.withValues(alpha: .7);
  }
}
