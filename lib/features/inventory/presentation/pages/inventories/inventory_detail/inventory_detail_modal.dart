import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ready_next/app/shell/overlay/app_modal_picker_host.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_presence_conflicts_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_surplus_conflicts_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_detail_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/inventory_sheet_search_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/create_arkusz_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/close_inventory_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/close_inventory_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_detail_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_detail_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_dates_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_dates_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_numer_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_numer_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_inventory_dates_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_inventory_dates_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/edit_commission/cubit/edit_commission_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/edit_commission/edit_commission_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/inventory_detail_constants.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/inventory_presence_conflicts_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/inventory_surplus_conflicts_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/inventory_tree_progress_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_reports_export.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_compact_list_tile.dart';
import 'package:ready_next/shared/presentation/widgets/app_date_picker_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_icon.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

part 'inventory_detail_modal/widgets/inventory_detail_loaded_view.part.dart';
part 'inventory_detail_modal/widgets/inventory_detail_sheet_widgets.part.dart';
part 'inventory_detail_modal/widgets/inventory_detail_support_widgets.part.dart';

/// Otwiera modal szczegolow inwentaryzacji.
Future<void> showInventoryDetailModal(
  BuildContext context, {
  required int inventoryId,
  required String inventoryNumber,
  VoidCallback? onDataChanged,
}) async {
  final inventoriesRepository = context.read<InventoriesRepository>();
  final locationsRepository = context.read<LocationsRepository>();
  final stockRepository = context.read<StockRepository>();
  final usersRepository = context.read<UsersRepository>();
  final intl = context.l10n;
  final viewportWidth = MediaQuery.sizeOf(context).width;
  final modalWidth = viewportWidth * .95;

  await AppModalSheet.showSideSheet<void>(
    context,
    title: intl.inventoryDetailsTitle,
    subtitle: intl.inventoryNumberLabel(inventoryNumber),
    size: AppModalSheetSize.large,
    width: modalWidth,
    body: BlocProvider(
      create: (context) =>
          InventoryDetailCubit(repository: inventoriesRepository)
            ..load(inventoryId).ignore(),
      child: _InventoryDetailBody(
        inventoryId: inventoryId,
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
        stockRepository: stockRepository,
        usersRepository: usersRepository,
        onDataChanged: onDataChanged,
      ),
    ),
  );
}

/// Zawartosc modala szczegolow inwentaryzacji.
class _InventoryDetailBody extends StatelessWidget {
  /// Tworzy body modala szczegolow inwentaryzacji.
  const _InventoryDetailBody({
    required this.inventoryId,
    required this.inventoriesRepository,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    this.onDataChanged,
  });

  final int inventoryId;
  final InventoriesRepository inventoriesRepository;
  final LocationsRepository locationsRepository;
  final StockRepository stockRepository;
  final UsersRepository usersRepository;
  final VoidCallback? onDataChanged;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocBuilder<InventoryDetailCubit, InventoryDetailState>(
      builder: (context, state) {
        return switch (state) {
          InventoryDetailLoading() => const Center(
            child: Padding(
              padding: .symmetric(vertical: Sizes.p24),
              child: AppSpinner(size: Sizes.p24),
            ),
          ),
          InventoryDetailError(:final message) => AppEmptyState.error(
            title: intl.inventoryDetailsLoadErrorTitle,
            message: message,
            compact: true,
            action: AppActionPill(
              label: intl.inventoryRefresh,
              icon: Icons.refresh_rounded,
              tone: .contrast,
              selected: true,
              onPressed: () =>
                  context.read<InventoryDetailCubit>().load(inventoryId),
            ),
          ),
          InventoryDetailLoaded(:final data) => _InventoryDetailLoadedView(
            inventoryId: inventoryId,
            data: data,
            inventoriesRepository: inventoriesRepository,
            locationsRepository: locationsRepository,
            stockRepository: stockRepository,
            usersRepository: usersRepository,
            onDataChanged: onDataChanged,
          ),
        };
      },
    );
  }
}

Future<bool?> _showCloseInventoryModal(
  BuildContext context, {
  required int inventoryId,
  required String inventoryNumber,
  required InwentaryzacjaStatus? status,
  required InventoriesRepository repository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventoryCloseTitle,
    subtitle: context.l10n.inventoryCloseSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => CloseInventoryCubit(repository: repository),
      child: _CloseInventoryModalBody(
        inventoryId: inventoryId,
        inventoryNumber: inventoryNumber,
        status: status,
      ),
    ),
  );
}

Future<bool?> _showUpdateInventoryDatesModal(
  BuildContext context, {
  required int inventoryId,
  required String inventoryNumber,
  required InwentaryzacjaStatus? status,
  required String? dataOd,
  required String? dataDo,
  required String? numer,
  required String? uwagi,
  required InventoriesRepository repository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventoryEditDatesTitle,
    subtitle: context.l10n.inventoryEditDatesSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => UpdateInventoryDatesCubit(repository: repository),
      child: _UpdateInventoryDatesModalBody(
        inventoryId: inventoryId,
        inventoryNumber: inventoryNumber,
        status: status,
        dataOd: dataOd,
        dataDo: dataDo,
        numer: numer,
        uwagi: uwagi,
      ),
    ),
  );
}

/// Body modalu zamykania inwentaryzacji.
class _CloseInventoryModalBody extends StatefulWidget {
  /// Tworzy body modalu zamykania inwentaryzacji.
  const _CloseInventoryModalBody({
    required this.inventoryId,
    required this.inventoryNumber,
    required this.status,
  });

  /// Identyfikator inwentaryzacji.
  final int inventoryId;

  /// Numer inwentaryzacji pokazywany w potwierdzeniu.
  final String inventoryNumber;

  /// Aktualny status inwentaryzacji.
  final InwentaryzacjaStatus? status;

  @override
  State<_CloseInventoryModalBody> createState() =>
      _CloseInventoryModalBodyState();
}

/// Stan modalu zamykania inwentaryzacji.
class _CloseInventoryModalBodyState extends State<_CloseInventoryModalBody> {
  static const _unlockPhrase = 'Excellent';

  final TextEditingController _confirmationController = TextEditingController();
  String? _errorMessage;

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
    final isBlockedByStatus = widget.status != InwentaryzacjaStatus.wToku;

    return BlocConsumer<CloseInventoryCubit, CloseInventoryState>(
      listener: (context, state) {
        switch (state) {
          case CloseInventorySuccess():
            Navigator.of(context).pop(true);
          case CloseInventoryBlocked():
            setState(() {
              _errorMessage = intl.inventoryCloseBlockedStatusMessage;
            });
          case CloseInventoryError(:final message):
            setState(() {
              _errorMessage = message;
            });
          case CloseInventoryInitial():
          case CloseInventorySubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is CloseInventorySubmitting;

        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            Container(
              width: double.infinity,
              padding: const .all(Sizes.p16),
              decoration: BoxDecoration(
                color: colors.tertiaryContainer.withValues(alpha: .68),
                borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
                border: Border.all(
                  color: colors.tertiary.withValues(alpha: .24),
                ),
              ),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    color: colors.tertiary,
                    size: Sizes.p20,
                  ),
                  Gaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        AppText(
                          intl.inventoryCloseConfirmTitle,
                          style: context.text.titleSmall?.copyWith(
                            color: colors.onTertiaryContainer,
                            fontWeight: .w700,
                          ),
                        ),
                        Gaps.h8,
                        AppText(
                          intl.inventoryCloseConfirmBody(
                            widget.inventoryNumber,
                            widget.inventoryId,
                          ),
                          style: context.text.bodyMedium?.copyWith(
                            color: colors.onTertiaryContainer,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_errorMessage case final String message) ...[
              Gaps.h12,
              AppText(
                message,
                style: context.text.bodySmall?.copyWith(
                  color: colors.error,
                  fontWeight: .w600,
                ),
              ),
            ],
            Gaps.h12,
            AppTextField(
              controller: _confirmationController,
              enabled: !isSubmitting && !isBlockedByStatus,
              labelText: intl.inventoryCloseUnlockLabel,
              hintText: intl.inventoryCloseUnlockHint,
              onChanged: (_) => setState(() {
                _errorMessage = null;
              }),
            ),
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: intl.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: intl.inventoryCloseTitle,
                  icon: Icons.task_alt_rounded,
                  onPressedAsync:
                      isSubmitting || !isUnlocked || isBlockedByStatus
                      ? null
                      : () async => context.read<CloseInventoryCubit>().submit(
                          inventoryId: widget.inventoryId,
                          status: widget.status,
                        ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Formularz edycji zakresu dat aktywnej inwentaryzacji.
class _UpdateInventoryDatesModalBody extends StatefulWidget {
  const _UpdateInventoryDatesModalBody({
    required this.inventoryId,
    required this.inventoryNumber,
    required this.status,
    required this.dataOd,
    required this.dataDo,
    required this.numer,
    required this.uwagi,
  });

  final int inventoryId;
  final String inventoryNumber;
  final InwentaryzacjaStatus? status;
  final String? dataOd;
  final String? dataDo;
  final String? numer;
  final String? uwagi;

  @override
  State<_UpdateInventoryDatesModalBody> createState() =>
      _UpdateInventoryDatesModalBodyState();
}

/// Stan formularza edycji zakresu dat inwentaryzacji.
class _UpdateInventoryDatesModalBodyState
    extends State<_UpdateInventoryDatesModalBody> {
  late DateTime? _selectedStartDate;
  late DateTime? _selectedEndDate;
  String? _errorMessage;

  DateTime get _firstDate => DateTime(2000);
  DateTime get _lastDate => DateTime(2100, 12, 31);

  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime.tryParse(widget.dataOd ?? '');
    _selectedEndDate = DateTime.tryParse(widget.dataDo ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isBlockedByStatus = widget.status == InwentaryzacjaStatus.zakonczona;

    return BlocConsumer<UpdateInventoryDatesCubit, UpdateInventoryDatesState>(
      listener: (context, state) {
        switch (state) {
          case UpdateInventoryDatesSuccess():
            Navigator.of(context).pop(true);
          case UpdateInventoryDatesError(:final message):
            setState(() {
              _errorMessage = message;
            });
          case UpdateInventoryDatesInitial():
          case UpdateInventoryDatesSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is UpdateInventoryDatesSubmitting;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              context.l10n.inventorySearchSheetsSubtitle(
                widget.inventoryNumber,
              ),
              style: context.text.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (_errorMessage case final String message) ...[
              Gaps.h12,
              AppText(
                message,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            Gaps.h12,
            AppDatePickerField(
              value: _selectedStartDate,
              firstDate: _firstDate,
              lastDate: _lastDate,
              enabled: !isSubmitting && !isBlockedByStatus,
              allowClear: false,
              variant: AppDateFieldVariant.filled,
              labelText: context.l10n.inventoryStartDateLabel,
              onChanged: (value) {
                setState(() {
                  _selectedStartDate = value;
                  _errorMessage = null;
                });
              },
            ),
            Gaps.h12,
            AppDatePickerField(
              value: _selectedEndDate,
              firstDate: _firstDate,
              lastDate: _lastDate,
              enabled: !isSubmitting && !isBlockedByStatus,
              variant: AppDateFieldVariant.filled,
              labelText: context.l10n.inventoryEndDateLabel,
              onChanged: (value) {
                setState(() {
                  _selectedEndDate = value;
                  _errorMessage = null;
                });
              },
            ),
            Gaps.h16,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppActionButton.text(
                  label: context.l10n.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: context.l10n.save,
                  icon: Icons.save_rounded,
                  onPressedAsync: isSubmitting || isBlockedByStatus
                      ? null
                      : () async {
                          final startDate = _selectedStartDate;
                          final endDate = _selectedEndDate;
                          if (startDate == null) {
                            setState(() {
                              _errorMessage =
                                  context.l10n.inventoryStartDateRequiredError;
                            });
                            return;
                          }
                          if (endDate != null && endDate.isBefore(startDate)) {
                            setState(() {
                              _errorMessage =
                                  context.l10n.inventoryEndDateBeforeStartError;
                            });
                            return;
                          }

                          await context
                              .read<UpdateInventoryDatesCubit>()
                              .submit(
                                inventoryId: widget.inventoryId,
                                query: PatchInwentaryzacjaRequest(
                                  dataOd: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(startDate),
                                  dataDo: endDate == null
                                      ? null
                                      : DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(endDate),
                                  numer: widget.numer,
                                  uwagi: widget.uwagi,
                                ),
                              );
                        },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Future<bool?> _showUpdateArkuszDatesModal(
  BuildContext context, {
  required int arkuszId,
  required String? startDateTime,
  required String? endDateTime,
  required InventoriesRepository repository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventoryEditSheetDatesTitle,
    subtitle: context.l10n.inventoryEditSheetDatesSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => UpdateArkuszDatesCubit(repository: repository),
      child: _InventoryDetailUpdateArkuszDatesModalBody(
        arkuszId: arkuszId,
        initialStartDateTime: startDateTime,
        initialEndDateTime: endDateTime,
      ),
    ),
  );
}

Future<bool?> _showUpdateArkuszNumerModal(
  BuildContext context, {
  required int arkuszId,
  required String? initialNumer,
  required InventoriesRepository repository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventoryNumber,
    subtitle: context.l10n.inventorySheetLabel,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => UpdateArkuszNumerCubit(repository: repository),
      child: _InventoryDetailUpdateArkuszNumerModalBody(
        arkuszId: arkuszId,
        initialNumer: initialNumer,
      ),
    ),
  );
}

/// Body modalu szybkiej edycji numeru arkusza z listy arkuszy.
class _InventoryDetailUpdateArkuszNumerModalBody extends StatefulWidget {
  /// Tworzy body modalu szybkiej edycji numeru arkusza.
  const _InventoryDetailUpdateArkuszNumerModalBody({
    required this.arkuszId,
    required this.initialNumer,
  });

  /// Identyfikator arkusza zapisywanego do backendu.
  final int arkuszId;

  /// Poczatkowy numer arkusza.
  final String? initialNumer;

  @override
  State<_InventoryDetailUpdateArkuszNumerModalBody> createState() =>
      _InventoryDetailUpdateArkuszNumerModalBodyState();
}

/// Stan modalu szybkiej edycji numeru arkusza.
class _InventoryDetailUpdateArkuszNumerModalBodyState
    extends State<_InventoryDetailUpdateArkuszNumerModalBody> {
  late final TextEditingController _numerController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _numerController = TextEditingController(
      text: (widget.initialNumer ?? '').trim(),
    );
  }

  @override
  void dispose() {
    _numerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocConsumer<UpdateArkuszNumerCubit, UpdateArkuszNumerState>(
      listener: (context, state) {
        switch (state) {
          case UpdateArkuszNumerSuccess():
            Navigator.of(context).pop(true);
          case UpdateArkuszNumerError(:final message):
            setState(() {
              _errorMessage = message;
            });
          case UpdateArkuszNumerInitial():
          case UpdateArkuszNumerSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is UpdateArkuszNumerSubmitting;
        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            AppTextField(
              controller: _numerController,
              enabled: !isSubmitting,
              isRequired: true,
              labelText: intl.inventoryNumber,
              hintText: intl.inventoryNumberExampleHint,
              maxLength: inventoryArkuszNumerMaxLength,
              errorText: _errorMessage,
              onChanged: (_) {
                if (_errorMessage == null) {
                  return;
                }
                setState(() => _errorMessage = null);
              },
            ),
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: intl.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: intl.save,
                  icon: Icons.check_rounded,
                  onPressedAsync: isSubmitting ? null : _submit,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    final intl = context.l10n;
    final numer = _numerController.text.trim();
    if (numer.isEmpty) {
      setState(() => _errorMessage = intl.inventoryNumberRequired);
      return;
    }

    await context.read<UpdateArkuszNumerCubit>().submit(
      arkuszId: widget.arkuszId,
      numer: numer,
    );
  }
}

/// Body modalu szybkiej edycji dat arkusza z listy arkuszy.
class _InventoryDetailUpdateArkuszDatesModalBody extends StatefulWidget {
  /// Tworzy body modalu szybkiej edycji dat arkusza.
  const _InventoryDetailUpdateArkuszDatesModalBody({
    required this.arkuszId,
    required this.initialStartDateTime,
    required this.initialEndDateTime,
  });

  /// Identyfikator arkusza zapisywanego do backendu.
  final int arkuszId;

  /// Poczatkowa data rozpoczecia wraz z czasem.
  final String? initialStartDateTime;

  /// Poczatkowa data zakonczenia wraz z czasem.
  final String? initialEndDateTime;

  @override
  State<_InventoryDetailUpdateArkuszDatesModalBody> createState() =>
      _InventoryDetailUpdateArkuszDatesModalBodyState();
}

/// Stan modalu szybkiej edycji dat arkusza.
class _InventoryDetailUpdateArkuszDatesModalBodyState
    extends State<_InventoryDetailUpdateArkuszDatesModalBody> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String? _errorMessage;

  DateTime get _firstDate {
    return DateTime(2000);
  }

  DateTime get _lastDate => DateTime(2100, 12, 31);

  @override
  void initState() {
    super.initState();
    _startDate = _tryParseDate(widget.initialStartDateTime);
    _endDate = _tryParseDate(widget.initialEndDateTime);
    _startTime = _timeFromDateTime(
      _startDate ?? DateTime.now(),
      fallback: const TimeOfDay(hour: 8, minute: 0),
    );
    _endTime = _timeFromDateTime(
      _endDate ?? _startDate ?? DateTime.now(),
      fallback: const TimeOfDay(hour: 16, minute: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateArkuszDatesCubit, UpdateArkuszDatesState>(
      listener: (context, state) {
        switch (state) {
          case UpdateArkuszDatesSuccess():
            Navigator.of(context).pop(true);
          case UpdateArkuszDatesError(:final message):
            setState(() {
              _errorMessage = message;
            });
          case UpdateArkuszDatesInitial():
          case UpdateArkuszDatesSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is UpdateArkuszDatesSubmitting;

        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            AppDatePickerField(
              value: _startDate,
              firstDate: _firstDate,
              lastDate: _lastDate,
              enabled: !isSubmitting,
              allowClear: false,
              variant: AppDateFieldVariant.filled,
              labelText: context.l10n.inventoryStartDateLabel,
              helperText: context.l10n.inventoryStartDateHelper,
              onChanged: (value) {
                setState(() {
                  _startDate = value;
                  _errorMessage = null;
                });
              },
            ),
            Gaps.h12,
            _ArkuszTimePickerField(
              label: context.l10n.inventoryStartTimeLabel,
              value: _startTime,
              enabled: !isSubmitting,
              onTap: () async {
                final selected = await AppModalPickerHost.showTime(
                  context,
                  initialTime: _startTime,
                );
                if (selected == null || !context.mounted) {
                  return;
                }
                setState(() {
                  _startTime = selected;
                  _errorMessage = null;
                });
              },
            ),
            Gaps.h12,
            AppDatePickerField(
              value: _endDate,
              firstDate: _firstDate,
              lastDate: _lastDate,
              enabled: !isSubmitting,
              variant: AppDateFieldVariant.filled,
              labelText: context.l10n.inventoryEndDateLabel,
              helperText: context.l10n.inventoryEndDateHelper,
              onChanged: (value) {
                setState(() {
                  _endDate = value;
                  _errorMessage = null;
                });
              },
            ),
            Gaps.h12,
            _ArkuszTimePickerField(
              label: context.l10n.inventoryEndTimeLabel,
              value: _endTime,
              enabled: !isSubmitting,
              onTap: () async {
                final selected = await AppModalPickerHost.showTime(
                  context,
                  initialTime: _endTime,
                );
                if (selected == null || !context.mounted) {
                  return;
                }
                setState(() {
                  _endTime = selected;
                  _errorMessage = null;
                });
              },
            ),
            if (_errorMessage case final String message
                when message.trim().isNotEmpty) ...[
              Gaps.h12,
              AppText(
                message,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                  fontWeight: .w600,
                ),
              ),
            ],
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: context.l10n.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: context.l10n.save,
                  icon: Icons.check_rounded,
                  onPressedAsync: isSubmitting ? null : _submit,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (_startDate == null) {
      setState(() {
        _errorMessage = context.l10n.inventoryStartDateRequiredError;
      });
      return;
    }

    final startDateTime = _combineDateAndTime(_startDate!, _startTime);
    final endDateTime = _endDate == null
        ? null
        : _combineDateAndTime(_endDate!, _endTime);

    if (endDateTime != null && endDateTime.isBefore(startDateTime)) {
      setState(() {
        _errorMessage = context.l10n.inventoryEndDateBeforeStartError;
      });
      return;
    }

    final query = UpdateArkuszRequest(
      dataRozpoczecia: _formatDateTimePayload(startDateTime),
      dataZakonczenia: endDateTime == null
          ? null
          : _formatDateTimePayload(endDateTime),
    );

    await context.read<UpdateArkuszDatesCubit>().submit(
      arkuszId: widget.arkuszId,
      query: query,
    );
  }

  DateTime? _tryParseDate(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return DateTime.tryParse(normalized);
  }

  TimeOfDay _timeFromDateTime(
    DateTime value, {
    required TimeOfDay fallback,
  }) {
    if (value.hour == 0 && value.minute == 0 && value.second == 0) {
      return fallback;
    }
    return TimeOfDay(hour: value.hour, minute: value.minute);
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  String _formatDateTimePayload(DateTime value) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(value);
  }
}

/// Pole wyboru godziny dla modalu edycji dat arkusza.
class _ArkuszTimePickerField extends StatelessWidget {
  /// Tworzy pole wyboru godziny.
  const _ArkuszTimePickerField({
    required this.label,
    required this.value,
    required this.onTap,
    this.enabled = true,
  });

  /// Etykieta pola.
  final String label;

  /// Wybrana godzina.
  final TimeOfDay value;

  /// Akcja otwierajaca picker czasu.
  final VoidCallback onTap;

  /// Okresla, czy pole jest aktywne.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final formatted = MaterialLocalizations.of(context).formatTimeOfDay(value);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: colors.surfaceContainerLow,
          prefixIcon: const Icon(Icons.schedule_outlined),
          enabled: enabled,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(.circular(Sizes.p8)),
          ),
        ),
        child: Text(formatted, style: context.text.bodyMedium),
      ),
    );
  }
}

Future<bool?> _showDeleteInventoryModal(
  BuildContext context, {
  required int inventoryId,
  required String inventoryNumber,
  required InventoriesRepository repository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventoryDeleteTitle,
    subtitle: context.l10n.inventoryDeleteSubtitle,
    size: AppModalSheetSize.small,
    body: _DeleteInventoryModalBody(
      inventoryId: inventoryId,
      inventoryNumber: inventoryNumber,
      repository: repository,
    ),
  );
}

/// Body modalu usuwania inwentaryzacji.
class _DeleteInventoryModalBody extends StatefulWidget {
  /// Tworzy body modalu usuwania.
  const _DeleteInventoryModalBody({
    required this.inventoryId,
    required this.inventoryNumber,
    required this.repository,
  });

  /// Identyfikator inwentaryzacji.
  final int inventoryId;

  /// Numer inwentaryzacji pokazywany w potwierdzeniu.
  final String inventoryNumber;

  /// Repozytorium wykonywujace usuniecie.
  final InventoriesRepository repository;

  @override
  State<_DeleteInventoryModalBody> createState() =>
      _DeleteInventoryModalBodyState();
}

/// Stan modalu usuwania inwentaryzacji.
class _DeleteInventoryModalBodyState extends State<_DeleteInventoryModalBody> {
  static const _deleteUnlockPhrase = 'Excellent';

  bool _isSubmitting = false;
  String? _errorMessage;
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
    final isUnlocked =
        _confirmationController.text.trim() == _deleteUnlockPhrase;

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
                      intl.inventoryDeleteConfirmTitle,
                      style: context.text.titleSmall?.copyWith(
                        color: colors.onErrorContainer,
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h8,
                    AppText(
                      intl.inventoryDeleteConfirmBody(
                        widget.inventoryNumber,
                        widget.inventoryId,
                      ),
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
        if (_errorMessage case final String message) ...[
          Gaps.h12,
          AppText(
            message,
            style: context.text.bodySmall?.copyWith(
              color: colors.error,
              fontWeight: .w600,
            ),
          ),
        ],
        Gaps.h12,
        AppTextField(
          controller: _confirmationController,
          enabled: !_isSubmitting,
          labelText: intl.inventoryDeleteUnlockLabel,
          hintText: intl.inventoryDeleteUnlockHint,
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
              onPressed: _isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(false),
            ),
            Gaps.w8,
            AppActionButton.filled(
              label: intl.delete,
              icon: Icons.delete_outline_rounded,
              tone: .danger,
              onPressedAsync: _isSubmitting || !isUnlocked ? null : _submit,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await widget.repository.deleteInventory(widget.inventoryId);

    if (!mounted) {
      return;
    }

    result.fold(_handleError, (_) => Navigator.of(context).pop(true));
  }

  void _handleError(ApiError error) {
    setState(() {
      _isSubmitting = false;
      _errorMessage = error.message;
    });
  }
}
