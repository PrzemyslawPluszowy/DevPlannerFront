import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_dialog_color_hex_codec.dart';
import 'package:flutter/material.dart';

/// Ton małego znacznika podglądu.
enum ProjectPreviewTone {
  /// Informacja neutralna, np. liczba etykiet.
  neutral,

  /// Akcent projektu albo statusu.
  accent,

  /// Ostrzeżenie albo brak danych.
  warning,

  /// Błąd pobrania.
  error,
}

/// Kolor zapisany w kontrakcie, bezpiecznie zamieniony na kolor motywu.
///
/// Niepoprawny HEX nigdy nie kończy się wyjątkiem — podgląd używa wtedy koloru
/// motywu, żeby decyzja użytkownika nie zależała od jakości danych szablonu.
Color projectPreviewColor(String? hex, Color fallback) =>
    ProjectDialogColorHexCodec.toColor(hex) ?? fallback;

/// Mały znacznik podglądu: ikona i krótka wartość.
class ProjectPreviewBadge extends StatelessWidget {
  /// Tworzy znacznik podglądu.
  const ProjectPreviewBadge({
    required this.label,
    this.icon,
    this.tone = ProjectPreviewTone.neutral,
    super.key,
  });

  /// Tekst znacznika.
  final String label;

  /// Opcjonalna ikona znacznika.
  final IconData? icon;

  /// Ton kolorystyczny znacznika.
  final ProjectPreviewTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      ProjectPreviewTone.neutral => (
        colors.surfaceContainerHighest,
        colors.onSurfaceVariant,
      ),
      ProjectPreviewTone.accent => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      ProjectPreviewTone.warning => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
      ),
      ProjectPreviewTone.error => (
        colors.errorContainer,
        colors.onErrorContainer,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p8,
        vertical: Sizes.p4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon case final value?) ...[
            Icon(value, size: 13, color: foreground),
            Gaps.w4,
          ],
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Notka podglądu: stan pusty, brak danych albo błąd z akcją ponowienia.
class ProjectPreviewNote extends StatelessWidget {
  /// Tworzy notkę podglądu.
  const ProjectPreviewNote({
    required this.title,
    this.body,
    this.icon,
    this.tone = ProjectPreviewTone.neutral,
    this.action,
    super.key,
  });

  /// Krótki nagłówek notki.
  final String title;

  /// Dłuższe wyjaśnienie pod nagłówkiem.
  final String? body;

  /// Ikona notki.
  final IconData? icon;

  /// Ton kolorystyczny notki.
  final ProjectPreviewTone tone;

  /// Akcja naprawcza, np. ponowienie pobrania.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      ProjectPreviewTone.neutral => (
        colors.surfaceContainerHighest,
        colors.onSurfaceVariant,
      ),
      ProjectPreviewTone.accent => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      ProjectPreviewTone.warning => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
      ),
      ProjectPreviewTone.error => (
        colors.errorContainer,
        colors.onErrorContainer,
      ),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon case final value?) ...[
                Icon(value, size: 16, color: foreground),
                Gaps.w8,
              ],
              Expanded(
                child: Text(
                  title,
                  style: context.text.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
          if (body case final value?) ...[
            Gaps.h4,
            Text(
              value,
              style: context.text.bodySmall?.copyWith(color: foreground),
            ),
          ],
          if (action case final value?) ...[Gaps.h8, value],
        ],
      ),
    );
  }
}
