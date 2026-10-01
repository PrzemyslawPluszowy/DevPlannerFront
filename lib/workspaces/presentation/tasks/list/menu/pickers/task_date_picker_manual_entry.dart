import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class TaskDatePickerManualEntry extends StatefulWidget {
  const TaskDatePickerManualEntry({
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
    super.key,
  });

  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  @override
  State<TaskDatePickerManualEntry> createState() =>
      _TaskDatePickerManualEntryState();
}

final class _TaskDatePickerManualEntryState
    extends State<TaskDatePickerManualEntry> {
  late final TextEditingController _dateController;
  String? _errorText;
  String? _localeTag;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncDateText();
  }

  @override
  void didUpdateWidget(TaskDatePickerManualEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _syncDateText(force: true);
    }
  }

  void _syncDateText({bool force = false}) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (!force && _localeTag == locale && _dateController.text.isNotEmpty) {
      return;
    }
    _localeTag = locale;
    _dateController.text = DateFormat.yMd(locale).format(widget.selectedDate);
    _errorText = null;
  }

  void _applyDate() {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final format = DateFormat.yMd(locale);
    final DateTime parsed;
    try {
      parsed = format.parseStrict(_dateController.text.trim());
    } on FormatException {
      setState(() => _errorText = context.l10n.tasksDatePickerInvalidDate);
      return;
    }
    final date = DateTime(parsed.year, parsed.month, parsed.day);
    final first = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      widget.firstDate.day,
    );
    final last = DateTime(
      widget.lastDate.year,
      widget.lastDate.month,
      widget.lastDate.day,
    );
    if (date.isBefore(first) || date.isAfter(last)) {
      setState(() => _errorText = context.l10n.tasksDatePickerInvalidDate);
      return;
    }
    setState(() => _errorText = null);
    widget.onSelected(date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final hint = DateFormat.yMd(locale).pattern ?? '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _dateController,
            textInputAction: TextInputAction.done,
            style: context.tasksTheme.controlText,
            decoration: InputDecoration(
              labelText: context.l10n.tasksDatePickerManualLabel,
              hintText: '${context.l10n.tasksDatePickerManualHint}: $hint',
              errorText: _errorText,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Sizes.p8,
                vertical: Sizes.p8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.tasksTheme.controlRadius,
                ),
              ),
            ),
            onSubmitted: (_) => _applyDate(),
            onChanged: (_) {
              if (_errorText != null) setState(() => _errorText = null);
            },
          ),
        ),
        const SizedBox(width: Sizes.p4),
        Padding(
          padding: EdgeInsets.only(
            top: _errorText == null ? Sizes.p2 : Sizes.p6,
          ),
          child: TextButton(
            onPressed: _applyDate,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p6),
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: context.tasksTheme.selectionAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  context.tasksTheme.controlRadius,
                ),
              ),
            ),
            child: Text(context.l10n.tasksDatePickerManualApply),
          ),
        ),
      ],
    );
  }
}
