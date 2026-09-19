import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lokalny launcher zakotwiczonego panelu edycji tekstu lub liczby.
final class AnchoredTextEditor {
  const AnchoredTextEditor._();

  static Future<String?> edit(
    BuildContext context, {
    required String title,
    required String initialValue,
    required RelativeRect menuPosition,
    bool isNumber = false,
    bool allowClear = false,
  }) async {
    final overlay = Navigator.of(context, rootNavigator: true).overlay;
    final box = overlay?.context.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final result = Completer<String?>();
    await AppContextMenu.showCustom(
      context,
      globalPosition: box.localToGlobal(
        Offset(menuPosition.left, menuPosition.top),
      ),
      maxWidth: 260,
      maxHeight: allowClear ? 150 : 116,
      contentBuilder: (_, dismiss) => _CustomTextFieldPanel(
        title: title,
        isNumber: isNumber,
        initialValue: initialValue,
        onCancel: dismiss,
        onClear: allowClear
            ? () {
                if (!result.isCompleted) result.complete('');
                dismiss();
              }
            : null,
        onSubmit: (answer) {
          if (!result.isCompleted) result.complete(answer);
          dismiss();
        },
      ),
    );
    return result.isCompleted ? result.future : null;
  }
}

class _CancelInlineInputIntent extends Intent {
  const _CancelInlineInputIntent();
}

class _CustomTextFieldPanel extends StatefulWidget {
  const _CustomTextFieldPanel({
    required this.title,
    required this.isNumber,
    required this.initialValue,
    required this.onCancel,
    required this.onSubmit,
    this.onClear,
  });

  final String title;
  final bool isNumber;
  final String initialValue;
  final VoidCallback onCancel;
  final ValueChanged<String> onSubmit;
  final VoidCallback? onClear;

  @override
  State<_CustomTextFieldPanel> createState() => _CustomTextFieldPanelState();
}

class _CustomTextFieldPanelState extends State<_CustomTextFieldPanel> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 252,
    height: widget.onClear == null ? 102 : 134,
    child: Padding(
      padding: const .all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Shortcuts(
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.escape):
                  _CancelInlineInputIntent(),
            },
            child: Actions(
              actions: {
                _CancelInlineInputIntent:
                    CallbackAction<_CancelInlineInputIntent>(
                      onInvoke: (_) {
                        widget.onCancel();
                        return null;
                      },
                    ),
              },
              child: TextField(
                controller: _controller,
                autofocus: true,
                style: context.text.labelMedium,
                keyboardType: widget.isNumber
                    ? TextInputType.number
                    : TextInputType.text,
                decoration: const InputDecoration(isDense: true),
                onSubmitted: widget.onSubmit,
              ),
            ),
          ),
          if (widget.onClear != null)
            Align(
              alignment: .centerRight,
              child: TextButton(
                onPressed: widget.onClear,
                child: const Text('Wyczyść'),
              ),
            ),
        ],
      ),
    ),
  );
}
