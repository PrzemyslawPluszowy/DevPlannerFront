import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_async_state_body.dart';
import 'package:ready_next/shared/presentation/widgets/app_banner.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:ready_next/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_control_size.dart';
import 'package:ready_next/shared/presentation/widgets/app_copy_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_date_picker_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_draggable_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_form_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_icon.dart';
import 'package:ready_next/shared/presentation/widgets/app_list_tile.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_multi_select_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_skeleton.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';
import 'package:ready_next/shared/presentation/widgets/app_tooltip.dart';

part 'framework_components_gallery_huge_table_modal.dart';
part 'framework_components_gallery_section_action_buttons.dart';
part 'framework_components_gallery_section_action_pills.dart';
part 'framework_components_gallery_section_confirm_dialog.dart';
part 'framework_components_gallery_section_context_menu.dart';
part 'framework_components_gallery_section_date_pickers.dart';
part 'framework_components_gallery_section_draggable_sheet.dart';
part 'framework_components_gallery_section_dropdown.dart';
part 'framework_components_gallery_section_empty_state.dart';
part 'framework_components_gallery_section_feedback.dart';
part 'framework_components_gallery_section_filters_bar.dart';
part 'framework_components_gallery_section_footer_note.dart';
part 'framework_components_gallery_section_form_section.dart';
part 'framework_components_gallery_section_icons.dart';
part 'framework_components_gallery_section_list_tiles.dart';
part 'framework_components_gallery_section_modal_states.dart';
part 'framework_components_gallery_section_multi_select.dart';
part 'framework_components_gallery_section_search_dropdown.dart';
part 'framework_components_gallery_section_section_card.dart';
part 'framework_components_gallery_section_simple_table.dart';
part 'framework_components_gallery_section_skeleton.dart';
part 'framework_components_gallery_section_status_badges.dart';
part 'framework_components_gallery_section_text_fields.dart';
part 'framework_components_gallery_section_tooltip_copy.dart';
part 'framework_components_gallery_shared_widgets.dart';
part 'framework_components_gallery_table_section.dart';

/// Galeria wspolnych komponentow UI.
///
/// Ten ekran sluzy jako miejsce do szybkiego podgladu i testowania
/// naszych komponentow frameworkowych.
class FrameworkComponentsGalleryPage extends StatefulWidget {
  const FrameworkComponentsGalleryPage({super.key});

  /// Otwiera pełnoekranowy podgląd tabeli przez wspólny rootowy host modali.
  static Future<void> showHugeTablePreview(BuildContext context) {
    return AppModalHost.showDialog<void>(
      context,
      builder: (_) {
        return const Dialog.fullscreen(child: _HugeTableStressModal());
      },
    );
  }

  /// Otwiera podgląd stanów lokalnego Cubita przez wspólny host modali.
  static Future<void> showBlocModalPreview(BuildContext context) {
    return AppModalHost.showDialog<void>(
      context,
      barrierDismissible: false,
      builder: (_) {
        return BlocProvider(
          create: (_) => _GalleryModalCubit()..load().ignore(),
          child: const _GalleryModalPreview(),
        );
      },
    );
  }

  @override
  State<FrameworkComponentsGalleryPage> createState() =>
      _FrameworkComponentsGalleryPageState();
}

class _FrameworkComponentsGalleryPageState
    extends State<FrameworkComponentsGalleryPage> {
  String selectedRange = 'today';
  String selectedCustomerLabel = 'Brak';
  List<String> selectedScopes = ['inventory', 'orders'];
  final filtersSearchController = AppSearchTextFieldController();
  final customerNameController = TextEditingController(
    text: 'Excellent Sp. z o.o.',
  );
  final customerEmailController = TextEditingController(
    text: 'kontakt@excellent.pl',
  );
  final customerNoteController = TextEditingController();
  DateTime? selectedDate = DateTime(2026, 4);
  AppDateRangeValue? selectedDateRange = AppDateRangeValue(
    start: DateTime(2026, 4),
    end: DateTime(2026, 4, 15),
  );
  String? selectedStatusFilter = 'all';
  String? selectedOwnerFilter = 'all';
  String selectedListTile = 'inbox';
  bool listExpanded = true;
  AppBannerTone feedbackBannerTone = .info;
  bool showFeedbackBanner = true;
  bool showTableLoading = false;
  bool useDarkTheme = false;
  String? tableErrorText;

  @override
  void dispose() {
    filtersSearchController.dispose();
    customerNameController.dispose();
    customerEmailController.dispose();
    customerNoteController.dispose();
    super.dispose();
  }

  void _showHint(String label) {
    AppBubbleToast.show(
      context,
      message: context.l10n.frameworkActionToast(label),
    );
  }

  void _updateGalleryState(VoidCallback update) {
    setState(update);
  }

  Future<void> _openHugeTablePreviewModal() async {
    await FrameworkComponentsGalleryPage.showHugeTablePreview(context);
  }

  Future<void> _openBlocModalPreview() async {
    await FrameworkComponentsGalleryPage.showBlocModalPreview(context);
  }

  Future<void> _openBlocSideSheetPreview() async {
    final cubit = _GalleryModalCubit()..load().ignore();
    try {
      await AppModalSheet.showSideSheet<void>(
        context,
        title: context.l10n.frameworkNewDocumentTitle,
        subtitle: context.l10n.frameworkNewDocumentSubtitle,
        body: BlocProvider.value(
          value: cubit,
          child: const _GalleryModalSideSheetBody(),
        ),
        footer: BlocProvider.value(
          value: cubit,
          child: BlocBuilder<_GalleryModalCubit, _GalleryModalState>(
            builder: (context, state) {
              final localCubit = context.read<_GalleryModalCubit>();
              return Row(
                mainAxisAlignment: .end,
                children: [
                  AppActionButton.text(
                    label: context.l10n.frameworkClose,
                    icon: Icons.close_rounded,
                    tone: .neutral,
                    onPressed: state is _GalleryModalLoading
                        ? null
                        : () => Navigator.of(context).maybePop(),
                  ),
                  Gaps.w8,
                  AppActionButton.outlined(
                    label: context.l10n.frameworkError,
                    icon: Icons.warning_amber_rounded,
                    tone: .danger,
                    onPressed: state is _GalleryModalLoading
                        ? null
                        : localCubit.fail,
                  ),
                  Gaps.w8,
                  AppActionButton.filled(
                    label: context.l10n.frameworkSave,
                    icon: Icons.save_outlined,
                    onPressedAsync: state is _GalleryModalLoaded
                        ? () async {
                            await localCubit.save();
                            if (context.mounted) {
                              Navigator.of(context).maybePop();
                            }
                          }
                        : null,
                  ),
                ],
              );
            },
          ),
        ),
      );
    } finally {
      await cubit.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    const controlSize = AppControlSize.small;
    final tableRows = _buildTableRows();
    final materialTheme = MaterialTheme.crm();
    final galleryTheme = useDarkTheme
        ? materialTheme.dark()
        : materialTheme.light();

    return Theme(
      data: galleryTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.frameworkGalleryTitle),
              actions: [
                Row(
                  children: [
                    AppText(
                      useDarkTheme ? 'Ciemny' : 'Jasny',
                      style: context.text.labelMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                        fontWeight: .w600,
                      ),
                    ),
                    Switch(
                      value: useDarkTheme,
                      onChanged: (value) {
                        setState(() => useDarkTheme = value);
                      },
                    ),
                    Gaps.w12,
                  ],
                ),
              ],
            ),
            body: ListView(
              padding: const .all(Sizes.p24),
              children: [
                _buildFeedbackSection(),
                Gaps.h20,
                _buildStatusBadgesSection(),
                Gaps.h20,
                _buildConfirmDialogSection(),
                Gaps.h20,
                _buildSkeletonSection(),
                Gaps.h20,
                _buildTooltipCopySection(),
                Gaps.h20,
                _buildEmptyStateSection(),
                Gaps.h20,
                _buildSectionCardSection(),
                Gaps.h20,
                _buildActionButtonsSection(),
                Gaps.h20,
                _buildActionPillsSection(),
                Gaps.h20,
                _buildIconsSection(),
                Gaps.h20,
                _buildModalStatesSection(),
                Gaps.h20,
                _buildDropdownSection(),
                Gaps.h20,
                _buildSearchDropdownSection(controlSize),
                Gaps.h20,
                _buildMultiSelectSection(controlSize),
                Gaps.h20,
                _buildContextMenuSection(),
                Gaps.h20,
                _buildListTilesSection(),
                Gaps.h20,
                _buildFiltersBarSection(controlSize),
                Gaps.h20,
                _buildTextFieldsSection(controlSize),
                Gaps.h20,
                _buildDatePickersSection(controlSize),
                Gaps.h20,
                _buildDraggableSheetSection(),
                Gaps.h20,
                _buildFormSectionSection(controlSize),
                Gaps.h20,
                _buildSimpleTableSection(tableRows),
                Gaps.h20,
                _GalleryDataTableSection(
                  rows: tableRows,
                  showTableLoading: showTableLoading,
                  tableErrorText: tableErrorText,
                  onCellTap: _showHint,
                  onOpenStressTest: _openHugeTablePreviewModal,
                  onToggleLoading: () {
                    setState(() => showTableLoading = !showTableLoading);
                  },
                  onToggleError: () {
                    setState(() {
                      tableErrorText = tableErrorText == null
                          ? context.l10n.frameworkSearchApiError
                          : null;
                    });
                  },
                  onShowTable: () {
                    setState(() {
                      showTableLoading = false;
                      tableErrorText = null;
                    });
                  },
                  onRetry: () {
                    setState(() => tableErrorText = null);
                    _showHint('Retry');
                  },
                ),
                Gaps.h20,
                _buildFooterNoteSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  List<_GalleryInventoryRow> _buildTableRows() {
    return const <_GalleryInventoryRow>[
      _GalleryInventoryRow(
        name: 'Spis Q2 / Warszawa',
        status: 'W toku',
        count: 148,
        owner: 'Anna',
      ),
      _GalleryInventoryRow(
        name: 'Spis Q1 / Poznań',
        status: 'Zamknięta',
        count: 92,
        owner: 'Marek',
      ),
      _GalleryInventoryRow(
        name: 'Spis ciągły / Wrocław',
        status: 'W toku',
        count: 210,
        owner: 'Kasia',
      ),
      _GalleryInventoryRow(
        name: 'Archiwum 2025',
        status: 'Archiwum',
        count: 1340,
        owner: 'System',
      ),
    ];
  }
}

class _GalleryModalPreview extends StatelessWidget {
  const _GalleryModalPreview();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_GalleryModalCubit, _GalleryModalState>(
      builder: (context, state) {
        final cubit = context.read<_GalleryModalCubit>();
        final status = switch (state) {
          _GalleryModalInitial() => AppAsyncViewStatus.initial,
          _GalleryModalLoading() => AppAsyncViewStatus.loading,
          _GalleryModalLoaded() => AppAsyncViewStatus.loaded,
          _GalleryModalError() => AppAsyncViewStatus.error,
        };
        final errorMessage = switch (state) {
          _GalleryModalError(:final message) => message,
          _ => null,
        };

        return AppModalSheet(
          title: context.l10n.frameworkNewDocumentTemplateTitle,
          subtitle: context.l10n.frameworkNewDocumentTemplateSubtitle,
          leading: CircleAvatar(
            radius: Sizes.p20,
            backgroundColor: context.colors.primaryContainer,
            child: Icon(
              Icons.description_outlined,
              color: context.colors.onPrimaryContainer,
            ),
          ),
          isBusy: state is _GalleryModalLoading,
          body: AppAsyncStateBody(
            status: status,
            errorMessage: errorMessage,
            onRetry: cubit.load,
            initialBuilder: (_) => const SizedBox.shrink(),
            loadedBuilder: (_) => const _GalleryModalLoadedBody(),
          ),
          footer: Row(
            mainAxisAlignment: .end,
            children: [
              AppActionButton.text(
                label: context.l10n.frameworkClose,
                icon: Icons.close_rounded,
                tone: .neutral,
                onPressed: state is _GalleryModalLoading
                    ? null
                    : () => Navigator.of(context).maybePop(),
              ),
              Gaps.w8,
              AppActionButton.outlined(
                label: context.l10n.frameworkError,
                icon: Icons.warning_amber_rounded,
                tone: .danger,
                onPressed: state is _GalleryModalLoading ? null : cubit.fail,
              ),
              Gaps.w8,
              AppActionButton.filled(
                label: context.l10n.frameworkSave,
                icon: Icons.save_outlined,
                onPressedAsync: state is _GalleryModalLoaded
                    ? () async {
                        await cubit.save();
                        if (context.mounted) {
                          await Navigator.of(context).maybePop();
                        }
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GalleryModalLoadedBody extends StatelessWidget {
  const _GalleryModalLoadedBody();

  @override
  Widget build(BuildContext context) {
    return AppFormSection(
      title: context.l10n.frameworkDocumentDataTitle,
      description: 'Body modalu z formularzem i wspolnymi komponentami.',
      items: [
        AppFormSectionItem(
          child: AppTextField(
            labelText: context.l10n.frameworkName,
            isRequired: true,
            hintText: context.l10n.frameworkDocumentNameHint,
            prefixIcon: Icons.title_rounded,
          ),
        ),
        AppFormSectionItem(
          child: AppDropdown<String>(
            value: 'open',
            labelText: context.l10n.frameworkStatus,
            options: [
              AppDropdownOption(
                value: 'open',
                label: context.l10n.frameworkDocumentStatusOpen,
              ),
              AppDropdownOption(
                value: 'closed',
                label: context.l10n.frameworkDocumentStatusClosed,
              ),
            ],
            onChanged: (_) {},
          ),
        ),
        AppFormSectionItem(
          child: AppDatePickerField(
            value: DateTime(2026, 4, 2),
            labelText: context.l10n.inventoryDates,
            firstDate: DateTime(2020),
            lastDate: DateTime(2035, 12, 31),
            onChanged: (_) {},
          ),
        ),
      ],
    );
  }
}

class _GalleryModalSideSheetBody extends StatelessWidget {
  const _GalleryModalSideSheetBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_GalleryModalCubit, _GalleryModalState>(
      builder: (context, state) {
        final cubit = context.read<_GalleryModalCubit>();
        final status = switch (state) {
          _GalleryModalInitial() => AppAsyncViewStatus.initial,
          _GalleryModalLoading() => AppAsyncViewStatus.loading,
          _GalleryModalLoaded() => AppAsyncViewStatus.loaded,
          _GalleryModalError() => AppAsyncViewStatus.error,
        };
        final errorMessage = switch (state) {
          _GalleryModalError(:final message) => message,
          _ => null,
        };

        return AppAsyncStateBody(
          status: status,
          errorMessage: errorMessage,
          onRetry: cubit.load,
          initialBuilder: (_) => const SizedBox.shrink(),
          loadedBuilder: (_) => const _GalleryModalLoadedBody(),
        );
      },
    );
  }
}

sealed class _GalleryModalState extends Equatable {
  const _GalleryModalState();

  @override
  List<Object?> get props => const [];
}

class _GalleryModalInitial extends _GalleryModalState {
  const _GalleryModalInitial();
}

class _GalleryModalLoading extends _GalleryModalState {
  const _GalleryModalLoading();
}

class _GalleryModalLoaded extends _GalleryModalState {
  const _GalleryModalLoaded();
}

class _GalleryModalError extends _GalleryModalState {
  const _GalleryModalError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class _GalleryModalCubit extends Cubit<_GalleryModalState> {
  _GalleryModalCubit() : super(const _GalleryModalInitial());

  Future<void> load() async {
    emit(const _GalleryModalLoading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    emit(const _GalleryModalLoaded());
  }

  void fail() {
    emit(const _GalleryModalError('Blad API: nie udalo sie pobrac slownika.'));
  }

  Future<void> save() async {
    emit(const _GalleryModalLoading());
    await Future<void>.delayed(const Duration(milliseconds: 700));
    emit(const _GalleryModalLoaded());
  }
}
