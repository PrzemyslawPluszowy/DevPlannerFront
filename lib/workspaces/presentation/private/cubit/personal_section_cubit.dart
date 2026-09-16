import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/presentation/private/cubit/personal_section_state.dart';

/// Wynik dostawcy prywatnej sekcji, przygotowany do podłączenia API bez
/// przenoszenia transportu do widgetu.
sealed class PersonalSectionLoadResult {
  const PersonalSectionLoadResult();
}

/// Dane prywatnej sekcji zwrócone przez repository.
final class PersonalSectionData extends PersonalSectionLoadResult {
  const PersonalSectionData({
    required this.itemCount,
    this.tasks = const [],
    this.nextCursor,
  });

  final int itemCount;
  final List<MyTaskListItemResponse> tasks;
  final String? nextCursor;
}

/// Jawna informacja, że endpoint globalny nie jest jeszcze dostępny.
final class PersonalSectionContractUnavailable
    extends PersonalSectionLoadResult {
  const PersonalSectionContractUnavailable({required this.message});

  final String message;
}

/// Błąd domenowy, który UI ma pokazać użytkownikowi.
final class PersonalSectionLoadFailure extends PersonalSectionLoadResult {
  const PersonalSectionLoadFailure({required this.message, this.code});

  final String message;
  final String? code;
}

/// Źródło danych prywatnej sekcji. Transport implementuje repository.
typedef PersonalSectionLoader = Future<PersonalSectionLoadResult> Function(
  String? cursor,
);

/// Lokalny Cubit prywatnego katalogu, niezależny od globalnego routingu.
class PersonalSectionCubit extends Cubit<PersonalSectionState> {
  PersonalSectionCubit({required this._loader})
    : super(const PersonalSectionInitial());

  final PersonalSectionLoader _loader;

  /// Ładuje dane przez warstwę domenową i zachowuje jawne stany błędów.
  Future<void> load() => _fetch(reset: true);

  /// Dopina kolejną stronę tylko dla dostępnego cursorowego źródła danych.
  Future<void> loadMore() async {
    final current = state;
    if (current is! PersonalSectionReady ||
        current.isLoadingMore ||
        current.nextCursor == null) {
      return;
    }
    await _fetch(reset: false, current: current);
  }

  Future<void> _fetch({
    required bool reset,
    PersonalSectionReady? current,
  }) async {
    if (isClosed) return;
    if (reset) {
      emit(const PersonalSectionLoading());
    } else {
      emit(current!.copyWith(isLoadingMore: true, clearLoadMoreError: true));
    }
    try {
      final result = await _loader(reset ? null : current!.nextCursor);
      if (isClosed) return;
      switch (result) {
        case PersonalSectionData(
          :final itemCount,
          :final tasks,
          :final nextCursor,
        ):
          final merged = reset
              ? tasks
              : _deduplicate([...current!.tasks, ...tasks]);
          emit(
            PersonalSectionReady(
              itemCount: reset ? itemCount : current!.itemCount + itemCount,
              tasks: merged,
              nextCursor: nextCursor,
            ),
          );
        case PersonalSectionContractUnavailable(:final message):
          if (reset) emit(PersonalSectionUnavailable(message: message));
        case PersonalSectionLoadFailure(:final message, :final code):
          if (reset) {
            emit(PersonalSectionFailure(message: message, code: code));
          } else {
            emit(
              current!.copyWith(
                isLoadingMore: false,
                loadMoreError: message,
              ),
            );
          }
      }
    } catch (error) {
      if (isClosed) return;
      if (reset) {
        emit(PersonalSectionFailure(message: error.toString()));
      } else {
        emit(
          current!.copyWith(
            isLoadingMore: false,
            loadMoreError: error.toString(),
          ),
        );
      }
    }
  }

  List<MyTaskListItemResponse> _deduplicate(
    Iterable<MyTaskListItemResponse> tasks,
  ) {
    final ids = <String>{};
    return [
      for (final task in tasks)
        if (ids.add(task.id)) task,
    ];
  }
}
