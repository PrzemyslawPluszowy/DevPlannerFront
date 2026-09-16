import 'package:json_annotation/json_annotation.dart';

/// Bezpośredni poziom dostępu do strony Wiki lub whiteboardu.
@JsonEnum()
enum ResourceAccessLevel { reader, editor }
