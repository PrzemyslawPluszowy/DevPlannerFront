import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/create_arkusz_tree_utils.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/cubit/create_arkusz_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/cubit/create_arkusz_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/inventory_detail_constants.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/inventory_users_search_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_tree.dart';

/// Otwiera modal tworzenia nowego arkusza.
Future<bool?> showCreateArkuszModal(
  BuildContext context, {
  required int inventoryId,
  required int? firmaId,
  required List<GetInwentaryzacjaDetailsFirmaItem> firmy,
  required InventoriesRepository inventoriesRepository,
  required LocationsRepository locationsRepository,
  required UsersRepository usersRepository,
}) {
  final intl = context.l10n;
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => BlocProvider(
      create: (context) =>
          CreateArkuszCubit(
              inventoriesRepository: inventoriesRepository,
              locationsRepository: locationsRepository,
            )
            ..initialize(
              firmaId: _resolveInitialFirmaId(firmaId: firmaId, firmy: firmy),
            ).ignore(),
      child: AppModalSheet(
        title: intl.inventoryNewSheet,
        subtitle: intl.inventoryAddSheetToInventory(inventoryId),
        size: AppModalSheetSize.large,
        minBodyHeight: 560,
        maxBodyHeight: 720,
        body: _CreateArkuszModalBody(
          firmaId: firmaId,
          firmy: firmy,
          usersRepository: usersRepository,
        ),
        footer: _CreateArkuszModalFooter(inventoryId: inventoryId),
      ),
    ),
  );
}

int? _resolveInitialFirmaId({
  required int? firmaId,
  required List<GetInwentaryzacjaDetailsFirmaItem> firmy,
}) {
  final validFirmy = firmy
      .where((firma) => firma.id > 0)
      .toList(growable: false);
  if (firmaId case final int id when id > 0) {
    return id;
  }
  return validFirmy.firstOrNull?.id;
}

/// Zakladka firmy dla modalu tworzenia arkusza.
class _CreateArkuszFirmaTab {
  /// Tworzy zakladke firmy.
  const _CreateArkuszFirmaTab({
    required this.id,
    this.nazwaFirmy,
  });

  /// Identyfikator firmy.
  final int id;

  /// Nazwa firmy.
  final String? nazwaFirmy;
}

/// Zawartosc modala tworzenia nowego arkusza.
class _CreateArkuszModalBody extends StatefulWidget {
  /// Tworzy body modala nowego arkusza.
  const _CreateArkuszModalBody({
    required this.firmaId,
    required this.firmy,
    required this.usersRepository,
  });

  final int? firmaId;
  final List<GetInwentaryzacjaDetailsFirmaItem> firmy;
  final UsersRepository usersRepository;

  @override
  State<_CreateArkuszModalBody> createState() => _CreateArkuszModalBodyState();
}

/// Stan lokalny formularza tworzenia arkusza.
class _CreateArkuszModalBodyState extends State<_CreateArkuszModalBody> {
  late final List<_CreateArkuszFirmaTab> _firmaTabs;
  late final TextEditingController _numerController;
  late int? _selectedFirmaId;

  @override
  void initState() {
    super.initState();
    _firmaTabs = _resolveFirmaTabs(widget.firmy);
    _numerController = TextEditingController();
    _selectedFirmaId = _resolveInitialFirmaId(
      firmaId: widget.firmaId,
      firmy: widget.firmy,
    );
  }

  @override
  void dispose() {
    _numerController.dispose();
    super.dispose();
  }

  List<_CreateArkuszFirmaTab> _resolveFirmaTabs(
    List<GetInwentaryzacjaDetailsFirmaItem> firmy,
  ) {
    final deduped = <int>{};
    return firmy
        .where((firma) => firma.id > 0)
        .where((firma) => deduped.add(firma.id))
        .map(
          (firma) => _CreateArkuszFirmaTab(
            id: firma.id,
            nazwaFirmy: firma.nazwaFirmy,
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocConsumer<CreateArkuszCubit, CreateArkuszState>(
      listener: (context, state) {
        switch (state) {
          case CreateArkuszSuccess():
            Navigator.of(context).pop(true);
          case CreateArkuszLoading() ||
              CreateArkuszLoadError() ||
              CreateArkuszReady():
            break;
        }
      },
      builder: (context, state) {
        return switch (state) {
          CreateArkuszLoading() => const Center(
            child: Padding(
              padding: .symmetric(vertical: Sizes.p24),
              child: AppSpinner(),
            ),
          ),
          CreateArkuszLoadError(:final message) => AppEmptyState.error(
            title: intl.inventoryLoadLocationsErrorTitle,
            message: message,
            compact: true,
            action: AppActionButton.outlined(
              label: intl.retry,
              icon: Icons.refresh_rounded,
              tone: .neutral,
              onPressed: () => context
                  .read<CreateArkuszCubit>()
                  .initialize(
                    firmaId: _selectedFirmaId,
                  )
                  .ignore(),
            ),
          ),
          CreateArkuszSuccess() => const SizedBox.shrink(),
          CreateArkuszReady(
            :final locations,
            :final selectedLocationId,
            :final numerRaw,
            :final isSubmitting,
            :final submitError,
          ) =>
            _buildReadyForm(
              locations: locations,
              selectedLocationId: selectedLocationId,
              numerRaw: numerRaw,
              isSubmitting: isSubmitting,
              submitError: submitError,
            ),
        };
      },
    );
  }

  String _selectedFirmaLabel(BuildContext context) {
    final intl = context.l10n;
    final selectedTab = _firmaTabs
        .where((firmaTab) => firmaTab.id == _selectedFirmaId)
        .firstOrNull;
    return switch (selectedTab?.nazwaFirmy) {
      final String name when name.trim().isNotEmpty => name.trim(),
      _ when _selectedFirmaId != null =>
        '${intl.inventoryCompany} $_selectedFirmaId',
      _ => intl.inventoryCompany,
    };
  }

  Widget _buildReadyForm({
    required List<GetMiejscaItem> locations,
    required int? selectedLocationId,
    required String numerRaw,
    required bool isSubmitting,
    required String? submitError,
  }) {
    final intl = context.l10n;
    if (_numerController.text != numerRaw) {
      _numerController.value = TextEditingValue(
        text: numerRaw,
        selection: TextSelection.collapsed(offset: numerRaw.length),
      );
    }
    final locationNodes = _buildLocationNodes(
      locations: locations,
      selectedLocationId: selectedLocationId,
    );

    return SizedBox(
      height: 600,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          if (submitError case final String message
              when message.trim().isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const .all(Sizes.p10),
              decoration: BoxDecoration(
                color: context.colors.errorContainer.withValues(alpha: .35),
                borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
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
          if (_firmaTabs.length > 1) ...[
            AppText(
              'Wybrana firma: ${_selectedFirmaLabel(context)}',
              style: context.text.labelLarge?.copyWith(fontWeight: .w700),
            ),
            Gaps.h8,
            Container(
              width: double.infinity,
              margin: const .only(bottom: Sizes.p12),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLow,
                borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
                border: Border.all(color: context.colors.outlineVariant),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const .all(Sizes.p4),
                child: Row(
                  children: _firmaTabs
                      .map((firmaTab) {
                        final isSelected = firmaTab.id == _selectedFirmaId;
                        final label = switch (firmaTab.nazwaFirmy) {
                          final String name when name.trim().isNotEmpty =>
                            name.trim(),
                          _ => '${intl.inventoryCompany} ${firmaTab.id}',
                        };
                        return Padding(
                          padding: const .only(right: Sizes.p4),
                          child: AppActionPill(
                            label: label,
                            icon: Icons.business_outlined,
                            tone: .primary,
                            selected: isSelected,
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    if (isSelected) {
                                      return;
                                    }
                                    setState(
                                      () => _selectedFirmaId = firmaTab.id,
                                    );
                                    context
                                        .read<CreateArkuszCubit>()
                                        .initialize(
                                          firmaId: firmaTab.id,
                                        )
                                        .ignore();
                                  },
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
            ),
          ],
          InventoryUsersSearchPicker(
            label: intl.inventoryOptionalCommission,
            hintText: intl.inventorySearchByNameOrLoginHint,
            enabled: !isSubmitting,
            repository: widget.usersRepository,
            onChanged: (users) {
              final ids = users.map((user) => user.userId).join(',');
              context.read<CreateArkuszCubit>().updateKomisjaRaw(ids);
            },
          ),
          Gaps.h12,
          AppTextField(
            controller: _numerController,
            enabled: !isSubmitting,
            labelText: intl.inventoryNumber,
            hintText: intl.inventoryNumberExampleHint,
            maxLength: inventoryArkuszNumerMaxLength,
            onChanged: (value) {
              context.read<CreateArkuszCubit>().updateNumerRaw(value);
            },
          ),
          Gaps.h12,
          AppText(
            intl.inventoryLocation,
            style: context.text.labelLarge?.copyWith(fontWeight: .w700),
          ),
          Gaps.h4,
          AppText(
            switch (selectedLocationId) {
              null => intl.inventorySelectLocationFromTree,
              _ => intl.inventoryScopeAutoSet,
            },
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          Gaps.h8,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLow,
                borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
                border: Border.all(color: context.colors.outlineVariant),
              ),
              child: locationNodes.isNotEmpty
                  ? AppTree<GetMiejscaItem>(
                      padding: const .all(Sizes.p8),
                      itemSpacing: Sizes.p2,
                      nodes: locationNodes,
                    )
                  : Center(
                      child: AppEmptyState.noData(
                        title: intl.inventoryNoLocationsTitle,
                        message: intl.inventoryLocationsBackendEmptyMessage,
                        compact: true,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  List<AppTreeNode<GetMiejscaItem>> _buildLocationNodes({
    required List<GetMiejscaItem> locations,
    required int? selectedLocationId,
  }) {
    final parentUsesRecordId = createArkuszParentUsesRecordId(locations);
    final locationsByTreeKey = {
      for (final location in locations)
        createArkuszScopedTreeKey(location, parentUsesRecordId): location,
    };
    final childrenByParent =
        <CreateArkuszScopedTreeKey, List<GetMiejscaItem>>{};
    for (final location in locations) {
      final parentKey = createArkuszScopedParentKey(location);
      childrenByParent.putIfAbsent(parentKey, () => []).add(location);
    }

    final roots =
        locations
            .where((location) {
              final parentKey = createArkuszScopedParentKey(location);
              return parentKey.id == 0 ||
                  !locationsByTreeKey.containsKey(parentKey);
            })
            .toList(growable: false)
          ..sort(_compareLocations);

    return roots
        .map(
          (location) => _buildLocationNode(
            location: location,
            childrenByParent: childrenByParent,
            parentUsesRecordId: parentUsesRecordId,
            selectedLocationId: selectedLocationId,
          ),
        )
        .toList(growable: false);
  }

  AppTreeNode<GetMiejscaItem> _buildLocationNode({
    required GetMiejscaItem location,
    required Map<CreateArkuszScopedTreeKey, List<GetMiejscaItem>>
    childrenByParent,
    required bool parentUsesRecordId,
    required int? selectedLocationId,
  }) {
    final children = List<GetMiejscaItem>.from(
      childrenByParent[createArkuszScopedTreeKey(
            location,
            parentUsesRecordId,
          )] ??
          const <GetMiejscaItem>[],
    )..sort(_compareLocations);

    return AppTreeNode<GetMiejscaItem>(
      value: location,
      title: _buildLocationTitle(location),
      titleSpan: _buildLocationTitleSpan(location),
      selected: selectedLocationId == location.id,
      leading: Icon(
        children.isEmpty ? Icons.place_outlined : Icons.keyboard_arrow_right,
        size: Sizes.p18,
      ),
      trailing: selectedLocationId == location.id
          ? Icon(Icons.check_circle_rounded, color: context.colors.primary)
          : null,
      initiallyExpanded: selectedLocationId == location.id,
      children: [
        for (final child in children)
          _buildLocationNode(
            location: child,
            childrenByParent: childrenByParent,
            parentUsesRecordId: parentUsesRecordId,
            selectedLocationId: selectedLocationId,
          ),
      ],
      onTap: (_) {
        context.read<CreateArkuszCubit>().selectLocation(location.id);
      },
    );
  }

  String _buildLocationTitle(GetMiejscaItem location) {
    final intl = context.l10n;
    return switch ((location.nazwa ?? '').trim()) {
      final String name when name.isNotEmpty => name,
      _ => intl.inventoryIdWithValue(location.idMiejsca),
    };
  }

  InlineSpan _buildLocationTitleSpan(GetMiejscaItem location) {
    final intl = context.l10n;
    final baseTitle = switch ((location.nazwa ?? '').trim()) {
      final String name when name.isNotEmpty => name,
      _ => intl.inventoryIdWithValue(location.idMiejsca),
    };
    final level = (location.lvl ?? '').trim();
    if (level.isEmpty) {
      return TextSpan(text: baseTitle);
    }

    return TextSpan(
      children: [
        TextSpan(text: baseTitle),
        TextSpan(
          text: ' ($level)',
          style: const TextStyle(fontStyle: .italic),
        ),
      ],
    );
  }

  int _compareLocations(GetMiejscaItem left, GetMiejscaItem right) {
    final leftName = (left.nazwa ?? '').trim().toLowerCase();
    final rightName = (right.nazwa ?? '').trim().toLowerCase();
    return leftName.compareTo(rightName);
  }
}

/// Sticky footer akcji modala tworzenia arkusza.
class _CreateArkuszModalFooter extends StatelessWidget {
  /// Tworzy sticky footer modala nowego arkusza.
  const _CreateArkuszModalFooter({required this.inventoryId});

  final int inventoryId;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocBuilder<CreateArkuszCubit, CreateArkuszState>(
      builder: (context, state) {
        final isSubmitting = switch (state) {
          CreateArkuszReady(:final isSubmitting) => isSubmitting,
          _ => false,
        };

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
              onPressed: isSubmitting
                  ? null
                  : () => _submit(context, state: state),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit(
    BuildContext context, {
    required CreateArkuszState state,
  }) async {
    final intl = context.l10n;
    if (state is! CreateArkuszReady) {
      return;
    }

    if (state.selectedLocationId == null) {
      context.read<CreateArkuszCubit>().setSubmitError(
        intl.inventorySelectLocationBeforeCreateError,
      );
      return;
    }

    final parsedKomisja = _parseIds(state.komisjaRaw);
    if (parsedKomisja == null) {
      context.read<CreateArkuszCubit>().setSubmitError(
        intl.inventoryInvalidCommissionFormatError,
      );
      return;
    }

    // `subtree` jest celowo wylaczone w UI dla zgodnosci z Delphi:
    // stary klient przekazywal do `CREATE_ARS` jedno `IDMIEJSCA`.
    const scope = 'node';

    await context.read<CreateArkuszCubit>().submit(
      inventoryId: inventoryId,
      scope: scope,
      komisja: parsedKomisja.isEmpty ? null : parsedKomisja,
    );
  }

  List<int>? _parseIds(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return const [];
    }

    final parts = normalized
        .split(RegExp(r'[;,\s]+'))
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    final parsed = <int>[];
    for (final value in parts) {
      final id = int.tryParse(value);
      if (id == null) {
        return null;
      }
      parsed.add(id);
    }
    return parsed;
  }
}
