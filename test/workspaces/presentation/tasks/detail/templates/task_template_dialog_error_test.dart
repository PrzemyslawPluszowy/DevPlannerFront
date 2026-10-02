import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_templates.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/templates/cubit/task_template_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements TaskTemplateRepository {}

void main() {
  setUpAll(
    () => registerFallbackValue(
      const CreateTaskTemplatePayload(name: 'Fallback'),
    ),
  );
  for (final dark in [false, true]) {
    testWidgets(
      'template keeps draft and shows safe failure at 200%; dark=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(420, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = _Repository();
        when(
          () => repository.create(
            workspaceId: 'ws',
            projectId: 'project-1',
            taskId: 'task',
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((_) => Future.error(StateError('private fixture')));
        final cubit = TaskTemplateCubit(
          repository: repository,
          workspaceId: 'ws',
          projectId: 'project-1',
          taskId: 'task',
        );
        addTearDown(cubit.close);
        await tester.pumpWidget(
          MaterialApp(
            theme: dark
                ? MaterialTheme.crm().dark()
                : MaterialTheme.crm().light(),
            locale: Locale(dark ? 'pl' : 'en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: Scaffold(
              body: BlocProvider.value(
                value: cubit,
                child: const CreateTaskTemplateDialog(initialName: ''),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final name = find.byKey(const ValueKey('task_template_name'));
        final l10n = AppLocalizations.of(tester.element(name))!;
        final create = find.widgetWithText(FilledButton, l10n.create);
        expect(create.hitTestable(), findsOneWidget);
        await tester.tap(create);
        await tester.pumpAndSettle();
        expect(find.text(l10n.authFieldRequired), findsOneWidget);
        verifyNever(
          () => repository.create(
            workspaceId: 'ws',
            projectId: 'project-1',
            taskId: 'task',
            payload: any(named: 'payload'),
          ),
        );
        final draftName = List.filled(160, 'a').join();
        await tester.enterText(name, draftName);
        await tester.tap(create);
        await tester.pumpAndSettle();
        expect(
          tester.widget<TextField>(name).controller!.text,
          draftName,
        );
        expect(find.text(l10n.tasksTemplateSaveFailed), findsOneWidget);
        expect(create.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
