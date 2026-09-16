import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/cubit/bhp_users_cubit.dart';

/// Mock repozytorium pracowników BHP.
class _MockBhpUsersRepository extends Mock implements BhpUsersRepository {}

void main() {
  test('nie emituje stanu po zamknięciu podczas oczekiwania na API', () async {
    final repository = _MockBhpUsersRepository();
    final response = Completer<Either<ApiError, List<GetBhpUserListItem>>>();
    when(repository.getUsers).thenAnswer((_) => response.future);

    final cubit = BhpUsersCubit(repository: repository);
    final loadFuture = cubit.load();

    await Future<void>.delayed(Duration.zero);
    await cubit.close();
    response.complete(const Right([]));

    await loadFuture;
  });
}
