import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';

/// Uniwersalny placeholder dla tras lub modulow, ktore nie sa jeszcze gotowe.
class ModulePlaceholderPage extends StatelessWidget {
  const ModulePlaceholderPage({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p24),
          child: Text(message, textAlign: .center),
        ),
      ),
    );
  }
}
