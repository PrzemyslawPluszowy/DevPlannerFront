import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';

/// Loads a bounded UTF-8 text preview without exposing HTTP to presentation.
// A port is intentionally a class despite exposing one operation: project
// architecture forbids top-level feature functions and requires testable IO.
// ignore: one_member_abstracts
abstract interface class TextPreviewLoader {
  /// Loads at most [maxBytes] from [url].
  Future<Either<ApiError, String>> load(
    String url, {
    int maxBytes = 1024 * 1024,
  });
}
