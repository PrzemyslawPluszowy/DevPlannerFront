part of '../change_item_modal.dart';

/// Zawartosc modala edycji pojedynczego elementu.
class _ChangeItemBody extends StatefulWidget {
  /// Tworzy body modala edycji elementu.
  const _ChangeItemBody({
    required this.item,
    required this.inventoryCompanies,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    super.key,
  });

  /// Element arkusza przekazany do edycji.
  final GetArkuszDetailsElementItem item;

  /// Firmy objete aktualna inwentaryzacja.
  final List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies;

  /// Repozytorium lokalizacji wykorzystywanych przy przeniesieniu.
  final LocationsRepository locationsRepository;

  /// Repozytorium firm wykorzystywanych przy nadwyzkach i przeniesieniach.
  final StockRepository stockRepository;

  /// Repozytorium wyszukiwarki uzytkownikow dla pola nowej osoby.
  final UsersRepository usersRepository;

  @override
  State<_ChangeItemBody> createState() => _ChangeItemBodyState();
}

/// Stan lokalny formularza edycji elementu arkusza.
class _ChangeItemBodyState extends State<_ChangeItemBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nrewidController;
  late final TextEditingController _nowyKodKreskowyController;
  late final SearchController _nowaOsobaController;
  late final TextEditingController _nowaNazwaController;
  late final TextEditingController _uwagiController;
  late final Future<List<GetMiejscaItem>> _locationsFuture;
  late final Future<List<GetFirmyItem>> _companiesFuture;

  late ArkuszElementInwentStatus _stanInwent;
  ArkuszElementStatusSpisu? _statusSpisu;
  late bool _likwidacja;
  late bool _nadwyzka;
  int? _nadwIdmiejsce;
  int? _nadwIdFirmy;
  int? _selectedLocationCompanyId;
  String? _locationError;
  String? _selectedLocationLabel;
  String? _selectedCompanyLabelText;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _stanInwent = item.inventoryStatus ?? ArkuszElementInwentStatus.brak;
    _statusSpisu = item.statusSpisu;
    _likwidacja = item.isLiquidated;
    _nadwyzka = item.hasSurplus;
    _nadwIdmiejsce = item.nadwIdmiejsce;
    _nadwIdFirmy = item.nadwIdFirmy;
    _selectedLocationCompanyId = item.nadwIdFirmy;
    _locationsFuture = _loadLocations();
    _companiesFuture = _loadCompanies();
    _nrewidController = TextEditingController(text: item.nrewid ?? '');
    _nowyKodKreskowyController = TextEditingController(
      text: item.nowyKodKreskowy ?? '',
    );
    _nowaOsobaController = SearchController()..text = item.nowaOsoba ?? '';
    _nowaNazwaController = TextEditingController(text: item.nowaNazwa ?? '');
    _uwagiController = TextEditingController(text: item.uwagiLoc ?? '');
    _selectedLocationLabel = _optionalLocationLabel(
      item.nadwMiejsce ?? item.miejsce,
    );
    _selectedCompanyLabelText = _optionalLocationLabel(item.nadwFirma);
  }

  @override
  void dispose() {
    _nrewidController.dispose();
    _nowyKodKreskowyController.dispose();
    _nowaOsobaController.dispose();
    _nowaNazwaController.dispose();
    _uwagiController.dispose();
    super.dispose();
  }

  void _handleInventoryStatusChange(ArkuszElementInwentStatus? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _stanInwent = value;
      if (_stanInwent != ArkuszElementInwentStatus.przeniesiony &&
          shouldForceDiscrepancyStatus(_statusSpisu)) {
        _statusSpisu = null;
      }
      if (!_shouldShowLocationTree) {
        _clearLocationSelection();
        _clearCompanySelection();
      } else if (!_requiresSubmittedCompany) {
        _nadwIdFirmy = null;
      }
    });
  }

  void _handleSurplusChanged(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _nadwyzka = value;
      if (!_nadwyzka && _statusSpisu == ArkuszElementStatusSpisu.nadwyzka) {
        _statusSpisu = null;
      }
      if (!_shouldShowLocationTree) {
        _clearLocationSelection();
        _clearCompanySelection();
      } else if (!_requiresSubmittedCompany) {
        _nadwIdFirmy = null;
      }
    });
  }

  void _handleStatusSpisuChanged(ArkuszElementStatusSpisu? value) {
    setState(() {
      _statusSpisu = value;
      if (value == ArkuszElementStatusSpisu.nadwyzka) {
        _nadwyzka = true;
      } else if (value != null) {
        _nadwyzka = false;
      }
      if (shouldForceDiscrepancyStatus(value)) {
        _stanInwent = ArkuszElementInwentStatus.przeniesiony;
        _likwidacja = false;
      }
      if (!_shouldShowLocationTree) {
        _clearLocationSelection();
        _clearCompanySelection();
      } else if (!_requiresSubmittedCompany) {
        _nadwIdFirmy = null;
      }
    });
  }

  void _clearLocationSelection() {
    _nadwIdmiejsce = null;
    _locationError = null;
    _selectedLocationLabel = null;
  }

  void _clearCompanySelection() {
    _nadwIdFirmy = null;
    _selectedLocationCompanyId = null;
    _selectedCompanyLabelText = null;
  }

  String? _validateNowyKodKreskowy(String? value) {
    final intl = context.l10n;
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    if (normalized.length > 64) {
      return intl.inventoryNewBarcodeMaxLengthError;
    }

    return null;
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_shouldShowLocationTree && _nadwIdmiejsce == null) {
      setState(() {
        _locationError = context.l10n.inventorySelectLocationBeforeCreateError;
      });
      return;
    }

    final query = PatchArkuszElementQuery(
      stanInwent: _submittedInventoryStatus,
      statusSpisu: _submittedStatusSpisu,
      likwidacja: _submittedLiquidation,
      nadwyzka: _submittedSurplus,
      nrewid: _optionalText(_nrewidController),
      nowyKodKreskowy: _submittedOptionalText(_nowyKodKreskowyController),
      nowaOsoba: _submittedOptionalText(_nowaOsobaController),
      nowaNazwa: _submittedOptionalText(_nowaNazwaController),
      uwagiLoc: _submittedOptionalText(_uwagiController),
      nadwIdmiejsce: _submittedLocationId,
      nadwIdFirmy: _submittedCompanyId,
    );

    context.read<ChangeItemCubit>().submit(query).ignore();
  }

  bool get _shouldShowLocationTree =>
      _nadwyzka ||
      _statusSpisu == ArkuszElementStatusSpisu.znalezionyWInnejFirmie;

  bool get _shouldShowDiscrepancySection => true;

  bool get _shouldShowDiscrepancyDetailsSection => _shouldShowLocationTree;

  bool get _requiresSubmittedCompany =>
      _statusSpisu == ArkuszElementStatusSpisu.znalezionyWInnejFirmie;

  ArkuszElementStatusSpisu? get _submittedStatusSpisu {
    return resolveSubmittedStatusSpisu(
      statusSpisu: _statusSpisu,
      nadwyzka: _nadwyzka,
    );
  }

  bool get _submittedSurplus {
    return resolveSubmittedSurplus(
      statusSpisu: _submittedStatusSpisu,
      nadwyzka: _nadwyzka,
    );
  }

  bool get _restrictToLocationOnly =>
      shouldRestrictToLocationOnly(_submittedStatusSpisu);

  ArkuszElementInwentStatus get _submittedInventoryStatus =>
      resolveSubmittedInventoryStatus(
        inventoryStatus: _stanInwent,
        statusSpisu: _submittedStatusSpisu,
      );

  bool get _submittedLiquidation => resolveSubmittedLiquidation(
    likwidacja: _likwidacja,
    statusSpisu: _submittedStatusSpisu,
  );

  bool get _isLiquidationLockedByStatus =>
      shouldForceDiscrepancyStatus(_submittedStatusSpisu);

  bool get _isInventoryStatusLockedByStatus =>
      shouldForceDiscrepancyStatus(_submittedStatusSpisu);

  bool get _isSurplusLockedByStatus => _restrictToLocationOnly;

  int? get _submittedLocationId =>
      _shouldShowLocationTree ? _nadwIdmiejsce : null;

  int? get _submittedCompanyId =>
      _requiresSubmittedCompany ? _nadwIdFirmy : null;

  Set<int> get _inventoryCompanyIds =>
      widget.inventoryCompanies.map((company) => company.id).toSet();

  bool get _isOutsideInventoryLocationMode =>
      _statusSpisu == ArkuszElementStatusSpisu.znalezionyWInnejFirmie;

  List<GetFirmyItem> _filterLocationCompanies(
    List<GetFirmyItem> companies,
    List<GetMiejscaItem> locations,
  ) {
    final locationCompanyIds = locations
        .map((location) => location.idFirmy)
        .whereType<int>()
        .toSet();

    return companies
        .where((company) {
          if (!locationCompanyIds.contains(company.idFirmy)) {
            return false;
          }

          final isInInventory = _inventoryCompanyIds.contains(company.idFirmy);
          return _isOutsideInventoryLocationMode
              ? !isInInventory
              : isInInventory;
        })
        .toList(growable: false);
  }

  void _syncSelectedLocationCompany(
    List<GetFirmyItem> companies,
    List<GetMiejscaItem> locations,
  ) {
    if (companies.isEmpty) {
      return;
    }

    final availableIds = companies.map((company) => company.idFirmy).toSet();
    if (_selectedLocationCompanyId case final int selectedCompanyId
        when availableIds.contains(selectedCompanyId)) {
      return;
    }

    final selectedLocation = switch (_nadwIdmiejsce) {
      final int locationId =>
        locations
            .where((location) => location.idMiejsca == locationId)
            .firstOrNull,
      _ => null,
    };

    final nextCompanyId = switch (selectedLocation?.idFirmy) {
      final int companyId when availableIds.contains(companyId) => companyId,
      _ => companies.first.idFirmy,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedLocationCompanyId = nextCompanyId;
        _selectedCompanyLabelText = _companyOptionLabel(
          companies.firstWhere(
            (company) => company.idFirmy == nextCompanyId,
          ),
        );
        if (_requiresSubmittedCompany) {
          _nadwIdFirmy = nextCompanyId;
        }
      });
    });
  }

  void _handleLocationCompanyChanged(GetFirmyItem company) {
    setState(() {
      _selectedLocationCompanyId = company.idFirmy;
      _selectedCompanyLabelText = _companyOptionLabel(company);
      if (_requiresSubmittedCompany) {
        _nadwIdFirmy = company.idFirmy;
      }
      _clearLocationSelection();
    });
  }

  Future<List<GetMiejscaItem>> _loadLocations() async {
    final result = await widget.locationsRepository.fetchLocations(
      forceRefresh: true,
    );
    return result.fold(_throwLocationsError, _sortLocations);
  }

  Future<List<GetFirmyItem>> _loadCompanies() async {
    final result = await widget.stockRepository.fetchCompanies(
      forceRefresh: true,
    );
    return result.fold(_throwCompaniesError, _sortCompanies);
  }

  Never _throwLocationsError(ApiError error) {
    throw Exception(error.message);
  }

  Never _throwCompaniesError(ApiError error) {
    throw Exception(error.message);
  }

  List<GetMiejscaItem> _sortLocations(GetMiejscaResponseData data) {
    return List<GetMiejscaItem>.from(data.items)..sort(
      (left, right) => _locationOptionLabel(left).compareTo(
        _locationOptionLabel(right),
      ),
    );
  }

  List<GetFirmyItem> _sortCompanies(List<GetFirmyItem> items) {
    return List<GetFirmyItem>.from(items)..sort(
      (left, right) =>
          _companyOptionLabel(left).compareTo(_companyOptionLabel(right)),
    );
  }

  String _locationOptionLabel(GetMiejscaItem location) {
    final name = _displayValue(location.nazwa);
    final level = _displayValue(location.lvl);
    return '$name [$level]';
  }

  String _companyOptionLabel(GetFirmyItem company) {
    final name = company.nazwa.trim().isEmpty
        ? _displayValue(null)
        : company.nazwa.trim();
    return '$name [${company.idFirmy}]';
  }

  void _syncSelectedLocationLabel(List<GetMiejscaItem> locations) {
    if (_nadwIdmiejsce == null) {
      return;
    }

    final selected = locations
        .where((location) => location.idMiejsca == _nadwIdmiejsce)
        .firstOrNull;
    if (selected == null) {
      return;
    }

    final nextLabel = _locationOptionLabel(selected);
    if (_selectedLocationLabel == nextLabel) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() => _selectedLocationLabel = nextLabel);
    });
  }

  String _locationsErrorMessage(Object? error) {
    return switch (error) {
      final Exception exception => exception.toString().replaceFirst(
        'Exception: ',
        '',
      ),
      _ => 'Nie udało się pobrać listy miejsc.',
    };
  }

  String _companiesErrorMessage(Object? error) {
    return switch (error) {
      final Exception exception => exception.toString().replaceFirst(
        'Exception: ',
        '',
      ),
      _ => 'Nie udało się pobrać listy firm.',
    };
  }

  String? _optionalText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  String? _submittedOptionalText(TextEditingController controller) {
    if (_restrictToLocationOnly) {
      return null;
    }

    return _optionalText(controller);
  }

  String? _optionalLocationLabel(String? value) {
    final normalized = value?.trim();
    return switch (normalized) {
      final String label when label.isNotEmpty => label,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocConsumer<ChangeItemCubit, ChangeItemState>(
      listener: (context, state) {
        switch (state) {
          case ChangeItemSaved():
            Navigator.of(context).pop(true);
            AppToast.show(
              context,
              tone: AppToastTone.success,
              message: intl.inventoryItemSavedMessage,
            );
          case ChangeItemReady() || ChangeItemSending():
            break;
        }
      },
      builder: (context, state) {
        final isSending = state is ChangeItemSending;
        final submitError = switch (state) {
          ChangeItemReady(:final submitError) => submitError,
          ChangeItemSending() || ChangeItemSaved() => null,
        };
        final bodyHeight = (MediaQuery.sizeOf(context).height - 220).clamp(
          540.0,
          1200.0,
        );

        final locationPanel = _shouldShowLocationTree
            ? _ChangeItemLocationPanelCard(
                isSending: isSending,
                nadwyzka: _nadwyzka,
                isFoundInOtherCompany: _isOutsideInventoryLocationMode,
                selectedLocationLabel: _selectedLocationLabel,
                locationError: _locationError,
                locationsFuture: _locationsFuture,
                companiesFuture: _companiesFuture,
                selectedCompanyId: _selectedLocationCompanyId,
                selectedLocationId: _nadwIdmiejsce,
                companyOptionLabel: _companyOptionLabel,
                filterLocationCompanies: _filterLocationCompanies,
                onSyncSelectedCompany: _syncSelectedLocationCompany,
                onCompanySelected: _handleLocationCompanyChanged,
                onSyncSelectedLocationLabel: _syncSelectedLocationLabel,
                onLocationSelected: (location) {
                  setState(() {
                    _nadwIdmiejsce = location.idMiejsca;
                    _selectedLocationCompanyId = location.idFirmy;
                    if (_requiresSubmittedCompany) {
                      _nadwIdFirmy = location.idFirmy;
                    }
                    _locationError = null;
                    _selectedLocationLabel = _locationOptionLabel(location);
                  });
                },
                locationsErrorMessage: _locationsErrorMessage,
                companiesErrorMessage: _companiesErrorMessage,
              )
            : null;

        final changesPreview = _ChangeItemChangesPreview(
          item: widget.item,
          stanInwent: _submittedInventoryStatus,
          statusSpisu: _submittedStatusSpisu,
          likwidacja: _submittedLiquidation,
          nadwyzka: _submittedSurplus,
          nrewid: _optionalText(_nrewidController),
          nowyKodKreskowy: _submittedOptionalText(_nowyKodKreskowyController),
          nowaOsoba: _submittedOptionalText(_nowaOsobaController),
          nowaNazwa: _submittedOptionalText(_nowaNazwaController),
          uwagi: _submittedOptionalText(_uwagiController),
          submittedLocationId: _submittedLocationId,
          submittedCompanyId: _submittedCompanyId,
          selectedLocationLabel: _selectedLocationLabel,
          selectedCompanyLabel: _selectedCompanyLabelText,
        );

        return Form(
          key: _formKey,
          child: SizedBox(
            height: bodyHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide =
                    constraints.maxWidth >= 980 && _shouldShowLocationTree;
                final formColumn = _ChangeItemMainColumn(
                  item: widget.item,
                  isSending: isSending,
                  submitError: submitError,
                  shouldShowDiscrepancySection: _shouldShowDiscrepancySection,
                  shouldShowDiscrepancyDetailsSection:
                      _shouldShowDiscrepancyDetailsSection,
                  inventoryStatus: _submittedInventoryStatus,
                  lockInventoryStatus: _isInventoryStatusLockedByStatus,
                  statusSpisu: _statusSpisu,
                  likwidacja: _submittedLiquidation,
                  lockLiquidation: _isLiquidationLockedByStatus,
                  nadwyzka: _nadwyzka,
                  lockSurplus: _isSurplusLockedByStatus,
                  nrewidController: _nrewidController,
                  nowyKodKreskowyController: _nowyKodKreskowyController,
                  usersRepository: widget.usersRepository,
                  nowaOsobaController: _nowaOsobaController,
                  nowaNazwaController: _nowaNazwaController,
                  uwagiController: _uwagiController,
                  lockManualCorrections: _restrictToLocationOnly,
                  validateNowyKodKreskowy: _validateNowyKodKreskowy,
                  onInventoryStatusChanged: _handleInventoryStatusChange,
                  onStatusSpisuChanged: _handleStatusSpisuChanged,
                  onLikwidacjaChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() => _likwidacja = value);
                  },
                  onSurplusChanged: _handleSurplusChanged,
                  onTextChanged: () => setState(() {}),
                  inlineLocationPanel: isWide ? null : locationPanel,
                  changesPreview: changesPreview,
                );

                if (!isWide) {
                  return SingleChildScrollView(child: formColumn);
                }

                return Row(
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        padding: const .only(right: Sizes.p16),
                        child: formColumn,
                      ),
                    ),
                    SizedBox(
                      width: (constraints.maxWidth * 0.44).clamp(480.0, 760.0),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const .only(left: Sizes.p8),
                          child: locationPanel,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
