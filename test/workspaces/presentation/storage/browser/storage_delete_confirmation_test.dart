import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_delete_confirmation.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_support/storage_shell_harness.dart';

final class _Repository extends Fake implements StorageRepository {}

final class _Downloads extends Fake implements DownloadTransport {}

void main() {
  for (final locale in ['pl', 'en']) {
    testWidgets('Delete: $locale, 200%, wąskie okno i Enter anulują', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(420, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = _Repository();
      final selection = StorageSelectionCubit()
        ..selectAll(files: [storageTestFile()], folders: const []);
      final browser = StorageBrowserCubit(repository: repository);
      final mutation = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: _Downloads(),
      );
      addTearDown(selection.close);
      addTearDown(browser.close);
      addTearDown(mutation.close);
      const palette = MaterialTheme(TextTheme());
      await tester.pumpWidget(
        MaterialApp(
          theme: locale == 'pl' ? palette.dark() : palette.light(),
          locale: Locale(locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2),
            ),
            child: child!,
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: selection),
              BlocProvider.value(value: browser),
              BlocProvider.value(value: mutation),
            ],
            child: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => unawaited(
                    StorageDeleteConfirmation.show(context, selection.state),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
      final l10n = await AppLocalizations.delegate.load(Locale(locale));
      expect(find.text(l10n.storageDeleteConfirmTitle), findsOneWidget);
      expect(find.text(l10n.cancel).hitTestable(), findsOneWidget);
      expect(find.text(l10n.delete).hitTestable(), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(selection.state.selectedFileIds, {'file-1'});
      expect(tester.takeException(), isNull);
    });
  }
}
