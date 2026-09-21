import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_active_filter_strip.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_command_row.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_context_row.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/toolbar/storage_search_field.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';

/// Rama chrome'u modułu Pliki: dwa wiersze i jedna powierzchnia.
///
/// Oba wiersze dzielą tło, obramowanie i odstępy, więc moduł wygląda jak jedna
/// powierzchnia danych, a nie jak trzy niezależne paski. Progi reagują na
/// szerokość oddaną modułowi, a nie na szerokość okna — sidebar produktu i
/// sidebar zakresów zabierają część miejsca, którą trzeba uwzględnić.
final class StorageBrowserChrome extends StatelessWidget {
  /// Tworzy chrome eksploratora plików.
  const StorageBrowserChrome({
    this.capabilities = StorageShellCapabilities.readOnly,
    this.filePicker,
    super.key,
  });

  /// Uprawnienia kompozycji decydujące o widoczności akcji.
  final StorageShellCapabilities capabilities;

  /// Picker plików wymagany przez akcję wysyłania.
  final FilePickerPort? filePicker;

  /// Szerokość, poniżej której akcje drugorzędne zwijają się do jednego menu.
  static const double _narrowWidth = 760;

  /// Szerokość, poniżej której wyszukiwanie przechodzi do własnego wiersza.
  static const double _inlineSearchWidth = 560;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: common.canvas,
        border: Border(bottom: BorderSide(color: common.canvasBorder)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: common.sectionGap,
          vertical: common.tightGap,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isNarrow = width < _narrowWidth;
            final showInlineSearch = width >= _inlineSearchWidth;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StorageChromeContextRow(
                  capabilities: capabilities,
                  filePicker: filePicker,
                  isNarrow: isNarrow,
                ),
                SizedBox(height: common.tightGap),
                StorageChromeCommandRow(
                  capabilities: capabilities,
                  showInlineSearch: showInlineSearch,
                ),
                const StorageActiveFilterStrip(),
                if (!showInlineSearch) ...[
                  SizedBox(height: common.tightGap),
                  const StorageSearchField(expanded: true),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
