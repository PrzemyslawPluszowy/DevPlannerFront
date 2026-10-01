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
class WorkspaceCreationModalWrapper extends StatefulWidget {
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
    this.onBeforeClose,
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

  /// Optional asynchronous guard used by task-detail editor forms.
  final Future<bool> Function()? onBeforeClose;

  @override
  State<WorkspaceCreationModalWrapper> createState() =>
      _WorkspaceCreationModalWrapperState();
}

class _WorkspaceCreationModalWrapperState
    extends State<WorkspaceCreationModalWrapper> {
  bool _allowPop = false;
  bool _checkingClose = false;

  Future<void> _requestClose() async {
    if (widget.isSubmitting || _checkingClose) return;
    final route = ModalRoute.of(context);
    if (route?.isCurrent != true) return;
    final guard = widget.onBeforeClose;
    if (guard == null) {
      Navigator.of(context).pop();
      return;
    }
    _checkingClose = true;
    final canClose = await guard();
    if (!mounted) return;
    _checkingClose = false;
    if (!canClose || route?.isCurrent != true) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && route?.isCurrent == true) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final widget = this.widget;
    final colors = context.colors;
    final tasks = context.tasksTheme;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = widget.accentColor ?? colors.primary;
    final effectiveSubmitLabel =
        widget.submitLabel ?? l10n.workspacesCreateButton;
    final effectiveCancelLabel =
        widget.cancelLabel ?? l10n.workspacesCancelButton;

    final dialog = Dialog(
      backgroundColor: tasks.canvas,
      elevation: 8,
      shadowColor: tasks.shadow.withValues(alpha: isDark ? .4 : .12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tasks.panelRadius),
        side: BorderSide(color: tasks.canvasBorder),
      ),
      insetPadding: const .symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
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
                  if (widget.icon case final iconData?) ...[
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
                          widget.title,
                          style: context.text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (widget.subtitle case final sub?) ...[
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
                    onPressed: widget.isSubmitting ? null : _requestClose,
                    icon: const Icon(Symbols.close_rounded, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: tasks.divider,
            ),

            // 2. Przewijalna treść formularza
            Flexible(
              child: SingleChildScrollView(
                padding: const .all(Sizes.p20),
                child: widget.body,
              ),
            ),

            Divider(
              height: 1,
              color: tasks.divider,
            ),

            // 3. Stopka akcji z przyciskami
            Padding(
              padding: const .symmetric(
                horizontal: Sizes.p20,
                vertical: Sizes.p12,
              ),
              child: Row(
                children: [
                  if (widget.additionalActions case final actions?) ...[
                    ...actions,
                    const Spacer(),
                  ] else
                    const Spacer(),
                  TextButton(
                    onPressed: widget.isSubmitting ? null : _requestClose,
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
                    onPressed: widget.isSubmitting || widget.onSubmit == null
                        ? null
                        : () => widget.onSubmit!(),
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
                    child: widget.isSubmitting
                        ? SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: tasks.onAccent,
                            ),
                          )
                        : Text(
                            effectiveSubmitLabel,
                            style: context.tasksTheme.controlText.copyWith(
                              color: tasks.onAccent,
                            ),
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
          if (!widget.isSubmitting) unawaited(_requestClose());
        },
      },
      child: Focus(
        autofocus: true,
        child: PopScope<void>(
          canPop: widget.onBeforeClose == null || _allowPop,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && widget.onBeforeClose != null) {
              unawaited(_requestClose());
            }
          },
          child: dialog,
        ),
      ),
    );
  }
}
