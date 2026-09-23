import 'package:equatable/equatable.dart';

/// Sanitizowane metadane linku zwrócone przez backend.
final class ChatLinkPreview extends Equatable {
  /// Tworzy podgląd zapisany w serwerowej polityce linków.
  const ChatLinkPreview({
    required this.finalUrl,
    required this.fetchedAtUtc,
    this.title,
    this.description,
    this.contentType,
  });

  final String finalUrl;
  final String? title;
  final String? description;
  final String? contentType;
  final DateTime fetchedAtUtc;

  @override
  List<Object?> get props => [
    finalUrl,
    title,
    description,
    contentType,
    fetchedAtUtc,
  ];
}
