String formatBhpEmployeeNameLastFirst(String? fullName) {
  final parts = _splitBhpEmployeeName(fullName);
  if (parts.isEmpty) {
    return 'Brak imienia i nazwiska';
  }
  if (parts.length == 1) {
    return parts.first;
  }

  return '${parts.skip(1).join(' ')} ${parts.first}';
}

String? extractBhpEmployeeFirstName(String? fullName) {
  final parts = _splitBhpEmployeeName(fullName);
  if (parts.isEmpty) {
    return null;
  }

  return parts.first;
}

String? extractBhpEmployeeLastName(String? fullName) {
  final parts = _splitBhpEmployeeName(fullName);
  if (parts.length < 2) {
    return null;
  }

  return parts.skip(1).join(' ');
}

List<String> _splitBhpEmployeeName(String? fullName) {
  return (fullName ?? '')
      .split(' ')
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList(growable: false);
}
