/// Kategorie wspólnego pickera emoji.
enum ChatEmojiCategory {
  /// Ostatnio użyte w tej sesji.
  recent,

  /// Twarze i gesty.
  people,

  /// Zwierzęta i przyroda.
  nature,

  /// Jedzenie i napoje.
  food,

  /// Aktywność i sport.
  activity,

  /// Podróże i miejsca.
  travel,

  /// Przedmioty i praca.
  objects,

  /// Symbole i znaczniki.
  symbols,
}

/// Pojedynczy wpis katalogu emoji.
///
/// `emoji` to kompletny grapheme cluster (z ZWJ, flagą albo wariantem odcienia),
/// więc UI nigdy nie tnie znaku na code unity.
final class ChatEmojiEntry {
  /// Tworzy wpis katalogu.
  const ChatEmojiEntry(
    this.emoji,
    this.name, {
    this.keywords = const <String>[],
    this.skinTones = false,
  });

  /// Znak emoji gotowy do wstawienia.
  final String emoji;

  /// Nazwa do wyszukiwania i etykiety dostępności.
  final String name;

  /// Dodatkowe słowa kluczowe (polskie i angielskie).
  final List<String> keywords;

  /// Czy znak wspiera warianty odcienia skóry.
  final bool skinTones;

  /// Czy wpis pasuje do zapytania; puste zapytanie pasuje do wszystkiego.
  bool matches(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;
    if (name.toLowerCase().contains(needle)) return true;
    for (final keyword in keywords) {
      if (keyword.toLowerCase().contains(needle)) return true;
    }
    return false;
  }
}

/// Warianty odcienia skóry wspierane tam, gdzie znak je ma.
abstract final class ChatEmojiSkinTone {
  /// Kolejne modyfikatory: domyślny, jasny, średni jasny, średni, średni ciemny, ciemny.
  static const List<String> modifiers = <String>[
    '',
    '\u{1F3FB}',
    '\u{1F3FC}',
    '\u{1F3FD}',
    '\u{1F3FE}',
    '\u{1F3FF}',
  ];

  /// Zwraca znak z wybranym wariantem odcienia.
  ///
  /// Wariant stosujemy tylko do wpisów, które go wspierają; inaczej zwracamy
  /// znak bazowy, żeby nie tworzyć niepoprawnego klastra.
  static String apply(ChatEmojiEntry entry, int toneIndex) {
    if (!entry.skinTones || toneIndex <= 0 || toneIndex >= modifiers.length) {
      return entry.emoji;
    }
    return '${entry.emoji}${modifiers[toneIndex]}';
  }
}

/// Kuratorowany katalog emoji wspólny dla composera, reakcji i statusu.
///
/// To lokalny zbiór najczęściej używanych znaków z nazwami i słowami
/// kluczowymi; nie zawiera pełnego Unicode, więc wyszukiwanie jest przewidywalne
/// i działa bez dodatkowej zależności i bez pobierania danych z sieci.
abstract final class ChatEmojiCatalog {
  /// Wpisy w kolejności prezentacji, podzielone po kategorii.
  static const Map<ChatEmojiCategory, List<ChatEmojiEntry>>
  byCategory = <ChatEmojiCategory, List<ChatEmojiEntry>>{
    ChatEmojiCategory.people: <ChatEmojiEntry>[
      ChatEmojiEntry('😀', 'uśmiech', keywords: ['smile', 'happy']),
      ChatEmojiEntry('😄', 'szeroki uśmiech', keywords: ['grin']),
      ChatEmojiEntry('😉', 'oczko', keywords: ['wink']),
      ChatEmojiEntry('😊', 'zadowolenie', keywords: ['blush']),
      ChatEmojiEntry('🙂', 'lekki uśmiech', keywords: ['slight smile']),
      ChatEmojiEntry('😎', 'okulary', keywords: ['cool', 'sunglasses']),
      ChatEmojiEntry('🤔', 'zamyślenie', keywords: ['thinking']),
      ChatEmojiEntry('😅', 'ulga', keywords: ['sweat', 'relief']),
      ChatEmojiEntry('😂', 'śmiech ze łzami', keywords: ['joy', 'laugh']),
      ChatEmojiEntry('🤣', 'beka', keywords: ['rofl']),
      ChatEmojiEntry('😍', 'zakochanie', keywords: ['love', 'heart eyes']),
      ChatEmojiEntry('🥳', 'impreza', keywords: ['party']),
      ChatEmojiEntry('😢', 'smutek', keywords: ['sad', 'cry']),
      ChatEmojiEntry('😭', 'płacz', keywords: ['sob']),
      ChatEmojiEntry('😮', 'zdziwienie', keywords: ['wow', 'surprise']),
      ChatEmojiEntry('😱', 'przerażenie', keywords: ['scream']),
      ChatEmojiEntry('😴', 'sen', keywords: ['sleep']),
      ChatEmojiEntry('🤯', 'eksplozja głowy', keywords: ['mind blown']),
      ChatEmojiEntry(
        '🤝',
        'uścisk dłoni',
        keywords: ['handshake'],
        skinTones: true,
      ),
      ChatEmojiEntry('👋', 'cześć', keywords: ['wave', 'hi'], skinTones: true),
      ChatEmojiEntry(
        '👍',
        'kciuk w górę',
        keywords: ['ok', 'thumbs up'],
        skinTones: true,
      ),
      ChatEmojiEntry(
        '👎',
        'kciuk w dół',
        keywords: ['thumbs down'],
        skinTones: true,
      ),
      ChatEmojiEntry('👌', 'ok', keywords: ['perfect'], skinTones: true),
      ChatEmojiEntry(
        '🙏',
        'proszę',
        keywords: ['please', 'thanks'],
        skinTones: true,
      ),
      ChatEmojiEntry('👏', 'brawa', keywords: ['clap'], skinTones: true),
      ChatEmojiEntry(
        '🙌',
        'podniesione ręce',
        keywords: ['raise'],
        skinTones: true,
      ),
      ChatEmojiEntry('💪', 'siła', keywords: ['strong'], skinTones: true),
      ChatEmojiEntry('🤙', 'zadzwoń', keywords: ['call me'], skinTones: true),
      ChatEmojiEntry('🤷', 'wzruszenie', keywords: ['shrug']),
      ChatEmojiEntry(
        '🙋',
        'zgłoszenie',
        keywords: ['raise hand'],
        skinTones: true,
      ),
      ChatEmojiEntry('👀', 'oczy', keywords: ['eyes', 'look']),
      ChatEmojiEntry('🧑‍💻', 'programista', keywords: ['developer', 'coder']),
    ],
    ChatEmojiCategory.nature: <ChatEmojiEntry>[
      ChatEmojiEntry('🔥', 'ogień', keywords: ['fire', 'hot']),
      ChatEmojiEntry('✨', 'iskry', keywords: ['sparkles']),
      ChatEmojiEntry('⭐', 'gwiazda', keywords: ['star']),
      ChatEmojiEntry('🌟', 'świecąca gwiazda', keywords: ['glow star']),
      ChatEmojiEntry('⚡', 'błyskawica', keywords: ['zap', 'lightning']),
      ChatEmojiEntry('☀️', 'słońce', keywords: ['sun']),
      ChatEmojiEntry('🌤️', 'słońce z chmurą', keywords: ['partly cloudy']),
      ChatEmojiEntry('🌧️', 'deszcz', keywords: ['rain']),
      ChatEmojiEntry('❄️', 'śnieżynka', keywords: ['snow']),
      ChatEmojiEntry('🌈', 'tęcza', keywords: ['rainbow']),
      ChatEmojiEntry('🌊', 'fala', keywords: ['wave', 'water']),
      ChatEmojiEntry('🌸', 'kwiat', keywords: ['flower', 'blossom']),
      ChatEmojiEntry('🌻', 'słonecznik', keywords: ['sunflower']),
      ChatEmojiEntry('🍀', 'koniczyna', keywords: ['lucky', 'clover']),
      ChatEmojiEntry('🌱', 'sadzonka', keywords: ['seedling']),
      ChatEmojiEntry('🌳', 'drzewo', keywords: ['tree']),
      ChatEmojiEntry('🐶', 'pies', keywords: ['dog']),
      ChatEmojiEntry('🐱', 'kot', keywords: ['cat']),
      ChatEmojiEntry('🐟', 'ryba', keywords: ['fish']),
      ChatEmojiEntry('🦄', 'jednorożec', keywords: ['unicorn']),
    ],
    ChatEmojiCategory.food: <ChatEmojiEntry>[
      ChatEmojiEntry('☕', 'kawa', keywords: ['coffee']),
      ChatEmojiEntry('🍵', 'herbata', keywords: ['tea']),
      ChatEmojiEntry('🍺', 'piwo', keywords: ['beer']),
      ChatEmojiEntry('🍕', 'pizza', keywords: ['pizza']),
      ChatEmojiEntry('🍔', 'burger', keywords: ['burger']),
      ChatEmojiEntry('🍟', 'frytki', keywords: ['fries']),
      ChatEmojiEntry('🌮', 'taco', keywords: ['taco']),
      ChatEmojiEntry('🍣', 'sushi', keywords: ['sushi']),
      ChatEmojiEntry('🥗', 'sałatka', keywords: ['salad']),
      ChatEmojiEntry('🍎', 'jabłko', keywords: ['apple']),
      ChatEmojiEntry('🍋', 'cytryna', keywords: ['lemon']),
      ChatEmojiEntry('🍓', 'truskawka', keywords: ['strawberry']),
      ChatEmojiEntry('🍫', 'czekolada', keywords: ['chocolate']),
      ChatEmojiEntry('🍩', 'pączek', keywords: ['donut']),
      ChatEmojiEntry('🎂', 'tort', keywords: ['cake', 'birthday']),
      ChatEmojiEntry('🍿', 'popcorn', keywords: ['popcorn']),
    ],
    ChatEmojiCategory.activity: <ChatEmojiEntry>[
      ChatEmojiEntry('✅', 'gotowe', keywords: ['check', 'done']),
      ChatEmojiEntry('❌', 'błąd', keywords: ['cross', 'no']),
      ChatEmojiEntry('⏰', 'alarm', keywords: ['alarm', 'clock']),
      ChatEmojiEntry('⏳', 'klepsydra', keywords: ['hourglass', 'wait']),
      ChatEmojiEntry('🚀', 'rakieta', keywords: ['rocket', 'launch']),
      ChatEmojiEntry('🎯', 'cel', keywords: ['target', 'goal']),
      ChatEmojiEntry('🏆', 'puchar', keywords: ['trophy', 'win']),
      ChatEmojiEntry('🎉', 'konfetti', keywords: ['tada', 'celebrate']),
      ChatEmojiEntry('🎊', 'fajerwerki', keywords: ['confetti']),
      ChatEmojiEntry('🎈', 'balon', keywords: ['balloon']),
      ChatEmojiEntry('🎵', 'nuta', keywords: ['music']),
      ChatEmojiEntry('🎮', 'gra', keywords: ['game']),
      ChatEmojiEntry('⚽', 'piłka', keywords: ['football', 'soccer']),
      ChatEmojiEntry('🏃', 'bieg', keywords: ['run'], skinTones: true),
      ChatEmojiEntry(
        '🧘',
        'medytacja',
        keywords: ['meditate'],
        skinTones: true,
      ),
      ChatEmojiEntry('🏋️', 'trening', keywords: ['gym', 'lift']),
    ],
    ChatEmojiCategory.travel: <ChatEmojiEntry>[
      ChatEmojiEntry('✈️', 'samolot', keywords: ['plane', 'flight']),
      ChatEmojiEntry('🚗', 'samochód', keywords: ['car']),
      ChatEmojiEntry('🚲', 'rower', keywords: ['bike']),
      ChatEmojiEntry('🚂', 'pociąg', keywords: ['train']),
      ChatEmojiEntry('🚢', 'statek', keywords: ['ship']),
      ChatEmojiEntry('🗺️', 'mapa', keywords: ['map']),
      ChatEmojiEntry('🏠', 'dom', keywords: ['home', 'house']),
      ChatEmojiEntry('🏢', 'biuro', keywords: ['office', 'building']),
      ChatEmojiEntry('🌍', 'świat', keywords: ['world', 'earth']),
      ChatEmojiEntry('🌙', 'księżyc', keywords: ['moon', 'night']),
      ChatEmojiEntry('📍', 'pinezka', keywords: ['pin', 'location']),
      ChatEmojiEntry('🗓️', 'kalendarz', keywords: ['calendar']),
    ],
    ChatEmojiCategory.objects: <ChatEmojiEntry>[
      ChatEmojiEntry('💻', 'laptop', keywords: ['laptop', 'computer']),
      ChatEmojiEntry('🖥️', 'komputer', keywords: ['desktop']),
      ChatEmojiEntry('📱', 'telefon', keywords: ['phone', 'mobile']),
      ChatEmojiEntry('⌨️', 'klawiatura', keywords: ['keyboard']),
      ChatEmojiEntry('🖱️', 'mysz', keywords: ['mouse']),
      ChatEmojiEntry('📝', 'notatka', keywords: ['note', 'memo']),
      ChatEmojiEntry('📌', 'pinezka', keywords: ['pushpin', 'pin']),
      ChatEmojiEntry('📎', 'spinacz', keywords: ['paperclip', 'attachment']),
      ChatEmojiEntry('📁', 'folder', keywords: ['folder']),
      ChatEmojiEntry('📄', 'dokument', keywords: ['document', 'file']),
      ChatEmojiEntry('📊', 'wykres', keywords: ['chart', 'stats']),
      ChatEmojiEntry('📈', 'wzrost', keywords: ['growth', 'up']),
      ChatEmojiEntry('📉', 'spadek', keywords: ['down', 'loss']),
      ChatEmojiEntry('🔍', 'lupa', keywords: ['search', 'zoom']),
      ChatEmojiEntry('🔒', 'zamek', keywords: ['lock', 'secure']),
      ChatEmojiEntry('🔑', 'klucz', keywords: ['key']),
      ChatEmojiEntry('💡', 'żarówka', keywords: ['idea', 'bulb']),
      ChatEmojiEntry('🛠️', 'narzędzia', keywords: ['tools', 'fix']),
      ChatEmojiEntry('🧪', 'test', keywords: ['test', 'lab']),
      ChatEmojiEntry('🐞', 'błąd', keywords: ['bug']),
      ChatEmojiEntry('🧹', 'porządki', keywords: ['clean', 'refactor']),
      ChatEmojiEntry('💰', 'pieniądze', keywords: ['money']),
    ],
    ChatEmojiCategory.symbols: <ChatEmojiEntry>[
      ChatEmojiEntry('❤️', 'serce', keywords: ['heart', 'love']),
      ChatEmojiEntry('💙', 'niebieskie serce', keywords: ['blue heart']),
      ChatEmojiEntry('💚', 'zielone serce', keywords: ['green heart']),
      ChatEmojiEntry('🧡', 'pomarańczowe serce', keywords: ['orange heart']),
      ChatEmojiEntry('💯', 'sto procent', keywords: ['hundred', 'perfect']),
      ChatEmojiEntry('❗', 'wykrzyknik', keywords: ['exclamation', 'important']),
      ChatEmojiEntry('❓', 'pytanie', keywords: ['question']),
      ChatEmojiEntry('⚠️', 'ostrzeżenie', keywords: ['warning']),
      ChatEmojiEntry('🚫', 'zakaz', keywords: ['no', 'forbidden']),
      ChatEmojiEntry('🔴', 'czerwone koło', keywords: ['red circle']),
      ChatEmojiEntry('🟡', 'żółte koło', keywords: ['yellow circle']),
      ChatEmojiEntry('🟢', 'zielone koło', keywords: ['green circle']),
      ChatEmojiEntry('🔵', 'niebieskie koło', keywords: ['blue circle']),
      ChatEmojiEntry('⬆️', 'w górę', keywords: ['up']),
      ChatEmojiEntry('⬇️', 'w dół', keywords: ['down']),
      ChatEmojiEntry('↩️', 'powrót', keywords: ['back']),
      ChatEmojiEntry('🔁', 'powtórzenie', keywords: ['repeat', 'retry']),
      ChatEmojiEntry('🕐', 'czas', keywords: ['time']),
    ],
  };

  /// Wszystkie wpisy katalogu w kolejności kategorii.
  static final List<ChatEmojiEntry> all = List<ChatEmojiEntry>.unmodifiable([
    for (final entries in byCategory.values) ...entries,
  ]);

  /// Wpisy pasujące do zapytania; puste zapytanie zwraca cały katalog.
  static List<ChatEmojiEntry> search(String query) {
    final needle = query.trim();
    if (needle.isEmpty) return all;
    return List<ChatEmojiEntry>.unmodifiable(
      all.where((entry) => entry.matches(needle)),
    );
  }

  /// Szybkie reakcje pokazywane przy dymku.
  static const List<String> quickReactions = <String>[
    '👍',
    '❤️',
    '😂',
    '🎉',
    '🙏',
    '✅',
  ];
}
