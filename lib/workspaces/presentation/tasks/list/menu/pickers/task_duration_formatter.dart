/// Formatuje i parsuje czas trwania zadań wyrażony w minutach.
final class TaskDurationFormatter {
  const TaskDurationFormatter._();

  static String format(int? minutes, {bool showEmptyDash = false}) {
    if (minutes == null || minutes <= 0) {
      return showEmptyDash ? '—' : '';
    }
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours >= 8 && hours % 8 == 0 && remainingMinutes == 0) {
      return '${hours ~/ 8}d';
    }
    if (remainingMinutes == 0) return '${hours}h';
    return '${hours}h ${remainingMinutes}m';
  }

  static int? parse(String input) {
    final clean = input.trim().toLowerCase();
    if (clean.isEmpty) return null;
    final directNumber = int.tryParse(clean);
    if (directNumber != null) return directNumber > 0 ? directNumber : null;

    var total = 0;
    final dayMatch = RegExp(r'(\d+(?:\.\d+)?)\s*d').firstMatch(clean);
    final hourMatch = RegExp(r'(\d+(?:\.\d+)?)\s*h').firstMatch(clean);
    final minuteMatch = RegExp(r'(\d+)\s*m').firstMatch(clean);
    if (dayMatch != null) {
      total += ((double.tryParse(dayMatch.group(1) ?? '') ?? 0) * 8 * 60)
          .round();
    }
    if (hourMatch != null) {
      total += ((double.tryParse(hourMatch.group(1) ?? '') ?? 0) * 60).round();
    }
    if (minuteMatch != null) {
      total += int.tryParse(minuteMatch.group(1) ?? '') ?? 0;
    }
    return total > 0 ? total : null;
  }
}
