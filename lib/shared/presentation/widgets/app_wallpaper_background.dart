import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Konwertuje ścieżkę do tapety na ImageProvider z obsługą assetów i plików lokalnych.
ImageProvider<Object>? appWallpaperProviderFromPath(String path) {
  final trimmed = path.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  if (trimmed.startsWith('assets/')) {
    return AssetImage(trimmed);
  }

  if (kIsWeb) {
    return null;
  }

  final file = File(trimmed);
  if (!file.existsSync()) {
    return null;
  }

  return FileImage(file);
}

/// Współdzielone tło tapety aplikacji z ambientowym gradientem i obsługą motywu.
class AppWallpaperBackground extends StatelessWidget {
  /// Tworzy tło tapety aplikacji.
  const AppWallpaperBackground({
    required this.wallpaper,
    super.key,
    this.overlayAlphaStart = .08,
    this.overlayAlphaEnd = .28,
  });

  /// Provider obrazu tapety.
  final ImageProvider<Object>? wallpaper;

  /// Początkowa przezroczystość nakładki gradientowej na górze.
  final double overlayAlphaStart;

  /// Końcowa przezroczystość nakładki gradientowej na dole.
  final double overlayAlphaEnd;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.colors.surface),
      child: Stack(
        children: [
          if (wallpaper != null)
            Positioned.fill(
              child: Image(
                image: wallpaper!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.expand(),
              ),
            ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.colors.surface.withValues(alpha: overlayAlphaStart),
                    context.colors.surface.withValues(
                      alpha: (overlayAlphaStart + overlayAlphaEnd) / 2,
                    ),
                    context.colors.surface.withValues(alpha: overlayAlphaEnd),
                  ],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}
