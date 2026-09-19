import 'package:equatable/equatable.dart';

/// Niezmienny stan krótkotrwałych operacji wykonywanych w edytorze OnlyOffice.
final class StorageOfficeEditorActionsState extends Equatable {
  const StorageOfficeEditorActionsState({
    this.isClosing = false,
    this.isDownloading = false,
    this.isPrinting = false,
    this.isSavingCopy = false,
    this.notice,
    this.noticeRevision = 0,
  });

  final bool isClosing;
  final bool isDownloading;
  final bool isPrinting;
  final bool isSavingCopy;
  final StorageOfficeEditorActionNotice? notice;
  final int noticeRevision;

  StorageOfficeEditorActionsState copyWith({
    bool? isClosing,
    bool? isDownloading,
    bool? isPrinting,
    bool? isSavingCopy,
    StorageOfficeEditorActionNotice? notice,
    bool clearNotice = false,
    int? noticeRevision,
  }) => StorageOfficeEditorActionsState(
    isClosing: isClosing ?? this.isClosing,
    isDownloading: isDownloading ?? this.isDownloading,
    isPrinting: isPrinting ?? this.isPrinting,
    isSavingCopy: isSavingCopy ?? this.isSavingCopy,
    notice: clearNotice ? null : notice ?? this.notice,
    noticeRevision: noticeRevision ?? this.noticeRevision,
  );

  @override
  List<Object?> get props => [
    isClosing,
    isDownloading,
    isPrinting,
    isSavingCopy,
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
