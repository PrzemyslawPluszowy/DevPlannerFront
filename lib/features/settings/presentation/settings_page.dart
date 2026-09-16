import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/modules/app_modules_catalog.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/settings/application/current_user_avatar_cubit.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';

part 'settings_page_navigation.part.dart';
part 'settings_page_sections.part.dart';
part 'settings_page_options.part.dart';
part 'settings_page_profile.part.dart';

enum _SettingsSection { profile, appearance, language, modules }

/// Globalny ekran ustawien lokalnych aplikacji.
class SettingsPage extends StatefulWidget {
  /// Tworzy ekran ustawien.
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// Stan ekranu ustawien.
class _SettingsPageState extends State<SettingsPage> {
  _SettingsSection _selectedSection = _SettingsSection.appearance;

  void _selectSection(_SettingsSection section) {
    setState(() => _selectedSection = section);
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Padding(
              padding: const .all(Sizes.p24),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const .all(Sizes.p24),
                    decoration: BoxDecoration(
                      borderRadius: const .all(.circular(Sizes.p20)),
                      gradient: LinearGradient(
                        begin: .topLeft,
                        end: .bottomRight,
                        colors: [
                          colors.primary.withValues(alpha: .16),
                          colors.secondary.withValues(alpha: .08),
                        ],
                      ),
                      border: Border.all(
                        color: colors.outlineVariant.withValues(alpha: .9),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          crossAxisAlignment: .start,
                          children: [
                            Expanded(
                              child: Text(
                                intl.settingsHeaderTitle,
                                style: context.text.headlineSmall?.copyWith(
                                  fontWeight: .w800,
                                ),
                              ),
                            ),
                            AppActionButton.outlined(
                              label: 'Framework Components',
                              icon: Icons.widgets_outlined,
                              tone: .neutral,
                              onPressed: () => context.router.push(
                                AppRoutePaths.frameworkComponents,
                              ),
                            ),
                          ],
                        ),
                        Gaps.h8,
                        Text(
                          intl.settingsHeaderSubtitle,
                          style: context.text.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.h20,
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 940;
                        final nav = _SettingsNavigationCard(
                          selectedSection: _selectedSection,
                          onSectionSelected: _selectSection,
                        );
                        final content = switch (_selectedSection) {
                          _SettingsSection.profile =>
                            const _ProfileSettingsCard(),
                          _SettingsSection.appearance =>
                            const _AppearanceSettingsCard(),
                          _SettingsSection.language =>
                            const _LanguageSettingsCard(),
                          _SettingsSection.modules =>
                            const _ModulesSettingsCard(),
                        };

                        if (!isWide) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                nav,
                                Gaps.h16,
                                content,
                              ],
                            ),
                          );
                        }

                        return Row(
                          crossAxisAlignment: .start,
                          children: [
                            SizedBox(width: 300, child: nav),
                            Gaps.w16,
                            Expanded(
                              child: SingleChildScrollView(child: content),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
