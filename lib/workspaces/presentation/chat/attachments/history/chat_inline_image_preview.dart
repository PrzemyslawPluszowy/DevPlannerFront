import 'dart:math' as math;
import 'dart:typed_data';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Czytelny podgląd obrazu wewnątrz załącznika wiadomości.
///
/// Rozmiar jest ograniczony do szerokości dymka, a dekoder tworzy mały cache
/// obrazu zamiast dekodować pełną rozdzielczość do widoku listy.
final class ChatInlineImagePreview extends StatelessWidget {
  const ChatInlineImagePreview({
    required this.future,
    required this.fallback,
    super.key,
  });

  final Future<Uint8List?>? future;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    final request = future;
    if (request == null) return const SizedBox.shrink();
    final chat = context.chatTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? math.min(constraints.maxWidth, 280.0)
            : 280.0;
        if (maxWidth <= 0) return const SizedBox.shrink();
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: maxWidth,
            height: maxWidth * .75,
            child: ColoredBox(
              color: chat.codeSurface,
              child: FutureBuilder<Uint8List?>(
                future: request,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: chat.focusRing,
                        ),
                      ),
                    );
                  }
                  final bytes = snapshot.data;
                  if (bytes == null || bytes.isEmpty) {
                    return Center(child: fallback);
                  }
                  return Image.memory(
                    bytes,
                    fit: BoxFit.contain,
                    cacheWidth: (maxWidth * 2).round(),
                    cacheHeight: (maxWidth * 1.5).round(),
                    errorBuilder: (_, _, _) => Center(child: fallback),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
