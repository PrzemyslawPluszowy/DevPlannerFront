import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';

/// Fallback dla platform bez dedykowanego adaptera pobierania.
final class StorageDownloadPlatform {
  const StorageDownloadPlatform._();

  static Future<Either<ApiError, Unit>> downloadUrl(
    String downloadUrl,
    String fileName, {
    Map<String, String>? headers,
  }) => throw UnsupportedError(
    'Brak implementacji platformowej DownloadTransport',
  );

  static Future<Either<ApiError, Uint8List>> fetchBytes(
    String downloadUrl, {
    Map<String, String>? headers,
  }) => throw UnsupportedError(
    'Brak implementacji platformowej DownloadTransport',
  );

  static Future<Either<ApiError, Unit>> saveBytes(
    List<int> bytes,
    String fileName,
  ) => throw UnsupportedError(
    'Brak implementacji platformowej DownloadTransport',
  );
}
