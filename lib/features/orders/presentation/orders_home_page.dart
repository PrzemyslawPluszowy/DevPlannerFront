import 'package:flutter/material.dart';

import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Drugi przykladowy ekran feature'a pod inna trase.
///
/// Dzieki niemu mozna szybko sprawdzic, czy routing miedzy modulami dziala.
class OrdersHomePage extends StatelessWidget {
  const OrdersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.ordersTitle)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.ordersBody,
              style: context.text.headlineSmall,
            ),
            const SizedBox(height: Sizes.p16),
            Text(context.l10n.ordersInitialRoute),
            Text(context.l10n.ordersUserId),
            Text(context.l10n.ordersUser),
            Text(context.l10n.ordersBearerPassed),
          ],
        ),
      ),
    );
  }
}
