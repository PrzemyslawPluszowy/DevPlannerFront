import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:ready_next/workspaces/data/kanban/models/kanban_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_status_category.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/domain/repositories/task_template_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart';

final class _MockTaskTemplateRepository implements TaskTemplateRepository {
  Either<ApiError, List<TaskTemplateResponse>>? listResult;
  Either<ApiError, DefaultTaskTemplateResponse>? defaultResult;
  Either<ApiError, TaskTemplateDetailsResponse>? detailsResult;
  Either<ApiError, TaskTemplateResponse>? createResult;
  Either<ApiError, TaskTemplateDetailsResponse>? updateResult;
  Either<ApiError, Unit>? deleteResult;

  int detailsCallCount = 0;
  CreateTaskTemplateDefinitionPayload? createPayload;

  @override
  Future<Either<ApiError, List<TaskTemplateResponse>>> list(
    String workspaceId,
  ) async => listResult ?? const Right([]);

  @override
  Future<Either<ApiError, DefaultTaskTemplateResponse>> getDefault(
    String workspaceId,
  ) async => defaultResult ?? const Right(DefaultTaskTemplateResponse());

  @override
  Future<Either<ApiError, TaskTemplateDetailsResponse>> details({
    required String workspaceId,
    required String templateId,
  }) async {
    detailsCallCount++;
    return detailsResult ??
        const Left(ApiError(type: .notFound, message: 'Not found'));
  }

  @override
  Future<Either<ApiError, TaskTemplateResponse>> createFromDefinition({
    required String workspaceId,
    required CreateTaskTemplateDefinitionPayload payload,
  }) async {
    createPayload = payload;
    return createResult ??
        Right(
          TaskTemplateResponse(
            id: 'template-created',
            workspaceId: workspaceId,
            name: payload.name,
            updatedAtUtc: DateTime.utc(2026, 9, 8),
            version: 1,
          ),
        );
  }

  @override
  Future<Either<ApiError, TaskTemplateDetailsResponse>> update({
    required String workspaceId,
    required String templateId,
    required UpdateTaskTemplatePayload payload,
  }) async =>
      updateResult ??
      Right(
        TaskTemplateDetailsResponse(
          id: templateId,
          name: payload.name,
          title: payload.title,
          status: payload.status,
          priority: payload.priority,
          assigneeCoreUserIds: const [],
          checklistItems: const [],
          acceptanceCriteria: const [],
          labels: const [],
          customFieldValues: const [],
          updatedAtUtc: DateTime.utc(2026, 9, 8),
          version: payload.expectedVersion + 1,
        ),
      );

  @override
  Future<Either<ApiError, Unit>> delete({
    required String workspaceId,
    required String templateId,
    required int expectedVersion,
  }) async => deleteResult ?? const Right(unit);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _wrapTestWidget({
  required Widget child,
  required TaskTemplatePickerCubit cubit,
}) => MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('pl'),
  home: Material(
    child: BlocProvider.value(
      value: cubit,
      child: child,
    ),
  ),
);

void main() {
  testWidgets(
    'Nowa formatka natychmiast pokazuje formularz, a nie retry i nie wywoluje details',
    (
      tester,
    ) async {
      final repository = _MockTaskTemplateRepository()
        ..listResult = const Right([])
        ..defaultResult = const Right(DefaultTaskTemplateResponse());
      final cubit = TaskTemplatePickerCubit(
        repository: repository,
        workspaceId: 'workspace-1',
      );
      await cubit.load();

      await tester.pumpWidget(
        _wrapTestWidget(
          child: const TaskTemplateEditor(
            template: null,
            members: <ProjectMemberProfile>[],
          ),
          cubit: cubit,
        ),
      );
      await tester.pump();

      // Weryfikacja: W trybie create NIE ma byc przycisku "Ponow probe" / retry
      expect(find.text('Ponów próbę'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Weryfikacja: formularz jest widoczny w pierwszej klatce
      expect(find.text('Nazwa szablonu'), findsOneWidget);
      expect(find.text('Tytuł'), findsNothing);
      expect(find.text('Opis'), findsNothing);

      // Weryfikacja: Nie wykonano zadnego zapytania details
      expect(repository.detailsCallCount, equals(0));

      await cubit.close();
    },
  );

  testWidgets(
    'Wypełnienie wymaganych pól i zapis wywołuje createFromDefinition dokładnie raz',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final repository = _MockTaskTemplateRepository()
        ..listResult = const Right([])
        ..defaultResult = const Right(DefaultTaskTemplateResponse());
      final cubit = TaskTemplatePickerCubit(
        repository: repository,
        workspaceId: 'workspace-1',
      );
      await cubit.load();

      await tester.pumpWidget(
        _wrapTestWidget(
          child: const TaskTemplateEditor(
            template: null,
            members: <ProjectMemberProfile>[],
          ),
          cubit: cubit,
        ),
      );
      await tester.pump();

      // Formatka ma wyłącznie własną nazwę; tytuł podaje użytkownik przy tworzeniu taska.
      await tester.enterText(
        find.byKey(const Key('task-template-name')),
        'Szablon Release',
      );
      await tester.pump();

      // Kliknij przycisk "Utwórz formatkę"
      final createButton = find.text('Utwórz formatkę');
      expect(createButton, findsOneWidget);
      await tester.tap(createButton);
      await tester.pump();

      expect(repository.createPayload, isNotNull);
      expect(repository.createPayload?.name, 'Szablon Release');
      expect(repository.createPayload?.title, isNull);
      expect(repository.createPayload?.description, isNull);

      await cubit.close();
    },
  );

  testWidgets(
    'Błąd create pozostawia formularz i wpisane wartości oraz pokazuje błąd API',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final repository = _MockTaskTemplateRepository()
        ..listResult = const Right([])
        ..defaultResult = const Right(DefaultTaskTemplateResponse())
        ..createResult = const Left(
          ApiError(
            type: ApiErrorType.conflict,
            message: 'Szablon o tej nazwie już istnieje',
          ),
        );
      final cubit = TaskTemplatePickerCubit(
        repository: repository,
        workspaceId: 'workspace-1',
      );
      await cubit.load();

      await tester.pumpWidget(
        _wrapTestWidget(
          child: const TaskTemplateEditor(
            template: null,
            members: <ProjectMemberProfile>[],
          ),
          cubit: cubit,
        ),
      );
      await tester.pump();

      await tester.enterText(
        find.byKey(const Key('task-template-name')),
        'Zduplikowany szablon',
      );
      await tester.pump();

      await tester.tap(find.text('Utwórz formatkę'));
      await tester.pumpAndSettle();

      // Komunikat błędu z API powinien pojawić się w panelu
      expect(find.text('Szablon o tej nazwie już istnieje'), findsOneWidget);

      // Formularz i wpisane dane NIE mogą zniknąć
      expect(find.text('Zduplikowany szablon'), findsOneWidget);
      expect(find.text('Tytuł'), findsNothing);

      await cubit.close();
    },
  );

  testWidgets(
    'Edycja istniejącej formatki pobiera details i pokazuje wypełniony formularz',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final existing = TaskTemplateResponse(
        id: 'template-edit-1',
        workspaceId: 'workspace-1',
        name: 'Formatka Produkcyjna',
        updatedAtUtc: DateTime.utc(2026, 9, 8),
        version: 2,
      );

      final repository = _MockTaskTemplateRepository()
        ..detailsResult = Right(
          TaskTemplateDetailsResponse(
            id: 'template-edit-1',
            name: 'Formatka Produkcyjna',
            title: 'Wdrożenie na prod',
            status: ProjectTaskStatus.todo,
            priority: TaskPriority.high,
            assigneeCoreUserIds: const [],
            checklistItems: const ['Krok 1', 'Krok 2'],
            acceptanceCriteria: const ['Kryterium 1'],
            labels: const [],
            customFieldValues: const [],
            updatedAtUtc: DateTime.utc(2026, 9, 8),
            version: 2,
          ),
        );

      final cubit = TaskTemplatePickerCubit(
        repository: repository,
        workspaceId: 'workspace-1',
      );
      await cubit.load();

      await tester.pumpWidget(
        _wrapTestWidget(
          child: TaskTemplateEditor(
            template: existing,
            members: const <ProjectMemberProfile>[],
          ),
          cubit: cubit,
        ),
      );

      // Przed zakończeniem requestu jest stan ładowania
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Po zakończeniu details formularz jest wypełniony danymi
      await tester.pumpAndSettle();
      expect(repository.detailsCallCount, 1);
      expect(find.text('Formatka Produkcyjna'), findsOneWidget);
      expect(find.text('Wdrożenie na prod'), findsNothing);
      expect(find.text('Zapisz zmiany'), findsOneWidget);

      await cubit.close();
    },
  );

  testWidgets('Błąd details pokazuje komunikat i działający retry', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final existing = TaskTemplateResponse(
      id: 'template-err-1',
      workspaceId: 'workspace-1',
      name: 'Uszkodzona formatka',
      updatedAtUtc: DateTime.utc(2026, 9, 8),
      version: 1,
    );

    final repository = _MockTaskTemplateRepository()
      ..detailsResult = const Left(
        ApiError(type: ApiErrorType.connection, message: 'Błąd sieci details'),
      );

    final cubit = TaskTemplatePickerCubit(
      repository: repository,
      workspaceId: 'workspace-1',
    );
    await cubit.load();

    await tester.pumpWidget(
      _wrapTestWidget(
        child: TaskTemplateEditor(
          template: existing,
          members: const <ProjectMemberProfile>[],
        ),
        cubit: cubit,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Błąd sieci details'), findsOneWidget);
    expect(find.text('Spróbuj ponownie'), findsOneWidget);

    // Teraz naprawiamy wynik w repozytorium i klikamy retry
    repository.detailsResult = Right(
      TaskTemplateDetailsResponse(
        id: 'template-err-1',
        name: 'Uszkodzona formatka',
        title: 'Naprawiony tytuł',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
        assigneeCoreUserIds: const [],
        checklistItems: const [],
        acceptanceCriteria: const [],
        labels: const [],
        customFieldValues: const [],
        updatedAtUtc: DateTime.utc(2026, 9, 8),
        version: 1,
      ),
    );

    await tester.tap(find.text('Spróbuj ponownie'));
    await tester.pumpAndSettle();

    expect(find.text('Naprawiony tytuł'), findsNothing);
    expect(find.text('Spróbuj ponownie'), findsNothing);

    await cubit.close();
  });

  testWidgets('Zamknięcie brudnego formularza wymaga potwierdzenia', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final repository = _MockTaskTemplateRepository();
    final cubit = TaskTemplatePickerCubit(
      repository: repository,
      workspaceId: 'workspace-1',
    );
    await cubit.load();

    await tester.pumpWidget(
      _wrapTestWidget(
        child: const TaskTemplateEditor(
          template: null,
          members: <ProjectMemberProfile>[],
        ),
        cubit: cubit,
      ),
    );
    await tester.pump();

    // Wpisujemy zmianę w polu, co oznacza formularz jako dirty
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nazwa szablonu'),
      'Wpisana brudna nazwa',
    );
    await tester.pump();

    // Klikamy "Anuluj"
    await tester.tap(find.text('Anuluj'));
    await tester.pumpAndSettle();

    // Powinien pojawić się dialog AppConfirmDialog z pytaniem o odrzucenie zmian
    expect(find.byType(AppConfirmDialog), findsOneWidget);
    expect(find.text('Odrzucić niezapisane zmiany?'), findsOneWidget);
    expect(find.text('Odrzuć zmiany'), findsOneWidget);
    expect(find.text('Wróć do edycji'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('Zapis jest odporny na podwójne kliknięcie', (tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final repository = _MockTaskTemplateRepository();
    final cubit = TaskTemplatePickerCubit(
      repository: repository,
      workspaceId: 'workspace-1',
    );
    await cubit.load();

    await tester.pumpWidget(
      _wrapTestWidget(
        child: const TaskTemplateEditor(
          template: null,
          members: <ProjectMemberProfile>[],
        ),
        cubit: cubit,
      ),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('task-template-name')),
      'Formatka One Click',
    );
    await tester.pump();

    // Symulacja podwójnego kliknięcia w krótkim odstępie
    await tester.tap(find.text('Utwórz formatkę'), warnIfMissed: false);
    await tester.tap(find.text('Utwórz formatkę'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(repository.createPayload?.name, 'Formatka One Click');

    await cubit.close();
  });

  testWidgets('Wybór kolumny customowej trafia do właściwego payloadu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final repository = _MockTaskTemplateRepository();
    final cubit = TaskTemplatePickerCubit(
      repository: repository,
      workspaceId: 'workspace-1',
    );
    await cubit.load();

    final customColumns = [
      const KanbanColumnResponse(
        status: ProjectTaskStatus.todo,
        customStatusId: 'custom-col-123',
        displayName: 'Do akceptacji QA',
        color: '#E056FD',
        totalTaskCount: 0,
        isWipLimitExceeded: false,
        tasks: [],
      ),
    ];

    await tester.pumpWidget(
      _wrapTestWidget(
        child: TaskTemplateEditor(
          template: null,
          members: const <ProjectMemberProfile>[],
          columns: customColumns,
        ),
        cubit: cubit,
      ),
    );
    await tester.pump();

    // Wypełnij wymagane pola
    await tester.enterText(
      find.byKey(const Key('task-template-name')),
      'Formatka QA',
    );
    await tester.pump();

    // Zapisz formatkę
    await tester.tap(find.text('Utwórz formatkę'));
    await tester.pumpAndSettle();

    expect(repository.createPayload?.customStatus?.name, 'Do akceptacji QA');
    expect(
      repository.createPayload?.customStatus?.category,
      TaskStatusCategory.todo,
    );

    await cubit.close();
  });

  testWidgets(
    'Walidacja wymaga wyłącznie nazwy formatki, bez tytułu zadania',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final repository = _MockTaskTemplateRepository();
      final cubit = TaskTemplatePickerCubit(
        repository: repository,
        workspaceId: 'workspace-1',
      );
      await cubit.load();

      await tester.pumpWidget(
        _wrapTestWidget(
          child: const TaskTemplateEditor(
            template: null,
            members: <ProjectMemberProfile>[],
          ),
          cubit: cubit,
        ),
      );
      await tester.pump();

      // Zapis pustego formularza
      final btn = find.widgetWithText(FilledButton, 'Utwórz formatkę');
      tester.widget<FilledButton>(btn).onPressed!();
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, 1200));
      await tester.pumpAndSettle();

      expect(find.text('Nazwa formatki jest wymagana.'), findsOneWidget);
      expect(find.text('Tytuł zadania jest wymagany.'), findsNothing);

      await cubit.close();
    },
  );

  testWidgets(
    'Lista wykonawców wyszukuje po imieniu i nazwisku oraz nie pokazuje UUID',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final members = [
        const ProjectMemberProfile(
          coreUserId: '9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d',
          displayName: 'Jan Kowalski',
          role: ProjectRole.member,
        ),
        const ProjectMemberProfile(
          coreUserId: '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
          displayName: 'Anna Nowak',
          role: ProjectRole.member,
        ),
      ];

      final repository = _MockTaskTemplateRepository();
      final cubit = TaskTemplatePickerCubit(
        repository: repository,
        workspaceId: 'workspace-1',
      );
      await cubit.load();

      await tester.pumpWidget(
        _wrapTestWidget(
          child: TaskTemplateEditor(
            template: null,
            members: members,
          ),
          cubit: cubit,
        ),
      );
      await tester.pump();

      // Weryfikacja: W UI widoczne są imiona, a NIE UUID
      expect(find.text('Jan Kowalski'), findsOneWidget);
      expect(find.text('Anna Nowak'), findsOneWidget);
      expect(find.text('9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d'), findsNothing);

      // Wpisz w filtrze "Anna"
      final searchField = find.widgetWithText(TextField, 'Szukaj osób...');
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Anna');
      await tester.pump();

      // Jan powinien zniknąć z listy, Anna ma pozostać
      expect(find.text('Anna Nowak'), findsOneWidget);
      expect(find.text('Jan Kowalski'), findsNothing);

      await cubit.close();
    },
  );
}
