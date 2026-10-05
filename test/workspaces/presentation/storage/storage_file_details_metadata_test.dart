import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_file_details_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_support/storage_shell_harness.dart';

void main() {
  for (final language in ['pl', 'en']) {
    testWidgets(
      'details are localized and readable at narrow width: $language',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final file =
            storageTestFile(
              name: '${List.filled(12, 'Long file name').join(' ')}.docx',
            ).copyWith(
              extension: '.docx',
              mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
              fileSizeBytes: 29326,
            );
        final details = StorageFileDetailsResponse(
          file: file,
          canEdit: false,
          canDelete: false,
          isOfficeDocument: true,
          permissions: const StorageFilePermissionsResponse(
            accessLevel: StorageEffectiveAccessLevel.reader,
            canRead: true,
            canComment: false,
            canEdit: false,
            canShare: false,
            canDelete: false,
          ),
          versions: [
            StorageFileVersionResponse(
              id: 'v1',
              version: 1,
              fileSizeBytes: 29326,
              createdByUserId: 'private-author-id',
              createdAtUtc: DateTime.utc(2026, 10, 5, 12),
            ),
          ],
        );
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  StorageFileDetailsMetadata(details: details),
                  StorageFileDetailsHistory(details: details),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('DOCX'), findsOneWidget);
        expect(find.text('28.6 KB'), findsOneWidget);
        expect(find.textContaining('private-author-id'), findsNothing);
        expect(find.textContaining('application/vnd'), findsNothing);
        expect(
          find.text(
            language == 'pl' ? 'Twoje uprawnienia' : 'Your permissions',
          ),
          findsOneWidget,
        );
        await tester.scrollUntilVisible(
          find.text(language == 'pl' ? 'Aktualna wersja' : 'Current version'),
          250,
        );
        expect(
          find.textContaining(
            language == 'pl' ? 'Nieznany autor' : 'Unknown author',
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
