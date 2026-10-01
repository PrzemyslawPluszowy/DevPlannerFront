import 'package:flutter/widgets.dart';

/// Drafts currently owned by mounted editors inside one task detail modal.
///
/// Each form gets its own registration so a successful save clears only that
/// form while other dirty editors continue to block closing the modal.
final class TaskDetailDraftRegistry {
  final Set<TaskDetailDraftRegistration> _registrations = {};
  bool _disposed = false;

  bool get hasUnsavedDrafts =>
      _registrations.any((registration) => registration.isDirty);

  List<String> get dirtyDraftLabels => [
    for (final registration in _registrations)
      if (registration.isDirty) registration.label,
  ];

  TaskDetailDraftRegistration registerDraft({required String label}) {
    if (_disposed) {
      throw StateError('Task detail draft registry is disposed.');
    }
    final registration = TaskDetailDraftRegistration._(this, label);
    _registrations.add(registration);
    return registration;
  }

  void _unregister(TaskDetailDraftRegistration registration) {
    _registrations.remove(registration);
  }

  void dispose() {
    _disposed = true;
    for (final registration in _registrations.toList()) {
      registration.dispose();
    }
  }
}

/// Lifecycle token held by one editor State.
final class TaskDetailDraftRegistration {
  TaskDetailDraftRegistration._(this._registry, this.label);

  final TaskDetailDraftRegistry _registry;
  final String label;
  bool _isDirty = false;
  bool _disposed = false;

  bool get isDirty => _isDirty && !_disposed;

  void markDirty() {
    if (!_disposed) _isDirty = true;
  }

  /// Call only after the repository confirms a successful save.
  void clear() {
    if (!_disposed) _isDirty = false;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _isDirty = false;
    _registry._unregister(this);
  }
}

/// Makes one modal's draft registry available to its editor subtree.
final class TaskDetailDraftScope extends InheritedTheme {
  const TaskDetailDraftScope({
    required this.registry,
    required super.child,
    super.key,
  });

  final TaskDetailDraftRegistry registry;

  static TaskDetailDraftRegistry? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<TaskDetailDraftScope>()
      ?.registry;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      TaskDetailDraftScope(registry: registry, child: child);

  @override
  bool updateShouldNotify(TaskDetailDraftScope oldWidget) =>
      !identical(registry, oldWidget.registry);
}
