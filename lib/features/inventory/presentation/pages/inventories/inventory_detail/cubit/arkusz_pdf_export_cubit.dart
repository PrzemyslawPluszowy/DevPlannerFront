import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_detail_pdf_export.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_pdf_save.dart';

/// Rodzaj akcji eksportu PDF dla arkusza.
enum ArkuszPdfExportAction { print, download }

/// Stan eksportu PDF arkusza.
final class ArkuszPdfExportState extends Equatable {
  /// Tworzy stan eksportu PDF.
  const ArkuszPdfExportState({
    this.isProcessing = false,
    this.errorMessage,
    this.lastAction,
    this.progressMessage,
  });

  /// Czy akcja eksportu jest aktualnie wykonywana.
  final bool isProcessing;

  /// Ostatni komunikat błędu.
  final String? errorMessage;

  /// Ostatnio zakończona akcja.
  final ArkuszPdfExportAction? lastAction;

  /// Bieżący etap wykonywanej operacji.
  final String? progressMessage;

  /// Tworzy kopię stanu z nadpisanymi polami.
  ArkuszPdfExportState copyWith({
    bool? isProcessing,
    String? errorMessage,
    bool clearError = false,
    ArkuszPdfExportAction? lastAction,
    bool clearLastAction = false,
    String? progressMessage,
    bool clearProgressMessage = false,
  }) {
    return ArkuszPdfExportState(
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastAction: clearLastAction ? null : (lastAction ?? this.lastAction),
      progressMessage: clearProgressMessage
          ? null
          : (progressMessage ?? this.progressMessage),
    );
  }

  @override
  List<Object?> get props => [
    isProcessing,
    errorMessage,
    lastAction,
    progressMessage,
  ];
}

/// Cubit obsługujący druk i pobieranie PDF arkusza.
class ArkuszPdfExportCubit extends Cubit<ArkuszPdfExportState> {
  /// Tworzy cubit eksportu PDF arkusza.
  ArkuszPdfExportCubit() : super(const ArkuszPdfExportState());

  /// Generuje i otwiera podgląd wydruku PDF.
  Future<void> printPdf({
    required String arkuszNumber,
    required GetArkuszDetailsResponseData data,
    required List<String> selectedResponsiblePeople,
  }) async {
    await _run(
      action: ArkuszPdfExportAction.print,
      arkuszNumber: arkuszNumber,
      data: data,
      selectedResponsiblePeople: selectedResponsiblePeople,
      perform: (bytes, filename) async {
        final useDynamicLayout = defaultTargetPlatform != TargetPlatform.macOS;
        _log(
          ArkuszPdfExportAction.print,
          'layout_pdf_config',
          arkuszNumber: arkuszNumber,
          details: 'dynamicLayout=$useDynamicLayout',
        );
        await Printing.layoutPdf(
          name: filename,
          dynamicLayout: useDynamicLayout,
          onLayout: (_) async => bytes,
        );
        return true;
      },
    );
  }

  /// Generuje i pobiera PDF arkusza.
  Future<void> downloadPdf({
    required String arkuszNumber,
    required GetArkuszDetailsResponseData data,
    required List<String> selectedResponsiblePeople,
  }) async {
    await _run(
      action: ArkuszPdfExportAction.download,
      arkuszNumber: arkuszNumber,
      data: data,
      selectedResponsiblePeople: selectedResponsiblePeople,
      perform: (bytes, filename) => savePdfBytes(
        bytes: bytes,
        filename: filename,
      ),
    );
  }

  Future<void> _run({
    required ArkuszPdfExportAction action,
    required String arkuszNumber,
    required GetArkuszDetailsResponseData data,
    required List<String> selectedResponsiblePeople,
    required Future<bool> Function(Uint8List bytes, String filename) perform,
  }) async {
    if (state.isProcessing) {
      return;
    }

    emit(
      state.copyWith(
        isProcessing: true,
        clearError: true,
        progressMessage: _progressLabel(
          action,
          'Przygotowywanie danych arkusza...',
        ),
      ),
    );
    _log(action, 'start', arkuszNumber: arkuszNumber);

    try {
      emit(
        state.copyWith(
          progressMessage: _progressLabel(
            action,
            'Generowanie dokumentu PDF...',
          ),
        ),
      );
      _log(action, 'build_pdf_start', arkuszNumber: arkuszNumber);
      final bytes = await buildArkuszPdfDocument(
        arkuszNumber: arkuszNumber,
        data: data,
        selectedResponsiblePeople: selectedResponsiblePeople,
      );
      final filename = buildArkuszPdfFilename(arkuszNumber: arkuszNumber);
      _log(
        action,
        'build_pdf_done',
        arkuszNumber: arkuszNumber,
        details: 'bytes=${bytes.length}, filename=$filename',
      );

      emit(
        state.copyWith(
          progressMessage: _progressLabel(
            action,
            action == ArkuszPdfExportAction.print
                ? 'Otwieranie systemowego okna drukowania...'
                : 'Otwieranie systemowego okna zapisu...',
          ),
        ),
      );
      _log(action, 'perform_start', arkuszNumber: arkuszNumber);
      final completed = await perform(bytes, filename);
      _log(
        action,
        completed ? 'perform_done' : 'perform_cancelled',
        arkuszNumber: arkuszNumber,
      );
      if (!completed) {
        emit(
          state.copyWith(
            isProcessing: false,
            clearError: true,
            clearLastAction: true,
            clearProgressMessage: true,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          isProcessing: false,
          clearError: true,
          lastAction: action,
          clearProgressMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      _logError(
        action,
        error,
        stackTrace,
        arkuszNumber: arkuszNumber,
      );
      emit(
        state.copyWith(
          isProcessing: false,
          errorMessage: 'Nie udało się przygotować pliku PDF.',
          clearLastAction: true,
          clearProgressMessage: true,
        ),
      );
    }
  }

  String _progressLabel(ArkuszPdfExportAction action, String message) {
    final actionLabel = switch (action) {
      ArkuszPdfExportAction.print => 'Druk PDF',
      ArkuszPdfExportAction.download => 'Pobieranie PDF',
    };
    return '$actionLabel: $message';
  }

  void _log(
    ArkuszPdfExportAction action,
    String stage, {
    required String arkuszNumber,
    String? details,
  }) {
    final actionLabel = switch (action) {
      ArkuszPdfExportAction.print => 'print',
      ArkuszPdfExportAction.download => 'download',
    };
    final suffix = details == null ? '' : ' | $details';
    debugPrint(
      '[ARKUSZ_PDF][$actionLabel][$stage] arkusz=$arkuszNumber$suffix',
    );
  }

  void _logError(
    ArkuszPdfExportAction action,
    Object error,
    StackTrace stackTrace, {
    required String arkuszNumber,
  }) {
    final actionLabel = switch (action) {
      ArkuszPdfExportAction.print => 'print',
      ArkuszPdfExportAction.download => 'download',
    };
    debugPrint(
      '[ARKUSZ_PDF][$actionLabel][error] arkusz=$arkuszNumber | $error',
    );
    for (final line in stackTrace.toString().trim().split('\n')) {
      debugPrint('[ARKUSZ_PDF][$actionLabel][stack] $line');
    }
  }
}
