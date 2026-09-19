part of 'task_list_table.dart';

/// Model danych aktywnej pionowej linii prowadzącej (Ghost Guide Line)
/// wyświetlanej w trakcie zmiany szerokości kolumny bez obciążania layoutu wierszy.
class _ColumnResizeGuideData {
  const _ColumnResizeGuideData({
    required this.columnId,
    required this.baseX,
    required this.initialWidth,
    required this.currentWidth,
    required this.minWidth,
    required this.maxWidth,
  });

  /// Identyfikator kolumny będącej w trakcie zmiany szerokości.
  final String columnId;

  /// Pozycja X lewej krawędzi kolumny w pikselach względem początku tabeli.
  final double baseX;

  /// Początkowa szerokość kolumny przed rozpoczęciem przeciągania.
  final double initialWidth;

  /// Aktualna szerokość kolumny wskazywana przez kursor myszy.
  final double currentWidth;

  /// Minimalna dozwolona szerokość kolumny.
  final double minWidth;

  /// Maksymalna dozwolona szerokość kolumny.
  final double maxWidth;

  /// Pozycja X prawej krawędzi (separatora).
  double get x => baseX + currentWidth;

  /// Tworzy kopię ze zaktualizowaną szerokością w ramach dozwolonego limitu.
  _ColumnResizeGuideData copyWith({double? currentWidth}) =>
      _ColumnResizeGuideData(
        columnId: columnId,
        baseX: baseX,
        initialWidth: initialWidth,
        currentWidth: (currentWidth ?? this.currentWidth).clamp(
          minWidth,
          maxWidth,
        ),
        minWidth: minWidth,
        maxWidth: maxWidth,
      );
}

/// Płynna, świetlista linia prowadząca (Ghost Guide) ze wskaźnikiem pikseli
/// renderowana na wierzchu tabeli w czasie rzeczywistym z częstotliwością 120 FPS.
class _ColumnResizeGuideOverlay extends StatelessWidget {
  const _ColumnResizeGuideOverlay({
    required this.guideNotifier,
  });

  final ValueNotifier<_ColumnResizeGuideData?> guideNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_ColumnResizeGuideData?>(
      valueListenable: guideNotifier,
      builder: (context, guide, _) {
        if (guide == null) {
          return const SizedBox.shrink();
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: guide.x - 1,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.primary.withValues(alpha: 0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: (guide.x - 24).clamp(0.0, double.infinity),
              top: 4,
              child: IgnorePointer(
                child: Container(
                  padding: const .symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: const BorderRadius.all(.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.shadow.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${guide.currentWidth.round()} px',
                    style: context.text.labelSmall?.copyWith(
                      color: context.colors.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: context.tasksTheme.controlText.fontSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Metody obsługujące logikę zmiany rozmiaru kolumn (zarówno Ghost Guide jak i delta).
extension _TaskListTableResizeExtension on _TaskListTableState {
  void _onColumnResizeStart(String columnId) {
    final visibleColumns = TaskListGrid.visibleColumns(widget.columns);
    var baseX = TaskListGrid.selection;
    var initialWidth = TaskListGrid.customField;
    var minWidth = TaskListGrid.minResizableWidth;
    var maxWidth = TaskListGrid.maxResizableWidth;

    if (widget.columnReferences != null) {
      for (final ref in widget.columnReferences!) {
        final w =
            _columnWidthsById[ref.id] ??
            switch (ref) {
              SystemColumnReference(:final column) =>
                _columnWidths[column] ?? TaskListGrid.width(column),
              CustomFieldColumnReference() => TaskListGrid.customField,
            };
        if (ref.id == columnId) {
          initialWidth = w;
          minWidth = ref is SystemColumnReference
              ? TaskListGrid.width(ref.column)
              : 50.0;
          maxWidth = ref is SystemColumnReference
              ? TaskListGrid.maxResizableWidth
              : 1000.0;
          break;
        }
        baseX += w;
      }
    } else {
      for (final col in visibleColumns) {
        final id = 'sys:${col.name}';
        final w = _columnWidths[col] ?? TaskListGrid.width(col);
        if (id == columnId) {
          initialWidth = w;
          minWidth = TaskListGrid.width(col);
          maxWidth = TaskListGrid.maxResizableWidth;
          break;
        }
        baseX += w;
      }
    }

    _resizeGuideNotifier.value = _ColumnResizeGuideData(
      columnId: columnId,
      baseX: baseX,
      initialWidth: initialWidth,
      currentWidth: initialWidth,
      minWidth: minWidth,
      maxWidth: maxWidth,
    );
  }

  void _onColumnResizeUpdate(String columnId, double delta) {
    final current = _resizeGuideNotifier.value;
    if (current == null || current.columnId != columnId) return;
    _resizeGuideNotifier.value = current.copyWith(
      currentWidth: current.currentWidth + delta,
    );
  }

  void _onColumnResizeEnd(String columnId) {
    final guide = _resizeGuideNotifier.value;
    _resizeGuideNotifier.value = null;
    if (guide == null) return;
    final finalWidth = guide.currentWidth;
    if (finalWidth == guide.initialWidth) return;

    updateState(() {
      _columnWidthsById[columnId] = finalWidth;
      if (columnId.startsWith('sys:')) {
        final col = TaskColumnReference.fromId(columnId);
        if (col is SystemColumnReference) {
          _columnWidths[col.column] = finalWidth;
        }
      }
    });
    _tryResizePreferences(columnId, finalWidth);
  }

  void _resizeColumn(TaskSavedViewColumn column, double delta) {
    final baseWidth = TaskListGrid.width(column);
    final current = _columnWidths[column] ?? baseWidth;
    final next = (current + delta).clamp(
      baseWidth,
      TaskListGrid.maxResizableWidth,
    );
    if (next == current) return;
    updateState(() {
      _columnWidths[column] = next;
      _columnWidthsById['sys:${column.name}'] = next;
    });
    _tryResizePreferences('sys:${column.name}', next);
  }

  void _resizeColumnById(String columnId, double delta) {
    final baseWidth = columnId.startsWith('sys:')
        ? () {
            final col = TaskColumnReference.fromId(columnId);
            return col is SystemColumnReference
                ? TaskListGrid.width(col.column)
                : TaskListGrid.customField;
          }()
        : TaskListGrid.customField;
    final current = _columnWidthsById[columnId] ?? baseWidth;
    final next = (current + delta).clamp(50.0, 1000.0);
    if (next == current) return;
    updateState(() {
      _columnWidthsById[columnId] = next;
      if (columnId.startsWith('sys:')) {
        final col = TaskColumnReference.fromId(columnId);
        if (col is SystemColumnReference) {
          _columnWidths[col.column] = next;
        }
      }
    });
    _tryResizePreferences(columnId, next);
  }

  void _tryResizePreferences(String columnId, double width) {
    final cubit =
        widget.preferencesCubit ??
        (mounted
            ? () {
                try {
                  return context.read<TaskListPreferencesCubit>();
                } catch (_) {
                  return null;
                }
              }()
            : null);
    cubit?.resizeColumn(columnId, width);
  }
}
