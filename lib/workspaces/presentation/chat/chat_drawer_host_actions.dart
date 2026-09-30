import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/chat_global_settings_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Akcje globalnego hosta, które zależą od portów dostępnych w root scope.
abstract final class ChatDrawerHostActions {
  /// UUID-y par już obecnych w skrzynce, używane do nowej grupy.
  static Set<String> existingDirectConversationIds(BuildContext context) {
    final state = context.read<ChatInboxCubit?>()?.state;
    if (state is! ChatInboxReady) return const <String>{};
    return <String>{
      for (final item in state.items)
        if (item.conversation.type == 'direct')
          ...item.otherParticipants.map((participant) => participant.userId),
    };
  }

  /// Tworzy przycisk własnego profilu i statusu, jeśli są jego porty.
  static Widget? profile(BuildContext context) {
    final presence = context.read<ChatPresenceRepository?>();
    final user = context.read<AuthSessionPort?>()?.snapshot.user;
    final userId = user?.userId.trim() ?? '';
    if (presence == null || userId.isEmpty) return null;
    return ChatStatusMenuButton(
      repository: presence,
      currentUserId: userId,
      displayName: user?.displayName,
      login: user?.login,
    );
  }

  /// Otwiera ustawienia komunikatora, jeżeli host dostarczył port.
  static VoidCallback? settings(BuildContext context) {
    final repository = context.read<ChatNotificationSettingsRepository?>();
    if (repository == null) return null;
    return () => unawaited(
      ChatGlobalSettingsModal.show(context, repository: repository),
    );
  }
}
