import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:printing/printing.dart';
import 'package:ready_next/app/shell/overlay/app_modal_picker_host.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/extensions/number_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_element_nrewid_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_elementy_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/cubit/arkusz_preview_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_detail_pdf_export.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_element_status_ui.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/change_item/change_item_export.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/add_arkusz_element_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/add_arkusz_element_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/arkusz_pdf_export_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/delete_arkusz_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/delete_arkusz_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_dates_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_dates_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/edit_commission/cubit/edit_commission_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/edit_commission/edit_commission_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/widgets/inventory_person_suggestion_field.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/widgets/inventory_register_number_suggestion_field.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_date_picker_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

part 'arkusz_detail_modal_content.part.dart';
part 'arkusz_detail_modal_elements.part.dart';
part 'arkusz_detail_modal_header.part.dart';
part 'arkusz_detail_modal_management.part.dart';
part 'arkusz_detail_modal_actions.part.dart';
part 'arkusz_detail_modal_add_item.part.dart';
part 'arkusz_detail_modal_export.part.dart';
part 'arkusz_detail_modal_statuses.part.dart';
part 'arkusz_detail_modal_table.part.dart';

/// Otwiera pelnoekranowy widok szczegolow pojedynczego arkusza.
Future<void> showArkuszDetailModal(
  BuildContext context, {
  required int arkuszId,
  required String arkuszNumber,
  required List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies,
  required bool canDeleteArkusz,
  required bool canEditArkusz,
  required InventoriesRepository inventoriesRepository,
  required LocationsRepository locationsRepository,
  required StockRepository stockRepository,
  required UsersRepository usersRepository,
  int? initialHighlightElementId,
  VoidCallback? onDataChanged,
}) async {
  await Navigator.of(context).push<void>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => BlocProvider(
        create: (_) =>
            ArkuszPreviewCubit(repository: inventoriesRepository)
              ..load(arkuszId).ignore(),
        child: _ArkuszDetailPage(
          arkuszId: arkuszId,
          arkuszNumber: arkuszNumber,
          inventoryCompanies: inventoryCompanies,
          canDeleteArkusz: canDeleteArkusz,
          canEditArkusz: canEditArkusz,
          inventoriesRepository: inventoriesRepository,
          locationsRepository: locationsRepository,
          stockRepository: stockRepository,
          usersRepository: usersRepository,
          initialHighlightElementId: initialHighlightElementId,
          onDataChanged: onDataChanged,
        ),
      ),
    ),
  );
}
