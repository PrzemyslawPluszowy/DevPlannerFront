import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/presentation/storage/office/cubit/storage_office_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/office/cubit/storage_office_state.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  late _MockStorageRepository repository;

  setUp(() {
    repository = _MockStorageRepository();
  });

  const sampleSession = OnlyOfficeSessionResponse(
    fileId: 'file-1',
    documentType: 'word',
    documentServerUrl: 'https://onlyoffice.example.com',
    documentKey: 'key-123',
    token: 'jwt-token',
    canEdit: true,
  );

  test('initSession emituje Ready z konfiguracją sesji', () async {
    when(() => repository.getOfficeSession('file-1'))
        .thenAnswer((_) async => const Right(sampleSession));

    final cubit = StorageOfficeCubit(fileId: 'file-1', repository: repository);
    expect(cubit.state, isA<StorageOfficeInitial>());

    await cubit.initSession();

    expect(cubit.state, isA<StorageOfficeReady>());
    final state = cubit.state as StorageOfficeReady;
    expect(state.session.documentKey, equals('key-123'));
    expect(state.session.canEdit, isTrue);

    cubit.closeSession();
    expect(cubit.state, isA<StorageOfficeInitial>());

    await cubit.close();
  });
}
