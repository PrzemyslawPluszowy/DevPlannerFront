import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_pdf_save.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_definition.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_pdf_export.dart';

/// Rodzaj akcji eksportu pełnego pakietu raportów.
enum InventoryReportBundlePdfExportAction { print, download }

/// Etap postępu eksportu pełnego pakietu raportów.
enum InventoryReportBundlePdfExportProgress {
  fetchBundleData,
  buildDocument,
  openPrintDialog,
  saveFile,
  fetchSingleReport,
}

/// Typ błędu eksportu pełnego pakietu raportów.
enum InventoryReportBundlePdfExportErrorType { api, generic }

/// Stan eksportu pełnego pakietu raportów.
final class InventoryReportBundlePdfExportState extends Equatable {
  /// Tworzy stan eksportu pełnego pakietu raportów.
  const InventoryReportBundlePdfExportState({
    this.isProcessing = false,
    this.errorType,
    this.apiError,
    this.progress,
  });

  /// Czy eksport jest aktualnie wykonywany.
  final bool isProcessing;

  /// Typ błędu eksportu.
  final InventoryReportBundlePdfExportErrorType? errorType;

  /// Błąd odpowiedzi API, jeśli wystąpił.
  final ApiError? apiError;

  /// Aktualny etap postępu.
  final InventoryReportBundlePdfExportProgress? progress;

  /// Tworzy kopię stanu z nadpisanymi wartościami.
  InventoryReportBundlePdfExportState copyWith({
    bool? isProcessing,
    InventoryReportBundlePdfExportErrorType? errorType,
    bool clearErrorType = false,
    ApiError? apiError,
    bool clearApiError = false,
    InventoryReportBundlePdfExportProgress? progress,
    bool clearProgress = false,
  }) {
    return InventoryReportBundlePdfExportState(
      isProcessing: isProcessing ?? this.isProcessing,
      errorType: clearErrorType ? null : (errorType ?? this.errorType),
      apiError: clearApiError ? null : (apiError ?? this.apiError),
      progress: clearProgress ? null : (progress ?? this.progress),
    );
  }

  @override
  List<Object?> get props => [isProcessing, errorType, apiError, progress];
}

/// Cubit obsługujący eksport pełnego pakietu raportów inwentaryzacji.
class InventoryReportBundlePdfExportCubit
    extends Cubit<InventoryReportBundlePdfExportState> {
  /// Tworzy cubit eksportu pełnego pakietu raportów.
  InventoryReportBundlePdfExportCubit({
    required this._repository,
  }) : super(const InventoryReportBundlePdfExportState());

  final InventoriesRepository _repository;

  /// Drukuje pełny pakiet raportów jako jeden dokument.
  Future<void> printPdf({
    required int inventoryId,
    required String inventoryNumber,
    required GetInwentaryzacjaDetailsResponseData inventoryDetails,
    required bool showUwagi,
  }) async {
    await _run(
      action: InventoryReportBundlePdfExportAction.print,
      inventoryId: inventoryId,
      inventoryNumber: inventoryNumber,
      inventoryDetails: inventoryDetails,
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

  /// Pobiera pełny pakiet raportów jako jeden dokument.
  Future<void> downloadPdf({
    required int inventoryId,
    required String inventoryNumber,
    required GetInwentaryzacjaDetailsResponseData inventoryDetails,
    required bool showUwagi,
  }) async {
    await _run(
      action: InventoryReportBundlePdfExportAction.download,
      inventoryId: inventoryId,
      inventoryNumber: inventoryNumber,
      inventoryDetails: inventoryDetails,
      showUwagi: showUwagi,
      perform: (bytes, filename) =>
          savePdfBytes(bytes: bytes, filename: filename),
    );
  }

  /// Pobiera sekcje potrzebne do zbudowania scalonego pakietu raportów.
  Future<List<InventoryReportBundleSection>> fetchBundleSections(
    int inventoryId,
  ) async {
    final sections = <InventoryReportBundleSection>[];
    for (final definition in InventoryReportDefinitions.fullBundle) {
      final result = await _repository.fetchInventoryReport(
        inventoryId: inventoryId,
        query: const GetInwentaryzacjaReportQuery(
          reportType: InwentaryzacjaReportType.ogolnyStanSpisu,
          includeSummary: false,
          sortBy: GetInwentaryzacjaReportSortBy.nrewid,
          sortDir: GetInwentaryzacjaReportSortDirection.asc,
        ).copyWithReportType(definition.type),
      );

      final data = result.fold<GetInwentaryzacjaReportResponseData>(
        (error) => throw _BundleExportException(error),
        (data) => data,
      );

      sections.add(
        InventoryReportBundleSection(definition: definition, reportData: data),
      );
    }
    return sections;
  }

  Future<void> _run({
    required InventoryReportBundlePdfExportAction action,
    required int inventoryId,
    required String inventoryNumber,
    required GetInwentaryzacjaDetailsResponseData inventoryDetails,
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
        clearApiError: true,
        progress: InventoryReportBundlePdfExportProgress.fetchBundleData,
      ),
    );

    try {
      final sections = await _fetchBundleSectionsWithProgress(
        inventoryId: inventoryId,
        action: action,
      );

      emit(
        state.copyWith(
          progress: InventoryReportBundlePdfExportProgress.buildDocument,
        ),
      );

      final bytes = await buildInventoryReportBundlePdfDocument(
        inventoryNumber: inventoryNumber,
        inventoryDetails: inventoryDetails,
        sections: sections,
        showUwagi: showUwagi,
      );
      final filename = buildInventoryReportBundlePdfFilename(
        inventoryNumber: inventoryNumber,
      );

      emit(
        state.copyWith(
          progress: action == InventoryReportBundlePdfExportAction.print
              ? InventoryReportBundlePdfExportProgress.openPrintDialog
              : InventoryReportBundlePdfExportProgress.saveFile,
        ),
      );

      final completed = await perform(bytes, filename);
      emit(
        state.copyWith(
          isProcessing: false,
          clearErrorType: true,
          clearApiError: true,
          clearProgress: true,
        ),
      );
      if (!completed) {
        return;
      }
    } on _BundleExportException catch (error) {
      emit(
        state.copyWith(
          isProcessing: false,
          errorType: InventoryReportBundlePdfExportErrorType.api,
          apiError: error.apiError,
          clearProgress: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isProcessing: false,
          errorType: InventoryReportBundlePdfExportErrorType.generic,
          clearApiError: true,
          clearProgress: true,
        ),
      );
    }
  }

  Future<List<InventoryReportBundleSection>> _fetchBundleSectionsWithProgress({
    required int inventoryId,
    required InventoryReportBundlePdfExportAction action,
  }) async {
    final sections = <InventoryReportBundleSection>[];
    for (final definition in InventoryReportDefinitions.fullBundle) {
      emit(
        state.copyWith(
          progress: InventoryReportBundlePdfExportProgress.fetchSingleReport,
        ),
      );

      final result = await _repository.fetchInventoryReport(
        inventoryId: inventoryId,
        query: const GetInwentaryzacjaReportQuery(
          reportType: InwentaryzacjaReportType.ogolnyStanSpisu,
          includeSummary: false,
          sortBy: GetInwentaryzacjaReportSortBy.nrewid,
          sortDir: GetInwentaryzacjaReportSortDirection.asc,
        ).copyWithReportType(definition.type),
      );

      final data = result.fold<GetInwentaryzacjaReportResponseData>(
        (error) => throw _BundleExportException(error),
        (data) => data,
      );

      sections.add(
        InventoryReportBundleSection(definition: definition, reportData: data),
      );
    }
    return sections;
  }
}

/// Błąd eksportu pakietu raportów opakowujący odpowiedź repozytorium.
final class _BundleExportException implements Exception {
  /// Tworzy wyjątek eksportu pakietu.
  const _BundleExportException(this.apiError);

  /// Oryginalny błąd API.
  final ApiError apiError;
}

extension on GetInwentaryzacjaReportQuery {
  GetInwentaryzacjaReportQuery copyWithReportType(
    InwentaryzacjaReportType reportType,
  ) {
    return GetInwentaryzacjaReportQuery(
      reportType: reportType,
      includeSummary: includeSummary,
      sortBy: sortBy,
      sortDir: sortDir,
    );
  }
}
