import 'dart:async';

import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_error_banner.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Montuje trwały banner błędu pod chrome'em, nad ciałem eksploratora.
///
/// Banner należy do stanu pobrania zakresu, więc znika dopiero wtedy, gdy stan
/// przestaje być błędem — czyli po udanym ponowieniu albo odświeżeniu. Nie ma
/// akcji ukrycia, bo ukryty błąd wracałby dopiero przy następnej nawigacji.
final class StorageErrorBannerHost extends StatelessWidget {
  /// Tworzy host bannera.
  const StorageErrorBannerHost({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageBrowserCubit, StorageBrowserState>(
        buildWhen: (previous, current) =>
            previous is StorageBrowserFailure ||
            current is StorageBrowserFailure,
        builder: (context, state) {
          if (state is! StorageBrowserFailure) return const SizedBox.shrink();
          final cubit = context.read<StorageBrowserCubit>();
          return StorageErrorBanner(
            message: state.message,
            code: state.apiCode,
            traceId: state.traceId,
            onRetry: () => unawaited(cubit.load()),
            onRefresh: () => unawaited(cubit.load(showLoading: false)),
          );
        },
      );
}
