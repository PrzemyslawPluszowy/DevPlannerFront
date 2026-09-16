import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/add_user/cubit/add_bhp_user_state.dart';

/// Cubit formularza dodawania pracownika BHP.
class AddBhpUserCubit extends Cubit<AddBhpUserState> {
  /// Tworzy cubit formularza dodawania pracownika.
  AddBhpUserCubit({
    required this._usersRepository,
    required this._positionsRepository,
  }) : super(const AddBhpUserLoading());

  static const _diacriticsMap = <String, String>{
    'ą': 'a',
    'ć': 'c',
    'ę': 'e',
    'ł': 'l',
    'ń': 'n',
    'ó': 'o',
    'ś': 's',
    'ż': 'z',
    'ź': 'z',
  };

  final BhpUsersRepository _usersRepository;
  final BhpPositionsRepository _positionsRepository;

  List<GetBhpPositionListItem> _positions = const [];

  /// Ładuje dane potrzebne do formularza.
  Future<void> load() async {
    emit(const AddBhpUserLoading());

    final result = await _positionsRepository.getPositions(active: true);
    result.fold(
      (error) => emit(AddBhpUserLoadError(message: error.message)),
      (positions) {
        _positions = positions
            .where((item) => item.aktywny)
            .toList(
              growable: false,
            );
        emit(AddBhpUserReady(positions: _positions));
      },
    );
  }

  /// Wysyła formularz nowego pracownika do backendu.
  Future<void> submit(PostBhpUserRequest request) async {
    if (state is AddBhpUserSubmitting) {
      return;
    }

    emit(AddBhpUserSubmitting(positions: _positions));

    final result = await _usersRepository.createUser(request);
    result.fold(
      (error) => emit(
        AddBhpUserReady(
          positions: _positions,
          submitError: error.message,
        ),
      ),
      (user) => emit(AddBhpUserSuccess(user: user)),
    );
  }

  /// Wyszukuje istniejących pracowników o potencjalnie duplikujących się danych.
  Future<List<GetBhpUserListItem>> findPotentialDuplicates(
    PostBhpUserRequest request, {
    List<GetBhpUserListItem> existingUsers = const [],
  }) async {
    final firstNameQuery = _normalizeQuery(request.imie);
    final lastNameQuery = _normalizeQuery(request.nazwisko);
    final fullNameQuery = _normalizeQuery(
      '${request.imie} ${request.nazwisko}',
    );
    final peselQuery = _normalizeQuery(request.pesel);

    if (existingUsers.isNotEmpty) {
      return _deduplicateMatches(
        existingUsers,
        normalizedFullName: fullNameQuery,
        normalizedPesel: peselQuery,
      );
    }

    final queries = {
      if (firstNameQuery.isNotEmpty) firstNameQuery,
      if (lastNameQuery.isNotEmpty) lastNameQuery,
      if (fullNameQuery.isNotEmpty) fullNameQuery,
      if (peselQuery.isNotEmpty) peselQuery,
    }.toList(growable: false);

    if (queries.isEmpty) {
      return const [];
    }

    final responses = await Future.wait(
      queries.map((query) => _usersRepository.getUsers(query: query)),
    );

    final fetchedUsers = <GetBhpUserListItem>[];

    for (final response in responses) {
      response.fold(
        (_) {},
        fetchedUsers.addAll,
      );
    }

    return _deduplicateMatches(
      fetchedUsers,
      normalizedFullName: fullNameQuery,
      normalizedPesel: peselQuery,
    );
  }

  /// Wyszukuje podobnych pracowników wyłącznie na już załadowanej liście.
  List<GetBhpUserListItem> findPotentialDuplicatesLocally(
    PostBhpUserRequest request, {
    List<GetBhpUserListItem> existingUsers = const [],
  }) {
    final fullNameQuery = _normalizeQuery(
      '${request.imie} ${request.nazwisko}',
    );
    final peselQuery = _normalizeQuery(request.pesel);

    return _deduplicateMatches(
      existingUsers,
      normalizedFullName: fullNameQuery,
      normalizedPesel: peselQuery,
    );
  }

  List<GetBhpUserListItem> _deduplicateMatches(
    List<GetBhpUserListItem> users, {
    required String normalizedFullName,
    required String normalizedPesel,
  }) {
    final duplicatesById = <int, GetBhpUserListItem>{};

    for (final user in users) {
      if (_isPotentialDuplicate(
        user,
        normalizedFullName: normalizedFullName,
        normalizedPesel: normalizedPesel,
      )) {
        duplicatesById[user.id] = user;
      }
    }

    final duplicates = duplicatesById.values.toList(growable: false);
    duplicates.sort((left, right) {
      final leftScore = _duplicateScore(
        left,
        normalizedFullName: normalizedFullName,
        normalizedPesel: normalizedPesel,
      );
      final rightScore = _duplicateScore(
        right,
        normalizedFullName: normalizedFullName,
        normalizedPesel: normalizedPesel,
      );
      return rightScore.compareTo(leftScore);
    });
    return duplicates;
  }

  bool _isPotentialDuplicate(
    GetBhpUserListItem user, {
    required String normalizedFullName,
    required String normalizedPesel,
  }) {
    final userFullName = _normalizeQuery(
      '${user.imie ?? ''} ${user.nazwisko ?? ''}',
    );
    final userPesel = _normalizeQuery(user.pesel);

    final hasMatchingPesel =
        normalizedPesel.isNotEmpty && userPesel == normalizedPesel;
    final hasMatchingFullName =
        normalizedFullName.isNotEmpty && userFullName == normalizedFullName;

    return hasMatchingPesel || hasMatchingFullName;
  }

  int _duplicateScore(
    GetBhpUserListItem user, {
    required String normalizedFullName,
    required String normalizedPesel,
  }) {
    var score = 0;
    final userFullName = _normalizeQuery(
      '${user.imie ?? ''} ${user.nazwisko ?? ''}',
    );
    final userPesel = _normalizeQuery(user.pesel);

    if (normalizedPesel.isNotEmpty && userPesel == normalizedPesel) {
      score += 2;
    }
    if (normalizedFullName.isNotEmpty && userFullName == normalizedFullName) {
      score += 1;
    }

    return score;
  }

  String _normalizeQuery(String? value) {
    final normalized = value
        ?.trim()
        .toLowerCase()
        .split('')
        .map((char) => _diacriticsMap[char] ?? char)
        .join()
        .replaceAll(RegExp(r'\s+'), ' ');
    if (normalized == null || normalized.isEmpty) {
      return '';
    }

    return normalized;
  }
}
