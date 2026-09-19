part of '../tasks_board_page.dart';

/// Widok formularza i pasek akcji edytora szablonu.
extension _TemplateEditorView on _TaskTemplateEditorState {
  Widget _buildEditorView(BuildContext context) => PopScope(
    canPop: !_isDirty || _saving,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;
      final shouldDiscard = await _confirmDiscard();
      if (shouldDiscard && context.mounted) {
        Navigator.of(context).pop();
      }
    },
    child: Scaffold(
      backgroundColor: context.colors.surface,
      body: _buildBody(context),
      bottomNavigationBar: _buildStickyActionBar(context),
    ),
  );

  Widget _buildBody(BuildContext context) {
    if (!_isCreating && _loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_isCreating && _loadError != null) {
      return _buildLoadError();
    }
    return _buildForm(context);
  }

  Widget _buildLoadError() => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.error_outline_rounded,
            size: 48,
            color: context.colors.error,
          ),
          const SizedBox(height: 12),
          Text(
            _loadError?.message ?? context.l10n.workspacesRetry,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.error),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => unawaited(_loadExistingTemplate()),
            icon: const Icon(Symbols.refresh_rounded),
            label: Text(context.l10n.workspacesRetry),
          ),
        ],
      ),
    ),
  );

  Widget _buildForm(BuildContext context) {
    final metadataState = context.watch<TaskSavedViewMetadataCubit?>()?.state;
    final projectLabels = metadataState is TaskSavedViewMetadataReady
        ? metadataState.labels
        : const <TaskLabelResponse>[];
    final availableStatuses = _TemplateEditorHelpers.buildAvailableStatuses(
      context,
      widget.columns,
    );

    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_saveError != null) _buildSaveError(context),
          _buildBasicSection(context),
          const SizedBox(height: 16),
          _buildPlanningSection(context, availableStatuses),
          const SizedBox(height: 16),
          _buildResponsibilitySection(context),
          const SizedBox(height: 16),
          _buildScopeSection(context),
          const SizedBox(height: 16),
          _buildClassificationSection(context),
          const SizedBox(height: 16),
          _buildMetadataSection(context, projectLabels),
        ],
      ),
    );
  }

  Widget _buildSaveError(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: context.colors.errorContainer,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Row(
      children: [
        Icon(Symbols.error_rounded, color: context.colors.onErrorContainer),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _saveError!,
            style: TextStyle(color: context.colors.onErrorContainer),
          ),
        ),
      ],
    ),
  );

  Widget _buildStickyActionBar(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLowest,
      border: Border(
        top: BorderSide(color: context.colors.outlineVariant),
      ),
    ),
    child: Row(
      children: [
        OutlinedButton(
          onPressed: _saving ? null : () => unawaited(_handleCancel()),
          child: Text(context.l10n.cancel),
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: _saving ? null : () => unawaited(_save()),
          icon: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Symbols.save_rounded, size: 18),
          label: Text(
            _isCreating
                ? context.l10n.tasksTemplatesCreateAction
                : context.l10n.tasksTemplatesSaveAction,
          ),
        ),
      ],
    ),
  );
}
