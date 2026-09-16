part of 'settings_page.dart';

/// Sekcja ustawień zdjęcia profilowego Workspaces.
class _ProfileSettingsCard extends StatefulWidget {
  /// Tworzy kartę danych profilu.
  const _ProfileSettingsCard();

  @override
  State<_ProfileSettingsCard> createState() => _ProfileSettingsCardState();
}

class _ProfileSettingsCardState extends State<_ProfileSettingsCard> {
  static const int _maxAvatarSizeBytes = 5 * 1024 * 1024;

  @override
  void initState() {
    super.initState();
    unawaited(context.read<CurrentUserAvatarCubit>().load());
  }

  Future<void> _pickAvatar() async {
    final image = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'images',
          extensions: ['png', 'jpg', 'jpeg', 'webp', 'gif'],
        ),
      ],
    );
    if (image == null || !mounted) return;
    final bytes = await image.readAsBytes();
    if (!mounted) return;
    if (bytes.length > _maxAvatarSizeBytes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.settingsProfileAvatarTooLarge)),
      );
      return;
    }
    await context.read<CurrentUserAvatarCubit>().upload(
      bytes: bytes,
      fileName: image.name,
      mimeType: _mimeTypeFor(image.name),
    );
  }

  String _mimeTypeFor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      _ => 'image/webp',
    };
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final user = switch (context.watch<AuthCubit>().state) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };
    final name = user?.displayName.trim().isNotEmpty == true
        ? user!.displayName.trim()
        : user?.login.trim().isNotEmpty == true
        ? user!.login.trim()
        : intl.globalUserFallback;
    final initials = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();

    return BlocBuilder<CurrentUserAvatarCubit, CurrentUserAvatarState>(
      builder: (context, state) {
        final avatarUrl = switch (state) {
          CurrentUserAvatarLoading(:final previousAvatarUrl) =>
            previousAvatarUrl ?? user?.avatarUrl,
          CurrentUserAvatarReady(:final avatarUrl) =>
            avatarUrl ?? user?.avatarUrl,
          CurrentUserAvatarFailure(:final previousAvatarUrl) =>
            previousAvatarUrl ?? user?.avatarUrl,
          CurrentUserAvatarInitial() => user?.avatarUrl,
        };
        final isLoading = state is CurrentUserAvatarLoading;
        return Column(
          children: [
            AppSectionCard(
              title: intl.settingsProfileTitle,
              subtitle: intl.settingsProfileSubtitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ProfileAvatarPreview(
                        imageUrl: avatarUrl,
                        initials: initials.isEmpty ? 'U' : initials,
                        isLoading: isLoading,
                      ),
                      Gaps.w16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: context.text.titleMedium?.copyWith(
                                fontWeight: .w800,
                              ),
                            ),
                            if (user?.login.trim().isNotEmpty == true) ...[
                              Gaps.h2,
                              Text(
                                user!.login,
                                style: context.text.bodySmall?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                            Gaps.h8,
                            Text(
                              intl.settingsProfileAvatarHint,
                              style: context.text.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gaps.h20,
                  Wrap(
                    spacing: Sizes.p12,
                    runSpacing: Sizes.p8,
                    children: [
                      FilledButton.icon(
                        onPressed: isLoading ? null : _pickAvatar,
                        icon: const Icon(Icons.add_a_photo_outlined),
                        label: Text(intl.settingsProfileChooseAvatar),
                      ),
                      if (avatarUrl != null)
                        OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : context.read<CurrentUserAvatarCubit>().remove,
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: Text(intl.settingsProfileRemoveAvatar),
                        ),
                    ],
                  ),
                  if (isLoading) ...[
                    Gaps.h16,
                    const LinearProgressIndicator(),
                    Gaps.h8,
                    Text(intl.settingsProfileUploadInProgress),
                  ],
                  if (state case CurrentUserAvatarFailure(:final error)) ...[
                    Gaps.h16,
                    _ProfileError(error: error),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Podgląd avatara z bezpiecznym fallbackiem do inicjałów.
class _ProfileAvatarPreview extends StatelessWidget {
  /// Tworzy podgląd zdjęcia profilowego.
  const _ProfileAvatarPreview({
    required this.imageUrl,
    required this.initials,
    required this.isLoading,
  });

  final String? imageUrl;
  final String initials;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          foregroundImage: imageUrl == null ? null : NetworkImage(imageUrl!),
          child: Text(initials, style: context.text.titleLarge),
        ),
        if (isLoading)
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
      ],
    );
  }
}

/// Kompaktowy komunikat błędu bez utraty poprzedniego podglądu zdjęcia.
class _ProfileError extends StatelessWidget {
  /// Tworzy komunikat błędu avatara.
  const _ProfileError({required this.error});

  final ApiError error;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(Sizes.p12),
    decoration: BoxDecoration(
      color: context.colors.errorContainer,
      borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
    ),
    child: Text(
      error.message,
      style: context.text.bodySmall?.copyWith(
        color: context.colors.onErrorContainer,
      ),
    ),
  );
}
