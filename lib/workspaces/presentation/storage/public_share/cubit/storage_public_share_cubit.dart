import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/public_share/cubit/storage_public_share_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Owns the anonymous public-share exchange and platform download lifecycle.
final class StoragePublicShareCubit extends Cubit<StoragePublicShareState> {
  StoragePublicShareCubit({
    required this.shareToken,
    required this.repository,
    required this.downloadTransport,
  }) : super(const StoragePublicShareInitial());

  final String shareToken;
  final StorageRepository repository;
  final DownloadTransport downloadTransport;

  Future<void> download({String? password}) async {
    if (state is StoragePublicShareLoading) return;
    emit(const StoragePublicShareLoading());
    final normalizedPassword = password?.trim();
    final ticketResult = await repository.getPublicShareDownloadTicket(
      shareToken: shareToken,
      password: normalizedPassword == null || normalizedPassword.isEmpty
          ? null
          : normalizedPassword,
    );
    if (isClosed) return;

    await ticketResult.fold(
      (error) async => emit(
        StoragePublicShareFailure(
          message: error.message,
          code: error.backendCode?.toString(),
        ),
      ),
      (ticket) async {
        final result = await downloadTransport.downloadUrl(
          downloadUrl: ticket.downloadUrl,
          fileName: ticket.originalFileName,
        );
        if (isClosed) return;
        result.fold(
          (error) => emit(
            StoragePublicShareFailure(
              message: error.message,
              code: error.backendCode?.toString(),
            ),
          ),
          (_) => emit(StoragePublicShareSuccess(ticket.originalFileName)),
        );
      },
    );
  }
}
