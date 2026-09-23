import 'dart:typed_data';

import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:equatable/equatable.dart';

/// Rozpoznany typ podglądu pliku w UI.
enum StoragePreviewKind {
  /// Obraz graficzny (PNG, JPEG, WebP, GIF, SVG).
  image,

  /// Dokument PDF.
  pdf,

  /// Plik wideo (MP4, WebM).
  video,

  /// Plik audio (MP3, WAV, OGG).
  audio,

  /// Plik tekstowy / kod źródłowy / Markdown.
  text,

  /// Dokument pakietu biurowego (DOCX, XLSX, PPTX) zdatny do sesji OnlyOffice.
  office,

  /// Nieobsługiwany format do bezpośredniego podglądu w aplikacji.
  unsupported,
}

/// Bazowy stan podglądu pliku.
sealed class StoragePreviewState extends Equatable {
  /// Tworzy bazowy stan podglądu.
  const StoragePreviewState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy.
class StoragePreviewInitial extends StoragePreviewState {
  /// Tworzy stan początkowy.
  const StoragePreviewInitial();
}

/// Stan ładowania biletu podglądu / strumienia.
class StoragePreviewLoading extends StoragePreviewState {
  /// Tworzy stan ładowania podglądu.
  const StoragePreviewLoading({required this.file});

  /// Plik, dla którego przygotowywany jest podgląd.
  final StorageFileResponse file;

  @override
  List<Object?> get props => [file];
}

/// Stan gotowości podglądu ze zweryfikowanym źródłem danych.
class StoragePreviewReady extends StoragePreviewState {
  /// Tworzy stan gotowości podglądu.
  const StoragePreviewReady({
    required this.file,
    required this.kind,
    required this.previewUrl,
    this.imageBytes,
    this.officeSessionUrl,
    this.previewHeaders = const {},
    this.version,
  });

  /// Metadane pliku.
  final StorageFileResponse file;

  /// Typ podglądu.
  final StoragePreviewKind kind;

  /// Bezpieczny URL pobrania/strumienia z biletu.
  final String previewUrl;

  /// Bajty obrazu pobrane przez uwierzytelniony klient API.
  final Uint8List? imageBytes;

  /// Opcjonalny URL sesji OnlyOffice dla dokumentów biurowych.
  final String? officeSessionUrl;

  /// Headers required by an authenticated backend stream (never logged).
  final Map<String, String> previewHeaders;

  /// Numer wersji historycznej albo `null` dla bieżącej wersji pliku.
  ///
  /// Tryb historyczny jest tylko do odczytu: podgląd nie może podmienić
  /// bieżącego pliku ani otworzyć edytora na starej treści.
  final int? version;

  /// Czy podgląd pokazuje wersję historyczną.
  bool get isHistoricalVersion => version != null;

  @override
  List<Object?> get props => [
    file,
    kind,
    previewUrl,
    imageBytes,
    officeSessionUrl,
    version,
  ];
}

/// Stan błędu przygotowania podglądu.
class StoragePreviewFailure extends StoragePreviewState {
  /// Tworzy stan błędu.
  const StoragePreviewFailure({
    required this.file,
    required this.message,
  });

  /// Plik, dla którego nie udało się przygotować podglądu.
  final StorageFileResponse file;

  /// Komunikat błędu.
  final String message;

  @override
  List<Object?> get props => [file, message];
}
