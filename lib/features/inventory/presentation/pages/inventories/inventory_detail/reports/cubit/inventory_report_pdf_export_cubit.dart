import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_pdf_save.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_definition.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_pdf_export.dart';

/// Rodzaj akcji eksportu PDF dla raportu.
enum InventoryReportPdfExportAction { print, download }

/// Etap postępu eksportu PDF raportu.
enum InventoryReportPdfExportProgress {
  buildDocument,
  openPrintDialog,
  saveFile,
}

/// Typ błędu eksportu PDF raportu.
enum InventoryReportPdfExportErrorType { generic }

/// Stan eksportu PDF raportu.
final class InventoryReportPdfExportState extends Equatable {
  /// Tworzy stan eksportu PDF raportu.
  const InventoryReportPdfExportState({
    this.isProcessing = false,
    this.errorType,
    this.progress,
  });

  /// Czy eksport jest aktualnie wykonywany.
  final bool isProcessing;

  /// Typ błędu eksportu.
  final InventoryReportPdfExportErrorType? errorType;

  /// Aktualny etap postępu.
  final InventoryReportPdfExportProgress? progress;

  /// Tworzy kopię stanu z nadpisanymi wartościami.
  InventoryReportPdfExportState copyWith({
    bool? isProcessing,
    InventoryReportPdfExportErrorType? errorType,
    bool clearErrorType = false,
    InventoryReportPdfExportProgress? progress,
    bool clearProgress = false,
  }) {
    return InventoryReportPdfExportState(
      isProcessing: isProcessing ?? this.isProcessing,
      errorType: clearErrorType ? null : (errorType ?? this.errorType),
      progress: clearProgress ? null : (progress ?? this.progress),
    );
  }

  @override
  List<Object?> get props => [isProcessing, errorType, progress];
}

/// Cubit obsługujący eksport PDF raportów inwentaryzacji.
class InventoryReportPdfExportCubit
    extends Cubit<InventoryReportPdfExportState> {
  /// Tworzy cubit eksportu PDF raportu.
  InventoryReportPdfExportCubit()
    : super(const InventoryReportPdfExportState());

  /// Drukuje raport PDF.
  Future<void> printPdf({
    required InventoryReportDefinition definition,
    required String inventoryNumber,
    required GetInwentaryzacjaDetailsResponseData inventoryDetails,
    required GetInwentaryzacjaReportResponseData reportData,
    required bool showUwagi,
    InventoryReportPdfDocumentKind documentKind =
        InventoryReportPdfDocumentKind.report,
  }) async {
    await _run(
      action: InventoryReportPdfExportAction.print,
      documentKind: documentKind,
      definition: definition,
      inventoryNumber: inventoryNumber,
      inventoryDetails: inventoryDetails,
      reportData: reportData,
      showUwagi: showUwagi,
      perform: (bytes, filename) async {
        await Printing.layoutPdf(
          name: filename,
          format: PdfPageFormat.a4.landscape,
          dynamicLayout: false,
          onLayout: (_) async => bytes,
        );
        return true;
      },
    );
  }

  /// Pobiera raport PDF.
  Future<void> downloadPdf({
    required InventoryReportDefinition definition,
    required String inventoryNumber,
    required GetInwentaryzacjaDetailsResponseData inventoryDetails,
    required GetInwentaryzacjaReportResponseData reportData,
    required bool showUwagi,
    InventoryReportPdfDocumentKind documentKind =
        InventoryReportPdfDocumentKind.report,
  }) async {
    await _run(
      action: InventoryReportPdfExportAction.download,
      documentKind: documentKind,
      definition: definition,
      inventoryNumber: inventoryNumber,
      inventoryDetails: inventoryDetails,
      reportData: reportData,
      showUwagi: showUwagi,
      perform: (bytes, filename) =>
          savePdfBytes(bytes: bytes, filename: filename),
    );
  }

  Future<void> _run({
    required InventoryReportPdfExportAction action,
    required InventoryReportPdfDocumentKind documentKind,
    required InventoryReportDefinition definition,
    required String inventoryNumber,
    required GetInwentaryzacjaDetailsResponseData inventoryDetails,
    required GetInwentaryzacjaReportResponseData reportData,
    required bool showUwagi,
    required Future<bool> Function(Uint8List bytes, String filename) perform,
  }) async {
    if (state.isProcessing) {
      return;
    }

    emit(
      state.copyWith(
        isProcessing: true,
        clearErrorType: true,
        progress: InventoryReportPdfExportProgress.buildDocument,
      ),
    );

    try {
      final bytes = await buildInventoryReportPdfDocument(
        definition: definition,
        inventoryNumber: inventoryNumber,
        inventoryDetails: inventoryDetails,
        reportData: reportData,
        showUwagi: showUwagi,
        documentKind: documentKind,
      );
      final filename = buildInventoryReportPdfFilename(
        definition: definition,
        inventoryNumber: inventoryNumber,
        documentKind: documentKind,
      );
      emit(
        state.copyWith(
          progress: action == InventoryReportPdfExportAction.print
              ? InventoryReportPdfExportProgress.openPrintDialog
              : InventoryReportPdfExportProgress.saveFile,
        ),
      );
      final completed = await perform(bytes, filename);
      emit(
        state.copyWith(
          isProcessing: false,
          clearErrorType: true,
          clearProgress: true,
        ),
      );
      if (!completed) {
        return;
      }
    } catch (_) {
      emit(
        state.copyWith(
          isProcessing: false,
          errorType: InventoryReportPdfExportErrorType.generic,
          clearProgress: true,
        ),
      );
    }
  }
}
