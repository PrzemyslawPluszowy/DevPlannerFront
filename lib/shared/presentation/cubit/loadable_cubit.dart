import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

/// Uniwersalny stan widoku oparty o typ danych [T].
///
/// Pozwala utrzymac spojny kontrakt pomiedzy ekranami:
/// - `initial` przed pierwszym ladowaniem,
/// - `loading` podczas pobierania,
/// - `success` po sukcesie z opcjonalnymi danymi,
/// - `error` gdy wystapil blad.
sealed class LoadableState<T> extends Equatable {
  /// Tworzy bazowy stan ladowania.
  const LoadableState();

  /// Tworzy stan poczatkowy.
  const factory LoadableState.initial() = LoadableInitial<T>;

  /// Tworzy stan ladowania.
  const factory LoadableState.loading({T? previousData}) = LoadableLoading<T>;

  /// Tworzy stan sukcesu.
  const factory LoadableState.success({required T data}) = LoadableSuccess<T>;

  /// Tworzy stan bledu.
  const factory LoadableState.error({
    required String message,
    T? previousData,
  }) = LoadableError<T>;

  /// Dane widoku niezaleznie od wariantu stanu.
  T? get data;

  /// Komunikat bledu dla wariantu `error`.
  String? get errorMessage;

  /// Czy widok jest w stanie poczatkowym.
  bool get isInitial => switch (this) {
    LoadableInitial<T>() => true,
    _ => false,
  };

  /// Czy widok jest w trakcie ladowania.
  bool get isLoading => switch (this) {
    LoadableLoading<T>() => true,
    _ => false,
  };

  /// Czy widok zakonczyl ladowanie sukcesem.
  bool get isSuccess => switch (this) {
    LoadableSuccess<T>() => true,
    _ => false,
  };

  /// Czy widok zakonczyl ladowanie bledem.
  bool get isError => switch (this) {
    LoadableError<T>() => true,
    _ => false,
  };

  /// Mapuje stan na wartosc [R] przez pelny, wyczerpujacy `switch`.
  R map<R>({
    required R Function() initial,
    required R Function(T? previousData) loading,
    required R Function(T data) success,
    required R Function(String message, T? previousData) error,
  }) {
    return switch (this) {
      LoadableInitial<T>() => initial(),
      LoadableLoading<T>(:final previousData) => loading(previousData),
      LoadableSuccess<T>(:final data) => success(data),
      LoadableError<T>(:final message, :final previousData) => error(
        message,
        previousData,
      ),
    };
  }
}

/// Stan poczatkowy przed pierwszym ladowaniem danych.
final class LoadableInitial<T> extends LoadableState<T> {
  /// Tworzy stan poczatkowy.
  const LoadableInitial();

  @override
  T? get data => null;

  @override
  String? get errorMessage => null;

  @override
  List<Object?> get props => const [];
}

/// Stan aktywnego ladowania danych.
final class LoadableLoading<T> extends LoadableState<T> {
  /// Tworzy stan ladowania z opcjonalnymi poprzednimi danymi.
  const LoadableLoading({this.previousData});

  /// Ostatnie dane, ktore mozna pokazac podczas odswiezania.
  final T? previousData;

  @override
  T? get data => previousData;

  @override
  String? get errorMessage => null;

  @override
  List<Object?> get props => [previousData];
}

/// Stan sukcesu z zaladowanymi danymi.
final class LoadableSuccess<T> extends LoadableState<T> {
  /// Tworzy stan sukcesu z wymaganymi danymi.
  const LoadableSuccess({required this.data});

  @override
  final T data;

  @override
  String? get errorMessage => null;

  @override
  List<Object?> get props => [data];
}

/// Stan bledu podczas ladowania danych.
final class LoadableError<T> extends LoadableState<T> {
  /// Tworzy stan bledu z komunikatem i opcjonalnymi danymi poprzednimi.
  const LoadableError({required this.message, this.previousData});

  /// Komunikat bledu.
  final String message;

  /// Ostatnie poprawne dane mozliwe do utrzymania na widoku.
  final T? previousData;

  @override
  T? get data => previousData;

  @override
  String? get errorMessage => message;

  @override
  List<Object?> get props => [message, previousData];
}

/// Bazowy cubit dla ekranow korzystajacych z [LoadableState].
abstract class LoadableCubit<T> extends Cubit<LoadableState<T>> {
  /// Tworzy bazowy cubit z poczatkowym stanem `initial`.
  LoadableCubit() : super(LoadableState<T>.initial());

  /// Ustawia stan ladowania z mozliwoscia zachowania poprzednich danych.
  void emitLoading({bool keepPreviousData = true}) {
    final previous = keepPreviousData ? state.data : null;
    emit(LoadableState<T>.loading(previousData: previous));
  }

  /// Ustawia stan sukcesu.
  void emitSuccess(T data) {
    emit(LoadableState<T>.success(data: data));
  }

  /// Ustawia stan bledu z opcjonalnym zachowaniem poprzednich danych.
  void emitError(String message, {bool keepPreviousData = true}) {
    final previous = keepPreviousData ? state.data : null;
    emit(LoadableState<T>.error(message: message, previousData: previous));
  }

  /// Ustawia ponownie stan poczatkowy.
  void reset() {
    emit(LoadableState<T>.initial());
  }
}
