import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wizualne metadane typu pola niestandardowego: ikona, kolor przewodni, etykieta i opis.
class CustomFieldTypeVisual {
  const CustomFieldTypeVisual({
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
  });

  /// Ikona symbolizująca typ pola.
  final IconData icon;

  /// Kolor akcentujący dany typ.
  final Color color;

  /// Czytelna, skrócona polska nazwa typu.
  final String label;

  /// Krótkie objaśnienie zastosowania pola.
  final String description;
}

/// Zwraca spójne ikony i kolory dla typów pól niestandardowych.
class CustomFieldTypeVisualCatalog {
  const CustomFieldTypeVisualCatalog._();

  static CustomFieldTypeVisual forType(TaskCustomFieldType type) =>
      switch (type) {
        TaskCustomFieldType.text => const CustomFieldTypeVisual(
          icon: Symbols.short_text_rounded,
          color: Color(0xFF3B82F6),
          label: 'Tekst',
          description: 'Pojedyncza linia tekstu lub notatka',
        ),
        TaskCustomFieldType.number => const CustomFieldTypeVisual(
          icon: Symbols.tag_rounded,
          color: Color(0xFF10B981),
          label: 'Liczba',
          description: 'Wartość numeryczna, budżet lub kwota',
        ),
        TaskCustomFieldType.date => const CustomFieldTypeVisual(
          icon: Symbols.calendar_today_rounded,
          color: Color(0xFFF59E0B),
          label: 'Data',
          description: 'Termin lub data kalendarzowa',
        ),
        TaskCustomFieldType.boolean => const CustomFieldTypeVisual(
          icon: Symbols.check_box_rounded,
          color: Color(0xFF06B6D4),
          label: 'Tak / Nie',
          description: 'Przełącznik logiczny checkbox',
        ),
        TaskCustomFieldType.singleSelect => const CustomFieldTypeVisual(
          icon: Symbols.arrow_drop_down_circle_rounded,
          color: Color(0xFF8B5CF6),
          label: 'Wybór pojedynczy',
          description: 'Wybór jednej opcji z predefiniowanej listy',
        ),
        TaskCustomFieldType.multiSelect => const CustomFieldTypeVisual(
          icon: Symbols.rule_rounded,
          color: Color(0xFFEC4899),
          label: 'Wybór wielokrotny',
          description: 'Zaznaczenie wielu wartości z listy',
        ),
        TaskCustomFieldType.user => const CustomFieldTypeVisual(
          icon: Symbols.person_rounded,
          color: Color(0xFF6366F1),
          label: 'Użytkownik',
          description: 'Wskazanie członka projektu',
        ),
      };
}
