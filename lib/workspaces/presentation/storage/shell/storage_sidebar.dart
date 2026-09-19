import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Panel boczny (Sidebar) modułu Files ze skrótami do sekcji: Moje pliki, Udostępnione, Ostatnie, Ulubione, Kosz.
class StorageSidebar extends StatelessWidget {
  /// Tworzy pasek boczny.
  const StorageSidebar({this.compact = false, super.key});

  /// Czy panel ma pokazywać wyłącznie ikony w wąskim oknie.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.watch<StorageBrowserCubit>();
    final currentScope = cubit.currentScope;

    void selectScope(StorageScope scope) {
      unawaited(cubit.setScope(scope));
    }

    return Container(
      width: compact ? 56 : 220,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        border: Border(
          right: BorderSide(
            color: context.colors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        children: [
          _SidebarItem(
            icon: AppIcons.folder,
            label: l10n.storageMyFiles,
            isSelected:
                currentScope.isPersonal && currentScope.folderId == null,
            onTap: () => selectScope(const StorageScope.personal()),
            compact: compact,
          ),
          _SidebarItem(
            icon: AppIcons.users,
            label: l10n.storageSharedWithMe,
            isSelected: currentScope.isSharedWithMe,
            onTap: () => selectScope(const StorageScope.shared()),
            compact: compact,
          ),
          _SidebarItem(
            icon: AppIcons.clock,
            label: l10n.storageRecent,
            isSelected: currentScope.isRecent,
            onTap: () => selectScope(const StorageScope.recent()),
            compact: compact,
          ),
          _SidebarItem(
            icon: AppIcons.star,
            label: l10n.storageFavorites,
            isSelected: currentScope.isFavorites,
            onTap: () => selectScope(const StorageScope.favorites()),
            compact: compact,
          ),
          const Divider(height: 16),
          _SidebarItem(
            icon: AppIcons.delete,
            label: l10n.storageTrash,
            isSelected: currentScope.isTrash,
            onTap: () => selectScope(const StorageScope.trash()),
            compact: compact,
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Tooltip(
        message: label,
        child: Semantics(
          button: true,
          selected: isSelected,
          label: label,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Ink(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected
                      ? context.colors.primaryContainer.withValues(alpha: 0.4)
                      : null,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        dense: true,
        minLeadingWidth: 0,
        horizontalTitleGap: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        selected: isSelected,
        selectedTileColor: context.colors.primaryContainer.withValues(
          alpha: 0.4,
        ),
        leading: Icon(
          icon,
          size: 18,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : context.colors.onSurfaceVariant,
        ),
        title: Text(
          label,
          style: context.text.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : context.colors.onSurface,
          ),
        ),
        titleTextStyle: context.text.bodyMedium,
        onTap: onTap,
      ),
    );
  }
}
