import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/auth_redirect_policy.dart';
import 'package:ready_next/app/shell/app_shell_export.dart';
import 'package:ready_next/app/startup/presentation/app_startup_page.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/features/auth/presentation/login_page.dart';
import 'package:ready_next/features/bhp/presentation/bhp_home_page.dart';
import 'package:ready_next/features/bhp/presentation/pages/dashboard/bhp_dashboard_page.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/bhp_equipment_page.dart';
import 'package:ready_next/features/bhp/presentation/pages/operations/bhp_issue_operations_page.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/bhp_positions_page.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/bhp_issue_statistics_page.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/bhp_users_page.dart';
import 'package:ready_next/features/dashboard/presentation/app_dashboard_page.dart';
import 'package:ready_next/features/framework/presentation/framework_components_gallery_page.dart';
import 'package:ready_next/features/inne/presentation/inne_home_page.dart';
import 'package:ready_next/features/inventory/presentation/inventory_home_page.dart';
import 'package:ready_next/features/inventory/presentation/pages/archive/inventory_archive_page.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/inventory_companies_page.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_inventories_page.dart';
import 'package:ready_next/features/inventory/presentation/pages/overview/inventory_overview_page.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/inventory_stock_page.dart';
import 'package:ready_next/features/orders/presentation/orders_home_page.dart';
import 'package:ready_next/features/settings/presentation/settings_page.dart';
import 'package:ready_next/shared/presentation/global/app_global_utility_pages.dart';
import 'package:ready_next/shared/presentation/module_placeholder_page.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_scope.dart';
import 'package:ready_next/workspaces/presentation/private/private_pages.dart';
import 'package:ready_next/workspaces/presentation/routing/workspace_resource_pages.dart';
import 'package:ready_next/workspaces/presentation/sections/workspaces_section_pages.dart';
import 'package:ready_next/workspaces/presentation/storage/public_share/storage_public_share_page.dart';
import 'package:ready_next/workspaces/presentation/storage/shell/storage_scope_route_codec.dart';
import 'package:ready_next/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:ready_next/workspaces/presentation/tasks/detail/task_details_page.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home_page.dart';

/// Strona błędu / nieznanego modułu.
class UnknownModulePage extends StatelessWidget {
  const UnknownModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderPage(
      title: 'Nieznany moduł',
      message: 'Ta trasa nie jest jeszcze podłączona do routera aplikacji.',
    );
  }
}

/// Nowoczesny router aplikacji oparty o GoRouter z pełną obsługą Web, deep linków i shelli.
class AppRouter implements Listenable {
  AppRouter({
    required this.authRepository,
    required this.ensureSessionRestored,
    this.navigatorObservers = const [],
    String? initialLocation,
  }) {
    _goRouter = _createRouter(initialLocation);
  }

  final AuthRepository authRepository;
  final Future<void> Function() ensureSessionRestored;
  final List<NavigatorObserver> navigatorObservers;

  late final GoRouter _goRouter;
  GoRouter get config => _goRouter;

  @override
  void addListener(VoidCallback listener) =>
      _goRouter.routerDelegate.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _goRouter.routerDelegate.removeListener(listener);

  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );
  final GlobalKey<NavigatorState> _authenticatedShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'authenticated_shell');
  final GlobalKey<NavigatorState> _workspacesShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'workspaces_shell');
  final GlobalKey<NavigatorState> _bhpShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'bhp_shell');
  final GlobalKey<NavigatorState> _inventoryShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'inventory_shell');

  GlobalKey<NavigatorState> get navigatorKey => _rootNavigatorKey;

  /// Zwalnia delegaty i listenery należące do GoRoutera.
  void dispose() => _goRouter.dispose();

  /// Nawigacja do podanej ścieżki.
  Future<void> navigatePath(String path) async {
    _goRouter.go(path);
  }

  /// Otwiera nową podstronę w stacku.
  Future<T?> push<T extends Object?>(String path, {Object? extra}) {
    return _goRouter.push<T>(path, extra: extra);
  }

  /// Zastępuje bieżącą trasę.
  Future<void> replacePath(String path, {Object? extra}) async {
    _goRouter.go(path, extra: extra);
  }

  /// Próbuje zamknąć bieżący widok w routerze.
  Future<bool> maybePop<T extends Object?>([T? result]) async {
    if (_goRouter.canPop()) {
      _goRouter.pop(result);
      return true;
    }
    return false;
  }

  /// Zamyka bieżący widok w routerze.
  void pop<T extends Object?>([T? result]) {
    _goRouter.pop(result);
  }

  /// Bieżąca znormalizowana ścieżka routera.
  String get currentPath =>
      _goRouter.routerDelegate.currentConfiguration.uri.toString();

  /// Pobiera instancję routera z BuildContext.
  static AppRouter of(BuildContext context) {
    final router = context.read<AppRouter?>();
    if (router != null) return router;
    throw StateError('AppRouter is not found in context.');
  }

  GoRouter _createRouter(String? initialLocation) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialLocation ?? '/',
      debugLogDiagnostics: kDebugMode,
      observers: navigatorObservers,
      redirect: (context, state) async {
        await ensureSessionRestored();
        final isAuthenticated = authRepository.isAuthenticated;
        final path = state.uri.path;
        final isLogin = path == AppRoutePaths.login;
        final isStartup = path == '/';
        final isPublicStorageShare = path.startsWith(
          '${AppRoutePaths.storagePublicShares}/',
        );

        final canonicalPrivatePath = AppRoutePaths.redirectLegacyPrivatePath(
          state.uri,
        );
        if (canonicalPrivatePath != null) {
          return canonicalPrivatePath;
        }

        if (!isAuthenticated) {
          if (isStartup || isLogin || isPublicStorageShare) return null;
          final attempted = state.uri.toString();
          return buildLoginPath(redirectTo: attempted);
        }

        if (isLogin) {
          return resolvePostLoginPath(
            currentLocation: state.uri.toString(),
            fallbackPath: AppRoutePaths.dashboard,
          );
        }

        // Sprawdzenie uprawnień modułowych dla Inwentaryzacji
        if (path.startsWith(AppRoutePaths.inventory)) {
          final permissions =
              authRepository.currentUser?.permissions ?? const <String>{};
          if (!permissions.contains(ReadyPermissions.inventory)) {
            return AppRoutePaths.dashboard;
          }
        }

        // Sprawdzenie uprawnień modułowych dla BHP
        if (path.startsWith(AppRoutePaths.bhp)) {
          final permissions =
              authRepository.currentUser?.permissions ?? const <String>{};
          if (!permissions.contains(ReadyPermissions.bhp)) {
            return AppRoutePaths.dashboard;
          }
        }

        return null;
      },
      errorBuilder: (context, state) => const UnknownModulePage(),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AppStartupPage(),
        ),
        GoRoute(
          path: AppRoutePaths.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '${AppRoutePaths.storagePublicShares}/:shareToken',
          builder: (context, state) => StoragePublicSharePage(
            shareToken: state.pathParameters['shareToken'] ?? '',
          ),
        ),
        ShellRoute(
          navigatorKey: _authenticatedShellNavigatorKey,
          builder: (context, state, child) => AppGlobalShell(
            appRouter: this,
            child: child,
          ),
          routes: [
            GoRoute(
              path: AppRoutePaths.dashboard,
              builder: (context, state) => const AppDashboardPage(),
            ),
            GoRoute(
              path: AppRoutePaths.orders,
              builder: (context, state) => const OrdersHomePage(),
            ),
            GoRoute(
              path: AppRoutePaths.notifications,
              builder: (context, state) => const GlobalNotificationsPage(),
            ),
            GoRoute(
              path: AppRoutePaths.chat,
              builder: (context, state) => const GlobalChatPage(),
              routes: [
                GoRoute(
                  path: 'conversations/:conversationId',
                  builder: (context, state) => GlobalChatConversationPage(
                    conversationId:
                        state.pathParameters['conversationId'] ?? '',
                  ),
                  routes: [
                    GoRoute(
                      path: 'messages/:messageId',
                      builder: (context, state) => GlobalChatMessagePage(
                        conversationId:
                            state.pathParameters['conversationId'] ?? '',
                        messageId: state.pathParameters['messageId'] ?? '',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: '${AppRoutePaths.storageFiles}/:fileId',
              builder: (context, state) => StorageFilePage(
                fileId: state.pathParameters['fileId'] ?? '',
              ),
            ),

            // Shell dla BHP
            ShellRoute(
              navigatorKey: _bhpShellNavigatorKey,
              builder: (context, state, child) => BhpHomePage(child: child),
              routes: [
                GoRoute(
                  path: AppRoutePaths.bhp,
                  builder: (context, state) => const BhpDashboardPage(),
                ),
                GoRoute(
                  path: AppRoutePaths.bhpUsers,
                  builder: (context, state) => const BhpUsersPage(),
                ),
                GoRoute(
                  path: AppRoutePaths.bhpPositions,
                  builder: (context, state) => const BhpPositionsPage(),
                ),
                GoRoute(
                  path: AppRoutePaths.bhpEquipment,
                  builder: (context, state) => const BhpEquipmentPage(),
                ),
                GoRoute(
                  path: '/bhp/operations',
                  builder: (context, state) => const BhpIssueOperationsPage(),
                ),
                GoRoute(
                  path: '/bhp/statistics',
                  builder: (context, state) => const BhpIssueStatisticsPage(),
                ),
              ],
            ),

            // Shell dla Inwentaryzacji
            ShellRoute(
              navigatorKey: _inventoryShellNavigatorKey,
              builder: (context, state, child) =>
                  InventoryHomePage(child: child),
              routes: [
                GoRoute(
                  path: AppRoutePaths.inventory,
                  builder: (context, state) => const InventoryInventoriesPage(),
                ),
                GoRoute(
                  path: AppRoutePaths.inventoryOverview,
                  builder: (context, state) => const InventoryOverviewPage(),
                ),
                GoRoute(
                  path: AppRoutePaths.inventoryStock,
                  builder: (context, state) => const InventoryStockPage(),
                ),
                GoRoute(
                  path: '/inventory/companies',
                  builder: (context, state) => const InventoryCompaniesPage(),
                ),
                GoRoute(
                  path: AppRoutePaths.inventoryArchive,
                  builder: (context, state) => const InventoryArchivePage(),
                ),
              ],
            ),

            // Shell dla Workspaces z trwałym Panelem Bocznym (Directory Menu)
            ShellRoute(
              navigatorKey: _workspacesShellNavigatorKey,
              builder: (context, state, child) =>
                  WorkspacesHomePage(child: child),
              routes: [
                GoRoute(
                  path: AppRoutePaths.workspaces,
                  builder: (context, state) => const WorkspacesOverviewPage(),
                  routes: [
                    GoRoute(
                      path: ':workspaceId',
                      builder: (context, state) {
                        final workspaceId =
                            state.pathParameters['workspaceId'] ?? '';
                        return WorkspaceSectionPage(
                          workspaceId: workspaceId,
                          section: 'overview',
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'projects/:projectId',
                          builder: (context, state) {
                            final workspaceId =
                                state.pathParameters['workspaceId'] ?? '';
                            final projectId =
                                state.pathParameters['projectId'] ?? '';
                            return WorkspaceResourcePage(
                              workspaceId: workspaceId,
                              projectId: projectId,
                              resourceKind: 'project',
                            );
                          },
                          routes: [
                            GoRoute(
                              path: 'tasks',
                              builder: (context, state) {
                                final workspaceId =
                                    state.pathParameters['workspaceId'] ?? '';
                                final projectId =
                                    state.pathParameters['projectId'] ?? '';
                                final view = state.uri.queryParameters['view'];
                                return TasksBoardPage(
                                  workspaceId: workspaceId,
                                  projectId: projectId,
                                  initialView: view,
                                );
                              },
                              routes: [
                                GoRoute(
                                  path: ':taskId',
                                  builder: (context, state) {
                                    final workspaceId =
                                        state.pathParameters['workspaceId'] ??
                                        '';
                                    final projectId =
                                        state.pathParameters['projectId'] ?? '';
                                    final taskId =
                                        state.pathParameters['taskId'] ?? '';
                                    return WorkspaceTaskDetailsPage(
                                      workspaceId: workspaceId,
                                      projectId: projectId,
                                      taskId: taskId,
                                    );
                                  },
                                ),
                              ],
                            ),
                            GoRoute(
                              path: 'whiteboards',
                              builder: (context, state) =>
                                  WorkspaceProjectSectionPage(
                                    workspaceId:
                                        state.pathParameters['workspaceId'] ??
                                        '',
                                    projectId:
                                        state.pathParameters['projectId'] ?? '',
                                    resourceKind: 'whiteboards',
                                  ),
                              routes: [
                                GoRoute(
                                  path: ':resourceId',
                                  builder: (context, state) =>
                                      WorkspaceProjectResourcePage(
                                        workspaceId:
                                            state
                                                .pathParameters['workspaceId'] ??
                                            '',
                                        projectId:
                                            state.pathParameters['projectId'] ??
                                            '',
                                        resourceKind: 'whiteboards',
                                        resourceId:
                                            state
                                                .pathParameters['resourceId'] ??
                                            '',
                                      ),
                                ),
                              ],
                            ),
                            GoRoute(
                              path: 'wiki',
                              builder: (context, state) =>
                                  WorkspaceProjectSectionPage(
                                    workspaceId:
                                        state.pathParameters['workspaceId'] ??
                                        '',
                                    projectId:
                                        state.pathParameters['projectId'] ?? '',
                                    resourceKind: 'wiki',
                                  ),
                              routes: [
                                GoRoute(
                                  path: 'pages/:resourceId',
                                  builder: (context, state) =>
                                      WorkspaceProjectWikiPage(
                                        workspaceId:
                                            state
                                                .pathParameters['workspaceId'] ??
                                            '',
                                        projectId:
                                            state.pathParameters['projectId'] ??
                                            '',
                                        resourceId:
                                            state
                                                .pathParameters['resourceId'] ??
                                            '',
                                      ),
                                ),
                              ],
                            ),
                            GoRoute(
                              path: 'files',
                              builder: (context, state) => StorageShellPage(
                                initialScope: StorageScope.project(
                                  workspaceId:
                                      state.pathParameters['workspaceId'] ?? '',
                                  projectId:
                                      state.pathParameters['projectId'] ?? '',
                                  folderId: state.uri.queryParameters['folder'],
                                ),
                              ),
                              routes: [
                                GoRoute(
                                  path: ':resourceId',
                                  builder: (context, state) =>
                                      WorkspaceProjectResourcePage(
                                        workspaceId:
                                            state
                                                .pathParameters['workspaceId'] ??
                                            '',
                                        projectId:
                                            state.pathParameters['projectId'] ??
                                            '',
                                        resourceKind: 'files',
                                        resourceId:
                                            state
                                                .pathParameters['resourceId'] ??
                                            '',
                                      ),
                                ),
                              ],
                            ),
                            GoRoute(
                              path: 'automations',
                              builder: (context, state) =>
                                  WorkspaceProjectSectionPage(
                                    workspaceId:
                                        state.pathParameters['workspaceId'] ??
                                        '',
                                    projectId:
                                        state.pathParameters['projectId'] ?? '',
                                    resourceKind: 'automations',
                                  ),
                            ),
                            GoRoute(
                              path: 'members',
                              builder: (context, state) =>
                                  WorkspaceProjectSectionPage(
                                    workspaceId:
                                        state.pathParameters['workspaceId'] ??
                                        '',
                                    projectId:
                                        state.pathParameters['projectId'] ?? '',
                                    resourceKind: 'members',
                                  ),
                            ),
                            GoRoute(
                              path: 'settings',
                              builder: (context, state) =>
                                  WorkspaceProjectSectionPage(
                                    workspaceId:
                                        state.pathParameters['workspaceId'] ??
                                        '',
                                    projectId:
                                        state.pathParameters['projectId'] ?? '',
                                    resourceKind: 'settings',
                                  ),
                            ),
                            GoRoute(
                              path: 'corkboard',
                              builder: (context, state) =>
                                  WorkspaceProjectSectionPage(
                                    workspaceId:
                                        state.pathParameters['workspaceId'] ??
                                        '',
                                    projectId:
                                        state.pathParameters['projectId'] ?? '',
                                    resourceKind: 'corkboard',
                                  ),
                            ),
                            GoRoute(
                              path: 'dashboard',
                              builder: (context, state) =>
                                  WorkspaceProjectSectionPage(
                                    workspaceId:
                                        state.pathParameters['workspaceId'] ??
                                        '',
                                    projectId:
                                        state.pathParameters['projectId'] ?? '',
                                    resourceKind: 'dashboard',
                                  ),
                            ),
                            GoRoute(
                              path: ':resourceKind',
                              builder: (context, state) =>
                                  WorkspaceProjectSectionPage(
                                    workspaceId:
                                        state.pathParameters['workspaceId'] ??
                                        '',
                                    projectId:
                                        state.pathParameters['projectId'] ?? '',
                                    resourceKind:
                                        state.pathParameters['resourceKind'] ??
                                        '',
                                  ),
                            ),
                            GoRoute(
                              path: ':resourceKind/:resourceId',
                              builder: (context, state) =>
                                  WorkspaceProjectResourcePage(
                                    workspaceId:
                                        state.pathParameters['workspaceId'] ??
                                        '',
                                    projectId:
                                        state.pathParameters['projectId'] ?? '',
                                    resourceKind:
                                        state.pathParameters['resourceKind'] ??
                                        '',
                                    resourceId:
                                        state.pathParameters['resourceId'] ??
                                        '',
                                  ),
                            ),
                          ],
                        ),
                        GoRoute(
                          path: 'okr/:resourceType/:resourceId',
                          builder: (context, state) => WorkspaceOkrResourcePage(
                            workspaceId:
                                state.pathParameters['workspaceId'] ?? '',
                            resourceType:
                                state.pathParameters['resourceType'] ?? '',
                            resourceId:
                                state.pathParameters['resourceId'] ?? '',
                          ),
                        ),
                        GoRoute(
                          path: 'wiki/pages/:resourceId',
                          builder: (context, state) =>
                              WorkspaceWikiResourcePage(
                                workspaceId:
                                    state.pathParameters['workspaceId'] ?? '',
                                resourceId:
                                    state.pathParameters['resourceId'] ?? '',
                              ),
                        ),
                        GoRoute(
                          path: 'invitations/:resourceId',
                          builder: (context, state) =>
                              WorkspaceInvitationResourcePage(
                                workspaceId:
                                    state.pathParameters['workspaceId'] ?? '',
                                resourceId:
                                    state.pathParameters['resourceId'] ?? '',
                              ),
                        ),
                        GoRoute(
                          path: 'files',
                          builder: (context, state) => StorageShellPage(
                            initialScope: StorageScope.workspace(
                              state.pathParameters['workspaceId'] ?? '',
                              folderId: state.uri.queryParameters['folder'],
                            ),
                          ),
                        ),
                        GoRoute(
                          path: ':section',
                          builder: (context, state) =>
                              WorkspaceDynamicSectionPage(
                                workspaceId:
                                    state.pathParameters['workspaceId'] ?? '',
                                section: state.pathParameters['section'] ?? '',
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            GoRoute(
              path: '/me/:section',
              builder: (context, state) => PersonalSectionPage(
                section: state.pathParameters['section'] ?? '',
                initialStorageScope: StorageScopeRouteCodec.fromPersonalUri(
                  state.uri,
                ),
              ),
            ),
            GoRoute(
              path: AppRoutePaths.inne,
              builder: (context, state) => const InneHomePage(),
            ),
            GoRoute(
              path: AppRoutePaths.frameworkComponents,
              builder: (context, state) =>
                  const FrameworkComponentsGalleryPage(),
            ),
            GoRoute(
              path: AppRoutePaths.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Rozszerzenie ułatwiające dostęp do AppRouter i nawigacji z BuildContext.
extension AppRouterBuildContextExtension on BuildContext {
  AppRouter get router => AppRouter.of(this);
  AppRouter get appRouter => AppRouter.of(this);
}
