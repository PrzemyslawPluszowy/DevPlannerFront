import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

/// Embedded, zoomable PDF preview for Web/Wasm and desktop.
class StoragePdfPreview extends StatelessWidget {
  /// Creates a PDF viewer backed by a short-lived download URL.
  const StoragePdfPreview({
    required this.url,
    this.headers = const {},
    super.key,
  });

  /// Presigned or authenticated PDF URL.
  final String url;

  /// Optional Authorization headers for authenticated streams.
  final Map<String, String> headers;

  @override
  Widget build(BuildContext context) => PdfViewer.uri(
    Uri.parse(url),
    preferRangeAccess: true,
    headers: headers,
  );
}
