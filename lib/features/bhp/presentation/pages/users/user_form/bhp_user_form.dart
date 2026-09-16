import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_form/bhp_user_form_controller.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_banner.dart';
import 'package:ready_next/shared/presentation/widgets/app_date_picker_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_form_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

/// Współdzielony formularz pracownika BHP dla dodawania i edycji.
class BhpUserForm extends StatelessWidget {
  /// Tworzy współdzielony formularz pracownika.
  const BhpUserForm({
    required this.controller,
    required this.positions,
    required this.potentialDuplicates,
    required this.baseSectionTitle,
    required this.baseSectionDescription,
    required this.submitLabel,
    required this.submitIcon,
    required this.onPositionChanged,
    required this.onEmploymentStartChanged,
    required this.onEmploymentEndChanged,
    required this.onSubmit,
    super.key,
    this.submitError,
    this.isSubmitting = false,
  });

  /// Kontroler danych formularza.
  final BhpUserFormController controller;

  /// Lista aktywnych stanowisk dostępnych w formularzu.
  final List<GetBhpPositionListItem> positions;

  /// Lista pracowników o podobnych danych.
  final List<GetBhpUserListItem> potentialDuplicates;

  /// Tytuł sekcji danych podstawowych.
  final String baseSectionTitle;

  /// Opis sekcji danych podstawowych.
  final String baseSectionDescription;

  /// Etykieta przycisku zapisu.
  final String submitLabel;

  /// Ikona przycisku zapisu.
  final IconData submitIcon;

  /// Błąd walidacji lub zapisu zwrócony z backendu.
  final String? submitError;

  /// Czy formularz jest w trakcie wysyłki.
  final bool isSubmitting;

  /// Callback zmiany stanowiska.
  final ValueChanged<int?> onPositionChanged;

  /// Callback zmiany daty rozpoczęcia.
  final ValueChanged<DateTime?> onEmploymentStartChanged;

  /// Callback zmiany daty zakończenia.
  final ValueChanged<DateTime?> onEmploymentEndChanged;

  /// Callback zapisu formularza.
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          AppFormSection(
            title: baseSectionTitle,
            description: baseSectionDescription,
            desktopColumns: 2,
            items: [
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.imieController,
                  variant: .filled,
                  labelText: intl.bhpAddUserFirstNameLabel,
                  isRequired: true,
                  enabled: !isSubmitting,
                  validators: [AppValidators.required()],
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.nazwiskoController,
                  variant: .filled,
                  labelText: intl.bhpAddUserLastNameLabel,
                  isRequired: true,
                  enabled: !isSubmitting,
                  validators: [AppValidators.required()],
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.peselController,
                  variant: .filled,
                  labelText: intl.bhpAddUserPeselLabel,
                  enabled: !isSubmitting,
                  keyboardType: .number,
                  maxLength: 11,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validators: [AppValidators.pesel()],
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.numerTelefonuController,
                  variant: .filled,
                  labelText: intl.bhpAddUserPhoneLabel,
                  enabled: !isSubmitting,
                  keyboardType: .phone,
                  validators: [AppValidators.phone()],
                ),
              ),
              AppFormSectionItem(
                child: AppDropdown<int>(
                  options: [
                    for (final position in positions)
                      AppDropdownOption(
                        value: position.id,
                        label: position.nazwa,
                      ),
                  ],
                  value: controller.stanowiskoId,
                  variant: .filled,
                  labelText: intl.bhpTablePosition,
                  hintText: intl.bhpAddUserSelectPositionHint,
                  errorText:
                      controller.submitted && controller.stanowiskoId == null
                      ? intl.bhpAddUserPositionRequiredError
                      : null,
                  enabled: !isSubmitting,
                  onChanged: onPositionChanged,
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.miejsceController,
                  variant: .filled,
                  labelText: intl.bhpAddUserResidenceLabel,
                  enabled: !isSubmitting,
                ),
              ),
              AppFormSectionItem(
                child: AppDatePickerField(
                  value: controller.dataRozpoczecia,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  variant: .filled,
                  labelText: intl.bhpTableEmploymentStart,
                  enabled: !isSubmitting,
                  onChanged: onEmploymentStartChanged,
                ),
              ),
              AppFormSectionItem(
                child: AppDatePickerField(
                  value: controller.dataZakonczenia,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  variant: .filled,
                  labelText: intl.bhpTableEmploymentEnd,
                  enabled: !isSubmitting,
                  onChanged: onEmploymentEndChanged,
                ),
              ),
            ],
          ),
          Gaps.h16,
          AppFormSection(
            title: intl.bhpAddUserDimensionsSectionTitle,
            description: intl.bhpAddUserDimensionsSectionDescription,
            items: [
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.wzrostController,
                  variant: .filled,
                  labelText: intl.bhpAddUserHeightLabel,
                  enabled: !isSubmitting,
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.klatkaController,
                  variant: .filled,
                  labelText: intl.bhpAddUserChestLabel,
                  enabled: !isSubmitting,
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.pasController,
                  variant: .filled,
                  labelText: intl.bhpAddUserWaistLabel,
                  enabled: !isSubmitting,
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.glowaController,
                  variant: .filled,
                  labelText: intl.bhpAddUserHeadLabel,
                  enabled: !isSubmitting,
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.stopaController,
                  variant: .filled,
                  labelText: intl.bhpAddUserFootLabel,
                  enabled: !isSubmitting,
                ),
              ),
              AppFormSectionItem(
                child: AppTextField(
                  controller: controller.uwagiController,
                  variant: .filled,
                  labelText: intl.bhpIssueFormNotesLabel,
                  enabled: !isSubmitting,
                  maxLines: 3,
                  minLines: 3,
                ),
              ),
            ],
          ),
          if (controller.hasExpiredEmploymentEndDate) ...[
            Gaps.h16,
            AppBanner(
              tone: AppBannerTone.warning,
              message: intl.bhpUserEmploymentEndDatePastWarning,
            ),
          ],
          if (potentialDuplicates.isNotEmpty) ...[
            Gaps.h16,
            AppBanner(
              tone: AppBannerTone.warning,
              title: intl.bhpAddUserPotentialDuplicateTitle,
              message: intl.bhpAddUserPotentialDuplicateBannerMessage(
                _buildDuplicateSummary(context),
              ),
            ),
          ],
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
                label: intl.cancel,
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

  String _buildDuplicateSummary(BuildContext context) {
    final intl = context.l10n;

    return potentialDuplicates
        .take(3)
        .map((user) {
          final status = user.isArchived
              ? intl.bhpUsersFilterArchived
              : intl.bhpUsersFilterActive;
          return '${user.fullName} ($status)';
        })
        .join(', ');
  }
}
