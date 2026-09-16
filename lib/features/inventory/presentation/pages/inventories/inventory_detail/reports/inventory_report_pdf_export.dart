import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_definition.dart';

const _reportPdfBaseFontSize = 8.2;
const _reportPdfSmallFontSize = 6.8;
const _reportPdfSectionTitleFontSize = 9.4;
const _reportPdfDocumentTitleFontSize = 13.5;
const _reportPdfMaxPages = 200;
const _reportPlaceLabel = 'Podłęże';

/// Rodzaj dokumentu PDF generowanego dla raportu.
enum InventoryReportPdfDocumentKind { report, disposalProtocol }

/// Jedna sekcja scalonego pakietu raportów.
class InventoryReportBundleSection {
  /// Tworzy sekcję scalonego pakietu raportów.
  const InventoryReportBundleSection({
    required this.definition,
    required this.reportData,
  });

  /// Definicja raportu dla sekcji.
  final InventoryReportDefinition definition;

  /// Dane raportu dla sekcji.
  final GetInwentaryzacjaReportResponseData reportData;
}

/// Buduje dokument PDF dla raportu inwentaryzacji.
Future<Uint8List> buildInventoryReportPdfDocument({
  required InventoryReportDefinition definition,
  required String inventoryNumber,
  required GetInwentaryzacjaDetailsResponseData inventoryDetails,
  required GetInwentaryzacjaReportResponseData reportData,
  required bool showUwagi,
  InventoryReportPdfDocumentKind documentKind =
      InventoryReportPdfDocumentKind.report,
}) async {
  final document = pw.Document();
  final regularFont = await fontFromAssetBundle(
    'assets/pdf_fonts/Lato-Regular.ttf',
  );
  final boldFont = await fontFromAssetBundle('assets/pdf_fonts/Lato-Bold.ttf');
  final italicFont = await fontFromAssetBundle(
    'assets/pdf_fonts/Lato-Italic.ttf',
  );
  final committeeNames = inventoryDetails.komisja
      .map(_reportCommitteeLabel)
      .toList(growable: false);
  final reportTitle = _reportDocumentTitle(definition);
  final pdfItems = _filteredItemsForPdf(
    definition: definition,
    items: reportData.elements,
  );

  switch (documentKind) {
    case InventoryReportPdfDocumentKind.report:
      document.addPage(
        pw.MultiPage(
          maxPages: _reportPdfMaxPages,
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4.landscape,
            margin: const pw.EdgeInsets.fromLTRB(20, 18, 20, 30),
            theme: pw.ThemeData.withFont(
              base: regularFont,
              bold: boldFont,
              italic: italicFont,
            ),
          ),
          footer: (context) => _buildReportFooter(
            committeeNames: committeeNames,
            pageNumber: context.pageNumber,
            pagesCount: context.pagesCount,
          ),
          build: (context) => [
            _buildReportHeader(
              inventoryDetails: inventoryDetails,
              reportData: reportData,
              reportTitle: reportTitle,
              placeLabelOverride: _reportPlaceLabel,
            ),
            pw.SizedBox(height: 10),
            if (definition.isInternal) ...[
              _buildInternalReportBanner(),
              pw.SizedBox(height: 8),
            ],
            if (definition.type == InwentaryzacjaReportType.kompensaty)
              _buildCompensationReportTable(pdfItems)
            else
              _buildStandardReportTable(
                items: pdfItems,
                showUwagi: showUwagi && definition.supportsUwagi,
              ),
          ],
        ),
      );
    case InventoryReportPdfDocumentKind.disposalProtocol:
      document.addPage(
        pw.MultiPage(
          maxPages: _reportPdfMaxPages,
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4.landscape,
            margin: const pw.EdgeInsets.fromLTRB(24, 24, 24, 26),
            theme: pw.ThemeData.withFont(
              base: regularFont,
              bold: boldFont,
              italic: italicFont,
            ),
          ),
          footer: (context) => _buildProtocolFooter(
            pageNumber: context.pageNumber,
            pagesCount: context.pagesCount,
          ),
          build: (context) => [
            _buildDisposalProtocolHeader(
              inventoryDetails: inventoryDetails,
              reportData: reportData,
            ),
            pw.SizedBox(height: 12),
            _buildDisposalProtocolTable(
              items: pdfItems,
              showUwagi: showUwagi && definition.supportsUwagi,
            ),
            pw.SizedBox(height: 16),
            _buildDisposalProtocolStatement(),
            pw.SizedBox(height: 12),
            _buildCommitteeMembersSection(
              title: 'Skład komisji',
              names: committeeNames,
            ),
            pw.SizedBox(height: 12),
            _buildManagerAcceptanceSection(),
          ],
        ),
      );
  }

  return document.save();
}

/// Buduje nazwę pliku PDF raportu.
String buildInventoryReportPdfFilename({
  required InventoryReportDefinition definition,
  required String inventoryNumber,
  InventoryReportPdfDocumentKind documentKind =
      InventoryReportPdfDocumentKind.report,
}) {
  final safeReport = switch (documentKind) {
    InventoryReportPdfDocumentKind.report =>
      definition.type.apiValue.replaceAll('_', '-'),
    InventoryReportPdfDocumentKind.disposalProtocol =>
      'protokol-kasacji-${definition.type.apiValue.replaceAll('_', '-')}',
  };
  final safeInventory = inventoryNumber
      .trim()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '-');
  final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  return 'raport_${safeReport}_${safeInventory}_$timestamp.pdf';
}

/// Buduje nazwę pliku PDF dla pełnego pakietu raportów.
String buildInventoryReportBundlePdfFilename({
  required String inventoryNumber,
}) {
  final safeInventory = inventoryNumber
      .trim()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '-');
  final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  return 'raport_komplet_${safeInventory}_$timestamp.pdf';
}

/// Buduje scalony dokument PDF zawierający komplet raportów zgodnych z Delphi.
Future<Uint8List> buildInventoryReportBundlePdfDocument({
  required String inventoryNumber,
  required GetInwentaryzacjaDetailsResponseData inventoryDetails,
  required List<InventoryReportBundleSection> sections,
  required bool showUwagi,
}) async {
  final document = pw.Document();
  final regularFont = await fontFromAssetBundle(
    'assets/pdf_fonts/Lato-Regular.ttf',
  );
  final boldFont = await fontFromAssetBundle('assets/pdf_fonts/Lato-Bold.ttf');
  final italicFont = await fontFromAssetBundle(
    'assets/pdf_fonts/Lato-Italic.ttf',
  );
  final committeeNames = inventoryDetails.komisja
      .map(_reportCommitteeLabel)
      .toList(growable: false);

  for (final (index, section) in sections.indexed) {
    final pdfItems = _filteredItemsForPdf(
      definition: section.definition,
      items: section.reportData.elements,
    );
    document.addPage(
      pw.MultiPage(
        maxPages: _reportPdfMaxPages,
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.fromLTRB(20, 18, 20, 30),
          theme: pw.ThemeData.withFont(
            base: regularFont,
            bold: boldFont,
            italic: italicFont,
          ),
        ),
        footer: (context) => _buildReportFooter(
          committeeNames: committeeNames,
          pageNumber: context.pageNumber,
          pagesCount: context.pagesCount,
        ),
        build: (context) => [
          _buildReportHeader(
            inventoryDetails: inventoryDetails,
            reportData: section.reportData,
            reportTitle: _reportDocumentTitle(section.definition, index: index),
            placeLabelOverride: _reportPlaceLabel,
          ),
          pw.SizedBox(height: 10),
          if (section.definition.type == InwentaryzacjaReportType.kompensaty)
            _buildCompensationReportTable(pdfItems)
          else if (pdfItems.isEmpty)
            _buildNoDataSection(
              _reportDocumentTitle(section.definition, index: index),
            )
          else
            _buildStandardReportTable(
              items: pdfItems,
              showUwagi: showUwagi && section.definition.supportsUwagi,
            ),
        ],
      ),
    );
  }

  document.addPage(
    pw.MultiPage(
      maxPages: _reportPdfMaxPages,
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.fromLTRB(24, 24, 24, 26),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
          italic: italicFont,
        ),
      ),
      footer: (context) => _buildProtocolFooter(
        pageNumber: context.pageNumber,
        pagesCount: context.pagesCount,
      ),
      build: (context) => [
        _buildCommitteeMembersSection(
          title: 'Skład komisji',
          names: committeeNames,
        ),
        pw.SizedBox(height: 12),
        _buildManagerAcceptanceSection(),
      ],
    ),
  );

  return document.save();
}

List<GetInwentaryzacjaReportElementItem> _filteredItemsForPdf({
  required InventoryReportDefinition definition,
  required List<GetInwentaryzacjaReportElementItem> items,
}) {
  final displayItems = displayElementsForInventoryReport(
    reportType: definition.type,
    elements: items,
  );

  if (definition.type == InwentaryzacjaReportType.znalezioneWInnejFirmie) {
    return displayItems;
  }

  return displayItems
      .where((item) => item.statusSpisu != 'znaleziony_w_innej_firmie')
      .toList(growable: false);
}

pw.Widget _buildDisposalProtocolHeader({
  required GetInwentaryzacjaDetailsResponseData inventoryDetails,
  required GetInwentaryzacjaReportResponseData reportData,
}) {
  final header = inventoryDetails.inwentaryzacja;
  final generatedAt = _formatDateTime(reportData.meta.generatedAt);
  final inventoryRange = _buildInventoryDateRangeLabel(
    header.dataOd,
    header.dataDo,
  );

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Center(
        child: pw.Text(
          'PROTOKÓŁ KASACJI ŚRODKÓW TRWAŁYCH',
          style: const pw.TextStyle(
            fontSize: _reportPdfDocumentTitleFontSize,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: .3,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.SizedBox(height: 6),
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey700, width: .6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildReportMetaLine(
              'Data i miejsce sporządzenia protokołu',
              '${generatedAt.split(' ').first}, $_reportPlaceLabel',
            ),
            if (inventoryRange != null) ...[
              pw.SizedBox(height: 4),
              _buildReportMetaLine('Zakres inwentaryzacji', inventoryRange),
            ],
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildReportHeader({
  required GetInwentaryzacjaDetailsResponseData inventoryDetails,
  required GetInwentaryzacjaReportResponseData reportData,
  required String reportTitle,
  String? placeLabelOverride,
}) {
  final header = inventoryDetails.inwentaryzacja;
  final generatedAt = _formatDateTime(reportData.meta.generatedAt);
  final inventoryRange = _buildInventoryDateRangeLabel(
    header.dataOd,
    header.dataDo,
  );
  final placeLabel = _normalizeReportText(
    placeLabelOverride ?? header.firmaNazwa,
  );

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Center(
        child: pw.Column(
          children: [
            pw.Text(
              'PROTOKÓŁ Z INWENTARYZACJI ŚRODKÓW TRWAŁYCH',
              style: const pw.TextStyle(
                fontSize: _reportPdfDocumentTitleFontSize,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: .4,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              reportTitle,
              style: const pw.TextStyle(
                fontSize: _reportPdfSectionTitleFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              placeLabel,
              style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey700, width: .6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildReportMetaLine(
              'Data i miejsce sporządzenia',
              '${generatedAt.split(' ').first}, $placeLabel',
            ),
            if (inventoryRange != null) ...[
              pw.SizedBox(height: 4),
              _buildReportMetaLine('Zakres inwentaryzacji', inventoryRange),
            ],
            pw.SizedBox(height: 4),
            _buildReportMetaLine('Rodzaj', reportTitle),
            pw.SizedBox(height: 4),
            pw.Text(
              'Komisja w składzie',
              style: const pw.TextStyle(
                fontSize: _reportPdfBaseFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              _committeeNamesLabel(inventoryDetails),
              style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
            ),
          ],
        ),
      ),
    ],
  );
}

String? _buildInventoryDateRangeLabel(String? dataOd, String? dataDo) {
  final from = _normalizeReportText(dataOd);
  final to = _normalizeReportText(dataDo);
  if (from == '-' && to == '-') {
    return null;
  }
  return '$from - $to';
}

pw.Widget _buildInternalReportBanner() {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: pw.BoxDecoration(
      color: PdfColors.red50,
      border: pw.Border.all(color: PdfColors.red400, width: .7),
    ),
    child: pw.Text(
      'RAPORT WEWNĘTRZNY',
      style: const pw.TextStyle(
        fontSize: _reportPdfBaseFontSize,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.red800,
        letterSpacing: .3,
      ),
      textAlign: pw.TextAlign.center,
    ),
  );
}

pw.Widget _buildNoDataSection(String title) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.fromLTRB(12, 16, 12, 16),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey600, width: .6),
    ),
    child: pw.Text(
      'Raport „$title” nie zawiera pozycji dla tej inwentaryzacji.',
      style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
    ),
  );
}

pw.Widget _buildStandardReportTable({
  required List<GetInwentaryzacjaReportElementItem> items,
  required bool showUwagi,
}) {
  final headers = [
    'Nr ewidencyjny',
    'Nazwa',
    'Miejsce',
    'Osoba',
    'Kod kreskowy',
    'Wartość brutto',
    'Wartość netto',
    'Data zakupu',
    if (showUwagi) 'Uwagi',
  ];

  final columnWidths = <int, pw.TableColumnWidth>{
    0: const pw.FixedColumnWidth(60),
    1: const pw.FlexColumnWidth(2.7),
    2: const pw.FlexColumnWidth(1.9),
    3: const pw.FlexColumnWidth(1.8),
    4: const pw.FixedColumnWidth(72),
    5: const pw.FixedColumnWidth(62),
    6: const pw.FixedColumnWidth(62),
    7: const pw.FixedColumnWidth(66),
    if (showUwagi) 8: const pw.FlexColumnWidth(2.0),
  };

  return pw.Table(
    border: _buildReportTableBorder(),
    columnWidths: columnWidths,
    defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    children: [
      _buildHeaderTableRow(headers),
      ...items.map(
        (item) => _buildDataTableRow(
          values: [
            _normalizeReportText(item.nrewid),
            _normalizeReportText(_reportDisplayName(item)),
            _normalizeReportText(_reportDisplayPlace(item)),
            _normalizeReportText(_reportDisplayPerson(item)),
            _normalizeReportText(_reportBarcodeValue(item)),
            _normalizeReportText(item.wartoscP),
            _normalizeReportText(item.wartoscA),
            _formatOptionalDate(item.dataZakupu),
            if (showUwagi) _normalizeReportText(item.uwagiLoc),
          ],
          numericColumns: {5, 6},
        ),
      ),
      _buildStandardReportTotalsRow(
        items: items,
        showUwagi: showUwagi,
      ),
    ],
  );
}

pw.Widget _buildCompensationReportTable(
  List<GetInwentaryzacjaReportElementItem> items,
) {
  const topHeaders = [
    '',
    '',
    '',
    '',
    'Brak',
    'Brak',
    'Nadwyżka',
    'Nadwyżka',
  ];

  const headers = [
    'Nr ewidencyjny',
    'Nazwa',
    'Kod kreskowy',
    'Data zakupu',
    'Miejsce',
    'Osoba',
    'Miejsce',
    'Osoba',
  ];

  const columnWidths = <int, pw.TableColumnWidth>{
    0: pw.FixedColumnWidth(72),
    1: pw.FlexColumnWidth(2.2),
    2: pw.FixedColumnWidth(74),
    3: pw.FixedColumnWidth(64),
    4: pw.FlexColumnWidth(1.5),
    5: pw.FlexColumnWidth(1.4),
    6: pw.FlexColumnWidth(1.5),
    7: pw.FlexColumnWidth(1.4),
  };

  return pw.Table(
    border: _buildReportTableBorder(),
    columnWidths: columnWidths,
    defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    children: [
      _buildCompensationTopHeaderRow(topHeaders),
      _buildHeaderTableRow(headers),
      ...items.map(
        (item) => _buildDataTableRow(
          values: [
            _normalizeReportText(item.nrewid),
            _normalizeReportText(_reportDisplayName(item)),
            _normalizeReportText(_reportBarcodeValue(item)),
            _formatOptionalDate(item.dataZakupu),
            _normalizeReportText(item.compensation?.brakMiejsce),
            _normalizeReportText(item.compensation?.brakOsoba),
            _normalizeReportText(item.compensation?.nadwyzkaMiejsce),
            _normalizeReportText(item.compensation?.nadwyzkaOsoba),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildDisposalProtocolTable({
  required List<GetInwentaryzacjaReportElementItem> items,
  required bool showUwagi,
}) {
  final headers = [
    'Nr ewidencyjny',
    'Nazwa',
    'Miejsce',
    'Osoba',
    'Kod kreskowy',
    'Wartość brutto',
    'Wartość netto',
    'Data zakupu',
    if (showUwagi) 'Uwagi',
  ];

  final columnWidths = <int, pw.TableColumnWidth>{
    0: const pw.FixedColumnWidth(58),
    1: const pw.FlexColumnWidth(2.25),
    2: const pw.FlexColumnWidth(1.65),
    3: const pw.FlexColumnWidth(1.5),
    4: const pw.FixedColumnWidth(68),
    5: const pw.FixedColumnWidth(56),
    6: const pw.FixedColumnWidth(56),
    7: const pw.FixedColumnWidth(64),
    if (showUwagi) 8: const pw.FlexColumnWidth(1.55),
  };

  return pw.Table(
    border: _buildReportTableBorder(),
    columnWidths: columnWidths,
    defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    children: [
      _buildHeaderTableRow(headers),
      ...items.map(
        (item) => _buildDataTableRow(
          values: [
            _normalizeReportText(item.nrewid),
            _normalizeReportText(_reportDisplayName(item)),
            _normalizeReportText(_reportDisplayPlace(item)),
            _normalizeReportText(_reportDisplayPerson(item)),
            _normalizeReportText(_reportBarcodeValue(item)),
            _normalizeReportText(item.wartoscP),
            _normalizeReportText(item.wartoscA),
            _formatOptionalDate(item.dataZakupu),
            if (showUwagi) _normalizeReportText(item.uwagiLoc),
          ],
          numericColumns: {5, 6},
        ),
      ),
      _buildStandardReportTotalsRow(
        items: items,
        showUwagi: showUwagi,
      ),
    ],
  );
}

pw.TableRow _buildCompensationTopHeaderRow(List<String> labels) {
  return pw.TableRow(
    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
    children: labels
        .map(
          (label) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            child: pw.Text(
              label,
              style: const pw.TextStyle(
                fontSize: _reportPdfSmallFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
        )
        .toList(growable: false),
  );
}

pw.TableRow _buildHeaderTableRow(List<String> labels) {
  return pw.TableRow(
    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
    children: labels
        .map(
          (label) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: pw.Text(
              label,
              style: const pw.TextStyle(
                fontSize: _reportPdfSmallFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
        )
        .toList(growable: false),
  );
}

pw.TableRow _buildStandardReportTotalsRow({
  required List<GetInwentaryzacjaReportElementItem> items,
  required bool showUwagi,
}) {
  final brutto = _formatDecimal(
    items.fold<double>(0, (sum, item) => sum + _parseDecimal(item.wartoscP)),
  );
  final netto = _formatDecimal(
    items.fold<double>(0, (sum, item) => sum + _parseDecimal(item.wartoscA)),
  );

  return pw.TableRow(
    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: pw.Text(
          'Suma',
          style: const pw.TextStyle(
            fontSize: _reportPdfBaseFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
      pw.SizedBox(),
      pw.SizedBox(),
      pw.SizedBox(),
      pw.SizedBox(),
      _buildTotalsCell(brutto),
      _buildTotalsCell(netto),
      pw.SizedBox(),
      if (showUwagi) pw.SizedBox(),
    ],
  );
}

pw.Widget _buildTotalsCell(String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: pw.Text(
      value,
      style: const pw.TextStyle(
        fontSize: _reportPdfBaseFontSize,
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.right,
    ),
  );
}

pw.TableRow _buildDataTableRow({
  required List<String> values,
  Set<int> numericColumns = const {},
}) {
  return pw.TableRow(
    children: values.indexed
        .map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: pw.Text(
              entry.$2,
              style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
              textAlign: numericColumns.contains(entry.$1)
                  ? pw.TextAlign.right
                  : pw.TextAlign.left,
            ),
          ),
        )
        .toList(growable: false),
  );
}

pw.TableBorder _buildReportTableBorder() {
  const side = pw.BorderSide(color: PdfColors.grey700, width: .55);
  return const pw.TableBorder(
    left: side,
    right: side,
    top: side,
    bottom: side,
    verticalInside: side,
    horizontalInside: side,
  );
}

pw.Widget _buildReportStatementSection({
  required String title,
  required List<pw.Widget> children,
}) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 10),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey600, width: .6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: _reportPdfSectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        ...children,
      ],
    ),
  );
}

pw.Widget _buildCommitteeMembersSection({
  required String title,
  required List<String> names,
}) {
  final rows = names.isEmpty ? const ['Brak'] : names;

  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 10),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey600, width: .6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: _reportPdfSectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        ...rows.map(
          (name) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Text(
              name,
              style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildReportFooter({
  required List<String> committeeNames,
  required int pageNumber,
  required int pagesCount,
}) {
  final footerNames = committeeNames.isEmpty
      ? 'Komisja w składzie: brak'
      : 'Komisja w składzie: ${committeeNames.join(', ')}';
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Expanded(
        child: pw.Text(
          footerNames,
          style: const pw.TextStyle(fontSize: _reportPdfSmallFontSize),
          maxLines: 2,
        ),
      ),
      pw.SizedBox(width: 12),
      pw.Text(
        'strona $pageNumber/$pagesCount',
        style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
      ),
    ],
  );
}

pw.Widget _buildProtocolFooter({
  required int pageNumber,
  required int pagesCount,
}) {
  return pw.Align(
    alignment: pw.Alignment.centerRight,
    child: pw.Text(
      'strona $pageNumber/$pagesCount',
      style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
    ),
  );
}

pw.Widget _buildReportMetaLine(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 2),
    child: pw.RichText(
      text: pw.TextSpan(
        style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
        children: [
          pw.TextSpan(
            text: '$label: ',
            style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(text: value),
        ],
      ),
    ),
  );
}

pw.Widget _buildDisposalProtocolStatement() {
  return _buildReportStatementSection(
    title: 'Postanowienie końcowe',
    children: [
      pw.Text(
        'Skasowane środki trwałe będą wywiezione przez firmę zajmującą się wywozem odpadów mieszanych oraz złomu elektronicznego.',
        style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        'Do momentu zabrania ich przez w/w firmę, skasowane środki trwałe będą składowane w depozycie Działu Administracji oraz depozycie Działu Informatyki.',
        style: const pw.TextStyle(fontSize: _reportPdfBaseFontSize),
      ),
    ],
  );
}

pw.Widget _buildManagerAcceptanceSection() {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 16),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey600, width: .6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Akcept kierownika jednostki',
          style: const pw.TextStyle(
            fontSize: _reportPdfSectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 24),
        pw.Container(
          width: 240,
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: PdfColors.grey700, width: .7),
            ),
          ),
          padding: const pw.EdgeInsets.only(top: 4),
          child: pw.Text(
            'podpis i pieczęć',
            style: const pw.TextStyle(
              fontSize: _reportPdfSmallFontSize,
              color: PdfColors.grey600,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

String _reportCommitteeLabel(GetInwentaryzacjaDetailsKomisjaItem member) {
  final normalized = member.displayName.trim();
  if (normalized.isEmpty) {
    return 'Użytkownik ${member.userId}';
  }
  return normalized;
}

String _committeeNamesLabel(
  GetInwentaryzacjaDetailsResponseData inventoryDetails,
) {
  final names = inventoryDetails.komisja
      .map(_reportCommitteeLabel)
      .toList(growable: false);
  if (names.isEmpty) {
    return 'Brak';
  }
  return names.join(', ');
}

String _reportDocumentTitle(
  InventoryReportDefinition definition, {
  int? index,
}) {
  final numberedBundleTitles = <InwentaryzacjaReportType, String>{
    InwentaryzacjaReportType.braki: '1. Braki inwentaryzacyjne',
    InwentaryzacjaReportType.nadwyzki: '2. Nadwyżki inwentaryzacyjne',
    InwentaryzacjaReportType.kompensaty: '3. Kompensaty',
    InwentaryzacjaReportType.elementyDoLikwidacji: '4. Kasacje',
    InwentaryzacjaReportType.brakiNieskompensowane:
        '5. Braki inwentaryzacyjne nieskompensowane',
    InwentaryzacjaReportType.nadwyzkiNieskompensowane:
        '6. Nadwyżki inwentaryzacyjne nieskompensowane',
  };

  if (index != null) {
    return numberedBundleTitles[definition.type] ?? definition.documentTitle;
  }

  return definition.documentTitle;
}

String _formatDateTime(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return 'Brak';
  }
  try {
    return DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(normalized));
  } catch (_) {
    return normalized;
  }
}

String _formatOptionalDate(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return 'Brak';
  }
  try {
    return DateFormat('dd.MM.yyyy').format(DateTime.parse(normalized));
  } catch (_) {
    return normalized;
  }
}

String _normalizeReportText(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return 'Brak';
  }
  return normalized;
}

double _parseDecimal(String? value) {
  final normalized = value
      ?.trim()
      .replaceAll(RegExp(r'\s+'), '')
      .replaceAll(',', '.');
  if (normalized == null || normalized.isEmpty) {
    return 0;
  }
  return double.tryParse(normalized) ?? 0;
}

String _formatDecimal(double value) {
  return NumberFormat('0.00').format(value);
}

String? _reportBarcodeValue(GetInwentaryzacjaReportElementItem item) {
  final newBarcode = item.nowyKodKreskowy?.trim();
  if (newBarcode != null && newBarcode.isNotEmpty) {
    return newBarcode;
  }
  return item.kodKreskowy?.toString();
}

String? _reportDisplayName(GetInwentaryzacjaReportElementItem item) {
  final newName = item.nowaNazwa?.trim();
  if (newName != null && newName.isNotEmpty) {
    return newName;
  }
  return item.nazwa;
}

String? _reportDisplayPerson(GetInwentaryzacjaReportElementItem item) {
  final newPerson = item.nowaOsoba?.trim();
  if (newPerson != null && newPerson.isNotEmpty) {
    return newPerson;
  }
  return item.osoba;
}

String? _reportDisplayPlace(GetInwentaryzacjaReportElementItem item) {
  final foundPlace = item.nadwMiejsce?.trim();
  if (foundPlace != null && foundPlace.isNotEmpty) {
    return foundPlace;
  }
  return item.miejsce;
}
