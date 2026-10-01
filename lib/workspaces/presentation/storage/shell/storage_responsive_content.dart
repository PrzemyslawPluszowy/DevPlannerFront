import 'dart:async';

import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_browser_chrome.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_browser_body.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_feedback_area.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Składa sidebar i zawartość przeglądarki dla dostępnej szerokości.
final class StorageResponsiveContent extends StatelessWidget {
  const StorageResponsiveContent({
    required this.capabilities,
    required this.filePicker,
    required this.onOpenFileDetails,
    required this.mutationError,
    super.key,
  });

  final StorageShellCapabilities capabilities;
  final FilePickerPort? filePicker;
  final ValueChanged<String>? onOpenFileDetails;
  final ValueNotifier<StorageMutationError?> mutationError;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compactSidebar = constraints.maxWidth < 900;
      return Row(
        children: [
          StorageSidebar(compact: compactSidebar),
          Expanded(
            child: Column(
              children: [
                StorageBrowserChrome(
                  capabilities: capabilities,
                  filePicker: filePicker,
                ),
                StorageShellFeedbackArea(
                  availableHeight: constraints.maxHeight,
                  errorListenable: mutationError,
                  onRefresh: () {
                    mutationError.value = null;
                    unawaited(
                      context.read<StorageBrowserCubit>().load(
                        showLoading: false,
                      ),
                    );
                  },
                  onDismiss: () => mutationError.value = null,
                ),
                Expanded(
                  child: StorageBrowserBody(
                    capabilities: capabilities,
                    onOpenFileDetails: onOpenFileDetails,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
