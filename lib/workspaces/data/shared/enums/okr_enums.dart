import 'package:json_annotation/json_annotation.dart';

/// Sposób wyliczania postępu kluczowego rezultatu.
@JsonEnum(fieldRename: FieldRename.pascal)
enum KeyResultType { manual, projectProgress, milestoneProgress }
