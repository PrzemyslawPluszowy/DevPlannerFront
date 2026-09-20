import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_folder_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Repozytorium zasobów projektu: test sprawdza tylko wybór powierzchni,
/// więc żadna metoda nie jest wołana.
final class _FakeResourcesRepository implements ProjectResourcesRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _host({required bool withRepository}) {
  final child = Builder(
    builder: (context) => ElevatedButton(
      onPressed: () => ProjectResourceCreationDialogs.showCreateFolder(
        context,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
      child: const Text('open'),
    ),
  );
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('pl')],
    locale: const Locale('pl'),
    home: withRepository
        ? Provider<ProjectResourcesRepository>.value(
            value: _FakeResourcesRepository(),
            child: child,
          )
        : child,
  );
}

void main() {
  testWidgets('brak portu zasobów pokazuje jawny stan zamiast wyjątku', (
    tester,
  ) async {
    await tester.pumpWidget(_host(withRepository: false));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Brak providera nie może wywrócić widoku: formularz mówi wprost,
    // że w tej sesji nie ma połączenia i nic nie zostało zapisane.
    expect(
      find.text(
        'Ten formularz nie ma połączenia z backendem w tej sesji, '
        'więc nic nie zostało zapisane.',
      ),
      findsOneWidget,
    );
    expect(find.byType(CreateFolderDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('z portem zasobów otwiera się właściwy formularz', (tester) async {
    await tester.pumpWidget(_host(withRepository: true));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateFolderDialog), findsOneWidget);
    expect(
      find.text(
        'Ten formularz nie ma połączenia z backendem w tej sesji, '
        'więc nic nie zostało zapisane.',
      ),
      findsNothing,
    );
  });
}
