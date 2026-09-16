import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:web/web.dart' as web;

/// Operacje pobierania przeznaczone dla Web/Wasm.
final class StorageDownloadPlatform {
  const StorageDownloadPlatform._();

  /// Uruchamia pobieranie bez kopiowania odpowiedzi do pamięci aplikacji,
  /// a w przypadku obecności nagłówków (np. JWT) pobiera plik i wyzwala zapis bloba.
  static Future<Either<ApiError, Unit>> downloadUrl(
    String downloadUrl,
    String fileName, {
    Map<String, String>? headers,
  }) async {
    try {
      if (headers != null && headers.isNotEmpty) {
        final bytesResult = await fetchBytes(downloadUrl, headers: headers);
        return await bytesResult.fold<Future<Either<ApiError, Unit>>>(
          (err) async => Left(err),
          (bytes) => saveBytes(bytes, fileName),
        );
      }

      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = downloadUrl;
      anchor.download = fileName;
      anchor.target = '_blank';
      web.document.body?.appendChild(anchor);
      anchor.click();
      anchor.remove();
      return const Right(unit);
    } catch (e) {
      return Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się rozpocząć pobierania w przeglądarce: $e',
        ),
      );
    }
  }

  /// Pobiera surowe bajty pliku (np. do wydruku przez Printing).
  static Future<Either<ApiError, Uint8List>> fetchBytes(
    String downloadUrl, {
    Map<String, String>? headers,
  }) async {
    try {
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
        return Right(Uint8List.fromList(data));
      } finally {
        dio.close(force: true);
      }
    } on DioException catch (e) {
      return Left(
        ApiError.fromDioException(
          e,
          fallbackMessage: 'Nie udało się pobrać pliku.',
        ),
      );
    } catch (e) {
      return Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się pobrać pliku w przeglądarce: $e',
        ),
      );
    }
  }

  /// Implementacja zapisu surowych bajtów dla przeglądarki Web (Wasm / JS).
  static Future<Either<ApiError, Unit>> saveBytes(
    List<int> bytes,
    String fileName,
  ) async {
    try {
      final uint8 = Uint8List.fromList(bytes);
      final jsArray = [uint8.toJS].toJS;
      final blob = web.Blob(jsArray);
      final url = web.URL.createObjectURL(blob);

      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = fileName;
      web.document.body?.appendChild(anchor);
      anchor.click();
      anchor.remove();
      web.URL.revokeObjectURL(url);
      return const Right(unit);
    } catch (e) {
      return Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się zapisać pliku w przeglądarce: $e',
        ),
      );
    }
  }
}
