import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Uniwersalny komponent szybkiego wprowadzania tytułu zadania / podzadania (inline create input).
///
/// Zapewnia elegancki, dopracowany wygląd (ClickUp / Linear style):
/// - Delikatne zaokrąglone tło z subtelną ramką i focus-ringiem.
/// - Ikonka plusa lub dedykowana wiodąca kontrolka.
/// - Obsługa klawiatury: `Escape` wywołuje anulowanie, `Enter` zatwierdza formularz.
/// - Obsługa wskaźnika asynchronicznego zapisu (`isSubmitting`).
/// - Opcjonalny przycisk akcji po prawej stronie (np. wybór szablonu, przycisk submit).
class TaskInlineInputField extends StatelessWidget {
  /// Tworzy pole inline create input.
  const TaskInlineInputField({
    required this.controller,
    required this.hintText,
    required this.onCancel,
    required this.onSubmit,
    this.autofocus = true,
    this.isSubmitting = false,
    this.leadingIcon,
    this.trailing,
    this.keyboardHint,
    this.dense = false,
    this.fillColor,
    this.borderRadius = 8.0,
    super.key,
  });

  /// Kontroler edycji tekstu.
  final TextEditingController controller;

  /// Tekst zastępczy (placeholder).
  final String hintText;

  /// Callback anulowania (np. klawisz Escape lub kliknięcie poza obszarem).
  final VoidCallback onCancel;

  /// Asynchroniczny callback zatwierdzenia tytułu (klawisz Enter lub przycisk akcji).
  final Future<void> Function() onSubmit;

  /// Czy pole ma natychmiast otrzymać fokus.
  final bool autofocus;

  /// Czy trwa zapis zadania do backendu (blokuje edycję i pokazuje spinner).
  final bool isSubmitting;

  /// Opcjonalna wiodąca ikona (domyślnie [Symbols.add_rounded]).
  final Widget? leadingIcon;

  /// Opcjonalny widget na końcu wiersza (np. przycisk szablonu lub submit).
  final Widget? trailing;

  /// Opcjonalna podpowiedź klawiszowa (np. `Enter to save, Esc to cancel`).
  final String? keyboardHint;

  /// Kompaktowy wariant o mniejszym paddingu (np. do miniaturowych podzadań).
  final bool dense;

  /// Opcjonalne niestandardowe tło kontenera.
  final Color? fillColor;

  /// Promień zaokrąglenia narożników.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bg = fillColor ?? colors.surfaceContainerLow;

    return Focus(
      onKeyEvent: (_, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape &&
            !isSubmitting) {
          onCancel();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: colors.primary.withValues(alpha: .35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: .06),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 6 : 8,
          vertical: dense ? 2 : 4,
        ),
        child: Row(
          children: [
            leadingIcon ??
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 6),
                  child: Icon(
                    Symbols.add_rounded,
                    size: dense ? 15 : 18,
                    color: colors.primary,
                  ),
                ),
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: autofocus,
                enabled: !isSubmitting,
                style:
                    (dense ? context.text.bodySmall : context.text.bodyMedium)
                        ?.copyWith(fontWeight: FontWeight.w600),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!isSubmitting) unawaited(onSubmit());
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText: hintText,
                  hintStyle:
                      (dense ? context.text.bodySmall : context.text.bodyMedium)
                          ?.copyWith(
                            color: colors.onSurfaceVariant.withValues(
                              alpha: .55,
                            ),
                          ),
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: dense ? 4 : 6,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            if (isSubmitting)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox.square(
                  dimension: dense ? 13 : 16,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else ...[
              if (keyboardHint != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    keyboardHint!,
                    style: context.text.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant.withValues(alpha: .6),
                      fontSize: 10,
                    ),
                  ),
                ),
              ?trailing,
            ],
          ],
        ),
      ),
    );
  }
}
