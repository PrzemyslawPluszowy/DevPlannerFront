import 'dart:async';

import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/me/presentation/cubit/change_password_cubit.dart';
import 'package:devplanner/me/presentation/cubit/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Karta zmiany hasła użytkownika z dynamiczną walidacją reguł bezpieczeństwa.
class UserProfilePasswordCard extends StatefulWidget {
  const UserProfilePasswordCard({super.key});

  @override
  State<UserProfilePasswordCard> createState() =>
      _UserProfilePasswordCardState();
}

class _UserProfilePasswordCardState extends State<UserProfilePasswordCard> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<_PasswordFormUiState> _uiState = ValueNotifier(
    const _PasswordFormUiState(),
  );

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onPasswordChanged);
    _currentPasswordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    _uiState.value = _uiState.value.copyWith(
      revision: _uiState.value.revision + 1,
    );
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_onPasswordChanged);
    _confirmPasswordController.removeListener(_onPasswordChanged);
    _currentPasswordController.removeListener(_onPasswordChanged);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _uiState.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<ChangePasswordCubit>().changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }

  void _clearForm() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return ValueListenableBuilder<_PasswordFormUiState>(
      valueListenable: _uiState,
      builder: (context, uiState, _) {
        final newPassword = _newPasswordController.text;
        final currentPassword = _currentPasswordController.text;
        final confirmPassword = _confirmPasswordController.text;
        final hasMinLength = newPassword.length >= 15;
        final hasDiffFromCurrent =
            newPassword.isNotEmpty && newPassword != currentPassword;
        final hasMatchConfirm =
            newPassword.isNotEmpty && newPassword == confirmPassword;
        return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              _clearForm();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(color: theme.feedback.successForeground),
                  ),
                  backgroundColor: theme.feedback.successBackground,
                ),
              );
            } else if (state is ChangePasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isSubmitting = state is ChangePasswordSubmitting;

            return Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const .all(Sizes.p24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      // Nagłówek sekcji
                      Row(
                        children: [
                          Container(
                            padding: const .all(Sizes.p8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: const .all(.circular(Sizes.p8)),
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              color: theme.colorScheme.onSecondaryContainer,
                              size: Sizes.p24,
                            ),
                          ),
                          Gaps.w12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  l10n.mePasswordSectionTitle,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  l10n.mePasswordSectionSubtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: Sizes.p32),

                      // Aktualne hasło
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: uiState.obscureCurrent,
                        decoration: InputDecoration(
                          labelText: l10n.meCurrentPasswordLabel,
                          hintText: l10n.meCurrentPasswordHint,
                          prefixIcon: const Icon(Icons.password, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              uiState.obscureCurrent
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            onPressed: () => _uiState.value = uiState.copyWith(
                              obscureCurrent: !uiState.obscureCurrent,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.meCurrentPasswordRequired;
                          }
                          return null;
                        },
                      ),
                      Gaps.h16,

                      // Nowe hasło
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: uiState.obscureNew,
                        decoration: InputDecoration(
                          labelText: l10n.meNewPasswordLabel,
                          hintText: l10n.meNewPasswordHint,
                          prefixIcon: const Icon(
                            Icons.vpn_key_outlined,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              uiState.obscureNew
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            onPressed: () => _uiState.value = uiState.copyWith(
                              obscureNew: !uiState.obscureNew,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 15) {
                            return l10n.meNewPasswordMinLengthError;
                          }
                          if (value.length > 128) {
                            return l10n.meNewPasswordMaxLengthError;
                          }
                          if (value == _currentPasswordController.text) {
                            return l10n.meNewPasswordSameAsCurrentError;
                          }
                          return null;
                        },
                      ),
                      Gaps.h16,

                      // Potwierdzenie nowego hasła
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: uiState.obscureConfirm,
                        decoration: InputDecoration(
                          labelText: l10n.meConfirmPasswordLabel,
                          hintText: l10n.meConfirmPasswordHint,
                          prefixIcon: const Icon(
                            Icons.check_circle_outline,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              uiState.obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            onPressed: () => _uiState.value = uiState.copyWith(
                              obscureConfirm: !uiState.obscureConfirm,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return l10n.mePasswordsDoNotMatchError;
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(context),
                      ),
                      Gaps.h16,

                      // Wizualne wskaźniki spełnienia kryteriów bezpieczeństwa hasła
                      Container(
                        padding: const .all(Sizes.p12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: const .all(.circular(Sizes.p8)),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          children: [
                            _PasswordRuleIndicator(
                              label: l10n.meNewPasswordMinLengthError,
                              isSatisfied: hasMinLength,
                            ),
                            Gaps.h6,
                            _PasswordRuleIndicator(
                              label: l10n.meNewPasswordSameAsCurrentError,
                              isSatisfied: hasDiffFromCurrent,
                            ),
                            Gaps.h6,
                            _PasswordRuleIndicator(
                              label: l10n.mePasswordsDoNotMatchError,
                              isSatisfied: hasMatchConfirm,
                              invertLabel: true,
                            ),
                          ],
                        ),
                      ),
                      Gaps.h24,

                      // Przycisk zatwierdzenia formularza
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: isSubmitting
                              ? null
                              : () => _submit(context),
                          icon: isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.save_outlined, size: 18),
                          label: Text(l10n.meChangePasswordButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

@immutable
class _PasswordFormUiState {
  const _PasswordFormUiState({
    this.obscureCurrent = true,
    this.obscureNew = true,
    this.obscureConfirm = true,
    this.revision = 0,
  });

  final bool obscureCurrent;
  final bool obscureNew;
  final bool obscureConfirm;
  final int revision;

  _PasswordFormUiState copyWith({
    bool? obscureCurrent,
    bool? obscureNew,
    bool? obscureConfirm,
    int? revision,
  }) => _PasswordFormUiState(
    obscureCurrent: obscureCurrent ?? this.obscureCurrent,
    obscureNew: obscureNew ?? this.obscureNew,
    obscureConfirm: obscureConfirm ?? this.obscureConfirm,
    revision: revision ?? this.revision,
  );
}

/// Element prezentujący spełnienie reguły walidacji hasła.
class _PasswordRuleIndicator extends StatelessWidget {
  const _PasswordRuleIndicator({
    required this.label,
    required this.isSatisfied,
    this.invertLabel = false,
  });

  final String label;
  final bool isSatisfied;
  final bool invertLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSatisfied
        ? theme.feedback.successForeground
        : theme.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(
          isSatisfied ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: color,
        ),
        Gaps.w8,
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: isSatisfied ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
