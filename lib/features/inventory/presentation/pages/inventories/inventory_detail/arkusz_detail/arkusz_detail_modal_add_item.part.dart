part of 'arkusz_detail_modal.dart';

Future<int?> _showAddArkuszElementModal(
  BuildContext context, {
  required int arkuszId,
  required InventoriesRepository repository,
  required UsersRepository usersRepository,
}) {
  final intl = context.l10n;
  return AppModalSheet.show<int>(
    context,
    title: intl.inventoryAddSheetItemTitle,
    subtitle: intl.inventoryAddSheetItemSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => AddArkuszElementCubit(repository: repository),
      child: _AddArkuszElementModalBody(
        arkuszId: arkuszId,
        usersRepository: usersRepository,
      ),
    ),
  );
}

Future<int?> _showAddArkuszElementByNrewidModal(
  BuildContext context, {
  required int arkuszId,
  required List<int> companyIds,
  required InventoriesRepository repository,
  required StockRepository stockRepository,
}) {
  final intl = context.l10n;
  return AppModalSheet.show<int>(
    context,
    title: intl.inventoryAddSheetItemByRegisterNumberTitle,
    subtitle: intl.inventoryAddSheetItemByRegisterNumberSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => AddArkuszElementCubit(repository: repository),
      child: _AddArkuszElementByNrewidModalBody(
        arkuszId: arkuszId,
        companyIds: companyIds,
        stockRepository: stockRepository,
      ),
    ),
  );
}

/// Formularz recznego dodawania nowego elementu arkusza.
class _AddArkuszElementModalBody extends StatefulWidget {
  /// Tworzy body modalu recznego dodawania elementu.
  const _AddArkuszElementModalBody({
    required this.arkuszId,
    required this.usersRepository,
  });

  final int arkuszId;
  final UsersRepository usersRepository;

  @override
  State<_AddArkuszElementModalBody> createState() =>
      _AddArkuszElementModalBodyState();
}

/// Stan modalu recznego dodawania elementu arkusza.
class _AddArkuszElementModalBodyState
    extends State<_AddArkuszElementModalBody> {
  final _formKey = GlobalKey<FormState>();
  final _firstPurchaseDate = DateTime(1900);
  final _lastPurchaseDate = DateTime(2100);
  final _barcodeController = TextEditingController();
  final _registerNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _personController = SearchController();

  DateTime? _purchaseDate;
  final ValueNotifier<String?> _localError = ValueNotifier(null);

  @override
  void dispose() {
    _barcodeController.dispose();
    _registerNumberController.dispose();
    _nameController.dispose();
    _personController.dispose();
    _localError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocConsumer<AddArkuszElementCubit, AddArkuszElementState>(
      listener: (context, state) {
        if (state is! AddArkuszElementSaved) {
          return;
        }

        AppToast.show(
          context,
          message: context.l10n.inventorySheetItemAddedMessage,
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(state.itemId);
      },
      builder: (context, state) {
        final isSubmitting = state is AddArkuszElementSending;
        final submitError = switch (state) {
          AddArkuszElementReady(:final submitError) => submitError,
          _ => null,
        };

        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              AppTextField(
                controller: _barcodeController,
                variant: .filled,
                labelText: intl.inventoryBarcode,
                helperText: intl.inventoryAddSheetItemBarcodeOptionalHelper,
                keyboardType: TextInputType.number,
                enabled: !isSubmitting,
                validators: [
                  AppValidators.positiveInteger(
                    message: intl.inventoryBarcodePositiveIntegerError,
                  ),
                ],
                onChanged: (_) => _localError.value = null,
              ),
              Gaps.h12,
              AppTextField(
                controller: _registerNumberController,
                variant: .filled,
                labelText: intl.inventoryRegisterNumber,
                enabled: !isSubmitting,
                onChanged: (_) => _localError.value = null,
              ),
              Gaps.h12,
              AppTextField(
                controller: _nameController,
                variant: .filled,
                labelText: intl.inventoryName,
                enabled: !isSubmitting,
                onChanged: (_) => _localError.value = null,
              ),
              Gaps.h12,
              InventoryPersonSuggestionField(
                repository: widget.usersRepository,
                controller: _personController,
                enabled: !isSubmitting,
                labelText: intl.inventoryPerson,
                hintText: intl.inventoryPerson,
                onChanged: () => _localError.value = null,
              ),
              Gaps.h12,
              AppDatePickerField(
                value: _purchaseDate,
                firstDate: _firstPurchaseDate,
                lastDate: _lastPurchaseDate,
                variant: AppDateFieldVariant.filled,
                labelText: intl.inventoryPurchaseDate,
                enabled: !isSubmitting,
                onChanged: (value) {
                  setState(() => _purchaseDate = value);
                  _localError.value = null;
                },
              ),
              ValueListenableBuilder<String?>(
                valueListenable: _localError,
                builder: (context, localError, _) {
                  final message = submitError ?? localError;
                  if (message == null || message.trim().isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: Sizes.p12),
                    child: AppText(
                      message,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.error,
                        fontWeight: .w600,
                      ),
                    ),
                  );
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
                        : () => Navigator.of(context).pop(),
                  ),
                  Gaps.w8,
                  AppActionButton.filled(
                    label: intl.create,
                    icon: Icons.add_rounded,
                    onPressedAsync: isSubmitting ? null : _submit,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final barcode = int.tryParse(_barcodeController.text.trim()) ?? 0;
    final registerNumber = _nullableText(_registerNumberController);
    final name = _nullableText(_nameController);
    final person = _nullableText(_personController);

    if (barcode <= 0 &&
        registerNumber == null &&
        name == null &&
        person == null) {
      _localError.value =
          context.l10n.inventoryAddSheetItemAtLeastOneFieldError;
      return;
    }

    _localError.value = null;

    await context.read<AddArkuszElementCubit>().addManual(
      arkuszId: widget.arkuszId,
      query: PostArkuszElementyQuery(
        kodKreskowy: barcode,
        dataZakupu: _purchaseDate?.toIso8601String().split('T').first,
        nrewid: registerNumber,
        nazwa: name,
        osoba: person,
      ),
    );
  }

  String? _nullableText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }
}

/// Formularz dodawania elementu po numerze ewidencyjnym.
class _AddArkuszElementByNrewidModalBody extends StatefulWidget {
  /// Tworzy body modalu dodawania po numerze ewidencyjnym.
  const _AddArkuszElementByNrewidModalBody({
    required this.arkuszId,
    required this.companyIds,
    required this.stockRepository,
  });

  final int arkuszId;
  final List<int> companyIds;
  final StockRepository stockRepository;

  @override
  State<_AddArkuszElementByNrewidModalBody> createState() =>
      _AddArkuszElementByNrewidModalBodyState();
}

/// Stan modalu dodawania elementu po numerze ewidencyjnym.
class _AddArkuszElementByNrewidModalBodyState
    extends State<_AddArkuszElementByNrewidModalBody> {
  final _formKey = GlobalKey<FormState>();
  final _registerNumberController = SearchController();

  final ValueNotifier<String?> _localError = ValueNotifier(null);

  @override
  void dispose() {
    _registerNumberController.dispose();
    _localError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocConsumer<AddArkuszElementCubit, AddArkuszElementState>(
      listener: (context, state) {
        if (state is! AddArkuszElementSaved) {
          return;
        }

        AppToast.show(
          context,
          message: context.l10n.inventorySheetItemAddedByRegisterNumberMessage,
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(state.itemId);
      },
      builder: (context, state) {
        final isSubmitting = state is AddArkuszElementSending;
        final submitError = switch (state) {
          AddArkuszElementReady(:final submitError) => submitError,
          _ => null,
        };

        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              InventoryRegisterNumberSuggestionField(
                repository: widget.stockRepository,
                companyIds: widget.companyIds,
                controller: _registerNumberController,
                enabled: !isSubmitting,
                labelText: intl.inventoryRegisterNumber,
                hintText: intl.inventoryOverviewSearchHintRegisterNumber,
                onChanged: () => _localError.value = null,
              ),
              ValueListenableBuilder<String?>(
                valueListenable: _localError,
                builder: (context, localError, _) {
                  final message = submitError ?? localError;
                  if (message == null || message.trim().isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: Sizes.p12),
                    child: AppText(
                      message,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.error,
                        fontWeight: .w600,
                      ),
                    ),
                  );
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
                        : () => Navigator.of(context).pop(),
                  ),
                  Gaps.w8,
                  AppActionButton.filled(
                    label: intl.create,
                    icon: Icons.tag_rounded,
                    onPressedAsync: isSubmitting ? null : _submit,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final registerNumber = _registerNumberController.text.trim();
    if (registerNumber.isEmpty) {
      _localError.value = context.l10n.inventoryRegisterNumberRequiredError;
      return;
    }

    _localError.value = null;

    await context.read<AddArkuszElementCubit>().addByNrewid(
      arkuszId: widget.arkuszId,
      query: CreateArkuszElementByNrewidRequest(nrewid: registerNumber),
    );
  }
}
