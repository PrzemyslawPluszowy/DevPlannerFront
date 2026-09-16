part of 'arkusz_detail_modal.dart';

/// Otwiera modal edycji dat rozpoczecia i zakonczenia arkusza.
Future<bool?> _showUpdateArkuszDatesModal(
  BuildContext context, {
  required int arkuszId,
  required String? startDateTime,
  required String? endDateTime,
  required InventoriesRepository repository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventorySheetManagementTitle,
    subtitle: context.l10n.inventorySheetManagementSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => UpdateArkuszDatesCubit(repository: repository),
      child: _UpdateArkuszDatesModalBody(
        arkuszId: arkuszId,
        initialStartDateTime: startDateTime,
        initialEndDateTime: endDateTime,
      ),
    ),
  );
}

/// Otwiera modal potwierdzenia usuniecia arkusza.
Future<bool?> _showDeleteArkuszModal(
  BuildContext context, {
  required int arkuszId,
  required String arkuszNumber,
  required bool canDeleteArkusz,
  required InventoriesRepository repository,
}) {
  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.inventoryDeleteSheetTitle,
    subtitle: context.l10n.inventoryDeleteSheetSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => DeleteArkuszCubit(repository: repository),
      child: _DeleteArkuszModalBody(
        arkuszId: arkuszId,
        arkuszNumber: arkuszNumber,
        canDeleteArkusz: canDeleteArkusz,
      ),
    ),
  );
}

/// Body modalu usuwania arkusza.
class _DeleteArkuszModalBody extends StatefulWidget {
  /// Tworzy body modalu usuwania arkusza.
  const _DeleteArkuszModalBody({
    required this.arkuszId,
    required this.arkuszNumber,
    required this.canDeleteArkusz,
  });

  /// Identyfikator arkusza do usuniecia.
  final int arkuszId;

  /// Numer arkusza pokazywany w potwierdzeniu.
  final String arkuszNumber;

  /// Flaga guardu usuwania dla statusu zakonczonej inwentaryzacji.
  final bool canDeleteArkusz;

  @override
  State<_DeleteArkuszModalBody> createState() => _DeleteArkuszModalBodyState();
}

/// Stan modalu usuwania arkusza.
class _DeleteArkuszModalBodyState extends State<_DeleteArkuszModalBody> {
  static const _deleteUnlockPhrase = 'Excellent';
  final TextEditingController _confirmationController = TextEditingController();

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;
    final isUnlocked =
        _confirmationController.text.trim() == _deleteUnlockPhrase;

    return BlocConsumer<DeleteArkuszCubit, DeleteArkuszState>(
      listener: (context, state) {
        switch (state) {
          case DeleteArkuszSuccess():
            Navigator.of(context).pop(true);
          case DeleteArkuszBlocked():
            AppToast.show(
              context,
              message: intl.inventoryDeleteSheetBlockedMessage,
              tone: AppToastTone.error,
            );
          case DeleteArkuszInitial():
          case DeleteArkuszSubmitting():
          case DeleteArkuszError():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is DeleteArkuszSubmitting;
        final isBlocked =
            !widget.canDeleteArkusz || state is DeleteArkuszBlocked;
        final errorMessage = switch (state) {
          DeleteArkuszError(:final message) => message,
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
                          intl.inventoryDeleteSheetConfirmTitle,
                          style: context.text.titleSmall?.copyWith(
                            color: colors.onErrorContainer,
                            fontWeight: .w700,
                          ),
                        ),
                        Gaps.h8,
                        AppText(
                          intl.inventoryDeleteSheetConfirmBody(
                            widget.arkuszNumber,
                            widget.arkuszId,
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
            if (isBlocked) ...[
              Gaps.h12,
              AppText(
                intl.inventoryDeleteSheetBlockedMessage,
                style: context.text.bodySmall?.copyWith(
                  color: colors.error,
                  fontWeight: .w600,
                ),
              ),
            ],
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
              controller: _confirmationController,
              enabled: !isSubmitting && !isBlocked,
              labelText: intl.inventoryDeleteUnlockLabel,
              hintText: intl.inventoryDeleteUnlockHint,
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
                  onPressedAsync: isSubmitting || !isUnlocked || isBlocked
                      ? null
                      : () => context.read<DeleteArkuszCubit>().submit(
                          arkuszId: widget.arkuszId,
                          isInventoryFinished: !widget.canDeleteArkusz,
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

/// Body modalu edycji dat arkusza.
class _UpdateArkuszDatesModalBody extends StatefulWidget {
  /// Tworzy body modalu edycji dat arkusza.
  const _UpdateArkuszDatesModalBody({
    required this.arkuszId,
    required this.initialStartDateTime,
    required this.initialEndDateTime,
  });

  /// Identyfikator arkusza zapisywanego do backendu.
  final int arkuszId;

  /// Poczatkowa data rozpoczecia wraz z czasem.
  final String? initialStartDateTime;

  /// Poczatkowa data zakonczenia wraz z czasem.
  final String? initialEndDateTime;

  @override
  State<_UpdateArkuszDatesModalBody> createState() =>
      _UpdateArkuszDatesModalBodyState();
}

/// Stan modalu edycji dat arkusza.
class _UpdateArkuszDatesModalBodyState
    extends State<_UpdateArkuszDatesModalBody> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String? _errorMessage;

  DateTime get _firstDate {
    return DateTime(2000);
  }

  DateTime get _lastDate => DateTime(2100, 12, 31);

  @override
  void initState() {
    super.initState();
    _startDate = _tryParseDate(widget.initialStartDateTime);
    _endDate = _tryParseDate(widget.initialEndDateTime);
    _startTime = _timeFromDateTime(
      _startDate ?? DateTime.now(),
      fallback: const TimeOfDay(hour: 8, minute: 0),
    );
    _endTime = _timeFromDateTime(
      _endDate ?? _startDate ?? DateTime.now(),
      fallback: const TimeOfDay(hour: 16, minute: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateArkuszDatesCubit, UpdateArkuszDatesState>(
      listener: (context, state) {
        switch (state) {
          case UpdateArkuszDatesSuccess():
            Navigator.of(context).pop(true);
          case UpdateArkuszDatesError(:final message):
            setState(() {
              _errorMessage = message;
            });
          case UpdateArkuszDatesInitial():
          case UpdateArkuszDatesSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is UpdateArkuszDatesSubmitting;

        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            AppDatePickerField(
              value: _startDate,
              firstDate: _firstDate,
              lastDate: _lastDate,
              enabled: !isSubmitting,
              allowClear: false,
              variant: AppDateFieldVariant.filled,
              labelText: 'Data rozpoczecia',
              helperText: context.l10n.inventoryStartDateHelper,
              onChanged: (value) {
                setState(() {
                  _startDate = value;
                  _errorMessage = null;
                });
              },
            ),
            Gaps.h12,
            _ArkuszDetailTimePickerField(
              label: context.l10n.inventorySheetStartTimeLabel,
              value: _startTime,
              enabled: !isSubmitting,
              onTap: () async {
                final selected = await AppModalPickerHost.showTime(
                  context,
                  initialTime: _startTime,
                );
                if (selected == null || !context.mounted) {
                  return;
                }
                setState(() {
                  _startTime = selected;
                  _errorMessage = null;
                });
              },
            ),
            Gaps.h12,
            AppDatePickerField(
              value: _endDate,
              firstDate: _firstDate,
              lastDate: _lastDate,
              enabled: !isSubmitting,
              variant: AppDateFieldVariant.filled,
              labelText: 'Data zakonczenia',
              helperText: context.l10n.inventoryEndDateHelper,
              onChanged: (value) {
                setState(() {
                  _endDate = value;
                  _errorMessage = null;
                });
              },
            ),
            Gaps.h12,
            _ArkuszDetailTimePickerField(
              label: context.l10n.inventorySheetEndTimeLabel,
              value: _endTime,
              enabled: !isSubmitting,
              onTap: () async {
                final selected = await AppModalPickerHost.showTime(
                  context,
                  initialTime: _endTime,
                );
                if (selected == null || !context.mounted) {
                  return;
                }
                setState(() {
                  _endTime = selected;
                  _errorMessage = null;
                });
              },
            ),
            if (_errorMessage case final String message
                when message.trim().isNotEmpty) ...[
              Gaps.h12,
              AppText(
                message,
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
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: context.l10n.save,
                  icon: Icons.check_rounded,
                  onPressedAsync: isSubmitting ? null : _submit,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (_startDate == null) {
      setState(() {
        _errorMessage = 'Data rozpoczecia jest wymagana.';
      });
      return;
    }

    final startDateTime = _combineDateAndTime(_startDate!, _startTime);
    final endDateTime = _endDate == null
        ? null
        : _combineDateAndTime(_endDate!, _endTime);

    if (endDateTime != null && endDateTime.isBefore(startDateTime)) {
      setState(() {
        _errorMessage =
            'Data zakonczenia nie moze byc wczesniejsza niz data rozpoczecia.';
      });
      return;
    }

    final query = UpdateArkuszRequest(
      dataRozpoczecia: _formatDateTimePayload(startDateTime),
      dataZakonczenia: endDateTime == null
          ? null
          : _formatDateTimePayload(endDateTime),
    );

    await context.read<UpdateArkuszDatesCubit>().submit(
      arkuszId: widget.arkuszId,
      query: query,
    );
  }

  DateTime? _tryParseDate(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return DateTime.tryParse(normalized);
  }

  TimeOfDay _timeFromDateTime(
    DateTime value, {
    required TimeOfDay fallback,
  }) {
    if (value.hour == 0 && value.minute == 0 && value.second == 0) {
      return fallback;
    }
    return TimeOfDay(hour: value.hour, minute: value.minute);
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  String _formatDateTimePayload(DateTime value) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(value);
  }
}

/// Pole wyboru godziny dla modalu dat arkusza.
class _ArkuszDetailTimePickerField extends StatelessWidget {
  /// Tworzy pole wyboru godziny.
  const _ArkuszDetailTimePickerField({
    required this.label,
    required this.value,
    required this.onTap,
    this.enabled = true,
  });

  /// Etykieta pola.
  final String label;

  /// Wybrana godzina.
  final TimeOfDay value;

  /// Akcja otwierajaca picker czasu.
  final VoidCallback onTap;

  /// Okresla, czy pole jest aktywne.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final formatted = MaterialLocalizations.of(context).formatTimeOfDay(value);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: colors.surfaceContainerLow,
          prefixIcon: const Icon(Icons.schedule_outlined),
          enabled: enabled,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(.circular(Sizes.p8)),
          ),
        ),
        child: Text(formatted, style: context.text.bodyMedium),
      ),
    );
  }
}
