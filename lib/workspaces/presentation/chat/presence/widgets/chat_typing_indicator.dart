import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_typing_label.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_typing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wskaźnik pisania w rozmowie.
///
/// Pokazuje wyłącznie to, co potwierdził serwer: lista piszących pochodzi
/// z cubita i wygasa po TTL, więc wskaźnik nie zostaje na ekranie po zerwaniu
/// połączenia ani po tym, jak druga strona przestała pisać bez zdarzenia stop.
/// Nazwy pochodzą z katalogu rozmowy; brak etykiety daje tekst neutralny,
/// a nie techniczny UUID.
class ChatTypingIndicator extends StatelessWidget {
  /// Tworzy wskaźnik pisania.
  const ChatTypingIndicator({
    this.labels = const <String, String>{},
    super.key,
  });

  /// Etykiety uczestników z katalogu; brak wpisu daje tekst neutralny.
  final Map<String, String> labels;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatTypingCubit?>();
    if (cubit == null) return const SizedBox.shrink();
    return BlocBuilder<ChatTypingCubit, ChatTypingState>(
      bloc: cubit,
      builder: (context, state) {
        // Wysokość jest zarezerwowana, więc pojawienie się pisania nie skacze
        // układem historii ani composera.
        return SizedBox(
          height: Sizes.p20,
          child: state.isTyping
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p12,
                  ),
                  child: Row(
                    children: [
                      const _TypingDots(),
                      const SizedBox(width: Sizes.p8),
                      Flexible(
                        child: Text(
                          _label(context, state),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.chatTheme.metadataStyle.copyWith(
                            color: context.chatTheme.metadataText,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  String _label(BuildContext context, ChatTypingState state) {
    final decision = ChatTypingLabels.decide(
      typingUserIds: state.typingUserIds,
      participantLabels: labels,
    );
    return switch (decision) {
      ChatTypingSingle(:final name) => context.l10n.chatTypingOne(name),
      ChatTypingPair(:final first, :final second) => context.l10n.chatTypingTwo(
        first,
        second,
      ),
      ChatTypingCrowd(:final first, :final others) =>
        context.l10n.chatTypingMany(first, others),
      ChatTypingUnknown() => context.l10n.chatTypingIndicator,
    };
  }
}

/// Trzy subtelne kropki; przy wyłączonych animacjach systemu zostają statyczne.
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void initState() {
    super.initState();
    // Animacja jest łagodna i cykliczna; przy wyłączonych animacjach systemu
    // kropki zostają statyczne, więc wskaźnik nikogo nie rozprasza.
    if (!(MediaQuery.maybeDisableAnimationsOf(context) ?? false)) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.chatTheme.metadataText;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < 3; index++)
            Padding(
              padding: const EdgeInsets.only(right: Sizes.p2),
              child: Opacity(
                opacity: .35 + .65 * _phase(_controller.value, index),
                child: _dot(color),
              ),
            ),
        ],
      ),
    );
  }

  /// Faza animacji dla kolejnej kropki; ruch jest łagodny i cykliczny.
  double _phase(double value, int index) {
    final shifted = (value + index / 3) % 1;
    return shifted < .5 ? shifted * 2 : (1 - shifted) * 2;
  }

  Widget _dot(Color color) => Container(
    width: 4,
    height: 4,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
