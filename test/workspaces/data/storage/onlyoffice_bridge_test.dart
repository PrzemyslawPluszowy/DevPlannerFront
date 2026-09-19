import 'package:devplanner/workspaces/data/storage/transport/onlyoffice_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final server = Uri.parse('https://office.example');
  test('odczytuje JSON eksportu i rzeczywiste rozszerzenie pliku', () {
    final message = OnlyOfficeBridge.decode(
      '{"type":"download","data":{"url":"https://office.example/cache/out.pdf?token=test","fileType":"pdf"}}',
    );
    final result = OnlyOfficeBridge.download(message!['data'], server);
    expect(result?.fileType, 'pdf');
    expect(result?.url, 'https://office.example/cache/out.pdf?token=test');
  });
  test('odrzuca obiekt zamiast JSON i niepoprawne adresy eksportu', () {
    expect(OnlyOfficeBridge.decode('[object Object]'), isNull);
    expect(OnlyOfficeBridge.decode('[]'), isNull);
    for (final url in [
      'https://attacker.example/file.pdf',
      'http://office.example/file.pdf',
      'https://user:pass@office.example/file.pdf',
      'javascript:alert(1)',
      'https://office.example/file.pdf#fragment',
    ]) {
      expect(
        OnlyOfficeBridge.download({'url': url, 'fileType': 'pdf'}, server),
        isNull,
      );
    }
    expect(
      OnlyOfficeBridge.download({
        'url': 'https://office.example/file',
        'fileType': '../docx',
      }, server),
      isNull,
    );
  });

  test('obsługuje loopback 127.0.0.1 i localhost oraz czyści rozszerzenie z kropką', () {
    final localServer = Uri.parse('http://127.0.0.1:8081');
    final result = OnlyOfficeBridge.download({
      'url': 'http://localhost:8081/cache/out.docx',
      'fileType': '.docx',
    }, localServer);
    expect(result?.fileType, 'docx');
    expect(result?.url, 'http://localhost:8081/cache/out.docx');
  });

  test('odczytuje zdarzenie saveAs z tytułem i formatem', () {
    final message = OnlyOfficeBridge.decode(
      '{"type":"saveAs","data":{"url":"https://office.example/cache/out.docx","fileType":"docx","title":"Raport.docx"}}',
    );
    final result = OnlyOfficeBridge.saveAs(message!['data'], server);
    expect(result?.fileType, 'docx');
    expect(result?.url, 'https://office.example/cache/out.docx');
    expect(result?.title, 'Raport.docx');
  });

  test('saveAs odrzuca niepoprawne adresy i rozszerzenia', () {
    expect(
      OnlyOfficeBridge.saveAs({
        'url': 'https://evil.example/file.pdf',
        'fileType': 'pdf',
      }, server),
      isNull,
    );
  });
}
