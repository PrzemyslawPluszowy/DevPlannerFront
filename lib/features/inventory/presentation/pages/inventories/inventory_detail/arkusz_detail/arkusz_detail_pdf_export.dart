import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';

const _pdfBaseFontSize = 9.0;
const _pdfSmallFontSize = 7.5;
const _pdfSectionTitleFontSize = 10.0;
const _pdfDocumentTitleFontSize = 15.0;

/// Buduje dokument PDF dla pojedynczego arkusza spisu.
Future<Uint8List> buildArkuszPdfDocument({
  required String arkuszNumber,
  required GetArkuszDetailsResponseData data,
  List<String>? selectedResponsiblePeople,
}) async {
  final document = pw.Document();
  final regularFont = await fontFromAssetBundle(
    'assets/pdf_fonts/Lato-Regular.ttf',
  );
  final boldFont = await fontFromAssetBundle(
    'assets/pdf_fonts/Lato-Bold.ttf',
  );
  final italicFont = await fontFromAssetBundle(
    'assets/pdf_fonts/Lato-Italic.ttf',
  );
  final visibleItems = data.elementy
      .where(
        (item) =>
            item.statusSpisu != ArkuszElementStatusSpisu.znalezionyWInnejFirmie,
      )
      .toList(growable: false);
  final committeeNames = data.komisja
      .map(_committeeLabel)
      .toList(growable: false);
  final responsiblePeople = selectedResponsiblePeople == null
      ? _collectResponsiblePeople(visibleItems)
      : _normalizeResponsiblePeople(selectedResponsiblePeople);

  document.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(26, 22, 26, 38),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
          italic: italicFont,
        ),
      ),
      footer: (context) => _buildFooter(
        committeeNames: committeeNames,
        pageNumber: context.pageNumber,
        pagesCount: context.pagesCount,
      ),
      build: (context) => [
        _buildHeader(
          arkuszNumber: arkuszNumber,
          data: data,
        ),
        pw.SizedBox(height: 12),
        _buildElementsTable(visibleItems),
        pw.SizedBox(height: 16),
        _buildFinalStatement(
          committeeNames: committeeNames,
          responsiblePeople: responsiblePeople,
          lastLp: visibleItems.length,
        ),
      ],
    ),
  );

  return document.save();
}

String buildArkuszPdfFilename({
  required String arkuszNumber,
}) {
  final normalized = arkuszNumber
      .trim()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '-');
  final safeNumber = normalized.isEmpty ? 'arkusz' : normalized;
  final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  return 'arkusz_spisu_${safeNumber}_$timestamp.pdf';
}

pw.Widget _buildHeader({
  required String arkuszNumber,
  required GetArkuszDetailsResponseData data,
}) {
  final header = data.arkusz;
  final details = [
    ('Rozpoczęto', _formatDateTime(header.rozpoczecie)),
    ('Zakończono', _formatDateTime(header.zakonczenie)),
    ('Miejsce', _normalizeText(header.nazwaMiejsca)),
  ];

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey700, width: .8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'ARKUSZ SPISU $arkuszNumber',
              style: const pw.TextStyle(
                fontSize: _pdfDocumentTitleFontSize,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: .5,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              _normalizeText(header.nazwaMiejsca),
              style: const pw.TextStyle(fontSize: _pdfSectionTitleFontSize),
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: _buildMetaSection(
              title: 'Dane arkusza',
              children: details
                  .map((entry) => _buildMetaLine(entry.$1, entry.$2))
                  .toList(growable: false),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: _buildMetaSection(
              title: 'Skład komisji inwentaryzacyjnej',
              children: data.komisja.isEmpty
                  ? [_buildBulletLine('Brak')]
                  : data.komisja
                        .map(
                          (member) => _buildBulletLine(_committeeLabel(member)),
                        )
                        .toList(growable: false),
            ),
          ),
        ],
      ),
    ],
  );
}

pw.Widget _buildMetaSection({
  required String title,
  required List<pw.Widget> children,
}) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 10),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey500, width: .6),
      color: PdfColors.grey100,
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: _pdfSectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        ...children,
      ],
    ),
  );
}

pw.Widget _buildMetaLine(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 3),
    child: pw.RichText(
      text: pw.TextSpan(
        style: const pw.TextStyle(fontSize: _pdfBaseFontSize),
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

pw.Widget _buildBulletLine(String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 3),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '• ',
          style: const pw.TextStyle(fontSize: _pdfBaseFontSize),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: _pdfBaseFontSize),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildElementsTable(List<GetArkuszDetailsElementItem> items) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Table(
        border: _buildElementsTableBorder(showTop: true),
        columnWidths: _elementsTableColumnWidths,
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [_buildHeaderRow()],
      ),
      ...items.indexed.expand((indexed) {
        final lp = indexed.$1 + 1;
        final item = indexed.$2;
        return [
          pw.Table(
            border: _buildElementsTableBorder(),
            columnWidths: _elementsTableColumnWidths,
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              _buildDataRow(
                values: [
                  '$lp',
                  _normalizeText(item.nrewid),
                  _normalizeText(_barcodeValue(item)),
                  _formatOptionalDate(item.dataZakupu),
                  _normalizeText(_currentName(item)),
                  _normalizeText(_responsiblePersonForTable(item)),
                  _stanValue(item),
                  _surplusValue(item),
                  if (item.isLiquidated) 'Tak' else 'Nie',
                ],
              ),
            ],
          ),
          if (_shouldRenderTransferNote(item))
            _buildTransferNoteRow(item, lp: lp),
        ];
      }),
    ],
  );
}

const _elementsTableColumnWidths = <int, pw.TableColumnWidth>{
  0: pw.FixedColumnWidth(24),
  1: pw.FixedColumnWidth(58),
  2: pw.FixedColumnWidth(62),
  3: pw.FixedColumnWidth(56),
  4: pw.FlexColumnWidth(2.0),
  5: pw.FlexColumnWidth(1.45),
  6: pw.FixedColumnWidth(34),
  7: pw.FixedColumnWidth(74),
  8: pw.FixedColumnWidth(48),
};

pw.TableBorder _buildElementsTableBorder({bool showTop = false}) {
  const side = pw.BorderSide(
    color: PdfColors.grey700,
    width: .6,
  );
  return pw.TableBorder(
    left: side,
    right: side,
    bottom: side,
    top: showTop ? side : pw.BorderSide.none,
    verticalInside: side,
    horizontalInside: side,
  );
}

pw.TableRow _buildHeaderRow() {
  const labels = [
    'Lp',
    'Nr ewid.',
    'Kod kreskowy',
    'Data zakupu',
    'Nazwa środka trwałego',
    'Osoba odpowiedzialna',
    'Stan 1/0',
    'Nadwyżka',
    'Do likwidacji',
  ];

  return pw.TableRow(
    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
    children: labels
        .map(
          (label) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 5,
            ),
            child: pw.Text(
              label,
              style: const pw.TextStyle(
                fontSize: _pdfSmallFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
        )
        .toList(growable: false),
  );
}

pw.TableRow _buildDataRow({
  required List<String> values,
}) {
  const style = pw.TextStyle(
    fontSize: _pdfBaseFontSize,
  );
  return pw.TableRow(
    children: values.indexed
        .map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 5,
            ),
            child: pw.Text(
              entry.$2,
              style: style,
              textAlign: entry.$1 == 6
                  ? pw.TextAlign.center
                  : pw.TextAlign.left,
            ),
          ),
        )
        .toList(growable: false),
  );
}

pw.Widget _buildTransferNoteRow(
  GetArkuszDetailsElementItem item, {
  required int lp,
}) {
  final itemName = _normalizeText(_currentName(item));
  final recipientName = _normalizeText(item.nowaOsoba);
  final evidNumber = _normalizeText(item.nrewid);

  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.fromLTRB(12, 9, 12, 10),
    decoration: const pw.BoxDecoration(
      color: PdfColors.grey100,
      border: pw.Border(
        left: pw.BorderSide(color: PdfColors.grey700, width: .6),
        right: pw.BorderSide(color: PdfColors.grey700, width: .6),
        bottom: pw.BorderSide(color: PdfColors.grey700, width: .6),
      ),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
                borderRadius: pw.BorderRadius.all(
                  pw.Radius.circular(2),
                ),
              ),
              child: pw.Text(
                'LP $lp',
                style: const pw.TextStyle(
                  fontSize: _pdfSmallFontSize,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: .2,
                ),
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Przekazanie środka trwałego',
                    style: const pw.TextStyle(
                      fontSize: _pdfBaseFontSize,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    '$itemName • nr ewid. $evidNumber',
                    style: const pw.TextStyle(
                      fontSize: _pdfSmallFontSize,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.RichText(
          text: pw.TextSpan(
            style: const pw.TextStyle(fontSize: _pdfBaseFontSize),
            children: [
              const pw.TextSpan(
                text: 'Imię i nazwisko osoby przyjmującej: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.TextSpan(
                text: recipientName,
                style: const pw.TextStyle(fontStyle: pw.FontStyle.italic),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 7),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    height: 16,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.grey700,
                          width: .6,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'potwierdzenie odbioru',
                    style: const pw.TextStyle(
                      fontSize: 6.5,
                      color: PdfColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _buildFinalStatement({
  required List<String> committeeNames,
  required List<String> responsiblePeople,
  required int lastLp,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      _buildStatementSection(
        title: 'Oświadczenie końcowe',
        children: [
          pw.Text(
            'Spis zakończono po pozycji lp $lastLp.',
            style: const pw.TextStyle(
              fontSize: _pdfBaseFontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Nie zgłaszam zastrzeżeń do ustaleń komisji.',
            style: const pw.TextStyle(fontSize: _pdfBaseFontSize),
          ),
        ],
      ),
      pw.SizedBox(height: 12),
      _buildSignatureSection(
        title: 'Podpisy członków komisji',
        names: committeeNames,
      ),
      pw.SizedBox(height: 12),
      _buildSignatureSection(
        title: 'Podpisy osób odpowiedzialnych',
        names: responsiblePeople,
      ),
    ],
  );
}

pw.Widget _buildStatementSection({
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
            fontSize: _pdfSectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        ...children,
      ],
    ),
  );
}

pw.Widget _buildSignatureSection({
  required String title,
  required List<String> names,
}) {
  final rows = names.isEmpty
      ? const ['................................']
      : names;

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
            fontSize: _pdfSectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        ...rows.map(
          (name) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    name,
                    style: const pw.TextStyle(fontSize: _pdfBaseFontSize),
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.Container(
                  width: 180,
                  alignment: pw.Alignment.center,
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.grey700,
                        width: .6,
                      ),
                    ),
                  ),
                  padding: const pw.EdgeInsets.only(bottom: 2),
                  child: pw.Text(
                    'podpis',
                    style: const pw.TextStyle(
                      fontSize: 6.5,
                      color: PdfColors.grey500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildFooter({
  required List<String> committeeNames,
  required int pageNumber,
  required int pagesCount,
}) {
  final footerNames = committeeNames.isEmpty
      ? 'Komisja: brak'
      : 'Komisja: ${committeeNames.join(', ')}';
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Expanded(
        child: pw.Text(
          'Podpisy członków komisji: $footerNames',
          style: const pw.TextStyle(fontSize: _pdfSmallFontSize),
          maxLines: 2,
        ),
      ),
      pw.SizedBox(width: 12),
      pw.Text(
        '$pageNumber/$pagesCount',
        style: const pw.TextStyle(fontSize: _pdfBaseFontSize),
      ),
    ],
  );
}

String _committeeLabel(GetArkuszDetailsKomisjaItem member) {
  final normalized = member.displayName.trim();
  if (normalized.isEmpty) {
    return 'Użytkownik ${member.userId}';
  }

  return normalized;
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
    return DateFormat('yyyy-MM-dd').format(DateTime.parse(normalized));
  } catch (_) {
    return normalized;
  }
}

String _normalizeText(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return 'Brak';
  }

  return normalized;
}

String _barcodeValue(GetArkuszDetailsElementItem item) {
  return item.nowyKodKreskowy?.trim().isNotEmpty == true
      ? item.nowyKodKreskowy!
      : item.kodKreskowy?.toString() ?? '';
}

String _currentName(GetArkuszDetailsElementItem item) {
  return item.nowaNazwa?.trim().isNotEmpty == true
      ? item.nowaNazwa!
      : item.nazwa ?? '';
}

String _responsiblePersonForTable(GetArkuszDetailsElementItem item) {
  return item.osoba?.trim().isNotEmpty == true
      ? item.osoba!
      : item.nowaOsoba ?? '';
}

String _stanValue(GetArkuszDetailsElementItem item) {
  return switch (item.inventoryStatus) {
    null || ArkuszElementInwentStatus.brak => '0',
    ArkuszElementInwentStatus.zgodny ||
    ArkuszElementInwentStatus.przeniesiony => '1',
  };
}

String _surplusValue(GetArkuszDetailsElementItem item) {
  if (!item.hasSurplus) {
    return 'Brak';
  }

  final sameDepartment =
      item.nadwIdmiejsce != null &&
      item.idmiejsce != null &&
      item.nadwIdmiejsce == item.idmiejsce;

  return sameDepartment ? 'W tym samym dziale' : 'W innym dziale';
}

bool _shouldRenderTransferNote(GetArkuszDetailsElementItem item) {
  final newPerson = _normalizeOptionalText(item.nowaOsoba);
  if (newPerson == null) {
    return false;
  }

  final currentPerson = _normalizeOptionalText(item.osoba);
  return currentPerson == null || currentPerson != newPerson;
}

List<String> _collectResponsiblePeople(
  List<GetArkuszDetailsElementItem> items,
) {
  final uniquePeople = <String>{};

  for (final item in items) {
    final normalized = _normalizeOptionalText(
      _responsiblePersonForSignature(item),
    );
    if (normalized == null) {
      continue;
    }
    uniquePeople.add(normalized);
  }

  return uniquePeople.toList(growable: false)..sort();
}

List<String> _normalizeResponsiblePeople(List<String> names) {
  final uniquePeople = <String>{};

  for (final name in names) {
    final normalized = _normalizeOptionalText(name);
    if (normalized == null) {
      continue;
    }
    uniquePeople.add(normalized);
  }

  return uniquePeople.toList(growable: false)..sort();
}

/// Zbiera unikalne osoby odpowiedzialne do sekcji podpisów w PDF.
List<String> collectResponsiblePeopleForSignatures(
  List<GetArkuszDetailsElementItem> items,
) => _collectResponsiblePeople(items);

String? _responsiblePersonForSignature(GetArkuszDetailsElementItem item) {
  if (_shouldRenderTransferNote(item)) {
    return item.nowaOsoba;
  }

  return item.osoba?.trim().isNotEmpty == true ? item.osoba : item.nowaOsoba;
}

String? _normalizeOptionalText(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  if (normalized.toLowerCase() == 'brak') {
    return null;
  }

  return normalized;
}
