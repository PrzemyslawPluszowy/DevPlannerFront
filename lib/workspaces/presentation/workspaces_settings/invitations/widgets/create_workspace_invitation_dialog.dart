import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/workspace_role.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

/// Modal wyszukiwania użytkownika w katalogu Ready i wysyłania zaproszenia do workspace.
class CreateWorkspaceInvitationDialog extends StatefulWidget {
  const CreateWorkspaceInvitationDialog({
    required this.onSearch,
    super.key,
  });

  /// Funkcja wyszukująca w katalogu Ready.
  final Future<List<ReadyDirectoryUserResponse>> Function(String query)
  onSearch;

  @override
  State<CreateWorkspaceInvitationDialog> createState() =>
      _CreateWorkspaceInvitationDialogState();
}

class _CreateWorkspaceInvitationDialogState
    extends State<CreateWorkspaceInvitationDialog> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;
  List<ReadyDirectoryUserResponse> _results = [];
  ReadyDirectoryUserResponse? _selectedUser;
  WorkspaceRole _selectedRole = WorkspaceRole.member;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().length < 2) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _isSearching = true);
      final users = await widget.onSearch(query.trim());
      if (mounted) {
        setState(() {
          _results = users;
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspaceSettingsInviteDialogTitle,
      subtitle: 'Wyszukaj użytkownika systemu Ready i zaproś go do przestrzeni roboczej.',
      icon: Icons.person_add_rounded,
      submitLabel: l10n.workspaceSettingsInviteUserButton,
      cancelLabel: l10n.tasksListCancelButton,
      onSubmit: () {
        if (_selectedUser != null) {
          Navigator.of(context).pop((
            readyUserId: _selectedUser!.readyUserId,
            role: _selectedRole,
          ));
        }
      },
      body: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onQueryChanged,
            style: context.text.bodySmall?.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: l10n.workspaceSettingsSearchReadyHint,
              hintStyle: context.text.bodySmall?.copyWith(
                fontSize: 12.5,
                color: colors.onSurfaceVariant.withValues(alpha: .6),
              ),
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              suffixIcon: _isSearching
                  ? const Padding(
                      padding: .all(Sizes.p12),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          Gaps.h12,
          if (_selectedUser != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.primary.withValues(alpha: .5)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: colors.primary,
                    child: Text(
                      _selectedUser!.displayName.isNotEmpty
                          ? _selectedUser!.displayName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Gaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          _selectedUser!.displayName,
                          style: context.text.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: colors.onSurface,
                          ),
                        ),
                        Text(
                          'Login: ${_selectedUser!.login} | ID: #${_selectedUser!.readyUserId}',
                          style: context.text.labelSmall?.copyWith(
                            fontSize: 11.5,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () => setState(() => _selectedUser = null),
                  ),
                ],
              ),
            ),
            Gaps.h16,
            Text(
              'Rola w przestrzeni',
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<WorkspaceRole>(
                  value: _selectedRole,
                  isExpanded: true,
                  dropdownColor: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  elevation: 3,
                  menuMaxHeight: 260,
                  style: context.text.bodySmall?.copyWith(fontSize: 13),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  items: [
                    DropdownMenuItem(
                      value: WorkspaceRole.admin,
                      child: Text(
                        l10n.workspaceSettingsMemberRoleAdmin,
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                    DropdownMenuItem(
                      value: WorkspaceRole.member,
                      child: Text(
                        l10n.workspaceSettingsMemberRoleMember,
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                    DropdownMenuItem(
                      value: WorkspaceRole.observer,
                      child: Text(
                        l10n.workspaceSettingsMemberRoleObserver,
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedRole = val);
                  },
                ),
              ),
            ),
          ] else if (_results.isNotEmpty) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _results.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: colors.outlineVariant.withValues(alpha: .5),
                ),
                itemBuilder: (ctx, index) {
                  final user = _results[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    leading: CircleAvatar(
                      radius: 13,
                      backgroundColor: colors.surfaceContainerHigh,
                      child: Text(
                        user.displayName.isNotEmpty
                            ? user.displayName[0].toUpperCase()
                            : '?',
                        style: context.text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    title: Text(
                      user.displayName,
                      style: const TextStyle(fontSize: 13),
                    ),
                    subtitle: Text(
                      'Login: ${user.login} | ID: #${user.readyUserId}',
                      style: context.text.labelSmall?.copyWith(fontSize: 11),
                    ),
                    onTap: () => setState(() => _selectedUser = user),
                  );
                },
              ),
            ),
          ] else if (_searchController.text.trim().length >= 2 &&
              !_isSearching) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Nie znaleziono użytkowników pasujących do zapytania.',
                  style: context.text.bodySmall?.copyWith(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ] else ...[
            Text(
              l10n.workspaceSettingsSearchReadyMinChars,
              style: context.text.bodySmall?.copyWith(
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
