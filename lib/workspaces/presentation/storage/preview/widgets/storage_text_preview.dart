import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/storage/transport/text_preview_loader_impl.dart';
import 'package:devplanner/workspaces/domain/storage/ports/text_preview_loader.dart';
import 'package:flutter/material.dart';

/// Bounded, selectable text preview that never buffers an unbounded file.
class StorageTextPreview extends StatefulWidget {
  /// Creates a text preview.
  const StorageTextPreview({required this.url, this.loader, super.key});

  /// Presigned or authenticated text URL.
  final String url;

  /// Injectable loader used by tests.
  final TextPreviewLoader? loader;

  @override
  State<StorageTextPreview> createState() => _StorageTextPreviewState();
}

class _StorageTextPreviewState extends State<StorageTextPreview> {
  late final Future<String> _content;

  @override
  void initState() {
    super.initState();
    _content = _load();
  }

  Future<String> _load() async {
    final result = await (widget.loader ?? TextPreviewLoaderImpl()).load(
      widget.url,
    );
    return result.fold(
      (error) => throw _TextPreviewException(error.message),
      (text) => text,
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
    future: _content,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      if (snapshot.hasError) {
        final error = snapshot.error;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error is _TextPreviewException ? error.message : error.toString(),
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.error,
              ),
            ),
          ),
        );
      }
      return Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: SelectableText(
              snapshot.data ?? '',
              style: context.text.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                height: 1.45,
              ),
            ),
          ),
        ),
      );
    },
  );
}

final class _TextPreviewException implements Exception {
  const _TextPreviewException(this.message);

  final String message;
}
