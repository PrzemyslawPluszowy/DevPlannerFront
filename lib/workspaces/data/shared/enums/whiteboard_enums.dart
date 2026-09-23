import 'package:json_annotation/json_annotation.dart';

/// Format eksportu whiteboardu.
@JsonEnum(fieldRename: FieldRename.pascal)
enum WhiteboardExportFormat { pdf, png, svg }

/// Zakres eksportu whiteboardu.
@JsonEnum(fieldRename: FieldRename.pascal)
enum WhiteboardExportScope { entireCanvas, currentView, page }

/// Status joba eksportu whiteboardu.
@JsonEnum(fieldRename: FieldRename.pascal)
enum WhiteboardExportJobStatus { pending, processing, completed, failed }
