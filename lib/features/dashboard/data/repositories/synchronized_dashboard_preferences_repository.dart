import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ready_next/core/storage/hive_helper.dart';
import 'package:ready_next/features/dashboard/data/api/dashboard_preferences_api.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';

/// Repozytorium pulpitu synchronizujące Core z odpornym na offline cache'em Hive.
class SynchronizedDashboardPreferencesRepository
    implements DashboardPreferencesRepository {
  /// Tworzy repozytorium z API Core oraz lokalnym cache'em i dziennikiem synchronizacji.
  factory SynchronizedDashboardPreferencesRepository({
    required DashboardPreferencesApi api,
    required DashboardPreferencesRepository localRepository,
  }) => SynchronizedDashboardPreferencesRepository._(api, localRepository);

  SynchronizedDashboardPreferencesRepository._(
    this._api,
    this._localRepository,
  );

  static const _schemaVersion = 1;
  static const _syncStateBoxName = 'dashboard_preferences_sync_state_v1';

  final DashboardPreferencesApi _api;
  final DashboardPreferencesRepository _localRepository;

  @override
  Future<DashboardPreferences> getPreferences({
    required String readyUserId,
  }) async {
    final normalizedUserId = _normalizeReadyUserId(readyUserId);
    final hadLocalPreferences = await _hasStoredPreferences(normalizedUserId);
    final local = await _localRepository.getPreferences(
      readyUserId: normalizedUserId,
    );
    if (_isAnonymous(local.readyUserId)) {
      return local;
    }

    var state = await _readSyncState(local.readyUserId);
    if (state.isPending) {
      return _syncPending(local);
    }
    if (state.hasSynchronized &&
        state.syncedFingerprint != _preferencesFingerprint(local)) {
      state = state.copyWith(isPending: true);
      await _writeSyncState(local.readyUserId, state);
      return _syncPending(local);
    }

    try {
      final remote = await _api.getPreferences();
      if (!state.hasSynchronized &&
          hadLocalPreferences &&
          local.updatedAt.isAfter(remote.updatedAtUtc.toLocal())) {
        state = state.copyWith(
          isPending: true,
          hasSynchronized: true,
          revision: remote.revision,
        );
        await _writeSyncState(local.readyUserId, state);
        return await _syncPending(local);
      }
      return await _storeRemote(remote, readyUserId: local.readyUserId);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        state = state.copyWith(isPending: true);
        await _writeSyncState(local.readyUserId, state);
        return _syncPending(local);
      }
      if (hadLocalPreferences && !state.hasSynchronized) {
        await _writeSyncState(
          local.readyUserId,
          state.copyWith(isPending: true),
        );
      }
      return local;
    }
  }

  @override
  Future<DashboardPreferences> savePreferences(
    DashboardPreferences preferences,
  ) async {
    final local = await _localRepository.savePreferences(preferences);
    if (_isAnonymous(local.readyUserId)) {
      return local;
    }

    final state = (await _readSyncState(local.readyUserId)).copyWith(
      isPending: true,
    );
    await _writeSyncState(local.readyUserId, state);
    return _syncPending(local);
  }

  @override
  Future<DashboardPreferences> updatePreferences({
    required String readyUserId,
    required DashboardPreferences Function(DashboardPreferences current) update,
  }) async {
    final current = await getPreferences(readyUserId: readyUserId);
    return savePreferences(update(current));
  }

  @override
  Future<void> close() async {
    await HiveHelper.closeBox(_syncStateBoxName);
    await _localRepository.close();
  }

  Future<DashboardPreferences> _syncPending(
    DashboardPreferences local,
  ) async {
    try {
      final remote = await _api.getPreferences();
      return await _uploadLocal(local, revision: remote.revision);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return _uploadLocal(local, revision: 0);
      }
      return local;
    }
  }

  Future<DashboardPreferences> _uploadLocal(
    DashboardPreferences preferences, {
    required int revision,
  }) async {
    try {
      final remote = await _api.putPreferences(
        PutDashboardPreferencesRequest(
          schemaVersion: _schemaVersion,
          revision: revision,
          preferences: preferences,
        ),
      );
      return await _storeRemote(remote, readyUserId: preferences.readyUserId);
    } on DioException catch (error) {
      return error.response?.statusCode == 409
          ? _acceptRemoteAfterRevisionConflict(preferences)
          : preferences;
    }
  }

  Future<DashboardPreferences> _acceptRemoteAfterRevisionConflict(
    DashboardPreferences local,
  ) async {
    try {
      final latest = await _api.getPreferences();
      return await _storeRemote(latest, readyUserId: local.readyUserId);
    } on DioException {
      return local;
    }
  }

  Future<DashboardPreferences> _storeRemote(
    RemoteDashboardPreferences remote, {
    required String readyUserId,
  }) async {
    final preferences = await _localRepository.savePreferences(
      remote.preferences.copyWith(
        readyUserId: readyUserId,
        updatedAt: remote.updatedAtUtc.toLocal(),
      ),
    );
    await _writeSyncState(
      preferences.readyUserId,
      _DashboardSyncState(
        hasSynchronized: true,
        revision: remote.revision,
        syncedFingerprint: _preferencesFingerprint(preferences),
      ),
    );
    return preferences;
  }

  Future<bool> _hasStoredPreferences(String readyUserId) async {
    final localStore = _localRepository;
    if (localStore is DashboardPreferencesLocalStore) {
      final dashboardLocalStore = localStore as DashboardPreferencesLocalStore;
      return dashboardLocalStore.hasStoredPreferences(readyUserId: readyUserId);
    }
    return true;
  }

  Future<_DashboardSyncState> _readSyncState(String readyUserId) async {
    final box = await HiveHelper.openBox<String>(_syncStateBoxName);
    final raw = box.get(_normalizeReadyUserId(readyUserId));
    if (raw == null) {
      return const _DashboardSyncState();
    }

    try {
      return _DashboardSyncState.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } on Object {
      await box.delete(_normalizeReadyUserId(readyUserId));
      return const _DashboardSyncState();
    }
  }

  Future<void> _writeSyncState(
    String readyUserId,
    _DashboardSyncState state,
  ) async {
    final box = await HiveHelper.openBox<String>(_syncStateBoxName);
    await box.put(
      _normalizeReadyUserId(readyUserId),
      jsonEncode(state.toJson()),
    );
  }

  String _normalizeReadyUserId(String readyUserId) {
    final normalized = readyUserId.trim();
    return normalized.isEmpty ? 'anonymous' : normalized;
  }

  bool _isAnonymous(String readyUserId) => readyUserId.trim() == 'anonymous';

  String _preferencesFingerprint(DashboardPreferences preferences) {
    final document = preferences.toJson()..remove('updatedAt');
    final source = jsonEncode(document);
    var hash = 0x811c9dc5;
    for (final codeUnit in source.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}

/// Trwały metadokument opisujący status synchronizacji pojedynczego pulpitu.
class _DashboardSyncState {
  /// Tworzy stan synchronizacji z rewizją ostatniej znanej wersji Core.
  const _DashboardSyncState({
    this.hasSynchronized = false,
    this.isPending = false,
    this.revision,
    this.syncedFingerprint,
  });

  /// Odtwarza stan synchronizacji z bezpiecznego dokumentu JSON Hive.
  factory _DashboardSyncState.fromJson(Map<String, dynamic> json) {
    final revision = json['revision'];
    return _DashboardSyncState(
      hasSynchronized: json['hasSynchronized'] as bool? ?? false,
      isPending: json['isPending'] as bool? ?? false,
      revision: revision is num && revision >= 0 ? revision.toInt() : null,
      syncedFingerprint: json['syncedFingerprint'] as String?,
    );
  }

  final bool hasSynchronized;
  final bool isPending;
  final int? revision;
  final String? syncedFingerprint;

  /// Tworzy zmodyfikowaną kopię stanu synchronizacji.
  _DashboardSyncState copyWith({
    bool? hasSynchronized,
    bool? isPending,
    int? revision,
    String? syncedFingerprint,
  }) {
    return _DashboardSyncState(
      hasSynchronized: hasSynchronized ?? this.hasSynchronized,
      isPending: isPending ?? this.isPending,
      revision: revision ?? this.revision,
      syncedFingerprint: syncedFingerprint ?? this.syncedFingerprint,
    );
  }

  /// Zamienia stan na dokument gotowy do zapisu w Hive.
  Map<String, dynamic> toJson() => {
    'hasSynchronized': hasSynchronized,
    'isPending': isPending,
    'revision': revision,
    'syncedFingerprint': syncedFingerprint,
  };
}
