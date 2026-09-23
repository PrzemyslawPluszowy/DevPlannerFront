import 'dart:convert';

import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/transport/onlyoffice_editor_html_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buduje host DocsAPI z podpisaną konfiguracją backendu', () {
    final payload = base64Url
        .encode(
          utf8.encode(
            jsonEncode({
              'fileId': 'file-1',
              'docKey': 'key-1',
              'documentType': 'word',
              'document': {
                'key': 'key-1',
                'url': 'https://storage.example/file',
              },
              'editorConfig': {'mode': 'edit'},
            }),
          ),
        )
        .replaceAll('=', '');
    final session = OnlyOfficeSessionResponse(
      fileId: 'file-1',
      documentType: 'word',
      documentServerUrl: 'https://office.example/',
      documentKey: 'key-1',
      token: 'header.$payload.signature',
      canEdit: true,
    );

    final html = OnlyOfficeEditorHtmlBuilder.build(session);

    expect(html, contains('web-apps/apps/api/documents/api.js'));
    expect(html, contains('new DocsAPI.DocEditor'));
    expect(html, contains('onDownloadAs'));
    expect(html, isNot(contains('onRequestSaveAs')));
    expect(html, contains('storageBridge.postMessage'));
    expect(html, contains(session.token));
    expect(html, isNot(contains('"fileId":"file-1"')));
  });
}
