import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_shimmer.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_visual_helpers.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nowoczesny, zunifikowany wrapper dla wszystkich ekranów i funkcji w module Workspaces.
///
/// Zapewnia spójny nagłówek z ikoną funkcji, metadanymi, akcjami oraz wbudowaną
/// obsługą stanów ładowania (Shimmer), błędów (Error view z retry) i pustych danych (Empty state).
class WorkspaceFeatureWrapper extends StatelessWidget {
  const WorkspaceFeatureWrapper({
    required this.title,
    required this.icon,
    super.key,
    this.subtitle,
    this.accentColor,
    this.badgeText,
    this.actions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.isEmpty = false,
    this.emptyTitle = 'Brak danych',
    this.emptyMessage =
        'Nie znaleziono jeszcze żadnych elementów w tej sekcji.',
    this.emptyAction,
    this.scrollable = true,
    this.padding = const EdgeInsets.all(Sizes.p20),
    this.child,
  });

  /// Główny tytuł widoku (np. 'Zadania', 'Baza wiedzy Wiki').
  final String title;

  /// Główna ikona identyfikująca daną funkcję.
  final IconData icon;

  /// Opcjonalny opis tekstowy pod tytułem.
  final String? subtitle;

  /// Opcjonalny kolor akcentowy (jeśli brak, wyliczany z kontekstu).
  final Color? accentColor;

  /// Opcjonalny tekst etykiety/badge obok tytułu (np. '14 aktywnych', 'Pro').
  final String? badgeText;

  /// Przyciski akcji umieszczane po prawej stronie paska nagłówka.
  final List<Widget> actions;

  /// Flaga sygnalizująca stan ładowania danych (renderuje Shimmer).
  final bool isLoading;

  /// Komunikat błędu (jeśli wystąpił).
  final String? errorMessage;

  /// Callback ponowienia zapytania w przypadku wystąpienia błędu.
  final VoidCallback? onRetry;

  /// Flaga pustego stanu po poprawnym pobraniu danych.
  final bool isEmpty;

  /// Tytuł pustego stanu.
  final String emptyTitle;

  /// Treść opisowa pustego stanu.
  final String emptyMessage;

  /// Opcjonalny przycisk akcji w stanie pustym (np. 'Dodaj pierwsze zadanie').
  final Widget? emptyAction;

  /// Czy główna zawartość powinna być opakowana w [SingleChildScrollView].
  final bool scrollable;

  /// Odstępy wewnętrzne dla treści.
  final EdgeInsetsGeometry padding;

  /// Właściwa treść ekranu.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor =
        accentColor ?? WorkspaceVisualHelpers.resourceColor(context, title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Górny nagłówek funkcji
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p20,
            vertical: Sizes.p12,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: .08)
                    : colors.outlineVariant.withValues(alpha: .5),
                width: 1.1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Kolorowa plakietka z ikoną
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: isDark ? .22 : .12),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                  border: Border.all(
                    color: effectiveColor.withValues(alpha: isDark ? .42 : .28),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: effectiveColor,
                ),
              ),
              Gaps.w12,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badgeText case final badge?) ...[
                          Gaps.w8,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.p8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: effectiveColor.withValues(
                                alpha: isDark ? .18 : .10,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              border: Border.all(
                                color: effectiveColor.withValues(alpha: .3),
                              ),
                            ),
                            child: Text(
                              badge,
                              style: context.text.labelSmall?.copyWith(
                                color: effectiveColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (subtitle case final sub?) ...[
                      Gaps.h2,
                      Text(
                        sub,
                        style: context.text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (actions.isNotEmpty) ...[
                Gaps.w12,
                Wrap(
                  spacing: Sizes.p8,
                  runSpacing: Sizes.p8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: actions,
                ),
              ],
            ],
          ),
        ),

        // Obszar roboczy z obsługą stanów
        Expanded(
          child: _buildBody(context),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return const AppShimmerContent();
    }

    if (errorMessage case final error?) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Symbols.error_outline_rounded,
                  size: 44,
                  color: context.colors.error,
                ),
                Gaps.h12,
                Text(
                  'Wystąpił błąd',
                  style: context.text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.h8,
                Text(
                  error,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (onRetry != null) ...[
                  Gaps.h16,
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Symbols.refresh_rounded, size: 18),
                    label: const Text('Spróbuj ponownie'),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    if (isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (accentColor ?? context.colors.primary).withValues(
                      alpha: .12,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: accentColor ?? context.colors.primary,
                  ),
                ),
                Gaps.h16,
                Text(
                  emptyTitle,
                  style: context.text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.h8,
                Text(
                  emptyMessage,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (emptyAction case final action?) ...[
                  Gaps.h20,
                  action,
                ],
              ],
            ),
          ),
        ),
      );
    }

    final content = child ?? const SizedBox.shrink();
    if (scrollable) {
      return SingleChildScrollView(
        padding: padding,
        child: content,
      );
    }

    return Padding(
      padding: padding,
      child: content,
    );
  }
}
