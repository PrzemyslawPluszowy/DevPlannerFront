import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_control_size.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

enum AppTextFieldVariant { outlined, filled }

/// Wspolny `TextFormField` dla formularzy CRM.
///
/// Cel komponentu:
/// - utrzymac spojny wyglad pol tekstowych w calej aplikacji,
/// - zapewnic domyslnie bardziej kompaktowe rozmiary na web,
/// - korzystac z motywu Material i extensionow projektu.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = AppTextFieldVariant.outlined,
    this.size = AppControlSize.small,
    this.inlineLabel,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.inputFormatters,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.validators,
    this.autovalidateMode,
    this.trim = true,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? inlineLabel;
  final AppTextFieldVariant variant;
  final AppControlSize size;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<FormFieldValidator<String>>? validators;
  final AutovalidateMode? autovalidateMode;
  final bool trim;

  void _trimControllerValue(TextEditingController controller) {
    final trimmed = controller.text.trim();
    if (trimmed == controller.text) {
      return;
    }

    controller.value = controller.value.copyWith(
      text: trimmed,
      selection: TextSelection.collapsed(offset: trimmed.length),
      composing: TextRange.empty,
    );
  }

  FormFieldValidator<String>? _buildValidator() {
    final merged = <FormFieldValidator<String>>[
      ...?validator == null ? null : [validator!],
      ...?validators,
    ];
    if (merged.isEmpty) {
      return null;
    }

    final composed = AppValidators.compose(merged);
    return (value) => composed(trim ? value?.trim() : value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSingleLine = maxLines == 1 && minLines == null;
    final textAlignVertical = isSingleLine
        ? TextAlignVertical.center
        : TextAlignVertical.top;
    final contentVerticalPadding = isSingleLine
        ? size.verticalPadding
        : Sizes.p12;
    final minFieldHeight = size.minHeight;
    final isFilled = variant == AppTextFieldVariant.filled;
    final baseFill = context.formControlFillColor(isFilled: isFilled);
    final enabledBorderColor = context.formControlEnabledBorderColor(
      isFilled: isFilled,
    );
    const borderRadius = BorderRadius.all(.circular(Sizes.p8));
    final resolvedValidator = _buildValidator();

    final fieldInput = TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      validator: resolvedValidator,
      textAlignVertical: textAlignVertical,
      style: context.text.bodyMedium?.copyWith(
        color: colors.onSurface,
        fontWeight: .w500,
      ),
      onTapOutside: (_) {
        if (!trim) {
          return;
        }
        if (controller case final textController?) {
          _trimControllerValue(textController);
        }
      },
      onChanged: (value) {
        final normalized = trim ? value.trim() : value;
        onChanged?.call(normalized);
      },
      onFieldSubmitted: (value) {
        if (trim) {
          if (controller case final textController?) {
            _trimControllerValue(textController);
            onSubmitted?.call(textController.text);
            return;
          }
          onSubmitted?.call(value.trim());
          return;
        }
        onSubmitted?.call(value);
      },
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        labelStyle: context.text.labelSmall?.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: .w600,
          height: 1,
        ),
        hintStyle: context.text.bodyMedium?.copyWith(
          color: context.formControlHintColor,
        ),
        prefixIcon: prefixIcon == null && inlineLabel == null
            ? null
            : Padding(
                padding: EdgeInsets.only(
                  left: size.horizontalPadding,
                  right: Sizes.p4,
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    if (prefixIcon case final icon?) ...[
                      Icon(icon, size: size.iconSize),
                      Gaps.w4,
                    ],
                    if (inlineLabel case final label?) ...[
                      Text(
                        '$label: ',
                        style: context.text.bodyMedium?.copyWith(
                          color: context.formControlInlineLabelColor,
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
        prefixIconConstraints: BoxConstraints(
          minWidth: size.minHeight,
          minHeight: size.minHeight,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: EdgeInsets.only(right: size.horizontalPadding / 2),
                child: suffixIcon,
              ),
        suffixIconConstraints: BoxConstraints(
          minWidth: size.minHeight,
          minHeight: size.minHeight,
        ),
        filled: true,
        isCollapsed: false,
        isDense: false,
        fillColor: baseFill,
        constraints: isSingleLine
            ? BoxConstraints(minHeight: minFieldHeight)
            : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.horizontalPadding,
          vertical: contentVerticalPadding,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: enabledBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.error, width: 1.4),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: context.formControlDisabledBorderColor(
              isFilled: isFilled,
            ),
          ),
        ),
        alignLabelWithHint: true,
      ),
    );

    if (labelText != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(context)!,
          const SizedBox(height: 4),
          fieldInput,
        ],
      );
    }

    return fieldInput;
  }

  Widget? _buildLabel(BuildContext context) {
    if (labelText case final label?) {
      final colors = context.colors;
      final baseStyle = context.text.labelSmall?.copyWith(
        color: colors.onSurfaceVariant,
        fontWeight: .w600,
        height: 1,
      );

      if (!isRequired) {
        return Text(label, style: baseStyle);
      }

      return Text.rich(
        TextSpan(
          text: label,
          style: baseStyle,
          children: [
            TextSpan(
              text: ' *',
              style: baseStyle?.copyWith(
                color: colors.error,
                fontWeight: .w700,
              ),
            ),
          ],
        ),
      );
    }
    return null;
  }
}
