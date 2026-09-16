import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/companies_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/companies_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/delete_company_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/delete_company_state.dart';
import 'package:ready_next/features/inventory/presentation/widgets/inventory_section_placeholder_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_compact_list_tile.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_icon.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

part 'widgets/inventory_companies_widgets.dart';

/// Ekran sekcji "Firmy".
class InventoryCompaniesPage extends StatelessWidget {
  /// Tworzy ekran sekcji "Firmy".
  const InventoryCompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompaniesCubit(
        repository: context.read<StockRepository>(),
      )..load().ignore(),
      child: const _InventoryCompaniesContent(),
    );
  }
}

class _InventoryCompaniesContent extends StatelessWidget {
  const _InventoryCompaniesContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompaniesCubit, CompaniesState>(
      builder: (context, state) {
        final cubit = context.read<CompaniesCubit>();
        final intl = context.l10n;

        return InventorySectionPlaceholderCard(
          title: intl.inventoryCompaniesTitle,
          subtitle: intl.inventoryCompaniesSubtitle,
          actions: [
            AppActionPill(
              label: intl.inventoryRefresh,
              icon: Icons.refresh_rounded,
              tone: AppActionPillTone.contrast,
              selected: true,
              onPressed: () => unawaited(cubit.load(forceRefresh: true)),
            ),
          ],
          child: switch (state) {
            CompaniesInitial() ||
            CompaniesLoading() => const Center(child: AppSpinner()),
            CompaniesSuccess(:final companies) => _CompaniesList(
              companies: companies,
            ),
            CompaniesError(:final message) => Center(
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
}
