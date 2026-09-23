import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/chat_emoji_picker.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_label.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_presets.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Przycisk własnego statusu otwierający zakotwiczoną kartę profilu.
///
/// Karta jest odpowiedzią na odrzucony formularz: zamiast ręcznego emoji,
/// przełącznika i rozwijanej listy pokazuje zdjęcie, nazwę, gotowe statusy
/// wybierane jednym kliknięciem, picker emoji, jedno lekkie pole opisu i menu
/// terminu. Termin istniejącego statusu nie jest zerowany bez świadomego wyboru,
/// a karta nie zamyka się przed potwierdzeniem zapisu.
class ChatStatusMenuButton extends StatefulWidget {
  /// Tworzy przycisk karty statusu.
  const ChatStatusMenuButton({
    required this.repository,
    required this.currentUserId,
    this.displayName,
    this.login,
    this.icon,
    this.tooltip,
    super.key,
  });

  /// Port obecności REST; właściciel przycisku dostarcza go jawnie.
  final ChatPresenceRepository repository;

  /// Kanoniczny UUID bieżącego użytkownika.
  final String currentUserId;

  /// Nazwa wyświetlana do nagłówka profilu; `null` pomija nagłówek.
  final String? displayName;

  /// Login do nagłówka profilu, używany gdy brak nazwy wyświetlanej.
  final String? login;

  /// Ikona przycisku; domyślnie ikona nastroju.
  final Widget? icon;

  /// Podpowiedź przycisku; domyślnie tekst ARB „Ustaw status”.
  final String? tooltip;

  @override
  State<ChatStatusMenuButton> createState() => _ChatStatusMenuButtonState();
}

class _ChatStatusMenuButtonState extends State<ChatStatusMenuButton> {
  final MenuController _menu = MenuController();
  final TextEditingController _text = TextEditingController();

  ChatUserStatus? _current;
  ChatStatusPreset? _preset;
  String? _emoji;
  bool _loading = false;
  bool _saving = false;
  bool _isDnd = false;
  bool _loadFailed = false;

  /// Wybór terminu w tej sesji edycji; `null` oznacza brak zmiany terminu.
  ChatStatusDurationOption? _durationChoice;
  String? _failureCode;

  @override
  void initState() {
    super.initState();
    // The panel trigger must reflect the saved status before the editor opens.
    unawaited(_load());
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_menu.isOpen) {
      _menu.close();
      return;
    }
    setState(() => _failureCode = null);
    _menu.open();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
      _failureCode = null;
    });
    final result = await widget.repository.getUserStatus(widget.currentUserId);
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _loading = false;
        _loadFailed = true;
      }),
      (status) => setState(() {
        _loading = false;
        _loadFailed = false;
        _current = status;
        _emoji = status?.emoji;
        _text.text = status?.text ?? '';
        _isDnd = status?.isDnd ?? false;
        _preset = null;
        // Termin zostaje bez zmian, dopóki użytkownik nie wybierze opcji.
        _durationChoice = null;
      }),
    );
  }

  Future<void> _pickEmoji() async {
    final emoji = await showChatEmojiPicker(
      context,
      recent: context.read<ChatEmojiRecentCubit?>(),
    );
    if (emoji == null || !mounted) return;
    setState(() => _emoji = emoji);
  }

  void _applyPreset(ChatStatusPreset preset) {
    setState(() {
      _preset = preset;
      _emoji = preset.emoji;
      _text.text = _presetLabel(context, preset);
    });
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _failureCode = null;
    });
    final choice = _durationChoice;
    final expiresAtUtc = choice == null
        ? _current?.expiresAtUtc
        : ChatStatusDurations.expiresAtLocal(choice, DateTime.now())?.toUtc();
    final result = await widget.repository.setOwnStatus(
      ChatUserStatusUpdate(
        emoji: _emoji?.trim().isEmpty ?? true ? null : _emoji!.trim(),
        text: _text.text.trim().isEmpty ? null : _text.text.trim(),
        isDnd: _isDnd,
        expiresAtUtc: expiresAtUtc,
      ),
    );
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _saving = false;
        _failureCode = context.l10n.chatActionFailureMessage;
      }),
      (status) {
        setState(() {
          _saving = false;
          _current = status;
        });
        _menu.close();
      },
    );
  }

  Future<void> _clear() async {
    setState(() {
      _saving = true;
      _failureCode = null;
    });
    final result = await widget.repository.clearOwnStatus();
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _saving = false;
        _failureCode = context.l10n.chatActionFailureMessage;
      }),
      (_) {
        setState(() {
          _saving = false;
          _current = null;
          _emoji = null;
          _text.clear();
          _isDnd = false;
          _preset = null;
          _durationChoice = null;
        });
        _menu.close();
      },
    );
  }

  @override
  Widget build(BuildContext context) => MenuAnchor(
    controller: _menu,
    crossAxisUnconstrained: false,
    alignmentOffset: const Offset(Sizes.p8, -Sizes.p8),
    menuChildren: [_buildCard(context)],
    builder: (context, controller, child) => IconButton(
      key: const ValueKey('chat-own-status-menu'),
      tooltip: _current?.text?.trim().isNotEmpty == true
          ? '${_current!.emoji ?? ''} ${_current!.text}'.trim()
          : widget.tooltip ?? context.l10n.chatStatusOpen,
      onPressed: _toggle,
      icon: _current?.emoji?.trim().isNotEmpty == true
          ? Text(
              _current!.emoji!,
              style: const TextStyle(fontSize: 20),
              semanticsLabel: context.l10n.chatStatusOpen,
            )
          : widget.icon ?? const Icon(Symbols.mood, size: 18),
    ),
  );

  Widget _buildCard(BuildContext context) {
    final chat = context.chatTheme;
    final busy = _loading || _saving;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340, maxHeight: 460),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: chat.panelSurface,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: chat.separator),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                const SizedBox(height: Sizes.p8),
                Divider(height: 1, color: chat.separator),
                const SizedBox(height: Sizes.p8),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.p16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_loadFailed)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p8,
                      vertical: Sizes.p16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.chatStatusLoadFailed,
                          style: chat.contentStyle.copyWith(
                            color: chat.metadataText,
                          ),
                        ),
                        const SizedBox(height: Sizes.p8),
                        TextButton.icon(
                          onPressed: _loading ? null : () => unawaited(_load()),
                          icon: const Icon(Symbols.refresh_rounded, size: 18),
                          label: Text(context.l10n.workspacesRetry),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Text(
                    context.l10n.chatStatusPresets,
                    style: chat.metadataStyle.copyWith(
                      color: chat.metadataText,
                    ),
                  ),
                  const SizedBox(height: Sizes.p4),
                  Wrap(
                    spacing: Sizes.p4,
                    runSpacing: Sizes.p4,
                    children: [
                      for (final preset in ChatStatusPreset.values)
                        _PresetChip(
                          preset: preset,
                          label: _presetLabel(context, preset),
                          selected: _preset == preset,
                          onTap: _saving ? null : () => _applyPreset(preset),
                        ),
                    ],
                  ),
                  const SizedBox(height: Sizes.p8),
                  Row(
                    children: [
                      SizedBox.square(
                        dimension: chat.composerActionSize,
                        child: OutlinedButton(
                          key: const ValueKey('chat-status-emoji'),
                          onPressed: _saving
                              ? null
                              : () => unawaited(_pickEmoji()),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            _emoji?.isNotEmpty ?? false ? _emoji! : '🙂',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: Sizes.p8),
                      Expanded(
                        child: TextField(
                          controller: _text,
                          enabled: !_saving,
                          maxLength: 240,
                          style: chat.contentStyle.copyWith(
                            color: chat.incomingText,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            counterText: '',
                            filled: true,
                            fillColor: chat.listSurface,
                            hintText: context.l10n.chatStatusText,
                            hintStyle: chat.contentStyle.copyWith(
                              color: chat.metadataText,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: chat.separator),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: chat.focusRing,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: chat.separator),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.p4),
                  Builder(
                    builder: (anchorContext) => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: const ValueKey('chat-status-duration'),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        onTap: _saving
                            ? null
                            : () => unawaited(() async {
                                final selected =
                                    await AppContextMenu.select<
                                      ChatStatusDurationOption
                                    >(
                                      anchorContext,
                                      globalPosition:
                                          AppContextMenu.positionFor(
                                            anchorContext,
                                          ),
                                      options: [
                                        AppContextMenuOption(
                                          value:
                                              ChatStatusDurationOption.oneHour,
                                          label:
                                              context.l10n.chatStatusExpiryHour,
                                          selected:
                                              _durationChoice ==
                                              ChatStatusDurationOption.oneHour,
                                        ),
                                        AppContextMenuOption(
                                          value: ChatStatusDurationOption.today,
                                          label: context
                                              .l10n
                                              .chatStatusExpiryToday,
                                          selected:
                                              _durationChoice ==
                                              ChatStatusDurationOption.today,
                                        ),
                                        AppContextMenuOption(
                                          value: ChatStatusDurationOption.none,
                                          label:
                                              context.l10n.chatStatusExpiryNone,
                                          selected:
                                              _durationChoice ==
                                              ChatStatusDurationOption.none,
                                        ),
                                      ],
                                    );
                                if (selected != null && mounted) {
                                  setState(() => _durationChoice = selected);
                                }
                              }()),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: chat.listSurface,
                            labelText: context.l10n.chatStatusExpiry,
                            labelStyle: chat.metadataStyle.copyWith(
                              color: chat.metadataText,
                            ),
                            suffixIcon: Icon(
                              Symbols.expand_more_rounded,
                              color: chat.metadataText,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: chat.separator),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: chat.separator),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: chat.focusRing,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Text(
                            _durationLabel(context),
                            style: chat.contentStyle.copyWith(
                              color: chat.incomingText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.p4),
                  _dndControl(context),
                  if (_failureCode != null)
                    Padding(
                      padding: const EdgeInsets.only(top: Sizes.p8),
                      child: Text(
                        _failureCode!,
                        style: chat.metadataStyle.copyWith(color: chat.error),
                      ),
                    ),
                  const SizedBox(height: Sizes.p8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: busy ? null : _clear,
                        child: Text(context.l10n.chatStatusClear),
                      ),
                      const SizedBox(width: Sizes.p8),
                      FilledButton(
                        onPressed: busy ? null : _save,
                        child: Text(context.l10n.chatStatusSave),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Etykieta wybranego terminu; bez wyboru pokazuje stan bez zmian.
  String _durationLabel(BuildContext context) => switch (_durationChoice) {
    ChatStatusDurationOption.oneHour => context.l10n.chatStatusExpiryHour,
    ChatStatusDurationOption.today => context.l10n.chatStatusExpiryToday,
    ChatStatusDurationOption.none => context.l10n.chatStatusExpiryNone,
    null => context.l10n.chatStatusExpiryUnchanged,
  };

  /// Widoczny, samodzielnie stylowany przełącznik DND zamiast Material Switch.
  Widget _dndControl(BuildContext context) {
    final chat = context.chatTheme;
    return ChatToggle(
      key: const ValueKey('chat-status-dnd-toggle'),
      value: _isDnd,
      label: context.l10n.chatStatusDnd,
      showLabel: true,
      activeColor: chat.presenceDnd,
      onChanged: _saving ? null : (value) => setState(() => _isDnd = value),
    );
  }

  Widget _header(BuildContext context) {
    final chat = context.chatTheme;
    final name = widget.displayName?.trim();
    final fallback = widget.login?.trim();
    final label = name != null && name.isNotEmpty
        ? name
        : (fallback != null && fallback.isNotEmpty ? fallback : null);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUserAvatar(
          isCurrentUser: true,
          displayName: label,
          radius: 22,
          singleInitial: true,
        ),
        const SizedBox(width: Sizes.p8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                Text(
                  label,
                  style: chat.authorStyle.copyWith(color: chat.incomingText),
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: Sizes.p2),
              if (_current != null)
                ChatStatusLabel(
                  status: _current,
                  style: chat.metadataStyle.copyWith(
                    color: chat.metadataText,
                  ),
                )
              else
                Text(
                  context.l10n.chatStatusNone,
                  style: chat.metadataStyle.copyWith(
                    color: chat.metadataText,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.preset,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final ChatStatusPreset preset;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return InkWell(
      key: ValueKey<String>('chat-status-preset-${preset.name}'),
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p8,
          vertical: Sizes.p4,
        ),
        decoration: BoxDecoration(
          color: selected ? chat.selectedSurface : chat.hoverSurface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: selected ? chat.focusRing : chat.separator),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(preset.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: Sizes.p4),
            Text(
              label,
              style: chat.metadataStyle.copyWith(color: chat.incomingText),
            ),
          ],
        ),
      ),
    );
  }
}

/// Etykieta presetu w języku interfejsu.
String _presetLabel(BuildContext context, ChatStatusPreset preset) =>
    switch (preset) {
      ChatStatusPreset.focus => context.l10n.chatStatusPresetFocus,
      ChatStatusPreset.inMeeting => context.l10n.chatStatusPresetInMeeting,
      ChatStatusPreset.brb => context.l10n.chatStatusPresetBrb,
      ChatStatusPreset.commuting => context.l10n.chatStatusPresetCommuting,
      ChatStatusPreset.lunch => context.l10n.chatStatusPresetLunch,
    };
