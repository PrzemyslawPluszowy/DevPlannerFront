part of '../inventory_companies_page.dart';

class _CompaniesList extends StatelessWidget {
  const _CompaniesList({required this.companies});

  final List<GetFirmyItem> companies;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    if (companies.isEmpty) {
      return Padding(
        padding: const .only(top: Sizes.p16),
        child: AppEmptyState.noResults(
          title: intl.inventoryCompaniesEmptyTitle,
          message: intl.inventoryCompaniesEmptyMessage,
          compact: true,
        ),
      );
    }

    return ListView.separated(
      padding: const .only(bottom: Sizes.p16),
      itemCount: companies.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        thickness: 1,
        color: context.colors.outlineVariant.withValues(alpha: .32),
      ),
      itemBuilder: (context, index) => _CompanyRow(
        item: companies[index],
        onDeleted: () =>
            unawaited(context.read<CompaniesCubit>().load(forceRefresh: true)),
      ),
    );
  }
}

class _CompanyRow extends StatelessWidget {
  const _CompanyRow({required this.item, required this.onDeleted});

  final GetFirmyItem item;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final title = item.nazwa.trim().isEmpty
        ? intl.inventoryNoName
        : item.nazwa.trim();

    return AppCompactListTile(
      title: title,
      titleSelectable: true,
      subtitle: intl.inventoryCompanyIdLabel(item.idFirmy),
      leading: const AppIcon(
        Icons.business_outlined,
        tone: AppIconTone.primary,
      ),
      footer: Align(
        alignment: .centerRight,
        child: AppActionChip(
          label: intl.delete,
          icon: Icons.delete_outline_rounded,
          tone: AppActionChipTone.danger,
          onPressed: () {
            unawaited(() async {
              final deleted = await _showDeleteCompanyModal(
                context,
                company: item,
              );
              if (!context.mounted || deleted != true) {
                return;
              }

              AppToast.show(
                context,
                message: intl.inventoryCompanyDeletedMessage,
                tone: AppToastTone.success,
              );
              onDeleted();
            }());
          },
        ),
      ),
    );
  }
}

Future<bool?> _showDeleteCompanyModal(
  BuildContext context, {
  required GetFirmyItem company,
}) {
  final repository = context.read<StockRepository>();

  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventoryDeleteCompanyTitle,
    subtitle: context.l10n.inventoryDeleteCompanySubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => DeleteCompanyCubit(repository: repository),
      child: _DeleteCompanyModalBody(company: company),
    ),
  );
}

/// Body modalu usuwania firmy.
class _DeleteCompanyModalBody extends StatelessWidget {
  const _DeleteCompanyModalBody({required this.company});
  final GetFirmyItem company;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;

    return BlocConsumer<DeleteCompanyCubit, DeleteCompanyState>(
      listener: (context, state) {
        switch (state) {
          case DeleteCompanySuccess():
            Navigator.of(context).pop(true);
          case DeleteCompanyError(:final message):
            AppToast.show(
              context,
              message: message,
              tone: AppToastTone.error,
            );
          case DeleteCompanyInitial():
          case DeleteCompanySubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is DeleteCompanySubmitting;
        final errorMessage = switch (state) {
          DeleteCompanyError(:final message) => message,
          _ => null,
        };

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
                border: Border.all(
                  color: colors.error.withValues(alpha: .24),
                ),
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
                          intl.inventoryDeleteCompanyConfirmTitle,
                          style: context.text.titleSmall?.copyWith(
                            color: colors.onErrorContainer,
                            fontWeight: .w700,
                          ),
                        ),
                        Gaps.h8,
                        AppText(
                          intl.inventoryDeleteCompanyConfirmBody(
                            company.nazwa,
                            company.idFirmy,
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
            if (errorMessage != null) ...[
              Gaps.h12,
              AppText(
                errorMessage,
                style: context.text.bodySmall?.copyWith(
                  color: colors.error,
                  fontWeight: .w600,
                ),
              ),
            ],
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
                  label: intl.delete,
                  icon: Icons.delete_outline_rounded,
                  tone: .danger,
                  onPressedAsync: isSubmitting
                      ? null
                      : () => context.read<DeleteCompanyCubit>().submit(
                          companyId: company.id,
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
