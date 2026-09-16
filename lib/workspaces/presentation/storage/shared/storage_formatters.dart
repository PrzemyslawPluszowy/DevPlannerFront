import 'package:flutter/material.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_browser_filter.dart';

/// Bezstanowa klasa pomocnicza formatowania rozmiaru plików i dobierania ikon typów plików.
abstract final class StorageFormatters {
  /// Formatuje rozmiar pliku w bajtach do czytelnego ciągu tekstowego.
  static String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Zwraca odpowiednią ikonę dla wskazanego rozszerzenia lub typu MIME.
  static IconData iconForFile({String? mimeType, String? extension}) {
    final ext = (extension ?? '').toLowerCase().replaceAll('.', '');
    final mime = (mimeType ?? '').toLowerCase();

    if (mime.startsWith('image/') ||
        {'png', 'jpg', 'jpeg', 'gif', 'svg', 'webp'}.contains(ext)) {
      return AppIcons.image;
    }
    if (mime == 'application/pdf' || ext == 'pdf') {
      return AppIcons.document;
    }
    if (mime.startsWith('video/') ||
        {'mp4', 'mov', 'avi', 'mkv', 'webm'}.contains(ext)) {
      return AppIcons.video;
    }
    if (mime.startsWith('audio/') ||
        {'mp3', 'wav', 'ogg', 'm4a', 'flac'}.contains(ext)) {
      return AppIcons.volume;
    }
    if ({'doc', 'docx', 'odt', 'rtf', 'txt', 'md'}.contains(ext) ||
        mime.contains('word') ||
        mime.contains('text')) {
      return AppIcons.documentText;
    }
    if ({'xls', 'xlsx', 'ods', 'csv'}.contains(ext) ||
        mime.contains('sheet') ||
        mime.contains('excel')) {
      return AppIcons.table;
    }
    if ({'ppt', 'pptx', 'odp'}.contains(ext) || mime.contains('presentation')) {
      return AppIcons.presentation;
    }
    if ({'zip', 'tar', 'gz', '7z', 'rar'}.contains(ext) ||
        mime.contains('zip') ||
        mime.contains('compressed')) {
      return AppIcons.archive;
    }
    if ({
      'dart',
      'js',
      'ts',
      'html',
      'css',
      'json',
      'py',
      'cs',
      'java',
    }.contains(ext)) {
      return AppIcons.code;
    }

    return AppIcons.file;
  }

  /// Sortuje listę folderów według zadanego kryterium.
  static List<StorageFolderResponse> sortFolders(
    List<StorageFolderResponse> folders,
    StorageSortCriteria sort,
  ) {
    final list = [...folders];
    list.sort((a, b) {
      final cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return sort.isAscending ? cmp : -cmp;
    });
    return list;
  }

  /// Sortuje listę plików według zadanego kryterium.
  static List<StorageFileResponse> sortFiles(
    List<StorageFileResponse> files,
    StorageSortCriteria sort,
  ) {
    final list = [...files];
    list.sort((a, b) {
      final int cmp;
      switch (sort.field) {
        case StorageSortField.name:
          cmp = a.originalFileName.toLowerCase().compareTo(
            b.originalFileName.toLowerCase(),
          );
        case StorageSortField.size:
          cmp = a.fileSizeBytes.compareTo(b.fileSizeBytes);
        case StorageSortField.updatedAt:
          cmp = a.updatedAtUtc.compareTo(b.updatedAtUtc);
      }
      return sort.isAscending ? cmp : -cmp;
    });
    return list;
  }

  /// Sprawdza czy plik jest dokumentem biurowym wspieranym przez edytor OnlyOffice.
  static bool isOfficeDocument({String? mimeType, String? extension}) {
    final ext = (extension ?? '').toLowerCase().replaceAll('.', '');
    return {
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'odt',
      'ods',
      'odp',
    }.contains(ext);
  }
}
