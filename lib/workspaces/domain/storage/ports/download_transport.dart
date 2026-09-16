import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';

/// Abstrakcja pobierania i zapisywania plików na urządzeniu użytkownika.
abstract interface class DownloadTransport {
  /// Otwiera pobieranie pliku z bezpiecznego adresu downloadUrl.
  Future<Either<ApiError, Unit>> downloadUrl({
    required String downloadUrl,
    required String fileName,
    Map<String, String>? headers,
  });

  /// Pobiera surowe bajty wskazanego pliku (np. PDF do wydruku).
  Future<Either<ApiError, Uint8List>> fetchBytes({
    required String downloadUrl,
    Map<String, String>? headers,
  });

  /// Zapisuje surowe bajty pod wskazaną nazwą pliku.
  Future<Either<ApiError, Unit>> saveBytes({
    required List<int> bytes,
    required String fileName,
  });
}
