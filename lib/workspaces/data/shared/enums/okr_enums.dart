import 'package:json_annotation/json_annotation.dart';

/// Sposób wyliczania postępu kluczowego rezultatu.
@JsonEnum()
enum KeyResultType { manual, projectProgress, milestoneProgress }
