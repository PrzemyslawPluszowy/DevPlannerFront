import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wyszukiwalna lista rozmów docelowych osadzona w menu kontekstowym.
class ChatForwardTargetPicker extends StatefulWidget {
  const ChatForwardTargetPicker({
    required this.targets,
    required this.onSelected,
    super.key,
  });

  final List<ChatInboxItem> targets;
  final ValueChanged<ChatInboxItem> onSelected;

  @override
  State<ChatForwardTargetPicker> createState() =>
      _ChatForwardTargetPickerState();
}

class _ChatForwardTargetPickerState extends State<ChatForwardTargetPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final query = _query.trim().toLowerCase();
    final matches = widget.targets
        .where((item) {
          return query.isEmpty ||
              item.displayName.toLowerCase().contains(query) ||
              (item.lastMessage?.text ?? '').toLowerCase().contains(query);
        })
        .toList(growable: false);
    return Theme(
      data: chat.applyControls(Theme.of(context)),
      child: SizedBox(
        width: 340,
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                style: chat.contentStyle.copyWith(color: chat.incomingText),
                decoration: InputDecoration(
                  hintText: context.l10n.chatInboxSearchHint,
                  prefixIcon: Icon(Symbols.search, color: chat.metadataText),
                  isDense: true,
                  filled: true,
                  fillColor: chat.composerSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: chat.separator),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: matches.isEmpty
                    ? Center(
                        child: Text(
                          context.l10n.chatMessageForwardEmpty,
                          style: chat.metadataStyle.copyWith(
                            color: chat.metadataText,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: matches.length,
                        itemBuilder: (context, index) {
                          final item = matches[index];
                          final preview = item.lastMessage?.text;
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              Symbols.forum,
                              color: chat.metadataText,
                            ),
                            title: Text(
                              item.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: chat.contentStyle.copyWith(
                                color: chat.incomingText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: preview == null
                                ? null
                                : Text(
                                    preview,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: chat.metadataStyle.copyWith(
                                      color: chat.metadataText,
                                    ),
                                  ),
                            onTap: () => widget.onSelected(item),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
