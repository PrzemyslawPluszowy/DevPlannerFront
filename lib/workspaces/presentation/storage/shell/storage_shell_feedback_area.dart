import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_error_banner_host.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_feedback_host.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Rezerwuje ograniczoną część nagłówka na błędy i zachowuje miejsce listy.
final class StorageShellFeedbackArea extends StatelessWidget {
  const StorageShellFeedbackArea({
    required this.availableHeight,
    required this.errorListenable,
    required this.onRefresh,
    required this.onDismiss,
    super.key,
  });

  final double availableHeight;
  final ValueListenable<StorageMutationError?> errorListenable;
  final VoidCallback onRefresh;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final maxHeight = availableHeight.isFinite
        ? (availableHeight * 0.32).clamp(112.0, 220.0)
        : 220.0;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const StorageErrorBannerHost(),
            StorageMutationFeedbackHost(
              errorListenable: errorListenable,
              onRefresh: onRefresh,
              onDismiss: onDismiss,
            ),
          ],
        ),
      ),
    );
  }
}
