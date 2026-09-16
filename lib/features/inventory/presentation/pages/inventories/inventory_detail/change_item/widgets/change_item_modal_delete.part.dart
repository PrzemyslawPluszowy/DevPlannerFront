part of '../change_item_modal.dart';

Future<bool?> _showDeleteArkuszElementModal(
  BuildContext context, {
  required int arkuszId,
  required GetArkuszDetailsElementItem item,
  required InventoriesRepository repository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventoryDeleteItemTitle,
    subtitle: context.l10n.inventoryDeleteItemSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => DeleteArkuszElementCubit(repository: repository),
      child: _DeleteArkuszElementModalBody(
        arkuszId: arkuszId,
        item: item,
      ),
    ),
  );
}

/// Body modalu usuwania pojedynczego elementu arkusza.
class _DeleteArkuszElementModalBody extends StatefulWidget {
  /// Tworzy body modalu usuwania elementu.
  const _DeleteArkuszElementModalBody({
    required this.arkuszId,
    required this.item,
  });

  /// Identyfikator arkusza zawierajacego element.
  final int arkuszId;

  /// Element przeznaczony do usuniecia.
  final GetArkuszDetailsElementItem item;

  @override
  State<_DeleteArkuszElementModalBody> createState() =>
      _DeleteArkuszElementModalBodyState();
}

/// Stan modalu usuwania pojedynczego elementu arkusza.
class _DeleteArkuszElementModalBodyState
    extends State<_DeleteArkuszElementModalBody> {
  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;

    return BlocConsumer<DeleteArkuszElementCubit, DeleteArkuszElementState>(
      listener: (context, state) {
        switch (state) {
          case DeleteArkuszElementSuccess():
            AppToast.show(
              context,
              tone: AppToastTone.success,
              message: context.l10n.inventoryDeleteItemSuccessMessage,
            );
            Navigator.of(context).pop(true);
          case DeleteArkuszElementError():
          case DeleteArkuszElementInitial():
          case DeleteArkuszElementSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is DeleteArkuszElementSubmitting;
        final errorMessage = switch (state) {
          DeleteArkuszElementError(:final message) => message,
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
                border: Border.all(color: colors.error.withValues(alpha: .24)),
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
                          intl.inventoryDeleteItemTitle,
                          style: context.text.titleSmall?.copyWith(
                            color: colors.onErrorContainer,
                            fontWeight: .w700,
                          ),
                        ),
                        Gaps.h8,
                        AppText(
                          context.l10n.inventoryDeleteItemDetailsMessage(
                            widget.item.id,
                            _displayValue(widget.item.nrewid),
                            _displayValue(widget.item.nazwa),
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
                      : () => context.read<DeleteArkuszElementCubit>().submit(
                          arkuszId: widget.arkuszId,
                          elementId: widget.item.id,
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
