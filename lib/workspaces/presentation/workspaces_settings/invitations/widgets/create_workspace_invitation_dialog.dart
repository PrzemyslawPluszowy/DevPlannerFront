import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';

/// Modal wyszukiwania użytkownika w lokalnym katalogu i wysyłania zaproszenia.
class CreateWorkspaceInvitationDialog extends StatefulWidget {
  const CreateWorkspaceInvitationDialog({
    required this.onSearch,
    super.key,
  });

  /// Funkcja wyszukująca w lokalnym katalogu użytkowników.
  final Future<List<LocalUserDirectoryResponse>> Function(String query)
  onSearch;

  @override
  State<CreateWorkspaceInvitationDialog> createState() =>
      _CreateWorkspaceInvitationDialogState();
}

class _CreateWorkspaceInvitationDialogState
    extends State<CreateWorkspaceInvitationDialog> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<_InvitationDialogDraft> _draft = ValueNotifier(
    const _InvitationDialogDraft(),
  );
  Timer? _debounce;
  int _searchGeneration = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _draft.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    final generation = ++_searchGeneration;
    if (query.trim().length < 2) {
      _draft.value = _draft.value.copyWith(
        clearResults: true,
        isSearching: false,
      );
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      _draft.value = _draft.value.copyWith(isSearching: true);
      try {
        final users = await widget.onSearch(query.trim());
        if (mounted && generation == _searchGeneration) {
          _draft.value = _draft.value.copyWith(
            results: users,
            isSearching: false,
          );
        }
      } catch (_) {
        if (mounted && generation == _searchGeneration) {
          _draft.value = _draft.value.copyWith(
            clearResults: true,
            isSearching: false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspaceSettingsInviteDialogTitle,
      subtitle: 'Wyszukaj użytkownika i zaproś go do przestrzeni roboczej.',
      icon: Icons.person_add_rounded,
      submitLabel: l10n.workspaceSettingsInviteUserButton,
      cancelLabel: l10n.tasksListCancelButton,
      onSubmit: () {
        final selectedUser = _draft.value.selectedUser;
        if (selectedUser != null) {
          Navigator.of(context).pop((
            userId: selectedUser.userId,
            role: _draft.value.selectedRole,
          ));
        }
      },
      body: ValueListenableBuilder(
        valueListenable: _draft,
        builder: (context, draft, _) => Column(
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
                suffixIcon: draft.isSearching
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
            if (draft.selectedUser case final selectedUser?) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: .5),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: colors.primary,
                      child: Text(
                        selectedUser.displayName.isNotEmpty
                            ? selectedUser.displayName[0].toUpperCase()
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
                            selectedUser.displayName,
                            style: context.text.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: colors.onSurface,
                            ),
                          ),
                          Text(
                            'Login: ${selectedUser.login} | ID: ${selectedUser.userId}',
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
                      onPressed: () => _draft.value = draft.copyWith(
                        clearSelectedUser: true,
                      ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.7),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<WorkspaceRole>(
                    value: draft.selectedRole,
                    isExpanded: true,
                    dropdownColor: colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8),
                    elevation: 3,
                    menuMaxHeight: 260,
                    style: context.text.bodySmall?.copyWith(fontSize: 13),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                    ),
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
                      if (val != null) {
                        _draft.value = draft.copyWith(selectedRole: val);
                      }
                    },
                  ),
                ),
              ),
            ] else if (draft.results.isNotEmpty) ...[
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: draft.results.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: colors.outlineVariant.withValues(alpha: .5),
                  ),
                  itemBuilder: (ctx, index) {
                    final user = draft.results[index];
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
                        'Login: ${user.login} | ID: ${user.userId}',
                        style: context.text.labelSmall?.copyWith(fontSize: 11),
                      ),
                      onTap: () => _draft.value = draft.copyWith(
                        selectedUser: user,
                      ),
                    );
                  },
                ),
              ),
            ] else if (_searchController.text.trim().length >= 2 &&
                !draft.isSearching) ...[
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
      ),
    );
  }
}

/// Niemutowalny szkic przejściowego stanu dialogu zaproszenia.
class _InvitationDialogDraft {
  const _InvitationDialogDraft({
    this.isSearching = false,
    this.results = const [],
    this.selectedUser,
    this.selectedRole = WorkspaceRole.member,
  });

  final bool isSearching;
  final List<LocalUserDirectoryResponse> results;
  final LocalUserDirectoryResponse? selectedUser;
  final WorkspaceRole selectedRole;

  _InvitationDialogDraft copyWith({
    bool? isSearching,
    List<LocalUserDirectoryResponse>? results,
    LocalUserDirectoryResponse? selectedUser,
    WorkspaceRole? selectedRole,
    bool clearResults = false,
    bool clearSelectedUser = false,
  }) => _InvitationDialogDraft(
    isSearching: isSearching ?? this.isSearching,
    results: clearResults ? const [] : (results ?? this.results),
    selectedUser: clearSelectedUser
        ? null
        : (selectedUser ?? this.selectedUser),
    selectedRole: selectedRole ?? this.selectedRole,
  );
}
