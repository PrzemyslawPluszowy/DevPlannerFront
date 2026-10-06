import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Nullowa wartość usuwa kolor; brak wyniku dialogu oznacza anulowanie.
final class TaskDescriptionColorChoice {
  const TaskDescriptionColorChoice(this.value);
  final String? value;
}

/// Zwarty wybór koloru opisu, z tymi samymi tokenami i stopką co inne formularze.
abstract final class TaskDescriptionColorPicker {
  static Future<TaskDescriptionColorChoice?> show(
    BuildContext context, {
    required String title,
    String? initialValue,
  }) => DevPlannerModalHost.showDialog<TaskDescriptionColorChoice>(
    context,
    builder: (_) => _DescriptionColorDialog(
      title: title,
      initialValue: initialValue,
    ),
  );

  /// Quill zapisuje sześć cyfr RGB lub osiem cyfr ARGB poprzedzonych #.
  static String? normalize(String input) {
    final value = input.trim().replaceFirst(RegExp('^#'), '').toUpperCase();
    return RegExp(r'^(?:[0-9A-F]{6}|[0-9A-F]{8})$').hasMatch(value)
        ? '#$value'
        : null;
  }

  static Color? preview(String input) {
    final value = normalize(input);
    if (value == null) return null;
    final number = int.parse(value.substring(1), radix: 16);
    return Color(value.length == 7 ? number | 0xFF000000 : number);
  }
}

final class _DescriptionColorDialog extends StatefulWidget {
  const _DescriptionColorDialog({required this.title, this.initialValue});
  final String title;
  final String? initialValue;

  @override
  State<_DescriptionColorDialog> createState() =>
      _DescriptionColorDialogState();
}

final class _DescriptionColorDialogState
    extends State<_DescriptionColorDialog> {
  static const _palette = [
    '#000000',
    '#FFFFFF',
    '#475569',
    '#94A3B8',
    '#DC2626',
    '#EA580C',
    '#D97706',
    '#CA8A04',
    '#16A34A',
    '#0D9488',
    '#0891B2',
    '#2563EB',
    '#4F46E5',
    '#7C3AED',
    '#C026D3',
    '#DB2777',
  ];
  late final TextEditingController _hex;
  final ValueNotifier<int> _revision = ValueNotifier(0);
  bool _attempted = false;

  @override
  void initState() {
    super.initState();
    _hex = TextEditingController(
      text:
          TaskDescriptionColorPicker.normalize(widget.initialValue ?? '') ??
          '#000000',
    );
    _hex.addListener(_changed);
  }

  void _changed() => _revision.value++;

  void _select(String value) {
    _attempted = false;
    _hex.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _submit() {
    final value = TaskDescriptionColorPicker.normalize(_hex.text);
    if (value == null) {
      _attempted = true;
      _revision.value++;
      return;
    }
    Navigator.of(context).pop(TaskDescriptionColorChoice(value));
  }

  void _clear() => Navigator.of(context).pop(
    const TaskDescriptionColorChoice(null),
  );

  @override
  void dispose() {
    _hex.removeListener(_changed);
    _hex.dispose();
    _revision.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _revision,
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: widget.title,
      icon: Symbols.palette_rounded,
      maxWidth: 380,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      onSubmit: _submit,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in _palette)
                _DescriptionColorSwatch(
                  value: value,
                  selected:
                      TaskDescriptionColorPicker.normalize(_hex.text) == value,
                  onSelected: _select,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('task_description_color_hex'),
                  controller: _hex,
                  autofocus: true,
                  maxLength: 9,
                  decoration: InputDecoration(
                    labelText: context.l10n.taskDescriptionColorHex,
                    hintText: '#RRGGBB / #AARRGGBB',
                    counterText: '',
                    errorMaxLines: 8,
                    errorText:
                        _attempted &&
                            TaskDescriptionColorPicker.normalize(_hex.text) ==
                                null
                        ? context.l10n.taskDescriptionColorInvalid
                        : null,
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: TaskDescriptionColorPicker.preview(_hex.text),
                  border: Border.all(color: context.colors.outlineVariant),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const SizedBox.square(dimension: 32),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: _clear,
              child: Text(context.l10n.taskDescriptionColorDefault),
            ),
          ),
        ],
      ),
    ),
  );
}

final class _DescriptionColorSwatch extends StatelessWidget {
  const _DescriptionColorSwatch({
    required this.value,
    required this.selected,
    required this.onSelected,
  });
  final String value;
  final bool selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    label: '${context.l10n.tasksCustomWorkflowColor} $value',
    child: Tooltip(
      message: value,
      child: Material(
        color: TaskDescriptionColorPicker.preview(value),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: selected ? context.colors.primary : context.colors.outline,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onSelected(value),
          child: SizedBox.square(
            dimension: 32,
            child: selected
                ? Icon(
                    Symbols.check_rounded,
                    size: 18,
                    color:
                        ThemeData.estimateBrightnessForColor(
                              TaskDescriptionColorPicker.preview(value)!,
                            ) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  )
                : null,
          ),
        ),
      ),
    ),
  );
}
