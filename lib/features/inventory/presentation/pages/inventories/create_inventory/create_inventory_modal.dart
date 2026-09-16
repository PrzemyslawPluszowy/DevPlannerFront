import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/create_inventory/cubit/create_inventory_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/create_inventory/cubit/create_inventory_state.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/inventory_users_search_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_multi_select_chips_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera modal tworzenia nowej inwentaryzacji.
Future<bool?> showCreateInventoryModal(BuildContext context) {
  final inventoriesRepository = context.read<InventoriesRepository>();
  final stockRepository = context.read<StockRepository>();
  final usersRepository = context.read<UsersRepository>();
  final intl = context.l10n;
  final formController = _CreateInventoryModalFormController();
  final cubit = CreateInventoryCubit(
    inventoriesRepository: inventoriesRepository,
    stockRepository: stockRepository,
  );

  return AppModalSheet.show<bool>(
    context,
    title: intl.inventoryCreateTitle,
    subtitle: intl.inventoryCreateSubtitle,
    body: BlocProvider.value(
      value: cubit,
      child: _CreateInventoryModalBody(
        formController: formController,
        usersRepository: usersRepository,
      ),
    ),
    footer: BlocProvider.value(
      value: cubit,
      child: _CreateInventoryModalFooter(formController: formController),
    ),
  ).whenComplete(cubit.close);
}

/// Kontroler formularza tworzenia inwentaryzacji dla akcji w stopce modala.
class _CreateInventoryModalFormController {
  VoidCallback? _submit;

  void attachSubmit(VoidCallback callback) {
    _submit = callback;
  }

  void clear() {
    _submit = null;
  }

  void submit() {
    _submit?.call();
  }
}

/// Zawartosc modala tworzenia inwentaryzacji.
class _CreateInventoryModalBody extends StatefulWidget {
  /// Tworzy body modala nowej inwentaryzacji.
  const _CreateInventoryModalBody({
    required this.usersRepository,
    required this.formController,
  });

  final UsersRepository usersRepository;
  final _CreateInventoryModalFormController formController;

  @override
  State<_CreateInventoryModalBody> createState() =>
      _CreateInventoryModalBodyState();
}

/// Stan lokalny formularza tworzenia inwentaryzacji.
class _CreateInventoryModalBodyState extends State<_CreateInventoryModalBody> {
  static const int _minKomisjaUsersCount = 2;
  static const int _minFirmyCount = 1;

  final _formKey = GlobalKey<FormState>();
  final _numerController = TextEditingController();
  final _uwagiController = TextEditingController();
  List<int> _komisjaUserIds = const [];
  List<int> _selectedFirmaIds = const [];
  bool _firmyInitialized = false;

  String? _firmaError;
  String? _komisjaError;

  @override
  void initState() {
    super.initState();
    widget.formController.attachSubmit(_onSubmit);
  }

  @override
  void didUpdateWidget(covariant _CreateInventoryModalBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.formController, widget.formController)) {
      oldWidget.formController.clear();
      widget.formController.attachSubmit(_onSubmit);
    }
  }

  @override
  void dispose() {
    widget.formController.clear();
    _numerController.dispose();
    _uwagiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateInventoryCubit, CreateInventoryState>(
      listener: (context, state) {
        switch (state) {
          case CreateInventorySended():
            Navigator.of(context).pop(true);
            AppToast.show(
              context,
              tone: AppToastTone.success,
              message: context.l10n.inventoryCreatedMessage,
            );
          case CreateInventoryLoaded(
            :final companies,
          ):
            final validCompanyIds = companies
                .map((company) => company.idFirmy)
                .toSet();
            if (!_firmyInitialized) {
              _firmyInitialized = true;
              break;
            }

            final filtered = _selectedFirmaIds
                .where(validCompanyIds.contains)
                .toList(growable: false);
            if (filtered.length != _selectedFirmaIds.length) {
              setState(() => _selectedFirmaIds = filtered);
            }
          case CreateInventoryError():
          case CreateInventoryLoading() || CreateInventoryLoaded():
            break;
        }
      },
      builder: (context, state) {
        if (state case CreateInventoryLoading()) {
          return const Center(child: AppSpinner());
        }

        if (state case CreateInventoryError(:final message)) {
          final intl = context.l10n;
          return AppEmptyState.error(
            title: intl.inventoryLoadCompaniesErrorTitle,
            message: message,
            compact: true,
            action: AppActionButton.outlined(
              label: intl.retry,
              icon: Icons.refresh_rounded,
              tone: .neutral,
              onPressedAsync: context
                  .read<CreateInventoryCubit>()
                  .loadCompanies,
            ),
          );
        }

        if (state case CreateInventoryLoaded(
          :final companies,
          :final isSending,
          :final submitError,
        )) {
          final intl = context.l10n;
          if (companies.isEmpty) {
            return AppEmptyState.error(
              title: intl.inventoryCompaniesEmptyTitle,
              message: intl.inventoryCompaniesListEmptyMessage,
              compact: true,
              action: AppActionButton.outlined(
                label: intl.retry,
                icon: Icons.refresh_rounded,
                tone: .neutral,
                onPressedAsync: context
                    .read<CreateInventoryCubit>()
                    .loadCompanies,
              ),
            );
          }

          final isSubmitting = isSending;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                if (submitError case final String message
                    when message.trim().isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const .all(Sizes.p10),
                    decoration: BoxDecoration(
                      color: context.colors.errorContainer.withValues(
                        alpha: .35,
                      ),
                      borderRadius: const BorderRadius.all(
                        .circular(Sizes.p8),
                      ),
                      border: Border.all(
                        color: context.colors.error.withValues(alpha: .35),
                      ),
                    ),
                    child: AppText(
                      message.trim(),
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onErrorContainer,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                  Gaps.h12,
                ],
                AppMultiSelectChipsField<int>(
                  labelText: intl.inventoryCompany,
                  hintText: intl.inventorySelectCompanyHint,
                  isRequired: true,
                  enabled: !isSubmitting,
                  errorText: _firmaError,
                  selectedValues: _selectedFirmaIds,
                  options: companies
                      .map(
                        (company) => AppMultiSelectChipsOption<int>(
                          value: company.idFirmy,
                          label: '${company.nazwa} (${company.idFirmy})',
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (nextValues) {
                    setState(() {
                      _firmaError = null;
                      _selectedFirmaIds = nextValues;
                    });
                  },
                ),
                Gaps.h12,
                AppTextField(
                  controller: _numerController,
                  labelText: intl.inventoryNumber,
                  hintText: intl.inventoryNumberExampleHint,
                  isRequired: true,
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return intl.inventoryNumberRequired;
                    }
                    return null;
                  },
                ),
                Gaps.h12,
                InventoryUsersSearchPicker(
                  hintText: intl.inventorySearchPersonHint,
                  enabled: !isSubmitting,
                  repository: widget.usersRepository,
                  onChanged: (users) {
                    setState(() {
                      _komisjaError = null;
                      _komisjaUserIds = users
                          .map((user) => user.userId)
                          .toList(growable: false);
                    });
                  },
                ),
                if (_komisjaError case final String message
                    when message.trim().isNotEmpty) ...[
                  Gaps.h8,
                  AppText(
                    message.trim(),
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.error,
                      fontWeight: .w600,
                    ),
                  ),
                ],
                Gaps.h12,
                AppTextField(
                  controller: _uwagiController,
                  labelText: intl.inventoryRemarks,
                  hintText: intl.inventoryOptionalRemarks,
                  maxLines: 3,
                  minLines: 3,
                ),
                Gaps.h16,
                AppText(
                  intl.inventoryCreateDatesInfo,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _onSubmit() {
    setState(() {
      _firmaError = null;
      _komisjaError = null;
    });

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    if (_selectedFirmaIds.length < _minFirmyCount) {
      setState(() {
        _firmaError = context.l10n.inventorySelectCompanyError;
      });
      return;
    }

    if (_komisjaUserIds.length < _minKomisjaUsersCount) {
      setState(() {
        _komisjaError = context.l10n.inventorySelectMinTwoCommissionUsers;
      });
      return;
    }

    final currentDate = _formatApiDate(DateTime.now());
    final query = PostInwentaryzacjaQuery(
      firmy: _selectedFirmaIds,
      numer: _numerController.text.trim(),
      komisja: _komisjaUserIds,
      dataOd: currentDate,
      uwagi: _normalizeOptional(_uwagiController.text),
    );

    context.read<CreateInventoryCubit>().submit(query).ignore();
  }

  String? _normalizeOptional(String value) {
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  String _formatApiDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

/// Stopka modala tworzenia inwentaryzacji ze stałymi akcjami.
class _CreateInventoryModalFooter extends StatelessWidget {
  /// Tworzy stopkę modala dla akcji formularza.
  const _CreateInventoryModalFooter({required this.formController});

  final _CreateInventoryModalFormController formController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateInventoryCubit, CreateInventoryState>(
      builder: (context, state) {
        final isSubmitting = switch (state) {
          CreateInventoryLoaded(:final isSending) => isSending,
          _ => false,
        };
        final canSubmit = switch (state) {
          CreateInventoryLoaded(:final isSending) => !isSending,
          _ => false,
        };
        final intl = context.l10n;

        return Row(
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
              label: intl.create,
              icon: Icons.add_rounded,
              onPressed: canSubmit ? formController.submit : null,
            ),
          ],
        );
      },
    );
  }
}
