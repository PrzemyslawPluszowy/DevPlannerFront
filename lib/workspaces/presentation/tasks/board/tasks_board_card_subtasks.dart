import 'dart:async';
import 'dart:math' as math;

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

part 'cards/subtasks/kanban_card_subtasks_content.dart';
part 'cards/subtasks/kanban_card_subtasks_support.dart';

/// Zwijany/rozwijany podgląd podzadań wewnątrz karty Kanbana.
///
/// Zgodnie ze specyfikacją naprawy UI (Etap C):
/// - Nowy, zwarty nagłówek sekcji z obracanym chevronem, licznikiem i cienkim paskiem postępu (48 px).
/// - Usunięto kropkowany separator i punktowe drzewko — zastąpiono je czystą, subtelną linią pionową 1 px.
/// - Stała oś wyrównania tekstu dla stanów pustego, ładowania, błędu, listy podzadań i formularza dodawania.
/// - Wiersz dziecka: status 16 px, tytuł z przekreśleniem dla ukończonych, opcjonalny termin i awatar 20 px.
/// - Pełny stan hover (tło 6 px radius) oraz focus ring (2 px primary) dla dostępności.
/// - Dedykowane klucze testowe dla nagłówka, każdego wiersza dziecka, stronicowania i dodawania.
class KanbanCardSubtasksSection extends StatefulWidget {
  const KanbanCardSubtasksSection({
    required this.task,
    required this.workspaceId,
    required this.projectId,
    required this.memberProfilesByUserId,
    this.density = KanbanCardDensity.comfortable,
    super.key,
  });

  final KanbanTaskCardResponse task;
  final String workspaceId;
  final String projectId;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final KanbanCardDensity density;

  @override
  State<KanbanCardSubtasksSection> createState() =>
      _KanbanCardSubtasksSectionState();
}

class _KanbanCardSubtasksSectionState extends State<KanbanCardSubtasksSection>
    with SingleTickerProviderStateMixin {
  late final KanbanSubtasksCubit _cubit;
  late final AnimationController _chevronController;
  late final Animation<double> _chevronAnimation;

  late final ValueNotifier<bool> _isExpanded;
  late final ValueNotifier<bool> _isAddingSubtask;
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isExpanded = ValueNotifier(false);
    _isAddingSubtask = ValueNotifier(false);
    _cubit = KanbanSubtasksCubit(
      tasksRepository: context.read<TasksRepository>(),
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      parentTaskId: widget.task.id,
      initialSubtaskTotal: widget.task.subtaskTotal,
      initialSubtaskCompleted: widget.task.subtaskCompleted,
    );

    _chevronController = AnimationController(
      vsync: this,
      duration: KanbanCardTokens.chevronDuration,
    );

    _chevronAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(
        parent: _chevronController,
        curve: KanbanCardTokens.expandCurve,
      ),
    );
  }

  @override
  void dispose() {
    _subtaskController.dispose();
    _isExpanded.dispose();
    _isAddingSubtask.dispose();
    _chevronController.dispose();
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant KanbanCardSubtasksSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.id == widget.task.id) {
      _cubit.syncParentCounters(
        subtaskTotal: widget.task.subtaskTotal,
        subtaskCompleted: widget.task.subtaskCompleted,
      );
    }
  }

  void _toggleExpanded() {
    final nextState = !_isExpanded.value;
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    _isExpanded.value = nextState;
    if (!nextState) {
      _isAddingSubtask.value = false;
      if (reducedMotion) {
        _chevronController.value = 0.0;
      } else {
        _chevronController.reverse();
      }
    } else if (reducedMotion) {
      _chevronController.value = 1.0;
    } else {
      _chevronController.forward();
    }

    if (nextState) {
      unawaited(_cubit.loadInitial());
    }
  }

  /// Otwiera sekcję od razu w trybie dodawania.
  ///
  /// Karta bez podzadań pokazuje samą akcję „Dodaj podzadanie” (nagłówek
  /// z licznikiem „(0/0)” i pustym paskiem postępu nic nie wnosi), a jej
  /// dotknięcie ma postawić kursor w polu nazwy, a nie kazać klikać dwa razy.
  void _openAddSubtask() {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _isExpanded.value = true;
    _isAddingSubtask.value = true;
    if (reducedMotion) {
      _chevronController.value = 1.0;
    } else {
      _chevronController.forward();
    }
    unawaited(_cubit.loadInitial());
  }

  Future<void> _submitNewSubtask() async {
    final title = _subtaskController.text.trim();
    if (title.isEmpty) return;

    final success = await _cubit.createSubtask(title);
    if (success && mounted) {
      _subtaskController.clear();
      _isAddingSubtask.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompact = widget.density == KanbanCardDensity.compact;
    final toggleMinHeight = isCompact
        ? KanbanCardTokens.toggleRowMinHeightCompact
        : KanbanCardTokens.toggleRowMinHeightComfortable;
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return BlocProvider.value(
      value: _cubit,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isExpanded,
        builder: (context, isExpanded, _) => _OptionalTasksBoardListener(
          listenWhen: (previous, current) {
            final previousRevision = previous is TasksBoardReady
                ? previous.realtimeRevision
                : -1;
            final currentRevision = current is TasksBoardReady
                ? current.realtimeRevision
                : -1;
            return previousRevision != currentRevision;
          },
          listener: (_, boardState) {
            if (!_isExpanded.value || boardState is! TasksBoardReady) return;
            final mutation = boardState.latestRealtimeMutation;
            if (mutation == null || mutation.parentTaskId != widget.task.id) {
              return;
            }
            // The realtime snapshot is intentionally partial. A refreshed local
            // child list prevents an out-of-date expanded card without opening a
            // second SignalR connection for every Kanban card.
            unawaited(_cubit.refresh());
          },
          child: BlocBuilder<KanbanSubtasksCubit, KanbanSubtasksState>(
            builder: (context, state) {
              final total = state.subtaskTotal;
              final completed = state.subtaskCompleted;
              final progress = total > 0
                  ? (completed / total).clamp(0.0, 1.0)
                  : 0.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Zadanie bez podzadań nie ma czego zwijać: nagłówek
                  // z licznikiem „(0/0)” i pustym paskiem postępu byłby
                  // szumem, więc karta pokazuje wprost akcję dodania.
                  if (total == 0 && !isExpanded)
                    _buildAddSubtaskAction(context, onTap: _openAddSubtask)
                  else ...[
                    // Nagłówek sekcji: jeden dostępny przycisk z obracanym chevronem, licznikiem i progress barem
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: toggleMinHeight),
                      child: Material(
                        color: Colors.transparent,
                        child: Semantics(
                          button: true,
                          expanded: isExpanded,
                          label:
                              '${context.l10n.tasksSubtasksTitle} ($completed/$total)',
                          child: InkWell(
                            key: const ValueKey('subtasks_toggle_button'),
                            onTap: _toggleExpanded,
                            borderRadius: BorderRadius.circular(6),
                            hoverColor: colors.surfaceContainerHighest
                                .withValues(
                                  alpha: .5,
                                ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  RotationTransition(
                                    turns: _chevronAnimation,
                                    child: Icon(
                                      Symbols.keyboard_arrow_right_rounded,
                                      size: 16,
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      context.l10n.tasksSubtasksTitle,
                                      style: KanbanCardTokens.subtasksHeader(
                                        context,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '($completed/$total)',
                                    style: KanbanCardTokens.metaText(
                                      context,
                                      weight: .w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Wyrazisty, zintegrowany pasek postępu (64 × 5 px)
                                  Container(
                                    width: 64,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: colors.outlineVariant.withValues(
                                        alpha: .25,
                                      ),
                                      borderRadius: .circular(2.5),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: .circular(2.5),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: Colors.transparent,
                                        color: (completed == total && total > 0)
                                            ? const Color(0xFF10B981)
                                            : colors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Rozwijana zawartość z animacją
                    AnimatedSize(
                      duration: reducedMotion
                          ? Duration.zero
                          : KanbanCardTokens.expandDuration,
                      curve: KanbanCardTokens.expandCurve,
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.antiAlias,
                      child: isExpanded
                          ? ValueListenableBuilder<bool>(
                              valueListenable: _isAddingSubtask,
                              builder: (context, isAdding, _) =>
                                  _buildExpandedContent(context, state),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
