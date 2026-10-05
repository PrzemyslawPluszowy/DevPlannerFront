import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final status in ProjectTaskStatus.values) {
    test('status $status keeps normal-text contrast in either theme', () {
      final background = TaskStatusVisualHelper.color(status)
          .computeLuminance();
      final foreground = TaskStatusVisualHelper.foreground(status)
          .computeLuminance();
      final lighter = background > foreground ? background : foreground;
      final darker = background < foreground ? background : foreground;
      expect((lighter + .05) / (darker + .05), greaterThanOrEqualTo(4.5));
    });
  }
}
