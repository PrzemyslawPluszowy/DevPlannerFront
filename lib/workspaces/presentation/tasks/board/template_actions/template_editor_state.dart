part of '../tasks_board_page.dart';

class _TaskTemplateEditorState extends State<TaskTemplateEditor> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<int> _renderRevision = ValueNotifier(0);

  final _name = TextEditingController();
  String? _taskType;
  int? _size;
  int? _complexity;
  int? _risk;
  int? _businessValue;
  int? _estimate;
  List<String> _checklistItems = <String>[];
  List<String> _acceptanceCriteria = <String>[];

  SelectedTemplateStatus? _status;
  TaskPriority _priority = TaskPriority.normal;
  DateTime? _startAtUtc;
  DateTime? _dueAtUtc;
  Set<String> _assigneeUserIds = <String>{};
  List<TaskTemplateLabelResponse> _labels = <TaskTemplateLabelResponse>[];
  List<TaskTemplateCustomFieldValueResponse> _customFieldValues =
      <TaskTemplateCustomFieldValueResponse>[];

  late TaskTemplateDetailsResponse? _details;
  bool _loading = false;
  ApiError? _loadError;
  bool _saving = false;
  bool _isDirty = false;
  String? _saveError;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool get _isCreating => widget.template == null;
  TaskTemplatePickerCubit get _cubit =>
      widget.pickerCubit ?? context.read<TaskTemplatePickerCubit>();

  /// Jedyny punkt aktualizacji stanu używany przez rozszerzenia formularza.
  /// Chroni części widoku przed bezpośrednim dostępem do chronionego API State.
  /// Zmienia wyłącznie lokalną gałąź formularza, bez odświeżania całego shellu.
  void _updateEditorState(VoidCallback update) {
    update();
    if (mounted) _renderRevision.value++;
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: _renderRevision,
    builder: (context, _, _) => _buildEditorView(context),
  );

  @override
  void initState() {
    super.initState();
    if (_isCreating) {
      _details = null;
      _loading = false;
      _priority = TaskPriority.normal;
      _initDefaultStatus();
    } else {
      _details = null;
      _loading = true;
      unawaited(_loadExistingTemplate());
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _renderRevision.dispose();
    super.dispose();
  }
}
