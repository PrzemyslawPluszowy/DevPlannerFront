import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/add_user/cubit/add_bhp_user_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/add_user/cubit/add_bhp_user_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_form/user_form_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera boczny formularz dodawania pracownika BHP.
Future<GetBhpUserListItem?> showAddBhpUserModal(
  BuildContext context, {
  List<GetBhpUserListItem> existingUsers = const [],
}) {
  final usersRepository = context.read<BhpUsersRepository>();
  final positionsRepository = context.read<BhpPositionsRepository>();

  return AppModalSheet.showSideSheet<GetBhpUserListItem>(
    context,
    title: context.l10n.bhpAddUserTitle,
    subtitle: context.l10n.bhpAddUserSubtitle,
    size: AppModalSheetSize.large,
    width: 980,
    body: BlocProvider(
      create: (_) {
        final cubit = AddBhpUserCubit(
          usersRepository: usersRepository,
          positionsRepository: positionsRepository,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: _AddBhpUserModalBody(existingUsers: existingUsers),
    ),
  );
}

/// Treść modala dodawania pracownika BHP.
class _AddBhpUserModalBody extends StatefulWidget {
  /// Tworzy treść modala dodawania pracownika.
  const _AddBhpUserModalBody({required this.existingUsers});

  /// Lista pracowników już obecnych w załadowanym widoku.
  final List<GetBhpUserListItem> existingUsers;

  @override
  State<_AddBhpUserModalBody> createState() => _AddBhpUserModalBodyState();
}

/// Stan treści modala dodawania pracownika BHP.
class _AddBhpUserModalBodyState extends State<_AddBhpUserModalBody> {
  final _formController = BhpUserFormController();

  @override
  void initState() {
    super.initState();
    for (final controller in [
      _formController.imieController,
      _formController.nazwiskoController,
      _formController.peselController,
    ]) {
      controller.addListener(_handleIdentityFieldsChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _formController.imieController,
      _formController.nazwiskoController,
      _formController.peselController,
    ]) {
      controller.removeListener(_handleIdentityFieldsChanged);
    }
    _formController.dispose();
    super.dispose();
  }

  void _handleIdentityFieldsChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    return BlocConsumer<AddBhpUserCubit, AddBhpUserState>(
      listener: (context, state) {
        switch (state) {
          case AddBhpUserSuccess(:final user):
            AppToast.show(
              context,
              message: intl.bhpAddUserSuccessMessage(user.fullName),
              tone: AppToastTone.success,
            );
            Navigator.of(context).pop(user);
          case AddBhpUserLoadError():
          case AddBhpUserLoading():
          case AddBhpUserReady():
          case AddBhpUserSubmitting():
            break;
        }
      },
      builder: (context, state) {
        return switch (state) {
          AddBhpUserLoading() => const Center(child: AppSpinner()),
          AddBhpUserLoadError(:final message) => AppEmptyState.error(
            title: intl.bhpAddUserLoadErrorTitle,
            message: message,
          ),
          AddBhpUserReady() || AddBhpUserSubmitting() => _buildForm(
            context,
            state: state,
          ),
          AddBhpUserSuccess() => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildForm(
    BuildContext context, {
    required AddBhpUserState state,
  }) {
    final isSubmitting = state is AddBhpUserSubmitting;
    final positions = switch (state) {
      AddBhpUserReady(:final positions) => positions,
      AddBhpUserSubmitting(:final positions) => positions,
      _ => const <GetBhpPositionListItem>[],
    };
    final submitError = switch (state) {
      AddBhpUserReady(:final submitError) => submitError,
      _ => null,
    };
    final potentialDuplicates = context
        .read<AddBhpUserCubit>()
        .findPotentialDuplicatesLocally(
          _formController.buildDuplicateCheckRequest(),
          existingUsers: widget.existingUsers,
        );

    return BhpUserForm(
      controller: _formController,
      positions: positions,
      potentialDuplicates: potentialDuplicates,
      baseSectionTitle: context.l10n.bhpAddUserBaseSectionTitle,
      baseSectionDescription: context.l10n.bhpAddUserBaseSectionDescription,
      submitLabel: context.l10n.bhpAddUserSubmitAction,
      submitIcon: Icons.add_rounded,
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

    await context.read<AddBhpUserCubit>().submit(
      _formController.buildRequest(),
    );
  }
}
