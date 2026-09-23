import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/chat_emoji_catalog.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Otwiera wspólny picker emoji i zwraca wybrany znak albo `null`.
///
/// Picker jest jeden dla composera, reakcji i statusu, więc wyszukiwanie,
/// kategorie i odcienie działają identycznie w całym komunikatorze.
Future<String?> showChatEmojiPicker(
  BuildContext context, {
  ChatEmojiRecentCubit? recent,
  GlobalKey? anchorKey,
}) async {
  if (anchorKey == null) {
    return DevPlannerModalHost.showDialog<String>(
      context,
      builder: (_) => _ChatEmojiPickerDialog(recent: recent),
    );
  }

  final renderObject = anchorKey.currentContext?.findRenderObject();
  if (renderObject is! RenderBox || !renderObject.hasSize) return null;

  final anchorRect =
      renderObject.localToGlobal(Offset.zero) & renderObject.size;
  final viewport = Offset.zero & MediaQuery.sizeOf(context);
  final chat = context.chatTheme;
  return showMenu<String>(
    context: context,
    useRootNavigator: true,
    position: RelativeRect.fromRect(anchorRect, viewport),
    color: chat.panelSurface,
    elevation: 16,
    constraints: const BoxConstraints(minWidth: 360, maxWidth: 384),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(chat.composerRadius),
      side: BorderSide(color: chat.separator.withValues(alpha: .8)),
    ),
    items: <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        enabled: false,
        height: 364,
        padding: EdgeInsets.zero,
        child: _ChatEmojiPickerDialog(recent: recent, compact: true),
      ),
    ],
  );
}

class _ChatEmojiPickerDialog extends StatefulWidget {
  const _ChatEmojiPickerDialog({this.recent, this.compact = false});

  final ChatEmojiRecentCubit? recent;
  final bool compact;

  @override
  State<_ChatEmojiPickerDialog> createState() => _ChatEmojiPickerDialogState();
}

class _ChatEmojiPickerDialogState extends State<_ChatEmojiPickerDialog> {
  /// Bok komórki siatki; specyfikacja wymaga minimum 36.
  static const double _cellSize = 40;

  final TextEditingController _query = TextEditingController();
  ChatEmojiCategory _category = ChatEmojiCategory.people;
  int _tone = 0;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<ChatEmojiEntry> get _entries {
    final needle = _query.text.trim();
    if (needle.isNotEmpty) return ChatEmojiCatalog.search(needle);
    if (_category == ChatEmojiCategory.recent) return _recentEntries;
    return ChatEmojiCatalog.byCategory[_category] ?? const <ChatEmojiEntry>[];
  }

  List<ChatEmojiEntry> get _recentEntries {
    final remembered = widget.recent?.state ?? const <String>[];
    return <ChatEmojiEntry>[
      for (final emoji in remembered)
        ChatEmojiCatalog.all.firstWhere(
          (entry) => entry.emoji == emoji,
          orElse: () => ChatEmojiEntry(emoji, emoji),
        ),
    ];
  }

  void _select(ChatEmojiEntry entry) {
    final emoji = ChatEmojiSkinTone.apply(entry, _tone);
    widget.recent?.remember(emoji);
    Navigator.of(context).pop(emoji);
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final entries = _entries;
    final categories = <ChatEmojiCategory>[
      if (_recentEntries.isNotEmpty) ChatEmojiCategory.recent,
      ...ChatEmojiCategory.values.where(
        (category) => category != ChatEmojiCategory.recent,
      ),
    ];
    final content = SizedBox(
      height: 340,
      child: Column(
        children: [
          TextField(
            controller: _query,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            style: chat.contentStyle.copyWith(color: chat.incomingText),
            decoration: InputDecoration(
              hintText: context.l10n.chatEmojiSearchHint,
              hintStyle: chat.contentStyle.copyWith(
                color: chat.metadataText,
              ),
              prefixIcon: Icon(
                Symbols.search,
                size: 18,
                color: chat.metadataText,
              ),
              filled: true,
              fillColor: chat.composerSurface,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: chat.separator),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: chat.separator),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: chat.focusRing),
              ),
            ),
          ),
          const SizedBox(height: Sizes.p8),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: Sizes.p4),
              itemBuilder: (context, index) {
                final category = categories[index];
                final active =
                    _query.text.trim().isEmpty && category == _category;
                return TextButton(
                  onPressed: () => setState(() => _category = category),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p8,
                    ),
                    foregroundColor: active
                        ? chat.focusRing
                        : chat.metadataText,
                    backgroundColor: active ? chat.selectedSurface : null,
                  ),
                  child: Text(
                    _categoryLabel(context, category),
                    style: chat.metadataStyle,
                  ),
                );
              },
            ),
          ),
          Divider(height: Sizes.p12, color: chat.separator),
          Expanded(
            child: entries.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.chatEmojiEmpty,
                      style: chat.metadataStyle.copyWith(
                        color: chat.metadataText,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(Sizes.p4),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: _cellSize,
                          mainAxisSpacing: Sizes.p2,
                          crossAxisSpacing: Sizes.p2,
                        ),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Tooltip(
                        message: entry.name,
                        child: InkWell(
                          onTap: () => _select(entry),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              ChatEmojiSkinTone.apply(entry, _tone),
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Divider(height: Sizes.p12, color: chat.separator),
          SizedBox(
            height: 36,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.chatEmojiSkinTone,
                    style: chat.metadataStyle.copyWith(
                      color: chat.metadataText,
                    ),
                  ),
                ),
                for (var index = 0; index < 6; index++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p2,
                    ),
                    child: InkWell(
                      key: ValueKey<String>('chat-emoji-tone-$index'),
                      onTap: () => setState(() => _tone = index),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _toneColor(index),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _tone == index
                                ? chat.focusRing
                                : chat.separator,
                            width: _tone == index ? 2 : 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (widget.compact) {
      return Theme(
        data: chat.applyControls(Theme.of(context)),
        child: SizedBox(
          width: 360,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p12),
            child: content,
          ),
        ),
      );
    }
    return ChatSurfaceDialog(
      title: context.l10n.chatComposerEmoji,
      maxWidth: 384,
      content: content,
    );
  }

  static String _categoryLabel(
    BuildContext context,
    ChatEmojiCategory category,
  ) => switch (category) {
    ChatEmojiCategory.recent => context.l10n.chatEmojiRecent,
    ChatEmojiCategory.people => context.l10n.chatEmojiCategoryPeople,
    ChatEmojiCategory.nature => context.l10n.chatEmojiCategoryNature,
    ChatEmojiCategory.food => context.l10n.chatEmojiCategoryFood,
    ChatEmojiCategory.activity => context.l10n.chatEmojiCategoryActivity,
    ChatEmojiCategory.travel => context.l10n.chatEmojiCategoryTravel,
    ChatEmojiCategory.objects => context.l10n.chatEmojiCategoryObjects,
    ChatEmojiCategory.symbols => context.l10n.chatEmojiCategorySymbols,
  };

  /// Kolor próbki odcienia; pierwszy wariant jest neutralny (bez modyfikatora).
  static Color _toneColor(int index) => switch (index) {
    0 => const Color(0xfff1c27d),
    1 => const Color(0xffffd8b1),
    2 => const Color(0xffe8b88a),
    3 => const Color(0xffc68d5c),
    4 => const Color(0xffa16b3f),
    5 => const Color(0xff6f4a2c),
    _ => const Color(0xfff1c27d),
  };
}

/// Szybkie reakcje pod dymkiem z wejściem do pełnego pickera.
class ChatEmojiQuickReactions extends StatelessWidget {
  /// Tworzy pasek szybkich reakcji.
  const ChatEmojiQuickReactions({
    required this.onSelected,
    this.selected = const <String>{},
    super.key,
  });

  /// Reakcja wybrana przez użytkownika; własna reakcja jest wyróżniona.
  final Set<String> selected;

  /// Wywoływane z emoji i informacją, czy użytkownik już je dodał.
  final void Function(String emoji, bool isOwn) onSelected;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Wrap(
      spacing: Sizes.p4,
      children: [
        for (final emoji in ChatEmojiCatalog.quickReactions)
          InkWell(
            key: ValueKey<String>('chat-quick-reaction-$emoji'),
            onTap: () => onSelected(emoji, selected.contains(emoji)),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p8,
                vertical: Sizes.p4,
              ),
              decoration: BoxDecoration(
                color: selected.contains(emoji)
                    ? chat.selectedSurface
                    : chat.hoverSurface,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
          ),
      ],
    );
  }
}
