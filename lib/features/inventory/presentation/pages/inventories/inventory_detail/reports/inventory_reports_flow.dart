import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/cubit/inventory_report_bundle_pdf_export_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_definition.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_pdf_export.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_result_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_compact_list_tile.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Otwiera panel raportów dla wskazanej inwentaryzacji.
Future<void> showInventoryReportsFlow(
  BuildContext context, {
  required int inventoryId,
  required String inventoryNumber,
  required GetInwentaryzacjaDetailsResponseData inventoryDetails,
  required InventoriesRepository repository,
}) {
  final sheetWidth = MediaQuery.sizeOf(context).width * .9;

  return AppModalSheet.showSideSheet<void>(
    context,
    title: context.l10n.inventoryReportsTitle,
    subtitle: context.l10n.inventoryReportsSubtitle(inventoryNumber),
    width: sheetWidth,
    minBodyHeight: 760,
    scrollBody: false,
    body: BlocProvider(
      create: (_) =>
          InventoryReportBundlePdfExportCubit(repository: repository),
      child: _InventoryReportsWorkspace(
        inventoryId: inventoryId,
        inventoryNumber: inventoryNumber,
        inventoryDetails: inventoryDetails,
        repository: repository,
      ),
    ),
  );
}

/// Główny panel raportów z wyborem typu i widokiem wyniku.
class _InventoryReportsWorkspace extends StatefulWidget {
  /// Tworzy panel raportów inwentaryzacji.
  const _InventoryReportsWorkspace({
    required this.inventoryId,
    required this.inventoryNumber,
    required this.inventoryDetails,
    required this.repository,
  });

  final int inventoryId;
  final String inventoryNumber;
  final GetInwentaryzacjaDetailsResponseData inventoryDetails;
  final InventoriesRepository repository;

  @override
  State<_InventoryReportsWorkspace> createState() =>
      _InventoryReportsWorkspaceState();
}

/// Stan panelu raportów inwentaryzacji.
class _InventoryReportsWorkspaceState
    extends State<_InventoryReportsWorkspace> {
  InventoryReportDefinition _selectedDefinition =
      InventoryReportDefinitions.v1.first;
  bool _showUwagiInBundle = false;

  @override
  Widget build(BuildContext context) {
    final bundleState = context
        .watch<InventoryReportBundlePdfExportCubit>()
        .state;

    return Row(
      crossAxisAlignment: .stretch,
      children: [
        SizedBox(
          width: 380,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Padding(
              padding: const .all(Sizes.p12),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  AppText(
                    context.l10n.inventoryReportsIntro,
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  Gaps.h16,
                  _InventoryBundleSection(
                    isProcessing: bundleState.isProcessing,
                    showUwagi: _showUwagiInBundle,
                    onShowUwagiChanged: (value) {
                      setState(() {
                        _showUwagiInBundle = value;
                      });
                    },
                    onDownload: () {
                      context
                          .read<InventoryReportBundlePdfExportCubit>()
                          .downloadPdf(
                            inventoryId: widget.inventoryId,
                            inventoryNumber: widget.inventoryNumber,
                            inventoryDetails: widget.inventoryDetails,
                            showUwagi: _showUwagiInBundle,
                          )
                          .ignore();
                    },
                    onPrint: () {
                      context
                          .read<InventoryReportBundlePdfExportCubit>()
                          .printPdf(
                            inventoryId: widget.inventoryId,
                            inventoryNumber: widget.inventoryNumber,
                            inventoryDetails: widget.inventoryDetails,
                            showUwagi: _showUwagiInBundle,
                          )
                          .ignore();
                    },
                    onPreview: () {
                      _showInventoryReportBundlePdfPreviewModal(
                        context,
                        inventoryId: widget.inventoryId,
                        inventoryNumber: widget.inventoryNumber,
                        inventoryDetails: widget.inventoryDetails,
                        showUwagi: _showUwagiInBundle,
                      ).ignore();
                    },
                  ),
                  if (bundleState.progress
                      case final InventoryReportBundlePdfExportProgress
                          progress?) ...[
                    Gaps.h8,
                    AppText(
                      _bundleProgressLabel(context, progress),
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                        fontWeight: .w500,
                      ),
                    ),
                  ],
                  if (bundleState.errorType
                      case final InventoryReportBundlePdfExportErrorType
                          errorType?) ...[
                    Gaps.h8,
                    _InventoryBundleInlineError(
                      message: _bundleErrorLabel(
                        context,
                        errorType,
                        bundleState.apiError,
                      ),
                    ),
                  ],
                  Gaps.h16,
                  AppText(
                    context.l10n.inventoryReportsListTitle,
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: .w700,
                    ),
                  ),
                  Gaps.h12,
                  Expanded(
                    child: ListView.separated(
                      itemCount: InventoryReportDefinitions.v1.length,
                      separatorBuilder: (_, _) => Gaps.h8,
                      itemBuilder: (context, index) {
                        final definition = InventoryReportDefinitions.v1[index];
                        final isSelected =
                            definition.type == _selectedDefinition.type;
                        return AppCompactListTile(
                          title: definition.title,
                          subtitle: definition.description,
                          leading: Icon(
                            definition.icon,
                            color: isSelected
                                ? context.colors.primary
                                : context.colors.onSurfaceVariant,
                          ),
                          trailing: Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.chevron_right_rounded,
                            color: isSelected
                                ? context.colors.primary
                                : context.colors.onSurfaceVariant,
                          ),
                          meta: definition.isInternal
                              ? _InventoryInternalReportBadge(
                                  emphasized: isSelected,
                                )
                              : null,
                          selected: isSelected,
                          onTap: () {
                            if (isSelected) {
                              return;
                            }
                            setState(() {
                              _selectedDefinition = definition;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gaps.w16,
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLowest,
              borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Padding(
              padding: const .all(Sizes.p16),
              child: InventoryReportResultView(
                key: ValueKey(_selectedDefinition.type),
                inventoryId: widget.inventoryId,
                inventoryNumber: widget.inventoryNumber,
                inventoryDetails: widget.inventoryDetails,
                repository: widget.repository,
                definition: _selectedDefinition,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Wydzielona sekcja sterowania scalonym kompletem PDF.
class _InventoryBundleSection extends StatelessWidget {
  /// Tworzy sekcję kompletu PDF.
  const _InventoryBundleSection({
    required this.isProcessing,
    required this.showUwagi,
    required this.onShowUwagiChanged,
    required this.onDownload,
    required this.onPrint,
    required this.onPreview,
  });

  final bool isProcessing;
  final bool showUwagi;
  final ValueChanged<bool> onShowUwagiChanged;
  final VoidCallback onDownload;
  final VoidCallback onPrint;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AppText(
            context.l10n.inventoryReportsBundleTitle,
            style: context.text.titleSmall?.copyWith(fontWeight: .w700),
          ),
          Gaps.h4,
          AppText(
            context.l10n.inventoryReportsBundleDescription,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          Gaps.h12,
          _InventoryBundleNotesSwitch(
            value: showUwagi,
            onChanged: onShowUwagiChanged,
          ),
          Gaps.h8,
          Row(
            children: [
              Expanded(
                child: AppActionButton.outlined(
                  label: context.l10n.inventoryReportsPreview,
                  icon: Icons.preview_rounded,
                  tone: .neutral,
                  dense: true,
                  onPressed: isProcessing ? null : onPreview,
                ),
              ),
              Gaps.w8,
              Expanded(
                child: AppActionButton.outlined(
                  label: context.l10n.inventoryReportsDownload,
                  icon: Icons.download_for_offline_outlined,
                  tone: .neutral,
                  dense: true,
                  onPressed: isProcessing ? null : onDownload,
                ),
              ),
              Gaps.w8,
              Expanded(
                child: AppActionButton.filled(
                  label: context.l10n.inventoryReportsPrint,
                  icon: Icons.library_books_outlined,
                  dense: true,
                  onPressed: isProcessing ? null : onPrint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _showInventoryReportBundlePdfPreviewModal(
  BuildContext context, {
  required int inventoryId,
  required String inventoryNumber,
  required GetInwentaryzacjaDetailsResponseData inventoryDetails,
  required bool showUwagi,
}) {
  final filename = buildInventoryReportBundlePdfFilename(
    inventoryNumber: inventoryNumber,
  );
  final sheetWidth = MediaQuery.sizeOf(context).width * .9;
  final bundleCubit = context.read<InventoryReportBundlePdfExportCubit>();

  return AppModalSheet.showSideSheet<void>(
    context,
    title: context.l10n.inventoryReportsPreviewPdf,
    subtitle: context.l10n.inventoryReportsBundleSubtitle,
    width: sheetWidth,
    padding: const .all(Sizes.p12),
    minBodyHeight: 720,
    body: BlocProvider.value(
      value: bundleCubit,
      child: _InventoryReportBundlePdfPreviewBody(
        inventoryId: inventoryId,
        filename: filename,
        inventoryNumber: inventoryNumber,
        inventoryDetails: inventoryDetails,
        showUwagi: showUwagi,
      ),
    ),
  );
}

/// Podgląd PDF dla scalonego kompletu raportów.
class _InventoryReportBundlePdfPreviewBody extends StatefulWidget {
  /// Tworzy widok podglądu PDF kompletu raportów.
  const _InventoryReportBundlePdfPreviewBody({
    required this.inventoryId,
    required this.filename,
    required this.inventoryNumber,
    required this.inventoryDetails,
    required this.showUwagi,
  });

  final int inventoryId;
  final String filename;
  final String inventoryNumber;
  final GetInwentaryzacjaDetailsResponseData inventoryDetails;
  final bool showUwagi;

  @override
  State<_InventoryReportBundlePdfPreviewBody> createState() =>
      _InventoryReportBundlePdfPreviewBodyState();
}

/// Stan podglądu PDF kompletu raportów.
class _InventoryReportBundlePdfPreviewBodyState
    extends State<_InventoryReportBundlePdfPreviewBody> {
  PrintingInfo? _printingInfo;

  @override
  void initState() {
    super.initState();
    _loadPrintingInfo().ignore();
  }

  Future<void> _loadPrintingInfo() async {
    try {
      final info = await Printing.info();
      if (!mounted) {
        return;
      }
      setState(() {
        _printingInfo = info;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final previewHeight = (screenHeight - 220).clamp(320.0, 960.0);
    final cubit = context.read<InventoryReportBundlePdfExportCubit>();

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        if (_printingInfo case final PrintingInfo info) ...[
          Container(
            width: double.infinity,
            padding: const .all(Sizes.p12),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: AppText(
              'Układ PDF: A4 poziomo • dynamicLayout wyłączony • '
              'Drukowanie systemowe: ${info.canPrint ? 'dostępne' : 'niedostępne'} • '
              'Udostępnianie: ${info.canShare ? 'dostępne' : 'niedostępne'}',
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: .w500,
              ),
            ),
          ),
          Gaps.h12,
        ],
        SizedBox(
          height: previewHeight,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            child: ColoredBox(
              color: context.colors.surfaceContainerLow,
              child: PdfPreview(
                pdfFileName: widget.filename,
                canDebug: false,
                initialPageFormat: PdfPageFormat.a4.landscape,
                canChangeOrientation: false,
                canChangePageFormat: false,
                dynamicLayout: false,
                maxPageWidth: 900,
                loadingWidget: const Center(child: AppSpinner()),
                build: (_) async {
                  final sections = await cubit.fetchBundleSections(
                    widget.inventoryId,
                  );
                  return buildInventoryReportBundlePdfDocument(
                    inventoryNumber: widget.inventoryNumber,
                    inventoryDetails: widget.inventoryDetails,
                    sections: sections,
                    showUwagi: widget.showUwagi,
                  );
                },
                onError: (context, error) {
                  return Center(
                    child: Padding(
                      padding: const .all(Sizes.p24),
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 42,
                            color: context.colors.error,
                          ),
                          Gaps.h12,
                          AppText(
                            context.l10n.inventoryReportsPreviewOpenError,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w700,
                            ),
                          ),
                          Gaps.h8,
                          AppText(
                            '$error',
                            style: context.text.bodySmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Przełącznik uwag dla scalonego pakietu PDF.
class _InventoryBundleNotesSwitch extends StatelessWidget {
  /// Tworzy przełącznik uwag pakietu PDF.
  const _InventoryBundleNotesSwitch({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const .symmetric(horizontal: Sizes.p10, vertical: Sizes.p8),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sticky_note_2_outlined,
            size: 16,
            color: context.colors.onSurfaceVariant,
          ),
          Gaps.w8,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                AppText(
                  context.l10n.inventoryReportsNotesLabel,
                  style: context.text.labelMedium?.copyWith(
                    fontWeight: .w700,
                  ),
                ),
                AppText(
                  value
                      ? context.l10n.inventoryReportsEnabled
                      : context.l10n.inventoryReportsDisabled,
                  style: context.text.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: .82,
            child: Switch.adaptive(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

/// Mały błąd sekcji kompletu PDF.
class _InventoryBundleInlineError extends StatelessWidget {
  /// Tworzy błąd sekcji kompletu PDF.
  const _InventoryBundleInlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p10),
      decoration: BoxDecoration(
        color: context.colors.errorContainer.withValues(alpha: .45),
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        border: Border.all(
          color: context.colors.error.withValues(alpha: .28),
        ),
      ),
      child: AppText(
        message,
        style: context.text.bodySmall?.copyWith(
          color: context.colors.onErrorContainer,
          fontWeight: .w600,
        ),
      ),
    );
  }
}

String _bundleProgressLabel(
  BuildContext context,
  InventoryReportBundlePdfExportProgress progress,
) {
  return switch (progress) {
    InventoryReportBundlePdfExportProgress.fetchBundleData =>
      context.l10n.inventoryReportsDownload,
    InventoryReportBundlePdfExportProgress.buildDocument =>
      context.l10n.inventoryReportsBundleTitle,
    InventoryReportBundlePdfExportProgress.openPrintDialog =>
      context.l10n.inventoryReportsPrint,
    InventoryReportBundlePdfExportProgress.saveFile =>
      context.l10n.inventoryReportsDownload,
    InventoryReportBundlePdfExportProgress.fetchSingleReport =>
      context.l10n.inventoryReportsListTitle,
  };
}

String _bundleErrorLabel(
  BuildContext context,
  InventoryReportBundlePdfExportErrorType errorType,
  ApiError? apiError,
) {
  return switch (errorType) {
    InventoryReportBundlePdfExportErrorType.api =>
      apiError?.message ?? context.l10n.inventoryReportsPreviewOpenError,
    InventoryReportBundlePdfExportErrorType.generic =>
      context.l10n.inventoryReportsPreviewOpenError,
  };
}

/// Czerwony badge dla raportu o zastosowaniu wewnętrznym.
class _InventoryInternalReportBadge extends StatelessWidget {
  /// Tworzy badge raportu wewnętrznego.
  const _InventoryInternalReportBadge({required this.emphasized});

  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
      decoration: BoxDecoration(
        color: context.colors.errorContainer.withValues(
          alpha: emphasized ? .88 : .72,
        ),
        borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
        border: Border.all(
          color: context.colors.error.withValues(alpha: emphasized ? .38 : .24),
        ),
      ),
      child: AppText(
        context.l10n.inventoryReportInternalBannerTitle,
        style: context.text.labelSmall?.copyWith(
          color: context.colors.onErrorContainer,
          fontWeight: .w700,
        ),
      ),
    );
  }
}
