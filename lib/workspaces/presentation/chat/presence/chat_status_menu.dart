import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/chat_emoji_picker.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_menu_card.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_menu_components.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_presets.dart';
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
  int _loadRevision = 0;
  Timer? _expiryTimer;

  @override
  void initState() {
    super.initState();
    // Przycisk panelu ma pokazywać zapisany status jeszcze przed otwarciem karty.
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant ChatStatusMenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentUserId == widget.currentUserId &&
        identical(oldWidget.repository, widget.repository)) {
      return;
    }
    setState(() {
      _setCurrentStatus(null);
      _preset = null;
      _emoji = null;
      _text.clear();
      _isDnd = false;
      _durationChoice = null;
      _failureCode = null;
      _saving = false;
    });
    _menu.close();
    unawaited(_load());
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
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
    final revision = ++_loadRevision;
    setState(() {
      _loading = true;
      _loadFailed = false;
      _failureCode = null;
    });
    final result = await widget.repository.getUserStatus(widget.currentUserId);
    if (!mounted || revision != _loadRevision) return;
    result.fold(
      (error) => setState(() {
        _loading = false;
        _loadFailed = true;
      }),
      (status) => setState(() {
        _loading = false;
        _loadFailed = false;
        _setCurrentStatus(status);
        _emoji = _current?.emoji;
        _text.text = _current?.text ?? '';
        _isDnd = _current?.isDnd ?? false;
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
      _text.text = chatStatusPresetLabel(context, preset);
    });
  }

  Future<void> _save() async {
    ++_loadRevision;
    final userId = widget.currentUserId;
    final repository = widget.repository;
    setState(() {
      _saving = true;
      _loading = false;
      _loadFailed = false;
      _failureCode = null;
    });
    final choice = _durationChoice;
    final expiresAtUtc = choice == null
        ? _current?.expiresAtUtc
        : ChatStatusDurations.expiresAtLocal(choice, DateTime.now())?.toUtc();
    final result = await repository.setOwnStatus(
      ChatUserStatusUpdate(
        emoji: _emoji?.trim().isEmpty ?? true ? null : _emoji!.trim(),
        text: _text.text.trim().isEmpty ? null : _text.text.trim(),
        isDnd: _isDnd,
        expiresAtUtc: expiresAtUtc,
      ),
    );
    if (!mounted ||
        userId != widget.currentUserId ||
        !identical(repository, widget.repository)) {
      return;
    }
    result.fold(
      (error) => setState(() {
        _saving = false;
        _failureCode = context.l10n.chatActionFailureMessage;
      }),
      (status) {
        setState(() {
          _saving = false;
          _setCurrentStatus(status);
          _emoji = _current?.emoji;
          _text.text = _current?.text ?? '';
          _isDnd = _current?.isDnd ?? false;
        });
        _menu.close();
      },
    );
  }

  Future<void> _clear() async {
    ++_loadRevision;
    final userId = widget.currentUserId;
    final repository = widget.repository;
    setState(() {
      _saving = true;
      _loading = false;
      _loadFailed = false;
      _failureCode = null;
    });
    final result = await repository.clearOwnStatus();
    if (!mounted ||
        userId != widget.currentUserId ||
        !identical(repository, widget.repository)) {
      return;
    }
    result.fold(
      (error) => setState(() {
        _saving = false;
        _failureCode = context.l10n.chatActionFailureMessage;
      }),
      (_) {
        setState(() {
          _saving = false;
          _setCurrentStatus(null);
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

  /// Utrzymuje trigger zgodny z terminem statusu bez ponownego otwierania
  /// menu. Długi termin jest sprawdzany co dobę, także na Web, gdzie timery
  /// mają ograniczony maksymalny czas.
  void _setCurrentStatus(ChatUserStatus? status) {
    _expiryTimer?.cancel();
    final current = status?.isExpiredAt(DateTime.now().toUtc()) == true
        ? null
        : status;
    _current = current;
    final expiry = current?.expiresAtUtc?.toUtc();
    if (expiry == null) return;

    const maxTimerDelay = Duration(days: 1);
    final remaining = expiry.difference(DateTime.now().toUtc());
    final delay = remaining > maxTimerDelay
        ? maxTimerDelay
        : remaining.isNegative
        ? Duration.zero
        : remaining;
    _expiryTimer = Timer(delay, () {
      if (!mounted || _current != current) return;
      if (current!.isExpiredAt(DateTime.now().toUtc())) {
        setState(() {
          _current = null;
          _emoji = null;
          _text.clear();
          _isDnd = false;
          _preset = null;
          _durationChoice = null;
        });
      } else {
        _setCurrentStatus(current);
      }
    });
  }

  @override
  Widget build(BuildContext context) => MenuAnchor(
    controller: _menu,
    crossAxisUnconstrained: false,
    alignmentOffset: const Offset(Sizes.p8, -Sizes.p8),
    menuChildren: [
      ChatStatusMenuCard(
        current: _current,
        textController: _text,
        loading: _loading,
        loadFailed: _loadFailed,
        saving: _saving,
        isDnd: _isDnd,
        emoji: _emoji,
        preset: _preset,
        durationChoice: _durationChoice,
        failureMessage: _failureCode,
        displayName: widget.displayName,
        login: widget.login,
        onPickEmoji: () => unawaited(_pickEmoji()),
        onRetry: () => unawaited(_load()),
        onPreset: _applyPreset,
        onDuration: (value) {
          if (mounted) setState(() => _durationChoice = value);
        },
        onDnd: (value) => setState(() => _isDnd = value),
        onClear: () => unawaited(_clear()),
        onSave: () => unawaited(_save()),
      ),
    ],
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
}
