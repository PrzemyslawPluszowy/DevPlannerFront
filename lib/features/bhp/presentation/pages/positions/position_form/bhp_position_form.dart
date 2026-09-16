import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_form/bhp_position_form_controller.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_form_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

/// Współdzielony formularz stanowiska BHP.
class BhpPositionForm extends StatelessWidget {
  /// Tworzy współdzielony formularz stanowiska.
  const BhpPositionForm({
    required this.controller,
    required this.title,
    required this.description,
    required this.submitLabel,
    required this.submitIcon,
    required this.onSubmit,
    super.key,
    this.submitError,
    this.isSubmitting = false,
    this.secondarySubmitLabel,
    this.secondarySubmitIcon,
    this.onSecondarySubmit,
    this.showActions = true,
  });

  /// Kontroler danych formularza.
  final BhpPositionFormController controller;

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

  /// Opcjonalna etykieta dodatkowej akcji zapisu.
  final String? secondarySubmitLabel;

  /// Opcjonalna ikona dodatkowej akcji zapisu.
  final IconData? secondarySubmitIcon;

  /// Opcjonalny callback dodatkowej akcji zapisu.
  final Future<void> Function()? onSecondarySubmit;

  /// Czy renderować dolny wiersz akcji formularza.
  final bool showActions;

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
                desktopSpan: 2,
                child: AppTextField(
                  controller: controller.nameController,
                  variant: .filled,
                  labelText: context.l10n.bhpTablePosition,
                  isRequired: true,
                  enabled: !isSubmitting,
                  validators: [AppValidators.required()],
                ),
              ),
              AppFormSectionItem(
                desktopSpan: 2,
                child: AppTextField(
                  controller: controller.notesController,
                  variant: .filled,
                  labelText: context.l10n.bhpTableNotes,
                  enabled: !isSubmitting,
                  maxLines: 4,
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
          if (showActions) ...[
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                if (secondarySubmitLabel case final label?
                    when onSecondarySubmit != null) ...[
                  AppActionButton.outlined(
                    label: label,
                    icon: secondarySubmitIcon ?? Icons.tune_rounded,
                    onPressedAsync: isSubmitting ? null : onSecondarySubmit,
                  ),
                  Gaps.w8,
                ],
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
        ],
      ),
    );
  }
}
