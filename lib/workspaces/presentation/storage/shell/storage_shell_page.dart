import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/storage/transport/download_transport_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:devplanner/workspaces/domain/ports/storage_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_realtime_client.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_browser_chrome.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_error_banner.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_error_banner_host.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/storage_keyboard_shortcuts.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_browser_body.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_realtime_refresh.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_scope_route_codec.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_sidebar.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_view_preference_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_state.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/widgets/storage_upload_queue_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Główny shell widoku modułu Files (Universal Storage Engine).
///
/// Jedyny host plików osobistych, workspace i projektu. Zakres zmienia dane,
/// breadcrumbs i dozwolone akcje, ale nie przełącza użytkownika na uboższą
/// implementację. Integruje drzewo odpowiedzialności:
/// - Sidebar nawigacyjny (Moje pliki, Udostępnione, Ostatnie, Ulubione, Kosz)
/// - Górny nagłówek (kontekst i akcje nadrzędne)
/// - Pasek narzędziowy (okruszki, szukaj, sortowanie, widok)
/// - Pasek zaznaczenia masowego (Bulk toolbar)
/// - Ciało eksploratora (siatka lub lista folderów i plików, stan pusty, ładowanie, błąd)
/// - Pływająca kolejka uploadu plików (Overlay)
class StorageShellPage extends StatelessWidget {
  /// Tworzy shell plików z opcjonalnym początkowym zakresem i wstrzykiwanymi portami.
  const StorageShellPage({
    this.initialScope = const StorageScope.personal(),
    this.storageRepository,
    this.capabilities = StorageShellCapabilities.readOnly,
    this.filePicker,
    this.downloadTransport,
    this.uploadTransport,
    this.initialViewMode = StorageViewMode.list,
    this.viewPreferenceStore,
    this.userDirectory,
    this.realtimeClientFactory,
    this.onOpenFileDetails,
    super.key,
  });

  /// Początkowy zakres biznesowy.
  final StorageScope initialScope;

  /// Opcjonalne repozytorium (jeśli null, pobierane z context.read).
  final StorageRepository? storageRepository;

  /// Uprawnienia kompozycji; domyślnie read-only, więc brak jawnej decyzji
  /// composition rootu nigdy nie odsłania akcji mutujących.
  final StorageShellCapabilities capabilities;

  /// Platform picker plików wymagany przez akcję wysyłania.
  final FilePickerPort? filePicker;

  /// Opcjonalny transport pobierania.
  final DownloadTransport? downloadTransport;

  /// Opcjonalny transport wysyłania.
  final UploadTransport? uploadTransport;

  /// Początkowy tryb widoku używany, gdy nie ma zapisanej preferencji.
  final StorageViewMode initialViewMode;

  /// Trwałe preferencje widoku; brak portu oznacza brak trwałości.
  final StorageViewPreferenceStore? viewPreferenceStore;

  /// Lokalny katalog użytkowników; brak portu wyłącza tryb udostępniania osobie
  /// i filtr właściciela, zamiast pokazywać pole, które nic nie zwraca.
  final StorageUserDirectoryPort? userDirectory;

  /// Nawigacja do świeżych szczegółów pliku, składana wyłącznie przez router.
  final ValueChanged<String>? onOpenFileDetails;

  /// Fabryka kanału zmian plików. `null` oznacza ekran bez odświeżeń na żywo
  /// (np. webowy BFF bez tokenu dla huba); lista i mutacje działają wtedy jak
  /// dotąd, a użytkownik nie widzi cudzych zmian bez odświeżenia.
  final StorageRealtimeClientFactory? realtimeClientFactory;

  @override
  Widget build(BuildContext context) {
    final effectiveRepository =
        storageRepository ?? context.read<StorageRepository>();
    final effectiveDownload =
        downloadTransport ?? const DownloadTransportImpl();
    final effectiveUpload = uploadTransport ?? PresignedUploadTransport();
    final routedScope = StorageScopeRouteCodec.contextualScope(
      initialScope,
      StorageScopeRouteCodec.routeUri(context),
    );
    final storedPreference = viewPreferenceStore?.preferenceFor(
      scopeKey: StorageViewPreferenceScope.keyOf(routedScope),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<StorageBrowserCubit>(
          create: (_) {
            final cubit = StorageBrowserCubit(
              repository: effectiveRepository,
              initialScope: routedScope,
              initialViewMode: storedPreference?.viewMode ?? initialViewMode,
              initialSort:
                  storedPreference?.sort ?? const StorageSortCriteria(),
              initialDensity:
                  storedPreference?.density ?? StorageDensity.comfortable,
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider<StorageSelectionCubit>(
          create: (_) => StorageSelectionCubit(),
        ),
        BlocProvider<StorageFolderMutationCubit>(
          create: (_) => StorageFolderMutationCubit(
            repository: effectiveRepository,
          ),
        ),
        BlocProvider<StorageDocumentMutationCubit>(
          create: (_) => StorageDocumentMutationCubit(
            repository: effectiveRepository,
          ),
        ),
        BlocProvider<StorageFileMutationCubit>(
          create: (_) => StorageFileMutationCubit(
            repository: effectiveRepository,
            downloadTransport: effectiveDownload,
          ),
        ),
        BlocProvider<StorageUploadCubit>(
          create: (_) => StorageUploadCubit(
            repository: effectiveRepository,
            uploadTransport: effectiveUpload,
          ),
        ),
        BlocProvider<StoragePreviewCubit>(
          create: (_) => StoragePreviewCubit(
            repository: effectiveRepository,
          ),
        ),
      ],
      child: MultiProvider(
        providers: [
          // Port i repozytorium są częścią kompozycji trasy: menu kontekstowe,
          // panel wersji i dialog udostępniania czytają je z drzewa, a nie
          // tworzą własnego transportu.
          RepositoryProvider<StorageRepository>.value(
            value: effectiveRepository,
          ),
          Provider<DownloadTransport>.value(value: effectiveDownload),
          // Modal udostępniania i filtr właściciela czytają katalog z drzewa
          // modułu, a do samego modala port wędruje jawnie z miejsca otwarcia.
          Provider<StorageUserDirectoryPort?>.value(value: userDirectory),
        ],
        child: _StorageShellView(
          routedScope: routedScope,
          capabilities: capabilities,
          filePicker: filePicker,
          viewPreferenceStore: viewPreferenceStore,
          realtimeClientFactory: realtimeClientFactory,
          onOpenFileDetails: onOpenFileDetails,
        ),
      ),
    );
  }
}

class _StorageShellView extends StatefulWidget {
  const _StorageShellView({
    required this.routedScope,
    required this.capabilities,
    required this.filePicker,
    required this.viewPreferenceStore,
    required this.realtimeClientFactory,
    required this.onOpenFileDetails,
  });

  /// Zakres odtworzony z bieżącego adresu; jest źródłem prawdy dla shella.
  final StorageScope routedScope;

  final StorageShellCapabilities capabilities;
  final FilePickerPort? filePicker;
  final StorageViewPreferenceStore? viewPreferenceStore;
  final StorageRealtimeClientFactory? realtimeClientFactory;
  final ValueChanged<String>? onOpenFileDetails;

  @override
  State<_StorageShellView> createState() => _StorageShellViewState();
}

class _StorageShellViewState extends State<_StorageShellView> {
  /// Błąd ostatniej mutacji: stan krótkotrwały tej powierzchni, z jawnym
  /// właścicielem i zwolnieniem razem z widokiem.
  final _mutationError = ValueNotifier<StorageMutationError?>(null);

  /// Kanał zmian plików tego ekranu. Powstaje dopiero, gdy kompozycja podała
  /// fabrykę, i żyje dokładnie tyle, ile widok.
  StorageRealtimeRefreshCoordinator? _realtime;

  void _showMutationError(StorageMutationError error) {
    _mutationError.value = error;
  }

  /// Podłącza kanał właściwy dla zakresu widoku.
  ///
  /// Kanał jest własnością tego ekranu, więc zmiana zakresu przestawia
  /// subskrypcję, zamiast tworzyć drugie połączenie.
  void _startRealtime(StorageScope scope) {
    final factory = widget.realtimeClientFactory;
    if (factory == null || !mounted) return;
    final coordinator = _realtime ??= StorageRealtimeRefreshCoordinator(
      client: factory(),
      browser: context.read<StorageBrowserCubit>(),
      selection: context.read<StorageSelectionCubit>(),
      onFailure: _showMutationError,
    );
    final ownerUserId = context
        .read<AuthSessionPort?>()
        ?.snapshot
        .user
        ?.userId;
    unawaited(coordinator.start(scope, ownerUserId: ownerUserId));
  }

  @override
  void initState() {
    super.initState();
    _startRealtime(widget.routedScope);
  }

  @override
  void dispose() {
    // Zamknięcie ekranu nie czeka na odsubskrybowanie kanału.
    unawaited(_realtime?.dispose());
    _realtime = null;
    _mutationError.dispose();
    super.dispose();
  }

  /// Adoptuje zakres z adresu zamiast odtwarzać drzewo Cubitów.
  ///
  /// Odtworzenie providerów zmieniało klucz przy każdej zmianie zakresu i
  /// powodowało drugie, zbędne żądanie listy po każdej nawigacji w module.
  @override
  void didUpdateWidget(covariant _StorageShellView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.routedScope == oldWidget.routedScope) return;
    final target = widget.routedScope;
    // Cubit nie może być zmieniony w trakcie budowania drzewa.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<StorageBrowserCubit>();
      if (cubit.currentScope != target) {
        unawaited(cubit.setScope(target));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final capabilities = widget.capabilities;
    final filePicker = widget.filePicker;
    final onOpenFileDetails = widget.onOpenFileDetails;
    return MultiBlocListener(
      listeners: [
        BlocListener<StorageBrowserCubit, StorageBrowserState>(
          listenWhen: (previous, current) =>
              _StorageStateScope.read(previous) !=
              _StorageStateScope.read(current),
          listener: (context, state) {
            final currentUri = StorageScopeRouteCodec.routeUri(context);
            if (currentUri == null) return;
            final location = StorageScopeRouteCodec.contextualLocation(
              _StorageStateScope.read(state),
              currentUri,
            );
            if (location != null && currentUri.toString() != location) {
              context.go(location);
            }
          },
        ),
        // Zakres zmienia kanał: inny zakres to inny zbiór zdarzeń, a nie ten
        // sam kanał z innym filtrem.
        BlocListener<StorageBrowserCubit, StorageBrowserState>(
          listenWhen: (previous, current) =>
              _StorageStateScope.read(previous) !=
              _StorageStateScope.read(current),
          listener: (context, state) =>
              _startRealtime(_StorageStateScope.read(state)),
        ),
        BlocListener<StorageFileMutationCubit, StorageFileMutationState>(
          listener: (context, state) {
            if (state is StorageFileMutationSuccess ||
                state is StorageFileMutationPartialSuccess) {
              context.read<StorageSelectionCubit>().clearSelection();
              unawaited(
                context.read<StorageBrowserCubit>().load(showLoading: false),
              );
            }
            if (state is StorageFileMutationFailure) {
              _showMutationError(
                StorageMutationError(
                  message: switch (state.messageCode) {
                    StorageFileMutationMessage.deleteFailed =>
                      context.l10n.storageDeleteSelectedFailed,
                    _ => state.message,
                  },
                  code: state.apiCode,
                  traceId: state.traceId,
                  // Konflikt przeniesienia ma bezpieczne ponowienie: intencja
                  // i klucz idempotencji są zachowane, więc „Ponów” nie tworzy
                  // drugiej referencji.
                  onRetry:
                      state.messageCode ==
                          StorageFileMutationMessage.placementConflict
                      ? () => unawaited(
                          context
                              .read<StorageFileMutationCubit>()
                              .retryPlacementMove(),
                        )
                      : null,
                ),
              );
            } else if (state is StorageFileMutationPartialSuccess) {
              _showMutationError(
                StorageMutationError(
                  message: switch (state.messageCode) {
                    StorageFileMutationMessage.partialDelete =>
                      context.l10n.storagePartialDeleteFailed,
                    StorageFileMutationMessage.partialMove =>
                      context.l10n.storagePartialMoveFailed,
                    _ => state.errorMessage,
                  },
                ),
              );
            }
          },
        ),
        BlocListener<StorageFolderMutationCubit, StorageFolderMutationState>(
          listener: (context, state) {
            if (state is StorageFolderMutationSuccess) {
              unawaited(
                context.read<StorageBrowserCubit>().load(showLoading: false),
              );
            } else if (state is StorageFolderMutationFailure) {
              _showMutationError(
                StorageMutationError(
                  message: state.message,
                  code: state.apiCode,
                  traceId: state.traceId,
                ),
              );
            }
          },
        ),
        BlocListener<
          StorageDocumentMutationCubit,
          StorageDocumentMutationState
        >(
          listener: (context, state) {
            if (state is StorageDocumentMutationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.storageCreateDocumentSuccess),
                ),
              );
              unawaited(
                context.read<StorageBrowserCubit>().load(showLoading: false),
              );
              unawaited(
                context.read<StoragePreviewCubit>().preparePreview(state.file),
              );
              unawaited(
                showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<StoragePreviewCubit>(),
                    child: StoragePreviewDialog(file: state.file),
                  ),
                ),
              );
            } else if (state is StorageDocumentMutationFailure) {
              _showMutationError(
                StorageMutationError(
                  message: state.message,
                  code: state.apiCode,
                  traceId: state.traceId,
                  // Utworzenie dokumentu zachowuje intencję i klucz idempotencji,
                  // więc ponowienie nie tworzy drugiego pliku.
                  onRetry: () => unawaited(
                    context.read<StorageDocumentMutationCubit>().retry(),
                  ),
                ),
              );
            }
          },
        ),
        // Wejście w zakres ustawia jego własny zapis. Dzięki temu wybór
        // z poprzedniego zakresu nie przecieka do nowego, a zakres bez zapisu
        // startuje z wartości domyślnych produktu. Kompozycja bez portu
        // trwałości zachowuje bieżący widok, bo nie ma czym rządzić.
        BlocListener<StorageBrowserCubit, StorageBrowserState>(
          listenWhen: (previous, current) =>
              _StorageStateScope.read(previous) !=
              _StorageStateScope.read(current),
          listener: (context, state) {
            final store = widget.viewPreferenceStore;
            if (store == null) return;
            final stored =
                store.preferenceFor(
                  scopeKey: StorageViewPreferenceScope.keyOf(
                    _StorageStateScope.read(state),
                  ),
                ) ??
                StorageViewPreference.defaults;
            final cubit = context.read<StorageBrowserCubit>();
            cubit.setViewMode(stored.viewMode);
            cubit.setSort(stored.sort);
            cubit.setDensity(stored.density);
          },
        ),
        // Zapis wyłącznie reakcji użytkownika: stan bez listy nie niesie tych
        // pól, więc przejście w błąd albo odmowę dostępu nie nadpisuje zapisu.
        BlocListener<StorageBrowserCubit, StorageBrowserState>(
          listenWhen: (previous, current) {
            final next = _StorageViewPreference.read(current);
            return next != null &&
                next != _StorageViewPreference.read(previous);
          },
          listener: (context, state) {
            final store = widget.viewPreferenceStore;
            final preference = _StorageViewPreference.read(state);
            if (store == null || preference == null) return;
            unawaited(
              store.write(
                scopeKey: StorageViewPreferenceScope.keyOf(widget.routedScope),
                preference: preference,
              ),
            );
          },
        ),
        BlocListener<StorageUploadCubit, StorageUploadState>(
          listenWhen: (previous, current) =>
              current.completedCount > previous.completedCount,
          listener: (context, state) => unawaited(
            context.read<StorageBrowserCubit>().load(showLoading: false),
          ),
        ),
      ],
      child: BlocBuilder<StorageBrowserCubit, StorageBrowserState>(
        buildWhen: (previous, current) =>
            _StorageStateScope.read(previous).folderId !=
            _StorageStateScope.read(current).folderId,
        builder: (context, state) {
          final scope = _StorageStateScope.read(state);
          final returnTo = StorageScopeRouteCodec.returnLocation(
            StorageScopeRouteCodec.routeUri(context),
          );
          return PopScope(
            canPop: scope.folderId == null && returnTo == null,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              if (scope.folderId != null) {
                unawaited(context.read<StorageBrowserCubit>().navigateUp());
              } else if (returnTo != null) {
                context.go(returnTo);
              }
            },
            child: StorageKeyboardShortcuts(
              capabilities: capabilities,
              child: Scaffold(
                backgroundColor: context.colors.surface,
                body: Stack(
                  children: [
                    _StorageResponsiveContent(
                      capabilities: capabilities,
                      filePicker: filePicker,
                      onOpenFileDetails: onOpenFileDetails,
                      mutationError: _mutationError,
                    ),
                    const StorageUploadQueueOverlay(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StorageResponsiveContent extends StatelessWidget {
  const _StorageResponsiveContent({
    required this.capabilities,
    required this.filePicker,
    required this.onOpenFileDetails,
    required this.mutationError,
  });

  final StorageShellCapabilities capabilities;
  final FilePickerPort? filePicker;
  final ValueChanged<String>? onOpenFileDetails;
  final ValueNotifier<StorageMutationError?> mutationError;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                  const StorageErrorBannerHost(),
                  // Błąd mutacji jest trwały: pokazuje kod i traceId oraz
                  // pozwala ponowić albo odświeżyć, zamiast znikać jak SnackBar.
                  ValueListenableBuilder<StorageMutationError?>(
                    valueListenable: mutationError,
                    builder: (context, error, _) => error == null
                        ? const SizedBox.shrink()
                        : StorageErrorBanner(
                            message: error.message,
                            code: error.code,
                            traceId: error.traceId,
                            onRetry: error.onRetry,
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
}

/// Pola widoku niesione przez stan listy.
///
/// Stan błędu i odmowy dostępu nie przechowuje tych pól, więc nie może być
/// źródłem zapisu preferencji — inaczej awaria sieci przestawiłaby użytkownikowi
/// zapisany widok.
final class _StorageViewPreference {
  const _StorageViewPreference._();

  static StorageViewPreference? read(
    StorageBrowserState state,
  ) => switch (state) {
    StorageBrowserInitial(:final viewMode, :final sort, :final density) =>
      StorageViewPreference(viewMode: viewMode, sort: sort, density: density),
    StorageBrowserLoading(:final viewMode, :final sort, :final density) =>
      StorageViewPreference(viewMode: viewMode, sort: sort, density: density),
    StorageBrowserReady(:final viewMode, :final sort, :final density) =>
      StorageViewPreference(viewMode: viewMode, sort: sort, density: density),
    StorageBrowserEmpty(:final viewMode, :final sort, :final density) =>
      StorageViewPreference(viewMode: viewMode, sort: sort, density: density),
    StorageBrowserFailure() || StorageBrowserForbidden() => null,
  };
}

final class _StorageStateScope {
  const _StorageStateScope._();

  static StorageScope read(StorageBrowserState state) => switch (state) {
    StorageBrowserInitial(:final scope) => scope,
    StorageBrowserLoading(:final scope) => scope,
    StorageBrowserReady(:final scope) => scope,
    StorageBrowserEmpty(:final scope) => scope,
    StorageBrowserFailure(:final scope) => scope,
    StorageBrowserForbidden(:final scope) => scope,
  };
}
