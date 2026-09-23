import 'package:equatable/equatable.dart';

/// Link rozpoznany przez backend w treści wiadomości.
///
/// Parser serwera jest źródłem adresu i decyzji o podglądzie. Klient nie
/// wyciąga arbitralnych adresów z tekstu ani nie próbuje pobierać ich sam.
final class ChatMessageLink extends Equatable {
  /// Tworzy link zwrócony razem z wiadomością.
  const ChatMessageLink({
    required this.url,
    required this.isHttps,
    required this.isInternal,
    required this.previewAllowed,
    this.host,
  });

  /// Dokładny adres wskazany przez backend.
  final String url;

  /// Host do czytelnej etykiety, jeżeli backend go zwrócił.
  final String? host;

  final bool isHttps;
  final bool isInternal;
  final bool previewAllowed;

  @override
  List<Object?> get props => [url, host, isHttps, isInternal, previewAllowed];
}
