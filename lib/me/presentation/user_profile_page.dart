import 'dart:async';

import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/me/domain/ports/me_gateway.dart';
import 'package:devplanner/me/presentation/cubit/change_password_cubit.dart';
import 'package:devplanner/me/presentation/cubit/profile_cubit.dart';
import 'package:devplanner/me/presentation/cubit/profile_state.dart';
import 'package:devplanner/me/presentation/cubit/sessions_cubit.dart';
import 'package:devplanner/me/presentation/user_profile_password_card.dart';
import 'package:devplanner/me/presentation/user_profile_personal_card.dart';
import 'package:devplanner/me/presentation/user_profile_sessions_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Główna strona profilu i ustawień konta użytkownika (`/me`).
///
/// Integruje formularz danych osobowych, edycję nazwy, awatar,
/// zmianę hasła oraz listę aktywnych sesji urządzeń.
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({
    this.gateway,
    super.key,
  });

  /// Opcjonalna brama profilu. W przypadku braku wstrzyknięcia używa bezpiecznego fallbacku.
  final MeGateway? gateway;

  @override
  Widget build(BuildContext context) {
    final effectiveGateway = gateway ?? const UnavailableMeGateway();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = ProfileCubit(gateway: effectiveGateway);
            unawaited(cubit.loadProfile());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => ChangePasswordCubit(gateway: effectiveGateway),
        ),
        BlocProvider(
          create: (_) {
            final cubit = SessionsCubit(gateway: effectiveGateway);
            unawaited(cubit.loadSessions());
            return cubit;
          },
        ),
      ],
      child: const _UserProfileScaffold(),
    );
  }
}

class _UserProfileScaffold extends StatelessWidget {
  const _UserProfileScaffold();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const .symmetric(
            horizontal: Sizes.p24,
            vertical: Sizes.p32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  // Tytuł i podtytuł widoku
                  Text(
                    l10n.meProfileTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -.5,
                    ),
                  ),
                  Gaps.h8,
                  Text(
                    l10n.meProfileSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Gaps.h32,

                  // Sekcja 1: Dane profilowe użytkownika
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return switch (state) {
                        ProfileInitial() || ProfileLoading() => const Card(
                          child: Padding(
                            padding: .all(Sizes.p48),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        ProfileError(:final message, :final lastProfile) =>
                          lastProfile != null
                              ? UserProfilePersonalCard(profile: lastProfile)
                              : Card(
                                  child: Padding(
                                    padding: const .all(Sizes.p32),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 40,
                                            color: theme.colorScheme.error,
                                          ),
                                          Gaps.h12,
                                          Text(
                                            message,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          Gaps.h16,
                                          FilledButton.tonal(
                                            onPressed: () => context
                                                .read<ProfileCubit>()
                                                .loadProfile(),
                                            child: Text(l10n.meProfileRetry),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ProfileLoaded(:final profile) =>
                          UserProfilePersonalCard(profile: profile),
                        ProfileUpdating(:final profile) =>
                          UserProfilePersonalCard(profile: profile),
                        ProfileAvatarUploading(:final profile) =>
                          UserProfilePersonalCard(profile: profile),
                        ProfileAvatarDeleting(:final profile) =>
                          UserProfilePersonalCard(profile: profile),
                        ProfileUpdateSuccess(:final profile) =>
                          UserProfilePersonalCard(profile: profile),
                      };
                    },
                  ),
                  Gaps.h24,

                  // Sekcja 2: Zmiana hasła
                  const UserProfilePasswordCard(),
                  Gaps.h24,

                  // Sekcja 3: Aktywne sesje urządzeń
                  const UserProfileSessionsCard(),
                  Gaps.h32,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
