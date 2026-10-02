/// Nazwy i typy eksportów dokumentu; niezależne od stanu sesji i transportu.
final class StorageOfficeExportNames {
  const StorageOfficeExportNames(this.originalFileName, this.extension);

  final String originalFileName;
  final String extension;

  String get stem {
    final dot = originalFileName.lastIndexOf('.');
    return dot > 0 ? originalFileName.substring(0, dot) : originalFileName;
  }

  String copyFileName(String fileType, String? suggestedTitle) {
    final cleanFileType = fileType.isNotEmpty
        ? fileType
        : extension.replaceFirst('.', '');
    final title = suggestedTitle?.trim();
    final defaultName = '$stem (kopia).$cleanFileType';
    final candidate = title == null || title.isEmpty ? defaultName : title;
    return candidate.endsWith('.$cleanFileType')
        ? candidate
        : '$candidate.$cleanFileType';
  }

  static String mimeType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.docx')) {
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }
    if (lower.endsWith('.xlsx')) {
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }
    if (lower.endsWith('.pptx')) {
      return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    }
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.txt')) return 'text/plain';
    return 'application/octet-stream';
  }
}
