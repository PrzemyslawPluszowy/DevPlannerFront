part of '../inventory_overview_page.dart';

Future<bool?> _showDeleteStanStModal(
  BuildContext context, {
  required GetStanStItem item,
  required StockRepository repository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventoryDeleteStockTitle,
    subtitle: context.l10n.inventoryDeleteStockSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => DeleteStanStCubit(repository: repository),
      child: _DeleteStanStModalBody(item: item),
    ),
  );
}

/// Body modalu usuwania pojedynczego rekordu `stan_st`.
class _DeleteStanStModalBody extends StatefulWidget {
  /// Tworzy body modalu potwierdzenia usuniecia rekordu.
  const _DeleteStanStModalBody({required this.item});

  /// Rekord `stan_st` przeznaczony do usuniecia.
  final GetStanStItem item;

  @override
  State<_DeleteStanStModalBody> createState() => _DeleteStanStModalBodyState();
}

/// Stan modalu usuwania rekordu `stan_st`.
class _DeleteStanStModalBodyState extends State<_DeleteStanStModalBody> {
  final TextEditingController _registerController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _registerController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String _normalize(String? value) => value?.trim().toLowerCase() ?? '';

  bool get _isConfirmationMatching {
    final expectedRegister = _normalize(widget.item.nrewid);
    final expectedName = _normalize(widget.item.nazwa);

    return expectedRegister.isNotEmpty &&
        expectedName.isNotEmpty &&
        _normalize(_registerController.text) == expectedRegister &&
        _normalize(_nameController.text) == expectedName;
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;

    return BlocConsumer<DeleteStanStCubit, DeleteStanStState>(
      listener: (context, state) {
        switch (state) {
          case DeleteStanStSuccess():
            AppToast.show(
              context,
              tone: AppToastTone.success,
              message: intl.inventoryDeleteStockSuccessMessage,
            );
            Navigator.of(context).pop(true);
          case DeleteStanStError(:final message):
            AppToast.show(
              context,
              tone: AppToastTone.error,
              message: message,
            );
          case DeleteStanStInitial():
          case DeleteStanStSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is DeleteStanStSubmitting;
        final errorMessage = switch (state) {
          DeleteStanStError(:final message) => message,
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
                          intl.inventoryDeleteStockConfirmTitle,
                          style: context.text.titleSmall?.copyWith(
                            color: colors.onErrorContainer,
                            fontWeight: .w700,
                          ),
                        ),
                        Gaps.h8,
                        AppText(
                          intl.inventoryDeleteStockConfirmBody(
                            widget.item.id,
                            widget.item.nrewid?.trim().isNotEmpty == true
                                ? widget.item.nrewid!.trim()
                                : intl.inventoryNoData,
                            widget.item.nazwa?.trim().isNotEmpty == true
                                ? widget.item.nazwa!.trim()
                                : intl.inventoryNoData,
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
            Gaps.h12,
            AppText(
              intl.inventoryDeleteStockHelper,
              style: context.text.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
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
            Gaps.h12,
            AppTextField(
              controller: _registerController,
              enabled: !isSubmitting,
              labelText: intl.inventoryDeleteStockRegisterLabel,
              hintText: widget.item.nrewid ?? intl.inventoryNoData,
              onChanged: (_) => setState(() {}),
            ),
            Gaps.h12,
            AppTextField(
              controller: _nameController,
              enabled: !isSubmitting,
              labelText: intl.inventoryDeleteStockNameLabel,
              hintText: widget.item.nazwa ?? intl.inventoryNoName,
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
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: intl.delete,
                  icon: Icons.delete_outline_rounded,
                  tone: .danger,
                  onPressedAsync: isSubmitting || !_isConfirmationMatching
                      ? null
                      : () => context.read<DeleteStanStCubit>().submit(
                          stockItemId: widget.item.id,
                          confirmNrewid: _registerController.text.trim(),
                          confirmNazwa: _nameController.text.trim(),
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
