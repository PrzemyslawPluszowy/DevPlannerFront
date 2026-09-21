import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Sekcja udostępniania osobie z lokalnego katalogu użytkowników.
///
/// Katalog jest zakresowy: pyta wyłącznie workspace pliku, więc lista nie może
/// pokazać użytkownika spoza kontekstu, do którego autor nie ma dostępu. Gdy
/// plik nie ma kontekstu workspace'u (plik prywatny) albo kompozycja nie podała
/// portu, sekcja mówi o tym wprost zamiast pokazywać pole, które nic nie zwraca.
final class StorageSharePeopleSection extends StatefulWidget {
  /// Tworzy sekcję udostępniania osobie.
  const StorageSharePeopleSection({
    required this.workspaceId,
    required this.userDirectory,
    super.key,
  });

  /// Workspace pliku; `null` dla pliku bez kontekstu workspace'u.
  final String? workspaceId;

  /// Port lokalnego katalogu; `null`, gdy kompozycja go nie dostarczyła.
  final StorageUserDirectoryPort? userDirectory;

  @override
  State<StorageSharePeopleSection> createState() =>
      _StorageSharePeopleSectionState();
}

class _StorageSharePeopleSectionState extends State<StorageSharePeopleSection> {
  final _controller = TextEditingController();
  List<LocalUserDirectoryResponse> _results = const [];
  LocalUserDirectoryResponse? _selected;
  StorageShareAccessLevel _level = StorageShareAccessLevel.reader;
  bool _isSearching = false;
  String? _error;

  bool get _isAvailable =>
      widget.workspaceId != null && widget.userDirectory != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final workspaceId = widget.workspaceId;
    final directory = widget.userDirectory;
    final trimmed = query.trim();
    if (workspaceId == null || directory == null) return;
    if (trimmed.length < 2) {
      setState(() {
        _results = const [];
        _isSearching = false;
      });
      return;
    }
    setState(() {
      _isSearching = true;
      _error = null;
    });
    final result = await directory.search(
      workspaceId: workspaceId,
      query: trimmed,
    );
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _isSearching = false;
        _results = const [];
        _error = error.message;
      }),
      (users) => setState(() {
        _isSearching = false;
        _results = users;
      }),
    );
  }

  Future<void> _share() async {
    final selected = _selected;
    if (selected == null) return;
    final shared = await context.read<StorageSharingCubit>().shareWithUser(
      targetUserId: selected.userId,
      accessLevel: _level,
    );
    if (!mounted || !shared) return;
    _controller.clear();
    setState(() {
      _results = const [];
      _selected = null;
      _level = StorageShareAccessLevel.reader;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAvailable) {
      return _Note(text: context.l10n.storageUserSearchWorkspaceRequired);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('storage_share_user_search'),
          controller: _controller,
          decoration: InputDecoration(
            hintText: context.l10n.storageUserInputHint,
            prefixIcon: const Icon(AppIcons.search, size: 16),
            isDense: true,
          ),
          onChanged: (value) => unawaited(_search(value)),
        ),
        if (_isSearching) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(minHeight: 2),
        ],
        if (_error case final error?) ...[
          const SizedBox(height: 8),
          Text(
            error,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.error,
            ),
          ),
        ],
        if (!_isSearching &&
            _results.isEmpty &&
            _controller.text.trim().length >= 2)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              context.l10n.storageUserSearchNoResults,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
        if (_results.isNotEmpty) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 160),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final user = _results[index];
                final isSelected = _selected?.userId == user.userId;
                return ListTile(
                  key: ValueKey('storage_share_user-${user.userId}'),
                  dense: true,
                  selected: isSelected,
                  title: Text(user.displayName, maxLines: 1),
                  subtitle: Text(user.login, maxLines: 1),
                  onTap: () => setState(() => _selected = user),
                );
              },
            ),
          ),
        ],
        if (_selected != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SegmentedButton<StorageShareAccessLevel>(
                  key: const ValueKey('storage_share_user_level'),
                  segments: [
                    ButtonSegment(
                      value: StorageShareAccessLevel.reader,
                      label: Text(context.l10n.storageAccessReader),
                    ),
                    ButtonSegment(
                      value: StorageShareAccessLevel.commenter,
                      label: Text(context.l10n.storageAccessCommenter),
                    ),
                    ButtonSegment(
                      value: StorageShareAccessLevel.editor,
                      label: Text(context.l10n.storageAccessEditor),
                    ),
                  ],
                  selected: {_level},
                  onSelectionChanged: (selection) =>
                      setState(() => _level = selection.first),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                key: const ValueKey('storage_share_user_submit'),
                onPressed: () => unawaited(_share()),
                child: Text(context.l10n.storageShareAction),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        Icons.info_outline,
        size: 16,
        color: context.colors.onSurfaceVariant,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: context.filesTheme.common.dataText.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}
