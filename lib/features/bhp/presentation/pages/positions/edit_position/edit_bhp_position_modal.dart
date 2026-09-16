import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/archive_position/archive_position_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/edit_position/cubit/edit_bhp_position_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/edit_position/cubit/edit_bhp_position_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_form/position_form_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/position_standards_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera boczny formularz edycji stanowiska BHP.
Future<GetBhpPositionListItem?> showEditBhpPositionModal(
  BuildContext context, {
  required GetBhpPositionListItem item,
}) {
  final positionsRepository = context.read<BhpPositionsRepository>();
  final equipmentRepository = context.read<BhpEquipmentRepository>();

  return AppModalSheet.showSideSheet<GetBhpPositionListItem>(
    context,
    title: 'Edytuj stanowisko BHP',
    subtitle: item.nazwa,
    size: AppModalSheetSize.large,
    width: 1320,
    body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => EditBhpPositionCubit(
            item: item,
            repository: positionsRepository,
          ),
        ),
        BlocProvider(
          create: (_) {
            final cubit = BhpPositionStandardsCubit(
              position: item,
              positionsRepository: positionsRepository,
              equipmentRepository: equipmentRepository,
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: _EditBhpPositionModalBody(
        item: item,
      ),
    ),
  );
}

/// Treść modala edycji stanowiska BHP.
class _EditBhpPositionModalBody extends StatefulWidget {
  /// Tworzy treść modala edycji stanowiska.
  const _EditBhpPositionModalBody({required this.item});

  /// Edytowane stanowisko.
  final GetBhpPositionListItem item;

  @override
  State<_EditBhpPositionModalBody> createState() =>
      _EditBhpPositionModalBodyState();
}

/// Stan treści modala edycji stanowiska BHP.
class _EditBhpPositionModalBodyState extends State<_EditBhpPositionModalBody> {
  late GetBhpPositionListItem _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditBhpPositionCubit, EditBhpPositionState>(
      listener: (context, state) {
        if (state case EditBhpPositionSuccess(:final item)) {
          setState(() => _currentItem = item);
          AppToast.show(
            context,
            message: 'Zapisano stanowisko ${item.nazwa}.',
            tone: AppToastTone.success,
          );
        }
      },
      builder: (context, state) => AppSectionCard(
        padding: const .all(Sizes.p20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _buildQuickActions(context),
            Gaps.h16,
            BhpPositionStandardsContent(
              position: _currentItem,
              showPositionSummary: false,
              showInlineAddAction: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      spacing: Sizes.p8,
      runSpacing: Sizes.p8,
      children: [
        IconButton.filledTonal(
          tooltip: 'Zmień nazwę stanowiska',
          onPressed: () => showBhpPositionQuickEditModal(
            context,
            item: _currentItem,
            kind: BhpPositionQuickEditKind.name,
          ),
          icon: const Icon(Icons.drive_file_rename_outline_rounded),
        ),
        IconButton.filledTonal(
          tooltip: 'Dodaj lub edytuj uwagi',
          onPressed: () => showBhpPositionQuickEditModal(
            context,
            item: _currentItem,
            kind: BhpPositionQuickEditKind.notes,
          ),
          icon: const Icon(Icons.sticky_note_2_outlined),
        ),
        if (!_currentItem.aktywny) ...[
          IconButton.filledTonal(
            tooltip: 'Przywróć stanowisko',
            onPressed: () => _handleRestore(context),
            icon: Icon(Icons.settings_backup_restore_rounded, color: context.colors.tertiary),
          ),
          IconButton.filledTonal(
            tooltip: 'Usuń stanowisko',
            onPressed: () => _handleDelete(context),
            icon: Icon(Icons.delete_forever_rounded, color: context.colors.error),
          ),
        ],
        if (_currentItem.aktywny)
          IconButton.filledTonal(
            tooltip: 'Archiwizuj stanowisko',
            onPressed: () => _handleArchive(context),
            icon: Icon(Icons.archive_outlined, color: context.colors.error),
          ),
      ],
    );
  }

  Future<void> _handleArchive(BuildContext context) async {
    final archived = await showArchiveBhpPositionModal(context, item: _currentItem);
    if (!context.mounted || archived != true) {
      return;
    }

    AppToast.show(
      context,
      message: 'Zarchiwizowano stanowisko ${_currentItem.nazwa}.',
      tone: .success,
    );

    setState(() {
      _currentItem = _currentItem.copyWith(aktywny: false);
    });
  }

  Future<void> _handleRestore(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.bhpPositionsRestoreTitle,
      message: context.l10n.bhpPositionsRestoreMessage(_currentItem.nazwa),
      confirmLabel: context.l10n.bhpPositionsRestoreAction,
      tone: .warning,
    );
    if (!context.mounted || !confirmed) {
      return;
    }

    final repository = context.read<BhpPositionsRepository>();
    final result = await repository.unarchivePosition(_currentItem.id);
    if (!context.mounted) {
      return;
    }

    result.fold(
      (error) => AppToast.show(
        context,
        message: error.message,
        tone: .error,
      ),
      (item) {
        AppToast.show(
          context,
          message: context.l10n.bhpPositionsRestoreSuccess(item.nazwa),
          tone: .success,
        );
        setState(() {
          _currentItem = item;
        });
      },
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Usuń stanowisko',
      message: 'Czy na pewno chcesz trwale usunąć stanowisko „${_currentItem.nazwa}”?\nTej operacji nie można cofnąć.',
      confirmLabel: 'Usuń',
      cancelLabel: context.l10n.cancel,
      tone: .danger,
    );
    if (!context.mounted || !confirmed) {
      return;
    }

    final repository = context.read<BhpPositionsRepository>();
    final result = await repository.deletePosition(_currentItem.id);
    if (!context.mounted) {
      return;
    }

    result.fold(
      (error) => AppToast.show(
        context,
        message: error.message,
        tone: .error,
      ),
      (_) {
        AppToast.show(
          context,
          message: 'Pomyślnie usunięto stanowisko „${_currentItem.nazwa}”.',
          tone: .success,
        );
        Navigator.of(context).pop();
      },
    );
  }
}
