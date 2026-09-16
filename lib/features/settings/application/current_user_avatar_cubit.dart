import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/services/task_attachment_upload_transport.dart';

/// Stan prywatnego avatara użytkownika przechowywanego przez Storage Workspaces.
sealed class CurrentUserAvatarState {
  const CurrentUserAvatarState();
}

/// Avatar nie został jeszcze odczytany.
final class CurrentUserAvatarInitial extends CurrentUserAvatarState {
  const CurrentUserAvatarInitial();
}

/// Trwa odczyt albo zapis avatara.
final class CurrentUserAvatarLoading extends CurrentUserAvatarState {
  const CurrentUserAvatarLoading({this.previousAvatarUrl});

  final String? previousAvatarUrl;
}

/// Gotowy stan avatara; null oznacza użycie inicjałów jako fallbacku.
final class CurrentUserAvatarReady extends CurrentUserAvatarState {
  const CurrentUserAvatarReady({this.avatarUrl});

  final String? avatarUrl;
}

/// Błąd operacji z zachowaniem ostatniego poprawnego podglądu.
final class CurrentUserAvatarFailure extends CurrentUserAvatarState {
  const CurrentUserAvatarFailure({
    required this.error,
    this.previousAvatarUrl,
  });

  final ApiError error;
  final String? previousAvatarUrl;
}

/// Orkiestruje bezpieczny cykl uploadu, podglądu i usunięcia avatara użytkownika.
final class CurrentUserAvatarCubit extends Cubit<CurrentUserAvatarState> {
  /// Tworzy lokalny Cubit ustawień profilu.
  CurrentUserAvatarCubit({
    required StorageRepository storageRepository,
    required TaskAttachmentUploadTransport uploadTransport,
  }) : this._(storageRepository, uploadTransport);

  CurrentUserAvatarCubit._(this._storageRepository, this._uploadTransport)
    : super(const CurrentUserAvatarInitial());

  final StorageRepository _storageRepository;
  final TaskAttachmentUploadTransport _uploadTransport;

  String? get _currentAvatarUrl => switch (state) {
    CurrentUserAvatarLoading(:final previousAvatarUrl) => previousAvatarUrl,
    CurrentUserAvatarReady(:final avatarUrl) => avatarUrl,
    CurrentUserAvatarFailure(:final previousAvatarUrl) => previousAvatarUrl,
    CurrentUserAvatarInitial() => null,
  };

  /// Odczytuje avatar i jego krótkotrwały URL pobrania.
  Future<void> load() async {
    if (isClosed) return;
    final previousAvatarUrl = _currentAvatarUrl;
    emit(CurrentUserAvatarLoading(previousAvatarUrl: previousAvatarUrl));
    final avatarResult = await _storageRepository.getCurrentUserAvatar();
    await avatarResult.fold(
      (error) async {
        if (isClosed) return;
        if (error.type == ApiErrorType.notFound) {
          emit(const CurrentUserAvatarReady());
          return;
        }
        emit(
          CurrentUserAvatarFailure(
            error: error,
            previousAvatarUrl: previousAvatarUrl,
          ),
        );
      },
      (avatar) async {
        final ticketResult = await _storageRepository.getDownloadTicket(
          avatar.id,
        );
        ticketResult.fold(
          (error) {
            if (!isClosed) {
              emit(
                CurrentUserAvatarFailure(
                  error: error,
                  previousAvatarUrl: previousAvatarUrl,
                ),
              );
            }
          },
          (ticket) {
            if (!isClosed) {
              emit(CurrentUserAvatarReady(avatarUrl: ticket.downloadUrl));
            }
          },
        );
      },
    );
  }

  /// Czyści obraz poprzedniej sesji przed zalogowaniem innego użytkownika.
  ///
  /// Adres pobrania jest krótkotrwały, ale stan Cubita żyje przez cały czas
  /// działania aplikacji. Bez wyczyszczenia mógłby być przez chwilę widoczny
  /// avatar poprzednio zalogowanej osoby.
  void clear() {
    if (!isClosed) {
      emit(const CurrentUserAvatarInitial());
    }
  }

  /// Wysyła wybrany obraz i przypisuje go jako aktualny avatar.
  Future<void> upload({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    if (isClosed) return;
    final previousAvatarUrl = _currentAvatarUrl;
    emit(CurrentUserAvatarLoading(previousAvatarUrl: previousAvatarUrl));
    final ticket = await _storageRepository
        .requestAvatarUploadTicket(
          StorageUploadTicketItemPayload(
            fileName: fileName,
            fileSizeBytes: bytes.length,
            mimeType: mimeType,
          ),
        )
        .then(
          (result) => result.fold((error) {
            _emitFailure(error, previousAvatarUrl);
            return null;
          }, (value) => value),
        );
    if (ticket == null || isClosed) return;

    final uploadResult = await _uploadTransport.upload(
      ticket: ticket,
      bytes: bytes,
      mimeType: mimeType,
    );
    final uploaded = uploadResult.fold((error) {
      _emitFailure(error, previousAvatarUrl);
      return false;
    }, (_) => true);
    if (!uploaded || isClosed) return;

    final completed = await _storageRepository
        .completeUpload(
          fileId: ticket.fileId,
          fileSizeBytes: bytes.length,
        )
        .then(
          (result) => result.fold((error) {
            _emitFailure(error, previousAvatarUrl);
            return null;
          }, (value) => value),
        );
    if (completed == null || isClosed) return;

    final avatar = await _storageRepository
        .setCurrentUserAvatar(completed.id)
        .then(
          (result) => result.fold((error) {
            _emitFailure(error, previousAvatarUrl);
            return null;
          }, (value) => value),
        );
    if (avatar == null || isClosed) return;

    final imageTicket = await _storageRepository
        .getDownloadTicket(avatar.id)
        .then(
          (result) => result.fold((error) {
            _emitFailure(error, previousAvatarUrl);
            return null;
          }, (value) => value),
        );
    if (imageTicket == null || isClosed) return;
    emit(CurrentUserAvatarReady(avatarUrl: imageTicket.downloadUrl));
  }

  /// Usuwa avatar i natychmiast przywraca fallback do inicjałów.
  Future<void> remove() async {
    if (isClosed) return;
    final previousAvatarUrl = _currentAvatarUrl;
    emit(CurrentUserAvatarLoading(previousAvatarUrl: previousAvatarUrl));
    final result = await _storageRepository.deleteCurrentUserAvatar();
    result.fold(
      (error) => _emitFailure(error, previousAvatarUrl),
      (_) {
        if (!isClosed) emit(const CurrentUserAvatarReady());
      },
    );
  }

  void _emitFailure(ApiError error, String? previousAvatarUrl) {
    if (!isClosed) {
      emit(
        CurrentUserAvatarFailure(
          error: error,
          previousAvatarUrl: previousAvatarUrl,
        ),
      );
    }
  }
}
