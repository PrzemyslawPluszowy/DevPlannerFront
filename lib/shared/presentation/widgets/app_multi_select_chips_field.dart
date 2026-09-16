import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Opcja wyboru dla [AppMultiSelectChipsField].
class AppMultiSelectChipsOption<T> {
  /// Tworzy pojedyncza opcje wyboru.
  const AppMultiSelectChipsOption({
    required this.value,
    required this.label,
  });

  /// Wewnętrzna wartość opcji.
  final T value;

  /// Tekst prezentowany w interfejsie.
  final String label;
}

/// Pole wielokrotnego wyboru: dropdown "dodaj" + wybrane elementy jako chipy.
class AppMultiSelectChipsField<T> extends StatelessWidget {
  /// Tworzy pole wielokrotnego wyboru z prezentacja chipow.
  const AppMultiSelectChipsField({
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    super.key,
    this.labelText,
    this.hintText,
    this.emptySelectionText,
    this.isRequired = false,
    this.enabled = true,
    this.errorText,
  });

  /// Dostępne opcje wyboru.
  final List<AppMultiSelectChipsOption<T>> options;

  /// Aktualnie wybrane wartości.
  final List<T> selectedValues;

  /// Callback emitujący pełną listę aktualnych wyborów.
  final ValueChanged<List<T>> onChanged;

  /// Etykieta pola nad dropdownem.
  final String? labelText;

  /// Podpowiedź dla dropdowna dodawania.
  final String? hintText;

  /// Tekst zastępczy, gdy nic nie wybrano.
  final String? emptySelectionText;

  /// Czy pole jest wymagane.
  final bool isRequired;

  /// Czy pole jest aktywne.
  final bool enabled;

  /// Komunikat błędu walidacji.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final selectedSet = selectedValues.toSet();
    final selectedOptions = options
        .where((option) => selectedSet.contains(option.value))
        .toList(growable: false);
    final availableOptions = options
        .where((option) => !selectedSet.contains(option.value))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        AppDropdown<T>(
          value: null,
          variant: .filled,
          labelText: labelText,
          hintText: hintText,
          isRequired: isRequired,
          enabled: enabled,
          errorText: errorText,
          options: availableOptions
              .map(
                (option) => AppDropdownOption<T>(
                  value: option.value,
                  label: option.label,
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            final next = [...selectedValues, value];
            onChanged(next);
          },
        ),
        if (selectedOptions.isNotEmpty) ...[
          Gaps.h8,
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: selectedOptions
                .map(
                  (option) => AppActionChip(
                    label: option.label,
                    icon: Icons.close_rounded,
                    onPressed: enabled
                        ? () {
                            final next = selectedValues
                                .where((value) => value != option.value)
                                .toList(growable: false);
                            onChanged(next);
                          }
                        : null,
                  ),
                )
                .toList(growable: false),
          ),
        ] else if ((emptySelectionText ?? '').trim().isNotEmpty) ...[
          Gaps.h8,
          AppText(
            emptySelectionText!.trim(),
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
