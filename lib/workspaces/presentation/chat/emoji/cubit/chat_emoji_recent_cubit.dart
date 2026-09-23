import 'package:flutter_bloc/flutter_bloc.dart';

/// Sesyjny właściciel listy ostatnio użytych emoji.
///
/// Lista żyje wyłącznie w pamięci bieżącej sesji: nie trafia do storage, Hive
/// ani na serwer, więc nie przenosi preferencji między sesjami ani kontami.
final class ChatEmojiRecentCubit extends Cubit<List<String>> {
  /// Tworzy pustą listę z limitem pozycji.
  ChatEmojiRecentCubit({this.limit = 24}) : super(const <String>[]);

  /// Maksymalna liczba pamiętanych znaków.
  final int limit;

  /// Zapamiętuje użyty znak, przesuwając go na początek listy.
  void remember(String emoji) {
    final trimmed = emoji.trim();
    if (trimmed.isEmpty) return;
    final next = <String>[
      trimmed,
      ...state.where((item) => item != trimmed),
    ];
    if (next.length > limit) next.removeRange(limit, next.length);
    emit(List.unmodifiable(next));
  }

  /// Czyści listę; używane przy zmianie konta albo wylogowaniu.
  void clear() => emit(const <String>[]);
}
