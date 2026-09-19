import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/notifications/cubit/workspace_notifications_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widok zakładki "Powiadomienia" w ustawieniach przestrzeni roboczej.
class WorkspaceNotificationsTabView extends StatefulWidget {
  const WorkspaceNotificationsTabView({super.key});

  @override
  State<WorkspaceNotificationsTabView> createState() =>
      _WorkspaceNotificationsTabViewState();
}

class _WorkspaceNotificationsTabViewState
    extends State<WorkspaceNotificationsTabView> {
  final ValueNotifier<_NotificationPreferencesDraft> _draft = ValueNotifier(
    const _NotificationPreferencesDraft(),
  );
  bool _isInitialized = false;

  void _syncFromState(WorkspaceNotificationsSettingsLoaded state) {
    if (!_isInitialized) {
      _draft.value = _NotificationPreferencesDraft.fromPreferences(
        state.preferences,
      );
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
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
            ValueListenableBuilder(
              valueListenable: _draft,
              builder: (context, draft, _) => SingleChildScrollView(
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
                            value: draft.inAppEnabled,
                            title: Text(
                              l10n.workspaceSettingsNotificationsInApp,
                            ),
                            subtitle: const Text(
                              'Powiadomienia w prawym panelu oraz dzwonku aplikacji.',
                            ),
                            onChanged: isSaving
                                ? null
                                : (val) => _updateDraft(
                                    draft.copyWith(inAppEnabled: val),
                                  ),
                          ),
                          Divider(
                            height: 1,
                            color: colors.outlineVariant.withValues(alpha: .5),
                          ),
                          SwitchListTile(
                            value: draft.emailEnabled,
                            title: Text(
                              l10n.workspaceSettingsNotificationsEmail,
                            ),
                            subtitle: const Text(
                              'Podsumowania i alerty wysyłane na adres e-mail konta.',
                            ),
                            onChanged: isSaving
                                ? null
                                : (val) => _updateDraft(
                                    draft.copyWith(emailEnabled: val),
                                  ),
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
                            value: draft.tasksEnabled,
                            title: Text(l10n.workspaceSettingsCategoryTasks),
                            subtitle: const Text(
                              'Nowe zadania, zmiany statusów, przypisania i terminy.',
                            ),
                            onChanged: isSaving
                                ? null
                                : (val) => _updateDraft(
                                    draft.copyWith(tasksEnabled: val ?? false),
                                  ),
                          ),
                          Divider(
                            height: 1,
                            color: colors.outlineVariant.withValues(alpha: .5),
                          ),
                          CheckboxListTile(
                            value: draft.projectsEnabled,
                            title: Text(l10n.workspaceSettingsCategoryProjects),
                            subtitle: const Text(
                              'Nowe projekty, kamienie milowe i zmiany konfiguracji.',
                            ),
                            onChanged: isSaving
                                ? null
                                : (val) => _updateDraft(
                                    draft.copyWith(
                                      projectsEnabled: val ?? false,
                                    ),
                                  ),
                          ),
                          Divider(
                            height: 1,
                            color: colors.outlineVariant.withValues(alpha: .5),
                          ),
                          CheckboxListTile(
                            value: draft.workspaceEnabled,
                            title: Text(
                              l10n.workspaceSettingsCategoryWorkspace,
                            ),
                            subtitle: const Text(
                              'Aktualizacje przestrzeni roboczej i komunikaty administracyjne.',
                            ),
                            onChanged: isSaving
                                ? null
                                : (val) => _updateDraft(
                                    draft.copyWith(
                                      workspaceEnabled: val ?? false,
                                    ),
                                  ),
                          ),
                          Divider(
                            height: 1,
                            color: colors.outlineVariant.withValues(alpha: .5),
                          ),
                          CheckboxListTile(
                            value: draft.invitationsEnabled,
                            title: const Text('Zaproszenia i członkostwa'),
                            subtitle: const Text(
                              'Otrzymane zaproszenia, akceptacje i zmiany ról.',
                            ),
                            onChanged: isSaving
                                ? null
                                : (val) => _updateDraft(
                                    draft.copyWith(
                                      invitationsEnabled: val ?? false,
                                    ),
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
            ),
        };
      },
    );
  }

  Future<void> _handleSave() async {
    await context.read<WorkspaceNotificationsSettingsCubit>().savePreferences(
      inAppEnabled: _draft.value.inAppEnabled,
      emailEnabled: _draft.value.emailEnabled,
      tasksEnabled: _draft.value.tasksEnabled,
      projectsEnabled: _draft.value.projectsEnabled,
      workspaceEnabled: _draft.value.workspaceEnabled,
      membershipEnabled: _draft.value.membershipEnabled,
      invitationsEnabled: _draft.value.invitationsEnabled,
    );
  }

  void _updateDraft(_NotificationPreferencesDraft value) =>
      _draft.value = value;
}

/// Niemutowalny szkic formularza, niezależny od stanu zapisu Cubita.
class _NotificationPreferencesDraft {
  const _NotificationPreferencesDraft({
    this.inAppEnabled = true,
    this.emailEnabled = false,
    this.tasksEnabled = true,
    this.projectsEnabled = true,
    this.workspaceEnabled = true,
    this.membershipEnabled = true,
    this.invitationsEnabled = true,
  });

  factory _NotificationPreferencesDraft.fromPreferences(
    WorkspaceNotificationPreferenceResponse preferences,
  ) => _NotificationPreferencesDraft(
    inAppEnabled: preferences.inAppEnabled,
    emailEnabled: preferences.emailEnabled,
    tasksEnabled: preferences.tasksEnabled,
    projectsEnabled: preferences.projectsEnabled,
    workspaceEnabled: preferences.workspaceEnabled,
    membershipEnabled: preferences.membershipEnabled,
    invitationsEnabled: preferences.invitationsEnabled,
  );

  final bool inAppEnabled;
  final bool emailEnabled;
  final bool tasksEnabled;
  final bool projectsEnabled;
  final bool workspaceEnabled;
  final bool membershipEnabled;
  final bool invitationsEnabled;

  _NotificationPreferencesDraft copyWith({
    bool? inAppEnabled,
    bool? emailEnabled,
    bool? tasksEnabled,
    bool? projectsEnabled,
    bool? workspaceEnabled,
    bool? membershipEnabled,
    bool? invitationsEnabled,
  }) => _NotificationPreferencesDraft(
    inAppEnabled: inAppEnabled ?? this.inAppEnabled,
    emailEnabled: emailEnabled ?? this.emailEnabled,
    tasksEnabled: tasksEnabled ?? this.tasksEnabled,
    projectsEnabled: projectsEnabled ?? this.projectsEnabled,
    workspaceEnabled: workspaceEnabled ?? this.workspaceEnabled,
    membershipEnabled: membershipEnabled ?? this.membershipEnabled,
    invitationsEnabled: invitationsEnabled ?? this.invitationsEnabled,
  );
}
