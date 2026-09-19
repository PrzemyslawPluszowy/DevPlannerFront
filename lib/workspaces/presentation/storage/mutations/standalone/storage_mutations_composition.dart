import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Composition boundary for Files mutations.
///
/// The route supplies already-authenticated repository and platform transports.
/// Mutation cubits never construct HTTP clients, read tokens, or access
/// platform storage directly.
final class StorageMutationsComposition extends StatelessWidget {
  /// Creates the standalone mutation scope for a Files route.
  const StorageMutationsComposition({
    required this.repository,
    required this.downloadTransport,
    required this.uploadTransport,
    required this.child,
    super.key,
  });

  /// Authenticated Storage repository supplied by the composition root.
  final StorageRepository repository;

  /// Transport used by file actions that download or export data.
  final DownloadTransport downloadTransport;

  /// Presigned upload transport supplied by the platform adapter.
  final UploadTransport uploadTransport;

  /// Files content that consumes mutation cubits.
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<StorageFolderMutationCubit>(
        create: (_) => StorageFolderMutationCubit(repository: repository),
      ),
      BlocProvider<StorageFileMutationCubit>(
        create: (_) => StorageFileMutationCubit(
          repository: repository,
          downloadTransport: downloadTransport,
        ),
      ),
      BlocProvider<StorageUploadCubit>(
        create: (_) => StorageUploadCubit(
          repository: repository,
          uploadTransport: uploadTransport,
        ),
      ),
    ],
    child: child,
  );
}
