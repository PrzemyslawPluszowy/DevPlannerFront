import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/cubit/inventory_users_search_cubit.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/cubit/inventory_users_search_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Reuzywalny picker wyszukiwarki i wyboru wielu uzytkownikow.
class InventoryUsersSearchPicker extends StatefulWidget {
  /// Tworzy picker wyszukiwarki uzytkownikow.
  const InventoryUsersSearchPicker({
    required this.onChanged,
    super.key,
    this.label,
    this.hintText,
    this.initialSelected = const <GetReadyUsersSearchItem>[],
    this.enabled = true,
    this.repository,
  });

  /// Callback z aktualna lista zaznaczonych uzytkownikow.
  final ValueChanged<List<GetReadyUsersSearchItem>> onChanged;

  /// Etykieta pola.
  final String? label;

  /// Podpowiedz pola wyszukiwania.
  final String? hintText;

  /// Wartosc poczatkowa.
  final List<GetReadyUsersSearchItem> initialSelected;

  /// Czy kontrolka jest aktywna.
  final bool enabled;

  /// Opcjonalnie jawnie przekazane repozytorium wyszukiwarki.
  final UsersRepository? repository;

  static const double _preferredSearchWidth = 420;
  static const double _suggestionsMaxHeight = 220;

  @override
  State<InventoryUsersSearchPicker> createState() =>
      _InventoryUsersSearchPickerState();
}

/// Stan lokalny pickera wyszukiwarki uzytkownikow.
class _InventoryUsersSearchPickerState
    extends State<InventoryUsersSearchPicker> {
  late final List<GetReadyUsersSearchItem> _selected;
  late final SearchController _searchController;

  @override
  void initState() {
    super.initState();
    _selected = List<GetReadyUsersSearchItem>.from(widget.initialSelected);
    _searchController = SearchController();
  }

  @override
  void didUpdateWidget(covariant InventoryUsersSearchPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelected != widget.initialSelected) {
      _selected
        ..clear()
        ..addAll(widget.initialSelected);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocProvider(
      create: (context) => InventoryUsersSearchCubit(
        repository: widget.repository ?? context.read<UsersRepository>(),
      ),
      child: BlocBuilder<InventoryUsersSearchCubit, InventoryUsersSearchState>(
        builder: (context, state) {
          final cubit = context.read<InventoryUsersSearchCubit>();
          final options = state.results
              .where(
                (user) => !_selected.any(
                  (selected) => selected.userId == user.userId,
                ),
              )
              .take(10)
              .map(
                (user) {
                  final subtitle = _buildSubtitle(user);
                  return AppSearchDropdownOption<GetReadyUsersSearchItem>(
                    value: user,
                    label: user.displayName,
                    subtitle: subtitle,
                    icon: Icons.person_outline_rounded,
                    keywords: [
                      user.displayName,
                      if (user.firnam != null) user.firnam!,
                      if (user.lasnam != null) user.lasnam!,
                      if (user.usrnam != null) user.usrnam!,
                      if (user.eMail != null) user.eMail!,
                      if (user.usrsym != null) user.usrsym!,
                      if (user.login != null) user.login!,
                    ],
                  );
                },
              )
              .toList(growable: false);

          return Column(
            crossAxisAlignment: .start,
            children: [
              AppText(
                widget.label ?? intl.inventoryCommissionLabel,
                style: context.text.labelLarge?.copyWith(fontWeight: .w700),
              ),
              Gaps.h8,
              IgnorePointer(
                ignoring: !widget.enabled,
                child: Opacity(
                  opacity: widget.enabled ? 1 : .6,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = switch (constraints.maxWidth) {
                        final value when value.isFinite =>
                          value
                              .clamp(
                                0,
                                InventoryUsersSearchPicker
                                    ._preferredSearchWidth,
                              )
                              .toDouble(),
                        _ => InventoryUsersSearchPicker._preferredSearchWidth,
                      };

                      return AppSearchDropdown<GetReadyUsersSearchItem>(
                        width: width,
                        viewMaxHeight:
                            InventoryUsersSearchPicker._suggestionsMaxHeight,
                        options: options,
                        searchController: _searchController,
                        hintText:
                            widget.hintText ?? intl.inventorySearchUserHint,
                        noResultsText: switch (state) {
                          InventoryUsersSearchError(:final message) => message,
                          InventoryUsersSearchLoading() =>
                            intl.inventorySearching,
                          _ when _searchController.text.trim().length < 2 =>
                            intl.inventoryTypeMinTwoChars,
                          _ => intl.inventoryNoResults,
                        },
                        onChanged: cubit.onQueryChanged,
                        onSelected: (option) => _select(option.value, cubit),
                        closeWithSelectedLabel: false,
                        isLoading: state is InventoryUsersSearchLoading,
                      );
                    },
                  ),
                ),
              ),
              Gaps.h8,
              if (_selected.isEmpty)
                AppEmptyState.noData(
                  title: intl.inventoryNoSelectedPeopleTitle,
                  message: intl.inventoryNoSelectedPeopleMessage,
                  compact: true,
                )
              else
                Wrap(
                  spacing: Sizes.p8,
                  runSpacing: Sizes.p8,
                  children: _selected
                      .map(
                        (user) => AppActionChip(
                          label: user.displayName,
                          icon: Icons.person_outline_rounded,
                          onPressed: widget.enabled
                              ? () => _remove(user.userId)
                              : null,
                        ),
                      )
                      .toList(growable: false),
                ),
            ],
          );
        },
      ),
    );
  }

  void _select(
    GetReadyUsersSearchItem user,
    InventoryUsersSearchCubit cubit,
  ) {
    if (_selected.any((selected) => selected.userId == user.userId)) {
      return;
    }
    setState(() => _selected.add(user));
    widget.onChanged(List<GetReadyUsersSearchItem>.unmodifiable(_selected));
    _searchController.clear();
    cubit.clear();
  }

  void _remove(int userId) {
    setState(() => _selected.removeWhere((user) => user.userId == userId));
    widget.onChanged(List<GetReadyUsersSearchItem>.unmodifiable(_selected));
  }

  String? _buildSubtitle(GetReadyUsersSearchItem user) {
    final parts = <String>[];
    if (user.login case final login? when login.trim().isNotEmpty) {
      parts.add(login.trim());
    }
    if (user.usrsym case final symbol? when symbol.trim().isNotEmpty) {
      parts.add(symbol.trim());
    }
    if (parts.isEmpty) {
      return null;
    }
    return parts.join(' • ');
  }
}
