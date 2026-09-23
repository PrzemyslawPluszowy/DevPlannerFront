import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:devplanner/workspaces/domain/storage/models/file_picker_constraints.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_drop_input_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

const _defaultConstraints = FilePickerConstraints(
  maxFiles: 20,
  maxFileSizeBytes: 50 * 1024 * 1024,
  maxTotalSizeBytes: 100 * 1024 * 1024,
);

void main() {
  test('maps dropped file to the same neutral upload input shape', () async {
    final inputs = await ChatAttachmentDropInputAdapter.fromFiles(
      [
        DropItemFile.fromData(
          Uint8List.fromList([1, 2]),
          path: '/tmp/dropped.txt',
          mimeType: 'text/plain',
        ),
      ],
      constraints: _defaultConstraints,
    );
    expect(inputs.single.name, 'dropped.txt');
    expect(inputs.single.size, 2);
    expect(inputs.single.mimeType, 'text/plain');
    expect(inputs.single.bytes, Uint8List.fromList([1, 2]));
  });

  test('does not read a file that exceeds the per-file limit', () async {
    final inputs = await ChatAttachmentDropInputAdapter.fromFiles(
      [
        DropItemFile.fromData(
          Uint8List.fromList([1, 2]),
          name: 'large.bin',
          length: 11,
        ),
      ],
      constraints: const FilePickerConstraints(
        maxFiles: 2,
        maxFileSizeBytes: 10,
        maxTotalSizeBytes: 20,
      ),
    );

    expect(inputs.single.size, 11);
    expect(inputs.single.bytes, isNull);
  });

  test('bounds reads by remaining message bytes', () async {
    final inputs = await ChatAttachmentDropInputAdapter.fromFiles(
      [
        DropItemFile.fromData(
          Uint8List.fromList([1, 2, 3, 4]),
          name: 'accepted.bin',
        ),
        DropItemFile.fromData(
          Uint8List.fromList([5, 6, 7, 8]),
          name: 'over-budget.bin',
        ),
      ],
      constraints: const FilePickerConstraints(
        maxFiles: 2,
        maxFileSizeBytes: 10,
        maxTotalSizeBytes: 6,
      ),
    );

    expect(inputs[0].bytes, Uint8List.fromList([1, 2, 3, 4]));
    expect(inputs[1].size, 4);
    expect(inputs[1].bytes, isNull);
  });

  test('does not read files beyond remaining attachment slots', () async {
    final inputs = await ChatAttachmentDropInputAdapter.fromFiles(
      [
        DropItemFile.fromData(Uint8List.fromList([1, 2]), name: 'one.bin'),
        DropItemFile.fromData(Uint8List.fromList([3, 4]), name: 'two.bin'),
      ],
      constraints: const FilePickerConstraints(
        maxFiles: 1,
        maxFileSizeBytes: 10,
        maxTotalSizeBytes: 20,
      ),
    );

    expect(inputs[0].bytes, Uint8List.fromList([1, 2]));
    expect(inputs[1].size, 2);
    expect(inputs[1].bytes, isNull);
  });
}
