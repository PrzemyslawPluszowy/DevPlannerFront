import 'package:flutter/material.dart';

import 'package:ready_next/core/l10n/l10n_extensions.dart';

/// Prosta strona startowa modulu "Inne".
///
/// Na tym etapie zawiera tylko podstawowy `Scaffold`.
class InneHomePage extends StatelessWidget {
  /// Tworzy strone glowna modulu "Inne".
  const InneHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(context.l10n.inneTitle)),
    );
  }
}
