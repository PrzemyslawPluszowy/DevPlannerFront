import 'package:devplanner/core/host/host_bridge.dart';
import 'package:devplanner/core/host/host_bridge_stub.dart';

/// Creates the local, non-embedded platform boundary.
///
/// DevPlanner owns its own session lifecycle and does not connect to another
/// product's host, token bridge or backend.
HostBridge createHostBridge() => const StubHostBridge();
