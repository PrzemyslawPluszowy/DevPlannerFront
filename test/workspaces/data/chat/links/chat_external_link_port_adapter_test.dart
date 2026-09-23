import 'package:devplanner/workspaces/data/chat/links/chat_external_link_port_adapter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  late List<Uri> launched;
  late List<LaunchMode> modes;

  ChatExternalLinkPortAdapter adapterThat({
    required bool result,
    Exception? throwError,
  }) => ChatExternalLinkPortAdapter(
    launcher: (uri, mode) async {
      launched.add(uri);
      modes.add(mode);
      if (throwError != null) throw throwError;
      return result;
    },
  );

  setUp(() {
    launched = <Uri>[];
    modes = <LaunchMode>[];
  });

  group('ChatExternalLinkPortAdapter', () {
    test('otwiera bezpieczny adres jako zewnętrzną aplikację', () async {
      final adapter = adapterThat(result: true);

      expect(await adapter.open(' https://devplanner.example/docs '), isTrue);
      expect(launched.single.toString(), 'https://devplanner.example/docs');
      expect(modes.single, LaunchMode.externalApplication);
    });

    test('odrzuca schematy inne niż http i https', () async {
      final adapter = adapterThat(result: true);

      expect(await adapter.open('javascript:alert(1)'), isFalse);
      expect(await adapter.open('data:text/html,<b>x</b>'), isFalse);
      expect(await adapter.open('file:///etc/passwd'), isFalse);
      expect(await adapter.open('/workspaces/1'), isFalse);
      expect(launched, isEmpty);
    });

    test('odrzuca pusty i nieparsowalny adres', () async {
      final adapter = adapterThat(result: true);

      expect(await adapter.open(''), isFalse);
      expect(await adapter.open('http://exa mple.test'), isFalse);
      expect(launched, isEmpty);
    });

    test('odmowa systemu wraca jako porażka', () async {
      final adapter = adapterThat(result: false);
      expect(await adapter.open('https://a.test'), isFalse);
    });

    test('błąd launchera nie wychodzi na zewnątrz', () async {
      final adapter = adapterThat(result: true, throwError: Exception('boom'));
      expect(await adapter.open('https://a.test'), isFalse);
    });
  });
}
