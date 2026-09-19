import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/mutations/standalone/storage_mutations_composition.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockStorageRepository extends Mock implements StorageRepository {}

final class _MockDownloadTransport extends Mock implements DownloadTransport {}

final class _MockUploadTransport extends Mock implements UploadTransport {}

void main() {
  testWidgets('provides the standalone Files mutation cubits', (tester) async {
    final repository = _MockStorageRepository();
    final downloadTransport = _MockDownloadTransport();
    final uploadTransport = _MockUploadTransport();

    await tester.pumpWidget(
      StorageMutationsComposition(
        repository: repository,
        downloadTransport: downloadTransport,
        uploadTransport: uploadTransport,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Text(
              [
                context.read<StorageFolderMutationCubit>(),
                context.read<StorageFileMutationCubit>(),
                context.read<StorageUploadCubit>(),
              ].length.toString(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('3'), findsOneWidget);
  });
}
