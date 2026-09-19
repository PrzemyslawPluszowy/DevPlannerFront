import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/me/domain/models/user_session_item.dart';
import 'package:devplanner/me/presentation/cubit/sessions_cubit.dart';
import 'package:devplanner/me/presentation/cubit/sessions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Karta zarządzania aktywnymi sesjami urządzeń zalogowanego użytkownika.
class UserProfileSessionsCard extends StatelessWidget {
  const UserProfileSessionsCard({super.key});

  Future<void> _confirmRevoke(
    BuildContext context,
    UserSessionItem session,
  ) async {
    final l10n = context.l10n;
    final deviceName =
        session.deviceName ?? session.platform ?? 'Nieznane urządzenie';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.meSessionRevokeConfirmTitle),
          content: Text(
            l10n.meSessionRevokeConfirmMessage(deviceName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.meSessionRevokeConfirmAction),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await context.read<SessionsCubit>().revokeSession(session.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BlocConsumer<SessionsCubit, SessionsState>(
      listener: (context, state) {
        if (state is SessionsLoaded && state.actionMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.actionMessage!,
                style: TextStyle(color: theme.feedback.successForeground),
              ),
              backgroundColor: theme.feedback.successBackground,
            ),
          );
        } else if (state is SessionsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is SessionsLoading;
        final sessions = switch (state) {
          SessionsLoaded(:final sessions) => sessions,
          SessionsError(:final lastSessions) => lastSessions ?? const [],
          _ => const <UserSessionItem>[],
        };
        final revokingId = switch (state) {
          SessionsLoaded(:final revokingSessionId) => revokingSessionId,
          _ => null,
        };

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const .all(Sizes.p24),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // Nagłówek sekcji
                Row(
                  children: [
                    Container(
                      padding: const .all(Sizes.p8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: const .all(.circular(Sizes.p8)),
                      ),
                      child: Icon(
                        Icons.devices_outlined,
                        color: theme.colorScheme.onTertiaryContainer,
                        size: Sizes.p24,
                      ),
                    ),
                    Gaps.w12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            l10n.meSessionsSectionTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.meSessionsSectionSubtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      tooltip: l10n.meSessionsRefreshTooltip,
                      onPressed: isLoading
                          ? null
                          : () => context.read<SessionsCubit>().loadSessions(),
                    ),
                  ],
                ),
                const Divider(height: Sizes.p32),

                // Treść: ładowanie, brak sesji lub lista
                if (isLoading && sessions.isEmpty)
                  const Center(
                    child: Padding(
                      padding: .all(Sizes.p32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (sessions.isEmpty)
                  Padding(
                    padding: const .symmetric(vertical: Sizes.p16),
                    child: Text(
                      l10n.meSessionsEmpty,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sessions.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: Sizes.p16),
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isRevokingThis = revokingId == session.id;

                      return _SessionTile(
                        session: session,
                        isRevoking: isRevokingThis,
                        onRevoke: () => _confirmRevoke(context, session),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Kafelkowy element reprezentujący pojedynczą sesję urządzenia.
class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.session,
    required this.isRevoking,
    required this.onRevoke,
  });

  final UserSessionItem session;
  final bool isRevoking;
  final VoidCallback onRevoke;

  IconData _platformIcon(String? platform, String? deviceName) {
    final combined = '${platform ?? ''} ${deviceName ?? ''}'.toLowerCase();
    if (combined.contains('mac') ||
        combined.contains('darwin') ||
        combined.contains('ios') ||
        combined.contains('apple')) {
      return Icons.apple;
    }
    if (combined.contains('win')) {
      return Icons.desktop_windows_outlined;
    }
    if (combined.contains('linux')) {
      return Icons.terminal_outlined;
    }
    if (combined.contains('android')) {
      return Icons.phone_android_outlined;
    }
    if (combined.contains('iphone') || combined.contains('ipad')) {
      return Icons.phone_iphone_outlined;
    }
    return Icons.language_outlined;
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final icon = _platformIcon(session.platform, session.deviceName);
    final deviceTitle = session.deviceName?.isNotEmpty == true
        ? session.deviceName!
        : (session.platform?.isNotEmpty == true
              ? session.platform!
              : 'Urządzenie');

    return Row(
      children: [
        // Ikona platformy w zaokrąglonym tle
        Container(
          padding: const .all(Sizes.p10),
          decoration: BoxDecoration(
            color: session.isCurrent
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: Sizes.p20,
            color: session.isCurrent
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Gaps.w16,

        // Dane sesji
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Text(
                    deviceTitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (session.isCurrent) ...[
                    Gaps.w8,
                    Container(
                      padding: const .symmetric(
                        horizontal: Sizes.p8,
                        vertical: Sizes.p2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.feedback.successBackground,
                        borderRadius: const .all(.circular(Sizes.p12)),
                        border: Border.all(
                          color: theme.feedback.successForeground.withValues(
                            alpha: .4,
                          ),
                        ),
                      ),
                      child: Text(
                        l10n.meSessionCurrentBadge,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.feedback.successForeground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Gaps.h4,
              Text(
                '${l10n.meSessionLastSeen(_formatDate(session.lastSeenAtUtc))} • ${l10n.meSessionCreated(_formatDate(session.createdAtUtc))}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Przycisk zakończenia sesji
        if (!session.isCurrent) ...[
          if (isRevoking)
            const SizedBox(
              width: Sizes.p24,
              height: Sizes.p24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            OutlinedButton(
              onPressed: onRevoke,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(
                  color: theme.colorScheme.error.withValues(alpha: .4),
                ),
                padding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p6,
                ),
              ),
              child: Text(l10n.meSessionRevokeButton),
            ),
        ],
      ],
    );
  }
}
