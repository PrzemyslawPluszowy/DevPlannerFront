import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

class _TestLoadableCubit extends LoadableCubit<int> {
  void loading({bool keepPreviousData = true}) {
    emitLoading(keepPreviousData: keepPreviousData);
  }

  void success(int value) {
    emitSuccess(value);
  }

  void failure(String message, {bool keepPreviousData = true}) {
    emitError(message, keepPreviousData: keepPreviousData);
  }
}

void main() {
  group('LoadableCubit', () {
    blocTest<_TestLoadableCubit, LoadableState<int>>(
      'emituje success po zaladowaniu danych',
      build: _TestLoadableCubit.new,
      act: (cubit) => cubit.success(7),
      expect: () => [
        const LoadableSuccess<int>(data: 7),
      ],
    );

    blocTest<_TestLoadableCubit, LoadableState<int>>(
      'zachowuje poprzednie dane podczas loading',
      build: _TestLoadableCubit.new,
      act: (cubit) {
        cubit.success(7);
        cubit.loading();
      },
      expect: () => [
        const LoadableSuccess<int>(data: 7),
        const LoadableLoading<int>(previousData: 7),
      ],
    );

    blocTest<_TestLoadableCubit, LoadableState<int>>(
      'zachowuje poprzednie dane podczas error',
      build: _TestLoadableCubit.new,
      act: (cubit) {
        cubit.success(7);
        cubit.failure('Ups');
      },
      expect: () => [
        const LoadableSuccess<int>(data: 7),
        const LoadableError<int>(message: 'Ups', previousData: 7),
      ],
    );

    blocTest<_TestLoadableCubit, LoadableState<int>>(
      'reset wraca do initial',
      build: _TestLoadableCubit.new,
      act: (cubit) {
        cubit.success(7);
        cubit.reset();
      },
      expect: () => [
        const LoadableSuccess<int>(data: 7),
        const LoadableInitial<int>(),
      ],
    );
  });
}
