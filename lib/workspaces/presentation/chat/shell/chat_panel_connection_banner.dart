import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nieblokujący komunikat o stanie połączenia SignalR w panelu Chat.
final class ChatPanelConnectionBanner extends StatelessWidget {
  const ChatPanelConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<ChatRealtimeStatusCubit?>() == null) {
      return const SizedBox.shrink();
    }
    return BlocBuilder<
      ChatRealtimeStatusCubit,
      WorkspaceSignalRConnectionState
    >(
      builder: (context, state) {
        final message = switch (state) {
          WorkspaceSignalRConnectionState.connected => null,
          WorkspaceSignalRConnectionState.connecting =>
            context.l10n.globalChatConnecting,
          WorkspaceSignalRConnectionState.reconnecting =>
            context.l10n.globalChatReconnecting,
          WorkspaceSignalRConnectionState.disconnected =>
            context.l10n.globalChatOffline,
        };
        if (message == null) return const SizedBox.shrink();
        final chat = context.chatTheme;
        return Semantics(
          liveRegion: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: chat.listSurface,
              border: Border(
                bottom: BorderSide(color: chat.separator),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p8,
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.info,
                    size: 18,
                    color: chat.metadataText,
                  ),
                  Gaps.w8,
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: chat.metadataStyle.copyWith(
                        color: chat.metadataText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
