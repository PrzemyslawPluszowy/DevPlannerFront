import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/transport/download_transport_impl.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/public_share/cubit/storage_public_share_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/public_share/cubit/storage_public_share_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Anonymous, responsive entry point for password-protected public file links.
final class StoragePublicSharePage extends StatelessWidget {
  const StoragePublicSharePage({
    required this.shareToken,
    this.repository,
    super.key,
  });

  final String shareToken;
  final StorageRepository? repository;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => StoragePublicShareCubit(
      shareToken: shareToken,
      repository: repository ?? context.read<StorageRepository>(),
      downloadTransport: const DownloadTransportImpl(),
    ),
    child: const _StoragePublicShareView(),
  );
}

/// Fail-closed view used when the anonymous Storage composition is unavailable.
final class StoragePublicShareUnavailablePage extends StatelessWidget {
  const StoragePublicShareUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(context.l10n.storagePublicShareUnavailable),
    ),
  );
}

final class _StoragePublicShareView extends StatefulWidget {
  const _StoragePublicShareView();

  @override
  State<_StoragePublicShareView> createState() =>
      _StoragePublicShareViewState();
}

final class _StoragePublicShareViewState
    extends State<_StoragePublicShareView> {
  final _passwordController = TextEditingController();
  final _obscurePassword = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _passwordController.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      AppIcons.document,
                      size: 48,
                      color: context.colors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.storagePublicSharePageTitle,
                      style: context.text.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.storagePublicSharePageDescription,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, isObscured, _) => TextField(
                        controller: _passwordController,
                        obscureText: isObscured,
                        autofillHints: const [AutofillHints.password],
                        onSubmitted: (_) => _download(),
                        decoration: InputDecoration(
                          labelText: context.l10n.storagePublicSharePassword,
                          helperText:
                              context.l10n.storagePublicSharePasswordOptional,
                          prefixIcon: const Icon(AppIcons.lock),
                          suffixIcon: IconButton(
                            tooltip: isObscured
                                ? context.l10n.storageShowPassword
                                : context.l10n.storageHidePassword,
                            onPressed: () =>
                                _obscurePassword.value = !isObscured,
                            icon: Icon(
                              isObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<
                      StoragePublicShareCubit,
                      StoragePublicShareState
                    >(
                      listener: (context, state) {
                        if (state is StoragePublicShareSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.l10n.storagePublicShareDownloadStarted(
                                  state.fileName,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (state case StoragePublicShareFailure(
                            :final message,
                            :final code,
                          ))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                code == null ? message : '$message ($code)',
                                style: context.text.bodyMedium?.copyWith(
                                  color: context.colors.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          FilledButton.icon(
                            onPressed: state is StoragePublicShareLoading
                                ? null
                                : _download,
                            icon: state is StoragePublicShareLoading
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(AppIcons.download),
                            label: Text(
                              context.l10n.storagePublicShareDownload,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  void _download() {
    unawaited(
      context.read<StoragePublicShareCubit>().download(
        password: _passwordController.text,
      ),
    );
  }
}
