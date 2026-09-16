import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Embedded streaming player for audio and video on Web/Wasm and desktop.
class StorageMediaPreview extends StatefulWidget {
  /// Creates a player for a short-lived streaming URL.
  const StorageMediaPreview({
    required this.url,
    required this.isAudio,
    this.headers = const {},
    super.key,
  });

  /// Presigned or authenticated media URL.
  final String url;

  /// Whether to render the compact audio variant.
  final bool isAudio;

  /// Optional Authorization headers for authenticated streams.
  final Map<String, String> headers;

  @override
  State<StorageMediaPreview> createState() => _StorageMediaPreviewState();
}

class _StorageMediaPreviewState extends State<StorageMediaPreview> {
  late final Player _player;
  late final VideoController _controller;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    unawaited(
      _player.open(Media(widget.url, httpHeaders: widget.headers), play: false),
    );
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 960,
        maxHeight: widget.isAudio ? 140 : 620,
      ),
      child: Video(
        controller: _controller,
        fit: widget.isAudio ? BoxFit.none : BoxFit.contain,
      ),
    ),
  );
}
