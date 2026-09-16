import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/add_position/cubit/add_bhp_position_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/add_position/cubit/add_bhp_position_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/edit_position/cubit/edit_bhp_position_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/edit_position/cubit/edit_bhp_position_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_form/position_form_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/position_standards_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

/// Otwiera spójny modal dodawania stanowiska BHP wraz z konfiguracją standardu.
Future<GetBhpPositionListItem?> showAddBhpPositionModal(
  BuildContext context,
) {
  final positionsRepository = context.read<BhpPositionsRepository>();
  final equipmentRepository = context.read<BhpEquipmentRepository>();

  return AppModalSheet.showSideSheet<GetBhpPositionListItem>(
    context,
    title: 'Dodaj stanowisko BHP',
    subtitle: 'Najpierw zapisz stanowisko, potem od razu ustaw jego standard.',
    size: AppModalSheetSize.large,
    width: 1320,
    body: BlocProvider(
      create: (_) => AddBhpPositionCubit(repository: positionsRepository),
      child: _AddBhpPositionModalBody(
        positionsRepository: positionsRepository,
        equipmentRepository: equipmentRepository,
      ),
    ),
  );
}

/// Treść modala dodawania stanowiska BHP.
class _AddBhpPositionModalBody extends StatefulWidget {
  /// Tworzy treść modala dodawania stanowiska.
  const _AddBhpPositionModalBody({
    required this.positionsRepository,
    required this.equipmentRepository,
  });

  /// Repozytorium stanowisk używane po utworzeniu rekordu.
  final BhpPositionsRepository positionsRepository;

  /// Repozytorium wyposażenia potrzebne do konfiguracji standardu.
  final BhpEquipmentRepository equipmentRepository;

  @override
  State<_AddBhpPositionModalBody> createState() =>
      _AddBhpPositionModalBodyState();
}

/// Stan treści modala dodawania stanowiska BHP.
class _AddBhpPositionModalBodyState extends State<_AddBhpPositionModalBody> {
  final BhpPositionFormController _formController = BhpPositionFormController();
  GetBhpPositionListItem? _createdPosition;

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_createdPosition case final position?) {
      return _CreatedPositionWorkspace(
        key: ValueKey(position.id),
        position: position,
        positionsRepository: widget.positionsRepository,
        equipmentRepository: widget.equipmentRepository,
        onPositionUpdated: _handlePositionUpdated,
        onFinish: () => Navigator.of(context).pop(position),
      );
    }

    return BlocConsumer<AddBhpPositionCubit, AddBhpPositionState>(
      listener: (context, state) {
        if (state case AddBhpPositionSuccess(:final item)) {
          _formController.hydrateFromItem(item);
          setState(() => _createdPosition = item);
          AppToast.show(
            context,
            message:
                'Dodano stanowisko ${item.nazwa}. Teraz uzupełnij standard wyposażenia.',
            tone: AppToastTone.success,
          );
        }
      },
      builder: (context, state) {
        final submitError = switch (state) {
          AddBhpPositionReady(:final submitError) => submitError,
          _ => null,
        };

        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            AppSectionCard(
              child: Form(
                key: _formController.formKey,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Dane stanowiska',
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w700,
                            ),
                          ),
                        ),
                        AppActionButton.text(
                          label: context.l10n.cancel,
                          icon: Icons.close_rounded,
                          onPressed: state is AddBhpPositionSubmitting
                              ? null
                              : () => Navigator.of(context).pop(),
                        ),
                        Gaps.w8,
                        AppActionButton.filled(
                          label: 'Zapisz i ustaw standard',
                          icon: Icons.inventory_2_outlined,
                          onPressedAsync: state is AddBhpPositionSubmitting
                              ? null
                              : _submit,
                        ),
                      ],
                    ),
                    Gaps.h12,
                    Row(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _formController.nameController,
                            variant: .filled,
                            labelText: context.l10n.bhpTablePosition,
                            isRequired: true,
                            enabled: state is! AddBhpPositionSubmitting,
                            validators: [AppValidators.required()],
                          ),
                        ),
                        Gaps.w12,
                        Expanded(
                          child: AppTextField(
                            controller: _formController.notesController,
                            variant: .filled,
                            labelText: context.l10n.bhpTableNotes,
                            enabled: state is! AddBhpPositionSubmitting,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    if (submitError case final message?
                        when message.trim().isNotEmpty) ...[
                      Gaps.h12,
                      Text(
                        message,
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.error,
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Gaps.h16,
            AppEmptyState.noData(
              title: 'Standard pojawi się po zapisie stanowiska',
              message:
                  'Najpierw utwórz rekord stanowiska, bo dopiero wtedy można przypisywać do niego pozycje wyposażenia.',
            ),
          ],
        );
      },
    );
  }

  void _handlePositionUpdated(GetBhpPositionListItem item) {
    _formController.hydrateFromItem(item);
    setState(() => _createdPosition = item);
  }

  Future<void> _submit() async {
    if (!_formController.formKey.currentState!.validate()) {
      return;
    }

    await context.read<AddBhpPositionCubit>().submit(
      _formController.buildRequest(),
    );
  }
}

/// Widok roboczy nowo utworzonego stanowiska z konfiguracją standardu.
class _CreatedPositionWorkspace extends StatelessWidget {
  /// Tworzy widok roboczy nowo utworzonego stanowiska.
  const _CreatedPositionWorkspace({
    required this.position,
    required this.positionsRepository,
    required this.equipmentRepository,
    required this.onPositionUpdated,
    required this.onFinish,
    super.key,
  });

  /// Aktualnie utworzone stanowisko.
  final GetBhpPositionListItem position;

  /// Repozytorium stanowisk.
  final BhpPositionsRepository positionsRepository;

  /// Repozytorium wyposażenia.
  final BhpEquipmentRepository equipmentRepository;

  /// Callback po zapisaniu danych podstawowych stanowiska.
  final ValueChanged<GetBhpPositionListItem> onPositionUpdated;

  /// Callback kończący cały flow.
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => EditBhpPositionCubit(
            item: position,
            repository: positionsRepository,
          ),
        ),
        BlocProvider(
          create: (_) {
            final cubit = BhpPositionStandardsCubit(
              position: position,
              positionsRepository: positionsRepository,
              equipmentRepository: equipmentRepository,
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: _CreatedPositionWorkspaceBody(
        position: position,
        onPositionUpdated: onPositionUpdated,
        onFinish: onFinish,
      ),
    );
  }
}

/// Treść robocza nowo utworzonego stanowiska.
class _CreatedPositionWorkspaceBody extends StatelessWidget {
  /// Tworzy treść roboczą nowo utworzonego stanowiska.
  const _CreatedPositionWorkspaceBody({
    required this.position,
    required this.onPositionUpdated,
    required this.onFinish,
  });

  /// Aktualnie utworzone stanowisko.
  final GetBhpPositionListItem position;

  /// Callback po zapisaniu danych podstawowych stanowiska.
  final ValueChanged<GetBhpPositionListItem> onPositionUpdated;

  /// Callback kończący flow.
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditBhpPositionCubit, EditBhpPositionState>(
      listener: (context, state) {
        if (state case EditBhpPositionSuccess(:final item)) {
          onPositionUpdated(item);
          AppToast.show(
            context,
            message: 'Zapisano stanowisko ${item.nazwa}.',
            tone: AppToastTone.success,
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            AppSectionCard(
              padding: const .all(Sizes.p20),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  _buildQuickActions(context),
                  Gaps.h16,
                  BhpPositionStandardsContent(
                    position: position,
                    showPositionSummary: false,
                    showInlineAddAction: true,
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
            item: position,
            kind: BhpPositionQuickEditKind.name,
          ),
          icon: const Icon(Icons.drive_file_rename_outline_rounded),
        ),
        IconButton.filledTonal(
          tooltip: 'Dodaj lub edytuj uwagi',
          onPressed: () => showBhpPositionQuickEditModal(
            context,
            item: position,
            kind: BhpPositionQuickEditKind.notes,
          ),
          icon: const Icon(Icons.sticky_note_2_outlined),
        ),
        if (stateIsEditable(context))
          AppActionButton.text(
            label: 'Zakończ',
            icon: Icons.check_rounded,
            onPressed: onFinish,
          ),
      ],
    );
  }

  bool stateIsEditable(BuildContext context) =>
      context.read<EditBhpPositionCubit>().state is! EditBhpPositionSubmitting;
}
