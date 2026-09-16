import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';

/// Predefiniowana paleta kolorów dla opcji pól wyboru.
const customFieldOptionColors = <(String hex, String name, Color color)>[
  ('#EF4444', 'Czerwony', Color(0xFFEF4444)),
  ('#F97316', 'Pomarańczowy', Color(0xFFF97316)),
  ('#F59E0B', 'Bursztynowy', Color(0xFFF59E0B)),
  ('#10B981', 'Zielony', Color(0xFF10B981)),
  ('#059669', 'Szmaragdowy', Color(0xFF059669)),
  ('#06B6D4', 'Cyjan', Color(0xFF06B6D4)),
  ('#3B82F6', 'Niebieski', Color(0xFF3B82F6)),
  ('#6366F1', 'Indygo', Color(0xFF6366F1)),
  ('#8B5CF6', 'Fioletowy', Color(0xFF8B5CF6)),
  ('#EC4899', 'Różowy', Color(0xFFEC4899)),
  ('#F43F5E', 'Karminowy', Color(0xFFF43F5E)),
  ('#64748B', 'Szary', Color(0xFF64748B)),
];

/// Predefiniowany zestaw ikon dla opcji pól wyboru.
const customFieldOptionIcons = <(String name, String label, IconData icon)>[
  ('flag', 'Flaga', Symbols.flag_rounded),
  ('star', 'Gwiazdka', Symbols.star_rounded),
  ('check_circle', 'Sukces', Symbols.check_circle_rounded),
  ('schedule', 'Czas', Symbols.schedule_rounded),
  ('bookmark', 'Zakładka', Symbols.bookmark_rounded),
  ('bolt', 'Błyskawica', Symbols.bolt_rounded),
  ('warning', 'Ostrzeżenie', Symbols.warning_amber_rounded),
  ('bug_report', 'Błąd', Symbols.bug_report_rounded),
  ('label', 'Etykieta', Symbols.label_rounded),
  ('lightbulb', 'Pomysł', Symbols.lightbulb_rounded),
  ('verified', 'Zweryfikowane', Symbols.verified_rounded),
  ('favorite', 'Serce', Symbols.favorite_rounded),
  ('fire', 'Ogień', Symbols.local_fire_department_rounded),
  ('priority_high', 'Priorytet', Symbols.priority_high_rounded),
  ('category', 'Kategoria', Symbols.category_rounded),
  ('trending_up', 'Wzrost', Symbols.trending_up_rounded),
  ('folder', 'Folder', Symbols.folder_rounded),
  ('circle', 'Kropka', Symbols.circle),
];

/// Pomocnik zamieniający kod szesnastkowy na obiekt [Color].
Color? parseHexColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  var clean = hex.replaceAll('#', '').trim();
  if (clean.length == 6) clean = 'FF$clean';
  final value = int.tryParse(clean, radix: 16);
  return value != null ? Color(value) : null;
}

/// Pomocnik zamieniający identyfikator ikony na odpowiedni [IconData].
IconData? customFieldOptionIcon(String? iconName) {
  if (iconName == null || iconName.isEmpty) return null;
  return switch (iconName) {
    'flag' => Symbols.flag_rounded,
    'star' => Symbols.star_rounded,
    'check_circle' => Symbols.check_circle_rounded,
    'schedule' => Symbols.schedule_rounded,
    'bookmark' => Symbols.bookmark_rounded,
    'bolt' => Symbols.bolt_rounded,
    'warning' => Symbols.warning_amber_rounded,
    'bug_report' => Symbols.bug_report_rounded,
    'label' => Symbols.label_rounded,
    'lightbulb' => Symbols.lightbulb_rounded,
    'verified' => Symbols.verified_rounded,
    'favorite' => Symbols.favorite_rounded,
    'fire' || 'local_fire_department' => Symbols.local_fire_department_rounded,
    'priority_high' => Symbols.priority_high_rounded,
    'category' => Symbols.category_rounded,
    'trending_up' => Symbols.trending_up_rounded,
    'folder' => Symbols.folder_rounded,
    'circle' => Symbols.circle,
    _ => null,
  };
}

/// Struktura i logika opcji pól wyboru (SingleSelect / MultiSelect).
class CustomFieldOption {
  const CustomFieldOption({
    required this.raw,
    required this.label,
    this.colorHex,
    this.iconName,
  });

  /// Parsuje ciąg znaków z backendu (wspiera format JSON oraz prosty tekst/delimiter).
  factory CustomFieldOption.fromRaw(String raw) {
    final trimmed = raw.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) {
          return CustomFieldOption(
            raw: raw,
            label: (decoded['label'] as String?)?.trim() ?? raw,
            colorHex: decoded['color'] as String?,
            iconName: decoded['icon'] as String?,
          );
        }
      } catch (_) {
        // Fallback do surowego tekstu
      }
    }
    if (trimmed.contains('::')) {
      final parts = trimmed.split('::');
      return CustomFieldOption(
        raw: raw,
        label: parts[0].trim(),
        colorHex: parts.length > 1 && parts[1].trim().isNotEmpty
            ? parts[1].trim()
            : null,
        iconName: parts.length > 2 && parts[2].trim().isNotEmpty
            ? parts[2].trim()
            : null,
      );
    }
    return CustomFieldOption(raw: raw, label: trimmed);
  }

  /// Tworzy nową opcję i przygotowuje surową reprezentację gotową do zapisu.
  factory CustomFieldOption.create({
    required String label,
    String? colorHex,
    String? iconName,
  }) {
    final trimmedLabel = label.trim();
    final cleanColor = colorHex?.trim().isEmpty == true
        ? null
        : colorHex?.trim();
    final cleanIcon = iconName?.trim().isEmpty == true
        ? null
        : iconName?.trim();

    if (cleanColor == null && cleanIcon == null) {
      return CustomFieldOption(raw: trimmedLabel, label: trimmedLabel);
    }
    final map = <String, dynamic>{
      'label': trimmedLabel,
      'color': ?cleanColor,
      'icon': ?cleanIcon,
    };
    return CustomFieldOption(
      raw: jsonEncode(map),
      label: trimmedLabel,
      colorHex: cleanColor,
      iconName: cleanIcon,
    );
  }

  /// Surowy ciąg zapisywany w bazie danych.
  final String raw;

  /// Czytelna nazwa opcji.
  final String label;

  /// Opcjonalny kod koloru hex (#RRGGBB).
  final String? colorHex;

  /// Opcjonalny klucz ikony.
  final String? iconName;

  /// Obliczony obiekt [Color] lub null.
  Color? get color => parseHexColor(colorHex);

  /// Obliczony obiekt [IconData] lub null.
  IconData? get icon => customFieldOptionIcon(iconName);

  CustomFieldOption copyWith({
    String? label,
    String? colorHex,
    String? iconName,
    bool clearColor = false,
    bool clearIcon = false,
  }) => CustomFieldOption.create(
    label: label ?? this.label,
    colorHex: clearColor ? null : colorHex ?? this.colorHex,
    iconName: clearIcon ? null : iconName ?? this.iconName,
  );
}

/// Nowoczesny chip reprezentujący opcję pola niestandardowego z jej kolorem i ikoną.
class CustomFieldOptionChip extends StatelessWidget {
  const CustomFieldOptionChip({
    required this.option,
    this.onDelete,
    this.isSelected = false,
    this.compact = false,
    super.key,
  });

  final CustomFieldOption option;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final optColor = option.color;
    final optIcon = option.icon;

    final bgColor = optColor != null
        ? optColor.withValues(alpha: isSelected ? .22 : .12)
        : (isSelected
              ? colors.primaryContainer.withValues(alpha: .5)
              : colors.surfaceContainerHigh);

    final borderColor = optColor != null
        ? optColor.withValues(alpha: isSelected ? .6 : .25)
        : (isSelected
              ? colors.primary.withValues(alpha: .5)
              : Colors.transparent);

    final textColor = optColor != null
        ? (ThemeData.estimateBrightnessForColor(colors.surface) ==
                  Brightness.dark
              ? Color.lerp(optColor, Colors.white, 0.25)!
              : Color.lerp(optColor, Colors.black, 0.25)!)
        : colors.onSurface;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (optIcon != null) ...[
            Icon(
              optIcon,
              size: compact ? 13 : 15,
              color: optColor ?? textColor,
            ),
            SizedBox(width: compact ? 4 : 5),
          ],
          Flexible(
            child: Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.close_rounded,
                  size: 13,
                  color: textColor.withValues(alpha: .7),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
