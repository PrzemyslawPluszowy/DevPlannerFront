import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/presentation/workspaces_settings/notifications/cubit/workspace_notifications_settings_cubit.dart';

/// Widok zakładki "Powiadomienia" w ustawieniach przestrzeni roboczej.
class WorkspaceNotificationsTabView extends StatefulWidget {
  const WorkspaceNotificationsTabView({super.key});

  @override
  State<WorkspaceNotificationsTabView> createState() =>
      _WorkspaceNotificationsTabViewState();
}

class _WorkspaceNotificationsTabViewState
    extends State<WorkspaceNotificationsTabView> {
  bool _inAppEnabled = true;
  bool _emailEnabled = false;
  bool _tasksEnabled = true;
  bool _projectsEnabled = true;
  bool _workspaceEnabled = true;
  bool _membershipEnabled = true;
  bool _invitationsEnabled = true;
  bool _isInitialized = false;

  void _syncFromState(WorkspaceNotificationsSettingsLoaded state) {
    if (!_isInitialized) {
      _inAppEnabled = state.preferences.inAppEnabled;
      _emailEnabled = state.preferences.emailEnabled;
      _tasksEnabled = state.preferences.tasksEnabled;
      _projectsEnabled = state.preferences.projectsEnabled;
      _workspaceEnabled = state.preferences.workspaceEnabled;
      _membershipEnabled = state.preferences.membershipEnabled;
      _invitationsEnabled = state.preferences.invitationsEnabled;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return BlocConsumer<
      WorkspaceNotificationsSettingsCubit,
      WorkspaceNotificationsSettingsState
    >(
      listener: (context, state) {
        if (state is WorkspaceNotificationsSettingsLoaded) {
          _syncFromState(state);
        }
      },
      builder: (context, state) {
        return switch (state) {
          WorkspaceNotificationsSettingsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          WorkspaceNotificationsSettingsError(:final error) => Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: Sizes.p40,
                  color: colors.error,
                ),
                Gaps.h12,
                Text(
                  error.message,
                  style: context.text.bodyMedium?.copyWith(
                    color: colors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.h16,
                OutlinedButton(
                  onPressed: () => context
                      .read<WorkspaceNotificationsSettingsCubit>()
                      .load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
          WorkspaceNotificationsSettingsLoaded(
            :final isSaving,
            :final saveSuccess,
            :final error,
          ) =>
            SingleChildScrollView(
              padding: const .all(Sizes.p24),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  if (error != null) ...[
                    Container(
                      padding: const .all(Sizes.p12),
                      decoration: BoxDecoration(
                        color: colors.errorContainer.withValues(alpha: .2),
                        borderRadius: .circular(Sizes.p8),
                        border: Border.all(color: colors.error),
                      ),
                      child: Text(
                        error.message,
                        style: context.text.bodySmall?.copyWith(
                          color: colors.error,
                        ),
                      ),
                    ),
                    Gaps.h16,
                  ],
                  // 1. Kanały powiadomień
                  Text(
                    l10n.workspaceSettingsNotificationsChannels,
                    style: context.text.titleMedium?.copyWith(
                      fontWeight: .w700,
                      color: colors.onSurface,
                    ),
                  ),
                  Gaps.h12,
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLowest,
                      borderRadius: .circular(Sizes.p12),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: _inAppEnabled,
                          title: Text(l10n.workspaceSettingsNotificationsInApp),
                          subtitle: const Text(
                            'Powiadomienia w prawym panelu oraz dzwonku aplikacji.',
                          ),
                          onChanged: isSaving
                              ? null
                              : (val) => setState(() => _inAppEnabled = val),
                        ),
                        Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                        SwitchListTile(
                          value: _emailEnabled,
                          title: Text(l10n.workspaceSettingsNotificationsEmail),
                          subtitle: const Text(
                            'Podsumowania i alerty wysyłane na adres e-mail konta.',
                          ),
                          onChanged: isSaving
                              ? null
                              : (val) => setState(() => _emailEnabled = val),
                        ),
                      ],
                    ),
                  ),
                  Gaps.h28,
                  // 2. Kategorie powiadomień
                  Text(
                    l10n.workspaceSettingsNotificationsCategories,
                    style: context.text.titleMedium?.copyWith(
                      fontWeight: .w700,
                      color: colors.onSurface,
                    ),
                  ),
                  Gaps.h12,
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLowest,
                      borderRadius: .circular(Sizes.p12),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          value: _tasksEnabled,
                          title: Text(l10n.workspaceSettingsCategoryTasks),
                          subtitle: const Text(
                            'Nowe zadania, zmiany statusów, przypisania i terminy.',
                          ),
                          onChanged: isSaving
                              ? null
                              : (val) => setState(
                                  () => _tasksEnabled = val ?? false,
                                ),
                        ),
                        Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                        CheckboxListTile(
                          value: _projectsEnabled,
                          title: Text(l10n.workspaceSettingsCategoryProjects),
                          subtitle: const Text(
                            'Nowe projekty, kamienie milowe i zmiany konfiguracji.',
                          ),
                          onChanged: isSaving
                              ? null
                              : (val) => setState(
                                  () => _projectsEnabled = val ?? false,
                                ),
                        ),
                        Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                        CheckboxListTile(
                          value: _workspaceEnabled,
                          title: Text(l10n.workspaceSettingsCategoryWorkspace),
                          subtitle: const Text(
                            'Aktualizacje przestrzeni roboczej i komunikaty administracyjne.',
                          ),
                          onChanged: isSaving
                              ? null
                              : (val) => setState(
                                  () => _workspaceEnabled = val ?? false,
                                ),
                        ),
                        Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                        CheckboxListTile(
                          value: _invitationsEnabled,
                          title: const Text('Zaproszenia i członkostwa'),
                          subtitle: const Text(
                            'Otrzymane zaproszenia, akceptacje i zmiany ról.',
                          ),
                          onChanged: isSaving
                              ? null
                              : (val) => setState(
                                  () => _invitationsEnabled = val ?? false,
                                ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.h24,
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      if (saveSuccess) ...[
                        Icon(
                          Icons.check_circle_rounded,
                          color: colors.primary,
                          size: Sizes.p18,
                        ),
                        Gaps.w6,
                        Text(
                          l10n.workspaceSettingsNotificationsSaved,
                          style: context.text.bodySmall?.copyWith(
                            color: colors.primary,
                            fontWeight: .w600,
                          ),
                        ),
                        Gaps.w16,
                      ],
                      FilledButton(
                        onPressed: isSaving ? null : _handleSave,
                        child: isSaving
                            ? const SizedBox(
                                width: Sizes.p16,
                                height: Sizes.p16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.workspaceSettingsSaveNotifications),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        };
      },
    );
  }

  Future<void> _handleSave() async {
    await context.read<WorkspaceNotificationsSettingsCubit>().savePreferences(
      inAppEnabled: _inAppEnabled,
      emailEnabled: _emailEnabled,
      tasksEnabled: _tasksEnabled,
      projectsEnabled: _projectsEnabled,
      workspaceEnabled: _workspaceEnabled,
      membershipEnabled: _membershipEnabled,
      invitationsEnabled: _invitationsEnabled,
    );
  }
}
