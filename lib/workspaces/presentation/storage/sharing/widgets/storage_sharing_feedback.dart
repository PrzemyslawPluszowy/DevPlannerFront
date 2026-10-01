import 'dart:async';

import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_sharing_error_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Błąd i odświeżenie pozostają widoczne nad zawartością dialogu.
final class StorageSharingFeedback extends StatelessWidget {
  const StorageSharingFeedback({super.key});

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<StorageSharingCubit, StorageSharingState>(
    builder: (context, state) {
      if (state is StorageSharingLoading) {
        return const LinearProgressIndicator(minHeight: 2);
      }
      if (state is StorageSharingFailure) {
        return StorageSharingErrorPanel(
          error: state.error,
          onRefresh: () => _refresh(context),
        );
      }
      if (state is! StorageSharingReady) return const SizedBox.shrink();
      final error = state.mutationError ?? state.loadError;
      if (error == null && !state.isRefreshing) return const SizedBox.shrink();
      return Column(
        children: [
          if (error != null)
            StorageSharingErrorPanel(
              error: error,
              isRefreshing: state.isRefreshing || state.isMutating,
              onRefresh: () => _refresh(context),
            ),
          if (state.isRefreshing) const LinearProgressIndicator(minHeight: 2),
        ],
      );
    },
  );

  void _refresh(BuildContext context) {
    unawaited(context.read<StorageSharingCubit>().loadShares());
  }
}
