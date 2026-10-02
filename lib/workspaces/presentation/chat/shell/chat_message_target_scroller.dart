import 'dart:async';

import 'package:flutter/material.dart';

/// Szuka celu także poza leniwie zbudowanym viewportem historii.
///
/// Przechodzi po viewportach od końca historii, bez zgadywania wysokości
/// zmiennych dymków. Każdy krok buduje następną część listy, a docelowy dymek
/// jest ostatecznie wyrównywany przez ensureVisible. Nowy cel unieważnia stary.
final class ChatMessageTargetScroller {
  ChatMessageTargetScroller({
    required this.scroll,
    required this.targetKey,
    required this.isMounted,
  });

  final ScrollController scroll;
  final GlobalKey targetKey;
  final bool Function() isMounted;
  int _generation = 0;
  bool _scheduled = false;
  bool _running = false;
  String? _target;
  int _maxSteps = 0;
  String? _completedTarget;
  int _requestId = 0;

  void schedule(
    String? target, {
    required int messageCount,
    int requestId = 0,
  }) {
    if (target != _target || requestId != _requestId) {
      ++_generation;
      _target = target;
      _requestId = requestId;
      _completedTarget = null;
    }
    _maxSteps = messageCount * 2 + 2;
    if (target == null ||
        target == _completedTarget ||
        _scheduled ||
        _running) {
      return;
    }
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (isMounted()) unawaited(_findTarget());
    });
  }

  Future<void> _findTarget() async {
    if (_running || _target == null || !scroll.hasClients) return;
    final generation = _generation;
    final target = _target;
    _running = true;
    try {
      var restarted = false;
      for (var step = 0; step < _maxSteps; step++) {
        if (!isMounted() || generation != _generation || !scroll.hasClients) {
          return;
        }
        final context = targetKey.currentContext;
        if (context != null && context.mounted) {
          await Scrollable.ensureVisible(
            context,
            alignment: .4,
            duration: const Duration(milliseconds: 200),
          );
          if (isMounted() && generation == _generation) {
            _completedTarget = target;
          }
          return;
        }
        final position = scroll.position;
        if (!restarted) {
          restarted = true;
          scroll.jumpTo(position.minScrollExtent);
        } else {
          final next = (position.pixels + position.viewportDimension * .8)
              .clamp(position.minScrollExtent, position.maxScrollExtent);
          if (next <= position.pixels) return;
          scroll.jumpTo(next);
        }
        await WidgetsBinding.instance.endOfFrame;
      }
    } finally {
      _running = false;
      if (isMounted() && generation != _generation) {
        schedule(
          _target,
          messageCount: (_maxSteps - 2) ~/ 2,
          requestId: _requestId,
        );
      }
    }
  }

  void dispose() => ++_generation;
}
