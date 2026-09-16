import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/cubit/snapshot_regeneration_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/services/stock_filter_service.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_module_layout.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_module_top_bar.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_side_menu_panel.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';

enum InventorySection {
  inventories(icon: Icons.fact_check_outlined, path: AppRoutePaths.inventory),
  stanSt(icon: Icons.inventory_2_outlined, path: AppRoutePaths.inventoryStock),
  miejsca(icon: Icons.place_outlined, path: AppRoutePaths.inventoryOverview),
  firmy(icon: Icons.business_outlined, path: '/inventory/companies');

  const InventorySection({required this.icon, required this.path});

  final IconData icon;
  final String path;
}

class InventoryHomePage extends StatelessWidget {
  const InventoryHomePage({required this.child, super.key});

  final Widget child;

  InventorySection _sectionForPath(String path) {
    if (path.startsWith(AppRoutePaths.inventoryStock)) return InventorySection.stanSt;
    if (path.startsWith(AppRoutePaths.inventoryOverview)) return InventorySection.miejsca;
    if (path.startsWith('/inventory/companies')) return InventorySection.firmy;
    return InventorySection.inventories;
  }

  List<AppSideMenuSection> _buildMenuSections(
    BuildContext context,
    InventorySection activeSection,
  ) {
    final intl = context.l10n;
    final specs = <AppSideMenuSectionSpec>[
      AppSideMenuSectionSpec.simple(
        title: intl.inventoryModuleTitle,
        items: [
          AppSideMenuEntrySpec.route(
            label: intl.inventorySectionInventories,
            icon: Icons.fact_check_outlined,
            isSelected: activeSection == InventorySection.inventories,
            onTap: (ctx) => context.go(InventorySection.inventories.path),
          ),
          AppSideMenuEntrySpec.route(
            label: intl.inventorySectionAssetState,
            icon: Icons.inventory_2_outlined,
            isSelected: activeSection == InventorySection.stanSt,
            onTap: (ctx) => context.go(InventorySection.stanSt.path),
          ),
          AppSideMenuEntrySpec.route(
            label: intl.inventorySectionLocations,
            icon: Icons.place_outlined,
            isSelected: activeSection == InventorySection.miejsca,
            onTap: (ctx) => context.go(InventorySection.miejsca.path),
          ),
          AppSideMenuEntrySpec.route(
            label: intl.inventorySectionCompanies,
            icon: Icons.business_outlined,
            isSelected: activeSection == InventorySection.firmy,
            onTap: (ctx) => context.go(InventorySection.firmy.path),
          ),
        ],
      ),
    ];

    return buildSideMenuSectionsFromSpecs(context, specs, _showTopActionHint);
  }

  void _showTopActionHint(BuildContext context, String label) {
    final intl = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(intl.inventoryActionNotConnected(label))),
    );
  }

  String _sectionLabel(BuildContext context, InventorySection section) {
    final intl = context.l10n;
    return switch (section) {
      InventorySection.inventories => intl.inventorySectionInventories,
      InventorySection.stanSt => intl.inventorySectionAssetState,
      InventorySection.miejsca => intl.inventorySectionLocations,
      InventorySection.firmy => intl.inventorySectionCompanies,
    };
  }

  Future<void> _requestSnapshotRegeneration(BuildContext context) async {
    final intl = context.l10n;
    final confirmed = await _showSnapshotRegenerationConfirmModal(context);

    if (!confirmed || !context.mounted) {
      return;
    }

    final regenerationCubit = SnapshotRegenerationCubit(
      repository: context.read<InventoriesRepository>(),
    )..regenerate().ignore();

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return BlocProvider.value(
            value: regenerationCubit,
            child:
                BlocBuilder<
                  SnapshotRegenerationCubit,
                  SnapshotRegenerationState
                >(
                  builder: (context, state) {
                    final isLoading = switch (state) {
                      SnapshotRegenerationInitial() ||
                      SnapshotRegenerationInProgress() => true,
                      _ => false,
                    };

                    return AppModalSheet(
                      title: intl.inventorySnapshotRefreshTitle,
                      subtitle: intl.inventorySnapshotRefreshSubtitle,
                      size: AppModalSheetSize.small,
                      isBusy: isLoading,
                      canClose: !isLoading,
                      showCloseButton: !isLoading,
                      body: const _SnapshotRegenerationModalBody(),
                    );
                  },
                ),
          );
        },
      );
    } finally {
      await regenerationCubit.close();
    }
  }

  Future<bool> _showSnapshotRegenerationConfirmModal(
    BuildContext context,
  ) async {
    final intl = context.l10n;
    final result = await AppModalSheet.show<bool>(
      context,
      title: intl.inventorySnapshotRefreshConfirmTitle,
      subtitle: intl.inventorySnapshotRefreshConfirmSubtitle,
      size: AppModalSheetSize.small,
      body: const _SnapshotRegenerationConfirmModalBody(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<InventoryApi>(
          create: (context) => InventoryApi(context.read<Dio>()),
        ),
        RepositoryProvider<InventoriesRepository>(
          create: (context) =>
              InventoriesRepositoryImpl(api: context.read<InventoryApi>()),
        ),
        RepositoryProvider<StockRepository>(
          create: (context) =>
              StockRepositoryImpl(api: context.read<InventoryApi>()),
        ),
        RepositoryProvider<LocationsRepository>(
          create: (context) =>
              LocationsRepositoryImpl(api: context.read<InventoryApi>()),
        ),
        RepositoryProvider<UsersRepository>(
          create: (context) =>
              UsersRepositoryImpl(api: context.read<InventoryApi>()),
        ),
        RepositoryProvider<StockFilterService>(
          create: (context) => StockFilterService(),
          dispose: (service) => service.dispose(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final currentPath = GoRouterState.of(context).uri.path;
          final activeSection = _sectionForPath(currentPath);

          return Scaffold(
            body: AppModuleLayout(
              topBar: AppModuleTopBar(
                title: context.l10n.inventoryModuleTitle,
                subtitle: _sectionLabel(context, activeSection),
                actions: [
                  if (activeSection == InventorySection.inventories)
                    FilledButton.icon(
                      onPressed: () => _requestSnapshotRegeneration(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colors.secondary,
                        foregroundColor: context.colors.onSecondary,
                        visualDensity: .compact,
                      ),
                      icon: const Icon(Icons.sync_rounded),
                      label: Text(context.l10n.inventorySnapshotRefreshButton),
                    ),
                ],
                height: 40,
                horizontalPadding: 22,
                showBottomBorder: true,
                backgroundColor: Colors.transparent,
              ),
              showSidebarDivider: false,
              scrollContent: false,
              compactOuterPadding: Sizes.p16,
              regularOuterPadding: Sizes.p20,
              contentLeadingInset: Sizes.p20,
              contentMaxWidth: 1800,
              sidebarBuilder: (context, isCompact, outerPadding) {
                final textScale = MediaQuery.textScalerOf(context).scale(1);
                final clampedScale = textScale.clamp(1.0, 1.3);
                final baseSidebarWidth = isCompact ? 156.0 : 236.0;
                final sidebarWidth = baseSidebarWidth * clampedScale;

                return AppSideMenuPanel(
                  primaryIcon: activeSection.icon,
                  title: context.l10n.inventoryModuleTitle,
                  subtitle: context.l10n.inventorySidebarSubtitle,
                  width: sidebarWidth,
                  margin: EdgeInsets.zero,
                  flat: true,
                  showBorder: false,
                  menuSections: _buildMenuSections(context, activeSection),
                );
              },
              contentBuilder: (context, isCompact, outerPadding) => child,
            ),
          );
        },
      ),
    );
  }
}

/// Body modalu potwierdzenia odswiezenia snapshotu.
class _SnapshotRegenerationConfirmModalBody extends StatefulWidget {
  /// Tworzy body modalu potwierdzajacego.
  const _SnapshotRegenerationConfirmModalBody();

  @override
  State<_SnapshotRegenerationConfirmModalBody> createState() =>
      _SnapshotRegenerationConfirmModalBodyState();
}

/// Stan modalu potwierdzenia odswiezenia snapshotu.
class _SnapshotRegenerationConfirmModalBodyState
    extends State<_SnapshotRegenerationConfirmModalBody> {
  static const _unlockPhrase = 'Excellent';
  final TextEditingController _confirmationController = TextEditingController();

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;
    final isUnlocked = _confirmationController.text.trim() == _unlockPhrase;

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Container(
          width: double.infinity,
          padding: const .all(Sizes.p16),
          decoration: BoxDecoration(
            color: colors.errorContainer.withValues(alpha: .68),
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            border: Border.all(color: colors.error.withValues(alpha: .24)),
          ),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              Icon(
                Icons.delete_forever_rounded,
                color: colors.error,
                size: Sizes.p20,
              ),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppText(
                      intl.inventorySnapshotRefreshTitle,
                      style: context.text.titleSmall?.copyWith(
                        color: colors.onErrorContainer,
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h8,
                    AppText(
                      intl.inventorySnapshotRefreshConfirmQuestion,
                      style: context.text.bodyMedium?.copyWith(
                        color: colors.onErrorContainer,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gaps.h12,
        AppTextField(
          controller: _confirmationController,
          labelText: intl.inventorySnapshotRefreshUnlockLabel,
          hintText: intl.inventorySnapshotRefreshUnlockHint,
          onChanged: (_) => setState(() {}),
        ),
        Gaps.h16,
        Row(
          mainAxisAlignment: .end,
          children: [
            AppActionButton.text(
              label: intl.cancel,
              icon: Icons.close_rounded,
              tone: .neutral,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            Gaps.w8,
            AppActionButton.filled(
              label: intl.inventorySnapshotRefreshAction,
              icon: Icons.sync_rounded,
              tone: .neutral,
              onPressed: isUnlocked
                  ? () => Navigator.of(context).pop(true)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

/// Body modalu postepu i wyniku regeneracji snapshotu.
class _SnapshotRegenerationModalBody extends StatelessWidget {
  /// Tworzy body modalu regeneracji snapshotu.
  const _SnapshotRegenerationModalBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.l10n;

    return BlocBuilder<SnapshotRegenerationCubit, SnapshotRegenerationState>(
      builder: (context, state) {
        final (title, message, isLoading, isSuccess) = switch (state) {
          SnapshotRegenerationInitial() || SnapshotRegenerationInProgress() => (
            intl.inventorySnapshotRefreshInProgressTitle,
            intl.inventorySnapshotRefreshInProgressMessage,
            true,
            false,
          ),
          SnapshotRegenerationBlockedByActiveInventory() => (
            intl.inventorySnapshotRefreshBlockedTitle,
            intl.inventorySnapshotRefreshBlockedMessage,
            false,
            false,
          ),
          SnapshotRegenerationFailure(:final message) => (
            intl.inventorySnapshotRefreshFailureTitle,
            message,
            false,
            false,
          ),
          SnapshotRegenerationSuccess(:final okCount, :final errorCount) => (
            intl.inventorySnapshotRefreshSuccessTitle,
            intl.inventorySnapshotRefreshSuccessMessage(okCount, errorCount),
            false,
            true,
          ),
        };
        final containerColor = isSuccess
            ? colors.secondaryContainer.withValues(alpha: .68)
            : colors.errorContainer.withValues(alpha: .68);
        final borderColor = isSuccess
            ? colors.secondary.withValues(alpha: .24)
            : colors.error.withValues(alpha: .24);
        final accentColor = isSuccess ? colors.secondary : colors.error;
        final contentColor = isSuccess
            ? colors.onSecondaryContainer
            : colors.onErrorContainer;

        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Container(
              width: double.infinity,
              padding: const .all(Sizes.p16),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  if (isLoading)
                    SizedBox.square(
                      dimension: Sizes.p20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accentColor,
                      ),
                    ),
                  if (!isLoading)
                    Icon(
                      isSuccess
                          ? Icons.check_circle_outline_rounded
                          : Icons.delete_forever_rounded,
                      color: accentColor,
                      size: Sizes.p20,
                    ),
                  Gaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        AppText(
                          title,
                          style: context.text.titleSmall?.copyWith(
                            color: contentColor,
                            fontWeight: .w700,
                          ),
                        ),
                        Gaps.h8,
                        AppText(
                          message,
                          style: context.text.bodyMedium?.copyWith(
                            color: contentColor,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: intl.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: isLoading
                      ? intl.inventorySnapshotRefreshProcessingAction
                      : intl.close,
                  icon: isLoading
                      ? Icons.hourglass_top_rounded
                      : Icons.check_rounded,
                  tone: .neutral,
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
