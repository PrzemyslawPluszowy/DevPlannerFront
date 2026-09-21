import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pole wyszukiwania eksploratora plików.
///
/// Widget jest jedynym właścicielem kontrolera tekstu. Gdy Cubit porzuca tekst
/// zapytania — a robi to przy każdej zmianie zakresu — pole czyści się razem
/// z nim, żeby nie pokazywać frazy, której wyniki już nie obowiązują.
class StorageSearchField extends StatefulWidget {
  /// Tworzy pole wyszukiwania.
  const StorageSearchField({this.expanded = false, super.key});

  /// Czy pole zajmuje całą dostępną szerokość (osobny wiersz na małym ekranie).
  final bool expanded;

  @override
  State<StorageSearchField> createState() => _StorageSearchFieldState();
}

class _StorageSearchFieldState extends State<StorageSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(common.controlRadius),
      borderSide: BorderSide(
        color: common.commandBarBorder.withValues(alpha: 0.6),
      ),
    );

    return BlocListener<StorageBrowserCubit, StorageBrowserState>(
      listenWhen: (previous, current) =>
          _scopeOf(previous) != _scopeOf(current),
      listener: (context, state) {
        if (_controller.text.isEmpty) return;
        _controller.clear();
      },
      child: SizedBox(
        width: widget.expanded ? null : 220,
        height: 28,
        child: TextField(
          key: const ValueKey('storage_search_field'),
          controller: _controller,
          textInputAction: TextInputAction.search,
          style: common.controlText.copyWith(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: context.l10n.storageSearchHint,
            hintStyle: common.controlText.copyWith(
              color: colors.onSurfaceVariant,
            ),
            prefixIcon: const Icon(AppIcons.search, size: 16),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 30,
              minHeight: 28,
            ),
            isDense: true,
            filled: true,
            fillColor: common.commandBarSurface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: common.controlGap,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(color: common.selectionAccent),
            ),
          ),
          onChanged: context.read<StorageBrowserCubit>().search,
        ),
      ),
    );
  }
}

StorageScope _scopeOf(StorageBrowserState state) => switch (state) {
  StorageBrowserInitial(:final scope) => scope,
  StorageBrowserLoading(:final scope) => scope,
  StorageBrowserReady(:final scope) => scope,
  StorageBrowserEmpty(:final scope) => scope,
  StorageBrowserFailure(:final scope) => scope,
  StorageBrowserForbidden(:final scope) => scope,
};
