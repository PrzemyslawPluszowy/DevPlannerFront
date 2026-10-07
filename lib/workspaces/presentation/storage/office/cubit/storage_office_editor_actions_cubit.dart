import 'dart:async';
import 'dart:typed_data';

import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/payloads/storage_payloads.dart';
import 'package:devplanner/workspaces/data/storage/transport/onlyoffice_bridge.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_export_names.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_save_confirmation_watch.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_save_operation_id.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

/// Wykonuje mutacje dokumentu OnlyOffice bez zależności od widgetów i `BuildContext`.
final class StorageOfficeEditorActionsCubit
    extends Cubit<StorageOfficeEditorActionsState> {
  StorageOfficeEditorActionsCubit(
    this._file,
    this._repository,
    this._downloadTransport,
    this._uploadTransport,
    this._hostController, {
    this.confirmationInterval = const Duration(milliseconds: 1500),
    this.confirmationTimeout = const Duration(seconds: 60),
  }) : _exportNames = StorageOfficeExportNames(
         _file.originalFileName,
         _file.extension,
       ),
       super(const StorageOfficeEditorActionsState()) {
    _confirmationWatch = StorageOfficeSaveConfirmationWatch(
      readVersion: _readServerVersion,
      onConfirmed: _confirmVersion,
      onUnconfirmed: _markSaveUnconfirmed,
      interval: confirmationInterval,
      timeout: confirmationTimeout,
    );
  }

  final StorageFileResponse _file;
  final StorageOfficeExportNames _exportNames;
  final StorageRepository _repository;
  final DownloadTransport _downloadTransport;
  final UploadTransport _uploadTransport;
  final StorageOnlyOfficeHostController _hostController;

  /// Odstęp kontroli potwierdzenia i okno, po którym zapis uznajemy za
  /// niepotwierdzony, zamiast pokazywać użytkownikowi fałszywe „zapisano”.
  final Duration confirmationInterval;
  final Duration confirmationTimeout;

  late final StorageOfficeSaveConfirmationWatch _confirmationWatch;

  bool _canEdit = false;
  String? _documentKey;
  String? _saveOperationId;
  int _saveGeneration = 0;
  int? _requestGeneration;

  bool get _isExportBusy =>
      state.isDownloading || state.isPrinting || state.isSavingCopy;

  /// Prosi osadzony edytor o wygenerowanie pliku w formacie źródłowym.
  Future<void> requestDownload() async {
    if (_isExportBusy || state.isClosing || !state.isSessionReady) return;
    emit(state.copyWith(isDownloading: true));
    try {
      final extension = _file.extension.replaceFirst('.', '');
      await _hostController
          .requestExport(format: extension.isEmpty ? null : extension)
          .timeout(const Duration(seconds: 30));
    } on Object {
      _finishDownloadWithNotice(
        const StorageOfficeEditorActionLocalizedFailure(
          code: StorageOfficeEditorActionFailureCode.download,
        ),
      );
    }
  }

  /// Pobiera plik wystawiony przez OnlyOffice po wcześniejszym eksporcie.
  Future<void> downloadGeneratedFile(
    OnlyOfficeDownload download, {
    required String? sessionToken,
  }) async {
    if (state.isClosing || state.isPrinting || state.isSavingCopy) return;
    if (!state.isDownloading) emit(state.copyWith(isDownloading: true));

    final fileName = '${_exportNames.stem}.${download.fileType}';
    try {
      final result = await _downloadTransport
          .downloadUrl(
            downloadUrl: download.url,
            fileName: fileName,
            headers: _onlyOfficeHeaders(sessionToken),
          )
          .timeout(const Duration(minutes: 2));
      if (isClosed) return;

      result.fold(
        (error) => _finishDownloadWithNotice(
          StorageOfficeEditorActionFailure(message: error.message),
        ),
        (_) => _finishDownloadWithNotice(
          StorageOfficeEditorActionSuccess(
            fileName: fileName,
            kind: StorageOfficeEditorActionSuccessKind.download,
          ),
        ),
      );
    } on Object {
      if (!isClosed) {
        _finishDownloadWithNotice(
          const StorageOfficeEditorActionLocalizedFailure(
            code: StorageOfficeEditorActionFailureCode.download,
          ),
        );
      }
    }
  }

  /// Eksportuje dokument do PDF i przekazuje bajty do natywnego systemu drukowania.
  Future<void> requestPrint({required String? sessionToken}) async {
    if (_isExportBusy || state.isClosing || !state.isSessionReady) return;
    emit(state.copyWith(isPrinting: true));
    try {
      final download = await _hostController
          .requestExport(format: 'pdf')
          .timeout(const Duration(seconds: 30));
      final bytesResult = await _downloadTransport.fetchBytes(
        downloadUrl: download.url,
        headers: _onlyOfficeHeaders(sessionToken),
      );
      if (isClosed) return;

      await bytesResult.fold(
        (_) async => _publishNotice(
          const StorageOfficeEditorActionLocalizedFailure(
            code: StorageOfficeEditorActionFailureCode.print,
          ),
        ),
        (bytes) => Printing.layoutPdf(
          name: '${_exportNames.stem}.pdf',
          onLayout: (_) async => bytes,
        ),
      );
    } on Object {
      _publishNotice(
        const StorageOfficeEditorActionLocalizedFailure(
          code: StorageOfficeEditorActionFailureCode.print,
        ),
      );
    } finally {
      if (!isClosed) emit(state.copyWith(isPrinting: false));
    }
  }

  /// Tworzy nowy plik Storage na podstawie eksportu lub callbacku „Zapisz jako”.
  Future<void> saveCopy({
    required String? sessionToken,
    String? format,
    String? suggestedTitle,
    String? downloadUrl,
  }) async {
    if (_isExportBusy || state.isClosing || !state.isSessionReady) return;
    emit(state.copyWith(isSavingCopy: true));
    try {
      final download = await _resolveCopyDownload(
        format: format,
        downloadUrl: downloadUrl,
      );
      final bytesResult = await _downloadTransport.fetchBytes(
        downloadUrl: download.url,
        headers: _onlyOfficeHeaders(sessionToken),
      );
      if (isClosed) return;

      await bytesResult.fold(
        (_) async => _publishNotice(
          const StorageOfficeEditorActionLocalizedFailure(
            code: StorageOfficeEditorActionFailureCode.saveCopy,
          ),
        ),
        (bytes) => _uploadCopy(
          bytes: Uint8List.fromList(bytes),
          fileType: download.fileType,
          suggestedTitle: suggestedTitle,
        ),
      );
    } on Object {
      _publishNotice(
        const StorageOfficeEditorActionLocalizedFailure(
          code: StorageOfficeEditorActionFailureCode.saveCopy,
        ),
      );
    } finally {
      if (!isClosed) emit(state.copyWith(isSavingCopy: false));
    }
  }

  /// Rezerwuje zamknięcie, aby UI nie uruchomiło drugi raz lifecycle WebView.
  bool beginClosing() {
    if (state.isClosing || _isExportBusy) return false;
    emit(state.copyWith(isClosing: true));
    return true;
  }

  /// Zwalnia rezerwację, gdy użytkownik odmówił wymuszonego zamknięcia.
  /// Zapisuje status połączenia sesji zgłoszony przez dokument.
  void sessionReady({required String documentKey, bool canEdit = true}) {
    if (isClosed) return;
    final changed = _documentKey != documentKey || _canEdit != canEdit;
    if (changed) {
      _saveGeneration++;
      _saveOperationId = null;
      _confirmationWatch.stop();
    }
    _documentKey = documentKey;
    _canEdit = canEdit;
    emit(
      state.copyWith(
        isSessionReady: true,
        hasUnsavedChanges: !changed && state.hasUnsavedChanges,
        saveConfirmation: changed
            ? StorageOfficeSaveConfirmation.none
            : state.saveConfirmation,
      ),
    );
  }

  /// Zapisuje status dokumentu zgłoszony przez OnlyOffice.
  ///
  /// Brak lokalnych zmian to jeszcze nie zapis: callback może lecieć, zostać
  /// odrzucony albo czekać na skanowanie. Dlatego przejście na „bez zmian”
  /// włącza kontrolę potwierdzenia po stronie backendu, a „zapisano” pojawia się
  /// dopiero z nową wersją pliku.
  void documentStateChanged({required bool isModified}) {
    if (isClosed || !_canEdit) return;
    if (isModified) {
      _saveGeneration++;
      _saveOperationId = null;
      _confirmationWatch.stop();
      emit(
        state.copyWith(
          hasUnsavedChanges: true,
          saveConfirmation: StorageOfficeSaveConfirmation.none,
        ),
      );
      return;
    }

    final editedBefore = state.hasUnsavedChanges;
    emit(
      state.copyWith(
        hasUnsavedChanges: false,
        saveConfirmation: editedBefore
            ? StorageOfficeSaveConfirmation.awaitingServer
            : state.saveConfirmation,
      ),
    );
    if (editedBefore) {
      unawaited(requestSave());
    }
  }

  /// Zapisuje treść już zsynchronizowaną z DocumentServer i śledzi dokładny callback.
  Future<void> requestSave() async {
    final documentKey = _documentKey;
    final generation = _saveGeneration;
    if (isClosed ||
        !_canEdit ||
        documentKey == null ||
        state.hasUnsavedChanges ||
        !state.isSessionReady ||
        _requestGeneration == generation ||
        state.saveConfirmation == StorageOfficeSaveConfirmation.confirmed) {
      return;
    }
    final operationId = _saveOperationId ??=
        StorageOfficeSaveOperationId.create();
    _requestGeneration = generation;
    _confirmationWatch.stop();
    emit(
      state.copyWith(
        saveConfirmation: StorageOfficeSaveConfirmation.awaitingServer,
      ),
    );
    try {
      final result = await _repository.requestOfficeSave(
        fileId: _file.id,
        documentKey: documentKey,
        operationId: operationId,
      );
      if (isClosed || generation != _saveGeneration) return;
      result.fold(
        (_) => _markSaveUnconfirmed(),
        (save) {
          if (save.operationId != operationId) {
            _markSaveUnconfirmed();
          } else if (save.confirmed) {
            _confirmVersion(save.version!);
          } else {
            // Odczyt jest korelowany operationId, więc także ta sama wersja
            // może być potwierdzeniem dwóch zapisów identycznej treści.
            _confirmationWatch.start(0);
          }
        },
      );
    } on Object {
      if (!isClosed && generation == _saveGeneration) _markSaveUnconfirmed();
    } finally {
      if (_requestGeneration == generation) _requestGeneration = null;
    }
  }

  Future<int?> _readServerVersion() async {
    final operationId = _saveOperationId;
    if (operationId == null) return null;
    final result = await _repository.getOfficeSaveResult(
      fileId: _file.id,
      operationId: operationId,
    );
    return result.fold((_) => null, (save) {
      if (save.operationId != operationId) return null;
      return save.confirmed ? save.version : 0;
    });
  }

  void _confirmVersion(int version) {
    if (isClosed) return;
    emit(
      state.copyWith(
        hasSavedChanges: true,
        saveConfirmation: StorageOfficeSaveConfirmation.confirmed,
        confirmedVersion: version,
      ),
    );
  }

  void _markSaveUnconfirmed() {
    if (isClosed) return;
    emit(
      state.copyWith(
        saveConfirmation: StorageOfficeSaveConfirmation.unconfirmed,
      ),
    );
  }

  @override
  Future<void> close() async {
    _saveGeneration++;
    _confirmationWatch.stop();
    return super.close();
  }

  void cancelClosing() {
    if (!isClosed) emit(state.copyWith(isClosing: false));
  }

  /// Czy edytor zgłosił brak zmian, ale backend nie potwierdził jeszcze wersji.
  bool get isAwaitingSaveConfirmation =>
      state.saveConfirmation == StorageOfficeSaveConfirmation.awaitingServer;

  /// Czeka na potwierdzenie zapisu, maksymalnie przez okno kontroli.
  ///
  /// Zamknięcie modala nie może przerwać oczekiwania wcześniej, niż backend
  /// zdąży potwierdzić wersję: inaczej webowy BFF bez kanału realtime odświeży
  /// listę przed callbackiem zapisu i pokaże starą wersję. Zwraca `true`, gdy
  /// wersja została potwierdzona, `false` przy braku potwierdzenia w oknie.
  Future<bool> waitForConfirmedSave() async {
    if (!isAwaitingSaveConfirmation) {
      return state.saveConfirmation == StorageOfficeSaveConfirmation.confirmed;
    }
    // Kontrola chodzi cyklicznie; tu czekamy na jej wynik, ale nie dłużej niż
    // okno kontroli plus jeden odstęp, żeby nie zawiesić zamknięcia na zawsze.
    final deadline = DateTime.now().add(confirmationTimeout);
    while (!isClosed &&
        state.saveConfirmation ==
            StorageOfficeSaveConfirmation.awaitingServer &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    return state.saveConfirmation == StorageOfficeSaveConfirmation.confirmed;
  }

  Future<OnlyOfficeDownload> _resolveCopyDownload({
    String? format,
    String? downloadUrl,
  }) async {
    if (downloadUrl != null && format != null) {
      return (url: downloadUrl, fileType: format);
    }
    final sourceExtension = _file.extension.isNotEmpty
        ? _file.extension
        : _file.originalFileName.split('.').last;
    final targetFormat = format ?? sourceExtension.replaceFirst('.', '');
    return _hostController
        .requestExport(format: targetFormat.isEmpty ? null : targetFormat)
        .timeout(const Duration(seconds: 30));
  }

  Future<void> _uploadCopy({
    required Uint8List bytes,
    required String fileType,
    required String? suggestedTitle,
  }) async {
    final targetFileName = _exportNames.copyFileName(fileType, suggestedTitle);
    final payload = StorageUploadTicketPayload(
      fileName: targetFileName,
      fileSizeBytes: bytes.length,
      mimeType: StorageOfficeExportNames.mimeType(targetFileName),
      module: _file.module,
      resourceType: _file.resourceType,
      resourceId: _file.resourceId,
      workspaceId: _file.workspaceId,
      projectId: _file.projectId,
    );
    final ticketResult = await _repository.requestUploadTicket(payload);
    if (isClosed) return;

    await ticketResult.fold(
      (error) async => _publishNotice(
        StorageOfficeEditorActionFailure(message: error.message),
      ),
      (ticket) async {
        final uploadResult = await _uploadTransport.upload(
          ticket: ticket,
          input: StorageUploadInput(
            name: targetFileName,
            size: bytes.length,
            bytes: bytes,
            mimeType: payload.mimeType,
          ),
        );
        if (isClosed) return;
        await uploadResult.fold(
          (error) async => _publishNotice(
            StorageOfficeEditorActionFailure(message: error.message),
          ),
          (_) async {
            final completeResult = await _repository.completeUpload(
              fileId: ticket.fileId,
              fileSizeBytes: bytes.length,
            );
            if (isClosed) return;
            completeResult.fold(
              (error) => _publishNotice(
                StorageOfficeEditorActionFailure(message: error.message),
              ),
              (createdFile) => _publishNotice(
                StorageOfficeEditorActionSuccess(
                  fileName: createdFile.originalFileName,
                  kind: StorageOfficeEditorActionSuccessKind.saveCopy,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Map<String, String>? _onlyOfficeHeaders(String? sessionToken) =>
      sessionToken == null ? null : {'X-OnlyOffice-JWT': sessionToken};

  void _finishDownloadWithNotice(StorageOfficeEditorActionNotice notice) {
    if (isClosed) return;
    emit(
      state.copyWith(
        isDownloading: false,
        notice: notice,
        noticeRevision: state.noticeRevision + 1,
      ),
    );
  }

  void _publishNotice(StorageOfficeEditorActionNotice notice) {
    if (isClosed) return;
    emit(
      state.copyWith(
        notice: notice,
        noticeRevision: state.noticeRevision + 1,
      ),
    );
  }
}
