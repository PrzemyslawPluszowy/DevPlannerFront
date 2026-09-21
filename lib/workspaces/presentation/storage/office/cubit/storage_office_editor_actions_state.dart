import 'package:equatable/equatable.dart';

/// Niezmienny stan krótkotrwałych operacji wykonywanych w edytorze OnlyOffice.
final class StorageOfficeEditorActionsState extends Equatable {
  const StorageOfficeEditorActionsState({
    this.isClosing = false,
    this.isDownloading = false,
    this.isPrinting = false,
    this.isSavingCopy = false,
    this.isSessionReady = false,
    this.hasUnsavedChanges = false,
    this.hasSavedChanges = false,
    this.saveConfirmation = StorageOfficeSaveConfirmation.none,
    this.confirmedVersion,
    this.notice,
    this.noticeRevision = 0,
  });

  final bool isClosing;
  final bool isDownloading;
  final bool isPrinting;
  final bool isSavingCopy;

  /// Czy dokument zgłosił gotowość, czyli czy sesja jest połączona.
  final bool isSessionReady;

  /// Czy dokument ma zmiany niepotwierdzone zapisem.
  final bool hasUnsavedChanges;

  /// Czy w tej sesji backend potwierdził nową wersję; po takiej sesji lista
  /// plików musi zostać odświeżona.
  ///
  /// Flaga jest lepka: kolejna edycja nie cofa potrzeby odświeżenia listy.
  final bool hasSavedChanges;

  /// Stan potwierdzenia ostatniego „braku lokalnych zmian”.
  ///
  /// Sam brak zmian w edytorze nie znaczy, że wersja została zapisana: callback
  /// OnlyOffice może jeszcze lecieć, zostać odrzucony albo czekać na skanowanie.
  final StorageOfficeSaveConfirmation saveConfirmation;

  /// Numer wersji potwierdzonej przez backend.
  final int? confirmedVersion;

  final StorageOfficeEditorActionNotice? notice;
  final int noticeRevision;

  StorageOfficeEditorActionsState copyWith({
    bool? isClosing,
    bool? isDownloading,
    bool? isPrinting,
    bool? isSavingCopy,
    bool? isSessionReady,
    bool? hasUnsavedChanges,
    bool? hasSavedChanges,
    StorageOfficeSaveConfirmation? saveConfirmation,
    int? confirmedVersion,
    StorageOfficeEditorActionNotice? notice,
    bool clearNotice = false,
    int? noticeRevision,
  }) => StorageOfficeEditorActionsState(
    isClosing: isClosing ?? this.isClosing,
    isDownloading: isDownloading ?? this.isDownloading,
    isPrinting: isPrinting ?? this.isPrinting,
    isSavingCopy: isSavingCopy ?? this.isSavingCopy,
    isSessionReady: isSessionReady ?? this.isSessionReady,
    hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    hasSavedChanges: hasSavedChanges ?? this.hasSavedChanges,
    saveConfirmation: saveConfirmation ?? this.saveConfirmation,
    confirmedVersion: confirmedVersion ?? this.confirmedVersion,
    notice: clearNotice ? null : notice ?? this.notice,
    noticeRevision: noticeRevision ?? this.noticeRevision,
  );

  @override
  List<Object?> get props => [
    isClosing,
    isDownloading,
    isPrinting,
    isSavingCopy,
    isSessionReady,
    hasUnsavedChanges,
    hasSavedChanges,
    saveConfirmation,
    confirmedVersion,
    notice,
    noticeRevision,
  ];
}

/// Zdarzenie do jednokrotnego pokazania przez prezentację jako komunikat.
sealed class StorageOfficeEditorActionNotice extends Equatable {
  const StorageOfficeEditorActionNotice();
}

/// Sukces akcji zawierający nazwę pliku utworzonego lub pobranego przez użytkownika.
final class StorageOfficeEditorActionSuccess
    extends StorageOfficeEditorActionNotice {
  const StorageOfficeEditorActionSuccess({
    required this.fileName,
    required this.kind,
  });

  final String fileName;
  final StorageOfficeEditorActionSuccessKind kind;

  @override
  List<Object?> get props => [fileName, kind];
}

/// Rozróżnia tekst sukcesu pobrania od tekstu utworzenia kopii w Storage.
enum StorageOfficeEditorActionSuccessKind { download, saveCopy }

/// Błąd pochodzący z repozytorium albo transportu, który UI może pokazać bez utraty treści.
final class StorageOfficeEditorActionFailure
    extends StorageOfficeEditorActionNotice {
  const StorageOfficeEditorActionFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Kod lokalizowanego błędu operacji, którego Cubit nie tłumaczy samodzielnie.
enum StorageOfficeEditorActionFailureCode {
  download,
  print,
  saveCopy,
}

/// Błąd operacji wymagający tekstu ARB po stronie widgetu.
final class StorageOfficeEditorActionLocalizedFailure
    extends StorageOfficeEditorActionNotice {
  const StorageOfficeEditorActionLocalizedFailure({required this.code});

  final StorageOfficeEditorActionFailureCode code;

  @override
  List<Object?> get props => [code];
}

/// Stan potwierdzenia zapisu w edytorze biurowym.
///
/// Rozdział jest istotny, bo edytor mówi tylko o swoich lokalnych zmianach,
/// a wersję pliku potwierdza backend — dopiero on wie, że treść została pobrana,
/// zeskanowana i zapisana.
enum StorageOfficeSaveConfirmation {
  /// Brak sygnału o zapisie w tej sesji.
  none,

  /// Edytor nie ma lokalnych zmian, ale backend nie potwierdził jeszcze wersji.
  awaitingServer,

  /// Backend potwierdził nową wersję pliku.
  confirmed,

  /// Edytor zgłosił brak zmian, a backend nie potwierdził wersji w oknie kontroli.
  unconfirmed,
}
