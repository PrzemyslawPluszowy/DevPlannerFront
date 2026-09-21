import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/ports/storage_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_realtime_client.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Picker bez systemowego dialogu: testy nie dotykają wyboru plików z dysku.
final class NoopFilePicker extends Fake implements FilePickerPort {
  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  }) async => const [];
}

/// Rejestruje wartości zastępcze dla typów używanych w matcherach repozytorium.
void registerStorageFallbacks() {
  registerFallbackValue(const StorageScope.personal());
  registerFallbackValue(const StorageBrowserFilter());
}

/// Montuje jeden host modułu Pliki tak, jak robi to trasa.
///
/// Wszystkie testy shella przechodzą przez ten helper, żeby zakres, uprawnienia
/// kompozycji i porty były podawane w jeden sposób — inaczej każdy plik testowy
/// odtwarzałby własny wariant wrappera i rozjeżdżał się z runtime.
Future<void> pumpStorageShell(
  WidgetTester tester, {
  required StorageRepository repository,
  StorageScope scope = const StorageScope.personal(),
  StorageShellCapabilities capabilities = StorageShellCapabilities.desktop,
  FilePickerPort? filePicker,
  DownloadTransport? downloadTransport,
  UploadTransport? uploadTransport,
  StorageViewPreferenceStore? viewPreferenceStore,
  StorageUserDirectoryPort? userDirectory,
  StorageRealtimeClientFactory? realtimeClientFactory,
  ValueChanged<String>? onOpenFileDetails,
  Locale locale = const Locale('pl'),
  Size viewport = const Size(1440, 900),
}) async {
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: StorageShellPage(
          initialScope: scope,
          storageRepository: repository,
          capabilities: capabilities,
          filePicker: filePicker ?? NoopFilePicker(),
          downloadTransport: downloadTransport,
          uploadTransport: uploadTransport,
          viewPreferenceStore: viewPreferenceStore,
          userDirectory: userDirectory,
          realtimeClientFactory: realtimeClientFactory,
          onOpenFileDetails: onOpenFileDetails,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Przykładowy folder dla testów shella.
StorageFolderResponse storageTestFolder({
  String id = 'folder-1',
  String name = 'Dokumenty',
  StorageFileAccessFlags flags = const StorageFileAccessFlags(),
}) => StorageFolderResponse(
  id: id,
  name: name,
  folderType: StorageFolderType.personal,
  itemCount: 0,
  updatedAtUtc: DateTime.utc(2026, 9, 20, 12),
  accessLevel: StorageEffectiveAccessLevel.owner,
  canRead: true,
  canComment: true,
  canEdit: true,
  canShare: flags.canShare,
  canDelete: flags.canDelete,
);

/// Przykładowy plik dla testów shella.
StorageFileResponse storageTestFile({
  String id = 'file-1',
  String name = 'dokument.pdf',
  String? workspaceId = 'workspace-1',
  StorageFileAccessFlags flags = const StorageFileAccessFlags(),
}) => StorageFileResponse(
  id: id,
  module: StorageModule.workspaces,
  workspaceId: workspaceId,
  resourceType: StorageResourceType.document,
  originalFileName: name,
  extension: 'pdf',
  mimeType: 'application/pdf',
  fileSizeBytes: 1024,
  version: 1,
  ownerUserId: 'user-1',
  createdByUserId: 'user-1',
  createdAtUtc: DateTime.utc(2026, 9, 20, 12),
  updatedAtUtc: DateTime.utc(2026, 9, 20, 12),
  isDeleted: false,
  processingStatus: StorageProcessingStatus.ready,
  scanStatus: StorageScanStatus.clean,
  aiStatus: StorageAiStatus.completed,
  accessLevel: StorageEffectiveAccessLevel.owner,
  canRead: true,
  canComment: true,
  canEdit: true,
  canShare: flags.canShare,
  canDelete: flags.canDelete,
  canDownload: true,
  canPreview: true,
  canManageVersions: true,
);

/// Uprawnienia elementu w przykładach; domyślnie pełne, jak u właściciela.
final class StorageFileAccessFlags {
  const StorageFileAccessFlags({this.canShare = true, this.canDelete = true});

  final bool canShare;
  final bool canDelete;
}
