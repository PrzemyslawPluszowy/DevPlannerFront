import 'package:json_annotation/json_annotation.dart';

/// Kontekst preferencji dashboardu.
@JsonEnum(fieldRename: FieldRename.pascal)
enum DashboardContextKind { personal, project }

/// Stabilna reprezentacja tekstowa używana w query API.
extension DashboardContextKindWireValue on DashboardContextKind {
  String get wireValue => switch (this) {
    DashboardContextKind.personal => 'Personal',
    DashboardContextKind.project => 'Project',
  };
}

/// Typ źródła linku synchronizacji z zadaniem.
@JsonEnum(fieldRename: FieldRename.pascal)
enum CrossModuleSyncSourceKind { whiteboardStickyNote, wikiPage }

/// Stan linku synchronizacji między modułami.
@JsonEnum(fieldRename: FieldRename.pascal)
enum CrossModuleSyncLinkStatus { active, paused, conflict }
