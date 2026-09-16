import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/edit_equipment/cubit/edit_bhp_equipment_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/edit_equipment/cubit/edit_bhp_equipment_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_form/equipment_form_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera boczny formularz edycji karty wyposażenia BHP.
Future<GetBhpEquipmentDetails?> showEditBhpEquipmentModal(
  BuildContext context, {
  required GetBhpEquipmentListItem item,
}) {
  final repository = context.read<BhpEquipmentRepository>();

  return AppModalSheet.showSideSheet<GetBhpEquipmentDetails>(
    context,
    title: 'Edytuj kartę wyposażenia',
    subtitle: item.symbol,
    size: AppModalSheetSize.large,
    width: 980,
    body: BlocProvider(
      create: (_) {
        final cubit = EditBhpEquipmentCubit(item: item, repository: repository);
        unawaited(cubit.load());
        return cubit;
      },
      child: const _EditBhpEquipmentModalBody(),
    ),
  );
}

/// Treść modala edycji karty wyposażenia BHP.
class _EditBhpEquipmentModalBody extends StatefulWidget {
  /// Tworzy treść modala edycji wyposażenia.
  const _EditBhpEquipmentModalBody();

  @override
  State<_EditBhpEquipmentModalBody> createState() =>
      _EditBhpEquipmentModalBodyState();
}

/// Stan treści modala edycji karty wyposażenia BHP.
class _EditBhpEquipmentModalBodyState
    extends State<_EditBhpEquipmentModalBody> {
  final _formController = BhpEquipmentFormController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditBhpEquipmentCubit, EditBhpEquipmentState>(
      listener: (context, state) {
        switch (state) {
          case EditBhpEquipmentReady(:final detail):
            _formController.hydrateFromDetail(detail);
          case EditBhpEquipmentSuccess(:final item):
            AppToast.show(
              context,
              message: 'Zapisano kartę ${item.symbol}.',
              tone: AppToastTone.success,
            );
            Navigator.of(context).pop(item);
          case EditBhpEquipmentLoading():
          case EditBhpEquipmentLoadError():
          case EditBhpEquipmentSubmitting():
            break;
        }
      },
      builder: (context, state) {
        return switch (state) {
          EditBhpEquipmentLoading() => const Center(child: AppSpinner()),
          EditBhpEquipmentLoadError(:final message) => AppEmptyState.error(
            title: 'Nie udało się przygotować formularza',
            message: message,
          ),
          EditBhpEquipmentReady() || EditBhpEquipmentSubmitting() => _buildForm(
            state,
          ),
          EditBhpEquipmentSuccess() => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildForm(EditBhpEquipmentState state) {
    final submitError = switch (state) {
      EditBhpEquipmentReady(:final submitError) => submitError,
      _ => null,
    };

    return BhpEquipmentForm(
      controller: _formController,
      title: 'Dane karty wyposażenia',
      description:
          'Zmień parametry karty katalogowej bez utraty historii użycia.',
      submitLabel: 'Zapisz zmiany',
      submitIcon: Icons.save_outlined,
      isSubmitting: state is EditBhpEquipmentSubmitting,
      submitError: submitError,
      onSubmit: _submit,
    );
  }

  Future<void> _submit() async {
    if (!_formController.formKey.currentState!.validate()) {
      return;
    }

    await context.read<EditBhpEquipmentCubit>().submit(
      _formController.buildRequest(),
    );
  }
}
