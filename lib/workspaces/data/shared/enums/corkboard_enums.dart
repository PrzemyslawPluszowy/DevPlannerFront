import 'package:json_annotation/json_annotation.dart';

/// Kolor karteczki Corkboardu.
@JsonEnum(fieldRename: FieldRename.pascal)
enum CorkboardCardColor { yellow, blue, green, pink, orange, purple, slate }
