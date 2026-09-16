import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/extensions/number_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_element_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_element_status_ui.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/change_item/change_item_form_logic.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/change_item/cubit/change_item_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/change_item/cubit/change_item_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/create_arkusz_tree_utils.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/delete_arkusz_element_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/delete_arkusz_element_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/widgets/inventory_person_suggestion_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';
import 'package:ready_next/shared/presentation/widgets/app_tree.dart';

part 'widgets/change_item_modal_body.part.dart';
part 'widgets/change_item_modal_company.part.dart';
part 'widgets/change_item_modal_delete.part.dart';
part 'widgets/change_item_modal_location.part.dart';
part 'widgets/change_item_modal_location_tree.part.dart';
part 'widgets/change_item_modal_preview.part.dart';
part 'widgets/change_item_modal_shell.part.dart';
part 'widgets/change_item_modal_support.part.dart';

/// Otwiera modal edycji pojedynczego elementu arkusza.
Future<bool?> showChangeItemModal(
  BuildContext context, {
  required int arkuszId,
  required List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies,
  required GetArkuszDetailsElementItem item,
  required InventoriesRepository inventoriesRepository,
  required LocationsRepository locationsRepository,
  required StockRepository stockRepository,
  required UsersRepository usersRepository,
}) async {
  final intl = context.l10n;
  final bodyKey = GlobalKey<_ChangeItemBodyState>();
  final rootContext = Navigator.of(context, rootNavigator: true).context;
  final viewportWidth = MediaQuery.sizeOf(rootContext).width;
  final sideSheetWidth = (viewportWidth * .98).clamp(1240.0, 3200.0);
  final elementArkuszId = item.idarkuszSpisu ?? arkuszId;
  final cubit = ChangeItemCubit(
    repository: inventoriesRepository,
    arkuszId: elementArkuszId,
    elementId: item.id,
  );

  try {
    return await AppModalSheet.showSideSheet<bool>(
      context,
      title: intl.inventoryEditSheetItemTitle,
      subtitle: intl.inventoryEditSheetItemSubtitle(
        _displayValue(item.nazwa),
        _displayValue(item.nrewid),
        _displayValue(item.kodKreskowy?.toString()),
      ),
      width: sideSheetWidth,
      minBodyHeight: 720,
      body: BlocProvider.value(
        value: cubit,
        child: _ChangeItemBody(
          key: bodyKey,
          item: item,
          inventoryCompanies: inventoryCompanies,
          locationsRepository: locationsRepository,
          stockRepository: stockRepository,
          usersRepository: usersRepository,
        ),
      ),
      footer: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<ChangeItemCubit, ChangeItemState>(
          builder: (context, state) {
            final isSending = state is ChangeItemSending;
            return Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: intl.delete,
                  icon: Icons.delete_outline_rounded,
                  tone: .danger,
                  onPressed: isSending
                      ? null
                      : () {
                          (() async {
                            final deleted = await _showDeleteArkuszElementModal(
                              context,
                              arkuszId: elementArkuszId,
                              item: item,
                              repository: inventoriesRepository,
                            );
                            if (context.mounted && deleted == true) {
                              Navigator.of(context).pop(true);
                            }
                          })().ignore();
                        },
                ),
                Gaps.w8,
                AppActionButton.text(
                  label: intl.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isSending
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: intl.save,
                  icon: Icons.check_rounded,
                  onPressed: isSending
                      ? null
                      : () => bodyKey.currentState?._onSubmit(),
                ),
              ],
            );
          },
        ),
      ),
    );
  } finally {
    await cubit.close();
  }
}
