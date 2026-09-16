import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_session_storage.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Ekran logowania standalone do aplikacji Ready Custom.
class LoginPage extends StatefulWidget {
  /// Tworzy ekran logowania.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// Stan formularza logowania.
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _backgroundController;
  late final Future<ui.FragmentProgram> _shaderProgramFuture;
  late final AuthSessionStorage _authSessionStorage;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _authSessionStorage = context.read<AuthSessionStorage>();
    _shaderProgramFuture = ui.FragmentProgram.fromAsset(
      'shaders/login_background.frag',
    );
    unawaited(_restoreRememberedUsername());
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    await context.read<AuthCubit>().login(
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  Future<void> _restoreRememberedUsername() async {
    final rememberedUsername = await _authSessionStorage
        .readRememberedUsername();
    if (!mounted ||
        rememberedUsername == null ||
        rememberedUsername.isEmpty ||
        _usernameController.text.trim().isNotEmpty) {
      return;
    }

    _usernameController.value = TextEditingValue(
      text: rememberedUsername,
      selection: TextSelection.collapsed(offset: rememberedUsername.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.intl;
    final colors = context.colors;
    final surfaceRoles = context.surfaceRoles;
    final topGlow = Color.alphaBlend(
      colors.primary.withValues(alpha: .24),
      colors.surfaceContainerLow,
    );
    final bottomGlow = Color.alphaBlend(
      colors.tertiary.withValues(alpha: .18),
      colors.surfaceContainerLow,
    );

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          TextInput.finishAutofillContext();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: FutureBuilder<ui.FragmentProgram>(
                future: _shaderProgramFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return AnimatedBuilder(
                      animation: _backgroundController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _LoginBackgroundShaderPainter(
                            program: snapshot.data!,
                            time: _backgroundController.value * 8,
                            primary: colors.primary,
                            tertiary: colors.tertiary,
                            surface: colors.surfaceContainerLow,
                          ),
                          child: const SizedBox.expand(),
                        );
                      },
                    );
                  }

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: .topLeft,
                        end: .bottomRight,
                        colors: [
                          topGlow,
                          colors.surfaceContainerLow,
                          bottomGlow,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                final t = _backgroundController.value;
                return Positioned(
                  left: -120 + (t * 16),
                  top: -120 + (t * 10),
                  child: IgnorePointer(
                    child: Transform.scale(
                      scale: 1 + (t * .07),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary.withValues(alpha: .12),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                final t = _backgroundController.value;
                return Positioned(
                  right: -140 + ((1 - t) * 14),
                  bottom: -110 + ((1 - t) * 16),
                  child: IgnorePointer(
                    child: Transform.scale(
                      scale: 1 + ((1 - t) * .06),
                      child: Container(
                        width: 320,
                        height: 320,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.tertiary.withValues(alpha: .1),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Padding(
                  padding: const .all(Sizes.p24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: surfaceRoles.raisedBackground.withValues(
                        alpha: .95,
                      ),
                      borderRadius: const .all(.circular(Sizes.p24)),
                      border: Border.all(color: surfaceRoles.raisedBorder),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: .14),
                          blurRadius: 30,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Padding(
                        padding: const .all(Sizes.p24),
                        child: Form(
                          key: _formKey,
                          child: AutofillGroup(
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                final message = switch (state) {
                                  AuthUnauthenticated(:final message) =>
                                    message,
                                  _ => null,
                                };

                                return Column(
                                  mainAxisSize: .min,
                                  crossAxisAlignment: .stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: colors.primaryContainer,
                                            borderRadius: const .all(
                                              .circular(Sizes.p12),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.lock_outline_rounded,
                                            color: colors.primary,
                                          ),
                                        ),
                                        Gaps.w12,
                                        Expanded(
                                          child: Text(
                                            intl.appName,
                                            style: context.text.titleLarge
                                                ?.copyWith(
                                                  fontWeight: .w700,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gaps.h16,
                                    Text(
                                      intl.loginSubtitle,
                                      style: context.text.bodyMedium?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                    Gaps.h20,
                                    TextFormField(
                                      controller: _usernameController,
                                      enabled: !isLoading,
                                      textInputAction: .next,
                                      autofillHints: const [
                                        AutofillHints.username,
                                      ],
                                      decoration: InputDecoration(
                                        labelText: intl.loginUsernameLabel,
                                        prefixIcon: const Icon(
                                          Icons.person_outline,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return intl.loginUsernameRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                    Gaps.h12,
                                    TextFormField(
                                      controller: _passwordController,
                                      enabled: !isLoading,
                                      obscureText: !_isPasswordVisible,
                                      textInputAction: .done,
                                      onFieldSubmitted: (_) => _onSubmit(),
                                      autofillHints: const [
                                        AutofillHints.password,
                                      ],
                                      decoration: InputDecoration(
                                        labelText: intl.loginPasswordLabel,
                                        prefixIcon: const Icon(
                                          Icons.key_outlined,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: isLoading
                                              ? null
                                              : () => setState(
                                                  () => _isPasswordVisible =
                                                      !_isPasswordVisible,
                                                ),
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return intl.loginPasswordRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                    if (message != null) ...[
                                      Gaps.h12,
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: colors.errorContainer
                                              .withValues(
                                                alpha: .72,
                                              ),
                                          borderRadius: const .all(
                                            .circular(Sizes.p12),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const .all(Sizes.p10),
                                          child: Text(
                                            message,
                                            style: context.text.bodySmall
                                                ?.copyWith(
                                                  color:
                                                      colors.onErrorContainer,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    Gaps.h20,
                                    FilledButton.icon(
                                      onPressed: isLoading ? null : _onSubmit,
                                      icon: isLoading
                                          ? const SizedBox.square(
                                              dimension: Sizes.p16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(Icons.login_rounded),
                                      label: Text(
                                        isLoading
                                            ? intl.loginSubmitting
                                            : intl.loginSubmit,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rysuje subtelne, animowane tlo logowania przy pomocy fragment shader.
class _LoginBackgroundShaderPainter extends CustomPainter {
  /// Tworzy painter shadera logowania.
  const _LoginBackgroundShaderPainter({
    required this.program,
    required this.time,
    required this.primary,
    required this.tertiary,
    required this.surface,
  });

  final ui.FragmentProgram program;
  final double time;
  final Color primary;
  final Color tertiary;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();

    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, primary.r)
      ..setFloat(4, primary.g)
      ..setFloat(5, primary.b)
      ..setFloat(6, tertiary.r)
      ..setFloat(7, tertiary.g)
      ..setFloat(8, tertiary.b)
      ..setFloat(9, surface.r)
      ..setFloat(10, surface.g)
      ..setFloat(11, surface.b);

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant _LoginBackgroundShaderPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.primary != primary ||
        oldDelegate.tertiary != tertiary ||
        oldDelegate.surface != surface;
  }
}
