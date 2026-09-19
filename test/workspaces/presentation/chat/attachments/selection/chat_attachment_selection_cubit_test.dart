import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatAttachmentSelectionCubit', () {
    test(
      'egzekwuje 20 plików, 50 MiB na plik i 100 MiB na wiadomość',
      () async {
        final cubit = ChatAttachmentSelectionCubit();
        const mib = 1024 * 1024;

        cubit.selectInputs(
          List.generate(
            21,
            (index) => StorageUploadInput(name: '$index.txt', size: 1),
          ),
        );
        var state = cubit.state as ChatAttachmentSelectionReady;
        expect(state.attachments, hasLength(20));
        expect(
          state.rejections.single.reason,
          ChatAttachmentRejectionReason.tooManyFiles,
        );

        cubit.remove(state.attachments.last.localId);
        cubit.selectInputs(
          [const StorageUploadInput(name: 'big.bin', size: 50 * mib + 1)],
        );
        state = cubit.state as ChatAttachmentSelectionReady;
        expect(
          state.rejections.single.reason,
          ChatAttachmentRejectionReason.fileTooLarge,
        );

        await cubit.close();
        final sizeCubit = ChatAttachmentSelectionCubit();
        sizeCubit.selectInputs([
          const StorageUploadInput(name: 'one.bin', size: 50 * mib),
          const StorageUploadInput(name: 'two.bin', size: 50 * mib),
          const StorageUploadInput(name: 'three.bin', size: 1),
        ]);
        state = sizeCubit.state as ChatAttachmentSelectionReady;
        expect(state.attachments, hasLength(2));
        expect(
          state.rejections.single.reason,
          ChatAttachmentRejectionReason.messageTooLarge,
        );
        await sizeCubit.close();
      },
    );

    test(
      'przyjmuje zdarzenia neutralnego źródła i tylko monotoniczne statusy',
      () async {
        final source = _SelectionSource();
        final cubit = ChatAttachmentSelectionCubit(selectionSource: source);
        source.controller.add([
          const StorageUploadInput(name: 'scan.pdf', size: 1),
        ]);
        await Future<void>.delayed(Duration.zero);
        final id = (cubit.state as ChatAttachmentSelectionReady)
            .attachments
            .single
            .localId;

        cubit.transitionStatus(id, ChatAttachmentStatus.scanning);
        cubit.transitionStatus(id, ChatAttachmentStatus.clean);
        cubit.transitionStatus(id, ChatAttachmentStatus.failed);

        final attachment =
            (cubit.state as ChatAttachmentSelectionReady).attachments.single;
        expect(attachment.status, ChatAttachmentStatus.clean);
        await cubit.close();
        await source.controller.close();
      },
    );

    test(
      'revoke odłącza dane przed nieudaną utylizacją i nie przywraca ich',
      () async {
        final disposal = _FailingDisposalPort();
        final cubit = ChatAttachmentSelectionCubit(disposalPort: disposal);
        cubit.selectInputs([
          const StorageUploadInput(name: 'private.txt', size: 1),
        ]);

        final revoke = cubit.revokeAndDispose();
        expect(
          (cubit.state as ChatAttachmentSelectionReady).attachments,
          isEmpty,
        );
        await revoke;

        final state = cubit.state as ChatAttachmentSelectionReady;
        expect(disposal.disposed, hasLength(1));
        expect(state.attachments, isEmpty);
        expect(state.disposalFailed, isTrue);
        await cubit.close();
      },
    );

    test(
      'remove odłącza plik przed nieudaną utylizacją i nie przywraca go',
      () async {
        final disposal = _FailingDisposalPort();
        final cubit = ChatAttachmentSelectionCubit(disposalPort: disposal);
        cubit.selectInputs([
          const StorageUploadInput(name: 'remove.txt', size: 1),
          const StorageUploadInput(name: 'keep.txt', size: 1),
        ]);
        final removed =
            (cubit.state as ChatAttachmentSelectionReady).attachments.first;

        cubit.remove(removed.localId);
        expect(
          (cubit.state as ChatAttachmentSelectionReady).attachments.map(
            (attachment) => attachment.input.name,
          ),
          ['keep.txt'],
        );
        await Future<void>.delayed(Duration.zero);

        final state = cubit.state as ChatAttachmentSelectionReady;
        expect(disposal.disposed, [removed]);
        expect(
          state.attachments.map((attachment) => attachment.input.name),
          ['keep.txt'],
        );
        expect(state.disposalFailed, isTrue);
        await cubit.close();
      },
    );

    test('close odłącza i utylizuje pozostałe lokalne zasoby', () async {
      final disposal = _CollectingDisposalPort();
      final cubit = ChatAttachmentSelectionCubit(disposalPort: disposal);
      cubit.selectInputs([
        const StorageUploadInput(name: 'one.txt', size: 1),
        const StorageUploadInput(name: 'two.txt', size: 1),
      ]);

      await cubit.close();

      expect(
        disposal.disposed.map((attachment) => attachment.input.name),
        ['one.txt', 'two.txt'],
      );
    });
  });
}

final class _SelectionSource implements ChatAttachmentSelectionSource {
  final StreamController<List<StorageUploadInput>> controller =
      StreamController<List<StorageUploadInput>>();

  @override
  Stream<List<StorageUploadInput>> get selections => controller.stream;
}

final class _FailingDisposalPort implements ChatAttachmentDisposalPort {
  final List<ChatAttachment> disposed = <ChatAttachment>[];

  @override
  Future<void> dispose(List<ChatAttachment> attachments) async {
    disposed.addAll(attachments);
    throw StateError('No backend disposal contract.');
  }
}

final class _CollectingDisposalPort implements ChatAttachmentDisposalPort {
  final List<ChatAttachment> disposed = <ChatAttachment>[];

  @override
  Future<void> dispose(List<ChatAttachment> attachments) async {
    disposed.addAll(attachments);
  }
}
