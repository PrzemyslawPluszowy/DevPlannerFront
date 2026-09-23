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
  }) : _baselineVersion = _file.version,
       _confirmationFloor = _file.version,
       super(const StorageOfficeEditorActionsState());

  final StorageFileResponse _file;
  final StorageRepository _repository;
  final DownloadTransport _downloadTransport;
  final UploadTransport _uploadTransport;
  final StorageOnlyOfficeHostController _hostController;

  /// Wersja pliku w chwili otwarcia sesji.
  final int _baselineVersion;

  /// Próg potwierdzenia bieżącego oczekiwania.
  ///
  /// Startuje z wersji z chwili otwarcia, a po każdym potwierdzonym zapisie
  /// przesuwa się na potwierdzoną wersję. Bez tego drugi zapis w tej samej sesji
  /// „potwierdzałby się” wersją utworzoną przez pierwszy, zanim backend zdąży
  /// zapisać nową treść.
  int _confirmationFloor = 0;

  /// Odstęp kontroli potwierdzenia i okno, po którym zapis uznajemy za
  /// niepotwierdzony, zamiast pokazywać użytkownikowi fałszywe „zapisano”.
  final Duration confirmationInterval;
  final Duration confirmationTimeout;

  Timer? _confirmationTimer;
  DateTime? _confirmationDeadline;
  bool _confirmationInFlight = false;

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

    final fileName = '$_fileStem.${download.fileType}';
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
          name: '$_fileStem.pdf',
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
  void sessionReady() {
    emit(state.copyWith(isSessionReady: true));
  }

  /// Zapisuje status dokumentu zgłoszony przez OnlyOffice.
  ///
  /// Brak lokalnych zmian to jeszcze nie zapis: callback może lecieć, zostać
  /// odrzucony albo czekać na skanowanie. Dlatego przejście na „bez zmian”
  /// włącza kontrolę potwierdzenia po stronie backendu, a „zapisano” pojawia się
  /// dopiero z nową wersją pliku.
  void documentStateChanged({required bool isModified}) {
    if (isModified) {
      _stopConfirmationWatch();
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
      _resetConfirmationFloor();
      _startConfirmationWatch();
    }
  }

  /// Pilnuje, czy backend potwierdził nową wersję pliku.
  void _startConfirmationWatch() {
    _confirmationTimer?.cancel();
    _confirmationDeadline = DateTime.now().add(confirmationTimeout);
    _confirmationTimer = Timer.periodic(
      confirmationInterval,
      (_) => unawaited(_confirmSavedVersion()),
    );
  }

  void _stopConfirmationWatch() {
    _confirmationTimer?.cancel();
    _confirmationTimer = null;
    _confirmationDeadline = null;
  }

  /// Ustawia próg potwierdzenia dla kolejnego oczekiwania.
  ///
  /// Progiem jest ostatnia wersja znana jako zapisana: potwierdzona w tej sesji
  /// albo ta, na której sesję otwarto. Dzięki temu każdy zapis wymaga własnej,
  /// nowszej wersji z backendu.
  void _resetConfirmationFloor() {
    _confirmationFloor = state.confirmedVersion ?? _baselineVersion;
  }

  /// Pyta o szczegóły pliku i potwierdza zapis tylko wyższą wersją.
  Future<void> _confirmSavedVersion() async {
    if (isClosed || _confirmationInFlight) return;
    if (_confirmationDeadline case final deadline?
        when DateTime.now().isAfter(deadline)) {
      // Późniejszy ręczny Save nadal może utworzyć wersję. Pokazujemy brak
      // potwierdzenia, ale sprawdzamy rzadziej aż do zamknięcia/nowej edycji.
      _confirmationTimer?.cancel();
      _confirmationDeadline = null;
      _confirmationTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => unawaited(_confirmSavedVersion()),
      );
      emit(
        state.copyWith(
          saveConfirmation: StorageOfficeSaveConfirmation.unconfirmed,
        ),
      );
    }

    _confirmationInFlight = true;
    try {
      final result = await _repository.getFileDetails(_file.id);
      if (isClosed) return;
      final version = result.fold(
        (_) => null,
        (details) => details.file.version,
      );
      if (version == null || version <= _confirmationFloor) return;
      _stopConfirmationWatch();
      emit(
        state.copyWith(
          hasSavedChanges: true,
          saveConfirmation: StorageOfficeSaveConfirmation.confirmed,
          confirmedVersion: version,
        ),
      );
    } on Object {
      // Błąd odczytu wersji oznacza brak potwierdzenia, nie udany zapis.
    } finally {
      _confirmationInFlight = false;
    }
  }

  @override
  Future<void> close() async {
    _stopConfirmationWatch();
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
    final targetFileName = _copyFileName(fileType, suggestedTitle);
    final payload = StorageUploadTicketPayload(
      fileName: targetFileName,
      fileSizeBytes: bytes.length,
      mimeType: _guessMimeType(targetFileName),
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

  String get _fileStem {
    final dot = _file.originalFileName.lastIndexOf('.');
    return dot > 0
        ? _file.originalFileName.substring(0, dot)
        : _file.originalFileName;
  }

  String _copyFileName(String fileType, String? suggestedTitle) {
    final cleanFileType = fileType.isNotEmpty
        ? fileType
        : _file.extension.replaceFirst('.', '');
    final title = suggestedTitle?.trim();
    final defaultName = '$_fileStem (kopia).$cleanFileType';
    final candidate = title == null || title.isEmpty ? defaultName : title;
    return candidate.endsWith('.$cleanFileType')
        ? candidate
        : '$candidate.$cleanFileType';
  }

  String _guessMimeType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.docx')) {
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }
    if (lower.endsWith('.xlsx')) {
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }
    if (lower.endsWith('.pptx')) {
      return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    }
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.txt')) return 'text/plain';
    return 'application/octet-stream';
  }

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
