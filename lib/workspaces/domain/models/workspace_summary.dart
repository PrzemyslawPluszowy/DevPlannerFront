/// Minimalny, lokalny kontrakt workspace używany przez katalog rootu.
final class WorkspaceSummary {
  const WorkspaceSummary({
    required this.id,
    required this.name,
    this.description,
    required this.isPinned,
    required this.isHidden,
    required this.isOwner,
  });

  final String id;
  final String name;
  final String? description;
  final bool isPinned;
  final bool isHidden;
  final bool isOwner;
}
