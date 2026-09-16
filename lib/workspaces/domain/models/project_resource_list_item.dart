import 'package:flutter/foundation.dart';

/// Typ zasobu, który może być rozwinięty bezpośrednio pod projektem.
enum ProjectResourceKind { tasks, whiteboards, wiki, files, automations }

/// Akcja uruchamiana z menu projektu.
///
/// Menu tylko przekazuje intencję do właściciela nawigacji. Nie tworzy
/// zasobów i nie zawiera formularzy domenowych.
enum ProjectMenuAction {
  createProject,
  createTask,
  createWhiteboard,
  createFile,
  createFolder,
  createAutomation,
  createWikiPage,
  addCorkboardCard,
}

/// Minimalny model nawigacyjny zasobu projektu.
///
/// Model celowo nie przenosi DTO z warstwy `data` do widgetów. Zawiera tylko
/// dane potrzebne do opisania pozycji drzewa i zbudowania bezpiecznego URL.
@immutable
final class ProjectResourceListItem {
  const ProjectResourceListItem({
    required this.id,
    required this.title,
    required this.kind,
    this.isVerified = false,
  });

  final String id;
  final String title;
  final ProjectResourceKind kind;
  final bool isVerified;
}
