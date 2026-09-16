import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ready_next/app/shell/overlay/app_modal_picker_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';

/// Complete public-link form with password, expiry and copyable absolute URL.
class StoragePublicLinkForm extends StatefulWidget {
  const StoragePublicLinkForm({required this.onCreate, super.key});

  final Future<String?> Function(String? password, DateTime? expiresAtUtc)
  onCreate;

  @override
  State<StoragePublicLinkForm> createState() => _StoragePublicLinkFormState();
}

class _StoragePublicLinkFormState extends State<StoragePublicLinkForm> {
  final _passwordController = TextEditingController();
  DateTime? _expiresAtUtc;
  String? _createdUrl;
  bool _isCreating = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: context.colors.outlineVariant.withValues(alpha: 0.5),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(AppIcons.link, size: 20, color: context.colors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.storagePublicLinkTitle,
                    style: context.text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    context.l10n.storagePublicLinkSubtitle,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: context.l10n.storagePublicSharePassword,
            isDense: true,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _pickExpiry,
          icon: const Icon(Icons.event_outlined, size: 18),
          label: Text(
            _expiresAtUtc == null
                ? context.l10n.storagePublicLinkNoExpiry
                : context.l10n.storagePublicLinkExpires(
                    MaterialLocalizations.of(
                      context,
                    ).formatMediumDate(_expiresAtUtc!.toLocal()),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        if (_createdUrl case final url?)
          Row(
            children: [
              Expanded(child: SelectableText(url, maxLines: 2)),
              IconButton(
                tooltip: context.l10n.storageCopyPublicLink,
                onPressed: () => _copy(url),
                icon: const Icon(Icons.copy_outlined),
              ),
            ],
          )
        else
          FilledButton.icon(
            onPressed: _isCreating ? null : _create,
            icon: _isCreating
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(AppIcons.link, size: 16),
            label: Text(context.l10n.storageGenerateLinkButton),
          ),
      ],
    ),
  );

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final date = await AppModalPickerHost.showDate(
      context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 3650)),
      initialDate: _expiresAtUtc?.toLocal() ?? now.add(const Duration(days: 7)),
    );
    if (date == null || !mounted) return;
    setState(() {
      _expiresAtUtc = DateTime(
        date.year,
        date.month,
        date.day,
        23,
        59,
        59,
      ).toUtc();
      _createdUrl = null;
    });
  }

  Future<void> _create() async {
    setState(() => _isCreating = true);
    final password = _passwordController.text.trim();
    final url = await widget.onCreate(
      password.isEmpty ? null : password,
      _expiresAtUtc,
    );
    if (!mounted) return;
    setState(() {
      _isCreating = false;
      _createdUrl = url;
    });
    if (url != null) await _copy(url);
  }

  Future<void> _copy(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.storageLinkCopied)),
    );
  }
}
