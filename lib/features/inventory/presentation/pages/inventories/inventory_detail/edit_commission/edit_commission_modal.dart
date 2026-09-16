import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/edit_commission/cubit/edit_commission_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/edit_commission/cubit/edit_commission_state.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/inventory_users_search_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera modal edycji komisji.
Future<bool?> showEditCommissionModal(
  BuildContext context, {
  required String title,
  required String subtitle,
  required int targetId,
  required EditCommissionTargetType targetType,
  required List<GetReadyUsersSearchItem> initialSelected,
  required InventoriesRepository inventoriesRepository,
  required UsersRepository usersRepository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: title,
    subtitle: subtitle,
    body: BlocProvider(
      create: (context) => EditCommissionCubit(
        repository: inventoriesRepository,
        targetType: targetType,
        targetId: targetId,
      ),
      child: _EditCommissionBody(
        initialSelected: initialSelected,
        usersRepository: usersRepository,
      ),
    ),
  );
}

/// Zawartosc modala edycji komisji.
class _EditCommissionBody extends StatefulWidget {
  /// Tworzy body modala edycji komisji.
  const _EditCommissionBody({
    required this.initialSelected,
    required this.usersRepository,
  });

  /// Poczatkowo wybrani uzytkownicy komisji.
  final List<GetReadyUsersSearchItem> initialSelected;

  /// Repozytorium wyszukiwarki uzytkownikow.
  final UsersRepository usersRepository;

  @override
  State<_EditCommissionBody> createState() => _EditCommissionBodyState();
}

/// Stan formularza edycji komisji.
class _EditCommissionBodyState extends State<_EditCommissionBody> {
  static const int _minCommissionUsersCount = 2;

  late List<int> _commissionUserIds;
  String? _commissionError;

  @override
  void initState() {
    super.initState();
    _commissionUserIds = widget.initialSelected
        .map((user) => user.userId)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditCommissionCubit, EditCommissionState>(
      listener: (context, state) {
        switch (state) {
          case EditCommissionSaved():
            Navigator.of(context).pop(true);
            AppToast.show(
              context,
              tone: AppToastTone.success,
              message: context.l10n.inventoryCommissionSavedMessage,
            );
          case EditCommissionReady() || EditCommissionSending():
            break;
        }
      },
      builder: (context, state) {
        final isSending = state is EditCommissionSending;
        final submitError = switch (state) {
          EditCommissionReady(:final submitError) => submitError,
          EditCommissionSending() || EditCommissionSaved() => null,
        };

        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
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
            InventoryUsersSearchPicker(
              hintText: context.l10n.inventorySearchPersonHint,
              initialSelected: widget.initialSelected,
              enabled: !isSending,
              repository: widget.usersRepository,
              onChanged: (users) {
                setState(() {
                  _commissionError = null;
                  _commissionUserIds = users
                      .map((user) => user.userId)
                      .toList(growable: false);
                });
              },
            ),
            if (_commissionError case final String message
                when message.trim().isNotEmpty) ...[
              Gaps.h8,
              AppText(
                message.trim(),
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                  fontWeight: .w600,
                ),
              ),
            ],
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: context.l10n.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isSending
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: context.l10n.save,
                  icon: Icons.check_rounded,
                  onPressed: isSending ? null : _onSubmit,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _onSubmit() {
    if (_commissionUserIds.length < _minCommissionUsersCount) {
      setState(() {
        _commissionError = context.l10n.inventorySelectMinTwoCommissionUsers;
      });
      return;
    }

    context.read<EditCommissionCubit>().submit(_commissionUserIds).ignore();
  }
}
