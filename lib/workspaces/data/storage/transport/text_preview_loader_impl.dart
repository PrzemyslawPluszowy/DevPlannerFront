import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/storage/ports/text_preview_loader.dart';

/// Streamed text loader shared by Web/Wasm and desktop targets.
final class TextPreviewLoaderImpl implements TextPreviewLoader {
  /// Creates a loader; [dio] is injectable for deterministic tests.
  TextPreviewLoaderImpl({Dio? dio, this.headers}) : _dio = dio ?? Dio();

  final Dio _dio;
  final Map<String, String>? headers;

  @override
  Future<Either<ApiError, String>> load(
    String url, {
    int maxBytes = 1024 * 1024,
  }) async {
    try {
      final response = await _dio.get<ResponseBody>(
        url,
        options: Options(responseType: ResponseType.stream, headers: headers),
      );
      final body = response.data;
      if (body == null) {
        return const Left(
          ApiError(
            type: ApiErrorType.parsing,
            message: 'Serwer zwrócił pusty podgląd tekstu.',
          ),
        );
      }

      final bytes = <int>[];
      await for (final chunk in body.stream) {
        final remaining = maxBytes - bytes.length;
        if (remaining <= 0) break;
        bytes.addAll(
          chunk.length <= remaining ? chunk : chunk.sublist(0, remaining),
        );
      }
      return Right(utf8.decode(bytes, allowMalformed: true));
    } on DioException catch (error) {
      return Left(
        ApiError.fromDioException(
          error,
          fallbackMessage: 'Nie udało się pobrać podglądu tekstu.',
        ),
      );
    } on Object catch (error) {
      return Left(
        ApiError(
          type: ApiErrorType.parsing,
          message: 'Nie udało się odczytać podglądu tekstu: $error',
        ),
      );
    }
  }
}
