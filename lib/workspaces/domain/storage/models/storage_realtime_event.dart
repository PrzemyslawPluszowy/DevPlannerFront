import 'package:equatable/equatable.dart';

/// Typ zdarzenia kanału zmian plików.
///
/// Nazwy odpowiadają kontraktowi huba Storage. [resyncRequired] jest zdarzeniem
/// lokalnym klienta: luka w historii nie jest zdarzeniem serwera, tylko sygnałem,
/// że kursor klienta rozjechał się z historią i lista wymaga pełnego odświeżenia.
enum StorageRealtimeEventType {
  fileCreated('storage.file.created'),
  fileUpdated('storage.file.updated'),
  fileMoved('storage.file.moved'),
  fileDeleted('storage.file.deleted'),
  fileRestored('storage.file.restored'),
  shareChanged('storage.share.changed'),
  versionCreated('storage.file.version.created'),
  resyncRequired('storage.resync.required');

  const StorageRealtimeEventType(this.method);

  /// Nazwa zdarzenia w hubie; dla [resyncRequired] nazwa lokalna.
  final String method;

  /// Rozpoznaje typ po nazwie zdarzenia; nieznane typy są pomijane.
  static StorageRealtimeEventType? fromMethod(String method) {
    final normalized = method.trim().toLowerCase();
    for (final type in values) {
      if (type.method == normalized) return type;
    }
    return null;
  }
}

/// Typowana zmiana w module Pliki.
///
/// Koperta nie niesie treści pliku ani adresu, więc sygnał nie może pokazać
/// niczego, czego nie widzi lista: po zdarzeniu klient odświeża widoczny zakres
/// jednym żądaniem listy.
final class StorageRealtimeEvent extends Equatable {
  const StorageRealtimeEvent({
    required this.type,
    this.eventId,
    this.cursor,
    this.fileId,
    this.folderId,
    this.fileVersion,
    this.actorUserId,
    this.occurredAtUtc,
    this.isReplay = false,
  });

  /// Rodzaj zmiany.
  final StorageRealtimeEventType type;

  /// Klucz deduplikacji nadany przez serwer.
  final String? eventId;

  /// Kursor zdarzenia przekazywany do odtworzenia historii.
  final String? cursor;

  /// Plik, którego dotyczy zmiana.
  final String? fileId;

  /// Folder, którego dotyczy zmiana lub placement.
  final String? folderId;

  /// Numer wersji pliku po zmianie.
  final int? fileVersion;

  /// Autor zmiany.
  final String? actorUserId;

  /// Czas zmiany w UTC.
  final DateTime? occurredAtUtc;

  /// Prawda, gdy zdarzenie pochodzi z odtworzenia historii po ponownym połączeniu.
  final bool isReplay;

  /// Czy zdarzenie wymaga pełnego odświeżenia zamiast odświeżenia w miejscu.
  bool get requiresFullRefresh =>
      type == StorageRealtimeEventType.resyncRequired;

  @override
  List<Object?> get props => [
    type,
    eventId,
    cursor,
    fileId,
    folderId,
    fileVersion,
    actorUserId,
    occurredAtUtc,
    isReplay,
  ];
}
