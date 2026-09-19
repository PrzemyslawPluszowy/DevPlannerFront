import 'package:bloc_test/bloc_test.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/private/cubit/personal_section_cubit.dart';
import 'package:devplanner/workspaces/presentation/private/cubit/personal_section_state.dart';
import 'package:devplanner/workspaces/presentation/private/my_tasks_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersonalSectionCubit', () {
    blocTest<PersonalSectionCubit, PersonalSectionState>(
      'pokazuje jawny stan niedostępnego kontraktu',
      build: () => PersonalSectionCubit(
        loader: (_) async => const PersonalSectionContractUnavailable(
          message: 'Brak endpointu',
        ),
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        const PersonalSectionLoading(),
        const PersonalSectionUnavailable(message: 'Brak endpointu'),
      ],
    );

    blocTest<PersonalSectionCubit, PersonalSectionState>(
      'emituje gotowy stan po poprawnym wyniku repository',
      build: () => PersonalSectionCubit(
        loader: (_) async => const PersonalSectionData(itemCount: 3),
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        const PersonalSectionLoading(),
        const PersonalSectionReady(itemCount: 3),
      ],
    );

    blocTest<PersonalSectionCubit, PersonalSectionState>(
      'przekazuje kod błędu do jawnego stanu failure',
      build: () => PersonalSectionCubit(
        loader: (_) async => const PersonalSectionLoadFailure(
          message: 'Błąd backendu',
          code: 'private.unavailable',
        ),
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        const PersonalSectionLoading(),
        const PersonalSectionFailure(
          message: 'Błąd backendu',
          code: 'private.unavailable',
        ),
      ],
    );

    test('pobiera kolejną stronę wyłącznie z cursora backendu', () async {
      final cursors = <String?>[];
      final cubit = PersonalSectionCubit(
        loader: (cursor) async {
          cursors.add(cursor);
          return cursor == null
              ? const PersonalSectionData(itemCount: 1, nextCursor: 'next')
              : const PersonalSectionData(itemCount: 1);
        },
      );

      await cubit.load();
      await cubit.loadMore();

      expect(cursors, [null, 'next']);
      final state = cubit.state as PersonalSectionReady;
      expect(state.itemCount, 2);
      expect(state.hasMore, isFalse);
      await cubit.close();
    });
  });

  test('czyszczenie statusu filtra nie zmienia pozostałych kryteriów', () {
    final filters = MyTasksFilters(
      status: ProjectTaskStatus.todo,
      dueFromUtc: DateTime(2026, 1, 2),
    ).copyWith(clearStatus: true);

    expect(filters.status, isNull);
    expect(filters.dueFromUtc, DateTime(2026, 1, 2));
  });
}
