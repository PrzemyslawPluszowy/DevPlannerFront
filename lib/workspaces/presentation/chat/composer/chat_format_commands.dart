/// Akcje formatowania zaznaczenia w edytorze treści.
enum ChatFormatCommand {
  /// Pogrubienie.
  bold,

  /// Kursywa.
  italic,

  /// Przekreślenie.
  strike,

  /// Kod inline.
  inlineCode,

  /// Link do bezpiecznego adresu.
  link,

  /// Wyłączenie formatowania z zaznaczenia.
  clear,
}

/// Mapowanie akcji formatowania na atrybuty edytora.
///
/// Logika jest osobno, bez kontrolera i bez widgetów, żeby przełączanie
/// zaznaczenia dało się sprawdzić testem, a nie tylko klikając w UI.
abstract final class ChatFormatCommands {
  /// Klucze atrybutów Quill używane przez transport wiadomości.
  static const Map<ChatFormatCommand, String> attributeKeys =
      <ChatFormatCommand, String>{
        ChatFormatCommand.bold: 'bold',
        ChatFormatCommand.italic: 'italic',
        ChatFormatCommand.strike: 'strike',
        ChatFormatCommand.inlineCode: 'code',
        ChatFormatCommand.link: 'link',
      };

  /// Akcje pokazywane na pasku zaznaczenia, w kolejności prezentacji.
  static const List<ChatFormatCommand> selectionBar = <ChatFormatCommand>[
    ChatFormatCommand.bold,
    ChatFormatCommand.italic,
    ChatFormatCommand.strike,
    ChatFormatCommand.inlineCode,
    ChatFormatCommand.link,
    ChatFormatCommand.clear,
  ];

  /// Czy dany atrybut jest aktywny na zaznaczeniu.
  static bool isActive(
    ChatFormatCommand command,
    Map<String, dynamic> attributes,
  ) {
    final key = attributeKeys[command];
    if (key == null) return false;
    final value = attributes[key];
    return value != null && value != false;
  }

  /// Wartość do zastosowania; `null` usuwa atrybut.
  ///
  /// Akcja [ChatFormatCommand.link] wymaga niepustego adresu, a
  /// [ChatFormatCommand.clear] zawsze zdejmuje formatowanie, więc pasek nie
  /// udaje akcji, której nie da się wykonać.
  static Object? toggledValue(
    ChatFormatCommand command, {
    required bool currentlyActive,
    String? link,
  }) {
    switch (command) {
      case ChatFormatCommand.clear:
        return null;
      case ChatFormatCommand.link:
        final url = link?.trim();
        if (url == null || url.isEmpty) return null;
        return url;
      case ChatFormatCommand.bold:
      case ChatFormatCommand.italic:
      case ChatFormatCommand.strike:
      case ChatFormatCommand.inlineCode:
        return currentlyActive ? null : true;
    }
  }

  /// Czy adres linku nadaje się do zastosowania w zaznaczeniu.
  ///
  /// Nowy link musi być absolutnym HTTP/HTTPS, zgodnie z walidatorem backendu.
  /// Renderer historii może nadal bezpiecznie wyświetlić starsze ścieżki app.
  static bool isSafeLink(String? value) {
    final url = value?.trim();
    if (url == null || url.isEmpty) return false;
    final lower = url.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  /// Domyślnie proponowany schemat dla adresu bez protokołu.
  static String normalizeLink(String value) {
    final url = value.trim();
    if (url.isEmpty) return url;
    // Pozostaw ścieżki bez zmian, aby `isSafeLink` mógł je odrzucić jawnie.
    if (url.startsWith('/')) return url;
    final lower = url.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return url;
    }
    return 'https://$url';
  }
}

/// Akcje formatowania linii w rozbudowanym edytorze.
enum ChatLineFormatCommand {
  /// Lista punktowana.
  bulletList,

  /// Lista numerowana.
  orderedList,

  /// Cytat.
  quote,

  /// Blok kodu.
  codeBlock,
}

/// Mapowanie akcji linii na atrybuty akapitu.
///
/// Blok kodu i cytat są atrybutami linii, a listy niosą tekstową wartość
/// `bullet`/`ordered`, zgodną z backendem i rendererem historii. Mapowanie
/// musi być jawne — inaczej edytor
/// zapisałby atrybut, którego renderer historii nie rozpozna.
abstract final class ChatLineFormatCommands {
  /// Klucz atrybutu dla akcji; `list` jest wspólny dla obu list.
  static const Map<ChatLineFormatCommand, String> attributeKeys =
      <ChatLineFormatCommand, String>{
        ChatLineFormatCommand.bulletList: 'list',
        ChatLineFormatCommand.orderedList: 'list',
        ChatLineFormatCommand.quote: 'blockquote',
        ChatLineFormatCommand.codeBlock: 'code-block',
      };

  /// Akcje w kolejności prezentacji na pasku rozbudowanego edytora.
  static const List<ChatLineFormatCommand> toolbar = <ChatLineFormatCommand>[
    ChatLineFormatCommand.bulletList,
    ChatLineFormatCommand.orderedList,
    ChatLineFormatCommand.quote,
    ChatLineFormatCommand.codeBlock,
  ];

  /// Wartość do zastosowania; `null` usuwa atrybut linii.
  static Object? toggledValue(
    ChatLineFormatCommand command, {
    required bool currentlyActive,
  }) {
    if (currentlyActive) return null;
    return switch (command) {
      ChatLineFormatCommand.bulletList => 'bullet',
      ChatLineFormatCommand.orderedList => 'ordered',
      ChatLineFormatCommand.quote => true,
      ChatLineFormatCommand.codeBlock => true,
    };
  }

  /// Czy linia ma już dany atrybut; listy rozróżniamy po wartości.
  static bool isActive(
    ChatLineFormatCommand command,
    Map<String, dynamic> attributes,
  ) {
    final key = attributeKeys[command];
    if (key == null) return false;
    final value = attributes[key];
    if (value == null || value == false) return false;
    return switch (command) {
      ChatLineFormatCommand.bulletList => value == 'bullet',
      ChatLineFormatCommand.orderedList => value == 'ordered',
      ChatLineFormatCommand.quote || ChatLineFormatCommand.codeBlock => true,
    };
  }
}
