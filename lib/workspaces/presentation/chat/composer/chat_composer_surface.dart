import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Jedna, lekka powierzchnia pisania: akcje, edytor i Wyślij.
///
/// Edytor jest elastyczny, a akcje mają stały bok, więc długi tekst ani URL
/// nie zgniatają ikon i nie wypychają wysyłki poza panel.
class ChatComposerSurface extends StatelessWidget {
  /// Tworzy powierzchnię pisania.
  const ChatComposerSurface({
    required this.editor,
    required this.send,
    this.moreActions,
    this.trailingActions,
    this.focused = false,
    super.key,
  });

  /// Elastyczny obszar pisania.
  final Widget editor;

  /// Akcja wysyłki; zawsze widoczna.
  final Widget send;

  /// Akcje przed edytorem, np. `+`; brak oznacza brak menu.
  final Widget? moreActions;

  /// Akcje po edytorze, przed Wyślij, np. emoji.
  final Widget? trailingActions;

  /// Czy fokus jest w edytorze; obwódka jest subtelna i tylko dla aktywnej kontrolki.
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final trailing = trailingActions;
    final leading = moreActions;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: chat.composerSurface,
        borderRadius: BorderRadius.all(Radius.circular(chat.composerRadius)),
        border: Border.all(color: focused ? chat.focusRing : chat.separator),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p4,
          vertical: Sizes.p4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (leading != null) ...[leading, const SizedBox(width: Sizes.p4)],
            Expanded(child: editor),
            if (trailing != null) ...[
              const SizedBox(width: Sizes.p4),
              trailing,
            ],
            const SizedBox(width: Sizes.p4),
            send,
          ],
        ),
      ),
    );
  }
}

/// Akcja composera o stałym boku z motywu czatu.
class ChatComposerActionButton extends StatelessWidget {
  /// Tworzy akcję composera.
  const ChatComposerActionButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return SizedBox.square(
      dimension: chat.composerActionSize,
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        iconSize: chat.composerIconSize,
        color: chat.metadataText,
        icon: Icon(icon),
      ),
    );
  }
}

/// Akcje menu `+` composera.
enum ChatComposerMoreAction { image, file, code, textAsFile, expandedEditor }

/// Menu `+`: obraz, plik, kod, tekst jako plik i rozbudowany edytor.
///
/// Pozycje bez działającej integracji są widoczne, ale jawnie niedostępne z
/// powodem; żadna z nich nie udaje wykonanej akcji.
class ChatComposerMoreMenu extends StatelessWidget {
  /// Tworzy menu akcji composera.
  const ChatComposerMoreMenu({
    this.onPickImage,
    this.onPickFile,
    this.onInsertCode,
    this.onTextAsFile,
    this.onToggleExpandedEditor,
    this.expandedEditor = false,
    super.key,
  });

  /// Wybór zdjęcia z systemu; brak portu wyłącza pozycję.
  final VoidCallback? onPickImage;

  /// Wybór dowolnego pliku; brak portu wyłącza pozycję.
  final VoidCallback? onPickFile;

  /// Wstawienie bloku kodu do edytora.
  final VoidCallback? onInsertCode;

  /// Dodaje bieżący szkic jako zwykły załącznik TXT.
  final VoidCallback? onTextAsFile;

  /// Przełączenie rozbudowanego edytora bez konwersji treści.
  final VoidCallback? onToggleExpandedEditor;

  /// Czy rozbudowany edytor jest aktywny.
  final bool expandedEditor;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final canAttachFiles = onPickImage != null && onPickFile != null;
    return Builder(
      builder: (anchorContext) => IconButton(
        key: const ValueKey('chat-composer-more-menu'),
        tooltip: context.l10n.chatComposerMoreActions,
        onPressed: () => unawaited(
          AppContextMenu.show(
            anchorContext,
            globalPosition: AppContextMenu.positionFor(anchorContext),
            headerSubtitle: canAttachFiles
                ? null
                : context.l10n.chatComposerAttachmentsUnavailable,
            actions: [
              AppContextMenuAction(
                label: context.l10n.chatComposerAddImage,
                icon: Symbols.image_rounded,
                enabled: onPickImage != null,
                onTap: (_) => onPickImage?.call(),
              ),
              AppContextMenuAction(
                label: context.l10n.chatComposerAddFile,
                icon: Symbols.attach_file_rounded,
                enabled: onPickFile != null,
                onTap: (_) => onPickFile?.call(),
              ),
              AppContextMenuAction(
                label: context.l10n.chatComposerInsertCode,
                icon: Symbols.code,
                enabled: onInsertCode != null,
                onTap: (_) => onInsertCode?.call(),
              ),
              AppContextMenuAction(
                label: context.l10n.chatComposerTextAsFile,
                icon: Symbols.description,
                enabled: onTextAsFile != null,
                onTap: (_) => onTextAsFile?.call(),
              ),
              AppContextMenuAction(
                label: context.l10n.chatComposerExpandedEditor,
                icon: expandedEditor
                    ? Symbols.check
                    : Symbols.format_size_rounded,
                enabled: onToggleExpandedEditor != null,
                selected: expandedEditor,
                separatorBefore: true,
                onTap: (_) => onToggleExpandedEditor?.call(),
              ),
            ],
          ),
        ),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(
          width: chat.composerActionSize,
          height: chat.composerActionSize,
        ),
        iconSize: chat.composerIconSize,
        color: chat.metadataText,
        icon: const Icon(Symbols.add),
      ),
    );
  }
}
