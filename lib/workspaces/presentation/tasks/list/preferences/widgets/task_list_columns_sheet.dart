import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/preferences/widgets/components/task_column_header_preview_strip.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/preferences/widgets/components/task_column_pool_chip.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/header/task_list_column_helper.dart';

/// Zakres konfiguracji w arkuszu kolumn.
enum TaskColumnsSheetTab {
  /// Osobiste preferencje bieżącego użytkownika.
  user,

  /// Domyślna polityka kolumn dla całego projektu (dostępna dla administratora).
  project,
}

/// Nowoczesny, dwustrefowy modalny arkusz personalizacji kolumn tabeli zadań.
///
/// Zawiera:
/// 1. Górną strefę: interaktywny podgląd paska nagłówka z poziomym przeciąganiem (D&D).
/// 2. Dolną strefę: pulę dostępnych kolumn do dodania (systemowych oraz pól własnych).
/// 3. Przełącznik zakresu: Moje ustawienia (użytkownik) vs Panel admina (domyślne projektu).
class TaskListColumnsSheet extends StatefulWidget {
  const TaskListColumnsSheet({
    required this.cubit,
    super.key,
    this.customFields = const [],
    this.canManage = false,
    this.initialTab = TaskColumnsSheetTab.user,
  });

  final TaskListPreferencesCubit cubit;
  final List<TaskCustomFieldResponse> customFields;
  final bool canManage;
  final TaskColumnsSheetTab initialTab;

  /// Wyświetla arkusz dostosowywania kolumn jako responsywne okno modalne.
  static Future<void> show(
    BuildContext context, {
    required TaskListPreferencesCubit cubit,
    List<TaskCustomFieldResponse> customFields = const [],
    bool canManage = false,
    TaskColumnsSheetTab initialTab = TaskColumnsSheetTab.user,
  }) => showDialog<void>(
    context: context,
    builder: (ctx) {
      final size = MediaQuery.sizeOf(ctx);
      final maxWidth = (size.width * 0.94).clamp(720.0, 980.0);
      final maxHeight = (size.height * 0.90).clamp(580.0, 780.0);

      return BlocProvider.value(
        value: cubit,
        child: Dialog(
          backgroundColor: ctx.colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            child: TaskListColumnsSheet(
              cubit: cubit,
              customFields: customFields,
              canManage: canManage,
              initialTab: initialTab,
            ),
          ),
        ),
      );
    },
  );

  @override
  State<TaskListColumnsSheet> createState() => _TaskListColumnsSheetState();
}

class _TaskListColumnsSheetState extends State<TaskListColumnsSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _poolScrollController = ScrollController();
  String _query = '';
  late TaskColumnsSheetTab _selectedTab = widget.initialTab;
  bool _isSavingProjectPolicy = false;

  @override
  void initState() {
    super.initState();
    if (widget.canManage && _selectedTab == TaskColumnsSheetTab.project) {
      unawaited(widget.cubit.loadProjectPolicyDraft());
    }
  }

  void _onTabChanged(TaskColumnsSheetTab newTab) {
    setState(() => _selectedTab = newTab);
    if (newTab == TaskColumnsSheetTab.project) {
      unawaited(widget.cubit.loadProjectPolicyDraft());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _poolScrollController.dispose();
    super.dispose();
  }

  List<TaskColumnReference> _allAvailableColumns(
    TaskListPreferencesReady readyState,
  ) {
    final all = <TaskColumnReference>[];
    for (final col in TaskSavedViewColumn.values) {
      all.add(TaskColumnReference.system(col));
    }
    for (final cf in widget.customFields) {
      all.add(TaskColumnReference.customField(cf.id));
    }
    return all;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListPreferencesCubit, TaskListPreferencesState>(
      bloc: widget.cubit,
      builder: (context, state) => switch (state) {
        TaskListPreferencesLoading() => const SizedBox(
          height: 240,
          child: Center(child: CircularProgressIndicator()),
        ),
        TaskListPreferencesError(:final message) => _buildErrorState(
          context,
          message,
        ),
        TaskListPreferencesReady() => _buildReadyState(context, state),
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colors = context.colors;
    final text = context.text;

    return Padding(
      padding: const .all(24),
      child: Column(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        children: [
          Icon(
            Symbols.error_outline_rounded,
            size: 48,
            color: colors.error,
          ),
          const SizedBox(height: 12),
          Text(
            'Nie udało się załadować konfiguracji kolumn',
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: colors.error),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: .center,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Zamknij'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                icon: const Icon(Symbols.refresh_rounded, size: 16),
                label: const Text('Spróbuj ponownie'),
                onPressed: () => widget.cubit.load(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadyState(
    BuildContext context,
    TaskListPreferencesReady state,
  ) {
    final colors = context.colors;
    final text = context.text;
    final l10n = context.l10n;
    final isProjectTab = _selectedTab == TaskColumnsSheetTab.project;

    final visible = isProjectTab
        ? state.effectiveProjectDefaultColumns
        : state.effectiveVisibleColumns;
    final visibleIds = visible.map((c) => c.id.toLowerCase()).toSet();
    final all = _allAvailableColumns(state);
    final hidden = all
        .where((c) => !visibleIds.contains(c.id.toLowerCase()))
        .toList();

    final filteredHidden = hidden.where((c) {
      if (_query.isEmpty) return true;
      final label = TaskListColumnHelper.referenceLabel(
        context,
        c,
        customFields: widget.customFields,
      );
      return label.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    final systemHidden = filteredHidden.where((c) => !c.isCustomField).toList();
    final customHidden = filteredHidden.where((c) => c.isCustomField).toList();

    return Padding(
      padding: const .all(20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // Nagłówek okna z przełącznikiem zakresu
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: _buildHeaderScope(context, l10n, colors, text, state),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Symbols.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (state.saveError != null) ...[
            Container(
              padding: const .symmetric(horizontal: 12, vertical: 8),
              margin: const .only(bottom: 10),
              decoration: BoxDecoration(
                color: colors.errorContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.error.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.warning_rounded,
                    size: 16,
                    color: colors.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.saveError!,
                      style: text.bodySmall?.copyWith(
                        color: colors.error,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => widget.cubit.saveNow(),
                    child: const Text(
                      'Ponów zapis',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Pasek administracyjny dla zakładki projektu
          if (_selectedTab == TaskColumnsSheetTab.project) ...[
            Container(
              padding: const .symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.admin_panel_settings_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Konfigurujesz bazowy układ kolumn dla każdego członka tego projektu.',
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (state.isLoadingProjectPolicy) ...[
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // STREFA 1: Horyzontalny podgląd paska nagłówka z D&D
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Kolejność w nagłówku tabeli (${visible.length})',
                  style: text.labelSmall?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Przeciągaj w lewo/prawo',
                style: text.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TaskColumnHeaderPreviewStrip(
            columns: visible,
            state: state,
            cubit: widget.cubit,
            customFields: widget.customFields,
            onReorder: isProjectTab
                ? widget.cubit.reorderProjectDefaultColumns
                : widget.cubit.reorderColumns,
            onRemove: isProjectTab
                ? widget.cubit.toggleProjectDefaultColumn
                : widget.cubit.toggleColumn,
          ),

          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: colors.outlineVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),

          // STREFA 2: Pula dostępnych kolumn do dodania
          Row(
            children: [
              Text(
                'Dostępne do dodania (${hidden.length})',
                style: text.labelSmall?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 170,
                height: 30,
                child: TextField(
                  controller: _searchController,
                  style: text.labelSmall,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Filtruj kolumny...',
                    hintStyle: text.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    prefixIcon: const Icon(Symbols.search_rounded, size: 15),
                    prefixIconConstraints: const BoxConstraints.tightFor(
                      width: 26,
                      height: 26,
                    ),
                    contentPadding: const .symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: .circular(6),
                      borderSide: BorderSide(
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  onChanged: (val) => setState(() => _query = val.trim()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Przewijana lista puli kolumn z wirtualizacją kafelków
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: Scrollbar(
                controller: _poolScrollController,
                thumbVisibility: true,
                child: CustomScrollView(
                  controller: _poolScrollController,
                  slivers: [
                    if (systemHidden.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            'Kolumny standardowe',
                            style: text.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ),
                      SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisExtent: 34,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6,
                            ),
                        itemCount: systemHidden.length,
                        itemBuilder: (context, index) {
                          final col = systemHidden[index];
                          return TaskColumnPoolChip(
                            key: ValueKey(col.id),
                            column: col,
                            onAdd: () => isProjectTab
                                ? widget.cubit.toggleProjectDefaultColumn(col)
                                : widget.cubit.toggleColumn(col),
                            customFields: widget.customFields,
                          );
                        },
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 12),
                      ),
                    ],
                    if (customHidden.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            'Pola własne projektu',
                            style: text.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ),
                      SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisExtent: 34,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6,
                            ),
                        itemCount: customHidden.length,
                        itemBuilder: (context, index) {
                          final col = customHidden[index];
                          return TaskColumnPoolChip(
                            key: ValueKey(col.id),
                            column: col,
                            onAdd: () => isProjectTab
                                ? widget.cubit.toggleProjectDefaultColumn(col)
                                : widget.cubit.toggleColumn(col),
                            customFields: widget.customFields,
                          );
                        },
                      ),
                    ],
                    if (filteredHidden.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const .symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              _query.isEmpty
                                  ? 'Wszystkie kolumny są już widoczne w tabeli.'
                                  : 'Brak kolumn pasujących do filtra.',
                              style: text.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          // Dolny pasek akcji
          Row(
            children: [
              TextButton.icon(
                icon: const Icon(Symbols.restore_rounded, size: 16),
                label: Text(l10n.tasksListColumnsResetButton),
                onPressed: () async {
                  await widget.cubit.resetToProjectDefaults();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.tasksListColumnsResetSuccess),
                      ),
                    );
                  }
                },
              ),
              const Spacer(),
              if (_selectedTab == TaskColumnsSheetTab.user)
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.tasksListColumnsDoneButton),
                )
              else
                FilledButton.icon(
                  icon: _isSavingProjectPolicy
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Symbols.save_rounded, size: 16),
                  label: Text(l10n.tasksListSaveProjectDefaults),
                  onPressed: _isSavingProjectPolicy
                      ? null
                      : () async {
                          setState(() => _isSavingProjectPolicy = true);
                          final success = await widget.cubit
                              .saveAsProjectDefaults();
                          if (context.mounted) {
                            setState(() => _isSavingProjectPolicy = false);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.tasksListProjectDefaultsSaved,
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Nie udało się zapisać domyślnych kolumn projektu.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderScope(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
    TextTheme text,
    TaskListPreferencesReady state,
  ) {
    if (!widget.canManage) {
      return Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(Symbols.tune_rounded, size: 20, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                l10n.tasksListColumnsTitle,
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const .symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.tasksListColumnsScopeUser,
                  style: text.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (state.isSaving) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.8),
                ),
              ],
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Ułóż kolejność kolumn w Twoim widoku lub dodaj nowe z listy poniżej.',
            style: text.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(Symbols.tune_rounded, size: 20, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              l10n.tasksListColumnsTitle,
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (state.isSaving && _selectedTab == TaskColumnsSheetTab.user) ...[
              const SizedBox(width: 8),
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 1.8),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const .all(3),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.5),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _tabButton(
                label: l10n.tasksListColumnsScopeUser,
                icon: Symbols.tune_rounded,
                isSelected: _selectedTab == TaskColumnsSheetTab.user,
                onTap: () => _onTabChanged(TaskColumnsSheetTab.user),
              ),
              _tabButton(
                label: l10n.tasksListColumnsScopeProject,
                icon: Symbols.admin_panel_settings_rounded,
                isSelected: _selectedTab == TaskColumnsSheetTab.project,
                onTap: () => _onTabChanged(TaskColumnsSheetTab.project),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const .symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
