import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_typing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wskaźnik pisania w rozmowie.
///
/// Pokazuje wyłącznie to, co potwierdził serwer: lista piszących pochodzi
/// z cubita i wygasa po TTL, więc wskaźnik nie zostaje na ekranie po zerwaniu
/// połączenia ani po tym, jak druga strona przestała pisać bez zdarzenia stop.
class ChatTypingIndicator extends StatelessWidget {
  /// Tworzy wskaźnik pisania.
  const ChatTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatTypingCubit?>();
    if (cubit == null) return const SizedBox.shrink();
    return BlocBuilder<ChatTypingCubit, ChatTypingState>(
      bloc: cubit,
      builder: (context, state) {
        if (!state.isTyping) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(Sizes.p12, 0, Sizes.p12, Sizes.p4),
          child: Row(
            children: [
              Icon(
                Symbols.more_horiz,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: Sizes.p4),
              Text(
                context.l10n.chatTypingIndicator,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
