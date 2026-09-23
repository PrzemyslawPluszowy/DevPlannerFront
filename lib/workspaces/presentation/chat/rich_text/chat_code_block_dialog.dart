import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';

/// Dane wpisane w formularzu „Wstaw kod”.
final class ChatCodeBlockInput {
  /// Tworzy wynik formularza kodu.
  const ChatCodeBlockInput({required this.code, this.language});

  final String code;

  /// Opcjonalna nazwa języka; pusta wartość oznacza brak etykiety.
  final String? language;
}

/// Mały formularz wstawiania bloku kodu.
///
/// Edycja kodu nie może wysłać wiadomości Enterem, więc formularz ma osobne
/// pole i jawną akcję „Wstaw”. Nie wykonuje kodu ani nie podświetla składni —
/// wynikiem jest wyłącznie bezpieczny blok tekstu.
abstract final class ChatCodeBlockDialog {
  /// Otwiera formularz i zwraca wpisany kod albo `null` po anulowaniu.
  static Future<ChatCodeBlockInput?> show(BuildContext context) =>
      DevPlannerModalHost.showDialog<ChatCodeBlockInput>(
        context,
        builder: (_) => const _ChatCodeBlockDialogBody(),
      );
}

class _ChatCodeBlockDialogBody extends StatefulWidget {
  const _ChatCodeBlockDialogBody();

  @override
  State<_ChatCodeBlockDialogBody> createState() =>
      _ChatCodeBlockDialogBodyState();
}

class _ChatCodeBlockDialogBodyState extends State<_ChatCodeBlockDialogBody> {
  final TextEditingController _language = TextEditingController();
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _language.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _code.text.trim().isNotEmpty;
    return ChatSurfaceDialog(
      title: context.l10n.chatComposerInsertCode,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _language,
            style: context.chatTheme.contentStyle.copyWith(
              color: context.chatTheme.incomingText,
            ),
            decoration: InputDecoration(
              isDense: true,
              labelText: context.l10n.chatComposerCodeLanguage,
              labelStyle: context.chatTheme.metadataStyle.copyWith(
                color: context.chatTheme.metadataText,
              ),
              filled: true,
              fillColor: context.chatTheme.composerSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.chatTheme.separator),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.chatTheme.separator),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.chatTheme.focusRing),
              ),
            ),
          ),
          const SizedBox(height: Sizes.p8),
          TextField(
            controller: _code,
            minLines: 4,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            style: context.chatTheme.monospaceStyle.copyWith(
              color: context.chatTheme.incomingText,
            ),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              isDense: true,
              alignLabelWithHint: true,
              labelText: context.l10n.chatComposerCodeContent,
              labelStyle: context.chatTheme.metadataStyle.copyWith(
                color: context.chatTheme.metadataText,
              ),
              filled: true,
              fillColor: context.chatTheme.codeSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.chatTheme.separator),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.chatTheme.separator),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.chatTheme.focusRing),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.chatCreationCancel),
        ),
        FilledButton(
          onPressed: canSubmit
              ? () => Navigator.of(context).pop(
                  ChatCodeBlockInput(
                    code: _code.text,
                    language: _language.text.trim().isEmpty
                        ? null
                        : _language.text.trim(),
                  ),
                )
              : null,
          child: Text(context.l10n.chatComposerCodeSubmit),
        ),
      ],
    );
  }
}
