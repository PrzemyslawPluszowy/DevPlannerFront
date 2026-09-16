import 'package:json_annotation/json_annotation.dart';

/// Kontekst preferencji dashboardu.
@JsonEnum()
enum DashboardContextKind { personal, project }

/// Typ źródła linku synchronizacji z zadaniem.
@JsonEnum()
enum CrossModuleSyncSourceKind { whiteboardStickyNote, wikiPage }

/// Stan linku synchronizacji między modułami.
@JsonEnum()
enum CrossModuleSyncLinkStatus { active, paused, conflict }
