import 'dart:typed_data';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/attachments/models/chat_attachment_upload_exception.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_controls.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_queue_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Port extends Mock implements ChatAttachmentUploadPort {}

void main() {
  for (final locale in ['pl', 'en']) {
    testWidgets(
      'upload error retains metadata, selection and retry gate $locale',
      (tester) async {
        final port = _Port();
        final error = ApiError(
          type: ApiErrorType.badResponse,
          message: 'QA upload failure',
          statusCode: 429,
          apiCode: 'qa.upload',
          contractCode: 'qa.contract',
          backendCode: 42,
          traceId: 'qa.trace',
          retryAfterUtc: DateTime.now().toUtc().add(
            const Duration(seconds: 10),
          ),
          fields: {
            for (var i = 0; i < 30; i++) 'field$i': ['QA validation $i'],
          },
        );
        when(() => port.createSession('conversation'))
            .thenThrow(ChatAttachmentUploadException(error));
        final selection = ChatAttachmentSelectionCubit();
        final coordinator = ChatAttachmentComposerCoordinatorCubit(
          selection: selection,
          uploadQueue: ChatAttachmentUploadQueueCubit.fromUploadPort(port),
          updateDraftAttachmentIds: (_) {},
        );
        coordinator.selectInputs([
          StorageUploadInput(
            name: 'QA.txt',
            size: 3,
            bytes: Uint8List.fromList([1, 2, 3]),
          ),
        ]);
        await coordinator.prepare('conversation');
        expect(
          (coordinator.state as ChatAttachmentComposerCoordinatorFailed).error,
          same(error),
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              brightness: locale == 'pl' ? Brightness.light : Brightness.dark,
            ),
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 420,
                    height: 600,
                    child: SingleChildScrollView(
                      child: ChatAttachmentComposerControls(
                        coordinator: coordinator,
                        conversationId: 'conversation',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('QA.txt'), findsOneWidget);
        expect(find.text('QA upload failure'), findsOneWidget);
        expect(find.textContaining('qa.trace'), findsOneWidget);
        expect(find.textContaining('qa.upload'), findsOneWidget);
        expect(find.textContaining('qa.contract'), findsOneWidget);
        expect(find.textContaining('field29'), findsOneWidget);
        expect(
          tester.widget<TextButton>(find.byType(TextButton)).onPressed,
          isNull,
        );
        await coordinator.prepare('conversation');
        verify(() => port.createSession('conversation')).called(1);
        await tester.pump(const Duration(seconds: 11));
        expect(
          tester.widget<TextButton>(find.byType(TextButton)).onPressed,
          isNotNull,
        );
        expect(coordinator.selection.attachments.single.input.name, 'QA.txt');
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await coordinator.close();
      },
    );
  }

  test('unknown port exception does not reveal its private text', () async {
    final port = _Port();
    when(() => port.createSession('conversation'))
        .thenThrow(StateError('private-secret-sentinel'));
    final cubit = ChatAttachmentUploadCubit(port);
    await cubit.start(
      'conversation',
      const StorageUploadInput(name: 'QA.txt', size: 1),
    );
    final failure = cubit.state as ChatAttachmentUploadFailed;
    expect(failure.message, isEmpty);
    expect(failure.error?.apiCode, 'chat.attachment_upload_failed');
    expect(
      failure.error.toString(),
      isNot(contains('private-secret-sentinel')),
    );
    await cubit.close();
  });
}
