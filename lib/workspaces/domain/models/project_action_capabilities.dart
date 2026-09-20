import 'package:flutter/foundation.dart';

/// Możliwości bieżącego użytkownika względem projektu zwrócone przez backend.
///
/// Model pochodzi wyłącznie z odpowiedzi serwera (`capabilities`), a nie z roli
/// odczytanej z listy. Brak odpowiedzi (`null`) jest stanem jawnym: UI nie wie,
/// co wolno, więc zachowuje się zachowawczo i nie zgaduje uprawnień z `myRole`.
/// Backend nadal sprawdza własne ACL na każdym endpointcie.
@immutable
final class ProjectActionCapabilities {
  /// Tworzy zestaw możliwości; brak informacji odpowiada wszystkim `false`,
  /// bo tylko jawna zgoda backendu może odblokować akcję.
  const ProjectActionCapabilities({
    this.canManage = false,
    this.canArchive = false,
    this.canDelete = false,
    this.canManageMembers = false,
    this.canCreateTemplate = false,
    this.canLeave = false,
    this.canTransfer = false,
  });

  /// Zestaw możliwości bez żadnej zgody backendu.
  static const ProjectActionCapabilities none = ProjectActionCapabilities();

  /// Czy wolno zmieniać dane projektu (nazwa, opis, ikona, kolor, widoczność).
  final bool canManage;

  /// Czy wolno archiwizować i przywracać projekt.
  final bool canArchive;

  /// Czy wolno trwale usunąć zarchiwizowany projekt.
  final bool canDelete;

  /// Czy wolno zarządzać członkami projektu.
  final bool canManageMembers;

  /// Czy wolno zapisać szablon z projektu.
  final bool canCreateTemplate;

  /// Czy istnieje jawne członkostwo, które można opuścić.
  final bool canLeave;

  /// Zarezerwowane dla transferu między workspace’ami; backend zwraca `false`
  /// dopóki kontrakt transferu nie istnieje.
  final bool canTransfer;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectActionCapabilities &&
          runtimeType == other.runtimeType &&
          canManage == other.canManage &&
          canArchive == other.canArchive &&
          canDelete == other.canDelete &&
          canManageMembers == other.canManageMembers &&
          canCreateTemplate == other.canCreateTemplate &&
          canLeave == other.canLeave &&
          canTransfer == other.canTransfer;

  @override
  int get hashCode => Object.hash(
    canManage,
    canArchive,
    canDelete,
    canManageMembers,
    canCreateTemplate,
    canLeave,
    canTransfer,
  );

  @override
  String toString() =>
      'ProjectActionCapabilities(canManage: $canManage, canArchive: '
      '$canArchive, canDelete: $canDelete, canManageMembers: '
      '$canManageMembers, canCreateTemplate: $canCreateTemplate, canLeave: '
      '$canLeave, canTransfer: $canTransfer)';
}
