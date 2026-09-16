import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/extensions/number_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/delete_stan_st_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/delete_stan_st_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/stock_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/stock_duplicates_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/stock_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/services/stock_filter_service.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/stock_duplicates_modal.dart';
import 'package:ready_next/features/inventory/presentation/widgets/inventory_section_placeholder_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_pagination_bar.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

part 'widgets/inventory_overview_delete_stan_st.part.dart';
part 'widgets/inventory_overview_widgets.dart';

/// Ekran sekcji "Stan ŚT".
class InventoryOverviewPage extends StatelessWidget {
  const InventoryOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StockCubit(
            repository: context.read<StockRepository>(),
            filterService: context.read<StockFilterService>(),
          )..loadInitialData().ignore(),
        ),
        BlocProvider(
          create: (context) => StockDuplicatesCubit(
            repository: context.read<StockRepository>(),
          ),
        ),
      ],
      child: const _InventoryOverviewContent(),
    );
  }
}

/// Główna treść zakładki przeglądu stanów ŚT.
class _InventoryOverviewContent extends StatefulWidget {
  const _InventoryOverviewContent();

  @override
  State<_InventoryOverviewContent> createState() =>
      _InventoryOverviewContentState();
}

class _InventoryOverviewContentState extends State<_InventoryOverviewContent> {
  late final AppSearchTextFieldController _searchController;
  StreamSubscription<String?>? _querySubscription;
  StockFilterService? _subscribedFilterService;

  @override
  void initState() {
    super.initState();
    _searchController = AppSearchTextFieldController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindFilterService(context.read<StockFilterService>());
  }

  void _bindFilterService(StockFilterService filterService) {
    if (identical(_subscribedFilterService, filterService)) {
      return;
    }

    unawaited(_querySubscription?.cancel());
    _subscribedFilterService = filterService;
    _searchController.setQuery(filterService.currentQuery ?? '');
    _querySubscription = filterService.qStream.listen((query) {
      _searchController.setQuery(query ?? '');
    });
  }

  @override
  void dispose() {
    unawaited(_querySubscription?.cancel());
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockCubit, StockState>(
      builder: (context, state) {
        final intl = context.l10n;

        return InventorySectionPlaceholderCard(
          title: intl.inventoryOverviewTitle,
          subtitle: intl.inventoryOverviewSubtitle,
          actions: [
            const _FirmaFilter(),
            const _StatusFilter(),
            AppSearchTextField(
              controller: _searchController,
              width: 220,
              inlineLabel: intl.inventorySearch,
              hintText: intl.inventoryOverviewSearchHintGlobal,
              onChanged: (q) => context.read<StockFilterService>().setQuery(q),
            ),
            AppActionButton.outlined(
              label: intl.inventoryDuplicateConflictsRetryLabel,
              icon: Icons.warning_amber_rounded,
              tone: AppActionButtonTone.danger,
              onPressed: () => _openDuplicatesModal(context),
            ),
            AppActionPill(
              label: intl.inventoryRefresh,
              icon: Icons.refresh_rounded,
              tone: AppActionPillTone.contrast,
              selected: true,
              onPressed: () => context.read<StockFilterService>().refresh(),
            ),
          ],
          child: switch (state) {
            StockInitial() ||
            StockLoading() => const Center(child: AppSpinner()),
            StockSuccess(:final data) => _StockList(data: data),
            StockError(:final message) => Center(
              child: AppEmptyState.error(
                title: intl.inventoryLoadingErrorTitle,
                message: message,
              ),
            ),
          },
        );
      },
    );
  }

  Future<void> _openDuplicatesModal(BuildContext context) async {
    await showStockDuplicatesModal(
      context,
      cubit: context.read<StockDuplicatesCubit>(),
    );
  }
}
