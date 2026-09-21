import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_filter_menu.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/toolbar/storage_breadcrumbs.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/toolbar/storage_search_field.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/toolbar/storage_sort_menu.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/toolbar/storage_view_mode_toggle.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Drugi wiersz chrome'u Plików: okruszki, wyszukiwanie i kontrolki widoku.
///
/// Wiersz ma jeden slot na akcje kontekstowe: przy aktywnym zaznaczeniu zastępuje
/// go pasek akcji masowych, więc w chrome nigdy nie ma dwóch pasków masowych
/// jednocześnie.
final class StorageChromeCommandRow extends StatelessWidget {
  /// Tworzy wiersz poleceń.
  const StorageChromeCommandRow({
    this.capabilities = StorageShellCapabilities.readOnly,
    this.showInlineSearch = true,
    super.key,
  });

  /// Uprawnienia kompozycji przekazywane do paska akcji masowych.
  final StorageShellCapabilities capabilities;

  /// Czy wyszukiwanie mieści się w tym wierszu. Na węższych ekranach dostaje
  /// własny wiersz, ale nigdy nie znika.
  final bool showInlineSearch;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;

    return BlocBuilder<StorageSelectionCubit, StorageSelectionState>(
      builder: (context, selection) => ConstrainedBox(
        constraints: BoxConstraints(minHeight: common.commandRowHeight),
        child: selection.hasSelection
            ? StorageBulkBar(capabilities: capabilities)
            : Row(
                children: [
                  const Expanded(child: StorageBreadcrumbs()),
                  if (showInlineSearch) ...[
                    SizedBox(width: common.controlGap),
                    const StorageSearchField(),
                  ],
                  SizedBox(width: common.controlGap),
                  const _StorageViewControls(),
                ],
              ),
      ),
    );
  }
}

/// Kontrolki widoku, sensowne tylko wtedy, gdy istnieje lista do sterowania.
///
/// W stanie błędu i odmowy dostępu sortowanie i przełącznik widoku nie mają na
/// czym działać, a pokazane wyglądałyby na martwe.
class _StorageViewControls extends StatelessWidget {
  const _StorageViewControls();

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    return BlocSelector<StorageBrowserCubit, StorageBrowserState, bool>(
      selector: (state) =>
          state is! StorageBrowserFailure && state is! StorageBrowserForbidden,
      builder: (context, hasList) => hasList
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const StorageFilterMenu(),
                SizedBox(width: common.controlGap),
                const StorageSortMenu(),
                SizedBox(width: common.controlGap),
                const StorageViewModeToggle(),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
