import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Pole numeru ewidencyjnego z podpowiedziami z `stan_st` i wolnym wpisem.
class InventoryRegisterNumberSuggestionField extends StatefulWidget {
  /// Tworzy pole numeru ewidencyjnego z wyszukiwarka `stan_st`.
  const InventoryRegisterNumberSuggestionField({
    required this.repository,
    required this.companyIds,
    required this.controller,
    required this.enabled,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    super.key,
  });

  /// Repozytorium `stan_st`.
  final StockRepository repository;

  /// Firmy inwentaryzacji ograniczajace wyniki podpowiedzi.
  final List<int> companyIds;

  /// Kontroler pola tekstowego i wyszukiwarki.
  final SearchController controller;

  /// Czy pole jest aktywne.
  final bool enabled;

  /// Etykieta pola.
  final String labelText;

  /// Tekst podpowiedzi dla pola.
  final String hintText;

  /// Callback wywolywany po zmianie wartosci pola.
  final VoidCallback onChanged;

  @override
  State<InventoryRegisterNumberSuggestionField> createState() =>
      _InventoryRegisterNumberSuggestionFieldState();
}

class _InventoryRegisterNumberSuggestionFieldState
    extends State<InventoryRegisterNumberSuggestionField> {
  List<GetStanStItem> _results = const [];
  GetStanStItem? _selectedItem;
  String? _errorMessage;
  bool _isLoading = false;
  int _requestSequence = 0;

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.text.labelSmall?.copyWith(
      color: context.colors.onSurfaceVariant,
      fontWeight: .w600,
      height: 1,
    );
    final options = _results
        .take(50)
        .map(
          (item) => AppSearchDropdownOption<GetStanStItem>(
            value: item,
            label: item.nrewid?.trim().isNotEmpty == true
                ? item.nrewid!.trim()
                : '-',
            subtitle: _subtitle(item),
            icon: Icons.inventory_2_outlined,
            keywords: [
              ?item.nrewid,
              ?item.nazwa,
              ?item.osoba,
              ?item.miejsce,
              ?item.kodKreskowy?.toString(),
            ],
          ),
        )
        .toList(growable: false);

    return Column(
      crossAxisAlignment: .start,
      children: [
        AppText(widget.labelText, style: labelStyle),
        Gaps.h4,
        Focus(
          onKeyEvent: widget.enabled
              ? (_, event) {
                  if (event is! KeyDownEvent ||
                      event.logicalKey != LogicalKeyboardKey.enter) {
                    return KeyEventResult.ignored;
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.onChanged();
                  _clearResults();
                  return KeyEventResult.handled;
                }
              : null,
          child: IgnorePointer(
            ignoring: !widget.enabled,
            child: Opacity(
              opacity: widget.enabled ? 1 : .6,
              child: AppSearchDropdown<GetStanStItem>(
                searchController: widget.controller,
                hintText: widget.hintText,
                options: options,
                noResultsText: switch ((
                  _errorMessage,
                  widget.controller.text,
                )) {
                  (final String message?, _) => message,
                  (_, final String text) when text.trim().length < 2 =>
                    'Wpisz min. 2 znaki',
                  _ =>
                    'Po Enter zostanie wpisany recznie podany nr ewidencyjny',
                },
                onChanged: _handleChanged,
                onChangedDebounced: _onQueryChanged,
                onSelected: (option) {
                  setState(() => _selectedItem = option.value);
                  widget.onChanged();
                  _clearResults();
                },
                isLoading: _isLoading,
              ),
            ),
          ),
        ),
        if (_selectedItem case final item?) ...[
          Gaps.h8,
          _SelectedItemInfoCard(item: item),
        ],
      ],
    );
  }

  void _handleChanged(String _) {
    final selectedNrewid = _selectedItem?.nrewid?.trim();
    final currentValue = widget.controller.text.trim();
    if (selectedNrewid != null && selectedNrewid != currentValue) {
      setState(() => _selectedItem = null);
    }
    widget.onChanged();
  }

  Future<void> _onQueryChanged(String value) async {
    final query = value.trim();
    if (query.length < 2) {
      if (!mounted) {
        return;
      }
      setState(() {
        _results = const [];
        _errorMessage = null;
        _isLoading = false;
      });
      return;
    }

    final requestId = ++_requestSequence;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final results = await Future.wait(
      widget.companyIds.map(
        (companyId) => widget.repository.fetchStock(
          GetStanStQuery(
            firma: companyId,
            limit: 100,
            offset: 0,
            nrewid: query,
          ),
        ),
      ),
    );

    if (!mounted || requestId != _requestSequence) {
      return;
    }

    final items = <GetStanStItem>[];
    final errors = <String>[];

    for (final result in results) {
      result.fold(
        (error) => errors.add(error.message),
        (data) => items.addAll(data.items),
      );
    }

    setState(() {
      _results = _prioritizeResults(
        _deduplicateResults(items),
        query: query,
      );
      _errorMessage = items.isEmpty && errors.isNotEmpty ? errors.first : null;
      _isLoading = false;
    });
  }

  List<GetStanStItem> _deduplicateResults(List<GetStanStItem> items) {
    final seen = <int>{};
    final unique = <GetStanStItem>[];

    for (final item in items) {
      if (!seen.add(item.id)) {
        continue;
      }
      unique.add(item);
    }

    return unique;
  }

  List<GetStanStItem> _prioritizeResults(
    List<GetStanStItem> items, {
    required String query,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return items;
    }

    final rankedItems = items.indexed.toList(growable: false)
      ..sort((left, right) {
        final rankComparison =
            _matchRank(
              left.$2,
              normalizedQuery,
            ).compareTo(
              _matchRank(
                right.$2,
                normalizedQuery,
              ),
            );
        if (rankComparison != 0) {
          return rankComparison;
        }
        return left.$1.compareTo(right.$1);
      });

    return rankedItems.map((entry) => entry.$2).toList(growable: false);
  }

  int _matchRank(GetStanStItem item, String normalizedQuery) {
    final normalizedNrewid = item.nrewid?.trim().toLowerCase();
    if (normalizedNrewid == null || normalizedNrewid.isEmpty) {
      return 3;
    }
    if (normalizedNrewid == normalizedQuery) {
      return 0;
    }
    if (normalizedNrewid.startsWith(normalizedQuery)) {
      return 1;
    }
    if (normalizedNrewid.contains(normalizedQuery)) {
      return 2;
    }
    return 3;
  }

  void _clearResults() {
    if (!mounted) {
      return;
    }
    setState(() {
      _results = const [];
      _errorMessage = null;
      _isLoading = false;
    });
  }

  String? _subtitle(GetStanStItem item) {
    final parts = <String>[];
    if (item.nazwa case final name? when name.trim().isNotEmpty) {
      parts.add(name.trim());
    }
    if (item.osoba case final person? when person.trim().isNotEmpty) {
      parts.add(person.trim());
    }
    if (item.miejsce case final place? when place.trim().isNotEmpty) {
      parts.add(place.trim());
    }
    return switch (parts) {
      [] => null,
      _ => parts.join(' • '),
    };
  }
}

class _SelectedItemInfoCard extends StatelessWidget {
  const _SelectedItemInfoCard({required this.item});

  final GetStanStItem item;

  @override
  Widget build(BuildContext context) {
    final rows = <({String label, String value})>[
      if (_valueOrNull(item.nazwa) case final value?)
        (label: 'Nazwa', value: value),
      if (_valueOrNull(item.osoba) case final value?)
        (label: 'Osoba', value: value),
      if (_valueOrNull(item.miejsce) case final value?)
        (label: 'Miejsce', value: value),
      if (_valueOrNull(item.kodKreskowy?.toString()) case final value?)
        (label: 'Kod kreskowy', value: value),
      if (_formatOptionalDate(item.dataZakupu) case final value?)
        (label: 'Data zakupu', value: value),
    ];

    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p10),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: rows
            .map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p2),
                child: RichText(
                  text: TextSpan(
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: '${row.label}: ',
                        style: context.text.bodySmall?.copyWith(
                          fontWeight: .w700,
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      TextSpan(text: row.value),
                    ],
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  String? _valueOrNull(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  String? _formatOptionalDate(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(normalized));
    } catch (_) {
      return normalized;
    }
  }
}
