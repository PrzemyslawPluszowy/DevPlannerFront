import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';

/// Otwiera dialog zmiany nazwy ikony skrotu na pulpicie.
Future<String?> showDashboardShortcutRenameDialog(
  BuildContext context, {
  required String originalLabel,
  String? currentUserLabel,
}) {
  final intl = context.l10n;
  return AppModalSheet.show<String>(
    context,
    title: intl.dashboardShortcutRenameTitle,
    subtitle: intl.dashboardShortcutRenameSubtitle,
    size: AppModalSheetSize.small,
    body: _DashboardShortcutRenameDialogBody(
      originalLabel: originalLabel,
      currentUserLabel: currentUserLabel,
    ),
    maxBodyHeight: 220,
    scrollBody: false,
  );
}

/// Zawartosc dialogu zmiany nazwy skrotu.
class _DashboardShortcutRenameDialogBody extends StatefulWidget {
  /// Tworzy zawartosc dialogu zmiany nazwy skrotu.
  const _DashboardShortcutRenameDialogBody({
    required this.originalLabel,
    required this.currentUserLabel,
  });

  /// Oryginalna nazwa katalogowa skrótu.
  final String originalLabel;

  /// Aktualna nazwa użytkownika, jeśli istnieje.
  final String? currentUserLabel;

  @override
  State<_DashboardShortcutRenameDialogBody> createState() =>
      _DashboardShortcutRenameDialogBodyState();
}

/// Stan zawartosci dialogu zmiany nazwy skrotu.
class _DashboardShortcutRenameDialogBodyState
    extends State<_DashboardShortcutRenameDialogBody> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentUserLabel ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        AppTextField(
          controller: _controller,
          labelText: context.l10n.dashboardShortcutRenameFieldLabel,
          hintText: widget.originalLabel,
          prefixIcon: Icons.drive_file_rename_outline_rounded,
          onSubmitted: (_) => _submit(),
        ),
        Gaps.h16,
        Row(
          children: [
            Expanded(
              child: AppActionButton.outlined(
                label: context.l10n.dashboardShortcutRenameCancel,
                icon: Icons.close_rounded,
                tone: .neutral,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Gaps.w12,
            Expanded(
              child: AppActionButton.filled(
                label: context.l10n.dashboardShortcutRenameSave,
                icon: Icons.check_rounded,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
