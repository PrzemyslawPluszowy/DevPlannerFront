import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Pasek wyboru grupowania tablicy: status workflow albo osoba przypisana.
///
/// Wyglądem odpowiada przełącznikowi z listy zadań (smukły pill 28 px,
/// powierzchnia `surfaceContainerHigh`, subtelna ramka), żeby tablica nie
/// odstawała od reszty modułu i nie zajmowała pół ekranu.
class KanbanBoardGroupingBar extends StatelessWidget {
  const KanbanBoardGroupingBar({required this.state, super.key});

  final TasksBoardReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final options = <(TasksBoardGrouping, String, IconData)>[
      (
        TasksBoardGrouping.status,
        l10n.tasksBoardGroupByStatus,
        Symbols.grid_view_rounded,
      ),
      (
        TasksBoardGrouping.assignee,
        l10n.tasksKanbanSwimlaneAssignee,
        Symbols.person_rounded,
      ),
    ];

    // Kontrolka wiersza poleceń: bez paddingu, bez własnego scrolla i **bez
    // elementów rozciągliwych**. Wiersz poleceń to poziomy scroll, więc szerokość
    // jest nieograniczona i każdy `Spacer`/`Expanded` skończyłby się błędem
    // layoutu („non-zero flex but incoming width constraints are unbounded”).
    return Container(
      height: 28,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh.withValues(alpha: .7),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: .35),
          width: .8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (value, label, icon) in options)
            _GroupingSegment(
              label: label,
              icon: icon,
              isSelected: state.grouping == value,
              isLoading:
                  state.isAssigneeBoardLoading &&
                  value == TasksBoardGrouping.assignee,
              // Cubit czytamy w momencie kliknięcia, nie w buildzie: nagłówek
              // montuje się także w testach i podglądach bez dostawcy cubita.
              onTap: () => unawaited(
                context.read<TasksBoardCubit>().setGrouping(value),
              ),
            ),
        ],
      ),
    );
  }
}

/// Pojedynczy segment przełącznika: kolor zaznaczenia bierze z motywu, więc
/// wybór jest widoczny od pierwszego rzutu oka.
/// Pojedyncza opcja przełącznika z obsługą fokusu klawiatury.
class _GroupingSegment extends StatefulWidget {
  const _GroupingSegment({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  State<_GroupingSegment> createState() => _GroupingSegmentState();
}

/// Utrzymuje stan wizualny segmentu przełącznika.
class _GroupingSegmentState extends State<_GroupingSegment> {
  final _state = ValueNotifier<({bool hovered, bool focused})>((
    hovered: false,
    focused: false,
  ));

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<
        ({
          bool hovered,
          bool focused,
        })
      >(
        valueListenable: _state,
        builder: (context, interaction, _) {
          final colors = context.colors;
          final selected = widget.isSelected;
          final background = selected
              ? colors.primaryContainer
              : interaction.hovered
              ? colors.surfaceContainerHighest
              : Colors.transparent;
          final foreground = selected
              ? colors.onPrimaryContainer
              : colors.onSurfaceVariant;
          return Semantics(
            button: true,
            selected: selected,
            label: widget.label,
            child: FocusableActionDetector(
              mouseCursor: SystemMouseCursors.click,
              onShowHoverHighlight: (hovered) => _state.value = (
                hovered: hovered,
                focused: _state.value.focused,
              ),
              onShowFocusHighlight: (focused) => _state.value = (
                hovered: _state.value.hovered,
                focused: focused,
              ),
              actions: {
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) {
                    widget.onTap();
                    return null;
                  },
                ),
              },
              child: GestureDetector(
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(5),
                    border: interaction.focused
                        ? Border.all(color: colors.primary, width: 1.4)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: widget.isLoading
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color: foreground,
                              )
                            : Icon(widget.icon, size: 14, color: foreground),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.label,
                        style:
                            KanbanCardTokens.metaText(
                              context,
                            ).copyWith(
                              color: foreground,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
}
