import 'package:devplanner/workspaces/presentation/chat/links/chat_external_link_port.dart';
import 'package:url_launcher/url_launcher.dart';

/// Adapter otwierania adresów w systemowej przeglądarce.
///
/// Adres jest parsowany i otwierany jako zewnętrzna aplikacja; błąd parsowania
/// albo odmowa systemu wraca jako `false`, więc UI nie zgłasza sukcesu.
final class ChatExternalLinkPortAdapter implements ChatExternalLinkPort {
  /// Tworzy adapter; `launcher` istnieje dla testów bez platformy.
  ChatExternalLinkPortAdapter({
    Future<bool> Function(Uri uri, LaunchMode mode)? launcher,
  }) : _launcher = launcher ?? ((uri, mode) => launchUrl(uri, mode: mode));

  final Future<bool> Function(Uri uri, LaunchMode mode) _launcher;

  @override
  Future<bool> open(String url) async {
    final trimmed = url.trim();
    // Adres z odstępem w środku jest literówką, a nie adresem: nie przekazujemy
    // go systemowi, nawet jeśli parser przyjmie jego fragment jako host.
    if (trimmed.isEmpty || trimmed.contains(RegExp(r'\s'))) return false;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return false;
    if (!uri.hasScheme || !(uri.isScheme('http') || uri.isScheme('https'))) {
      return false;
    }
    // System nie dostaje adresu bez hosta ani z odstępem w hoście, żeby literówka
    // nie otwierała przypadkowej strony.
    if (uri.host.isEmpty) return false;
    try {
      return await _launcher(uri, LaunchMode.externalApplication);
    } on Object {
      return false;
    }
  }
}
