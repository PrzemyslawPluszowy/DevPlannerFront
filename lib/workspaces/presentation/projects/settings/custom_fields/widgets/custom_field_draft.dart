import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';

/// Niemutowalny szkic lokalnie edytowanej definicji pola niestandardowego.
class CustomFieldDraft {
  const CustomFieldDraft({
    required this.options,
    required this.selectedType,
    required this.isRequired,
    this.selectedColorHex,
    this.selectedIconName,
  });

  final List<CustomFieldOption> options;
  final TaskCustomFieldType selectedType;
  final bool isRequired;
  final String? selectedColorHex;
  final String? selectedIconName;

  bool get needsOptions =>
      selectedType == TaskCustomFieldType.singleSelect ||
      selectedType == TaskCustomFieldType.multiSelect;

  CustomFieldDraft copyWith({
    List<CustomFieldOption>? options,
    TaskCustomFieldType? selectedType,
    bool? isRequired,
    String? selectedColorHex,
    bool clearSelectedColorHex = false,
    String? selectedIconName,
    bool clearSelectedIconName = false,
  }) => CustomFieldDraft(
    options: options ?? this.options,
    selectedType: selectedType ?? this.selectedType,
    isRequired: isRequired ?? this.isRequired,
    selectedColorHex: clearSelectedColorHex
        ? null
        : selectedColorHex ?? this.selectedColorHex,
    selectedIconName: clearSelectedIconName
        ? null
        : selectedIconName ?? this.selectedIconName,
  );
}
