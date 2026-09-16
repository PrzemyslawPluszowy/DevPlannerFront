import 'package:ready_next/features/bhp/data/models/endpoints/bhp_employee_name.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Zagregowany snapshot sekcji struktury.
class BhpIssueStatisticsStructureSnapshot {
  /// Tworzy snapshot sekcji struktury.
  const BhpIssueStatisticsStructureSnapshot({
    required this.totalIssuedCount,
    required this.totalIssuedQuantity,
    required this.distinctEquipmentCount,
    required this.distinctPositionsCount,
    required this.distinctUsersCount,
    required this.equipmentRows,
    required this.positionRows,
    required this.userRows,
  });

  /// Łączna liczba wydań.
  final int totalIssuedCount;

  /// Łączna wydana ilość.
  final double totalIssuedQuantity;

  /// Liczba różnych kart wyposażenia.
  final int distinctEquipmentCount;

  /// Liczba różnych stanowisk.
  final int distinctPositionsCount;

  /// Liczba różnych pracowników.
  final int distinctUsersCount;

  /// Wiersze wyposażenia.
  final List<BhpIssueStatisticsEquipmentRow> equipmentRows;

  /// Wiersze stanowisk.
  final List<BhpIssueStatisticsPositionRow> positionRows;

  /// Wiersze pracowników.
  final List<BhpIssueStatisticsUserRow> userRows;
}

/// Wiersz zestawienia wyposażenia.
class BhpIssueStatisticsEquipmentRow {
  /// Tworzy wiersz wyposażenia.
  const BhpIssueStatisticsEquipmentRow({
    required this.label,
    required this.issuedCount,
    required this.issuedQuantity,
  });

  /// Nazwa wyposażenia.
  final String label;

  /// Liczba wydań.
  final int issuedCount;

  /// Łączna ilość z operacji `issued`.
  final double issuedQuantity;
}

/// Wiersz zestawienia stanowisk.
class BhpIssueStatisticsPositionRow {
  /// Tworzy wiersz stanowiska.
  const BhpIssueStatisticsPositionRow({
    required this.label,
    required this.issuedCount,
    required this.issuedQuantity,
  });

  /// Nazwa stanowiska.
  final String label;

  /// Liczba wydań.
  final int issuedCount;

  /// Łączna wydana ilość.
  final double issuedQuantity;
}

/// Wiersz zestawienia pracowników.
class BhpIssueStatisticsUserRow {
  /// Tworzy wiersz pracownika.
  const BhpIssueStatisticsUserRow({
    required this.user,
    required this.label,
    required this.issuedCount,
    required this.issuedQuantity,
  });

  /// Minimalne dane pracownika do otwarcia karty wydań.
  final GetBhpUserListItem user;

  /// Imię i nazwisko pracownika.
  final String label;

  /// Liczba wydań.
  final int issuedCount;

  /// Łączna wydana ilość.
  final double issuedQuantity;
}

/// Buduje snapshot sekcji struktury na podstawie listy operacji.
BhpIssueStatisticsStructureSnapshot buildStructureSnapshot(
  List<GetBhpIssueOperationItem> items,
) {
  final equipmentMap =
      <String, ({String label, int issuedCount, double issuedQuantity})>{};
  final positionMap =
      <String, ({String label, int issuedCount, double issuedQuantity})>{};
  final userMap =
      <
        int,
        ({
          String label,
          String? rawFullName,
          String? stanowiskoNazwa,
          int issuedCount,
          double issuedQuantity,
        })
      >{};
  final equipmentKeys = <String>{};
  final positionKeys = <String>{};
  final userIds = <int>{};
  var totalIssuedCount = 0;
  var totalIssuedQuantity = 0.0;

  for (final item in items) {
    if (item.type != 'issued') {
      continue;
    }

    totalIssuedCount++;
    final qty = _issuedQuantity(item);
    totalIssuedQuantity += qty;

    final equipmentKey = _entityKey(
      id: item.kartaWyposazeniaId,
      label: item.equipmentLabel,
      prefix: 'equipment',
    );
    equipmentKeys.add(equipmentKey);
    final currentEquipment =
        equipmentMap[equipmentKey] ??
        (
          label: item.equipmentLabel,
          issuedCount: 0,
          issuedQuantity: 0.0,
        );
    equipmentMap[equipmentKey] = (
      label: currentEquipment.label,
      issuedCount: currentEquipment.issuedCount + 1,
      issuedQuantity: currentEquipment.issuedQuantity + qty,
    );

    final positionLabel = _normalizeLabel(item.stanowiskoNazwa);
    final positionKey = _entityKey(
      id: item.stanowiskoId,
      label: positionLabel,
      prefix: 'position',
    );
    positionKeys.add(positionKey);
    final currentPosition =
        positionMap[positionKey] ??
        (
          label: positionLabel,
          issuedCount: 0,
          issuedQuantity: 0.0,
        );
    positionMap[positionKey] = (
      label: currentPosition.label,
      issuedCount: currentPosition.issuedCount + 1,
      issuedQuantity: currentPosition.issuedQuantity + qty,
    );

    userIds.add(item.userId);
    final currentUser =
        userMap[item.userId] ??
        (
          label: item.formattedUserFullName,
          rawFullName: item.userFullName,
          stanowiskoNazwa: item.stanowiskoNazwa,
          issuedCount: 0,
          issuedQuantity: 0.0,
        );
    userMap[item.userId] = (
      label: currentUser.label,
      rawFullName: currentUser.rawFullName,
      stanowiskoNazwa: currentUser.stanowiskoNazwa,
      issuedCount: currentUser.issuedCount + 1,
      issuedQuantity: currentUser.issuedQuantity + qty,
    );
  }

  final equipmentRows =
      equipmentMap.entries
          .map(
            (entry) => BhpIssueStatisticsEquipmentRow(
              label: entry.value.label,
              issuedCount: entry.value.issuedCount,
              issuedQuantity: entry.value.issuedQuantity,
            ),
          )
          .toList(growable: false)
        ..sort(_sortEquipmentRows);

  final positionRows =
      positionMap.entries
          .map(
            (entry) => BhpIssueStatisticsPositionRow(
              label: entry.value.label,
              issuedCount: entry.value.issuedCount,
              issuedQuantity: entry.value.issuedQuantity,
            ),
          )
          .toList(growable: false)
        ..sort(_sortPositionRows);

  final userRows =
      userMap.entries
          .map((entry) {
            final value = entry.value;
            return BhpIssueStatisticsUserRow(
              user: GetBhpUserListItem(
                id: entry.key,
                aktywny: true,
                isArchived: false,
                imie: extractBhpEmployeeFirstName(value.rawFullName),
                nazwisko: extractBhpEmployeeLastName(value.rawFullName),
                stanowiskoNazwa: value.stanowiskoNazwa,
              ),
              label: value.label,
              issuedCount: value.issuedCount,
              issuedQuantity: value.issuedQuantity,
            );
          })
          .toList(growable: false)
        ..sort((a, b) {
          final byCount = b.issuedCount.compareTo(a.issuedCount);
          if (byCount != 0) {
            return byCount;
          }

          return b.issuedQuantity.compareTo(a.issuedQuantity);
        });

  return BhpIssueStatisticsStructureSnapshot(
    totalIssuedCount: totalIssuedCount,
    totalIssuedQuantity: totalIssuedQuantity,
    distinctEquipmentCount: equipmentKeys.length,
    distinctPositionsCount: positionKeys.length,
    distinctUsersCount: userIds.length,
    equipmentRows: equipmentRows,
    positionRows: positionRows,
    userRows: userRows,
  );
}

int _sortEquipmentRows(
  BhpIssueStatisticsEquipmentRow a,
  BhpIssueStatisticsEquipmentRow b,
) {
  final byCount = b.issuedCount.compareTo(a.issuedCount);
  if (byCount != 0) {
    return byCount;
  }

  return b.issuedQuantity.compareTo(a.issuedQuantity);
}

int _sortPositionRows(
  BhpIssueStatisticsPositionRow a,
  BhpIssueStatisticsPositionRow b,
) {
  final byCount = b.issuedCount.compareTo(a.issuedCount);
  if (byCount != 0) {
    return byCount;
  }

  return b.issuedQuantity.compareTo(a.issuedQuantity);
}

String _entityKey({
  required int? id,
  required String label,
  required String prefix,
}) {
  if (id case final entityId?) {
    return '$prefix:$entityId';
  }

  return '$prefix:${label.toLowerCase()}';
}

double _issuedQuantity(GetBhpIssueOperationItem item) {
  if (item.type != 'issued') {
    return 0;
  }

  return double.tryParse(item.quantity ?? '') ?? 0;
}

String _normalizeLabel(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return '—';
  }

  return trimmed;
}
