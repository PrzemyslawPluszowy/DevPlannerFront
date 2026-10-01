import 'package:dartz/dartz.dart' show Right;
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/task_recurrence_time_zone_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _RecurrenceRepository extends Mock
    implements TaskRecurrenceRepository {}

final _hostKey = GlobalKey<_PickerHarnessState>();

void main() {
  testWidgets('wyszukuje i wybiera strefę z menu webowego', (tester) async {
    final repository = _RecurrenceRepository();
    when(
      () => repository.listSupportedTimeZones(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer(
      (_) async => const Right([
        'America/New_York',
        'Europe/Berlin',
        'Europe/Warsaw',
      ]),
    );
    final selected = <String>[];

    await tester.pumpWidget(_app(repository, selected));
    await tester.tap(find.text('Windows/UTC'));
    await tester.pumpAndSettle();

    final search = find.byType(TextField).last;
    await tester.enterText(search, 'berlin');
    await tester.pumpAndSettle();
    expect(find.text('Europe/Berlin'), findsOneWidget);
    expect(find.text('Europe/Warsaw'), findsNothing);

    await tester.tap(find.text('Europe/Berlin'));
    await tester.pumpAndSettle();
    expect(selected, ['Europe/Berlin']);
  });

  testWidgets('odrzuca wybór z popupu po podmianie właściciela', (
    tester,
  ) async {
    final repository = _RecurrenceRepository();
    when(
      () => repository.listSupportedTimeZones(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) async => const Right(['Europe/Berlin']));
    final selected = <String>[];

    await tester.pumpWidget(_app(repository, selected));
    await tester.tap(find.text('Windows/UTC'));
    await tester.pumpAndSettle();
    _hostKey.currentState!.replaceScope();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Europe/Berlin'));
    await tester.pumpAndSettle();
    expect(selected, isEmpty);
    expect(find.text('Europe/Berlin'), findsNothing);
  });
}

Widget _app(TaskRecurrenceRepository repository, List<String> selected) =>
    MaterialApp(
      theme: MaterialTheme.crm().light(),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: _PickerHarness(
          key: _hostKey,
          repository: repository,
          onSelected: selected.add,
        ),
      ),
    );

final class _PickerHarness extends StatefulWidget {
  const _PickerHarness({
    required this.repository,
    required this.onSelected,
    super.key,
  });

  final TaskRecurrenceRepository repository;
  final ValueChanged<String> onSelected;

  @override
  State<_PickerHarness> createState() => _PickerHarnessState();
}

final class _PickerHarnessState extends State<_PickerHarness> {
  Object _scope = Object();

  void replaceScope() => setState(() => _scope = Object());

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 360,
      child: TaskDetailsModalTheme(
        child: TaskRecurrenceTimeZonePicker(
          repository: widget.repository,
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          selectionScope: _scope,
          value: 'Windows/UTC',
          enabled: true,
          onSelected: widget.onSelected,
        ),
      ),
    ),
  );
}
