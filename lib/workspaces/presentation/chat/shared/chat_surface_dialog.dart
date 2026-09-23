import 'dart:math' as math;

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Dialog surface used by Chat flows instead of the default Material dialog.
///
/// Geometry, surfaces, separator, and focus colors come from ChatTheme; the
/// supplied content/actions keep their existing domain behavior.
class ChatSurfaceDialog extends StatelessWidget {
  const ChatSurfaceDialog({
    required this.title,
    required this.content,
    this.subtitle,
    this.leading,
    this.actions = const <Widget>[],
    this.maxWidth = 560,
    this.showCloseButton = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget content;
  final List<Widget> actions;
  final double maxWidth;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final media = MediaQuery.sizeOf(context);
    final width = math.min(maxWidth, media.width - Sizes.p32);
    final maxHeight = math.max(240.0, media.height - 64);
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: chat.incomingText,
    );
    final subtitleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: chat.metadataText,
    );

    return Theme(
      // Ten dialog jest montowany w root navigatorze, poza lokalnym Theme
      // panelu Chat. Jawnie przywracamy kontrolki ChatTheme, żeby akcje,
      // pola i progress nie dziedziczyły przypadkowego motywu ekranu bazowego.
      data: chat.applyControls(Theme.of(context)),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p24,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width, maxHeight: maxHeight),
          child: Material(
            color: chat.panelSurface,
            elevation: 16,
            shadowColor: Colors.black.withValues(alpha: .24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(chat.composerRadius),
              side: BorderSide(color: chat.separator.withValues(alpha: .8)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.p20,
                    Sizes.p16,
                    Sizes.p12,
                    Sizes.p16,
                  ),
                  decoration: BoxDecoration(
                    color: chat.listSurface,
                    border: Border(bottom: BorderSide(color: chat.separator)),
                  ),
                  child: Row(
                    children: [
                      if (leading != null) ...[leading!, Gaps.w12],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(title, style: titleStyle),
                            if (subtitle case final value?) ...[
                              const SizedBox(height: Sizes.p4),
                              Text(value, style: subtitleStyle),
                            ],
                          ],
                        ),
                      ),
                      if (showCloseButton)
                        IconButton(
                          tooltip: context.l10n.frameworkClose,
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Symbols.close),
                          color: chat.metadataText,
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight - 132),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Sizes.p20),
                    child: SizedBox(width: double.infinity, child: content),
                  ),
                ),
                if (actions.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p20,
                      vertical: Sizes.p12,
                    ),
                    decoration: BoxDecoration(
                      color: chat.listSurface,
                      border: Border(top: BorderSide(color: chat.separator)),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: Sizes.p8,
                      runSpacing: Sizes.p8,
                      children: actions,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
