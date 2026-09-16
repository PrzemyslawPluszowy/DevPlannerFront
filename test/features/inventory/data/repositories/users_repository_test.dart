import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/shared/data/models/data_response_list.dart';

class _MockInventoryApi extends Mock implements InventoryApi {}

void main() {
  late InventoryApi api;
  late UsersRepository repository;

  setUp(() {
    api = _MockInventoryApi();
    repository = UsersRepositoryImpl(api: api);
  });

  group('UsersRepositoryImpl', () {
    test(
      'searchUsers: dla frazy krotszej niz 2 znaki nie wywoluje backendu (wykrywa spamowanie API)',
      () async {
        final result = await repository.searchUsers(search: 'a');

        expect(result.isRight(), isTrue);
        expect(result.getOrElse(() => const []).isEmpty, isTrue);
        verifyNever(
          () => api.searchReadyUsers(
            q: any(named: 'q'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            includeInactive: any(named: 'includeInactive'),
          ),
        );
      },
    );

    test(
      'searchUsers: trimuje fraze i cacheuje po parametrach (wykrywa duble requestow dla tych samych danych)',
      () async {
        when(
          () => api.searchReadyUsers(
            q: 'jan',
            limit: 20,
            offset: 0,
            includeInactive: false,
          ),
        ).thenAnswer(
          (_) async => const DataResponseList(
            data: [
              GetReadyUsersSearchItem(
                usrId: 3759,
                firnam: 'Jan',
                lasnam: 'Nowak',
              ),
            ],
          ),
        );

        final first = await repository.searchUsers(search: '  jan  ');
        final second = await repository.searchUsers(search: 'jan');

        expect(first.isRight(), isTrue);
        expect(second.isRight(), isTrue);
        expect(first.getOrElse(() => const []).single.usrId, 3759);

        verify(
          () => api.searchReadyUsers(
            q: 'jan',
            limit: 20,
            offset: 0,
            includeInactive: false,
          ),
        ).called(1);
      },
    );

    test(
      'searchUsers(forceRefresh): pomija cache (wykrywa brak odswiezenia wynikow po zmianach w ready)',
      () async {
        when(
          () => api.searchReadyUsers(
            q: 'anna',
            limit: 10,
            offset: 5,
            includeInactive: true,
          ),
        ).thenAnswer(
          (_) async => const DataResponseList(
            data: [GetReadyUsersSearchItem(usrId: 3812, usrnam: 'anna')],
          ),
        );

        await repository.searchUsers(
          search: 'anna',
          limit: 10,
          offset: 5,
          includeInactive: true,
        );

        await repository.searchUsers(
          search: 'anna',
          limit: 10,
          offset: 5,
          includeInactive: true,
          forceRefresh: true,
        );

        verify(
          () => api.searchReadyUsers(
            q: 'anna',
            limit: 10,
            offset: 5,
            includeInactive: true,
          ),
        ).called(2);
      },
    );

    test(
      'invalidateUsersSearchCache: po czyszczeniu kolejny request idzie do API (wykrywa stale wyniki po zmianie danych)',
      () async {
        when(
          () => api.searchReadyUsers(
            q: 'marek',
            limit: 20,
            offset: 0,
            includeInactive: false,
          ),
        ).thenAnswer(
          (_) async => const DataResponseList(
            data: [GetReadyUsersSearchItem(usrId: 100, usrnam: 'marek')],
          ),
        );

        await repository.searchUsers(search: 'marek');
        repository.invalidateUsersSearchCache();
        await repository.searchUsers(search: 'marek');

        verify(
          () => api.searchReadyUsers(
            q: 'marek',
            limit: 20,
            offset: 0,
            includeInactive: false,
          ),
        ).called(2);
      },
    );

    test(
      'searchUsers: mapuje DioException na ApiError (wykrywa utrate informacji o bledzie backendu)',
      () async {
        when(
          () => api.searchReadyUsers(
            q: any(named: 'q'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            includeInactive: any(named: 'includeInactive'),
          ),
        ).thenThrow(
          DioException.badResponse(
            requestOptions: RequestOptions(path: '/api/v1/ready/users/search'),
            statusCode: 422,
            response: Response(
              requestOptions: RequestOptions(
                path: '/api/v1/ready/users/search',
              ),
              statusCode: 422,
              data: {'message': 'Bledny parametr q'},
            ),
          ),
        );

        final result = await repository.searchUsers(search: 'xyz');
        final error = result.fold((left) => left, (_) => null);

        expect(error?.type, ApiErrorType.validation);
        expect(error?.message, 'Bledny parametr q');
      },
    );

    test(
      'searchUsers: mapuje FormatException na ApiError.parsing (wykrywa regresje kontraktu odpowiedzi)',
      () async {
        when(
          () => api.searchReadyUsers(
            q: any(named: 'q'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            includeInactive: any(named: 'includeInactive'),
          ),
        ).thenThrow(const FormatException('bad payload'));

        final result = await repository.searchUsers(search: 'zz');
        final error = result.fold((left) => left, (_) => null);

        expect(error?.type, ApiErrorType.parsing);
        expect(
          error?.message,
          'Backend zwrócił nieprawidłowe dane wyszukiwarki użytkowników.',
        );
      },
    );
  });
}
