import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_share_directory_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_sharing_error_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wybór poziomu dostępu i zapis udostępnienia osoby.
final class StorageSharePersonControls extends StatelessWidget {
  const StorageSharePersonControls({
    required this.level,
    required this.isMutating,
    required this.onLevelChanged,
    required this.onShare,
    super.key,
  });

  final StorageShareAccessLevel level;
  final bool isMutating;
  final ValueChanged<Set<StorageShareAccessLevel>> onLevelChanged;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final levelPicker = constraints.maxWidth < 480
          ? _CompactAccessLevelPicker(
              level: level,
              enabled: !isMutating,
              onSelected: onLevelChanged,
            )
          : SegmentedButton<StorageShareAccessLevel>(
              key: const ValueKey('storage_share_user_level'),
              segments: [
                ButtonSegment(
                  value: StorageShareAccessLevel.reader,
                  label: Text(context.l10n.storageAccessReader),
                ),
                ButtonSegment(
                  value: StorageShareAccessLevel.commenter,
                  label: Text(context.l10n.storageAccessCommenter),
                ),
                ButtonSegment(
                  value: StorageShareAccessLevel.editor,
                  label: Text(context.l10n.storageAccessEditor),
                ),
              ],
              selected: {level},
              onSelectionChanged: isMutating ? null : onLevelChanged,
              showSelectedIcon: false,
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                  context.filesTheme.common.controlText,
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(color: context.colors.outlineVariant),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.filesTheme.common.controlRadius,
                    ),
                  ),
                ),
              ),
            );
      final submit = FilledButton(
        key: const ValueKey('storage_share_user_submit'),
        onPressed: isMutating ? null : onShare,
        child: Text(context.l10n.storageShareAction),
      );
      if (constraints.maxWidth < 520) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [levelPicker, const SizedBox(height: 8), submit],
        );
      }
      return Row(
        children: [
          Expanded(child: levelPicker),
          const SizedBox(width: 8),
          submit,
        ],
      );
    },
  );
}

final class _CompactAccessLevelPicker extends StatelessWidget {
  const _CompactAccessLevelPicker({
    required this.level,
    required this.enabled,
    required this.onSelected,
  });

  final StorageShareAccessLevel level;
  final bool enabled;
  final ValueChanged<Set<StorageShareAccessLevel>> onSelected;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    return Wrap(
      spacing: common.tightGap,
      runSpacing: common.tightGap,
      children: [
        for (final option in const [
          StorageShareAccessLevel.reader,
          StorageShareAccessLevel.commenter,
          StorageShareAccessLevel.editor,
        ])
          ChoiceChip(
            label: Text(_label(context, option)),
            selected: level == option,
            showCheckmark: false,
            backgroundColor: context.colors.surface,
            selectedColor: context.colors.primary.withValues(alpha: .12),
            side: BorderSide(
              color: level == option
                  ? context.colors.primary
                  : context.colors.outlineVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(common.controlRadius),
            ),
            labelStyle: common.controlText.copyWith(
              color: context.colors.onSurface,
            ),
            onSelected: enabled ? (_) => onSelected({option}) : null,
          ),
      ],
    );
  }

  String _label(BuildContext context, StorageShareAccessLevel option) =>
      switch (option) {
        StorageShareAccessLevel.read ||
        StorageShareAccessLevel.reader => context.l10n.storageAccessReader,
        StorageShareAccessLevel.write ||
        StorageShareAccessLevel.owner => context.l10n.storageAccessEditor,
        StorageShareAccessLevel.commenter =>
          context.l10n.storageAccessCommenter,
        StorageShareAccessLevel.editor => context.l10n.storageAccessEditor,
      };
}

/// Pełny błąd katalogu z jawnym ponowieniem bez utraty zapytania.
final class StorageShareDirectoryError extends StatelessWidget {
  const StorageShareDirectoryError({required this.error, super.key});

  final ApiError error;

  @override
  Widget build(BuildContext context) => StorageSharingErrorPanel(
    error: error,
    onRefresh: () => context.read<StorageShareDirectoryCubit>().retry(),
  );
}

/// Informacja, że lokalny katalog nie istnieje dla bieżącego zakresu pliku.
final class StorageShareDirectoryNote extends StatelessWidget {
  const StorageShareDirectoryNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        Icons.info_outline_rounded,
        size: 16,
        color: context.colors.onSurfaceVariant,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: context.filesTheme.common.dataText.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}
