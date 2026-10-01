import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_dismiss_shared_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _Download extends Mock implements DownloadTransport {}

typedef _Owners = ({
  StorageBrowserCubit browser,
  StorageFileMutationCubit mutation,
});

final class _App extends StatelessWidget {
  const _App({required this.owners, this.dark = false});
  final ValueNotifier<_Owners> owners;
  final bool dark;
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: dark ? MaterialTheme.crm().dark() : MaterialTheme.crm().light(),
    locale: Locale(dark ? 'pl' : 'en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(2)),
      child: child!,
    ),
    home: ValueListenableBuilder<_Owners>(
      valueListenable: owners,
      builder: (context, value, _) => MultiBlocProvider(
        providers: [
          BlocProvider<StorageBrowserCubit>.value(value: value.browser),
          BlocProvider<StorageFileMutationCubit>.value(value: value.mutation),
        ],
        child: const _Launcher(),
      ),
    ),
  );
}

final class _Launcher extends StatelessWidget {
  const _Launcher();
  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => StorageDismissSharedAction.confirm(context, 'file-1'),
      child: const Text('Open'),
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
  });
  for (final mode in ['current', 'scope', 'browser', 'mutation', 'cancel']) {
    testWidgets('dismiss confirmation guards $mode at 200%', (tester) async {
      tester.view.physicalSize = const Size(420, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = _Repository();
      final transport = _Download();
      final browser = StorageBrowserCubit(
        repository: repository,
        initialScope: const StorageScope.shared(),
      );
      final mutation = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: transport,
      );
      final replacementBrowser = StorageBrowserCubit(repository: repository);
      final replacementMutation = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: transport,
      );
      addTearDown(browser.close);
      addTearDown(mutation.close);
      addTearDown(replacementBrowser.close);
      addTearDown(replacementMutation.close);
      when(() => repository.dismissSharedFile('file-1'))
          .thenAnswer((_) async => right(unit));
      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer((_) async => right([]));
      when(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          filter: any(named: 'filter'),
        ),
      ).thenAnswer(
        (_) async => left(
          const ApiError(type: ApiErrorType.unknown, message: 'fixture'),
        ),
      );
      final owners = ValueNotifier<_Owners>((
        browser: browser,
        mutation: mutation,
      ));
      addTearDown(owners.dispose);
      await tester.pumpWidget(_App(owners: owners, dark: mode != 'current'));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      if (mode == 'scope') {
        await browser.setScope(const StorageScope.personal());
      }
      if (mode == 'browser') {
        owners.value = (browser: replacementBrowser, mutation: mutation);
      }
      if (mode == 'mutation') {
        owners.value = (browser: browser, mutation: replacementMutation);
      }
      await tester.pump();
      final confirm = find.byKey(const ValueKey('storage_dismiss_confirm'));
      final cancel = find.byKey(const ValueKey('storage_dismiss_cancel'));
      expect(confirm.hitTestable(), findsOneWidget);
      expect(cancel.hitTestable(), findsOneWidget);
      if (mode == 'cancel') {
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      } else {
        await tester.tap(confirm);
      }
      await tester.pumpAndSettle();
      if (mode == 'current') {
        verify(() => repository.dismissSharedFile('file-1')).called(1);
      } else {
        verifyNever(() => repository.dismissSharedFile(any()));
      }
      expect(tester.takeException(), isNull);
    });
  }
}
