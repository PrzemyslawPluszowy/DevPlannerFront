import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_file_actions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Kotwiczy menu pliku do przycisku konkretnego załącznika.
final class TaskAttachmentMenuButton extends StatelessWidget {
  const TaskAttachmentMenuButton({required this.file, super.key});

  final StorageFileResponse file;

  void _openMenu(BuildContext context) {
    unawaited(TaskAttachmentFileActions.show(context, file));
  }

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.l10n.storageMoreOptionsTooltip,
    onPressed: () => _openMenu(context),
    icon: const Icon(Symbols.more_horiz_rounded, size: 18),
  );
}
