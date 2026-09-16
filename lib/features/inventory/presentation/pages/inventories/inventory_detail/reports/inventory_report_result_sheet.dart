import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/extensions/number_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/cubit/inventory_report_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/cubit/inventory_report_pdf_export_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_definition.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_pdf_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Widok wyniku wybranego raportu inwentaryzacji.
class InventoryReportResultView extends StatelessWidget {
  /// Tworzy widok wyniku raportu.
  const InventoryReportResultView({
    required this.inventoryId,
    required this.inventoryNumber,
    required this.inventoryDetails,
    required this.repository,
    required this.definition,
    super.key,
  });

  final int inventoryId;
  final String inventoryNumber;
  final GetInwentaryzacjaDetailsResponseData inventoryDetails;
  final InventoriesRepository repository;
  final InventoryReportDefinition definition;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => InventoryReportCubit(
            repository: repository,
            reportType: definition.type,
          )..load(inventoryId).ignore(),
        ),
        BlocProvider(
          create: (_) => InventoryReportPdfExportCubit(),
        ),
      ],
      child: _InventoryReportResultBody(
        inventoryId: inventoryId,
        inventoryNumber: inventoryNumber,
        inventoryDetails: inventoryDetails,
        definition: definition,
      ),
    );
  }
}

/// Zawartość widoku wyników raportu.
class _InventoryReportResultBody extends StatefulWidget {
  /// Tworzy body wyników raportu.
  const _InventoryReportResultBody({
    required this.inventoryId,
    required this.inventoryNumber,
    required this.inventoryDetails,
    required this.definition,
  });

  final int inventoryId;
  final String inventoryNumber;
  final GetInwentaryzacjaDetailsResponseData inventoryDetails;
  final InventoryReportDefinition definition;

  @override
  State<_InventoryReportResultBody> createState() =>
      _InventoryReportResultBodyState();
}

/// Stan body wyników raportu.
class _InventoryReportResultBodyState
    extends State<_InventoryReportResultBody> {
  bool _showUwagi = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryReportCubit, InventoryReportState>(
      builder: (context, state) {
        final result = state.result;
        final currentData = result.data;
        final visibleElements = switch (currentData) {
          final data? => displayElementsForInventoryReport(
            reportType: widget.definition.type,
            elements: data.elements,
          ),
          _ => const <GetInwentaryzacjaReportElementItem>[],
        };
        final pdfState = context.watch<InventoryReportPdfExportCubit>().state;

        return Column(
          crossAxisAlignment: .start,
          children: [
            if (widget.definition.isInternal) ...[
              const _InventoryReportInternalBanner(),
              Gaps.h12,
            ],
            AppText(
              widget.definition.description,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            Gaps.h12,
            Wrap(
              spacing: Sizes.p12,
              runSpacing: Sizes.p12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  child: AppDropdown<GetInwentaryzacjaReportSortBy>(
                    value: state.sortBy,
                    inlineLabel: context.l10n.inventoryReportsSortLabel,
                    options: [
                      AppDropdownOption(
                        value: GetInwentaryzacjaReportSortBy.id,
                        label: context.l10n.inventoryReportsSortById,
                      ),
                      AppDropdownOption(
                        value: GetInwentaryzacjaReportSortBy.nrewid,
                        label:
                            context.l10n.inventoryReportsSortByRegisterNumber,
                      ),
                      AppDropdownOption(
                        value: GetInwentaryzacjaReportSortBy.miejsce,
                        label: context.l10n.inventoryReportsSortByLocation,
                      ),
                      AppDropdownOption(
                        value: GetInwentaryzacjaReportSortBy.statusSpisu,
                        label: context.l10n.inventoryReportsSortByStatus,
                      ),
                      AppDropdownOption(
                        value: GetInwentaryzacjaReportSortBy.stanInwent,
                        label:
                            context.l10n.inventoryReportsSortByInventoryState,
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      context
                          .read<InventoryReportCubit>()
                          .updateSortBy(widget.inventoryId, value)
                          .ignore();
                    },
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: AppDropdown<GetInwentaryzacjaReportSortDirection>(
                    value: state.sortDir,
                    inlineLabel:
                        context.l10n.inventoryReportsSortDirectionLabel,
                    options: [
                      AppDropdownOption(
                        value: GetInwentaryzacjaReportSortDirection.asc,
                        label: context.l10n.inventoryReportsSortAscending,
                      ),
                      AppDropdownOption(
                        value: GetInwentaryzacjaReportSortDirection.desc,
                        label: context.l10n.inventoryReportsSortDescending,
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      context
                          .read<InventoryReportCubit>()
                          .updateSortDir(widget.inventoryId, value)
                          .ignore();
                    },
                  ),
                ),
                if (widget.definition.supportsUwagi)
                  _InventoryReportNotesSwitch(
                    value: _showUwagi,
                    onChanged: (value) {
                      setState(() {
                        _showUwagi = value;
                      });
                    },
                  ),
                AppActionButton.outlined(
                  label: context.l10n.inventoryReportsRefresh,
                  icon: Icons.refresh_rounded,
                  tone: .neutral,
                  onPressed: () => context
                      .read<InventoryReportCubit>()
                      .load(widget.inventoryId)
                      .ignore(),
                ),
                AppActionButton.outlined(
                  label: widget.definition.supportsDisposalProtocol
                      ? context.l10n.inventoryReportsDownloadReportPdf
                      : context.l10n.inventoryReportsDownloadPdf,
                  icon: Icons.download_rounded,
                  tone: .neutral,
                  onPressed: pdfState.isProcessing || currentData == null
                      ? null
                      : () {
                          context
                              .read<InventoryReportPdfExportCubit>()
                              .downloadPdf(
                                definition: widget.definition,
                                inventoryNumber: widget.inventoryNumber,
                                inventoryDetails: widget.inventoryDetails,
                                reportData: currentData,
                                showUwagi: _showUwagi,
                              )
                              .ignore();
                        },
                ),
                if (widget.definition.supportsDisposalProtocol)
                  AppActionButton.outlined(
                    label: context.l10n.inventoryReportsDownloadProtocol,
                    icon: Icons.description_outlined,
                    tone: .neutral,
                    onPressed: pdfState.isProcessing || currentData == null
                        ? null
                        : () {
                            context
                                .read<InventoryReportPdfExportCubit>()
                                .downloadPdf(
                                  definition: widget.definition,
                                  inventoryNumber: widget.inventoryNumber,
                                  inventoryDetails: widget.inventoryDetails,
                                  reportData: currentData,
                                  showUwagi: _showUwagi,
                                  documentKind: InventoryReportPdfDocumentKind
                                      .disposalProtocol,
                                )
                                .ignore();
                          },
                  ),
                AppActionButton.filled(
                  label: widget.definition.supportsDisposalProtocol
                      ? context.l10n.inventoryReportsPrintReportPdf
                      : context.l10n.inventoryReportsPrintPdf,
                  icon: _shouldUsePdfPreviewForPrint()
                      ? Icons.preview_rounded
                      : Icons.print_rounded,
                  onPressed: pdfState.isProcessing || currentData == null
                      ? null
                      : () {
                          if (_shouldUsePdfPreviewForPrint()) {
                            _showInventoryReportPdfPreviewModal(
                              context,
                              definition: widget.definition,
                              inventoryNumber: widget.inventoryNumber,
                              inventoryDetails: widget.inventoryDetails,
                              reportData: currentData,
                              showUwagi: _showUwagi,
                            ).ignore();
                            return;
                          }
                          context
                              .read<InventoryReportPdfExportCubit>()
                              .printPdf(
                                definition: widget.definition,
                                inventoryNumber: widget.inventoryNumber,
                                inventoryDetails: widget.inventoryDetails,
                                reportData: currentData,
                                showUwagi: _showUwagi,
                              )
                              .ignore();
                        },
                ),
                if (widget.definition.supportsDisposalProtocol)
                  AppActionButton.filled(
                    label: context.l10n.inventoryReportsPrintProtocol,
                    icon: _shouldUsePdfPreviewForPrint()
                        ? Icons.article_outlined
                        : Icons.print_rounded,
                    onPressed: pdfState.isProcessing || currentData == null
                        ? null
                        : () {
                            if (_shouldUsePdfPreviewForPrint()) {
                              _showInventoryReportPdfPreviewModal(
                                context,
                                definition: widget.definition,
                                inventoryNumber: widget.inventoryNumber,
                                inventoryDetails: widget.inventoryDetails,
                                reportData: currentData,
                                showUwagi: _showUwagi,
                                documentKind: InventoryReportPdfDocumentKind
                                    .disposalProtocol,
                              ).ignore();
                              return;
                            }
                            context
                                .read<InventoryReportPdfExportCubit>()
                                .printPdf(
                                  definition: widget.definition,
                                  inventoryNumber: widget.inventoryNumber,
                                  inventoryDetails: widget.inventoryDetails,
                                  reportData: currentData,
                                  showUwagi: _showUwagi,
                                  documentKind: InventoryReportPdfDocumentKind
                                      .disposalProtocol,
                                )
                                .ignore();
                          },
                  ),
                if (currentData != null)
                  _InventoryReportMetaChip(
                    label: context.l10n.inventoryReportsElements,
                    value: '${visibleElements.length}',
                  ),
                if (currentData?.meta.generatedAt case final generatedAt?)
                  _InventoryReportMetaChip(
                    label: context.l10n.inventoryReportsGeneratedAt,
                    value: _formatGeneratedAt(generatedAt),
                  ),
              ],
            ),
            if (pdfState.errorType
                case final InventoryReportPdfExportErrorType errorType?) ...[
              Gaps.h12,
              _InventoryReportInlineError(
                message: _pdfErrorLabel(
                  context,
                  errorType,
                ),
              ),
            ],
            if (pdfState.progress
                case final InventoryReportPdfExportProgress progress?) ...[
              Gaps.h12,
              Row(
                children: [
                  const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  Gaps.w8,
                  Expanded(
                    child: AppText(
                      _pdfProgressLabel(context, progress),
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                        fontWeight: .w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            Gaps.h16,
            Expanded(
              child: _buildContent(
                context,
                state,
                visibleElements: visibleElements,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    InventoryReportState state, {
    required List<GetInwentaryzacjaReportElementItem> visibleElements,
  }) {
    return state.result.map(
      initial: SizedBox.shrink,
      loading: (previousData) {
        if (previousData != null) {
          return _InventoryReportTable(
            definition: widget.definition,
            rows: visibleElements,
            showUwagi: _showUwagi,
          );
        }
        return const Center(child: AppSpinner(size: Sizes.p24));
      },
      success: (data) {
        if (data.elements.isEmpty) {
          return AppEmptyState.noData(
            title: context.l10n.inventoryReportNoDataTitle,
            message: context.l10n.inventoryReportNoDataMessage,
            compact: true,
          );
        }
        return _InventoryReportTable(
          definition: widget.definition,
          rows: visibleElements,
          showUwagi: _showUwagi,
        );
      },
      error: (message, previousData) {
        if (previousData != null) {
          return Column(
            crossAxisAlignment: .start,
            children: [
              _InventoryReportInlineError(message: message),
              Gaps.h12,
              Expanded(
                child: _InventoryReportTable(
                  definition: widget.definition,
                  rows: visibleElements,
                  showUwagi: _showUwagi,
                ),
              ),
            ],
          );
        }
        return AppEmptyState.error(
          title: context.l10n.inventoryReportFetchErrorTitle,
          message: message,
          compact: true,
        );
      },
    );
  }

  String _formatGeneratedAt(String value) {
    try {
      return DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(value));
    } catch (_) {
      return value;
    }
  }
}

String _pdfProgressLabel(
  BuildContext context,
  InventoryReportPdfExportProgress progress,
) {
  return switch (progress) {
    InventoryReportPdfExportProgress.buildDocument =>
      context.l10n.inventoryReportsBundleTitle,
    InventoryReportPdfExportProgress.openPrintDialog =>
      context.l10n.inventoryReportsPrint,
    InventoryReportPdfExportProgress.saveFile =>
      context.l10n.inventoryReportsDownload,
  };
}

String _pdfErrorLabel(
  BuildContext context,
  InventoryReportPdfExportErrorType errorType,
) {
  return switch (errorType) {
    InventoryReportPdfExportErrorType.generic =>
      context.l10n.inventoryReportsPreviewOpenError,
  };
}

/// Czerwony baner ostrzegawczy dla raportów wewnętrznych.
class _InventoryReportInternalBanner extends StatelessWidget {
  /// Tworzy baner raportu wewnętrznego.
  const _InventoryReportInternalBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p12),
      decoration: BoxDecoration(
        color: context.colors.errorContainer.withValues(alpha: .78),
        borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
        border: Border.all(
          color: context.colors.error.withValues(alpha: .26),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.report_gmailerrorred_rounded,
            color: context.colors.onErrorContainer,
          ),
          Gaps.w8,
          Expanded(
            child: AppText(
              context.l10n.inventoryReportInternalBannerTitle,
              style: context.text.titleSmall?.copyWith(
                color: context.colors.onErrorContainer,
                fontWeight: .w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tabela wyników raportu.
class _InventoryReportTable extends StatelessWidget {
  /// Tworzy tabelę raportu.
  const _InventoryReportTable({
    required this.definition,
    required this.rows,
    required this.showUwagi,
  });

  final InventoryReportDefinition definition;
  final List<GetInwentaryzacjaReportElementItem> rows;
  final bool showUwagi;

  @override
  Widget build(BuildContext context) {
    return AppSimpleTable<GetInwentaryzacjaReportElementItem>(
      key: ValueKey('${definition.type.apiValue}_$showUwagi'),
      rows: rows,
      columns: _columnsFor(context, definition.type, showUwagi: showUwagi),
      height: null,
      showSearch: true,
      searchHintText: context.l10n.inventoryReportSearchHint,
      searchMatcher: (row, query) {
        final normalized = query.toLowerCase();
        return _searchValues(row).whereType<String>().any(
          (value) => value.toLowerCase().contains(normalized),
        );
      },
    );
  }

  List<AppSimpleTableColumn<GetInwentaryzacjaReportElementItem>> _columnsFor(
    BuildContext context,
    InwentaryzacjaReportType type, {
    required bool showUwagi,
  }) {
    final intl = context.l10n;
    final standard = <AppSimpleTableColumn<GetInwentaryzacjaReportElementItem>>[
      AppSimpleTableColumn(
        label: intl.inventoryReportRegisterNumberLabel,
        width: 110,
        sortValue: (row) => _sortText(row.nrewid),
        cellBuilder: (_, row) => AppText(_display(row.nrewid)),
      ),
      AppSimpleTableColumn(
        label: intl.inventoryReportNameLabel,
        width: 260,
        sortValue: (row) => _sortText(row.nazwa),
        cellBuilder: (_, row) => AppText(_display(row.nazwa)),
      ),
      AppSimpleTableColumn(
        label: intl.inventoryReportLocationLabel,
        width: 220,
        sortValue: (row) => _sortText(_placeValue(row)),
        cellBuilder: (_, row) => AppText(_display(_placeValue(row))),
      ),
      AppSimpleTableColumn(
        label: intl.inventoryReportPersonLabel,
        width: 180,
        sortValue: (row) => _sortText(_personValue(row)),
        cellBuilder: (_, row) => AppText(_display(_personValue(row))),
      ),
      AppSimpleTableColumn(
        label: intl.inventoryReportBarcodeLabel,
        width: 120,
        sortValue: (row) => _sortText(_barcodeValue(row)),
        cellBuilder: (_, row) => AppText(_display(_barcodeValue(row))),
      ),
      AppSimpleTableColumn(
        label: intl.inventoryReportGrossValueLabel,
        width: 112,
        sortValue: (row) => _sortNumber(row.wartoscP),
        numeric: true,
        cellAlignment: .centerRight,
        cellBuilder: (_, row) => AppText(_displayMoney(row.wartoscP)),
      ),
      AppSimpleTableColumn(
        label: intl.inventoryReportNetValueLabel,
        width: 112,
        sortValue: (row) => _sortNumber(row.wartoscA),
        numeric: true,
        cellAlignment: .centerRight,
        cellBuilder: (_, row) => AppText(_displayMoney(row.wartoscA)),
      ),
      AppSimpleTableColumn(
        label: intl.inventoryReportPurchaseDateLabel,
        width: 112,
        sortValue: (row) => _sortText(row.dataZakupu),
        cellBuilder: (_, row) => AppText(_displayDate(row.dataZakupu)),
      ),
    ];

    if (showUwagi) {
      standard.add(
        AppSimpleTableColumn(
          label: intl.inventoryReportUwagiLabel,
          width: 220,
          sortValue: (row) => _sortText(row.uwagiLoc),
          cellBuilder: (_, row) => AppText(_display(row.uwagiLoc)),
        ),
      );
    }

    return switch (type) {
      InwentaryzacjaReportType.kompensaty => [
        AppSimpleTableColumn(
          label: intl.inventoryReportRegisterNumberLabel,
          width: 120,
          sortValue: (row) => _sortText(row.nrewid),
          cellBuilder: (_, row) => AppText(_display(row.nrewid)),
        ),
        AppSimpleTableColumn(
          label: intl.inventoryReportNameLabel,
          width: 280,
          sortValue: (row) => _sortText(row.nazwa),
          cellBuilder: (_, row) => AppText(_display(row.nazwa)),
        ),
        AppSimpleTableColumn(
          label: intl.inventoryReportBarcodeLabel,
          width: 120,
          sortValue: (row) => _sortText(_barcodeValue(row)),
          cellBuilder: (_, row) => AppText(_display(_barcodeValue(row))),
        ),
        AppSimpleTableColumn(
          label: intl.inventoryReportMissingLocationLabel,
          width: 180,
          sortValue: (row) => _sortText(row.compensation?.brakMiejsce),
          cellBuilder: (_, row) =>
              AppText(_display(row.compensation?.brakMiejsce)),
        ),
        AppSimpleTableColumn(
          label: intl.inventoryReportMissingPersonLabel,
          width: 180,
          sortValue: (row) => _sortText(row.compensation?.brakOsoba),
          cellBuilder: (_, row) =>
              AppText(_display(row.compensation?.brakOsoba)),
        ),
        AppSimpleTableColumn(
          label: intl.inventoryReportExcessLocationLabel,
          width: 180,
          sortValue: (row) => _sortText(row.compensation?.nadwyzkaMiejsce),
          cellBuilder: (_, row) =>
              AppText(_display(row.compensation?.nadwyzkaMiejsce)),
        ),
        AppSimpleTableColumn(
          label: intl.inventoryReportExcessPersonLabel,
          width: 180,
          sortValue: (row) => _sortText(row.compensation?.nadwyzkaOsoba),
          cellBuilder: (_, row) =>
              AppText(_display(row.compensation?.nadwyzkaOsoba)),
        ),
      ],
      _ => standard,
    };
  }

  String _display(String? value) {
    final normalized = value?.trim();
    return switch (normalized) {
      final String text when text.isNotEmpty => text,
      _ => '—',
    };
  }

  String _sortText(String? value) {
    return value?.trim().toLowerCase() ?? '';
  }

  List<String?> _searchValues(GetInwentaryzacjaReportElementItem row) {
    return switch (definition.type) {
      InwentaryzacjaReportType.kompensaty => [
        row.nrewid,
        row.nazwa,
        _barcodeValue(row),
        row.compensation?.brakMiejsce,
        row.compensation?.brakOsoba,
        row.compensation?.nadwyzkaMiejsce,
        row.compensation?.nadwyzkaOsoba,
      ],
      _ => [
        row.nrewid,
        row.nazwa,
        row.osoba,
        row.miejsce,
        row.nadwMiejsce,
        _barcodeValue(row),
        row.uwagiLoc,
      ],
    };
  }

  double _sortNumber(String? value) {
    final normalized = value?.trim().replaceAll(',', '.');
    if (normalized == null || normalized.isEmpty) {
      return -1;
    }
    return double.tryParse(normalized) ?? -1;
  }

  String _displayMoney(String? value) {
    return value.toAppMoney(placeholder: '—');
  }

  String _displayDate(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return '—';
    }
    return normalized.toAppDate(placeholder: '—');
  }

  String? _barcodeValue(GetInwentaryzacjaReportElementItem row) {
    final newBarcode = row.nowyKodKreskowy?.trim();
    if (newBarcode != null && newBarcode.isNotEmpty) {
      return newBarcode;
    }
    return row.kodKreskowy?.toString();
  }

  String? _placeValue(GetInwentaryzacjaReportElementItem row) {
    return switch (definition.type) {
      InwentaryzacjaReportType.znalezioneWInnejFirmie => row.nadwMiejsce,
      _ => row.miejsce,
    };
  }

  String? _personValue(GetInwentaryzacjaReportElementItem row) {
    return row.osoba;
  }
}

/// Przełącznik kolumny uwag w raporcie.
class _InventoryReportNotesSwitch extends StatelessWidget {
  /// Tworzy przełącznik uwag raportu.
  const _InventoryReportNotesSwitch({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p8),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          AppText(
            'Pokaż uwagi',
            style: context.text.bodySmall?.copyWith(fontWeight: .w600),
          ),
          Gaps.w8,
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// Mały chip metadanych raportu.
class _InventoryReportMetaChip extends StatelessWidget {
  /// Tworzy chip metadanych raportu.
  const _InventoryReportMetaChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: Sizes.p10, vertical: Sizes.p8),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: AppText(
        '$label: $value',
        style: context.text.bodySmall?.copyWith(fontWeight: .w600),
      ),
    );
  }
}

/// Inline błąd zachowujący kontekst raportu.
class _InventoryReportInlineError extends StatelessWidget {
  /// Tworzy inline błąd raportu.
  const _InventoryReportInlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p12),
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

bool _shouldUsePdfPreviewForPrint() {
  if (kIsWeb) {
    return false;
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.macOS ||
    TargetPlatform.windows ||
    TargetPlatform.linux => true,
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.fuchsia => false,
  };
}

Future<void> _showInventoryReportPdfPreviewModal(
  BuildContext context, {
  required InventoryReportDefinition definition,
  required String inventoryNumber,
  required GetInwentaryzacjaDetailsResponseData inventoryDetails,
  required GetInwentaryzacjaReportResponseData reportData,
  required bool showUwagi,
  InventoryReportPdfDocumentKind documentKind =
      InventoryReportPdfDocumentKind.report,
}) {
  final filename = buildInventoryReportPdfFilename(
    definition: definition,
    inventoryNumber: inventoryNumber,
    documentKind: documentKind,
  );
  final sheetWidth = MediaQuery.sizeOf(context).width * .9;

  return AppModalSheet.showSideSheet<void>(
    context,
    title: context.l10n.inventoryReportsPreviewPdf,
    subtitle: switch (documentKind) {
      InventoryReportPdfDocumentKind.report => definition.title,
      InventoryReportPdfDocumentKind.disposalProtocol =>
        context.l10n.inventoryReportsDisposalProtocolLabel,
    },
    width: sheetWidth,
    padding: const .all(Sizes.p12),
    minBodyHeight: 720,
    body: _InventoryReportPdfPreviewBody(
      definition: definition,
      filename: filename,
      inventoryNumber: inventoryNumber,
      inventoryDetails: inventoryDetails,
      reportData: reportData,
      showUwagi: showUwagi,
      documentKind: documentKind,
    ),
  );
}

/// Podgląd PDF raportu inwentaryzacji.
class _InventoryReportPdfPreviewBody extends StatefulWidget {
  /// Tworzy widok podglądu PDF raportu.
  const _InventoryReportPdfPreviewBody({
    required this.definition,
    required this.filename,
    required this.inventoryNumber,
    required this.inventoryDetails,
    required this.reportData,
    required this.showUwagi,
    required this.documentKind,
  });

  final InventoryReportDefinition definition;
  final String filename;
  final String inventoryNumber;
  final GetInwentaryzacjaDetailsResponseData inventoryDetails;
  final GetInwentaryzacjaReportResponseData reportData;
  final bool showUwagi;
  final InventoryReportPdfDocumentKind documentKind;

  @override
  State<_InventoryReportPdfPreviewBody> createState() =>
      _InventoryReportPdfPreviewBodyState();
}

/// Stan podglądu PDF raportu inwentaryzacji.
class _InventoryReportPdfPreviewBodyState
    extends State<_InventoryReportPdfPreviewBody> {
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
                build: (_) => buildInventoryReportPdfDocument(
                  definition: widget.definition,
                  inventoryNumber: widget.inventoryNumber,
                  inventoryDetails: widget.inventoryDetails,
                  reportData: widget.reportData,
                  showUwagi: widget.showUwagi,
                  documentKind: widget.documentKind,
                ),
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
                            'Nie udało się otworzyć podglądu PDF.',
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
