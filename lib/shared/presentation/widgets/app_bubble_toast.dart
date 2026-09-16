import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ready_next/app/shell/overlay/app_modal_coordinator.dart';
import 'package:ready_next/core/theme/theme.dart';

enum AppBubbleToastTone { info, success, warning, error }

/// Sesyjny właściciel pojedynczego transient toastu.
///
/// Toast nie jest route'em modalnym. Gdy [AppModalCoordinator] trzyma aktywną
/// barierę, właściciel usuwa bieżący toast i kolejkuje nowe żądania do
/// czasu zamknięcia modala. Dzięki temu transient nigdy nie renderuje się nad
/// barierą rootowego modala.
class AppBubbleToastController extends ChangeNotifier {
  AppBubbleToastController(this._modalCoordinator) {
    _modalCoordinator.addListener(_handleModalStateChanged);
  }

  final AppModalCoordinator _modalCoordinator;
  OverlayEntry? _currentEntry;
  Timer? _currentTimer;
  final Queue<_AppBubbleToastRequest> _pendingRequests =
      Queue<_AppBubbleToastRequest>();

  /// Wyświetla request albo zapisuje go do kolejki podczas modala.
  void show({
    required OverlayState overlay,
    required String message,
    required AppBubbleToastTone tone,
    required Duration duration,
    required EdgeInsets margin,
    required Alignment alignment,
  }) {
    final request = _AppBubbleToastRequest(
      overlay: overlay,
      message: message,
      tone: tone,
      duration: duration,
      margin: margin,
      alignment: alignment,
    );
    _removeCurrent();
    if (_modalCoordinator.isPresenting) {
      _pendingRequests.add(request);
      return;
    }
    _showRequest(request);
  }

  /// Usuwa bieżący dymek i wszystkie oczekujące żądania.
  void dismiss() {
    _pendingRequests.clear();
    _removeCurrent();
  }

  void _handleModalStateChanged() {
    if (_modalCoordinator.isPresenting) {
      _removeCurrent();
      return;
    }
    _showNextPendingRequest();
  }

  void _showRequest(_AppBubbleToastRequest request) {
    if (!request.overlay.mounted || _modalCoordinator.isPresenting) {
      if (_modalCoordinator.isPresenting) {
        _pendingRequests.addFirst(request);
      } else {
        _showNextPendingRequest();
      }
      return;
    }
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _AppBubbleToastView(
        message: request.message,
        tone: request.tone,
        margin: request.margin,
        alignment: request.alignment,
        onDismiss: _dismissCurrentAndShowNext,
      ),
    );
    _currentEntry = entry;
    request.overlay.insert(entry);
    _currentTimer = Timer(request.duration, _dismissCurrentAndShowNext);
  }

  void _dismissCurrentAndShowNext() {
    _removeCurrent();
    _showNextPendingRequest();
  }

  void _showNextPendingRequest() {
    if (_modalCoordinator.isPresenting) {
      return;
    }
    while (_pendingRequests.isNotEmpty) {
      final request = _pendingRequests.removeFirst();
      if (request.overlay.mounted) {
        _showRequest(request);
        return;
      }
    }
  }

  void _removeCurrent() {
    _currentTimer?.cancel();
    _currentTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }

  @override
  void dispose() {
    _modalCoordinator.removeListener(_handleModalStateChanged);
    dismiss();
    super.dispose();
  }
}

/// Udostępnia sesyjnego ownera toastu pod prywatnym shellem.
class AppBubbleToastScope extends InheritedNotifier<AppBubbleToastController> {
  const AppBubbleToastScope({
    required AppBubbleToastController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  /// Zwraca ownera toastu, jeżeli kontekst należy do private shella.
  static AppBubbleToastController? maybeOf(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<AppBubbleToastScope>()
        ?.notifier;
  }
}

/// Lekki toast typu "dymek" dla weba.
///
/// To kompatybilna fasada API. Lifecycle i stan należą do wstrzykniętego
/// [AppBubbleToastController], a nie do globalnego singletonu.
abstract final class AppBubbleToast {
  static void show(
    BuildContext context, {
    required String message,
    AppBubbleToastTone tone = AppBubbleToastTone.info,
    Duration duration = const Duration(seconds: 2),
    EdgeInsets margin = const EdgeInsets.only(
      top: Sizes.p16,
      right: Sizes.p16,
      left: Sizes.p16,
    ),
    Alignment alignment = Alignment.topRight,
  }) {
    final controller = AppBubbleToastScope.maybeOf(context);
    if (controller == null) {
      return;
    }
    controller.show(
      overlay: Overlay.of(context, rootOverlay: true),
      message: message,
      tone: tone,
      duration: duration,
      margin: margin,
      alignment: alignment,
    );
  }
}

class _AppBubbleToastRequest {
  const _AppBubbleToastRequest({
    required this.overlay,
    required this.message,
    required this.tone,
    required this.duration,
    required this.margin,
    required this.alignment,
  });

  final OverlayState overlay;
  final String message;
  final AppBubbleToastTone tone;
  final Duration duration;
  final EdgeInsets margin;
  final Alignment alignment;
}

class _AppBubbleToastView extends StatelessWidget {
  const _AppBubbleToastView({
    required this.message,
    required this.tone,
    required this.margin,
    required this.alignment,
    required this.onDismiss,
  });

  final String message;
  final AppBubbleToastTone tone;
  final EdgeInsets margin;
  final Alignment alignment;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final feedback = context.feedback;
    final (bg, fg, icon) = _resolveStyle(feedback);
    return IgnorePointer(
      ignoring: false,
      child: SafeArea(
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: margin,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * -8),
                    child: child,
                  ),
                );
              },
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    .circular(Sizes.p12),
                  ),
                  onTap: onDismiss,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 360),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p12,
                      vertical: Sizes.p8,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: const BorderRadius.all(
                        .circular(Sizes.p12),
                      ),
                      border: Border.all(color: fg.withValues(alpha: .22)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .08),
                          blurRadius: Sizes.p16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: Sizes.p16, color: fg),
                        Gaps.w8,
                        Flexible(
                          child: Text(
                            message,
                            maxLines: 2,
                            overflow: .ellipsis,
                            style: context.text.bodySmall?.copyWith(
                              color: fg,
                              fontWeight: .w600,
                            ),
                          ),
                        ),
                        Gaps.w8,
                        Icon(
                          Icons.close_rounded,
                          size: Sizes.p16,
                          color: fg,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  (Color, Color, IconData) _resolveStyle(AppFeedbackColors feedback) {
    return switch (tone) {
      AppBubbleToastTone.info => (
        feedback.infoBackground,
        feedback.infoForeground,
        Icons.info_outline_rounded,
      ),
      AppBubbleToastTone.success => (
        feedback.successBackground,
        feedback.successForeground,
        Icons.check_circle_outline_rounded,
      ),
      AppBubbleToastTone.warning => (
        feedback.warningBackground,
        feedback.warningForeground,
        Icons.warning_amber_rounded,
      ),
      AppBubbleToastTone.error => (
        feedback.errorBackground,
        feedback.errorForeground,
        Icons.error_outline_rounded,
      ),
    };
  }
}
