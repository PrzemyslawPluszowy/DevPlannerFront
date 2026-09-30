import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wybiera wyłącznie czyste, gotowe pliki użytkownika z prywatnego Storage.
final class ChatPrivateStoragePicker extends StatefulWidget {
  const ChatPrivateStoragePicker({required this.repository, super.key});

  final StorageRepository repository;

  static Future<List<StorageUploadInput>?> show(
    BuildContext context, {
    required StorageRepository repository,
  }) => DevPlannerModalHost.showDialog<List<StorageUploadInput>>(
    context,
    builder: (_) => ChatPrivateStoragePicker(repository: repository),
  );

  @override
  State<ChatPrivateStoragePicker> createState() =>
      _ChatPrivateStoragePickerState();
}

final class _ChatPrivateStoragePickerState
    extends State<ChatPrivateStoragePicker> {
  final _search = TextEditingController();
  final _folders = <String?>[null];
  final _selected = <String, StorageFileResponse>{};
  List<StorageFolderResponse> _folderItems = const [];
  List<StorageFileResponse> _fileItems = const [];
  String? _cursor;
  String? _error;
  bool _loading = true;
  bool _hasMore = false;

  String? get _folderId => _folders.last;

  @override
  void initState() {
    super.initState();
    unawaited(_load(reset: true));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading && !reset) return;
    setState(() {
      _loading = true;
      _error = null;
      if (reset) {
        _folderItems = const [];
        _fileItems = const [];
        _cursor = null;
      }
    });
    final scope = StorageScope.personal(folderId: _folderId);
    final folders = _search.text.trim().isEmpty
        ? await widget.repository.listFolders(
            scope: scope,
            parentFolderId: _folderId,
          )
        : null;
    final files = await widget.repository.listFiles(
      scope: scope,
      folderId: _folderId,
      cursor: reset ? null : _cursor,
      limit: 50,
      query: _search.text.trim().isEmpty ? null : _search.text.trim(),
    );
    if (!mounted) return;
    files.fold(
      (error) => setState(() {
        _loading = false;
        _error = error.message;
      }),
      (page) {
        setState(() {
          if (folders != null) {
            folders.fold(
              (error) => _error = error.message,
              (values) => _folderItems = values
                  .where((folder) => folder.canRead)
                  .toList(growable: false),
            );
          }
          final eligible = page.items.where(_isEligible);
          _fileItems = reset
              ? eligible.toList(growable: false)
              : [..._fileItems, ...eligible];
          _cursor = page.nextCursor;
          _hasMore = page.nextCursor != null;
          _loading = false;
        });
      },
    );
  }

  bool _isEligible(StorageFileResponse file) =>
      !file.isDeleted &&
      file.resourceType == StorageResourceType.privateFile &&
      file.canRead &&
      file.scanStatus == StorageScanStatus.clean &&
      file.processingStatus == StorageProcessingStatus.ready &&
      _chatSupportsMime(file.mimeType);

  bool _chatSupportsMime(String mimeType) => const <String>{
    'image/png',
    'image/jpeg',
    'image/webp',
    'image/gif',
    'audio/mpeg',
    'audio/ogg',
    'audio/wav',
    'video/mp4',
    'video/webm',
    'application/pdf',
    'application/zip',
    'application/json',
    'text/plain',
    'text/markdown',
    'text/csv',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  }.contains(mimeType.split(';').first.trim().toLowerCase());

  void _toggle(StorageFileResponse file) => setState(() {
    if (_selected.remove(file.id) == null) _selected[file.id] = file;
  });

  void _enterFolder(String id) {
    _folders.add(id);
    unawaited(_load(reset: true));
  }

  void _goUp() {
    if (_folders.length <= 1) return;
    _folders.removeLast();
    unawaited(_load(reset: true));
  }

  void _confirm() => Navigator.of(context).pop(
    _selected.values
        .map(
          (file) => StorageUploadInput(
            name: file.originalFileName,
            size: file.fileSizeBytes,
            mimeType: file.mimeType,
            sourceStorageFileId: file.id,
          ),
        )
        .toList(growable: false),
  );

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return ChatSurfaceDialog(
      title: context.l10n.chatComposerAddPrivateFile,
      subtitle: context.l10n.chatPrivateFilesOnlyClean,
      leading: Icon(Symbols.folder_open, color: chat.metadataText),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => unawaited(_load(reset: true)),
              decoration: InputDecoration(
                hintText: context.l10n.chatPrivateFilesSearch,
                prefixIcon: const Icon(Symbols.search),
                suffixIcon: IconButton(
                  tooltip: context.l10n.frameworkClose,
                  onPressed: () {
                    _search.clear();
                    unawaited(_load(reset: true));
                  },
                  icon: const Icon(Symbols.close),
                ),
              ),
            ),
            if (_folders.length > 1 && _search.text.isEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _goUp,
                  icon: const Icon(Symbols.arrow_upward),
                  label: Text(context.l10n.chatPrivateFilesParentFolder),
                ),
              ),
            if (_error case final error?)
              Padding(
                padding: const EdgeInsets.all(Sizes.p16),
                child: Text(error, style: TextStyle(color: chat.error)),
              ),
            if (_loading && _fileItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(Sizes.p24),
                child: CircularProgressIndicator(),
              ),
            if (!_loading && _folderItems.isEmpty && _fileItems.isEmpty)
              Padding(
                padding: const EdgeInsets.all(Sizes.p24),
                child: Text(context.l10n.chatPrivateFilesEmpty),
              ),
            for (final folder in _folderItems)
              ListTile(
                leading: const Icon(Symbols.folder),
                title: Text(folder.name, maxLines: 1),
                trailing: const Icon(Symbols.chevron_right),
                onTap: () => _enterFolder(folder.id),
              ),
            for (final file in _fileItems)
              CheckboxListTile(
                value: _selected.containsKey(file.id),
                onChanged: (_) => _toggle(file),
                secondary: const Icon(Symbols.description),
                title: Text(file.originalFileName, maxLines: 1),
                subtitle: Text(_formatSize(file.fileSizeBytes)),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            if (_hasMore && !_loading)
              TextButton.icon(
                onPressed: () => unawaited(_load()),
                icon: const Icon(Symbols.expand_more),
                label: Text(context.l10n.chatPrivateFilesLoadMore),
              ),
            if (_loading && _fileItems.isNotEmpty)
              const LinearProgressIndicator(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.chatCreationCancel),
        ),
        FilledButton(
          onPressed: _selected.isEmpty ? null : _confirm,
          child: Text(context.l10n.chatPrivateFilesAdd(_selected.length)),
        ),
      ],
    );
  }

  String _formatSize(int bytes) => switch (bytes) {
    < 1024 => '$bytes B',
    < 1024 * 1024 => '${(bytes / 1024).toStringAsFixed(1)} KB',
    _ => '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB',
  };
}
