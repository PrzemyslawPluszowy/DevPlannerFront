import 'package:devplanner/workspaces/domain/storage/models/file_picker_constraints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const constraints = FilePickerConstraints(
    maxFiles: 3,
    maxFileSizeBytes: 8,
    maxTotalSizeBytes: 12,
    alreadySelectedFileCount: 1,
    alreadySelectedBytes: 4,
  );

  test('allows an input on exact remaining boundaries', () {
    expect(
      constraints.canReadFile(
        8,
        acceptedFilesInBatch: 1,
      ),
      isTrue,
    );
  });

  test('rejects input that exceeds the per-file size', () {
    expect(constraints.canReadFile(9), isFalse);
  });

  test('rejects input beyond remaining count or aggregate size', () {
    expect(constraints.canReadFile(1, acceptedFilesInBatch: 2), isFalse);
    expect(
      constraints.canReadFile(5, acceptedBytesInBatch: 4),
      isFalse,
    );
  });
}
