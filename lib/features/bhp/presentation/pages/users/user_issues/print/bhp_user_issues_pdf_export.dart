import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/l10n/app_localizations.dart';

/// Formatuje datę ze Stringa na format dd.MM.yyyy.
String _formatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) {
    return '—';
  }
  try {
    final parsed = DateTime.tryParse(dateStr);
    if (parsed == null) {
      return dateStr;
    }
    return DateFormat('dd.MM.yyyy').format(parsed);
  } catch (_) {
    return dateStr;
  }
}

/// Buduje dokument PDF przedstawiający zbiorczą Kartę Wyposażenia BHP pracownika.
Future<Uint8List> buildBhpUserIssuesCardPdf({
  required AppLocalizations l10n,
  required GetBhpUserListItem user,
  required GetBhpUserDetail detail,
  required List<GetBhpUserIssue> items,
}) async {
  final pdf = pw.Document();

  final regularFont = await fontFromAssetBundle(
    'assets/pdf_fonts/Lato-Regular.ttf',
  );
  final boldFont = await fontFromAssetBundle('assets/pdf_fonts/Lato-Bold.ttf');
  final italicFont = await fontFromAssetBundle(
    'assets/pdf_fonts/Lato-Italic.ttf',
  );

  final pageTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 36),
    theme: pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
      italic: italicFont,
    ),
  );

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      header: (context) => _buildCardHeader(
        title: l10n.bhpUserIssuesPdfTitle,
        user: user,
        detail: detail,
        l10n: l10n,
      ),
      footer: (context) => _buildFooter(l10n, context),
      build: (context) => [
        pw.SizedBox(height: 15),
        _buildCardTable(l10n, items),
        pw.SizedBox(height: 40),
        _buildCardSignatures(
          leftLabel: l10n.bhpUserIssuesPdfIssuerSignatureLabel,
          rightLabel: l10n.bhpUserIssuesPdfEmployeeSignatureLabel,
          disclaimer: l10n.bhpUserIssuesPdfDisclaimer,
        ),
      ],
    ),
  );

  return pdf.save();
}

pw.Widget _buildCardHeader({
  required String title,
  required GetBhpUserListItem user,
  required GetBhpUserDetail detail,
  required AppLocalizations l10n,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(title),
      pw.SizedBox(height: 10),
      pw.Text(user.fullName),
      pw.SizedBox(height: 8),
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey400, width: .5),
        columnWidths: const {
          0: pw.FlexColumnWidth(),
          1: pw.FlexColumnWidth(),
          2: pw.FlexColumnWidth(),
          3: pw.FlexColumnWidth(),
          4: pw.FlexColumnWidth(),
        },
        children: [
          _buildHeaderRow([
            l10n.bhpUserIssuesPdfHeightLabel,
            l10n.bhpUserIssuesPdfChestLabel,
            l10n.bhpUserIssuesPdfWaistLabel,
            l10n.bhpUserIssuesPdfHeadLabel,
            l10n.bhpUserIssuesPdfFootLabel,
          ]),
          _buildHeaderRow([
            detail.wzrost ?? '—',
            detail.obwodKlatkiPiers ?? '—',
            detail.obwodPasa ?? '—',
            detail.obwodGlowy ?? '—',
            detail.dlStopy ?? '—',
          ]),
        ],
      ),
    ],
  );
}

pw.Widget _buildCardTable(AppLocalizations l10n, List<GetBhpUserIssue> items) {
  return pw.TableHelper.fromTextArray(
    headers: [
      l10n.bhpTableSymbol,
      l10n.bhpTableEquipmentName,
      l10n.bhpTableIssueDate,
    ],
    data: items
        .map(
          (item) => [
            item.kartaWyposazeniaSymbol ?? '—',
            item.kartaWyposazeniaNazwa ?? '—',
            _formatDate(item.dataPrzydzialu),
          ],
        )
        .toList(growable: false),
  );
}

pw.TableRow _buildHeaderRow(List<String> values) {
  return pw.TableRow(
    children: values
        .map(
          (value) => pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(value),
          ),
        )
        .toList(growable: false),
  );
}

pw.Widget _buildCardSignatures({
  required String leftLabel,
  required String rightLabel,
  required String disclaimer,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(disclaimer),
      pw.SizedBox(height: 24),
      pw.Row(
        children: [
          pw.Expanded(child: pw.Text(leftLabel)),
          pw.SizedBox(width: 24),
          pw.Expanded(child: pw.Text(rightLabel)),
        ],
      ),
    ],
  );
}

pw.Widget _buildFooter(AppLocalizations l10n, pw.Context context) {
  return pw.Align(
    alignment: pw.Alignment.centerRight,
    child: pw.Text(
      l10n.bhpUserIssuesPdfPageLabel(context.pageNumber, context.pagesCount),
    ),
  );
}
