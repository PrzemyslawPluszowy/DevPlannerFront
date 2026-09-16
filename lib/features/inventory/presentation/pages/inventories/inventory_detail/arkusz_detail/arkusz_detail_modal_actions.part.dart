part of 'arkusz_detail_modal.dart';

/// Karta podsumowania arkusza z akcjami edycji naglowka.
class _ArkuszDetailSummaryCard extends StatelessWidget {
  /// Tworzy karte podsumowania dla zaladowanego arkusza.
  const _ArkuszDetailSummaryCard({
    required this.arkuszId,
    required this.arkuszNumber,
    required this.canEditArkusz,
    required this.data,
    required this.inventoriesRepository,
    required this.usersRepository,
    this.onDataChanged,
  });

  /// Identyfikator aktualnie otwartego arkusza.
  final int arkuszId;

  /// Numer arkusza pokazywany w tytulach i toastach.
  final String arkuszNumber;

  /// Okresla, czy akcje edycji sa dostepne dla uzytkownika.
  final bool canEditArkusz;

  /// Pelne dane szczegolow arkusza.
  final GetArkuszDetailsResponseData data;

  /// Repozytorium wykorzystywane przez modale edycyjne.
  final InventoriesRepository inventoriesRepository;

  /// Repozytorium potrzebne do wyszukiwarki uzytkownikow komisji.
  final UsersRepository usersRepository;

  /// Callback odswiezajacy widok nadrzedny po zapisaniu zmian.
  final VoidCallback? onDataChanged;

  @override
  Widget build(BuildContext context) {
    final header = data.arkusz;
    final visibleElementsCount = data.elementy.length;
    return _ArkuszHeaderCard(
      placeName: header.nazwaMiejsca,
      placeLevel: header.lvlMiejsca,
      elementsCount: visibleElementsCount,
      committeeCount: data.komisja.length,
      startDateTime: header.rozpoczecie,
      endDateTime: header.zakonczenie,
      committee: data.komisja,
      onShowLegend: () => _showArkuszStatusesLegendDialog(context),
      onEditCommittee: () => _handleEditCommittee(context),
      canEditCommittee: canEditArkusz,
    );
  }

  void _handleEditCommittee(BuildContext context) {
    if (!canEditArkusz) {
      return;
    }

    (() async {
      final intl = context.l10n;
      final saved = await showEditCommissionModal(
        context,
        title: intl.inventoryEditCommissionTitle,
        subtitle: intl.inventoryCommissionForSheet(arkuszNumber),
        targetId: arkuszId,
        targetType: EditCommissionTargetType.arkusz,
        initialSelected: _committeeInitialSelected(context, data.komisja),
        inventoriesRepository: inventoriesRepository,
        usersRepository: usersRepository,
      );
      if (!context.mounted || saved != true) {
        return;
      }

      await context.read<ArkuszPreviewCubit>().load(arkuszId);
      onDataChanged?.call();
    })().ignore();
  }

  List<GetReadyUsersSearchItem> _committeeInitialSelected(
    BuildContext context,
    List<GetArkuszDetailsKomisjaItem> members,
  ) {
    return members
        .map(
          (member) => GetReadyUsersSearchItem(
            usrId: member.userId,
            firnam: _normalizeMemberName(
              context,
              member.displayName,
              member.userId,
            ),
          ),
        )
        .toList(growable: false);
  }

  String _normalizeMemberName(
    BuildContext context,
    String displayName,
    int userId,
  ) {
    final intl = context.l10n;
    final normalized = displayName.trim();
    return normalized.isEmpty ? intl.inventoryUserWithId(userId) : normalized;
  }
}

/// Pasek akcji sekcji elementow arkusza.
class _ArkuszElementsToolbar extends StatelessWidget {
  /// Tworzy pasek akcji dla listy elementow.
  const _ArkuszElementsToolbar({
    required this.arkuszId,
    required this.arkuszNumber,
    required this.inventoryCompanies,
    required this.data,
    required this.visibleItemsForExport,
    required this.canEditArkusz,
    required this.canDeleteArkusz,
    required this.startDateTime,
    required this.endDateTime,
    required this.repository,
    required this.usersRepository,
    required this.stockRepository,
    required this.onItemAdded,
    this.onDataChanged,
  });

  /// Identyfikator arkusza obslugiwany przez akcje.
  final int arkuszId;

  /// Numer arkusza wyswietlany przy potwierdzaniu usuniecia.
  final String arkuszNumber;

  /// Firmy objete aktualna inwentaryzacja.
  final List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies;

  /// Pelne dane arkusza wykorzystywane do eksportu PDF.
  final GetArkuszDetailsResponseData data;

  /// Aktualnie widoczne pozycje po wyszukiwaniu i filtrowaniu.
  final List<GetArkuszDetailsElementItem> visibleItemsForExport;

  /// Okresla, czy akcja edycji jest dostepna dla uzytkownika.
  final bool canEditArkusz;

  /// Okresla, czy akcja usuniecia powinna byc aktywna.
  final bool canDeleteArkusz;

  /// Aktualna data rozpoczecia przekazywana do modalu edycji.
  final String? startDateTime;

  /// Aktualna data zakonczenia przekazywana do modalu edycji.
  final String? endDateTime;

  /// Repozytorium przekazywane do modalu usuwania.
  final InventoriesRepository repository;

  /// Repozytorium wyszukiwarki osob odpowiedzialnych.
  final UsersRepository usersRepository;

  /// Repozytorium wyszukiwarki `stan_st` po numerze ewidencyjnym.
  final StockRepository stockRepository;

  /// Callback fokusujacy nowo dodany element po odswiezeniu danych.
  final ValueChanged<int> onItemAdded;

  /// Callback dla nadrzednego widoku po zmianie danych.
  final VoidCallback? onDataChanged;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final actions = [
      AppActionButton.outlined(
        label: intl.inventoryAdd,
        icon: Icons.add_rounded,
        tone: .neutral,
        onPressed: !canEditArkusz ? null : () => _handleAddManual(context),
      ),
      AppActionButton.outlined(
        label: intl.inventoryAddByRegisterNumberShort,
        icon: Icons.tag_rounded,
        tone: .neutral,
        onPressed: !canEditArkusz ? null : () => _handleAddByNrewid(context),
      ),

      AppActionButton.outlined(
        label: context.l10n.inventoryPrint,
        icon: Icons.print_rounded,
        tone: .neutral,
        onPressedAsync: () => showArkuszPdfExportFlow(
          context,
          arkuszId: arkuszId,
          arkuszNumber: arkuszNumber,
          inventoriesRepository: repository,
          data: data,
        ),
      ),
      AppActionButton.outlined(
        label: '${context.l10n.inventoryPrint} (odfiltrowane)',
        icon: Icons.filter_alt_rounded,
        tone: .neutral,
        onPressedAsync: () => showArkuszPdfExportFlow(
          context,
          arkuszId: arkuszId,
          arkuszNumber: arkuszNumber,
          inventoriesRepository: repository,
          data: data,
          filteredItems: visibleItemsForExport,
        ),
      ),
      AppActionButton.outlined(
        label: context.l10n.inventoryDates,
        icon: Icons.event_outlined,
        tone: .neutral,
        onPressed: !canEditArkusz
            ? null
            : () {
                (() async {
                  final updated = await _showUpdateArkuszDatesModal(
                    context,
                    arkuszId: arkuszId,
                    startDateTime: startDateTime,
                    endDateTime: endDateTime,
                    repository: repository,
                  );
                  if (!context.mounted || updated != true) {
                    return;
                  }

                  AppToast.show(
                    context,
                    message: context.l10n.inventorySheetDatesSavedMessage,
                    tone: AppToastTone.success,
                  );
                  await context.read<ArkuszPreviewCubit>().load(arkuszId);
                  onDataChanged?.call();
                })().ignore();
              },
      ),
      AppActionPill(
        label: intl.inventoryRefresh,
        icon: Icons.refresh_rounded,
        tone: .contrast,
        selected: true,
        onPressed: () =>
            context.read<ArkuszPreviewCubit>().load(arkuszId).ignore(),
      ),
      AppActionButton.outlined(
        label: intl.inventoryDeleteSheetTitle,
        icon: Icons.delete_outline_rounded,
        tone: .danger,
        onPressed: !canDeleteArkusz ? null : () => _handleDelete(context),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1320) {
          return Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: AppText(
                  intl.inventorySheetItemsTitle,
                  style: context.text.titleSmall?.copyWith(fontWeight: .w700),
                ),
              ),
              Gaps.w12,
              Flexible(
                child: Align(
                  alignment: .centerRight,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: Sizes.p8,
                    runSpacing: Sizes.p8,
                    children: actions,
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: .start,
          children: [
            AppText(
              intl.inventorySheetItemsTitle,
              style: context.text.titleSmall?.copyWith(fontWeight: .w700),
            ),
            Gaps.h8,
            Wrap(spacing: Sizes.p8, runSpacing: Sizes.p8, children: actions),
          ],
        );
      },
    );
  }

  void _handleAddManual(BuildContext context) {
    (() async {
      final added = await _showAddArkuszElementModal(
        context,
        arkuszId: arkuszId,
        repository: repository,
        usersRepository: usersRepository,
      );
      if (!context.mounted || added == null) {
        return;
      }

      await context.read<ArkuszPreviewCubit>().load(arkuszId);
      onItemAdded(added);
      onDataChanged?.call();
    })().ignore();
  }

  void _handleAddByNrewid(BuildContext context) {
    (() async {
      final added = await _showAddArkuszElementByNrewidModal(
        context,
        arkuszId: arkuszId,
        companyIds: _resolveInventoryCompanyIds(),
        repository: repository,
        stockRepository: stockRepository,
      );
      if (!context.mounted || added == null) {
        return;
      }

      await context.read<ArkuszPreviewCubit>().load(arkuszId);
      onItemAdded(added);
      onDataChanged?.call();
    })().ignore();
  }

  List<int> _resolveInventoryCompanyIds() {
    final ids = <int>{
      ...inventoryCompanies
          .map((company) => company.id)
          .where((id) => id > 0)
          .toSet(),
    };

    final arkuszCompanyId = data.arkusz.firma;
    if (arkuszCompanyId != null && arkuszCompanyId > 0) {
      ids.add(arkuszCompanyId);
    }

    return ids.toList(growable: false);
  }

  void _handleDelete(BuildContext context) {
    (() async {
      final intl = context.l10n;
      final deleted = await _showDeleteArkuszModal(
        context,
        arkuszId: arkuszId,
        arkuszNumber: arkuszNumber,
        canDeleteArkusz: canDeleteArkusz,
        repository: repository,
      );
      if (!context.mounted || deleted != true) {
        return;
      }

      AppToast.show(
        context,
        message: intl.inventorySheetDeletedMessage,
        tone: AppToastTone.success,
      );
      onDataChanged?.call();
      Navigator.of(context).pop();
    })().ignore();
  }
}
