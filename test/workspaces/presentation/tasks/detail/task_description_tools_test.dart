import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_description_link_button.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_description_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_test/flutter_test.dart';

Widget _app(quill.QuillController controller, FocusNode focus) => MaterialApp(
  locale: const Locale('pl'),
  theme: MaterialTheme.crm().dark(),
  localizationsDelegates: const [
    ...AppLocalizations.localizationsDelegates,
    quill.FlutterQuillLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: Column(
      children: [
        TaskDescriptionToolbar(controller: controller, editorFocusNode: focus),
        Expanded(
          child: quill.QuillEditor(
            controller: controller,
            focusNode: focus,
            scrollController: ScrollController(),
          ),
        ),
      ],
    ),
  ),
);

Future<void> _open(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.byTooltip(label));
  await tester.tap(find.byTooltip(label));
  await tester.pumpAndSettle();
}

void main() {
  test('link URL validation permits absolute web URLs and rejects unsafe/non-web input', () {
    for (final value in [
      'https://example.com/a?q=x#tag',
      'http://localhost:8080/test',
      'https://user:secret@example.com',
      ...[
        'mailto',
        'tel',
        'sms',
        'callto',
        'wtai',
        'market',
        'geopoint',
        'ymsgr',
        'msnim',
        'gtalk',
        'skype',
        'sip',
        'whatsapp',
      ].map((scheme) => '$scheme:example'),
    ]) {
      expect(TaskDescriptionLinkDialog.isValidUrl(value), isTrue);
    }
    for (final value in [
      'javascript:alert(1)',
      'data:text/plain,a',
      '/relative',
      'https://',
      'https://example.com/has space',
      'mailto:',
      'tel:',
    ]) {
      expect(TaskDescriptionLinkDialog.isValidUrl(value), isFalse);
    }
  });
  for (final background in [false, true]) {
    testWidgets(
      'color ${background ? 'background' : 'foreground'} cancel, apply and clear preserve selected Delta',
      (tester) async {
        tester.view.physicalSize = const Size(1400, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = quill.QuillController(
          document: quill.Document.fromJson([
            {
              'insert': 'test',
              'attributes': {'bold': true},
            },
            {'insert': '\n'},
          ]),
          selection: const TextSelection(baseOffset: 0, extentOffset: 4),
        );
        final focus = FocusNode();
        addTearDown(focus.dispose);
        addTearDown(controller.dispose);
        await tester.pumpWidget(_app(controller, focus));
        await tester.pumpAndSettle();
        final original = controller.document.toDelta().toJson();
        final label = background ? 'Kolor tła' : 'Kolor tekstu';
        await _open(tester, label);
        await tester.tap(find.text('Anuluj'));
        await tester.pumpAndSettle();
        expect(controller.document.toDelta().toJson(), original);
        expect(
          controller.selection,
          const TextSelection(baseOffset: 0, extentOffset: 4),
        );
        expect(focus.hasFocus, isTrue);
        await _open(tester, label);
        await tester.enterText(find.byType(TextField), '#802563EB');
        await tester.tap(find.text('Zapisz'));
        await tester.pumpAndSettle();
        final key = background ? 'background' : 'color';
        expect(controller.document.toDelta().toJson().first['attributes'], {
          'bold': true,
          key: '#802563EB',
        });
        await _open(tester, label);
        await tester.tap(find.text('Kolor domyślny'));
        await tester.pumpAndSettle();
        expect(controller.document.toDelta().toJson().first['attributes'], {
          'bold': true,
        });
        await _open(tester, label);
        await tester.enterText(find.byType(TextField), '#DC2626');
        controller.readOnly = true;
        await tester.tap(find.text('Zapisz'));
        await tester.pumpAndSettle();
        expect(controller.document.toDelta().toJson().first['attributes'], {
          'bold': true,
        });
      },
    );
  }
  for (final address in ['mailto:qa@example.com', 'tel:+48123456789']) {
    testWidgets('existing $address remains editable and removable', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = quill.QuillController(
        document: quill.Document.fromJson([
          {
            'insert': 'contact',
            'attributes': {'bold': true, 'link': address},
          },
          {'insert': '\n'},
        ]),
        selection: const TextSelection.collapsed(offset: 2),
      );
      final focus = FocusNode();
      addTearDown(focus.dispose);
      addTearDown(controller.dispose);
      await tester.pumpWidget(_app(controller, focus));
      await tester.pumpAndSettle();
      await _open(tester, 'Wstaw link');
      expect(
        tester.widget<TextField>(find.byType(TextField).last).controller!.text,
        address,
      );
      await tester.tap(find.text('Anuluj'));
      await tester.pumpAndSettle();
      expect(controller.document.toDelta().toJson().first['attributes'], {
        'bold': true,
        'link': address,
      });
      await _open(tester, 'Wstaw link');
      await tester.tap(find.text('Zapisz'));
      await tester.pumpAndSettle();
      expect(controller.document.toDelta().toJson().first['attributes'], {
        'bold': true,
        'link': address,
      });
      await _open(tester, 'Wstaw link');
      await tester.tap(find.text('Usuń link'));
      await tester.pumpAndSettle();
      expect(controller.document.toDelta().toJson().first['attributes'], {
        'bold': true,
      });
    });
  }
  testWidgets(
    'link dialog validates inline and edits complete formatted link without opening it',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = quill.QuillController(
        document: quill.Document.fromJson([
          {
            'insert': 'test',
            'attributes': {'bold': true},
          },
          {'insert': '\n'},
        ]),
        selection: const TextSelection(baseOffset: 0, extentOffset: 4),
      );
      final focus = FocusNode();
      addTearDown(focus.dispose);
      addTearDown(controller.dispose);
      await tester.pumpWidget(_app(controller, focus));
      await tester.pumpAndSettle();
      await _open(tester, 'Wstaw link');
      expect(find.text('Edytuj link'), findsOneWidget);
      expect(find.text('Anuluj'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField).last,
        'javascript:alert(1)',
      );
      await tester.tap(find.text('Zapisz'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Wpisz poprawny adres linku, np. https://przyklad.pl lub mailto:kontakt@przyklad.pl.',
        ),
        findsOneWidget,
      );
      await tester.enterText(
        find.byType(TextField).last,
        'https://example.com/a',
      );
      await tester.tap(find.text('Zapisz'));
      await tester.pumpAndSettle();
      expect(controller.document.toDelta().toJson().first['attributes'], {
        'bold': true,
        'link': 'https://example.com/a',
      });
      controller.updateSelection(
        const TextSelection.collapsed(offset: 2),
        quill.ChangeSource.local,
      );
      await _open(tester, 'Wstaw link');
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        'test',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'https://example.com/b',
      );
      await tester.tap(find.text('Zapisz'));
      await tester.pumpAndSettle();
      expect(controller.document.toPlainText(), 'test\n');
      expect(controller.document.toDelta().toJson().first['attributes'], {
        'bold': true,
        'link': 'https://example.com/b',
      });
      await _open(tester, 'Wstaw link');
      await tester.tap(find.text('Usuń link'));
      await tester.pumpAndSettle();
      expect(controller.document.toDelta().toJson().first['attributes'], {
        'bold': true,
      });
      expect(focus.hasFocus, isTrue);
    },
  );
}
