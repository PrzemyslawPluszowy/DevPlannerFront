import 'package:ready_next/core/host/host_bridge.dart';
import 'package:ready_next/core/host/host_bridge_stub.dart'
    if (dart.library.html) 'host_bridge_web.dart'
    as impl;

/// Tworzy implementacje mostu odpowiednia dla aktualnej platformy.
HostBridge createHostBridge() => impl.createHostBridge();
