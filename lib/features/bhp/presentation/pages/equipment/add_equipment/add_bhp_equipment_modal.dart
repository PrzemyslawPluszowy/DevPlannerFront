import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/add_equipment/cubit/add_bhp_equipment_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/add_equipment/cubit/add_bhp_equipment_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_form/equipment_form_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera boczny formularz dodawania karty wyposażenia BHP.
Future<GetBhpEquipmentDetails?> showAddBhpEquipmentModal(BuildContext context) {
  final repository = context.read<BhpEquipmentRepository>();

  return AppModalSheet.showSideSheet<GetBhpEquipmentDetails>(
    context,
    title: 'Dodaj kartę wyposażenia',
    subtitle: 'Utwórz nową pozycję katalogu wyposażenia BHP.',
    size: AppModalSheetSize.large,
    width: 980,
    body: BlocProvider(
      create: (_) => AddBhpEquipmentCubit(repository: repository),
      child: const _AddBhpEquipmentModalBody(),
    ),
  );
}

/// Treść modala dodawania karty wyposażenia BHP.
class _AddBhpEquipmentModalBody extends StatefulWidget {
  /// Tworzy treść modala dodawania wyposażenia.
  const _AddBhpEquipmentModalBody();

  @override
  State<_AddBhpEquipmentModalBody> createState() =>
      _AddBhpEquipmentModalBodyState();
}

/// Stan treści modala dodawania karty wyposażenia BHP.
class _AddBhpEquipmentModalBodyState extends State<_AddBhpEquipmentModalBody> {
  final _formController = BhpEquipmentFormController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddBhpEquipmentCubit, AddBhpEquipmentState>(
      listener: (context, state) {
        if (state case AddBhpEquipmentSuccess(:final item)) {
          AppToast.show(
            context,
            message: 'Dodano kartę ${item.symbol}.',
            tone: AppToastTone.success,
          );
          Navigator.of(context).pop(item);
        }
      },
      builder: (context, state) {
        final submitError = switch (state) {
          AddBhpEquipmentReady(:final submitError) => submitError,
          _ => null,
        };

        return BhpEquipmentForm(
          controller: _formController,
          title: 'Dane karty wyposażenia',
          description: 'Uzupełnij podstawowe parametry pozycji katalogowej.',
          submitLabel: 'Dodaj wyposażenie',
          submitIcon: Icons.add_rounded,
          isSubmitting: state is AddBhpEquipmentSubmitting,
          submitError: submitError,
          onSubmit: _submit,
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formController.formKey.currentState!.validate()) {
      return;
    }

    await context.read<AddBhpEquipmentCubit>().submit(
      _formController.buildRequest(),
    );
  }
}
