import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

class PropertyRow extends StatelessWidget {
  const PropertyRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.valueWidget,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? valueWidget;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final stacked =
          constraints.maxWidth < 220 ||
          MediaQuery.textScalerOf(context).scale(14) >= 20;
      final tasks = context.tasksTheme;
      final colors = context.colors;
      return Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(tasks.controlRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: stacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                label,
                                style: context.text.bodySmall,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 28, top: 3),
                          child:
                              valueWidget ??
                              Text(value, style: context.text.bodyMedium),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Icon(icon, size: 18, color: colors.onSurfaceVariant),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 112,
                          child: Text(label, style: context.text.bodySmall),
                        ),
                        Expanded(
                          child:
                              valueWidget ??
                              Text(value, style: context.text.bodyMedium),
                        ),
                      ],
                    ),
            ),
          ),
          if (showDivider) Divider(height: 1, color: colors.outlineVariant),
        ],
      );
    },
  );
}
