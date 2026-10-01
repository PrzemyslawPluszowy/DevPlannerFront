import 'package:dartz/dartz.dart' show Either;
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/storage/transport/text_preview_loader_impl.dart';
import 'package:devplanner/workspaces/domain/storage/ports/text_preview_loader.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_failure_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Ograniczony, zaznaczalny tekst z błędem API i odczytem aktualnego źródła.
class StorageTextPreview extends StatefulWidget {
  const StorageTextPreview({
    required this.url,
    this.loader,
    this.headers = const {},
    super.key,
  });

  final String url;
  final TextPreviewLoader? loader;

  /// Nagłówki uwierzytelnionego strumienia; nie są logowane.
  final Map<String, String> headers;

  @override
  State<StorageTextPreview> createState() => _StorageTextPreviewState();
}

class _StorageTextPreviewState extends State<StorageTextPreview> {
  late TextPreviewLoader _loader;
  late final ValueNotifier<Future<Either<ApiError, String>>> _content;
  TextPreviewLoaderImpl? _ownedLoader;

  @override
  void initState() {
    super.initState();
    _configureLoader();
    _content = ValueNotifier(_loader.load(widget.url));
  }

  @override
  void didUpdateWidget(StorageTextPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.loader, widget.loader) ||
        !mapEquals(oldWidget.headers, widget.headers)) {
      _configureLoader();
      _content.value = _loader.load(widget.url);
    } else if (oldWidget.url != widget.url) {
      _content.value = _loader.load(widget.url);
    }
  }

  void _configureLoader() {
    _ownedLoader?.close();
    _ownedLoader = widget.loader == null
        ? TextPreviewLoaderImpl(headers: widget.headers)
        : null;
    _loader = widget.loader ?? _ownedLoader!;
  }

  Future<void> _retry(ApiError error) async {
    final retryAfter = error.retryAfterUtc;
    if (!mounted ||
        (retryAfter != null && DateTime.now().toUtc().isBefore(retryAfter))) {
      return;
    }
    _content.value = _loader.load(widget.url);
  }

  @override
  void dispose() {
    _content.dispose();
    _ownedLoader?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<Future<Either<ApiError, String>>>(
        valueListenable: _content,
        builder: (context, future, _) =>
            FutureBuilder<Either<ApiError, String>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final result = snapshot.data;
                if (result == null) {
                  return StoragePreviewFailureView(
                    message: context.l10n.storageTextLoadError,
                    onRetry: () => _retry(
                      const ApiError(type: ApiErrorType.unknown, message: ''),
                    ),
                  );
                }
                return result.fold(
                  (error) => StoragePreviewFailureView(
                    message: error.message,
                    error: error,
                    onRetry: () => _retry(error),
                  ),
                  (text) => Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: SelectableText(
                          text,
                          style: context.text.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                            height: 1.45,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      );
}
