import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_form/bhp_equipment_form_controller.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_form_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

/// Współdzielony formularz karty wyposażenia BHP.
class BhpEquipmentForm extends StatelessWidget {
  /// Tworzy współdzielony formularz wyposażenia.
  const BhpEquipmentForm({
    required this.controller,
    required this.title,
    required this.description,
    required this.submitLabel,
    required this.submitIcon,
    required this.onSubmit,
    super.key,
    this.submitError,
    this.isSubmitting = false,
  });

  /// Kontroler danych formularza.
  final BhpEquipmentFormController controller;

  /// Tytuł sekcji formularza.
  final String title;

  /// Opis sekcji formularza.
  final String description;

  /// Etykieta przycisku zapisu.
  final String submitLabel;

  /// Ikona przycisku zapisu.
  final IconData submitIcon;

  /// Błąd walidacji lub zapisu zwrócony z backendu.
  final String? submitError;

  /// Czy formularz jest w trakcie wysyłki.
  final bool isSubmitting;

  /// Callback zapisu formularza.
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          AppFormSection(
            title: title,
            description: description,
            desktopColumns: 2,
            items: [
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.symbolController,
                  variant: .filled,
                  labelText: context.l10n.bhpTableSymbol,
                  isRequired: true,
                  enabled: !isSubmitting,
                  validators: [AppValidators.required()],
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.nazwaController,
                  variant: .filled,
                  labelText: context.l10n.bhpTableEquipment,
                  isRequired: true,
                  enabled: !isSubmitting,
                  validators: [AppValidators.required()],
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.jmController,
                  variant: .filled,
                  labelText: context.l10n.bhpTableUnit,
                  enabled: !isSubmitting,
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.okresUzywalnosciController,
                  variant: .filled,
                  labelText: context.l10n.bhpTablePeriod,
                  enabled: !isSubmitting,
                  validators: [AppValidators.positiveInteger()],
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.iloscDomyslnaController,
                  variant: .filled,
                  labelText: context.l10n.bhpTableDefaultQuantity,
                  enabled: !isSubmitting,
                  validators: [AppValidators.nonNegativeNumber()],
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.cenaController,
                  variant: .filled,
                  labelText: context.l10n.bhpTablePrice,
                  enabled: !isSubmitting,
                  validators: [AppValidators.nonNegativeNumber()],
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.ekwiwalentController,
                  variant: .filled,
                  labelText: 'Ekwiwalent',
                  enabled: !isSubmitting,
                  validators: [AppValidators.nonNegativeNumber()],
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.procentPrzydatnosciController,
                  variant: .filled,
                  labelText: 'Procent przydatności',
                  enabled: !isSubmitting,
                  validators: [
                    AppValidators.nonNegativeInteger(),
                  ],
                ),
              ),
              AppFormSectionItem(
                desktopSpan: 2,
                child: AppTextField(
                  controller: controller.nrDowoduWydaniaController,
                  variant: .filled,
                  labelText: 'Numer dowodu wydania',
                  enabled: !isSubmitting,
                ),
              ),
            ],
          ),
          if (submitError case final message?
              when message.trim().isNotEmpty) ...[
            Gaps.h12,
            AppText(
              message,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.error,
                fontWeight: .w600,
              ),
            ),
          ],
          Gaps.h16,
          Row(
            mainAxisAlignment: .end,
            children: [
              AppActionButton.text(
                label: context.l10n.cancel,
                icon: Icons.close_rounded,
                tone: .neutral,
                onPressed: isSubmitting
                    ? null
                    : () => Navigator.of(context).pop(),
              ),
              Gaps.w8,
              AppActionButton.filled(
                label: submitLabel,
                icon: submitIcon,
                onPressedAsync: isSubmitting ? null : onSubmit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
