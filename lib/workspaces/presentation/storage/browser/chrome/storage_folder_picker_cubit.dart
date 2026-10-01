import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Niezmienny stan nawigacji w folderach jednego zakresu.
final class StorageFolderPickerState extends Equatable {
  const StorageFolderPickerState({
    this.path = const [],
    this.folders = const [],
    this.loading = true,
    this.error,
  });

  final List<StorageFolderResponse> path;
  final List<StorageFolderResponse> folders;
  final bool loading;
  final ApiError? error;

  StorageFolderResponse? get selected => path.isEmpty ? null : path.last;

  @override
  List<Object?> get props => [path, folders, loading, error];
}

/// Właściciel odczytów pickera; odrzuca odpowiedzi poprzedniej nawigacji.
final class StorageFolderPickerCubit extends Cubit<StorageFolderPickerState> {
  StorageFolderPickerCubit({required this.repository, required this.scope})
    : super(const StorageFolderPickerState());

  final StorageRepository repository;
  final StorageScope scope;
  int _generation = 0;
  DateTime? _retryAfterUtc;

  Future<void> open(StorageFolderResponse folder) async {
    if (isClosed || _blocked) return;
    await _load([...state.path, folder]);
  }

  Future<void> up() async {
    if (isClosed || state.path.isEmpty || _blocked) return;
    await _load(state.path.sublist(0, state.path.length - 1));
  }

  Future<void> load() async {
    if (isClosed || state.loading && _generation != 0 || _blocked) return;
    await _load(state.path);
  }

  bool get _blocked =>
      _retryAfterUtc != null &&
      DateTime.now().toUtc().isBefore(_retryAfterUtc!);

  Future<void> _load(List<StorageFolderResponse> path) async {
    final generation = ++_generation;
    final immutablePath = List<StorageFolderResponse>.unmodifiable(path);
    emit(StorageFolderPickerState(path: immutablePath));
    final parentId = path.isEmpty ? scope.folderId : path.last.id;
    try {
      final result = await repository.listFolders(
        scope: scope.copyWithFolder(parentId),
        parentFolderId: parentId,
      );
      if (!_owns(generation)) return;
      result.fold(
        (error) => _fail(generation, immutablePath, error),
        (folders) => emit(
          StorageFolderPickerState(
            path: immutablePath,
            folders: List<StorageFolderResponse>.unmodifiable(folders),
            loading: false,
          ),
        ),
      );
    } on ApiError catch (error) {
      _fail(generation, immutablePath, error);
    } on DioException catch (error) {
      _fail(
        generation,
        immutablePath,
        ApiError.fromDioException(
          error,
          fallbackMessage: 'Nie udało się wczytać folderów.',
        ),
      );
    } catch (_) {
      _fail(
        generation,
        immutablePath,
        const ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się wczytać folderów.',
        ),
      );
    }
  }

  bool _owns(int generation) => !isClosed && generation == _generation;

  void _fail(int generation, List<StorageFolderResponse> path, ApiError error) {
    if (!_owns(generation)) return;
    final deadline = error.retryAfterUtc;
    if (deadline != null &&
        (_retryAfterUtc == null || deadline.isAfter(_retryAfterUtc!))) {
      _retryAfterUtc = deadline;
    }
    emit(StorageFolderPickerState(path: path, loading: false, error: error));
  }
}
