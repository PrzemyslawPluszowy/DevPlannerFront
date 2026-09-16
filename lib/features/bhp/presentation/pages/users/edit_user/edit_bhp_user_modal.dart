import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/edit_user/cubit/edit_bhp_user_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/edit_user/cubit/edit_bhp_user_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_form/user_form_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera boczny formularz edycji pracownika BHP.
Future<GetBhpUserListItem?> showEditBhpUserModal(
  BuildContext context, {
  required GetBhpUserListItem user,
}) {
  final usersRepository = context.read<BhpUsersRepository>();
  final positionsRepository = context.read<BhpPositionsRepository>();

  return AppModalSheet.showSideSheet<GetBhpUserListItem>(
    context,
    title: context.l10n.bhpEditUserTitle,
    subtitle: user.fullName,
    size: AppModalSheetSize.large,
    width: 980,
    body: BlocProvider(
      create: (_) {
        final cubit = EditBhpUserCubit(
          user: user,
          usersRepository: usersRepository,
          positionsRepository: positionsRepository,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _EditBhpUserModalBody(),
    ),
  );
}

/// Treść modala edycji pracownika BHP.
class _EditBhpUserModalBody extends StatefulWidget {
  /// Tworzy treść modala edycji pracownika.
  const _EditBhpUserModalBody();

  @override
  State<_EditBhpUserModalBody> createState() => _EditBhpUserModalBodyState();
}

/// Stan treści modala edycji pracownika BHP.
class _EditBhpUserModalBodyState extends State<_EditBhpUserModalBody> {
  final _formController = BhpUserFormController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    return BlocConsumer<EditBhpUserCubit, EditBhpUserState>(
      listener: (context, state) {
        switch (state) {
          case EditBhpUserSuccess(:final user):
            AppToast.show(
              context,
              message: intl.bhpEditUserSuccessMessage(user.fullName),
              tone: AppToastTone.success,
            );
            Navigator.of(context).pop(user);
          case EditBhpUserReady(:final userDetail):
            _formController.hydrateFromDetail(userDetail, state.positions);
          case EditBhpUserLoadError():
          case EditBhpUserLoading():
          case EditBhpUserSubmitting():
            break;
        }
      },
      builder: (context, state) {
        return switch (state) {
          EditBhpUserLoading() => const Center(child: AppSpinner()),
          EditBhpUserLoadError(:final message) => AppEmptyState.error(
            title: intl.bhpEditUserLoadErrorTitle,
            message: message,
          ),
          EditBhpUserReady() || EditBhpUserSubmitting() => _buildForm(
            context,
            state: state,
          ),
          EditBhpUserSuccess() => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildForm(
    BuildContext context, {
    required EditBhpUserState state,
  }) {
    final isSubmitting = state is EditBhpUserSubmitting;
    final positions = switch (state) {
      EditBhpUserReady(:final positions) => positions,
      EditBhpUserSubmitting(:final positions) => positions,
      _ => const <GetBhpPositionListItem>[],
    };
    final submitError = switch (state) {
      EditBhpUserReady(:final submitError) => submitError,
      _ => null,
    };

    return BhpUserForm(
      controller: _formController,
      positions: positions,
      potentialDuplicates: const [],
      baseSectionTitle: context.l10n.bhpEditUserBaseSectionTitle,
      baseSectionDescription: context.l10n.bhpEditUserBaseSectionDescription,
      submitLabel: context.l10n.bhpEditUserSubmitAction,
      submitIcon: Icons.save_outlined,
      isSubmitting: isSubmitting,
      submitError: submitError,
      onPositionChanged: (value) =>
          setState(() => _formController.stanowiskoId = value),
      onEmploymentStartChanged: (value) {
        setState(() => _formController.dataRozpoczecia = value);
      },
      onEmploymentEndChanged: (value) {
        setState(() => _formController.dataZakonczenia = value);
      },
      onSubmit: _submit,
    );
  }

  Future<void> _submit() async {
    setState(() => _formController.submitted = true);

    if (!_formController.formKey.currentState!.validate() ||
        _formController.stanowiskoId == null) {
      return;
    }

    if (_formController.hasInvalidEmploymentDates) {
      AppToast.show(
        context,
        message: context.l10n.bhpAddUserInvalidEmploymentDatesMessage,
        tone: AppToastTone.warning,
      );
      return;
    }

    await context.read<EditBhpUserCubit>().submit(
      _formController.buildRequest(),
    );
  }
}
