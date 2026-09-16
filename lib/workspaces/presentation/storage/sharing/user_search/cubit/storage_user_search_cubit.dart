import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/user_search/cubit/storage_user_search_state.dart';

/// Debounced Ready directory search scoped to the file workspace.
final class StorageUserSearchCubit extends Cubit<StorageUserSearchState> {
  StorageUserSearchCubit({
    required this.workspaceId,
    required this.repository,
  }) : super(
         workspaceId == null
             ? const StorageUserSearchUnavailable()
             : const StorageUserSearchInitial(),
       );

  final String? workspaceId;
  final WorkspacesRepository repository;
  Timer? _debounce;
  int _requestGeneration = 0;

  void search(String query) {
    _debounce?.cancel();
    final normalized = query.trim();
    final workspace = workspaceId;
    if (workspace == null) {
      emit(const StorageUserSearchUnavailable());
      return;
    }
    if (normalized.length < 2) {
      _requestGeneration++;
      emit(const StorageUserSearchInitial());
      return;
    }

    final generation = ++_requestGeneration;
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (isClosed || generation != _requestGeneration) return;
      emit(StorageUserSearchLoading(normalized));
      final result = await repository.searchReadyUsers(
        workspaceId: workspace,
        query: normalized,
      );
      if (isClosed || generation != _requestGeneration) return;
      result.fold(
        (error) => emit(StorageUserSearchFailure(error.message)),
        (users) => emit(
          StorageUserSearchReady(
            query: normalized,
            users: users
                .where((user) => user.coreUserId?.isNotEmpty ?? false)
                .toList(growable: false),
          ),
        ),
      );
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await super.close();
  }
}
