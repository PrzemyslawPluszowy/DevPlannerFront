import 'dart:async';

import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/presentation/admin_users_list_view.dart';
import 'package:devplanner/admin/presentation/cubit/admin_users_cubit.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Trasa administracji lokalnymi kontami.
///
/// Composition jest wymagana przez produkcyjnego hosta. Brak adaptera oznacza
/// jawny stan niedostępności i nigdy nie tworzy pustej/fikcyjnej listy.
class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({required this.composition, super.key});

  final AdminUsersComposition composition;

  @override
  Widget build(BuildContext context) {
    if (!composition.canReadUsers) {
      return const AdminUsersAccessDeniedPage();
    }
    return BlocProvider(
      create: (_) {
        final cubit = AdminUsersCubit(composition: composition);
        unawaited(cubit.load());
        return cubit;
      },
      child: _AdminUsersScaffold(composition: composition),
    );
  }
}

/// Fail-closed entry point used when bootstrap nie dostarczył gatewaya.
class AdminUsersUnavailablePage extends StatelessWidget {
  const AdminUsersUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _AdminUsersMessagePage(
      icon: Icons.admin_panel_settings_outlined,
      title: context.l10n.adminUsersUnavailableTitle,
      message: context.l10n.adminUsersUnavailableMessage,
    );
  }
}

class AdminUsersAccessDeniedPage extends StatelessWidget {
  const AdminUsersAccessDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _AdminUsersMessagePage(
      icon: Icons.lock_outline,
      title: context.l10n.adminUsersAccessDeniedTitle,
      message: context.l10n.adminUsersAccessDeniedMessage,
    );
  }
}

class _AdminUsersScaffold extends StatelessWidget {
  const _AdminUsersScaffold({required this.composition});

  final AdminUsersComposition composition;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: AdminUsersListView(composition: composition),
    );
  }
}

class _AdminUsersMessagePage extends StatelessWidget {
  const _AdminUsersMessagePage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 44),
              Gaps.h12,
              Text(
                title,
                style: context.text.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Gaps.h8,
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
