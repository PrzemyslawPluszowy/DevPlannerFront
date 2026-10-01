import 'dart:async';

import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Controller extends Mock implements StorageOnlyOfficeController {}

void main() {
  test('detaching a host cancels its pending export immediately', () async {
    final delegate = _Controller();
    when(() => delegate.runJavaScript(any())).thenAnswer((_) async {});
    final owner = StorageOnlyOfficeHostController()..attach(delegate);
    owner.markDocumentReady(true);
    Object? outcome;
    final pending = owner.requestExport().then<void>(
      (value) => outcome = value,
      onError: (Object error) => outcome = error,
    );
    await Future<void>.value();
    owner.detach(delegate);
    await Future<void>.delayed(Duration.zero);
    try {
      expect(outcome, isA<StateError>());
    } finally {
      owner.downloadReceived((
        url: 'https://office.example/old.pdf',
        fileType: 'pdf',
      ));
      await pending;
    }
  });

  test('old close approval cannot destroy a replacement editor', () async {
    final old = _Controller();
    final next = _Controller();
    when(() => old.runJavaScript(any())).thenAnswer((_) async {});
    when(() => next.runJavaScript(any())).thenAnswer((_) async {});
    final owner = StorageOnlyOfficeHostController()..attach(old);
    owner.markDocumentReady(true);
    Object? outcome;
    final closing = owner.closeEditor().then<void>(
      (_) => outcome = 'closed',
      onError: (Object error) => outcome = error,
    );
    await Future<void>.value();
    owner.detach(old);
    owner.attach(next);
    await Future<void>.delayed(Duration.zero);
    try {
      expect(outcome, isA<StateError>());
      verifyNever(() => next.runJavaScript(any()));
    } finally {
      owner.approveClose();
      await closing;
    }
  });

  test(
    'detaching cancels export while JavaScript dispatch is still pending',
    () async {
      final delegate = _Controller();
      final dispatch = Completer<void>();
      when(() => delegate.runJavaScript(any()))
          .thenAnswer((_) => dispatch.future);
      final owner = StorageOnlyOfficeHostController()..attach(delegate);
      owner.markDocumentReady(true);
      Object? outcome;
      final pending = owner.requestExport().then<void>(
        (value) => outcome = value,
        onError: (Object error) => outcome = error,
      );
      owner.detach(delegate);
      await Future<void>.delayed(Duration.zero);
      try {
        expect(outcome, isA<StateError>());
      } finally {
        dispatch.complete();
        owner.downloadReceived((
          url: 'https://office.example/old.pdf',
          fileType: 'pdf',
        ));
        await pending;
      }
    },
  );
}
