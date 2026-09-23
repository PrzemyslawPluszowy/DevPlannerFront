import 'package:json_annotation/json_annotation.dart';

/// Bezpośredni poziom dostępu do strony Wiki lub whiteboardu.
@JsonEnum(fieldRename: FieldRename.pascal)
enum ResourceAccessLevel { reader, editor }
