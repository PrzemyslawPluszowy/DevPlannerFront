import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Własny edytor linku opisu zachowuje wybór tekstu i nie otwiera adresu URL.
final class TaskDescriptionLinkButton extends StatelessWidget {
  const TaskDescriptionLinkButton({
    required this.controller,
    this.editorFocusNode,
    super.key,
  });
  final quill.QuillController controller;
  final FocusNode? editorFocusNode;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.l10n.taskDescriptionLink,
    icon: const Icon(Symbols.link_rounded, size: 21),
    onPressed: controller.readOnly ? null : () => _edit(context),
  );

  Future<void> _edit(BuildContext context) async {
    if (controller.readOnly) return;
    final selection = controller.selection;
    var start = selection.start;
    var length = selection.end - start;
    final currentLink =
        controller
                .getSelectionStyle()
                .attributes[quill.Attribute.link.key]
                ?.value
            as String?;
    if (currentLink != null) {
      final leaf = controller.document.querySegmentLeafNode(start).leaf;
      if (leaf != null) {
        final range = quill.getLinkRange(leaf);
        start = range.start;
        length = range.end - range.start;
      }
    }
    final text = length == 0
        ? ''
        : controller.document.getPlainText(start, length);
    final result =
        await DevPlannerModalHost.showDialog<TaskDescriptionLinkChoice>(
          context,
          builder: (_) =>
              TaskDescriptionLinkDialog(text: text, link: currentLink),
        );
    if (!context.mounted || controller.readOnly) return;
    controller.updateSelection(selection, quill.ChangeSource.local);
    if (result != null) {
      if (result.text != text) {
        controller.replaceText(start, length, result.text, null);
      }
      controller.formatText(
        start,
        result.text.length,
        quill.LinkAttribute(result.link),
      );
    }
    editorFocusNode?.requestFocus();
  }
}

final class TaskDescriptionLinkChoice {
  const TaskDescriptionLinkChoice({required this.text, required this.link});
  final String text;
  final String? link;
}

final class TaskDescriptionLinkDialog extends StatefulWidget {
  const TaskDescriptionLinkDialog({required this.text, this.link, super.key});
  final String text;
  final String? link;

  /// Schematy obsługiwane przez dotychczasowy Quill; nie uruchamia adresu.
  static bool isValidUrl(String value) {
    if (RegExp(r'\s').hasMatch(value)) return false;
    final uri = Uri.tryParse(value);
    if (uri == null) return false;
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      return uri.host.isNotEmpty;
    }
    const schemes = {
      'mailto',
      'tel',
      'sms',
      'callto',
      'wtai',
      'market',
      'geopoint',
      'ymsgr',
      'msnim',
      'gtalk',
      'skype',
      'sip',
      'whatsapp',
    };
    return schemes.contains(uri.scheme) &&
        value.substring(uri.scheme.length + 1).isNotEmpty;
  }

  @override
  State<TaskDescriptionLinkDialog> createState() =>
      _TaskDescriptionLinkDialogState();
}

final class _TaskDescriptionLinkDialogState
    extends State<TaskDescriptionLinkDialog> {
  late final TextEditingController _text;
  late final TextEditingController _url;
  final ValueNotifier<bool> _showValidation = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: widget.text);
    _url = TextEditingController(text: widget.link ?? '');
  }

  @override
  void dispose() {
    _text.dispose();
    _url.dispose();
    _showValidation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: _showValidation,
    builder: (context, showValidation, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDescriptionLinkTitle,
      icon: Symbols.link_rounded,
      accentColor: context.colors.primary,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      onSubmit: _save,
      additionalActions: widget.link == null
          ? null
          : [
              TextButton(
                onPressed: _remove,
                child: Text(context.l10n.taskDescriptionRemoveLink),
              ),
            ],
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _text,
            onChanged: _clearValidation,
            autofocus: true,
            decoration: InputDecoration(
              labelText: context.l10n.taskDescriptionLinkText,
              errorText: showValidation && _text.text.trim().isEmpty
                  ? context.l10n.taskDescriptionLinkTextRequired
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _url,
            onChanged: _clearValidation,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: context.l10n.taskDescriptionLinkUrl,
              hintText: context.l10n.taskDescriptionLinkUrlHint,
              errorText:
                  showValidation &&
                      !TaskDescriptionLinkDialog.isValidUrl(_url.text.trim())
                  ? context.l10n.taskDescriptionLinkInvalid
                  : null,
            ),
          ),
        ],
      ),
    ),
  );

  void _clearValidation(String _) => _showValidation.value = false;

  void _save() {
    if (_text.text.trim().isEmpty ||
        !TaskDescriptionLinkDialog.isValidUrl(_url.text.trim())) {
      _showValidation.value = true;
      return;
    }
    Navigator.of(
      context,
    ).pop(
      TaskDescriptionLinkChoice(
        text: _text.text.trim(),
        link: _url.text.trim(),
      ),
    );
  }

  void _remove() =>
      Navigator.of(context)
          .pop(TaskDescriptionLinkChoice(text: widget.text, link: null));
}
