part of 'arkusz_detail_modal.dart';

/// Otwiera akcje eksportu PDF dla arkusza, opcjonalnie dociagajac jego szczegoly.
Future<void> showArkuszPdfExportFlow(
  BuildContext context, {
  required int arkuszId,
  required String arkuszNumber,
  required InventoriesRepository inventoriesRepository,
  GetArkuszDetailsResponseData? data,
  List<GetArkuszDetailsElementItem>? filteredItems,
}) async {
  final details =
      data ??
      await _fetchArkuszDetailsForPdfExport(
        context,
        arkuszId: arkuszId,
        arkuszNumber: arkuszNumber,
        inventoriesRepository: inventoriesRepository,
      );

  if (!context.mounted || details == null) {
    return;
  }

  final exportData = filteredItems == null
      ? details
      : GetArkuszDetailsResponseData(
          arkusz: details.arkusz,
          komisja: details.komisja,
          elementy: List<GetArkuszDetailsElementItem>.unmodifiable(
            filteredItems,
          ),
        );
  final responsiblePeople = collectResponsiblePeopleForSignatures(
    exportData.elementy,
  );

  final selectedResponsiblePeople = responsiblePeople.isEmpty
      ? const <String>[]
      : await _showArkuszPdfSignatureSelectionModal(
          context,
          responsiblePeople: responsiblePeople,
        );

  if (!context.mounted ||
      (responsiblePeople.isNotEmpty && selectedResponsiblePeople == null)) {
    return;
  }
  final effectiveResponsiblePeople =
      selectedResponsiblePeople ?? const <String>[];

  await _showArkuszPdfExportModal(
    context,
    arkuszNumber: arkuszNumber,
    data: exportData,
    selectedResponsiblePeople: effectiveResponsiblePeople,
    exportMode: filteredItems == null
        ? _ArkuszPdfExportMode.full
        : _ArkuszPdfExportMode.filtered,
  );
}

Future<GetArkuszDetailsResponseData?> _fetchArkuszDetailsForPdfExport(
  BuildContext context, {
  required int arkuszId,
  required String arkuszNumber,
  required InventoriesRepository inventoriesRepository,
}) async {
  final result = await inventoriesRepository.fetchArkuszDetails(arkuszId);

  if (!context.mounted) {
    return null;
  }

  return result.fold(
    (error) {
      _showArkuszPdfExportErrorToast(
        context,
        error,
        arkuszNumber: arkuszNumber,
      );
      return null;
    },
    (data) => data,
  );
}

void _showArkuszPdfExportErrorToast(
  BuildContext context,
  ApiError error, {
  required String arkuszNumber,
}) {
  AppToast.show(
    context,
    message:
        'Nie udalo sie przygotowac drukowania dla arkusza $arkuszNumber. ${error.message}',
    tone: AppToastTone.error,
  );
}

/// Otwiera modal akcji PDF dla arkusza.
Future<void> _showArkuszPdfExportModal(
  BuildContext context, {
  required String arkuszNumber,
  required GetArkuszDetailsResponseData data,
  required List<String> selectedResponsiblePeople,
  required _ArkuszPdfExportMode exportMode,
}) {
  return AppModalSheet.show<void>(
    context,
    title: switch (exportMode) {
      _ArkuszPdfExportMode.full => 'Eksport PDF',
      _ArkuszPdfExportMode.filtered => 'Eksport PDF (odfiltrowane)',
    },
    subtitle: switch (exportMode) {
      _ArkuszPdfExportMode.full =>
        'Druk lub pobranie arkusza spisu w formacie PDF.',
      _ArkuszPdfExportMode.filtered =>
        'Druk lub pobranie aktualnie widocznych pozycji w formacie PDF.',
    },
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => ArkuszPdfExportCubit(),
      child: _ArkuszPdfExportModalBody(
        arkuszNumber: arkuszNumber,
        data: data,
        selectedResponsiblePeople: selectedResponsiblePeople,
        exportMode: exportMode,
      ),
    ),
  );
}

enum _ArkuszPdfExportMode { full, filtered }

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

bool _shouldDisableDynamicLayoutForPrint() {
  if (kIsWeb) {
    return false;
  }

  return defaultTargetPlatform == TargetPlatform.macOS;
}

Future<void> _showArkuszPdfPreviewModal(
  BuildContext context, {
  required String arkuszNumber,
  required GetArkuszDetailsResponseData data,
  required List<String> selectedResponsiblePeople,
}) {
  final filename = buildArkuszPdfFilename(arkuszNumber: arkuszNumber);
  debugPrint('[ARKUSZ_PDF][preview][open] arkusz=$arkuszNumber');

  return AppModalSheet.showSideSheet<void>(
    context,
    title: 'Podgląd PDF',
    subtitle: 'Sprawdź dokument przed drukiem lub pobraniem.',
    width: 1120,
    padding: const .all(Sizes.p12),
    minBodyHeight: 720,
    body: _ArkuszPdfPreviewBody(
      arkuszNumber: arkuszNumber,
      filename: filename,
      data: data,
      selectedResponsiblePeople: selectedResponsiblePeople,
    ),
  );
}

Future<List<String>?> _showArkuszPdfSignatureSelectionModal(
  BuildContext context, {
  required List<String> responsiblePeople,
}) {
  return AppModalSheet.show<List<String>>(
    context,
    title: 'Podpisy osób odpowiedzialnych',
    subtitle:
        'Wybierz, które podpisy mają zostać uwzględnione w końcowej sekcji PDF.',
    size: AppModalSheetSize.small,
    body: _ArkuszPdfSignatureSelectionModalBody(
      responsiblePeople: responsiblePeople,
    ),
  );
}

/// Zawartość modala eksportu PDF.
class _ArkuszPdfExportModalBody extends StatelessWidget {
  /// Tworzy body modala eksportu PDF.
  const _ArkuszPdfExportModalBody({
    required this.arkuszNumber,
    required this.data,
    required this.selectedResponsiblePeople,
    required this.exportMode,
  });

  final String arkuszNumber;
  final GetArkuszDetailsResponseData data;
  final List<String> selectedResponsiblePeople;
  final _ArkuszPdfExportMode exportMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArkuszPdfExportCubit, ArkuszPdfExportState>(
      builder: (context, state) {
        final usePreviewForPrint = _shouldUsePdfPreviewForPrint();

        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            AppText(
              switch ((exportMode, usePreviewForPrint)) {
                (_ArkuszPdfExportMode.filtered, true) =>
                  'Dokument obejmuje tylko aktualnie widoczne pozycje i pomija elementy oznaczone jako znalezione w innej firmie. Przed drukiem otworzy się podgląd PDF.',
                (_ArkuszPdfExportMode.filtered, false) =>
                  'Dokument obejmuje tylko aktualnie widoczne pozycje i pomija elementy oznaczone jako znalezione w innej firmie.',
                (_, true) =>
                  'Dokument pomija elementy oznaczone jako znalezione w innej firmie. Przed drukiem otworzy się podgląd PDF.',
                _ =>
                  'Dokument pomija elementy oznaczone jako znalezione w innej firmie i przygotowuje wersję do druku zgodną z arkuszem.',
              },
              style: context.text.bodyMedium,
            ),
            if (state.errorMessage case final String message
                when message.trim().isNotEmpty) ...[
              Gaps.h12,
              Container(
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
              ),
            ],
            if (state.progressMessage case final String progress
                when progress.trim().isNotEmpty) ...[
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
                      progress,
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
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: context.l10n.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: state.isProcessing
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
                Gaps.w8,
                AppActionButton.outlined(
                  label: context.l10n.inventoryReportsDownloadPdf,
                  icon: Icons.download_rounded,
                  tone: .neutral,
                  onPressed: state.isProcessing
                      ? null
                      : () {
                          context
                              .read<ArkuszPdfExportCubit>()
                              .downloadPdf(
                                arkuszNumber: arkuszNumber,
                                data: data,
                                selectedResponsiblePeople:
                                    selectedResponsiblePeople,
                              )
                              .ignore();
                        },
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: context.l10n.inventoryReportsPrintPdf,
                  icon: usePreviewForPrint
                      ? Icons.preview_rounded
                      : Icons.print_rounded,
                  onPressed: state.isProcessing
                      ? null
                      : () {
                          if (usePreviewForPrint) {
                            Navigator.of(context).pop();
                            unawaited(
                              _showArkuszPdfPreviewModal(
                                context,
                                arkuszNumber: arkuszNumber,
                                data: data,
                                selectedResponsiblePeople:
                                    selectedResponsiblePeople,
                              ),
                            );
                            return;
                          }

                          context
                              .read<ArkuszPdfExportCubit>()
                              .printPdf(
                                arkuszNumber: arkuszNumber,
                                data: data,
                                selectedResponsiblePeople:
                                    selectedResponsiblePeople,
                              )
                              .ignore();
                        },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Zawartość modala podglądu PDF arkusza.
class _ArkuszPdfPreviewBody extends StatefulWidget {
  /// Tworzy body modala podglądu PDF.
  const _ArkuszPdfPreviewBody({
    required this.arkuszNumber,
    required this.filename,
    required this.data,
    required this.selectedResponsiblePeople,
  });

  final String arkuszNumber;
  final String filename;
  final GetArkuszDetailsResponseData data;
  final List<String> selectedResponsiblePeople;

  @override
  State<_ArkuszPdfPreviewBody> createState() => _ArkuszPdfPreviewBodyState();
}

/// Stan modala podglądu PDF arkusza.
class _ArkuszPdfPreviewBodyState extends State<_ArkuszPdfPreviewBody> {
  PrintingInfo? _printingInfo;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPrintingInfo());
  }

  Future<void> _loadPrintingInfo() async {
    try {
      final info = await Printing.info();
      debugPrint(
        '[ARKUSZ_PDF][preview][info] '
        'arkusz=${widget.arkuszNumber} | '
        'canPrint=${info.canPrint} | '
        'canShare=${info.canShare} | '
        'canRaster=${info.canRaster}',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _printingInfo = info;
      });
    } catch (error, stackTrace) {
      debugPrint(
        '[ARKUSZ_PDF][preview][info_error] arkusz=${widget.arkuszNumber} | $error',
      );
      for (final line in stackTrace.toString().trim().split('\n')) {
        debugPrint('[ARKUSZ_PDF][preview][info_stack] $line');
      }
    }
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
              '${_shouldDisableDynamicLayoutForPrint() ? 'macOS workaround: dynamicLayout wyłączony • ' : ''}'
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
                canChangeOrientation: false,
                canChangePageFormat: false,
                dynamicLayout: !_shouldDisableDynamicLayoutForPrint(),
                maxPageWidth: 900,
                loadingWidget: const Center(child: AppSpinner()),
                build: (_) => buildArkuszPdfDocument(
                  arkuszNumber: widget.arkuszNumber,
                  data: widget.data,
                  selectedResponsiblePeople: widget.selectedResponsiblePeople,
                ),
                onPrinted: (context) {
                  debugPrint(
                    '[ARKUSZ_PDF][preview][printed] arkusz=${widget.arkuszNumber}',
                  );
                },
                onShared: (context) {
                  debugPrint(
                    '[ARKUSZ_PDF][preview][shared] arkusz=${widget.arkuszNumber}',
                  );
                },
                onPrintError: (context, error) {
                  debugPrint(
                    '[ARKUSZ_PDF][preview][print_error] '
                    'arkusz=${widget.arkuszNumber} | $error',
                  );
                },
                onError: (context, error) {
                  debugPrint(
                    '[ARKUSZ_PDF][preview][render_error] '
                    'arkusz=${widget.arkuszNumber} | $error',
                  );
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

/// Modal wyboru podpisów osób odpowiedzialnych dla eksportu PDF.
class _ArkuszPdfSignatureSelectionModalBody extends StatefulWidget {
  /// Tworzy body modala wyboru podpisów.
  const _ArkuszPdfSignatureSelectionModalBody({
    required this.responsiblePeople,
  });

  final List<String> responsiblePeople;

  @override
  State<_ArkuszPdfSignatureSelectionModalBody> createState() =>
      _ArkuszPdfSignatureSelectionModalBodyState();
}

/// Stan modala wyboru podpisów.
class _ArkuszPdfSignatureSelectionModalBodyState
    extends State<_ArkuszPdfSignatureSelectionModalBody> {
  late final Set<String> _selectedPeople = widget.responsiblePeople.toSet();

  @override
  Widget build(BuildContext context) {
    final hasPeople = widget.responsiblePeople.isNotEmpty;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        AppText(
          hasPeople
              ? 'Domyślnie zaznaczone są wszystkie osoby odpowiedzialne. Możesz odznaczyć wybrane podpisy przed drukiem lub pobraniem PDF.'
              : 'W tym arkuszu nie wykryto osób odpowiedzialnych do podpisu. PDF zostanie wygenerowany bez tej listy.',
          style: context.text.bodyMedium,
        ),
        if (hasPeople) ...[
          Gaps.h12,
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLow,
                borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
                border: Border.all(color: context.colors.outlineVariant),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.responsiblePeople.length,
                itemBuilder: (context, index) {
                  final person = widget.responsiblePeople[index];
                  return CheckboxListTile(
                    value: _selectedPeople.contains(person),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    title: AppText(
                      person,
                      style: context.text.bodyMedium,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value ?? false) {
                          _selectedPeople.add(person);
                        } else {
                          _selectedPeople.remove(person);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
        Gaps.h16,
        Row(
          mainAxisAlignment: .end,
          children: [
            AppActionButton.text(
              label: context.l10n.cancel,
              icon: Icons.close_rounded,
              tone: .neutral,
              onPressed: () => Navigator.of(context).pop(),
            ),
            Gaps.w8,
            AppActionButton.filled(
              label: 'Dalej',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => Navigator.of(context).pop(
                widget.responsiblePeople
                    .where(_selectedPeople.contains)
                    .toList(growable: false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
