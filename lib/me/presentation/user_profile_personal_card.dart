import 'dart:async';

import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:devplanner/me/presentation/cubit/profile_cubit.dart';
import 'package:devplanner/me/presentation/cubit/profile_state.dart';
import 'package:devplanner/me/presentation/user_profile_access_chips.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Karta prezentująca dane profilowe użytkownika, awatar, role i uprawnienia.
class UserProfilePersonalCard extends StatefulWidget {
  const UserProfilePersonalCard({required this.profile, super.key});

  final UserProfile profile;

  @override
  State<UserProfilePersonalCard> createState() =>
      _UserProfilePersonalCardState();
}

class _UserProfilePersonalCardState extends State<UserProfilePersonalCard> {
  late final TextEditingController _displayNameController;
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isEditing = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.profile.displayName,
    );
  }

  @override
  void didUpdateWidget(covariant UserProfilePersonalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.displayName != widget.profile.displayName &&
        !_isEditing.value) {
      _displayNameController.text = widget.profile.displayName;
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _isEditing.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadAvatar(BuildContext context) async {
    const typeGroup = XTypeGroup(
      label: 'Obrazy',
      extensions: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
    );

    try {
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (!context.mounted) return;

      if (bytes.length > 5 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.settingsProfileAvatarTooLarge),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      await context.read<ProfileCubit>().uploadAvatar(bytes, file.name);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd podczas wyboru zdjęcia: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _deleteAvatar(BuildContext context) async {
    await context.read<ProfileCubit>().deleteAvatar();
  }

  void _submitDisplayName(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<ProfileCubit>().updateDisplayName(
          _displayNameController.text,
        ),
      );
      _isEditing.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final profile = widget.profile;

    return ValueListenableBuilder<bool>(
      valueListenable: _isEditing,
      builder: (context, isEditing, _) =>
          BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUpdateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: TextStyle(color: theme.feedback.successForeground),
                    ),
                    backgroundColor: theme.feedback.successBackground,
                  ),
                );
              } else if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isUploading = state is ProfileAvatarUploading;
              final isDeleting = state is ProfileAvatarDeleting;
              final isUpdating = state is ProfileUpdating;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const .all(Sizes.p24),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      // Nagłówek sekcji
                      Row(
                        children: [
                          Container(
                            padding: const .all(Sizes.p8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: const .all(.circular(Sizes.p8)),
                            ),
                            child: Icon(
                              Icons.account_circle_outlined,
                              color: theme.colorScheme.onPrimaryContainer,
                              size: Sizes.p24,
                            ),
                          ),
                          Gaps.w12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  l10n.mePersonalSectionTitle,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  l10n.mePersonalSectionSubtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: Sizes.p32),

                      // Sekcja awatara
                      Row(
                        children: [
                          Stack(
                            alignment: .center,
                            children: [
                              UserAvatarView(
                                profile: profile,
                                radius: Sizes.p40,
                              ),
                              if (isUploading || isDeleting)
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: .45),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Gaps.w16,
                          Expanded(
                            child: Wrap(
                              spacing: Sizes.p8,
                              runSpacing: Sizes.p8,
                              children: [
                                FilledButton.tonalIcon(
                                  onPressed: (isUploading || isDeleting)
                                      ? null
                                      : () => _pickAndUploadAvatar(context),
                                  icon: const Icon(
                                    Icons.photo_camera_outlined,
                                    size: 18,
                                  ),
                                  label: Text(l10n.settingsProfileChooseAvatar),
                                ),
                                if (profile.avatarFileId != null)
                                  OutlinedButton.icon(
                                    onPressed: (isUploading || isDeleting)
                                        ? null
                                        : () => _deleteAvatar(context),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                    ),
                                    label: Text(
                                      l10n.settingsProfileRemoveAvatar,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: theme.colorScheme.error,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gaps.h24,

                      // Formularz danych profilu
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            // Login (tylko do odczytu)
                            TextFormField(
                              initialValue: profile.login,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: l10n.meLoginLabel,
                                prefixIcon: const Icon(
                                  Icons.alternate_email,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor:
                                    theme.colorScheme.surfaceContainerLow,
                              ),
                            ),
                            Gaps.h16,

                            // Adres e-mail (tylko do odczytu)
                            TextFormField(
                              initialValue: profile.email,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: l10n.meEmailLabel,
                                prefixIcon: const Icon(
                                  Icons.mail_outline,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor:
                                    theme.colorScheme.surfaceContainerLow,
                              ),
                            ),
                            Gaps.h16,

                            // Nazwa wyświetlana (z możliwością edycji)
                            TextFormField(
                              controller: _displayNameController,
                              readOnly: !isEditing,
                              decoration: InputDecoration(
                                labelText: l10n.meDisplayNameLabel,
                                hintText: l10n.meDisplayNameHint,
                                prefixIcon: const Icon(
                                  Icons.badge_outlined,
                                  size: 20,
                                ),
                                suffixIcon: isUpdating
                                    ? const Padding(
                                        padding: .all(Sizes.p12),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : isEditing
                                    ? Row(
                                        mainAxisSize: .min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                            onPressed: () =>
                                                _submitDisplayName(context),
                                            tooltip: l10n.meSaveProfileButton,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              _displayNameController.text =
                                                  profile.displayName;
                                              _isEditing.value = false;
                                            },
                                          ),
                                        ],
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () {
                                          _isEditing.value = true;
                                        },
                                      ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.meDisplayNameRequired;
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) =>
                                  _submitDisplayName(context),
                            ),
                          ],
                        ),
                      ),
                      Gaps.h24,

                      UserProfileAccessChips(profile: profile),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}

/// Widżet wyświetlający awatar użytkownika lub estetyczny fallback z inicjałami.
class UserAvatarView extends StatelessWidget {
  const UserAvatarView({
    required this.profile,
    required this.radius,
    super.key,
  });

  final UserProfile profile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppUserAvatar(
      isCurrentUser: true,
      userId: profile.userId,
      displayName: profile.displayName.isNotEmpty
          ? profile.displayName
          : profile.login,
      hasCustomAvatar: profile.avatarFileId != null,
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      foregroundColor: theme.colorScheme.onPrimaryContainer,
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: .bold,
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
