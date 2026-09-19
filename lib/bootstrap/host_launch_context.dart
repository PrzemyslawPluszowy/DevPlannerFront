import 'package:flutter/foundation.dart';

/// Local launch data used by the standalone DevPlanner root.
@immutable
class HostLaunchContext {
  const HostLaunchContext({
    required this.initialRoute,
    required this.userId,
    required this.userDisplayName,
  });

  factory HostLaunchContext.fromMap(
    Map<String, dynamic> map, {
    required String initialRoute,
  }) {
    // Kept for decoding platform launch data; it never carries auth tokens.
    return HostLaunchContext(
      initialRoute: initialRoute,
      userId: map['userId'] as String?,
      userDisplayName: map['userDisplayName'] as String?,
    );
  }

  final String initialRoute;
  final String? userId;
  final String? userDisplayName;

  HostLaunchContext copyWith({
    String? initialRoute,
    String? userId,
    String? userDisplayName,
  }) {
    return HostLaunchContext(
      initialRoute: initialRoute ?? this.initialRoute,
      userId: userId ?? this.userId,
      userDisplayName: userDisplayName ?? this.userDisplayName,
    );
  }
}
