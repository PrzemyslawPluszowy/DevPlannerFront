import 'package:equatable/equatable.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';

/// Stany lokalnego ekranu prywatnego użytkownika.
sealed class PersonalSectionState extends Equatable {
  const PersonalSectionState();
}

/// Ekran nie rozpoczął jeszcze odczytu kontraktu.
final class PersonalSectionInitial extends PersonalSectionState {
  const PersonalSectionInitial();

  @override
  List<Object?> get props => const [];
}

/// Trwa przygotowanie danych po stronie warstwy domenowej.
final class PersonalSectionLoading extends PersonalSectionState {
  const PersonalSectionLoading();

  @override
  List<Object?> get props => const [];
}

/// Backend nie udostępnia jeszcze globalnego widoku tej sekcji.
///
/// To jawny stan, a nie pusty fallback: użytkownik widzi, że ekran wymaga
/// właściwego kontraktu, zamiast otrzymać sugerujące nieprawdziwe dane.
final class PersonalSectionUnavailable extends PersonalSectionState {
  const PersonalSectionUnavailable({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Kontrakt zwrócił dane gotowe do prezentacji.
final class PersonalSectionReady extends PersonalSectionState {
  const PersonalSectionReady({
    required this.itemCount,
    this.tasks = const [],
    this.nextCursor,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final int itemCount;
  final List<MyTaskListItemResponse> tasks;
  final String? nextCursor;
  final bool isLoadingMore;
  final String? loadMoreError;

  bool get hasMore => nextCursor != null;

  PersonalSectionReady copyWith({
    List<MyTaskListItemResponse>? tasks,
    String? nextCursor,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) => PersonalSectionReady(
    itemCount: itemCount,
    tasks: tasks ?? this.tasks,
    nextCursor: nextCursor ?? this.nextCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreError: clearLoadMoreError
        ? null
        : loadMoreError ?? this.loadMoreError,
  );

  @override
  List<Object?> get props => [
    itemCount,
    tasks,
    nextCursor,
    isLoadingMore,
    loadMoreError,
  ];
}

/// Błąd odczytu danych prywatnej sekcji.
final class PersonalSectionFailure extends PersonalSectionState {
  const PersonalSectionFailure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}
