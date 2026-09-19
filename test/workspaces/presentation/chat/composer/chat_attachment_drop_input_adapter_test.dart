import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_drop_input_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps dropped file to the same neutral upload input shape', () async {
    final inputs = await ChatAttachmentDropInputAdapter.fromFiles([
      DropItemFile.fromData(
        Uint8List.fromList([1, 2]),
        path: '/tmp/dropped.txt',
        mimeType: 'text/plain',
      ),
    ]);
    expect(inputs.single.name, 'dropped.txt');
    expect(inputs.single.size, 2);
    expect(inputs.single.mimeType, 'text/plain');
    expect(inputs.single.bytes, Uint8List.fromList([1, 2]));
  });
}
