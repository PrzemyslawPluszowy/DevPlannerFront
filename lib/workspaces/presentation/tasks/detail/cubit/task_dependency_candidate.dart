/// Lokalny model wyboru celu zależności; nie zmienia kontraktu API.
final class TaskDependencyCandidate {
  const TaskDependencyCandidate({
    required this.id,
    required this.key,
    required this.title,
  });

  final String id;
  final String key;
  final String title;
}
