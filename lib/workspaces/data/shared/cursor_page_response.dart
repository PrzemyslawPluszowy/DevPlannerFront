import 'package:freezed_annotation/freezed_annotation.dart';

part 'cursor_page_response.freezed.dart';
part 'cursor_page_response.g.dart';

/// Cursorowa strona odpowiedzi zgodna z `CursorPageResponse<T>` z C#.
@Freezed(genericArgumentFactories: true, makeCollectionsUnmodifiable: false)
abstract class CursorPageResponse<T> with _$CursorPageResponse<T> {
  /// Tworzy stronę elementów oraz nieprzezroczysty kursor kolejnej strony.
  const factory CursorPageResponse({
    /// Elementy bieżącej strony.
    required List<T> items,

    /// Kursor następnej strony albo null na końcu listy.
    String? nextCursor,
  }) = _CursorPageResponse<T>;

  /// Odtwarza stronę z JSON z użyciem fabryki elementu.
  factory CursorPageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$CursorPageResponseFromJson(json, fromJsonT);
}
