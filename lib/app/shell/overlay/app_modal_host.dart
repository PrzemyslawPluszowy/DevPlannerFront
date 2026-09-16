import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart'
    as material
    show showDialog, showModalBottomSheet;

import 'package:ready_next/app/shell/overlay/app_modal_coordinator.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_accessibility_boundary.dart';

/// Wybór navigatora dla modalnej warstwy aplikacji.
///
/// Domyślny `root` chroni globalny shell przed nakładaniem chrome'u nad
/// modalem. `nested` jest wyjątkiem dla świadomie lokalnego flow i wymaga testu
/// w module, który go wybiera.
enum AppModalNavigatorScope { root, nested }

/// Wspólny host route'ów modalnych oraz polityki focusu i navigatora.
///
/// Host nie przechowuje stanu biznesowego. Opcjonalny, lokalny dla sesji
/// `AppModalCoordinator` należy do `AppGlobalShell` i jawnie odrzuca drugi
/// równoległy request. Host zapewnia identyczny root/nested kontrakt, barrier,
/// Escape i przywrócenie focusu dla dialogów, side sheetów i bottom sheetów.
abstract final class AppModalHost {
  /// Otwiera centralny dialog w wybranym navigatorze i odtwarza fokus originu.
  static Future<T?> showDialog<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    AppModalNavigatorScope navigatorScope = AppModalNavigatorScope.root,
    bool barrierDismissible = true,
    String? barrierLabel,
    bool requestFocus = true,
  }) {
    final coordinator = AppModalCoordinatorScope.maybeOf(context);
    final toastController = AppBubbleToastScope.maybeOf(context);
    if (coordinator != null && !coordinator.tryAcquire()) {
      return Future<T?>.value();
    }
    final originFocus = FocusManager.instance.primaryFocus;
    return _restoreFocusAfter(
      material.showDialog<T>(
        context: context,
        useRootNavigator: _usesRootNavigator(navigatorScope),
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel ?? _defaultBarrierLabel(context),
        requestFocus: requestFocus,
        builder: (dialogContext) => AppModalAccessibilityBoundary(
          onDismiss: () => Navigator.of(dialogContext).maybePop(),
          child: _withPresentationOwners(
            coordinator: coordinator,
            toastController: toastController,
            child: Builder(builder: builder),
          ),
        ),
      ),
      coordinator: coordinator,
      originFocus: originFocus,
    );
  }

  /// Otwiera modalny side sheet z ujednoliconą barierą, Escape i animacją.
  static Future<T?> showSideSheet<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    AppModalNavigatorScope navigatorScope = AppModalNavigatorScope.root,
    bool barrierDismissible = true,
    bool canClose = true,
    String? barrierLabel,
    bool requestFocus = true,
  }) {
    final coordinator = AppModalCoordinatorScope.maybeOf(context);
    final toastController = AppBubbleToastScope.maybeOf(context);
    if (coordinator != null && !coordinator.tryAcquire()) {
      return Future<T?>.value();
    }
    final originFocus = FocusManager.instance.primaryFocus;
    return _restoreFocusAfter(
      showGeneralDialog<T>(
        context: context,
        useRootNavigator: _usesRootNavigator(navigatorScope),
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel ?? _defaultBarrierLabel(context),
        barrierColor: Theme.of(context).colorScheme.scrim
            .withValues(alpha: .24),
        transitionDuration: const Duration(milliseconds: 220),
        requestFocus: requestFocus,
        pageBuilder: (dialogContext, animation, secondaryAnimation) => PopScope(
          canPop: canClose,
          child: AppModalAccessibilityBoundary(
            onDismiss: () => Navigator.of(dialogContext).maybePop(),
            child: SafeArea(
              child: _withPresentationOwners(
                coordinator: coordinator,
                toastController: toastController,
                child: Builder(builder: builder),
              ),
            ),
          ),
        ),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(.08, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
      coordinator: coordinator,
      originFocus: originFocus,
    );
  }

  /// Otwiera dolny sheet przez tę samą politykę navigatora oraz focusu.
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    AppModalNavigatorScope navigatorScope = AppModalNavigatorScope.root,
    bool barrierDismissible = true,
    String? barrierLabel,
    bool isScrollControlled = true,
    BoxConstraints? constraints,
    Color backgroundColor = Colors.transparent,
  }) {
    final coordinator = AppModalCoordinatorScope.maybeOf(context);
    final toastController = AppBubbleToastScope.maybeOf(context);
    if (coordinator != null && !coordinator.tryAcquire()) {
      return Future<T?>.value();
    }
    final originFocus = FocusManager.instance.primaryFocus;
    return _restoreFocusAfter(
      material.showModalBottomSheet<T>(
        context: context,
        useRootNavigator: _usesRootNavigator(navigatorScope),
        isDismissible: barrierDismissible,
        barrierLabel: barrierLabel ?? _defaultBarrierLabel(context),
        isScrollControlled: isScrollControlled,
        constraints: constraints,
        backgroundColor: backgroundColor,
        builder: (sheetContext) => AppModalAccessibilityBoundary(
          onDismiss: () => Navigator.of(sheetContext).maybePop(),
          child: _withPresentationOwners(
            coordinator: coordinator,
            toastController: toastController,
            child: Builder(builder: builder),
          ),
        ),
      ),
      coordinator: coordinator,
      originFocus: originFocus,
    );
  }

  static bool _usesRootNavigator(AppModalNavigatorScope navigatorScope) {
    return navigatorScope == AppModalNavigatorScope.root;
  }

  static String _defaultBarrierLabel(BuildContext context) {
    return AppLocalizations.of(context)?.appModalDismiss ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel;
  }

  static Widget _withPresentationOwners({
    required AppModalCoordinator? coordinator,
    required AppBubbleToastController? toastController,
    required Widget child,
  }) {
    final coordinatorScoped = coordinator == null
        ? child
        : AppModalCoordinatorScope(coordinator: coordinator, child: child);
    return toastController == null
        ? coordinatorScoped
        : AppBubbleToastScope(
            controller: toastController,
            child: coordinatorScoped,
          );
  }

  static Future<T?> _restoreFocusAfter<T>(
    Future<T?> modalFuture, {
    required AppModalCoordinator? coordinator,
    required FocusNode? originFocus,
  }) async {
    try {
      return await modalFuture;
    } finally {
      coordinator?.release();
      await _restoreFocusOnNextFrame(originFocus);
    }
  }

  static Future<void> _restoreFocusOnNextFrame(FocusNode? originFocus) {
    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (originFocus?.context != null &&
          (originFocus?.canRequestFocus ?? false)) {
        originFocus!.requestFocus();
      }
      completer.complete();
    });
    return completer.future;
  }

  /// Mapuje zachowany parametr współdzielonych API na jawny kontrakt hosta.
  static AppModalNavigatorScope navigatorScopeFor(bool useRootNavigator) {
    return useRootNavigator
        ? AppModalNavigatorScope.root
        : AppModalNavigatorScope.nested;
  }
}
