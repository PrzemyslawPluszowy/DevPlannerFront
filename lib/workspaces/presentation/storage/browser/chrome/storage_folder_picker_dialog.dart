import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:flutter/material.dart';

/// Wybór folderu docelowego w bieżącym zakresie.
///
/// Picker pokazuje wyłącznie foldery osiągalne w tym samym zakresie, więc nie
/// pozwala wskazać celu, którego przeniesienie i tak zostałoby odrzucone przez
/// walidację kontekstu. Samo przeniesienie należy do wywołującego — dialog
/// zwraca tylko identyfikator i nie zna Cubitów modułu.
final class StorageFolderPickerDialog extends StatefulWidget {
  /// Tworzy picker folderu.
  const StorageFolderPickerDialog({
    required this.repository,
    required this.scope,
    this.disabledFolderIds = const {},
    super.key,
  });

  /// Pokazuje picker i zwraca wybrany folder albo `null`.
  static Future<StorageFolderResponse?> show(
    BuildContext context, {
    required StorageRepository repository,
    required StorageScope scope,
    Set<String> disabledFolderIds = const {},
  }) => showDialog<StorageFolderResponse>(
    context: context,
    builder: (_) => StorageFolderPickerDialog(
      repository: repository,
      scope: scope,
      disabledFolderIds: disabledFolderIds,
    ),
  );

  /// Repozytorium z composition rootu.
  final StorageRepository repository;

  /// Zakres, w którym wolno wybierać foldery.
  final StorageScope scope;

  /// Foldery, których nie można wskazać (np. obecny folder elementu).
  final Set<String> disabledFolderIds;

  @override
  State<StorageFolderPickerDialog> createState() =>
      _StorageFolderPickerDialogState();
}

class _StorageFolderPickerDialogState extends State<StorageFolderPickerDialog> {
  final List<StorageFolderResponse> _path = [];
  List<StorageFolderResponse> _folders = const [];
  bool _isLoading = true;
  String? _error;

  String? get _parentId =>
      _path.isEmpty ? widget.scope.folderId : _path.last.id;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final result = await widget.repository.listFolders(
      scope: widget.scope.copyWithFolder(_parentId),
      parentFolderId: _parentId,
    );
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _isLoading = false;
        _error = error.message;
      }),
      (folders) => setState(() {
        _isLoading = false;
        _folders = folders;
      }),
    );
  }

  Future<void> _open(StorageFolderResponse folder) async {
    setState(() => _path.add(folder));
    await _load();
  }

  Future<void> _up() async {
    if (_path.isEmpty) return;
    setState(_path.removeLast);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    final selected = _path.isEmpty ? null : _path.last;
    final canConfirm =
        selected != null && !widget.disabledFolderIds.contains(selected.id);

    return AlertDialog(
      title: Text(context.l10n.storageMoveDialogTitle),
      content: SizedBox(
        width: 420,
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  key: const ValueKey('storage_picker_up'),
                  icon: const Icon(AppIcons.arrowLeft, size: 18),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: _path.isEmpty ? null : _up,
                ),
                Expanded(
                  child: Text(
                    selected?.name ?? context.l10n.storageMoveDialogRoot,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: common.controlText.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: common.controlGap),
            Expanded(child: _body(common, colors)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('storage_picker_confirm'),
          onPressed: canConfirm
              ? () => Navigator.of(context).pop(selected)
              : null,
          child: Text(context.l10n.storageMoveConfirm),
        ),
      ],
    );
  }

  Widget _body(DevPlannerTasksTheme common, ColorScheme colors) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (_error case final error?) {
      return Center(
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: common.dataText.copyWith(color: colors.error),
        ),
      );
    }
    if (_folders.isEmpty) {
      return Center(
        child: Text(
          context.l10n.storageMoveDialogNoSubfolders,
          textAlign: TextAlign.center,
          style: common.dataText.copyWith(color: colors.onSurfaceVariant),
        ),
      );
    }
    return ListView.builder(
      itemCount: _folders.length,
      itemBuilder: (context, index) {
        final folder = _folders[index];
        final disabled = widget.disabledFolderIds.contains(folder.id);
        return ListTile(
          key: ValueKey('storage_picker_folder-${folder.id}'),
          dense: true,
          enabled: !disabled,
          leading: const Icon(AppIcons.folder, size: 18),
          title: Text(folder.name),
          subtitle: folder.itemCount > 0
              ? Text(context.l10n.storageItemsCount(folder.itemCount))
              : null,
          trailing: disabled
              ? null
              : const Icon(AppIcons.chevronRight, size: 16),
          onTap: disabled ? null : () => unawaited(_open(folder)),
        );
      },
    );
  }
}
