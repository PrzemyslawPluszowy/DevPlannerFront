import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/task_board_color_parser.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Przypisuje wykonawcom stabilną paletę kolorów kart.
final class TaskBoardAvatarPalette {
  const TaskBoardAvatarPalette._();

  static Color colorFor(String id) {
    const palette = <Color>[
      Color(0xFF6C5CE7),
      Color(0xFF0984E3),
      Color(0xFF00A884),
      Color(0xFFE17055),
    ];
    return palette[id.hashCode.abs() % palette.length];
  }
}

/// Etykieta i kolor statusu karty w widoku grupowanym po osobach.
/// Tekst i kolor statusu wyświetlane na karcie.
typedef KanbanCardStatusBadge = ({String label, Color color});

/// Wyszukuje kolumnę odpowiadającą statusowi zadania.
/// Wyznacza etykietę i kolor statusu dla karty zadania.
abstract final class KanbanAssigneeStatusBadge {
  static KanbanCardStatusBadge? resolve(
    TasksBoardReady state,
    KanbanTaskCardResponse task,
  ) {
    final columns = state.board.columns;
    final customStatusId = task.customStatusId;
    final column = customStatusId != null
        ? columns
              .where((item) => item.customStatusId == customStatusId)
              .firstOrNull
        : columns
              .where(
                (item) =>
                    item.customStatusId == null && item.status == task.status,
              )
              .firstOrNull;
    if (column == null) return null;
    return (
      label: column.displayName,
      color: TaskBoardColorParser.parse(column.color),
    );
  }
}

/// Zwarty badge statusu karty w widoku grupowanym po osobach.
class KanbanCardStatusBadgeView extends StatelessWidget {
  const KanbanCardStatusBadgeView({required this.badge, super.key});

  final KanbanCardStatusBadge badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: badge.color.withValues(alpha: .14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: badge.color.withValues(alpha: .38)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            badge.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KanbanCardTokens.metaText(context).copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar wykonawcy z fallbackiem inicjałów.
class KanbanAssigneeAvatar extends StatelessWidget {
  const KanbanAssigneeAvatar({
    required this.displayName,
    required this.avatarUrl,
    required this.isUnassigned,
    super.key,
  });

  static const double _size = 28;

  final String displayName;
  final String? avatarUrl;
  final bool isUnassigned;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fallback = DecoratedBox(
      decoration: BoxDecoration(
        color: isUnassigned
            ? colors.surfaceContainerHighest
            : colors.primary.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isUnassigned
            ? Icon(
                Symbols.person_rounded,
                size: _size * .6,
                color: colors.onSurfaceVariant,
              )
            : Text(
                _initials(displayName),
                style: KanbanCardTokens.childAvatarInitials(
                  context,
                ).copyWith(color: colors.onSurface),
              ),
      ),
    );
    final url = avatarUrl;
    return SizedBox(
      width: _size,
      height: _size,
      child: ClipOval(
        child: url == null
            ? fallback
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList(growable: false);
    if (parts.isEmpty) return '?';
    return parts.map((part) => part.characters.first.toUpperCase()).join();
  }
}

/// Znacznik bieżącego użytkownika w nagłówku kolumny.
/// Wyróżnia osobę zalogowaną w nagłówku kolumny.
class KanbanCurrentUserBadge extends StatelessWidget {
  const KanbanCurrentUserBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        child: Text(
          label,
          style: KanbanCardTokens.metaText(context).copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Licznik zadań w nagłówku kolumny wykonawcy.
/// Pokazuje liczbę zadań przypisanych do osoby.
class KanbanAssigneeCountBadge extends StatelessWidget {
  const KanbanAssigneeCountBadge({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        child: Text(
          '$count',
          style: KanbanCardTokens.metaText(context).copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Wiersz nagłówka kolumny wykonawcy.
class KanbanAssigneeColumnHeader extends StatelessWidget {
  const KanbanAssigneeColumnHeader({required this.group, super.key});

  final AssigneeKanbanGroupResponse group;

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.tasksBoardCurrentUserBadge;
    return Row(
      children: [
        KanbanAssigneeAvatar(
          displayName: group.displayName,
          avatarUrl: group.avatarUrl,
          isUnassigned: group.assigneeUserId == null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Tooltip(
            message: group.displayName,
            child: Text(
              group.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: KanbanCardTokens.columnTitle(context),
            ),
          ),
        ),
        if (group.isCurrentUser) ...[
          const SizedBox(width: 4),
          KanbanCurrentUserBadge(label: label),
        ],
        const SizedBox(width: 6),
        KanbanAssigneeCountBadge(count: group.totalTaskCount),
      ],
    );
  }
}
