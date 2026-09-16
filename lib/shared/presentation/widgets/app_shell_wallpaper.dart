import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/shared/presentation/widgets/app_wallpaper_background.dart';

/// Trwała tapeta globalnego shellu aplikacji.
///
/// Router wymienia nad nią wyłącznie treść modułów. Tapeta nie jest tworzona
/// ponownie przy przejściu między katalogiem Workspaces, wybranym workspace'em
/// i jego ekranami zasobów.
class AppShellWallpaper extends StatefulWidget {
  const AppShellWallpaper({
    required this.child,
    required this.refreshListenable,
    super.key,
  });

  final Widget child;
  final Listenable refreshListenable;

  @override
  State<AppShellWallpaper> createState() => _AppShellWallpaperState();
}

class _AppShellWallpaperState extends State<AppShellWallpaper> {
  static final Map<String, String> _wallpaperCache = {};

  String? _readyUserId;
  String _wallpaperPath = dashboardDefaultWallpaperPaths.first;

  @override
  void initState() {
    super.initState();
    widget.refreshListenable.addListener(_refreshWallpaper);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final readyUserId = _resolveReadyUserId();
    if (readyUserId == _readyUserId) {
      return;
    }

    _readyUserId = readyUserId;
    _wallpaperPath =
        _wallpaperCache[readyUserId] ?? dashboardDefaultWallpaperPaths.first;
    unawaited(_loadWallpaper(readyUserId));
  }

  @override
  void didUpdateWidget(covariant AppShellWallpaper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshListenable == widget.refreshListenable) {
      return;
    }
    oldWidget.refreshListenable.removeListener(_refreshWallpaper);
    widget.refreshListenable.addListener(_refreshWallpaper);
  }

  String _resolveReadyUserId() {
    final authState = context.read<AuthCubit>().state;
    final launchContext = context.read<HostLaunchContext>();
    return resolveReadyUserId(
      user: switch (authState) {
        AuthAuthenticated(:final user) => user,
        _ => null,
      },
      hostUserId: launchContext.userId,
    );
  }

  void _refreshWallpaper() {
    final readyUserId = _readyUserId;
    if (readyUserId != null) {
      unawaited(_loadWallpaper(readyUserId));
    }
  }

  Future<void> _loadWallpaper(String readyUserId) async {
    final repository = context.read<DashboardPreferencesRepository>();
    final preferences = await repository.getPreferences(
      readyUserId: readyUserId,
    );
    final path = preferences.selectedWallpaperPath;
    _wallpaperCache[readyUserId] = path;
    if (!mounted || _readyUserId != readyUserId || _wallpaperPath == path) {
      return;
    }
    setState(() => _wallpaperPath = path);
  }

  @override
  void dispose() {
    widget.refreshListenable.removeListener(_refreshWallpaper);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: AppWallpaperBackground(
            wallpaper: appWallpaperProviderFromPath(_wallpaperPath),
          ),
        ),
        widget.child,
      ],
    );
  }
}
