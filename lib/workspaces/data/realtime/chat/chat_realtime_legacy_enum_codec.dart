/// Odtwarza tekstowe wartości starszych, utrwalonych payloadów outboxa.
///
/// Nowe eventy mają tekstowe enumy. Retencja może jednak zwracać eventy sprzed
/// zmiany serializera; ich wartości liczbowe mają znane, niezmienne ordinale C#.
abstract final class ChatRealtimeLegacyEnumCodec {
  static Object? normalize(String field, Object? value) {
    if (value is! int) return value;
    final values = switch (field) {
      'type' || 'conversationType' => const [
        'Direct',
        'Group',
        'Channel',
        'Broadcast',
        'Discussion',
      ],
      'scopeKind' => const ['Global', 'Workspace', 'Project', 'Resource'],
      'preference' => const ['All', 'MentionsOnly', 'Muted', 'HighOnly'],
      'status' => const ['Sending', 'Sent', 'Delivered', 'Read', 'Failed'],
      'scanStatus' => const ['Pending', 'Clean', 'Infected', 'Skipped'],
      'processingStatus' => const [
        'None',
        'Queued',
        'Processing',
        'Ready',
        'Failed',
      ],
      _ => null,
    };
    // Nieznana liczba nie jest zgadywana ani zastępowana domyślnym sukcesem.
    if (values == null || value < 0 || value >= values.length) return value;
    return values[value];
  }
}
