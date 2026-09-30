import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Formularz tworzenia publicznego linku do pliku.
///
/// Widget nie zna repozytorium ani endpointu. Otrzymuje callback, który
/// wykonuje Cubit i zwraca już zbudowany bezpieczny link.
typedef StoragePublicShareCreation = ({String? url, String? error});

final class StoragePublicShareForm extends StatefulWidget {
  /// Tworzy formularz hasła, expiry oraz kopiowania linku.
  const StoragePublicShareForm({required this.onCreate, super.key})
    : onCreateDetailed = null;

  /// Tworzy formularz z błędem inline, zachowując starą sygnaturę callbacku.
  const StoragePublicShareForm.detailed({
    required this.onCreateDetailed,
    super.key,
  }) : onCreate = null;

  /// Zwraca link po potwierdzonym utworzeniu grantu albo `null` po błędzie.
  final Future<String?> Function(
    String? password,
    DateTime? expiresAtUtc,
  )?
  onCreate;

  /// Callback wariantowy ze szczegółowym błędem do pokazania w formularzu.
  final Future<StoragePublicShareCreation> Function(
    String? password,
    DateTime? expiresAtUtc,
  )?
  onCreateDetailed;

  @override
  State<StoragePublicShareForm> createState() => _StoragePublicShareFormState();
}

final class _StoragePublicShareFormState extends State<StoragePublicShareForm> {
  final _passwordController = TextEditingController();
  final _viewState = ValueNotifier<_StoragePublicShareFormViewState>(
    const _StoragePublicShareFormViewState(),
  );

  @override
  void dispose() {
    _passwordController.dispose();
    _viewState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<_StoragePublicShareFormViewState>(
        valueListenable: _viewState,
        builder: (context, state, _) => Container(
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
                  hintText: context.l10n.storagePublicSharePasswordOptional,
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickExpiry,
                icon: const Icon(Icons.event_outlined, size: 18),
                label: Text(_expiryLabel(context, state.expiresAtUtc)),
              ),
              const SizedBox(height: 8),
              if (state.createdUrl case final url?)
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
                  onPressed: state.isCreating ? null : _create,
                  icon: state.isCreating
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(AppIcons.link, size: 16),
                  label: Text(context.l10n.storageGenerateLinkButton),
                ),
              if (state.errorMessage case final error?) ...[
                const SizedBox(height: 8),
                Text(
                  error,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ],
              if (state.copied) ...[
                const SizedBox(height: 8),
                Text(
                  context.l10n.storageLinkCopied,
                  style: context.text.labelMedium?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      );

  String _expiryLabel(BuildContext context, DateTime? expiresAtUtc) =>
      expiresAtUtc == null
      ? context.l10n.storagePublicLinkNoExpiry
      : context.l10n.storagePublicLinkExpires(
          MaterialLocalizations.of(
            context,
          ).formatMediumDate(expiresAtUtc.toLocal()),
        );

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 3650)),
      initialDate:
          _viewState.value.expiresAtUtc?.toLocal() ??
          now.add(const Duration(days: 7)),
    );
    if (date == null || !mounted) return;
    _viewState.value = _viewState.value.copyWith(
      expiresAtUtc: DateTime(
        date.year,
        date.month,
        date.day,
        23,
        59,
        59,
      ).toUtc(),
      clearCreatedUrl: true,
    );
  }

  Future<void> _create() async {
    if (_viewState.value.isCreating) return;
    _viewState.value = _viewState.value.copyWith(isCreating: true);
    final password = _passwordController.text.trim();
    final result = widget.onCreateDetailed != null
        ? await widget.onCreateDetailed!(
            password.isEmpty ? null : password,
            _viewState.value.expiresAtUtc,
          )
        : (
            url: await widget.onCreate!(
              password.isEmpty ? null : password,
              _viewState.value.expiresAtUtc,
            ),
            error: null,
          );
    if (!mounted) return;
    _viewState.value = _viewState.value.copyWith(
      isCreating: false,
      createdUrl: result.url,
      errorMessage: result.error,
      clearError: result.error == null,
    );
    if (result.url != null) await _copy(result.url!);
  }

  Future<void> _copy(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    _viewState.value = _viewState.value.copyWith(copied: true);
  }
}

final class _StoragePublicShareFormViewState {
  const _StoragePublicShareFormViewState({
    this.expiresAtUtc,
    this.createdUrl,
    this.isCreating = false,
    this.errorMessage,
    this.copied = false,
  });

  final DateTime? expiresAtUtc;
  final String? createdUrl;
  final bool isCreating;
  final String? errorMessage;
  final bool copied;

  _StoragePublicShareFormViewState copyWith({
    DateTime? expiresAtUtc,
    String? createdUrl,
    bool? isCreating,
    String? errorMessage,
    bool clearError = false,
    bool? copied,
    bool clearCreatedUrl = false,
  }) => _StoragePublicShareFormViewState(
    expiresAtUtc: expiresAtUtc ?? this.expiresAtUtc,
    createdUrl: clearCreatedUrl ? null : createdUrl ?? this.createdUrl,
    isCreating: isCreating ?? this.isCreating,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    copied: copied ?? this.copied,
  );
}
