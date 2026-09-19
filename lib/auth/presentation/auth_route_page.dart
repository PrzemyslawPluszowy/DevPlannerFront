import 'dart:async';

import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/auth/domain/use_cases/auth_use_cases.dart';
import 'package:devplanner/auth/presentation/cubit/auth_action_cubit.dart';
import 'package:devplanner/auth/presentation/cubit/auth_login_cubit.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum AuthRouteKind { login, activation, reset, mfa }

class AuthRoutePage extends StatelessWidget {
  const AuthRoutePage({
    required this.kind,
    required this.useCases,
    required this.session,
    this.returnTo,
    super.key,
  });

  final AuthRouteKind kind;
  final AuthUseCases useCases;
  final AuthSessionPort session;
  final String? returnTo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: switch (kind) {
              AuthRouteKind.login => _LoginForm(
                useCases: useCases,
                returnTo: returnTo,
              ),
              AuthRouteKind.activation => _ActionForm(
                title: context.l10n.authActivationTitle,
                fields: [
                  context.l10n.authActivationTokenLabel,
                  context.l10n.authActivationPasswordLabel,
                ],
                obscureFields: const [false, true],
                action: (values) => useCases.activate(
                  token: values[0],
                  password: values[1],
                ),
              ),
              AuthRouteKind.reset => _ActionForm(
                title: context.l10n.authResetTitle,
                fields: [context.l10n.authResetLoginLabel],
                action: (values) => useCases.requestPasswordReset(values[0]),
              ),
              AuthRouteKind.mfa => _ActionForm(
                title: context.l10n.authMfaTitle,
                fields: [context.l10n.authMfaCodeLabel],
                action: (values) => useCases.verifyMfa(values[0]),
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.useCases, this.returnTo});

  final AuthUseCases useCases;
  final String? returnTo;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthLoginCubit(useCases: useCases),
      child: BlocConsumer<AuthLoginCubit, AuthLoginState>(
        listener: (context, state) {
          if (state is AuthLoginSucceeded) {
            context.go(AuthReturnTo.sanitize(returnTo) ?? '/workspaces');
          }
        },
        builder: (context, state) {
          final submitting = state is AuthLoginSubmitting;
          final redirecting = state is AuthLoginRedirecting;
          final content = switch (useCases.clientKind) {
            AuthClientKind.webBff => _WebBffLoginAction(
              submitting: submitting,
              redirecting: redirecting,
              onPressed: () => unawaited(
                context.read<AuthLoginCubit>().startInteractive(),
              ),
            ),
            AuthClientKind.desktopPkce => _DesktopPkceLoginAction(
              submitting: submitting,
              onPressed: () => unawaited(
                context.read<AuthLoginCubit>().startInteractive(),
              ),
            ),
          };
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.appName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  if (state case AuthLoginFailure(:final message)) ...[
                    Text(
                      message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  content,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

final class _WebBffLoginAction extends StatelessWidget {
  const _WebBffLoginAction({
    required this.submitting,
    required this.redirecting,
    required this.onPressed,
  });

  final bool submitting;
  final bool redirecting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.loginBffDescription),
        const SizedBox(height: 20),
        Semantics(
          key: const ValueKey('auth-bff-login-cta-semantics'),
          container: true,
          button: true,
          enabled: !submitting && !redirecting,
          label: switch ((submitting, redirecting)) {
            (true, _) => context.l10n.loginSubmitting,
            (_, true) => context.l10n.loginRedirecting,
            _ => context.l10n.loginBffSubmit,
          },
          child: FilledButton(
            onPressed: submitting || redirecting ? null : onPressed,
            child: Text(
              switch ((submitting, redirecting)) {
                (true, _) => context.l10n.loginSubmitting,
                (_, true) => context.l10n.loginRedirecting,
                _ => context.l10n.loginBffSubmit,
              },
            ),
          ),
        ),
      ],
    );
  }
}

final class _DesktopPkceLoginAction extends StatelessWidget {
  const _DesktopPkceLoginAction({
    required this.submitting,
    required this.onPressed,
  });
  final bool submitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    key: const ValueKey('auth-desktop-pkce-login-cta-semantics'),
    container: true,
    button: true,
    enabled: !submitting,
    label: submitting ? context.l10n.loginSubmitting : context.l10n.loginSubmit,
    child: FilledButton(
      onPressed: submitting ? null : onPressed,
      child: Text(
        submitting ? context.l10n.loginSubmitting : context.l10n.loginSubmit,
      ),
    ),
  );
}

class _ActionForm extends StatefulWidget {
  const _ActionForm({
    required this.title,
    required this.fields,
    required this.action,
    this.obscureFields = const <bool>[],
  });

  final String title;
  final List<String> fields;
  final List<bool> obscureFields;
  final Future<void> Function(List<String> values) action;

  @override
  State<_ActionForm> createState() => _ActionFormState();
}

class _ActionFormState extends State<_ActionForm> {
  late final List<TextEditingController> _controllers = [
    for (var index = 0; index < widget.fields.length; index++)
      TextEditingController(),
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthActionCubit(
        action: () => widget.action(
          _controllers.map((controller) => controller.text.trim()).toList(),
        ),
      ),
      child: BlocBuilder<AuthActionCubit, AuthActionState>(
        builder: (context, state) {
          final submitting = state is AuthActionSubmitting;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(context.l10n.authContractPending),
                    const SizedBox(height: 20),
                    for (var index = 0; index < widget.fields.length; index++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextFormField(
                          controller: _controllers[index],
                          enabled: !submitting,
                          obscureText:
                              index < widget.obscureFields.length &&
                              widget.obscureFields[index],
                          decoration: InputDecoration(
                            labelText: widget.fields[index],
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? context.l10n.authFieldRequired
                              : null,
                        ),
                      ),
                    if (state case AuthActionFailure(:final message)) ...[
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: submitting
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() != true) {
                                return;
                              }
                              unawaited(
                                context.read<AuthActionCubit>().submit(),
                              );
                            },
                      child: Text(context.l10n.loginSubmit),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
