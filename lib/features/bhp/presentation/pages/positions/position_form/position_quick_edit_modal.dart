import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/edit_position/cubit/edit_bhp_position_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/edit_position/cubit/edit_bhp_position_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

/// Typ szybkiej edycji danych stanowiska.
enum BhpPositionQuickEditKind {
  /// Edycja nazwy stanowiska.
  name,

  /// Edycja uwag stanowiska.
  notes,
}

/// Otwiera mały modal szybkiej edycji nazwy lub uwag stanowiska.
Future<GetBhpPositionListItem?> showBhpPositionQuickEditModal(
  BuildContext context, {
  required GetBhpPositionListItem item,
  required BhpPositionQuickEditKind kind,
}) {
  return AppModalSheet.show<GetBhpPositionListItem>(
    context,
    title: switch (kind) {
      BhpPositionQuickEditKind.name => 'Zmień nazwę stanowiska',
      BhpPositionQuickEditKind.notes => 'Uwagi stanowiska',
    },
    subtitle: item.nazwa,
    size: AppModalSheetSize.small,
    maxBodyHeight: 320,
    body: BlocProvider.value(
      value: context.read<EditBhpPositionCubit>(),
      child: _BhpPositionQuickEditModalBody(
        item: item,
        kind: kind,
      ),
    ),
  );
}

/// Treść modala szybkiej edycji danych stanowiska.
class _BhpPositionQuickEditModalBody extends StatefulWidget {
  /// Tworzy treść modala szybkiej edycji danych stanowiska.
  const _BhpPositionQuickEditModalBody({
    required this.item,
    required this.kind,
  });

  /// Aktualnie edytowane stanowisko.
  final GetBhpPositionListItem item;

  /// Typ edytowanego pola.
  final BhpPositionQuickEditKind kind;

  @override
  State<_BhpPositionQuickEditModalBody> createState() =>
      _BhpPositionQuickEditModalBodyState();
}

/// Stan treści modala szybkiej edycji danych stanowiska.
class _BhpPositionQuickEditModalBodyState
    extends State<_BhpPositionQuickEditModalBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: switch (widget.kind) {
        BhpPositionQuickEditKind.name => widget.item.nazwa,
        BhpPositionQuickEditKind.notes => widget.item.uwagi ?? '',
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditBhpPositionCubit, EditBhpPositionState>(
      listener: (context, state) {
        if (state case EditBhpPositionSuccess(:final item)) {
          Navigator.of(context).pop(item);
        }
      },
      builder: (context, state) {
        final isSubmitting = state is EditBhpPositionSubmitting;
        final submitError = switch (state) {
          EditBhpPositionReady(:final submitError) => submitError,
          _ => null,
        };

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              AppTextField(
                controller: _controller,
                variant: .filled,
                labelText: switch (widget.kind) {
                  BhpPositionQuickEditKind.name =>
                    context.l10n.bhpTablePosition,
                  BhpPositionQuickEditKind.notes => context.l10n.bhpTableNotes,
                },
                isRequired: widget.kind == BhpPositionQuickEditKind.name,
                enabled: !isSubmitting,
                maxLines: switch (widget.kind) {
                  BhpPositionQuickEditKind.name => 1,
                  BhpPositionQuickEditKind.notes => 4,
                },
                minLines: switch (widget.kind) {
                  BhpPositionQuickEditKind.name => null,
                  BhpPositionQuickEditKind.notes => 3,
                },
                validators: switch (widget.kind) {
                  BhpPositionQuickEditKind.name => [AppValidators.required()],
                  BhpPositionQuickEditKind.notes => const [],
                },
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
              Gaps.h20,
              Row(
                mainAxisAlignment: .end,
                children: [
                  AppActionButton.text(
                    label: context.l10n.cancel,
                    icon: Icons.close_rounded,
                    onPressed: isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                  Gaps.w8,
                  AppActionButton.filled(
                    label: context.l10n.save,
                    icon: Icons.save_outlined,
                    onPressedAsync: isSubmitting ? null : _submit,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<EditBhpPositionCubit>().submit(
      PostBhpPositionRequest(
        nazwa: switch (widget.kind) {
          BhpPositionQuickEditKind.name => _controller.text.trim(),
          BhpPositionQuickEditKind.notes => widget.item.nazwa,
        },
        uwagi: switch (widget.kind) {
          BhpPositionQuickEditKind.name => _nullableText(widget.item.uwagi),
          BhpPositionQuickEditKind.notes => _nullableText(_controller.text),
        },
      ),
    );
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
