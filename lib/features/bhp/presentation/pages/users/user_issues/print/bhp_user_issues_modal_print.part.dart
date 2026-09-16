part of '../bhp_user_issues_modal.dart';

/// Obsługa wydruków karty wydań pracownika.
extension _BhpUserIssuesModalPrint on _BhpUserIssuesModalBodyState {
  Future<List<GetBhpUserIssue>?> _showPrintOptionsDialog(
    BuildContext context,
    List<GetBhpUserIssue> items,
  ) async {
    final activeItems = items
        .where((item) => item.isActive)
        .toList(
          growable: false,
        );
    final selectedIds = <int>{
      ...activeItems.map((item) => item.id),
    };

    return showDialog<List<GetBhpUserIssue>>(
      context: context,
      builder: (context) {
        final intl = context.l10n;
        final maxHeight = MediaQuery.sizeOf(context).height * .72;

        return StatefulBuilder(
          builder: (context, setState) {
            void setSelection(Iterable<GetBhpUserIssue> selection) {
              setState(() {
                selectedIds
                  ..clear()
                  ..addAll(selection.map((item) => item.id));
              });
            }

            final inactiveItems = items
                .where((item) => !item.isActive)
                .toList(growable: false);
            final selectedItems = items
                .where((item) => selectedIds.contains(item.id))
                .toList(growable: false);
            final activeSelected =
                selectedIds.length == activeItems.length &&
                selectedIds.containsAll(activeItems.map((item) => item.id));
            final inactiveSelected =
                inactiveItems.isNotEmpty &&
                selectedIds.length == inactiveItems.length &&
                selectedIds.containsAll(
                  inactiveItems.map((item) => item.id),
                );
            final allSelected = selectedIds.length == items.length;

            return AlertDialog(
              title: Text(
                intl.bhpUserIssuesPrintSelectTitle,
                style: context.text.titleLarge?.copyWith(fontWeight: .bold),
              ),
              content: SizedBox(
                width: 760,
                height: maxHeight,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Wrap(
                      spacing: Sizes.p8,
                      runSpacing: Sizes.p8,
                      children: [
                        AppActionChip(
                          label: intl.bhpUserIssuesPrintOnlyActive,
                          icon: Icons.check_circle_outline_rounded,
                          selected: activeSelected,
                          tone: .primary,
                          onPressed: () => setSelection(activeItems),
                        ),
                        AppActionChip(
                          label: intl.bhpUserIssuesPrintOnlyInactive,
                          icon: Icons.pause_circle_outline_rounded,
                          selected: inactiveSelected,
                          tone: .primary,
                          onPressed: () => setSelection(inactiveItems),
                        ),
                        AppActionChip(
                          label: intl.bhpUserIssuesPrintAll,
                          icon: Icons.select_all_rounded,
                          selected: allSelected,
                          tone: .primary,
                          onPressed: () => setSelection(items),
                        ),
                      ],
                    ),
                    Gaps.h12,
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.surfaceContainerLowest,
                          borderRadius: const BorderRadius.all(
                            .circular(Sizes.p12),
                          ),
                          border: Border.all(
                            color: context.colors.outlineVariant,
                          ),
                        ),
                        child: items.isEmpty
                            ? Center(
                                child: AppEmptyState.noData(
                                  title: intl.bhpUserIssuesPrintEmptyTitle,
                                  message: intl.bhpUserIssuesPrintEmptyMessage,
                                ),
                              )
                            : ListView.separated(
                                padding: const .all(Sizes.p12),
                                itemCount: items.length,
                                separatorBuilder: (context, index) => Gaps.h8,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final isSelected = selectedIds.contains(
                                    item.id,
                                  );

                                  return CheckboxListTile(
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedIds.add(item.id);
                                        } else {
                                          selectedIds.remove(item.id);
                                        }
                                      });
                                    },
                                    title: Text(
                                      _buildIssuePrintLabel(context, item),
                                      style: context.text.bodyMedium?.copyWith(
                                        fontWeight: .w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      item.isActive
                                          ? context.l10n.bhpStatusActive
                                          : context.l10n.bhpStatusInactive,
                                      style: context.text.bodySmall?.copyWith(
                                        color: context.colors.onSurfaceVariant,
                                      ),
                                    ),
                                    secondary: AppStatusBadge(
                                      label: item.isActive
                                          ? context.l10n.bhpStatusActive
                                          : context.l10n.bhpStatusInactive,
                                      tone: item.isActive
                                          ? AppStatusBadgeTone.success
                                          : AppStatusBadgeTone.warning,
                                      icon: item.isActive
                                          ? Icons.check_circle_outline_rounded
                                          : Icons.pause_circle_outline_rounded,
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    contentPadding: EdgeInsets.zero,
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                AppActionButton.text(
                  label: context.l10n.cancel,
                  icon: Icons.close_rounded,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                AppActionButton.filled(
                  label: context.l10n.bhpUserIssuesPrintSelectedAction,
                  icon: Icons.print_rounded,
                  onPressed: selectedItems.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(selectedItems),
                ),
              ],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(.circular(Sizes.p16)),
              ),
              backgroundColor: context.colors.surfaceContainerLow,
            );
          },
        );
      },
    );
  }

  Future<void> _handlePrintCard(
    BuildContext context,
    GetBhpUserDetail detail,
    GetBhpUserListItem user,
  ) async {
    final l10n = context.l10n;
    final selectedItems = await _showPrintOptionsDialog(
      context,
      detail.historiaWydan,
    );
    if (selectedItems == null) {
      return;
    }

    try {
      final pdfBytes = await buildBhpUserIssuesCardPdf(
        l10n: l10n,
        user: user,
        detail: detail,
        items: selectedItems,
      );
      if (!context.mounted) {
        return;
      }
      await Printing.layoutPdf(
        name: 'karta_bhp_${_buildSafePdfName(user)}.pdf',
        onLayout: (_) async => pdfBytes,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      AppToast.show(
        context,
        message: context.l10n.bhpUserIssuesPrintCardError('$error'),
        tone: AppToastTone.error,
      );
    }
  }

  String _buildIssuePrintLabel(BuildContext context, GetBhpUserIssue item) {
    final intl = context.l10n;
    final symbol = item.kartaWyposazeniaSymbol?.trim();
    final name = item.kartaWyposazeniaNazwa?.trim();
    final parts = [
      if (symbol case final value? when value.isNotEmpty) value,
      if (name case final value? when value.isNotEmpty) value,
    ];

    if (parts.isEmpty) {
      return intl.bhpUserIssuesPrintIssueLabelFallback(item.id);
    }

    return parts.join(' - ');
  }

  String _buildSafePdfName(GetBhpUserListItem user) {
    final normalized = user.fullName
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '-');
    return normalized.isEmpty ? 'pracownik' : normalized;
  }
}
