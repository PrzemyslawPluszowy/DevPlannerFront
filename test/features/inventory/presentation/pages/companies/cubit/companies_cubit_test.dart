import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/companies_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/companies_state.dart';

class _MockStockRepository extends Mock implements StockRepository {}

void main() {
  late StockRepository repository;

  const companies = [
    GetFirmyItem(id: 1, idFirmy: 1, nazwa: 'AAA'),
    GetFirmyItem(id: 2, idFirmy: 2, nazwa: 'BBB'),
  ];

  setUp(() {
    repository = _MockStockRepository();
  });

  group('CompaniesCubit', () {
    blocTest<CompaniesCubit, CompaniesState>(
      'load: emituje loading i success (wykrywa brak odswiezania listy firm)',
      setUp: () {
        when(() => repository.fetchCompanies()).thenAnswer(
          (_) async => const Right(companies),
        );
      },
      build: () => CompaniesCubit(repository: repository),
      act: (cubit) => cubit.load(),
      expect: () => const <CompaniesState>[
        CompaniesLoading(),
        CompaniesSuccess(companies: companies),
      ],
      verify: (_) {
        verify(() => repository.fetchCompanies()).called(1);
      },
    );

    blocTest<CompaniesCubit, CompaniesState>(
      'load(forceRefresh): przekazuje forceRefresh=true (wykrywa przypadek odswiezania stalego cache)',
      setUp: () {
        when(
          () => repository.fetchCompanies(forceRefresh: true),
        ).thenAnswer((_) async => const Right(companies));
      },
      build: () => CompaniesCubit(repository: repository),
      act: (cubit) => cubit.load(forceRefresh: true),
      expect: () => const <CompaniesState>[
        CompaniesLoading(),
        CompaniesSuccess(companies: companies),
      ],
      verify: (_) {
        verify(() => repository.fetchCompanies(forceRefresh: true)).called(1);
      },
    );

    blocTest<CompaniesCubit, CompaniesState>(
      'load: emituje error dla bledu repozytorium (wykrywa brak propagacji bledu)',
      setUp: () {
        when(() => repository.fetchCompanies()).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak polaczenia.',
            ),
          ),
        );
      },
      build: () => CompaniesCubit(repository: repository),
      act: (cubit) => cubit.load(),
      expect: () => const <CompaniesState>[
        CompaniesLoading(),
        CompaniesError(message: 'Brak polaczenia.'),
      ],
    );
  });
}
