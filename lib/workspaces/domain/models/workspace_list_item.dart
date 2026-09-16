import 'package:equatable/equatable.dart';

/// Domena reprezentująca workspace widoczny na ekranie startowym.
///
/// Model nie zna formatu JSON ani warstwy Retrofit. Dzięki temu prezentacja
/// pozostaje niezależna od transportowego DTO backendu.
final class WorkspaceListItem extends Equatable {
  /// Tworzy domenowy element listy workspace’ów.
  const WorkspaceListItem({
    required this.id,
    required this.name,
    required this.isPinned,
    this.isHidden = false,
    this.description,
    this.icon,
    this.primaryColor,
    this.sortPosition,
    this.createdByCoreUserId,
    this.isOwner = false,
    this.archivedAtUtc,
  });

  /// Identyfikator workspace’u.
  final String id;

  /// Nazwa wyświetlana użytkownikowi.
  final String name;

  /// Opcjonalny opis workspace’u.
  final String? description;

  /// Opcjonalny identyfikator ikony z backendu.
  final String? icon;

  /// Kolor akcentu w formacie HEX zwrócony przez backend.
  final String? primaryColor;

  /// Czy workspace jest przypięty przez użytkownika.
  final bool isPinned;

  /// Czy workspace jest ukryty wyłącznie na osobistej liście użytkownika.
  final bool isHidden;

  /// Ręczna pozycja sortowania użytkownika.
  final int? sortPosition;

  /// Identyfikator użytkownika, który utworzył workspace.
  final String? createdByCoreUserId;

  /// Czy bieżący użytkownik jest właścicielem/twórcą tego workspace’u.
  final bool isOwner;

  /// Data archiwizacji workspace'u w UTC albo null jeśli aktywny.
  final DateTime? archivedAtUtc;

  /// Czy workspace jest zarchiwizowany.
  bool get isArchived => archivedAtUtc != null;

  /// Kompatybilny alias używany przez formularze i elementy menu.
  String? get iconKey => icon;

  /// Kompatybilny alias nazwy koloru akcentu z warstwy prezentacji.
  String? get accentColorHex => primaryColor;

  /// Tworzy kopię obiektu z nadpisanymi wybranymi właściwościami.
  WorkspaceListItem copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? primaryColor,
    bool? isPinned,
    bool? isHidden,
    int? sortPosition,
    String? createdByCoreUserId,
    bool? isOwner,
    DateTime? archivedAtUtc,
  }) => WorkspaceListItem(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    icon: icon ?? this.icon,
    primaryColor: primaryColor ?? this.primaryColor,
    isPinned: isPinned ?? this.isPinned,
    isHidden: isHidden ?? this.isHidden,
    sortPosition: sortPosition ?? this.sortPosition,
    createdByCoreUserId: createdByCoreUserId ?? this.createdByCoreUserId,
    isOwner: isOwner ?? this.isOwner,
    archivedAtUtc: archivedAtUtc ?? this.archivedAtUtc,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    icon,
    primaryColor,
    isPinned,
    isHidden,
    sortPosition,
    createdByCoreUserId,
    isOwner,
    archivedAtUtc,
  ];
}
