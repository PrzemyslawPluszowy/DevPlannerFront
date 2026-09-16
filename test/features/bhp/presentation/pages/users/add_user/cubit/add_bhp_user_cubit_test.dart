import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/add_user/cubit/add_bhp_user_cubit.dart';

/// Mock repozytorium pracowników BHP.
class _MockBhpUsersRepository extends Mock implements BhpUsersRepository {}

/// Mock repozytorium stanowisk BHP.
class _MockBhpPositionsRepository extends Mock
    implements BhpPositionsRepository {}

void main() {
  late BhpUsersRepository usersRepository;
  late BhpPositionsRepository positionsRepository;
  late AddBhpUserCubit cubit;

  const matchingPeselUser = GetBhpUserListItem(
    id: 11,
    aktywny: true,
    isArchived: false,
    imie: 'Jan',
    nazwisko: 'Kowalski',
    pesel: '90010112345',
    stanowiskoNazwa: 'Magazynier',
  );

  const matchingNameArchivedUser = GetBhpUserListItem(
    id: 12,
    aktywny: false,
    isArchived: true,
    imie: 'Jan',
    nazwisko: 'Kowalski',
    stanowiskoNazwa: 'Operator',
  );

  const unrelatedUser = GetBhpUserListItem(
    id: 13,
    aktywny: true,
    isArchived: false,
    imie: 'Adam',
    nazwisko: 'Nowak',
    pesel: '80010112345',
  );

  const matchingPolishCharsUser = GetBhpUserListItem(
    id: 14,
    aktywny: true,
    isArchived: false,
    imie: 'Łukasz',
    nazwisko: 'Żółć',
  );

  setUp(() {
    usersRepository = _MockBhpUsersRepository();
    positionsRepository = _MockBhpPositionsRepository();
    cubit = AddBhpUserCubit(
      usersRepository: usersRepository,
      positionsRepository: positionsRepository,
    );
  });

  group('AddBhpUserCubit.findPotentialDuplicates', () {
    test(
      'używa już załadowanej listy pracowników bez odpytywania API',
      () async {
        final duplicates = await cubit.findPotentialDuplicates(
          const PostBhpUserRequest(
            imie: 'Jan',
            nazwisko: 'Kowalski',
            stanowiskoId: 5,
            pesel: '90010112345',
          ),
          existingUsers: const [
            matchingPeselUser,
            matchingNameArchivedUser,
            unrelatedUser,
          ],
        );

        expect(
          duplicates,
          orderedEquals([
            matchingPeselUser,
            matchingNameArchivedUser,
          ]),
        );
        verifyNever(() => usersRepository.getUsers(query: any(named: 'query')));
      },
    );

    test(
      'traktuje polskie znaki jako równoważne przy porównaniu nazw',
      () async {
        final duplicates = cubit.findPotentialDuplicatesLocally(
          const PostBhpUserRequest(
            imie: 'Lukasz',
            nazwisko: 'Zolc',
            stanowiskoId: 5,
          ),
          existingUsers: const [
            matchingPolishCharsUser,
            unrelatedUser,
          ],
        );

        expect(
          duplicates,
          orderedEquals([
            matchingPolishCharsUser,
          ]),
        );
      },
    );

    test(
      'zwraca dopasowania po PESEL i imieniu z nazwiskiem bez duplikatów',
      () async {
        when(
          () => usersRepository.getUsers(query: 'jan'),
        ).thenAnswer(
          (_) async => const Right([
            matchingPeselUser,
            matchingNameArchivedUser,
            unrelatedUser,
          ]),
        );
        when(
          () => usersRepository.getUsers(query: 'kowalski'),
        ).thenAnswer(
          (_) async => const Right([
            matchingPeselUser,
            matchingNameArchivedUser,
          ]),
        );
        when(
          () => usersRepository.getUsers(query: 'jan kowalski'),
        ).thenAnswer((_) async => const Right([]));
        when(
          () => usersRepository.getUsers(query: '90010112345'),
        ).thenAnswer(
          (_) async => const Right([
            matchingPeselUser,
            unrelatedUser,
          ]),
        );

        final duplicates = await cubit.findPotentialDuplicates(
          const PostBhpUserRequest(
            imie: 'Jan',
            nazwisko: 'Kowalski',
            stanowiskoId: 5,
            pesel: '90010112345',
          ),
        );

        expect(
          duplicates,
          orderedEquals([
            matchingPeselUser,
            matchingNameArchivedUser,
          ]),
        );
      },
    );

    test('ignoruje błąd wyszukiwarki i zwraca puste dopasowania', () async {
      when(
        () => usersRepository.getUsers(query: 'jan'),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'Błąd wyszukiwarki.',
          ),
        ),
      );
      when(
        () => usersRepository.getUsers(query: 'kowalski'),
      ).thenAnswer((_) async => const Right([]));
      when(
        () => usersRepository.getUsers(query: 'jan kowalski'),
      ).thenAnswer((_) async => const Right([]));

      final duplicates = await cubit.findPotentialDuplicates(
        const PostBhpUserRequest(
          imie: 'Jan',
          nazwisko: 'Kowalski',
          stanowiskoId: 5,
        ),
      );

      expect(duplicates, isEmpty);
    });
  });
}
