import 'package:flutter/material.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/shared/presentation/widgets/app_global_utility_bar.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';

/// Prawa sekcja wejść do powiadomień i Chat, bez własnego stanu biznesowego.
class AppShellTopBarActions extends StatelessWidget {
  const AppShellTopBarActions({
    required this.router,
    required this.unreadNotifications,
    required this.notificationRepository,
    required this.chatRepository,
    this.onOpenNotifications,
    this.onOpenChat,
    super.key,
  });

  final AppRouter router;
  final int? unreadNotifications;
  final NotificationsRepository? notificationRepository;
  final ChatRepository? chatRepository;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenChat;

  @override
  Widget build(BuildContext context) {
    return AppGlobalUtilityActions(
      router: router,
      count: unreadNotifications,
      repository: notificationRepository,
      chatRepository: chatRepository,
      onOpenNotifications: onOpenNotifications,
      onOpenChat: onOpenChat,
    );
  }
}
