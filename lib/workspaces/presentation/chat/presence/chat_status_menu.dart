import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_label.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Przycisk własnego statusu otwierający mały, zakotwiczony popover.
///
/// Popover najpierw pobiera bieżący status konta, a dopiero potem pozwala go
/// edytować. Nie zamyka się przed potwierdzeniem zapisu: przy błędzie zostawia
/// wartości, pokazuje kod i pozwala ponowić, więc użytkownik nie traci pracy.
/// To status tekstowy/obecności — nie relacje zdjęciowe ani historie.
class ChatStatusMenuButton extends StatefulWidget {
  /// Tworzy przycisk popovera statusu.
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
  final TextEditingController _emoji = TextEditingController();
  final TextEditingController _text = TextEditingController();

  ChatUserStatus? _current;
  bool _loading = false;
  bool _saving = false;
  bool _isDnd = false;
  Duration? _expiry;
  String? _failureCode;

  @override
  void dispose() {
    _emoji.dispose();
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
    setState(() => _loading = true);
    final result = await widget.repository.getUserStatus(widget.currentUserId);
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _loading = false;
        _failureCode = error.apiCode ?? error.message;
      }),
      (status) => setState(() {
        _loading = false;
        _current = status;
        _emoji.text = status?.emoji ?? '';
        _text.text = status?.text ?? '';
        _isDnd = status?.isDnd ?? false;
        _expiry = null;
      }),
    );
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _failureCode = null;
    });
    final result = await widget.repository.setOwnStatus(
      ChatUserStatusUpdate(
        emoji: _emoji.text.trim().isEmpty ? null : _emoji.text.trim(),
        text: _text.text.trim().isEmpty ? null : _text.text.trim(),
        isDnd: _isDnd,
        expiresAtUtc: _expiry == null
            ? null
            : DateTime.now().toUtc().add(_expiry!),
      ),
    );
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _saving = false;
        _failureCode = error.apiCode ?? error.message;
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
        _failureCode = error.apiCode ?? error.message;
      }),
      (_) {
        setState(() {
          _saving = false;
          _current = null;
          _emoji.clear();
          _text.clear();
          _isDnd = false;
          _expiry = null;
        });
        _menu.close();
      },
    );
  }

  @override
  Widget build(BuildContext context) => MenuAnchor(
    controller: _menu,
    crossAxisUnconstrained: false,
    menuChildren: [_buildPanel(context)],
    builder: (context, controller, child) => IconButton(
      key: const ValueKey('chat-own-status-menu'),
      tooltip: widget.tooltip ?? context.l10n.chatStatusOpen,
      onPressed: _toggle,
      icon: widget.icon ?? const Icon(Symbols.mood, size: 18),
    ),
  );

  Widget _buildPanel(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _loading || _saving;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300, maxHeight: 380),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              const Divider(height: Sizes.p16),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.p8),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                TextField(
                  controller: _emoji,
                  enabled: !_saving,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: context.l10n.chatStatusEmoji,
                  ),
                ),
                const SizedBox(height: Sizes.p8),
                TextField(
                  controller: _text,
                  enabled: !_saving,
                  maxLength: 240,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: context.l10n.chatStatusText,
                  ),
                ),
                SwitchListTile(
                  value: _isDnd,
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _isDnd = value),
                  title: Text(context.l10n.chatStatusDnd),
                  dense: true,
                ),
                DropdownButtonFormField<Duration?>(
                  initialValue: _expiry,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: context.l10n.chatStatusExpiry,
                  ),
                  items: [
                    DropdownMenuItem<Duration?>(
                      child: Text(context.l10n.chatStatusExpiryNone),
                    ),
                    DropdownMenuItem<Duration?>(
                      value: const Duration(hours: 1),
                      child: Text(context.l10n.chatStatusExpiryHour),
                    ),
                    DropdownMenuItem<Duration?>(
                      value: const Duration(hours: 24),
                      child: Text(context.l10n.chatStatusExpiryDay),
                    ),
                  ],
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _expiry = value),
                ),
              ],
              if (_failureCode != null)
                Padding(
                  padding: const EdgeInsets.only(top: Sizes.p8),
                  child: Text(
                    _failureCode!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
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
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    final name = widget.displayName?.trim();
    final fallback = widget.login?.trim();
    final label = name != null && name.isNotEmpty
        ? name
        : (fallback != null && fallback.isNotEmpty ? fallback : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label,
            style: theme.textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: Sizes.p4),
        Text(
          context.l10n.chatStatusPeerView,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (_current != null)
          Padding(
            padding: const EdgeInsets.only(top: Sizes.p4),
            child: ChatStatusLabel(
              status: _current,
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
