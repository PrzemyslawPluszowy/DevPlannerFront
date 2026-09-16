import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/delete_firma_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/delete_company_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/delete_company_state.dart';

class _MockStockRepository extends Mock implements StockRepository {}

void main() {
  late StockRepository repository;

  setUp(() {
    repository = _MockStockRepository();
  });

  group('DeleteCompanyCubit', () {
    blocTest<DeleteCompanyCubit, DeleteCompanyState>(
      'submit: emituje submitting i success gdy delete sie powiedzie (wykrywa brak finalizacji usuwania)',
      setUp: () {
        when(
          () => repository.deleteCompany(5),
        ).thenAnswer((_) async => const Right(DeleteFirmaResponseData(id: 5)));
      },
      build: () => DeleteCompanyCubit(repository: repository),
      act: (cubit) => cubit.submit(companyId: 5),
      expect: () => const <DeleteCompanyState>[
        DeleteCompanySubmitting(),
        DeleteCompanySuccess(),
      ],
      verify: (_) {
        verify(() => repository.deleteCompany(5)).called(1);
      },
    );

    blocTest<DeleteCompanyCubit, DeleteCompanyState>(
      'submit: emituje submitting i error dla bledu backendu (wykrywa utrate komunikatu delete)',
      setUp: () {
        when(
          () => repository.deleteCompany(5),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.conflict,
              message: 'Firma jest uzywana.',
            ),
          ),
        );
      },
      build: () => DeleteCompanyCubit(repository: repository),
      act: (cubit) => cubit.submit(companyId: 5),
      expect: () => const <DeleteCompanyState>[
        DeleteCompanySubmitting(),
        DeleteCompanyError(message: 'Firma jest uzywana.'),
      ],
    );
  });
}
