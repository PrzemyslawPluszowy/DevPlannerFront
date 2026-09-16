import 'package:flutter/material.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Kafelek akcji ustawień i wylogowania z geometrią spójną z modułami.
class AppGlobalRailActionTile extends StatelessWidget {
  const AppGlobalRailActionTile({
    required this.isExpanded,
    required this.label,
    required this.icon,
    required this.background,
    required this.hover,
    required this.foreground,
    required this.onTap,
    super.key,
  });

  final bool isExpanded;
  final String label;
  final IconData icon;
  final Color background;
  final Color hover;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Material(
        color: background,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p8)),
        child: InkWell(
          onTap: onTap,
          hoverColor: hover,
          borderRadius: const BorderRadius.all(Radius.circular(Sizes.p8)),
          child: SizedBox(
            height: 36,
            child: Row(
              mainAxisAlignment: isExpanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(icon, color: foreground, size: 20),
                if (isExpanded) ...[
                  const SizedBox(width: Sizes.p10),
                  Expanded(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelLarge?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    return isExpanded || Overlay.maybeOf(context) == null
        ? content
        : Tooltip(
            message: label,
            waitDuration: const Duration(milliseconds: 350),
            child: content,
          );
  }
}

/// Konto użytkownika w stopce raila; zwinięty rail pokazuje sam avatar.
class AppGlobalRailAccount extends StatelessWidget {
  const AppGlobalRailAccount({
    required this.isExpanded,
    required this.user,
    this.avatarUrl,
    required this.background,
    required this.border,
    required this.foreground,
    super.key,
  });

  final bool isExpanded;
  final AuthUser? user;
  final String? avatarUrl;
  final Color background;
  final Color border;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final name = user?.displayName.trim().isNotEmpty == true
        ? user!.displayName.trim()
        : user?.login.trim().isNotEmpty == true
        ? user!.login.trim()
        : context.l10n.globalUserFallback;
    final initials = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(isExpanded ? Sizes.p10 : Sizes.p2),
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: .25),
                  width: 1.5,
                ),
              ),
              child: _UserAvatarContent(
                avatarUrl: avatarUrl ?? user?.avatarUrl,
                initials: initials.isEmpty ? 'U' : initials,
              ),
            ),
            if (isExpanded) ...[
              const SizedBox(width: Sizes.p10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelLarge?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (user?.login.trim().isNotEmpty == true)
                      Text(
                        user!.login.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall?.copyWith(
                          color: foreground.withValues(alpha: .9),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Obraz awatara z odpornym fallbackiem do inicjałów sesji.
class _UserAvatarContent extends StatelessWidget {
  const _UserAvatarContent({required this.avatarUrl, required this.initials});

  final String? avatarUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final url = avatarUrl?.trim();
    if (url == null || url.isEmpty) return _InitialsAvatar(initials: initials);
    return ClipOval(
      child: Image.network(
        url,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _InitialsAvatar(initials: initials),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      initials,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    ),
  );
}
