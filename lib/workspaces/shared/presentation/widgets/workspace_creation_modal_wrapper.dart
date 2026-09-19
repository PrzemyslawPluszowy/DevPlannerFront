import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nowoczesny webowo-desktopowy wrapper modala formularza tworzenia zasobów.
///
/// Zapewnia spójny wizualnie nagłówek z podglądem ikony i koloru,
/// przewijalną zawartość oraz stopkę z przyciskami i wskaźnikiem ładowania.
class WorkspaceCreationModalWrapper extends StatelessWidget {
  const WorkspaceCreationModalWrapper({
    required this.title,
    required this.body,
    this.onSubmit,
    this.subtitle,
    this.icon,
    this.accentColor,
    this.submitLabel,
    this.cancelLabel,
    this.additionalActions,
    this.isSubmitting = false,
    this.maxWidth = 480,
    super.key,
  });

  /// Opcjonalne dodatkowe akcje umieszczane po lewej stronie stopki.
  final List<Widget>? additionalActions;

  /// Tytuł modala.
  final String title;

  /// Opcjonalny podtytuł / opis modala.
  final String? subtitle;

  /// Ikona prezentacyjna w nagłówku.
  final IconData? icon;

  /// Kolor akcentu dla nagłówka i przycisku zatwierdzenia.
  final Color? accentColor;

  /// Treść formularza.
  final Widget body;

  /// Callback zatwierdzenia formularza.
  final FutureOr<void> Function()? onSubmit;

  /// Etykieta przycisku zatwierdzenia (domyślnie z l10n).
  final String? submitLabel;

  /// Etykieta przycisku anulowania (domyślnie z l10n).
  final String? cancelLabel;

  /// Czy trwa asynchroniczne wysyłanie formularza.
  final bool isSubmitting;

  /// Maksymalna szerokość okna dialogowego.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = accentColor ?? colors.primary;
    final effectiveSubmitLabel = submitLabel ?? l10n.workspacesCreateButton;
    final effectiveCancelLabel = cancelLabel ?? l10n.workspacesCancelButton;

    final dialog = Dialog(
      backgroundColor: colors.surfaceContainerLowest,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: isDark ? .4 : .12),
      shape: RoundedRectangleBorder(
        borderRadius: const .all(.circular(16)),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: .12)
              : colors.outlineVariant.withValues(alpha: .4),
        ),
      ),
      insetPadding: const .symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            // 1. Nowoczesny nagłówek z podglądem ikony i przyciskiem zamknięcia
            Padding(
              padding: const .fromLTRB(
                Sizes.p20,
                Sizes.p20,
                Sizes.p16,
                Sizes.p12,
              ),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  if (icon case final iconData?) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: .14),
                        borderRadius: const .all(.circular(12)),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: .3),
                        ),
                      ),
                      alignment: .center,
                      child: Icon(
                        iconData,
                        size: 22,
                        color: primaryColor,
                      ),
                    ),
                    Gaps.w12,
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          title,
                          style: context.text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (subtitle case final sub?) ...[
                          Gaps.h2,
                          Text(
                            sub,
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.close,
                    onPressed: isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Symbols.close_rounded, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: .08)
                  : colors.outlineVariant.withValues(alpha: .3),
            ),

            // 2. Przewijalna treść formularza
            Flexible(
              child: SingleChildScrollView(
                padding: const .all(Sizes.p20),
                child: body,
              ),
            ),

            Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: .08)
                  : colors.outlineVariant.withValues(alpha: .3),
            ),

            // 3. Stopka akcji z przyciskami
            Padding(
              padding: const .symmetric(
                horizontal: Sizes.p20,
                vertical: Sizes.p12,
              ),
              child: Row(
                children: [
                  if (additionalActions case final actions?) ...[
                    ...actions,
                    const Spacer(),
                  ] else
                    const Spacer(),
                  TextButton(
                    onPressed: isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const .symmetric(
                        horizontal: Sizes.p16,
                        vertical: Sizes.p10,
                      ),
                    ),
                    child: Text(effectiveCancelLabel),
                  ),
                  Gaps.w8,
                  FilledButton(
                    onPressed: isSubmitting || onSubmit == null
                        ? null
                        : () => onSubmit!(),
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const .symmetric(
                        horizontal: Sizes.p20,
                        vertical: Sizes.p10,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: .all(.circular(8)),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            effectiveSubmitLabel,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (!isSubmitting) Navigator.of(context).pop();
        },
      },
      child: Focus(
        autofocus: true,
        child: dialog,
      ),
    );
  }
}
