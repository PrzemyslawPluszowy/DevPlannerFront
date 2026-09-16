import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/cubit/inventory_users_search_cubit.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/cubit/inventory_users_search_state.dart';

/// Mock repozytorium wyszukiwarki uzytkownikow.
class _MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  late UsersRepository repository;

  const user = GetReadyUsersSearchItem(
    usrId: 123,
    firnam: 'Paulina',
    lasnam: 'Nowak',
    usrnam: 'pnowak',
  );

  setUp(() {
    repository = _MockUsersRepository();

    when(
      () => repository.searchUsers(
        search: any(named: 'search'),
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
        includeInactive: any(named: 'includeInactive'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (invocation) async {
        final search = invocation.namedArguments[#search] as String;
        return Right([
          GetReadyUsersSearchItem(
            usrId: user.usrId,
            firnam: user.firnam,
            lasnam: user.lasnam,
            usrnam: search,
          ),
        ]);
      },
    );
  });

  group('InventoryUsersSearchCubit', () {
    blocTest<InventoryUsersSearchCubit, InventoryUsersSearchState>(
      'nie wysyla requestu dla frazy krotszej niz 2 znaki',
      build: () => InventoryUsersSearchCubit(
        repository: repository,
        debounce: const Duration(milliseconds: 1),
      ),
      act: (cubit) async {
        cubit.onQueryChanged('p');
        await Future<void>.delayed(const Duration(milliseconds: 10));
      },
      expect: () => <InventoryUsersSearchState>[
        const InventoryUsersSearchInitial(),
      ],
      verify: (_) {
        verifyNever(
          () => repository.searchUsers(
            search: any(named: 'search'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            includeInactive: any(named: 'includeInactive'),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        );
      },
    );

    blocTest<InventoryUsersSearchCubit, InventoryUsersSearchState>(
      'po cofnieciu litery i ponownym wpisaniu tej samej frazy ponownie odpala REST',
      build: () => InventoryUsersSearchCubit(
        repository: repository,
        debounce: const Duration(milliseconds: 1),
      ),
      act: (cubit) async {
        cubit.onQueryChanged('paulina');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        cubit.onQueryChanged('paulin');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        cubit.onQueryChanged('paulina');
        await Future<void>.delayed(const Duration(milliseconds: 10));
      },
      expect: () => <dynamic>[
        isA<InventoryUsersSearchLoading>().having(
          (s) => s.query,
          'query',
          'paulina',
        ),
        isA<InventoryUsersSearchLoaded>().having(
          (s) => s.query,
          'query',
          'paulina',
        ),
        isA<InventoryUsersSearchLoading>().having(
          (s) => s.query,
          'query',
          'paulin',
        ),
        isA<InventoryUsersSearchLoaded>().having(
          (s) => s.query,
          'query',
          'paulin',
        ),
        isA<InventoryUsersSearchLoading>().having(
          (s) => s.query,
          'query',
          'paulina',
        ),
        isA<InventoryUsersSearchLoaded>().having(
          (s) => s.query,
          'query',
          'paulina',
        ),
      ],
      verify: (_) {
        verify(
          () => repository.searchUsers(
            search: 'paulina',
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            includeInactive: any(named: 'includeInactive'),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).called(2);
      },
    );

    blocTest<InventoryUsersSearchCubit, InventoryUsersSearchState>(
      'emituje blad wyszukiwarki gdy repozytorium zwroci blad',
      setUp: () {
        when(
          () => repository.searchUsers(
            search: any(named: 'search'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            includeInactive: any(named: 'includeInactive'),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak polaczenia',
            ),
          ),
        );
      },
      build: () => InventoryUsersSearchCubit(
        repository: repository,
        debounce: const Duration(milliseconds: 1),
      ),
      act: (cubit) async {
        cubit.onQueryChanged('paulina');
        await Future<void>.delayed(const Duration(milliseconds: 10));
      },
      expect: () => <dynamic>[
        isA<InventoryUsersSearchLoading>().having(
          (s) => s.query,
          'query',
          'paulina',
        ),
        isA<InventoryUsersSearchError>()
            .having((s) => s.query, 'query', 'paulina')
            .having((s) => s.message, 'message', 'Brak polaczenia'),
      ],
    );
  });
}
