import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/delete_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/delete_stan_st_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/delete_stan_st_state.dart';

/// Mock repozytorium `StockRepository` dla testow cubita usuwania `stan_st`.
class _MockStockRepository extends Mock implements StockRepository {}

void main() {
  late StockRepository repository;

  const response = DeleteStanStResponseData(id: 15);

  setUp(() {
    repository = _MockStockRepository();
  });

  blocTest<DeleteStanStCubit, DeleteStanStState>(
    'submit emituje submitting i success po poprawnym usunieciu rekordu',
    setUp: () {
      when(
        () => repository.deleteStockItem(
          stockItemId: 15,
          confirmNrewid: 'ST/15',
          confirmNazwa: 'Laptop testowy',
        ),
      ).thenAnswer((_) async => const Right(response));
    },
    build: () => DeleteStanStCubit(repository: repository),
    act: (cubit) => cubit.submit(
      stockItemId: 15,
      confirmNrewid: 'ST/15',
      confirmNazwa: 'Laptop testowy',
    ),
    expect: () => const [
      DeleteStanStSubmitting(),
      DeleteStanStSuccess(),
    ],
  );

  blocTest<DeleteStanStCubit, DeleteStanStState>(
    'submit emituje submitting i error po bledzie backendu',
    setUp: () {
      when(
        () => repository.deleteStockItem(
          stockItemId: 18,
          confirmNrewid: 'ST/18',
          confirmNazwa: 'Monitor testowy',
        ),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.conflict,
            message: 'Nie mozna usunac elementu, bo wystepuje w arkuszu.',
          ),
        ),
      );
    },
    build: () => DeleteStanStCubit(repository: repository),
    act: (cubit) => cubit.submit(
      stockItemId: 18,
      confirmNrewid: 'ST/18',
      confirmNazwa: 'Monitor testowy',
    ),
    expect: () => const [
      DeleteStanStSubmitting(),
      DeleteStanStError(
        message: 'Nie mozna usunac elementu, bo wystepuje w arkuszu.',
      ),
    ],
  );
}
