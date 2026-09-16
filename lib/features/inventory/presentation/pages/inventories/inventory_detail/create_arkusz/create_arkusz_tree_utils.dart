import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';

/// Klucz drzewa zgodny z backendowym zakresem miejsca: firma + baza + id wezla.
typedef CreateArkuszScopedTreeKey = ({String baza, int firma, int id});

/// Okresla, czy relacja `idparent` wskazuje na `id` rekordu czy na `id_miejsca`.
bool createArkuszParentUsesRecordId(List<GetMiejscaItem> locations) {
  final recordIds = {for (final location in locations) location.id};
  final placeIds = {for (final location in locations) location.idMiejsca};
  final parentIds = locations
      .map((location) => location.idparent)
      .whereType<int>()
      .where((id) => id != 0)
      .toList(growable: false);

  final recordMatches = parentIds.where(recordIds.contains).length;
  final placeMatches = parentIds.where(placeIds.contains).length;
  return recordMatches > placeMatches;
}

/// Zwraca klucz drzewa zgodny z trybem parent->child (`id` lub `id_miejsca`).
int createArkuszTreeKey(
  GetMiejscaItem location,
  bool parentUsesRecordId,
) {
  return parentUsesRecordId ? location.id : location.idMiejsca;
}

/// Zwraca klucz wezla z separacja po firmie i bazie.
CreateArkuszScopedTreeKey createArkuszScopedTreeKey(
  GetMiejscaItem location,
  bool parentUsesRecordId,
) {
  return (
    firma: location.idFirmy,
    baza: (location.baza ?? '').trim(),
    id: createArkuszTreeKey(location, parentUsesRecordId),
  );
}

/// Zwraca klucz rodzica z separacja po firmie i bazie.
CreateArkuszScopedTreeKey createArkuszScopedParentKey(
  GetMiejscaItem location,
) {
  return (
    firma: location.idFirmy,
    baza: (location.baza ?? '').trim(),
    id: location.idparent ?? 0,
  );
}

/// Tworzy arkusz tylko dla wskazanego miejsca, bez automatycznego subtree.
///
/// Backend nadal obsluguje `subtree`, ale UI celowo nie wlacza tego trybu.
/// To zachowuje zgodnosc z Delphi, gdzie `CREATE_ARS` dostawal jedno
/// `IDMIEJSCA`, a wsad arkusza byl wyliczany dla wybranego miejsca.
String createArkuszResolveLocationScope({
  required List<GetMiejscaItem> locations,
  required int? selectedLocationId,
}) {
  return 'node';
}
