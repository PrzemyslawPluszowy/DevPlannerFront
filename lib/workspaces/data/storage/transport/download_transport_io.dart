import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ready_next/core/error/api_error.dart';

/// Operacje zapisu plików dla macOS, Windows i Linux.
final class StorageDownloadPlatform {
  const StorageDownloadPlatform._();

  /// Rozwiązuje docelową ścieżkę zapisu w katalogu Downloads z unikalną nazwą.
  static Future<String> _resolveDownloadPath(String fileName) async {
    Directory? baseDir;
    try {
      baseDir = await getDownloadsDirectory();
    } catch (e) {
      debugPrint('[storage.download] Błąd pobierania katalogu Downloads: $e');
    }
    baseDir ??= await getApplicationDocumentsDirectory();

    final nameWithoutExt = p.basenameWithoutExtension(fileName);
    final ext = p.extension(fileName);

    var candidate = p.join(baseDir.path, fileName);
    var counter = 1;
    while (File(candidate).existsSync()) {
      candidate = p.join(baseDir.path, '$nameWithoutExt ($counter)$ext');
      counter++;
    }
    return candidate;
  }

  /// Pobiera odpowiedź bezpośrednio do wskazanego pliku w folderze Pobrane.
  static Future<Either<ApiError, Unit>> downloadUrl(
    String downloadUrl,
    String fileName, {
    Map<String, String>? headers,
  }) async {
    try {
      final targetPath = await _resolveDownloadPath(fileName);
      debugPrint(
        '[storage.download] Pobieranie $fileName do $targetPath z adresu: $downloadUrl',
      );

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 60),
          headers: headers,
        ),
      );
      try {
        await dio.download(downloadUrl, targetPath);
        debugPrint('[storage.download] Pomyślnie zapisano plik: $targetPath');
      } finally {
        dio.close(force: true);
      }
      return const Right(unit);
    } on DioException catch (e) {
      debugPrint('[storage.download] Błąd Dio: $e');
      return Left(
        ApiError.fromDioException(
          e,
          fallbackMessage: 'Nie udało się pobrać pliku na dysk.',
        ),
      );
    } catch (e) {
      debugPrint('[storage.download] Nieoczekiwany błąd zapisu: $e');
      return Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się zapisać pliku na dysku: $e',
        ),
      );
    }
  }

  /// Pobiera surowe bajty pliku do pamięci podręcznej (np. do wydruku).
  static Future<Either<ApiError, Uint8List>> fetchBytes(
    String downloadUrl, {
    Map<String, String>? headers,
  }) async {
    try {
      debugPrint('[storage.download] Pobieranie bajtów z $downloadUrl');
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 60),
          responseType: ResponseType.bytes,
          headers: headers,
        ),
      );
      try {
        final response = await dio.get<List<int>>(downloadUrl);
        final data = response.data;
        if (data == null) {
          return const Left(
            ApiError(
              type: ApiErrorType.unknown,
              message: 'Brak zawartości pliku.',
            ),
          );
        }
        debugPrint('[storage.download] Pomyślnie pobrano ${data.length} bajtów');
        return Right(Uint8List.fromList(data));
      } finally {
        dio.close(force: true);
      }
    } on DioException catch (e) {
      debugPrint('[storage.download] Błąd fetchBytes Dio: $e');
      return Left(
        ApiError.fromDioException(
          e,
          fallbackMessage: 'Nie udało się pobrać pliku.',
        ),
      );
    } catch (e) {
      debugPrint('[storage.download] Nieoczekiwany błąd fetchBytes: $e');
      return Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się pobrać pliku: $e',
        ),
      );
    }
  }

  /// Zapisuje gotową zawartość binarną, na przykład archiwum z API.
  static Future<Either<ApiError, Unit>> saveBytes(
    List<int> bytes,
    String fileName,
  ) async {
    try {
      final targetPath = await _resolveDownloadPath(fileName);
      debugPrint('[storage.download] Zapisywanie bajtów do $targetPath');
      final file = File(targetPath);
      await file.writeAsBytes(bytes, flush: true);
      debugPrint('[storage.download] Pomyślnie zapisano ${bytes.length} bajtów');
      return const Right(unit);
    } catch (e) {
      debugPrint('[storage.download] Błąd saveBytes: $e');
      return Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się zapisać pliku: $e',
        ),
      );
    }
  }
}
