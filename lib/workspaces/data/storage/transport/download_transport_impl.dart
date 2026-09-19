import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/transport/download_transport_stub.dart'
    if (dart.library.js_interop) 'package:devplanner/workspaces/data/storage/transport/download_transport_web.dart'
    if (dart.library.io) 'package:devplanner/workspaces/data/storage/transport/download_transport_io.dart'
    as platform;
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';

/// Implementacja [DownloadTransport] delegująca do adaptera właściwego dla platformy.
final class DownloadTransportImpl implements DownloadTransport {
  /// Tworzy transport pobierania.
  const DownloadTransportImpl();

  @override
  Future<Either<ApiError, Unit>> downloadUrl({
    required String downloadUrl,
    required String fileName,
    Map<String, String>? headers,
  }) => platform.StorageDownloadPlatform.downloadUrl(
    downloadUrl,
    fileName,
    headers: headers,
  );

  @override
  Future<Either<ApiError, Uint8List>> fetchBytes({
    required String downloadUrl,
    Map<String, String>? headers,
  }) => platform.StorageDownloadPlatform.fetchBytes(
    downloadUrl,
    headers: headers,
  );

  @override
  Future<Either<ApiError, Unit>> saveBytes({
    required List<int> bytes,
    required String fileName,
  }) => platform.StorageDownloadPlatform.saveBytes(bytes, fileName);
}
