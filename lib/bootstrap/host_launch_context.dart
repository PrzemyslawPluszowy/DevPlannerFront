import 'package:flutter/foundation.dart';

/// Dane przekazywane do Fluttera na starcie przez hosta.
///
/// Host może wskazać trasę oraz dane pomocnicze użytkownika. Sesja jest zawsze
/// tworzona wyłącznie przez Veloryn Core, więc token hosta nie jest przyjmowany.
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
    // `initialRoute` pochodzi z URL, a pozostale dane z hosta/storage.
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
