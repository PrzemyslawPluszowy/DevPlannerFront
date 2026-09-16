import 'package:json_annotation/json_annotation.dart';

/// Format eksportu whiteboardu.
@JsonEnum()
enum WhiteboardExportFormat { pdf, png, svg }

/// Zakres eksportu whiteboardu.
@JsonEnum()
enum WhiteboardExportScope { entireCanvas, currentView, page }

/// Status joba eksportu whiteboardu.
@JsonEnum()
enum WhiteboardExportJobStatus { pending, processing, completed, failed }
