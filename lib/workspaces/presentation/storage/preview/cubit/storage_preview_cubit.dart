import 'package:devplanner/foundation/config/app_api_module.dart';
import 'package:devplanner/foundation/config/app_env.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit przygotowujący bezpieczny podgląd pliku (obraz, PDF, wideo, audio, tekst, OnlyOffice).
final class StoragePreviewCubit extends Cubit<StoragePreviewState> {
  /// Tworzy instancję cubita podglądu.
  StoragePreviewCubit({required this.repository})
    : super(const StoragePreviewInitial());

  final StorageRepository repository;

  /// Pobiera bilet pobrania i przygotowuje podgląd pliku.
  Future<void> preparePreview(StorageFileResponse file) async {
    emit(StoragePreviewLoading(file: file));

    final kind = resolveKind(file);

    final ticketResult = await repository.getDownloadTicket(file.id);
    if (isClosed) return;

    ticketResult.fold(
      (err) => emit(
        StoragePreviewFailure(
          file: file,
          message: err.message,
        ),
      ),
      (ticket) {
        final rawUrl = ticket.previewUrl ?? ticket.downloadUrl;
        final authenticated = Uri.tryParse(rawUrl)?.hasScheme != true;
        final previewUrl = authenticated
            ? Uri.parse(AppEnv.apiBaseUrlFor(AppApiModule.workspaces))
                  .resolve(rawUrl)
                  .toString()
            : rawUrl;
        emit(
          StoragePreviewReady(
            file: file,
            kind: kind,
            // Backend rozdziela URL z Content-Disposition: attachment od URL-u
            // inline. Starsze backendy nie zwracają previewUrl, więc zachowujemy
            // kompatybilny fallback do dotychczasowego biletu.
            previewUrl: previewUrl,
          ),
        );
      },
    );
  }

  /// Rozpoznaje renderer na podstawie MIME oraz rozszerzenia pliku.
  ///
  /// Rozszerzenie jest fallbackiem, ponieważ część istniejących rekordów ma
  /// MIME `application/octet-stream` mimo poprawnego formatu pliku.
  static StoragePreviewKind resolveKind(StorageFileResponse file) {
    if (!file.canPreview) return StoragePreviewKind.unsupported;

    final mime = file.mimeType.split(';').first.trim().toLowerCase();
    final ext = file.extension.toLowerCase().replaceFirst('.', '');

    if (mime.startsWith('image/') ||
        ['png', 'jpg', 'jpeg', 'webp', 'gif', 'svg'].contains(ext)) {
      return StoragePreviewKind.image;
    }
    if (mime == 'application/pdf' || ext == 'pdf') {
      return StoragePreviewKind.pdf;
    }
    if (mime.startsWith('video/') ||
        ['mp4', 'webm', 'mov', 'm4v'].contains(ext)) {
      return StoragePreviewKind.video;
    }
    if (mime.startsWith('audio/') ||
        ['mp3', 'wav', 'ogg', 'm4a', 'aac', 'flac'].contains(ext)) {
      return StoragePreviewKind.audio;
    }
    if (file.canEditOnline ||
        [
          'docx',
          'xlsx',
          'pptx',
          'doc',
          'xls',
          'ppt',
          'odt',
          'ods',
          'odp',
        ].contains(ext)) {
      return StoragePreviewKind.office;
    }
    if (mime.startsWith('text/') ||
        ['txt', 'md', 'json', 'xml', 'csv', 'dart', 'yaml'].contains(ext)) {
      return StoragePreviewKind.text;
    }

    return StoragePreviewKind.unsupported;
  }
}
