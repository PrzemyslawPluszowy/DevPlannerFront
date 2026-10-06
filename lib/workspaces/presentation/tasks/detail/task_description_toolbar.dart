import 'package:devplanner/workspaces/presentation/tasks/detail/task_description_color_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_description_link_button.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Lokalne etykiety narzędzi opisu; nie zmienia lokalizacji Quill w innych modułach.
final class TaskDescriptionToolbar extends StatelessWidget {
  const TaskDescriptionToolbar({
    required this.controller,
    this.editorFocusNode,
    super.key,
  });
  final quill.QuillController controller;
  final FocusNode? editorFocusNode;

  @override
  Widget build(BuildContext context) => quill.QuillSimpleToolbar(
    controller: controller,
    config: quill.QuillSimpleToolbarConfig(
      multiRowsDisplay: false,
      showFontFamily: false,
      showFontSize: false,
      showCodeBlock: false,
      showSearchButton: false,
      showInlineCode: false,
      buttonOptions: quill.QuillSimpleToolbarButtonOptions(
        undoHistory: quill.QuillToolbarHistoryButtonOptions(
          tooltip: context.l10n.taskDescriptionUndo,
        ),
        redoHistory: quill.QuillToolbarHistoryButtonOptions(
          tooltip: context.l10n.taskDescriptionRedo,
        ),
        bold: quill.QuillToolbarToggleStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionBold,
        ),
        italic: quill.QuillToolbarToggleStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionItalic,
        ),
        underLine: quill.QuillToolbarToggleStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionUnderline,
        ),
        strikeThrough: quill.QuillToolbarToggleStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionStrike,
        ),
        subscript: quill.QuillToolbarToggleStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionSubscript,
        ),
        superscript: quill.QuillToolbarToggleStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionSuperscript,
        ),
        color: quill.QuillToolbarColorButtonOptions(
          tooltip: context.l10n.taskDescriptionFontColor,
          customOnPressedCallback: (controller, background) =>
              _chooseColor(context, controller, background),
        ),
        backgroundColor: quill.QuillToolbarColorButtonOptions(
          tooltip: context.l10n.taskDescriptionBackgroundColor,
          customOnPressedCallback: (controller, background) =>
              _chooseColor(context, controller, background),
        ),
        clearFormat: quill.QuillToolbarClearFormatButtonOptions(
          tooltip: context.l10n.taskDescriptionClearFormat,
        ),
        selectHeaderStyleDropdownButton:
            quill.QuillToolbarSelectHeaderStyleDropdownButtonOptions(
              tooltip: context.l10n.taskDescriptionHeader,
            ),
        listNumbers: quill.QuillToolbarToggleStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionNumberedList,
        ),
        listBullets: quill.QuillToolbarToggleStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionBulletList,
        ),
        toggleCheckList: quill.QuillToolbarToggleCheckListButtonOptions(
          tooltip: context.l10n.taskDescriptionCheckList,
        ),
        quote: quill.QuillToolbarToggleStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionQuote,
        ),
        indentIncrease: quill.QuillToolbarIndentButtonOptions(
          tooltip: context.l10n.taskDescriptionIncreaseIndent,
        ),
        indentDecrease: quill.QuillToolbarIndentButtonOptions(
          tooltip: context.l10n.taskDescriptionDecreaseIndent,
        ),
        linkStyle: quill.QuillToolbarLinkStyleButtonOptions(
          tooltip: context.l10n.taskDescriptionLink,
          childBuilder: _linkButton,
        ),
      ),
    ),
  );
  Widget _linkButton(
    Object? options,
    Object? extra,
  ) => TaskDescriptionLinkButton(
    controller: controller,
    editorFocusNode: editorFocusNode,
  );

  Future<void> _chooseColor(
    BuildContext context,
    quill.QuillController source,
    bool background,
  ) async {
    if (source.readOnly) return;
    final selection = source.selection;
    final attribute = background
        ? quill.Attribute.background
        : quill.Attribute.color;
    final initial =
        source.getSelectionStyle().attributes[attribute.key]?.value as String?;
    final choice = await TaskDescriptionColorPicker.show(
      context,
      title: background
          ? context.l10n.taskDescriptionBackgroundColor
          : context.l10n.taskDescriptionFontColor,
      initialValue: initial,
    );
    if (!context.mounted || source.readOnly) return;
    source.updateSelection(selection, quill.ChangeSource.local);
    if (choice != null) {
      source.formatSelection(
        background
            ? quill.BackgroundAttribute(choice.value)
            : quill.ColorAttribute(choice.value),
      );
    }
    editorFocusNode?.requestFocus();
  }
}
