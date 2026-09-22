// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get storageNewDocument => 'New document';

  @override
  String get storageRouteUnavailableTitle => 'Files unavailable';

  @override
  String get storageRouteInvalidWorkspaceId =>
      'The workspace address is invalid.';

  @override
  String get storageRouteNotConfigured =>
      'Files are not configured for this session.';

  @override
  String get storageCreateDocumentDialogTitle => 'Create document';

  @override
  String get storageDocumentName => 'Name';

  @override
  String get storageDocumentNameHint => 'For example: meeting notes';

  @override
  String get storageDocumentFormat => 'Format';

  @override
  String get storageCreateDocumentButton => 'Create';

  @override
  String get storageCreateDocumentSuccess => 'The document was created.';

  @override
  String get storageFormatTxt => 'Text file (.txt)';

  @override
  String get storageFormatOdt => 'OpenDocument text (.odt)';

  @override
  String get storageFormatOds => 'OpenDocument spreadsheet (.ods)';

  @override
  String get storageFormatOdp => 'OpenDocument presentation (.odp)';

  @override
  String get storageFormatDocx => 'Word document (.docx)';

  @override
  String get storageFormatXlsx => 'Excel spreadsheet (.xlsx)';

  @override
  String get storageFormatPptx => 'PowerPoint presentation (.pptx)';

  @override
  String get appName => 'DevPlanner';

  @override
  String get loginSubtitle => 'Sign in to access modules.';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginUsernameRequired => 'Enter username.';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Enter password.';

  @override
  String get loginRememberCredentials => 'Remember username and password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginSubmitting => 'Signing in...';

  @override
  String get loginRedirecting => 'Redirecting to secure sign-in...';

  @override
  String get loginBffDescription =>
      'Sign-in takes place on the secure DevPlanner server page. Your password is not entered or stored in this application.';

  @override
  String get loginBffSubmit => 'Continue to secure sign-in';

  @override
  String get loginDesktopUnavailable =>
      'Desktop sign-in through the system browser is not configured yet.';

  @override
  String get authContractPending =>
      'Authentication is waiting for the standalone backend contract.';

  @override
  String get authActivationTitle => 'Activate account';

  @override
  String get authActivationTokenLabel => 'Activation token';

  @override
  String get authActivationPasswordLabel => 'New password';

  @override
  String get authResetTitle => 'Reset password';

  @override
  String get authResetLoginLabel => 'Username or email';

  @override
  String get authMfaTitle => 'Verify MFA';

  @override
  String get authMfaCodeLabel => 'Verification code';

  @override
  String get authFieldRequired => 'Enter a value.';

  @override
  String get globalUserFallback => 'User';

  @override
  String get adminUsersTitle => 'Users';

  @override
  String get adminUsersSubtitle => 'Manage local DevPlanner accounts';

  @override
  String get adminUsersUnavailableTitle => 'User administration unavailable';

  @override
  String get adminUsersUnavailableMessage =>
      'The administration transport is not configured yet. No substitute data is displayed.';

  @override
  String get adminUsersAccessDeniedTitle => 'Access denied';

  @override
  String get adminUsersAccessDeniedMessage =>
      'Your session does not have permission to read accounts.';

  @override
  String get adminUsersSearchHint => 'Search by login, email or display name';

  @override
  String get adminUsersRefresh => 'Refresh';

  @override
  String get adminUsersCreate => 'Create account';

  @override
  String get adminUsersEmptyTitle => 'No accounts';

  @override
  String get adminUsersEmptyMessage => 'No accounts match the current filters.';

  @override
  String get adminUsersLoadFailureTitle => 'Could not load accounts';

  @override
  String get adminUsersRetry => 'Try again';

  @override
  String get adminUsersLogin => 'Login';

  @override
  String get adminUsersEmail => 'Email';

  @override
  String get adminUsersDisplayName => 'Display name';

  @override
  String get adminUsersRoles => 'Roles';

  @override
  String get adminUsersStatus => 'Status';

  @override
  String get adminUsersCreateTitle => 'New account';

  @override
  String get adminUsersEditTitle => 'Edit account';

  @override
  String get adminUsersSave => 'Save';

  @override
  String get adminUsersCancel => 'Cancel';

  @override
  String get adminUsersRequired => 'Fill in the required fields.';

  @override
  String get adminUsersRoleSystemAdmin => 'System administrator';

  @override
  String get adminUsersRoleUser => 'User';

  @override
  String get adminUsersRoleSave => 'Save roles';

  @override
  String get adminUsersReactivate => 'Reactivate';

  @override
  String get adminUsersDeactivate => 'Deactivate';

  @override
  String get adminUsersSelfRoleBlocked =>
      'You cannot grant yourself administrator privileges.';

  @override
  String get adminUsersStatusPendingActivation => 'Pending activation';

  @override
  String get adminUsersStatusActive => 'Active';

  @override
  String get adminUsersStatusDeactivated => 'Deactivated';

  @override
  String get adminUsersStatusLocked => 'Locked';

  @override
  String get adminUsersConfirmAction => 'Confirm operation';

  @override
  String get adminUsersConfirmActionMessage =>
      'This operation changes the account state.';

  @override
  String get globalModuleDashboard => 'Dashboard';

  @override
  String get globalModuleInventory => 'Inventory';

  @override
  String get globalModuleBhp => 'BHP';

  @override
  String get globalModuleWorkspaces => 'Workspaces';

  @override
  String get appShellChangelogTitle => 'Changelog';

  @override
  String get appShellChangelogLoadError => 'Could not load the changelog.';

  @override
  String get appShellChangelogEmpty => 'There are no changelog entries.';

  @override
  String get appShellChangelogShowAll => 'Show all entries';

  @override
  String get appShellBrandName => 'DevPlanner';

  @override
  String get appShellCommandPaletteUnavailable =>
      'Global search is coming soon';

  @override
  String get appModalDismiss => 'Close dialog';

  @override
  String get workspacesMenuTitle => 'Workspaces';

  @override
  String get workspacesMenuSubtitle => 'Spaces, projects and collaboration';

  @override
  String get workspacesSectionOverview => 'Overview';

  @override
  String get workspacesSectionProjects => 'Projects';

  @override
  String get workspacesNoProjects => 'No projects';

  @override
  String get workspacesMenuCreateProject => 'Create first project';

  @override
  String get workspacesMenuAdd => 'Add';

  @override
  String get workspacesTaskList => 'List';

  @override
  String get workspacesMenuCreateTask => 'Add task';

  @override
  String get workspacesTaskKanban => 'Kanban';

  @override
  String get workspacesTaskAutomations => 'Automations';

  @override
  String get workspacesProjectCorkboard => 'Corkboard';

  @override
  String get workspaceShellTitle => 'Workspace';

  @override
  String get workspaceShellSubtitle => 'Workspace';

  @override
  String get workspaceShellCollapseMenu => 'Collapse menu';

  @override
  String get workspaceShellExpandMenu => 'Expand menu';

  @override
  String get workspaceNavigationCollapseBranch => 'Collapse branch';

  @override
  String get workspaceNavigationExpandBranch => 'Expand branch';

  @override
  String get workspaceShellNavigationTitle => 'Workspace';

  @override
  String get workspaceShellDashboard => 'Dashboard';

  @override
  String get workspaceShellProjects => 'Projects';

  @override
  String get workspaceShellProjectsPlaceholder =>
      'The project list will appear here';

  @override
  String get workspaceShellDashboardDescription =>
      'Dashboard skeleton — data and widgets will be connected after the contracts are agreed.';

  @override
  String get workspaceShellWidgetProjects => 'Projects';

  @override
  String get workspaceShellWidgetTasks => 'Tasks';

  @override
  String get workspaceShellWidgetActivity => 'Activity';

  @override
  String get workspaceShellBackToDirectory => 'Back to workspace directory';

  @override
  String get workspacesSectionTasks => 'Tasks';

  @override
  String get workspacesSectionFiles => 'Files and documents';

  @override
  String get workspacesSectionChat => 'Chat';

  @override
  String get workspacesSectionWhiteboards => 'Whiteboards';

  @override
  String get workspacesSectionWiki => 'Wiki';

  @override
  String get workspacesSectionNotifications => 'Notifications';

  @override
  String get workspacesSectionPending =>
      'The section structure is ready. The next screen will be connected to the Workspaces backend contract.';

  @override
  String get workspacesEmptyTitle => 'You do not have a workspace yet';

  @override
  String get workspacesEmptyMessage =>
      'Workspaces available for your account will appear here.';

  @override
  String get workspacesErrorTitle => 'Could not load workspaces';

  @override
  String get workspacesForbiddenTitle => 'No access to workspaces';

  @override
  String get workspacesSessionTitle => 'Your session requires sign-in again';

  @override
  String get workspacesTransportUnavailableTitle =>
      'Workspace transport unavailable';

  @override
  String get workspacesTransportUnavailableMessage =>
      'The workspace transport is not configured yet.';

  @override
  String get workspacesSessionMessage =>
      'Sign in again to load your workspaces.';

  @override
  String get workspacesForbiddenMessage =>
      'You do not have permission to read workspaces.';

  @override
  String get workspacesRequestFailedMessage =>
      'The server did not return the workspace list. Try again.';

  @override
  String get workspacesInvalidResponseMessage =>
      'The server returned invalid workspace data.';

  @override
  String workspacesHttpStatus(int statusCode) {
    return 'HTTP status: $statusCode';
  }

  @override
  String get workspacesRefresh => 'Refresh';

  @override
  String get workspacesRetry => 'Try again';

  @override
  String get workspacesCreatePrivateWorkspace => 'Create private workspace';

  @override
  String get workspacesCreateWorkspace => 'Create workspace';

  @override
  String get workspacesCreateWorkspaceTitle => 'New workspace';

  @override
  String get workspacesCreateWorkspaceSubtitle =>
      'Enter a name and create a new workspace.';

  @override
  String get workspacesEditWorkspaceTitle => 'Edit workspace';

  @override
  String get workspacesEditWorkspaceSubtitle =>
      'Enter a new name and customize the appearance of the workspace.';

  @override
  String get workspacesNameFieldLabel => 'Workspace name';

  @override
  String get workspacesNameFieldPlaceholder =>
      'e.g. Marketing, Project A, Finance';

  @override
  String get workspacesNameRequiredError => 'Name cannot be empty';

  @override
  String get workspacesPickIconLabel => 'Pick icon';

  @override
  String get workspacesAccentColorLabel => 'Accent color';

  @override
  String get workspacesCancelButton => 'Cancel';

  @override
  String get workspacesCreateButton => 'Create';

  @override
  String get workspacesSaveButton => 'Save';

  @override
  String get workspacesCreateProjectTitle => 'New project';

  @override
  String get workspacesCreateProjectSubtitle =>
      'Create a project and organize team work.';

  @override
  String get workspacesProjectNameLabel => 'Project name *';

  @override
  String get workspacesProjectNameHint =>
      'e.g. Mobile App Development, ERP Deployment...';

  @override
  String get workspacesProjectNameRequired => 'Please enter a project name';

  @override
  String get workspacesProjectDescriptionLabel =>
      'Project description (optional)';

  @override
  String get workspacesProjectDescriptionHint =>
      'Project goal, scope or objectives...';

  @override
  String get workspacesProjectVisibilityLabel => 'Project visibility';

  @override
  String get workspacesProjectVisibilityShared =>
      'Shared with all workspace members';

  @override
  String get workspacesProjectVisibilityPrivate => 'Private';

  @override
  String get projectSetupWizardTitle => 'New project';

  @override
  String get projectSetupWizardSubtitle =>
      'The wizard walks through the project configuration. You can skip steps 3-6.';

  @override
  String projectSetupStepCounter(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get projectSetupNextButton => 'Next';

  @override
  String get projectSetupBackButton => 'Back';

  @override
  String get projectSetupSkipToSummaryButton => 'Skip to summary';

  @override
  String get projectSetupCreateButton => 'Create project';

  @override
  String get projectSetupCreatingButton => 'Creating project…';

  @override
  String get projectSetupRetryButton => 'Try again';

  @override
  String get projectSetupRefreshPlanButton => 'Refresh plan';

  @override
  String get projectSetupCancelButton => 'Cancel';

  @override
  String get projectSetupStepStartTitle => 'Starting point';

  @override
  String get projectSetupStepStartSubtitle => 'What the project starts from.';

  @override
  String get projectSetupStepBasicsTitle => 'Basics';

  @override
  String get projectSetupStepAccessTitle => 'Access';

  @override
  String get projectSetupStepWorkflowTitle => 'Workflow';

  @override
  String get projectSetupStepWorkingStyleTitle => 'Ways of working';

  @override
  String get projectSetupStepBasicsSubtitle =>
      'Name, description and the look of the project.';

  @override
  String get projectSetupStepAccessSubtitle =>
      'Who will see the project and with which role.';

  @override
  String get projectSetupStepWorkflowSubtitle =>
      'The statuses that tasks will move through.';

  @override
  String get projectSetupStepWorkingStyleSubtitle =>
      'Default view, schedule and board settings.';

  @override
  String get projectSetupStepStarterFeaturesSubtitle =>
      'Automations created together with the project.';

  @override
  String get projectSetupStepSummarySubtitle =>
      'Review the plan and create the project.';

  @override
  String get projectSetupStepStarterFeaturesTitle => 'Starter features';

  @override
  String get projectSetupStepSummaryTitle => 'Summary';

  @override
  String get projectSetupStartBlankTitle => 'Blank project';

  @override
  String get projectSetupStartBlankDescription =>
      'A project without tasks, labels or fields. You configure everything in the next steps.';

  @override
  String get projectSetupStartTemplateTitle => 'From a project template';

  @override
  String get projectSetupStartTemplateDescription =>
      'Recreates the project together with the tasks, labels, fields and workflow stored in the template.';

  @override
  String get projectSetupTemplatesLoading => 'Loading templates…';

  @override
  String get projectSetupTemplatesEmpty =>
      'This workspace has no project templates yet.';

  @override
  String get projectSetupTemplatesUnavailable =>
      'We cannot load project templates right now.';

  @override
  String get projectSetupTemplatesUnavailableReason =>
      'Try again in a moment. If the problem repeats, report it to your administrator.';

  @override
  String get projectSetupTemplatesRetry => 'Retry loading templates';

  @override
  String projectSetupTemplateTasksCount(int count) {
    return 'Tasks: $count';
  }

  @override
  String projectSetupTemplateLabelsCount(int count) {
    return 'Labels: $count';
  }

  @override
  String projectSetupTemplateFieldsCount(int count) {
    return 'Fields: $count';
  }

  @override
  String projectSetupTemplateStatusesCount(int count) {
    return 'Custom statuses: $count';
  }

  @override
  String projectSetupTemplateVersionLabel(int version) {
    return 'Version $version';
  }

  @override
  String get projectSetupTemplatePreviewLoading =>
      'Loading the template preview…';

  @override
  String get projectSetupTemplatePreviewFailed =>
      'Could not load the template preview.';

  @override
  String get projectSetupProjectStatusLabel => 'Project status';

  @override
  String get projectSetupProjectStatusPlanned => 'Planned';

  @override
  String get projectSetupProjectStatusActive => 'Active';

  @override
  String get projectSetupProjectStatusOnHold => 'On hold';

  @override
  String get projectSetupProjectStatusCompleted => 'Completed';

  @override
  String get projectSetupAccessSharedTitle => 'Everyone in the workspace';

  @override
  String get projectSetupAccessSharedDescription =>
      'Every active workspace member sees the project, and the starter member list is skipped.';

  @override
  String get projectSetupAccessPrivateTitle => 'Private';

  @override
  String get projectSetupAccessPrivateDescription =>
      'Only selected members see the project. You are always an Owner and cannot remove yourself.';

  @override
  String get projectSetupAccessCreatorBadge => 'You — Owner';

  @override
  String get projectSetupAccessMembersLegend => 'Starter members';

  @override
  String get projectSetupAccessMembersLoading => 'Loading workspace members…';

  @override
  String get projectSetupAccessMembersEmpty =>
      'There are no other active workspace members.';

  @override
  String get projectSetupAccessMembersUnavailable =>
      'We cannot load the workspace member list right now.';

  @override
  String get projectSetupAccessMembersUnavailableReason =>
      'Try again in a moment. If the problem repeats, report it to your administrator. You can also add members after creating the project.';

  @override
  String get projectSetupAccessMembersRetry => 'Retry loading members';

  @override
  String projectSetupAccessMemberLabel(String prefix) {
    return 'User ($prefix…)';
  }

  @override
  String get projectSetupAccessRoleLabel => 'Role';

  @override
  String get projectSetupWorkflowFromTemplateTitle =>
      'Workflow from the template';

  @override
  String get projectSetupWorkflowFromTemplateDescription =>
      'A templated project uses the statuses stored in the template. You can change them after the project is created.';

  @override
  String get projectSetupWorkflowDefaultTitle => 'Standard';

  @override
  String get projectSetupWorkflowDefaultDescription =>
      'System task statuses of the project.';

  @override
  String get projectSetupWorkflowCatalogTitle => 'Catalog template';

  @override
  String get projectSetupWorkflowCatalogDescription =>
      'A ready-made set of columns matched to the type of work.';

  @override
  String get projectSetupWorkflowCatalogLegend => 'Catalog template';

  @override
  String get projectSetupWorkflowCatalogStandard => 'Standard';

  @override
  String get projectSetupWorkflowCatalogMarketing => 'Marketing';

  @override
  String get projectSetupWorkflowCatalogProduction => 'Production / Workshop';

  @override
  String get projectSetupWorkflowCatalogHr => 'HR / Recruiting';

  @override
  String get projectSetupWorkflowCatalogSoftware => 'IT / Software';

  @override
  String get projectSetupWorkflowExplicitTitle => 'Custom statuses';

  @override
  String get projectSetupWorkflowExplicitDescription =>
      'You define the columns, categories and WIP limits yourself.';

  @override
  String get projectSetupStatusNameLabel => 'Column name';

  @override
  String get projectSetupStatusColorLabel => 'Column color';

  @override
  String get projectSetupStatusCategoryLabel => 'Category';

  @override
  String get projectSetupStatusCategoryTodo => 'To do';

  @override
  String get projectSetupStatusCategoryInProgress => 'In progress';

  @override
  String get projectSetupStatusCategoryDone => 'Done';

  @override
  String get projectSetupStatusCategoryCancelled => 'Cancelled';

  @override
  String get projectSetupStatusWipLabel => 'WIP limit';

  @override
  String get projectSetupStatusDefaultLabel => 'Default for new tasks';

  @override
  String get projectSetupStatusAddButton => 'Add status';

  @override
  String get projectSetupStatusRemoveButton => 'Remove status';

  @override
  String get projectSetupScheduleLegend => 'Schedule';

  @override
  String get projectSetupScheduleManual => 'Manual';

  @override
  String get projectSetupSchedulePushSuccessors =>
      'Push successors on conflict';

  @override
  String get projectSetupScheduleStrictCascade => 'Full dependency cascade';

  @override
  String get projectSetupDefaultViewLegend => 'Default Tasks view';

  @override
  String get projectSetupViewList => 'List';

  @override
  String get projectSetupViewBoard => 'Kanban';

  @override
  String get projectSetupBoardLegend => 'Kanban board';

  @override
  String get projectSetupBoardDensityLegend => 'Card density';

  @override
  String get projectSetupDensityCompact => 'Compact';

  @override
  String get projectSetupDensityComfortable => 'Comfortable';

  @override
  String get projectSetupDensityDetailed => 'Detailed';

  @override
  String get projectSetupBoardSwimlaneLegend => 'Card grouping into swimlanes';

  @override
  String get projectSetupSwimlaneNone => 'No swimlanes';

  @override
  String get projectSetupSwimlaneAssignee => 'By assignee';

  @override
  String get projectSetupSwimlanePriority => 'By priority';

  @override
  String get projectSetupSwimlaneMilestone => 'By milestone';

  @override
  String get projectSetupBoardFieldsLegend => 'Fields visible on the card';

  @override
  String get projectSetupCardFieldAssignee => 'Assignees';

  @override
  String get projectSetupCardFieldDueDate => 'Due date';

  @override
  String get projectSetupCardFieldLabels => 'Labels';

  @override
  String get projectSetupCardFieldChecklist => 'Checklist';

  @override
  String get projectSetupCardFieldSubtasks => 'Subtasks';

  @override
  String get projectSetupCardFieldTimeTracking => 'Time tracking';

  @override
  String get projectSetupCardFieldBlockers => 'Blockers';

  @override
  String get projectSetupCardFieldCoverAttachment => 'Cover image';

  @override
  String get projectSetupCardFieldCustomFields => 'Custom fields';

  @override
  String get projectSetupListLegend => 'Task list';

  @override
  String get projectSetupListSortFieldLegend => 'Default sorting';

  @override
  String get projectSetupListSortFieldPosition => 'Manual order';

  @override
  String get projectSetupListSortFieldUpdatedAt => 'Last update';

  @override
  String get projectSetupListSortFieldDueAt => 'Due date';

  @override
  String get projectSetupListSortFieldPriority => 'Priority';

  @override
  String get projectSetupListSortFieldTitle => 'Title';

  @override
  String get projectSetupListSortDirectionLegend => 'Sort direction';

  @override
  String get projectSetupListSortDirectionAscending => 'Ascending';

  @override
  String get projectSetupListSortDirectionDescending => 'Descending';

  @override
  String get projectSetupListGroupByLegend => 'List grouping';

  @override
  String get projectSetupListGroupByNone => 'No grouping';

  @override
  String get projectSetupListGroupByStatus => 'By status';

  @override
  String get projectSetupListGroupByCustomStatus => 'By custom status';

  @override
  String get projectSetupListGroupByPriority => 'By priority';

  @override
  String get projectSetupListGroupByAssignee => 'By assignee';

  @override
  String get projectSetupCapacityLegend => 'Default workspace daily capacity';

  @override
  String get projectSetupCapacityDescription =>
      'In minutes per person. The change applies to every workspace member.';

  @override
  String get projectSetupCapacityFieldLabel => 'Minutes per day';

  @override
  String get projectSetupCapacityAdminOnly =>
      'Changing the capacity requires the Admin or Owner role in the workspace.';

  @override
  String get projectSetupStartersDescription =>
      'Selected automation recipes are created together with the project. You can disable them later in project settings.';

  @override
  String get projectSetupRecipeCriticalToBlocked => 'Critical task as blocked';

  @override
  String get projectSetupRecipeDueSoonHighPriority =>
      'Raise priority before the due date';

  @override
  String get projectSetupRecipeDoneClearDueDate =>
      'Clear the due date when done';

  @override
  String get projectSetupRecipeDoneCreateReviewSubtask =>
      'Add a review subtask';

  @override
  String get projectSetupRecipeCriticalToBlockedDescription =>
      'When the status changes and the priority is critical, it sets the blocked status.';

  @override
  String get projectSetupRecipeDueSoonHighPriorityDescription =>
      'Tasks due within two days get a high priority.';

  @override
  String get projectSetupRecipeDoneClearDueDateDescription =>
      'When a task is completed, it clears the due date so planning does not show a stale date.';

  @override
  String get projectSetupRecipeDoneCreateReviewSubtaskDescription =>
      'When a task is completed, it creates a subtask with a result review.';

  @override
  String get projectSetupSummaryLegend => 'What will be created';

  @override
  String get projectSetupSummarySource => 'Source';

  @override
  String get projectSetupSummarySourceBlank => 'Blank project';

  @override
  String projectSetupSummarySourceTemplate(String name) {
    return 'Template: $name';
  }

  @override
  String get projectSetupSummaryName => 'Name';

  @override
  String get projectSetupSummaryVisibility => 'Visibility';

  @override
  String get projectSetupSummaryStatus => 'Status';

  @override
  String get projectSetupSummaryMembers => 'Members';

  @override
  String get projectSetupSummaryMembersShared => 'All active workspace members';

  @override
  String projectSetupSummaryMembersCount(int count) {
    return '$count people';
  }

  @override
  String get projectSetupSummaryWorkflow => 'Workflow';

  @override
  String get projectSetupSummaryWorkflowDefault => 'System statuses';

  @override
  String projectSetupSummaryWorkflowCatalog(String name) {
    return 'Catalog template: $name';
  }

  @override
  String projectSetupSummaryWorkflowExplicit(int count) {
    return '$count custom statuses';
  }

  @override
  String get projectSetupSummaryWorkflowFromTemplate =>
      'From the project template';

  @override
  String get projectSetupSummaryView => 'Default Tasks view';

  @override
  String get projectSetupSummarySchedule => 'Schedule';

  @override
  String get projectSetupSummaryCapacity => 'Daily capacity';

  @override
  String projectSetupSummaryCapacityValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get projectSetupSummaryBoard => 'Kanban board';

  @override
  String get projectSetupSummaryRecipes => 'Automations';

  @override
  String get projectSetupSummaryRecipesNone => 'None';

  @override
  String get projectSetupSummaryPlanLoading => 'Building the plan…';

  @override
  String get projectSetupSummaryPlanUnavailable =>
      'The plan has not been built yet.';

  @override
  String get projectSetupSummaryPlanStale =>
      'Settings changed since the plan was built.';

  @override
  String get projectSetupSummaryWarningsLegend => 'Warnings';

  @override
  String get projectSetupSummaryTemplateCounts =>
      'The template will bring the tasks, labels and fields shown in the plan.';

  @override
  String get projectSetupPreviewLegend => 'Project preview';

  @override
  String get projectSetupPreviewUntitledProject => 'Untitled project';

  @override
  String projectSetupPreviewTemplateBadge(String name) {
    return 'Template: $name';
  }

  @override
  String get projectSetupPreviewRefreshing => 'Refreshing the preview';

  @override
  String get projectSetupPreviewLoading => 'Loading the template preview…';

  @override
  String get projectSetupPreviewRetryHint =>
      'Try again. If the problem repeats, report it to your administrator.';

  @override
  String projectSetupPreviewMoreTasks(int count) {
    return '+$count more tasks';
  }

  @override
  String projectSetupPreviewMoreItems(int count) {
    return '+$count more';
  }

  @override
  String projectSetupPreviewWipBadge(int limit) {
    return 'WIP $limit';
  }

  @override
  String get projectSetupPreviewColumnTask => 'Task';

  @override
  String get projectSetupPreviewColumnStatus => 'Status';

  @override
  String get projectSetupPreviewColumnPriority => 'Priority';

  @override
  String get projectSetupPreviewEmptyBoardTitle => 'Nothing to preview yet';

  @override
  String get projectSetupPreviewEmptyBoardBody =>
      'This option brings no custom columns. The board will be created from the system statuses.';

  @override
  String get projectSetupPreviewColumnsFromTemplate =>
      'Columns from the template';

  @override
  String get projectSetupPreviewColumnsFromTemplateBody =>
      'Names, colours and WIP limits come straight from the template. You will see them in the project right after it is created.';

  @override
  String get projectSetupPreviewColumnsExplicit => 'Your columns';

  @override
  String get projectSetupPreviewColumnsExplicitBody =>
      'You define these columns yourself. They will appear in the project in the order given.';

  @override
  String get projectSetupPreviewColumnsPlan => 'Columns confirmed by the plan';

  @override
  String projectSetupPreviewColumnsPlanBody(int count) {
    return 'The plan confirms these columns plus $count system statuses that are always created.';
  }

  @override
  String get projectSetupPreviewColumnsSystem => 'System statuses';

  @override
  String projectSetupPreviewColumnsSystemBody(int count) {
    return 'System columns ($count) are created in every new project. You will see their names and colours once it is created.';
  }

  @override
  String get projectSetupPreviewColumnsSystemNoCount =>
      'System columns are created in every new project; you will see their names and colours once it is created.';

  @override
  String projectSetupPreviewColumnsCatalogBody(String name) {
    return 'A ready-made status layout: $name. You will see the columns in the project once it is created.';
  }

  @override
  String get projectSetupPreviewMembersTitle => 'Who will see the project';

  @override
  String get projectSetupPreviewMembersShared =>
      'All active workspace members.';

  @override
  String projectSetupPreviewMembersPrivate(int count) {
    return 'Invited people: $count.';
  }

  @override
  String get projectSetupPreviewMembersPrivateNone =>
      'Only you for now. You can add members now or later.';

  @override
  String get projectSetupPreviewBoardSettingsTitle => 'Board settings';

  @override
  String get projectSetupPreviewListSettingsTitle => 'List settings';

  @override
  String projectSetupPreviewVisibleFields(int count) {
    return 'Visible fields: $count';
  }

  @override
  String get projectSetupPreviewRecipesTitle => 'Automations';

  @override
  String get projectSetupPreviewRecipesNone =>
      'No automation selected. You can add them later.';

  @override
  String get projectSetupPreviewRecipeWhen => 'When';

  @override
  String get projectSetupPreviewRecipeThen => 'then';

  @override
  String projectSetupPreviewWarningsBody(int count) {
    return 'The plan contains warnings: $count. See them above the “Create project” button.';
  }

  @override
  String get projectSetupRecipeCriticalToBlockedTrigger =>
      'a task has a critical priority';

  @override
  String get projectSetupRecipeCriticalToBlockedAction =>
      'set the status to blocked';

  @override
  String get projectSetupRecipeDueSoonHighPriorityTrigger =>
      'a task is due within two days';

  @override
  String get projectSetupRecipeDueSoonHighPriorityAction =>
      'raise the priority to high';

  @override
  String get projectSetupRecipeDoneClearDueDateTrigger => 'a task is completed';

  @override
  String get projectSetupRecipeDoneClearDueDateAction =>
      'clear the task due date';

  @override
  String get projectSetupRecipeDoneCreateReviewSubtaskTrigger =>
      'a task is completed';

  @override
  String get projectSetupRecipeDoneCreateReviewSubtaskAction =>
      'add a subtask reviewing the result';

  @override
  String get projectSetupHelpSwimlanesTitle => 'Board lanes';

  @override
  String get projectSetupHelpSwimlanesBody =>
      'Lanes split the board into horizontal sections, for example one per assignee or priority. They do not change the task status.';

  @override
  String get projectSetupHelpWipTitle => 'WIP limit';

  @override
  String get projectSetupHelpWipBody =>
      'The maximum number of tasks that can sit in this column at the same time.';

  @override
  String get projectSetupHelpStatusCategoryTitle => 'Status category';

  @override
  String get projectSetupHelpStatusCategoryBody =>
      'The category tells reports whether a task is waiting, in progress or finished. You can name the column however you like.';

  @override
  String get projectSetupHelpCascadeTitle => 'Dependency cascade';

  @override
  String get projectSetupHelpCascadeBody =>
      'When one task moves its due date, the system can move the tasks that depend on it as well.';

  @override
  String get projectSetupHelpCapacityTitle => 'Daily capacity';

  @override
  String get projectSetupHelpCapacityBody =>
      'Minutes of work planned per person per day. This setting applies to the whole workspace.';

  @override
  String get projectSetupHelpVisibilityTitle => 'Private visibility';

  @override
  String get projectSetupHelpVisibilityBody =>
      'Only the members you add will see the project. People managing the workspace keep access according to their permissions.';

  @override
  String get projectSetupHelpAutomationsTitle => 'Automations';

  @override
  String get projectSetupHelpAutomationsBody =>
      'Rules run an action after a specific event. You can turn them off later.';

  @override
  String get projectSetupHelpCatalogWorkflowTitle =>
      'Catalog workflow template';

  @override
  String get projectSetupHelpCatalogWorkflowBody =>
      'A ready-made status layout, not a full project template with tasks.';

  @override
  String get projectSetupHelpDensityTitle => 'Card density';

  @override
  String get projectSetupHelpDensityBody =>
      'Decides how much detail and spacing a card has on the board.';

  @override
  String get projectSetupHelpMembersTitle => 'Initial members';

  @override
  String get projectSetupHelpMembersBody =>
      'People who will see the project straight away. You can change their roles after the project is created.';

  @override
  String get projectSetupHelpPreviewTitle => 'Project preview';

  @override
  String get projectSetupHelpPreviewBody =>
      'The preview shows a slice of what will be created: real tasks, columns and labels from the selected template.';

  @override
  String projectSetupHelpSemantics(String title) {
    return 'Help: $title';
  }

  @override
  String get projectSetupAppearanceLegend => 'Project appearance';

  @override
  String get projectSetupAppearanceHint =>
      'Icon and colour shown in the project tree and in the project header.';

  @override
  String get projectSetupAccessMembersHint =>
      'Select the people who should see the project right away.';

  @override
  String projectSetupAccessSelectedCount(int count) {
    return 'Selected people: $count';
  }

  @override
  String get projectSetupStatusesLegend => 'Custom columns';

  @override
  String get projectSetupStatusesHint =>
      'Name, colour, category and WIP limit make up a single board column.';

  @override
  String get projectSetupSummaryDecisionsLegend => 'Your decisions';

  @override
  String get projectSetupSummaryChangeButton => 'Change';

  @override
  String get projectSetupWorkflowOptionColumnsLegend =>
      'Columns in this option';

  @override
  String get projectSetupWorkflowSystemPreviewHint =>
      'These columns are created in every new project.';

  @override
  String get projectSetupWorkflowCatalogPreviewHint =>
      'Pick a ready-made layout from the list — the preview on the right shows its columns once you select it.';

  @override
  String get projectSetupWorkflowExplicitPreviewHint =>
      'You add your own columns below.';

  @override
  String projectSetupPreviewMoreColumns(int count) {
    return '+$count columns';
  }

  @override
  String get projectSetupWorkingStyleAdjustBoard =>
      'Also adjust board settings';

  @override
  String get projectSetupWorkingStyleAdjustList => 'Also adjust list settings';

  @override
  String get projectSetupWorkingStyleCollapseBoard => 'Collapse board settings';

  @override
  String get projectSetupWorkingStyleCollapseList => 'Collapse list settings';

  @override
  String get projectSetupWorkingStyleHiddenDefaults =>
      'The other view\'s settings go into the project with default values; you will see them in the summary.';

  @override
  String get projectSetupPreviewColumnsApproved => 'Matches the server plan';

  @override
  String get projectSetupPreviewColumnsApprovedBody =>
      'The server checked the template version and will create the project with exactly this content: columns, tasks and labels come straight from the template, and the plan does not change its workflow.';

  @override
  String get projectSetupErrorTitle => 'The operation could not be completed';

  @override
  String projectSetupErrorCodeLabel(String code) {
    return 'Code: $code';
  }

  @override
  String projectSetupErrorTraceIdLabel(String traceId) {
    return 'Trace id: $traceId';
  }

  @override
  String get projectSetupErrorConflictIdempotency =>
      'This operation key was already used for a different request. The next attempt uses a new key.';

  @override
  String get projectSetupErrorConflictInProgress =>
      'An operation with the same key is still in progress. Try again in a moment.';

  @override
  String get projectSetupErrorTemplateVersion =>
      'The project template changed in another session. Its preview was refreshed — review the summary and try again.';

  @override
  String get projectSetupErrorForbidden =>
      'You are not allowed to create a project in this workspace.';

  @override
  String get projectSetupErrorNotFound =>
      'The workspace or the template is no longer available.';

  @override
  String get projectSetupErrorValidation =>
      'The wizard data could not be saved. Fix the highlighted values.';

  @override
  String get projectSetupErrorUnavailable =>
      'Creating projects is unavailable right now. Try again in a moment; if the problem repeats, report it to your administrator.';

  @override
  String get projectResourceUnavailableMessage =>
      'We have no server connection right now, so nothing was saved. Try again in a moment.';

  @override
  String get projectSetupErrorCancelled =>
      'The operation was cancelled before it was sent.';

  @override
  String get projectSetupWarningMembersIgnoredForShared =>
      'Every workspace member sees a shared project, so the starter member list will be skipped.';

  @override
  String get projectSetupWarningPrivateMembersLimited =>
      'A private project stays visible only to you until you add members.';

  @override
  String get projectSetupWarningTemplateFieldsOverridden =>
      'Descriptive fields come from the wizard, while the workflow, labels, fields and tasks come from the template.';

  @override
  String get projectSetupWarningWorkspaceCapacityChanged =>
      'The default workspace daily capacity will change for every member.';

  @override
  String get projectSetupValidationNameRequired => 'Enter the project name.';

  @override
  String get projectSetupValidationNameTooLong =>
      'The project name can have at most 160 characters.';

  @override
  String get projectSetupValidationDescriptionTooLong =>
      'The project description can have at most 4000 characters.';

  @override
  String get projectSetupValidationTemplateRequired =>
      'Pick a project template or start from a blank project.';

  @override
  String get projectSetupValidationMemberDuplicated =>
      'This user appears on the list more than once.';

  @override
  String get projectSetupValidationStatusNameRequired =>
      'Every workflow status needs a name.';

  @override
  String get projectSetupValidationStatusNameInvalid =>
      'Status names must be unique and at most 60 characters long.';

  @override
  String get projectSetupValidationStatusesLimitExceeded =>
      'A workflow can have between 1 and 20 custom statuses.';

  @override
  String get projectSetupValidationStatusWipInvalid =>
      'The WIP limit must be between 1 and 999.';

  @override
  String get projectSetupValidationCapacityOutOfRange =>
      'The capacity must be between 0 and 1440 minutes.';

  @override
  String get projectSetupValidationBoardFieldsRequired =>
      'Select at least one field visible on the card.';

  @override
  String get projectSetupCreatedSuccess => 'The project was created.';

  @override
  String get workspacesCreateWhiteboardTitle => 'New whiteboard';

  @override
  String get workspacesCreateWhiteboardSubtitle =>
      'Create a whiteboard for sketching, diagrams and brainstorming.';

  @override
  String get workspacesWhiteboardNameLabel => 'Whiteboard name *';

  @override
  String get workspacesWhiteboardNameHint =>
      'e.g. System architecture, User journey map...';

  @override
  String get workspacesWhiteboardNameRequired =>
      'Please enter a whiteboard name';

  @override
  String get workspacesWhiteboardFormatLabel => 'Whiteboard format';

  @override
  String get workspacesWhiteboardFormatCanvas => 'Infinite canvas';

  @override
  String get workspacesWhiteboardFormatA4 => 'A4 Document';

  @override
  String get workspacesMenuCreateWhiteboard => 'Create whiteboard';

  @override
  String get workspacesMenuAddAnotherWhiteboard => 'Add another whiteboard';

  @override
  String get workspacesCreateTaskTitle => 'New task';

  @override
  String get workspacesCreateTaskSubtitle =>
      'Add a task to the project workflow.';

  @override
  String get workspacesTaskTitleLabel => 'Task title *';

  @override
  String get workspacesTaskTitleHint => 'Task title...';

  @override
  String get workspacesTaskTitleRequired => 'Please enter a task title';

  @override
  String get workspacesTaskDescriptionLabel => 'Task description (optional)';

  @override
  String get workspacesTaskDescriptionHint =>
      'Add details, reproduction steps or criteria...';

  @override
  String get workspacesTaskPriorityLabel => 'Priority';

  @override
  String get workspacesTaskPriorityLow => 'Low';

  @override
  String get workspacesTaskPriorityNormal => 'Normal';

  @override
  String get workspacesTaskPriorityHigh => 'High';

  @override
  String get workspacesTaskPriorityCritical => 'Critical';

  @override
  String get workspacesTaskStatusLabel => 'Initial status';

  @override
  String get workspacesTaskStatusTodo => 'To do';

  @override
  String get workspacesTaskStatusInProgress => 'In progress';

  @override
  String get workspacesTaskStatusBacklog => 'Backlog';

  @override
  String get workspacesCreateWikiTitle => 'New Wiki page';

  @override
  String get workspacesCreateWikiSubtitle =>
      'Add an article to the project knowledge base.';

  @override
  String get workspacesWikiTitleLabel => 'Page title *';

  @override
  String get workspacesWikiTitleHint =>
      'e.g. Technical requirements, Code standards...';

  @override
  String get workspacesWikiTitleRequired => 'Please enter a page title';

  @override
  String get workspacesCreateCorkboardTitle => 'Pin a note';

  @override
  String get workspacesCreateCorkboardSubtitle =>
      'Add a note to the project corkboard.';

  @override
  String get workspacesCorkboardTitleLabel => 'Note title *';

  @override
  String get workspacesCorkboardTitleHint => 'Short title...';

  @override
  String get workspacesCorkboardTitleRequired => 'Please enter a title';

  @override
  String get workspacesCorkboardContentLabel => 'Note content (optional)';

  @override
  String get workspacesCorkboardContentHint =>
      'Enter note content or reminders...';

  @override
  String get workspacesCorkboardColorLabel => 'Note color';

  @override
  String get workspacesCreateFolderTitle => 'New folder';

  @override
  String get workspacesCreateFolderSubtitle =>
      'Create a folder in project files repository.';

  @override
  String get workspacesFolderNameLabel => 'Folder name *';

  @override
  String get workspacesFolderNameHint =>
      'e.g. Documentation, Attachments, Mockups...';

  @override
  String get workspacesFolderNameRequired => 'Please enter a folder name';

  @override
  String get workspacesEditAction => 'Edit';

  @override
  String get workspacesPinAction => 'Pin to favorites';

  @override
  String get workspacesUnpinAction => 'Unpin from favorites';

  @override
  String get workspacesHideAction => 'Hide from list';

  @override
  String get workspacesShowAction => 'Restore to list';

  @override
  String get workspacesMyTasksLabel => 'My tasks';

  @override
  String get workspacesMyFilesLabel => 'My files';

  @override
  String get workspacesMyPrivateSectionLabel => 'Private';

  @override
  String get workspacesMyWorkspacesSection => 'My workspaces';

  @override
  String workspacesFavoritesSection(int count) {
    return 'Favorites ($count)';
  }

  @override
  String workspacesTeamWorkspacesSection(int count) {
    return 'Team spaces ($count)';
  }

  @override
  String get workspacesAllWorkspacesSection => 'All workspaces';

  @override
  String get workspacesHiddenWorkspacesLabel => 'Hidden workspaces';

  @override
  String get workspacesOwnerBadge => 'Owner';

  @override
  String get workspacesSharedBadge => 'Shared';

  @override
  String get workspacesPersonalBadge => 'Private';

  @override
  String get globalModuleOther => 'Other';

  @override
  String get globalModuleOrders => 'Orders';

  @override
  String get globalModuleSettings => 'Settings';

  @override
  String get globalActionSettings => 'Settings';

  @override
  String get globalActionLogout => 'Sign out';

  @override
  String get appDashboardTitle => 'Dashboard';

  @override
  String get appDashboardSubtitle =>
      'Main application surface that aggregates modules and future system areas.';

  @override
  String get appDashboardPlaceholderTitle => 'New top-level module';

  @override
  String get appDashboardPlaceholderMessage =>
      'This is the new parent application dashboard. In the next step, it can become a shared overview for Inventory, BHP, and future modules.';

  @override
  String get dashboardContextMenuChangeWallpaper => 'Change wallpaper';

  @override
  String get dashboardContextMenuManageShortcuts => 'Manage shortcuts';

  @override
  String get dashboardContextMenuAddWidget => 'Add widget';

  @override
  String get dashboardContextMenuAutoArrange => 'Auto arrange';

  @override
  String get dashboardContextMenuSnapToGrid => 'Snap to grid';

  @override
  String get dashboardCollapsedTrayTitle => 'Desktop Tray';

  @override
  String get dashboardCollapsedTraySubtitle =>
      'Items hidden due to small window size. Increase the window size to automatically restore them to the desktop.';

  @override
  String dashboardCollapsedTrayWidgets(int count) {
    return 'Widgets ($count)';
  }

  @override
  String dashboardCollapsedTrayShortcuts(int count) {
    return 'Shortcuts ($count)';
  }

  @override
  String get dashboardCollapsedTrayNoItems => 'All items fit on the screen.';

  @override
  String get dashboardWidgetRefreshTooltip => 'Refresh';

  @override
  String get dashboardWidgetResizeTitle => 'Change size';

  @override
  String dashboardWidgetResizeLabel(Object size) {
    return 'Size $size';
  }

  @override
  String get dashboardWidgetRemoveAction => 'Remove from desktop';

  @override
  String get dashboardWidgetBringToFront => 'Bring to front';

  @override
  String get dashboardWidgetSendToBack => 'Send to back';

  @override
  String get dashboardWidgetCategoryAll => 'All';

  @override
  String get dashboardWidgetCategoryGeneral => 'General';

  @override
  String get dashboardWidgetPickerTitle => 'Add widget';

  @override
  String get dashboardWidgetPickerCloseTooltip => 'Close';

  @override
  String get dashboardWidgetPickerAddButton => 'Add widget';

  @override
  String get dashboardWidgetPickerNoSpaceMessage =>
      'No free space on the dashboard.';

  @override
  String get dashboardWidgetPickerPreviewTitle => 'WIDGET PREVIEW';

  @override
  String get dashboardWallpaperPickerTitle => 'Change wallpaper';

  @override
  String get dashboardWallpaperPickerSubtitle =>
      'Choose one of the available desktop wallpapers.';

  @override
  String get dashboardShortcutRenameTitle => 'Rename shortcut';

  @override
  String get dashboardShortcutRenameSubtitle =>
      'The new label will appear under the desktop icon.';

  @override
  String get dashboardShortcutRenameFieldLabel => 'New name';

  @override
  String get dashboardShortcutRenameCancel => 'Cancel';

  @override
  String get dashboardShortcutRenameSave => 'Save';

  @override
  String get dashboardShortcutsPanelTitle => 'Available modules';

  @override
  String get dashboardShortcutsPanelCloseTooltip => 'Close';

  @override
  String get dashboardShortcutsPanelSubtitle =>
      'Click a module to place it in a free spot on the dashboard, or drag its icon directly onto the wallpaper.';

  @override
  String get dashboardShortcutsPanelRenameAction => 'Rename';

  @override
  String get dashboardShortcutsPanelRemoveAction => 'Remove from dashboard';

  @override
  String get dashboardShortcutsPickerTitle => 'Available modules';

  @override
  String get dashboardShortcutsPickerCloseTooltip => 'Close';

  @override
  String get dashboardShortcutsPickerInstruction =>
      'Click a module to add it to an empty spot on the dashboard, or drag its icon directly onto the wallpaper.';

  @override
  String get dashboardShortcutsPickerVisibleLabel => 'Visible';

  @override
  String get dashboardShortcutsPickerDragHint => 'Click / drag icon';

  @override
  String get dashboardQuickActionsName => 'Quick actions';

  @override
  String get dashboardQuickActionsDescription =>
      'Gives fast access to key forms and system functions.';

  @override
  String get dashboardQuickActionsCategory => 'General';

  @override
  String get dashboardQuickActionsInventoryAction => 'Inventory';

  @override
  String get dashboardQuickActionsBhpAction => 'BHP issue';

  @override
  String get dashboardQuickActionsSettingsAction => 'Settings';

  @override
  String get dashboardStartupModuleName => 'App Autostart';

  @override
  String get dashboardStartupModuleDescription =>
      'Choose which module will open automatically when launching the app.';

  @override
  String get dashboardStartupModuleCategory => 'General';

  @override
  String get dashboardActiveInventoriesName => 'Active inventories';

  @override
  String get dashboardActiveInventoriesDescription =>
      'List of active inventories currently in progress across branches.';

  @override
  String get dashboardActiveInventoriesCategory => 'Inventory';

  @override
  String get dashboardActiveInventoriesErrorTitle => 'Failed to load data';

  @override
  String get dashboardActiveInventoriesRetryLabel => 'Try again';

  @override
  String get dashboardActiveInventoriesEmptyTitle => 'No active inventories';

  @override
  String dashboardActiveInventoriesSheetsLabel(int count) {
    return 'Sheets: $count';
  }

  @override
  String get dashboardBhpUsersName => 'BHP: employees';

  @override
  String get dashboardBhpUsersDescription =>
      'Quick preview of BHP employees with a shortcut to the employee list module.';

  @override
  String get dashboardBhpUsersCategory => 'BHP';

  @override
  String get dashboardBhpUsersErrorTitle => 'Failed to load employees';

  @override
  String get dashboardBhpUsersSectionTitle => 'BHP employees';

  @override
  String get dashboardBhpUsersEmptyTitle => 'No employees';

  @override
  String get dashboardBhpUsersEmptyMessage => 'No active employees were found.';

  @override
  String get dashboardBhpUsersNoPositionLabel => 'No position';

  @override
  String dashboardBhpUsersDeadlineOverdueLabel(int days) {
    return '$days days overdue';
  }

  @override
  String get dashboardBhpUsersDeadlineTodayLabel => 'today';

  @override
  String dashboardBhpUsersDeadlineUpcomingLabel(int days) {
    return 'in $days days';
  }

  @override
  String dashboardBhpUsersDeadlineOverdueCountLabel(int count) {
    return '$count overdue';
  }

  @override
  String dashboardBhpUsersDeadlineUpcomingCountLabel(int count) {
    return '$count soon';
  }

  @override
  String get dashboardBhpUsersDeadlineOkLabel => 'ok';

  @override
  String get dashboardBhpPositionsName => 'BHP: positions';

  @override
  String get dashboardBhpPositionsDescription =>
      'Quick preview of BHP positions with a shortcut to the full position list.';

  @override
  String get dashboardBhpPositionsCategory => 'BHP';

  @override
  String get dashboardBhpPositionsErrorTitle => 'Failed to load positions';

  @override
  String get dashboardBhpPositionsSectionTitle => 'BHP positions';

  @override
  String get dashboardBhpPositionsEmptyTitle => 'No positions';

  @override
  String get dashboardBhpPositionsEmptyMessage =>
      'No active positions were found.';

  @override
  String get dashboardBhpPositionsNoNotesLabel => 'No notes';

  @override
  String get dashboardBhpPositionsActiveLabel => 'active';

  @override
  String get dashboardBhpPositionsInactiveLabel => 'inactive';

  @override
  String get dashboardBhpEquipmentName => 'BHP: equipment';

  @override
  String get dashboardBhpEquipmentDescription =>
      'Quick preview of the BHP equipment catalog with a shortcut to the full list.';

  @override
  String get dashboardBhpEquipmentCategory => 'BHP';

  @override
  String get dashboardBhpEquipmentErrorTitle => 'Failed to load equipment';

  @override
  String get dashboardBhpEquipmentSectionTitle => 'BHP equipment';

  @override
  String get dashboardBhpEquipmentEmptyTitle => 'No equipment';

  @override
  String get dashboardBhpEquipmentEmptyMessage =>
      'No active equipment was found.';

  @override
  String get dashboardBhpEquipmentNoPeriodLabel => 'No period';

  @override
  String get dashboardBhpEquipmentActiveLabel => 'active';

  @override
  String get dashboardBhpUpcomingName => 'BHP: upcoming';

  @override
  String get dashboardBhpUpcomingDescription =>
      'List of BHP alerts approaching their deadline and needing preparation.';

  @override
  String get dashboardBhpUpcomingCategory => 'BHP';

  @override
  String get dashboardBhpUpcomingErrorTitle => 'Failed to load upcoming alerts';

  @override
  String get dashboardBhpUpcomingRefreshLabel => 'Refresh';

  @override
  String get dashboardBhpUpcomingSectionTitle => 'Upcoming';

  @override
  String get dashboardBhpUpcomingEmptyTitle => 'No upcoming alerts';

  @override
  String get dashboardBhpUpcomingEmptyMessage =>
      'There are no items approaching their deadline.';

  @override
  String get dashboardBhpOverdueName => 'BHP: overdue';

  @override
  String get dashboardBhpOverdueDescription =>
      'List of the most urgent BHP alerts that are already overdue.';

  @override
  String get dashboardBhpOverdueCategory => 'BHP';

  @override
  String get dashboardBhpOverdueErrorTitle => 'Failed to load overdue alerts';

  @override
  String get dashboardBhpOverdueRefreshLabel => 'Refresh';

  @override
  String get dashboardBhpOverdueSectionTitle => 'Overdue';

  @override
  String get dashboardBhpOverdueEmptyTitle => 'No overdue alerts';

  @override
  String get dashboardBhpOverdueEmptyMessage =>
      'All BHP items are within their deadlines.';

  @override
  String get dashboardInventorySummaryName => 'Inventory stats';

  @override
  String get dashboardInventorySummaryDescription =>
      'Overview of inventory progress, active sheets, and latest readings.';

  @override
  String get dashboardInventorySummaryCategory => 'Inventory';

  @override
  String get dashboardInventorySummaryActiveSheetsLabel => 'Active sheets';

  @override
  String get dashboardInventorySummaryCompletedLabel => 'Completed';

  @override
  String get dashboardInventorySummaryProgressLabel => 'Overall progress';

  @override
  String get settingsHeaderTitle => 'Application settings';

  @override
  String get settingsHeaderSubtitle =>
      'Local configuration shared across all modules. This section will grow with language, preferences and module settings.';

  @override
  String get settingsCategoriesTitle => 'Categories';

  @override
  String get settingsCategoriesSubtitle => 'Choose a configuration area';

  @override
  String get settingsSectionAppearanceTitle => 'Appearance';

  @override
  String get settingsSectionAppearanceSubtitle => 'Theme and color palette';

  @override
  String get settingsSectionLanguageTitle => 'Language';

  @override
  String get settingsSectionLanguageSubtitle => 'Application language';

  @override
  String get settingsSectionModulesTitle => 'Modules';

  @override
  String get settingsSectionModulesSubtitle =>
      'Startup and post-login behavior';

  @override
  String get settingsStartupModuleTitle => 'Module auto start';

  @override
  String get settingsStartupModuleSubtitle =>
      'After sign-in the app always shows the dashboard first and then automatically opens the selected module.';

  @override
  String get settingsStartupModuleDashboardSubtitle =>
      'Stay on the dashboard after sign-in';

  @override
  String get settingsStartupModuleInventorySubtitle =>
      'Open the inventory module after the dashboard';

  @override
  String get settingsStartupModuleBhpSubtitle =>
      'Open the BHP module after the dashboard';

  @override
  String get settingsStartupModuleSettingsSubtitle =>
      'Open application settings after the dashboard';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Choose primary interface language.';

  @override
  String get settingsLanguagePolish => 'Polish (Polski)';

  @override
  String get settingsLanguagePolishSubtitle =>
      'Default language for your organization';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageEnglishSubtitle =>
      'Secondary language for international users';

  @override
  String get settingsAppearanceModeTitle => 'Theme mode';

  @override
  String get settingsAppearanceModeSubtitle =>
      'Choose how light and dark appearance is selected.';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeSystemSubtitle =>
      'Follow operating system preference';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeLightSubtitle => 'Always use light appearance';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeDarkSubtitle => 'Always use dark appearance';

  @override
  String get settingsPaletteTitle => 'Color palette';

  @override
  String get settingsPaletteSubtitle =>
      'Palette variant for the whole application.';

  @override
  String get settingsPaletteClassicTitle => 'Classic';

  @override
  String get settingsPaletteClassicSubtitle =>
      'Neutral blue, default visual style';

  @override
  String get settingsPaletteMaterialTitle => 'Material';

  @override
  String get settingsPaletteMaterialSubtitle =>
      'Standard Material 3 generated by ColorScheme.fromSeed';

  @override
  String get settingsSeedColorTitle => 'Material seed color';

  @override
  String get settingsSeedColorSubtitle =>
      'Choose the seed color for the Material palette.';

  @override
  String get settingsSeedColorBlueTitle => 'Blue';

  @override
  String get settingsSeedColorBlueSubtitle => 'Closest to the current app look';

  @override
  String get settingsSeedColorEmeraldTitle => 'Emerald';

  @override
  String get settingsSeedColorEmeraldSubtitle => 'Cool green-teal variant';

  @override
  String get settingsSeedColorAmberTitle => 'Amber';

  @override
  String get settingsSeedColorAmberSubtitle => 'Warm orange-gold variant';

  @override
  String get settingsSeedColorRoseTitle => 'Rose';

  @override
  String get settingsSeedColorRoseSubtitle => 'Soft raspberry accent';

  @override
  String get settingsSeedColorVioletTitle => 'Violet';

  @override
  String get settingsSeedColorVioletSubtitle => 'Cool violet variant';

  @override
  String get settingsSeedColorTealTitle => 'Teal';

  @override
  String get settingsSeedColorTealSubtitle =>
      'Sea-toned, more saturated variant';

  @override
  String get settingsSeedColorIndigoTitle => 'Indigo';

  @override
  String get settingsSeedColorIndigoSubtitle => 'Deep blue-violet variant';

  @override
  String get settingsSeedColorOrangeTitle => 'Orange';

  @override
  String get settingsSeedColorOrangeSubtitle => 'Energetic orange variant';

  @override
  String get settingsSeedColorCrimsonTitle => 'Crimson';

  @override
  String get settingsSeedColorCrimsonSubtitle => 'Strong crimson accent';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get inventoryModuleTitle => 'Inventory';

  @override
  String get inventorySectionInventories => 'Inventories';

  @override
  String get inventoryInventoriesSubtitle =>
      'List of active and archived records.';

  @override
  String get inventoryNew => 'New';

  @override
  String get inventorySectionAssetState => 'Asset state';

  @override
  String get inventoryCurrentState => 'Current state';

  @override
  String get inventorySectionLocations => 'Locations';

  @override
  String get inventorySectionCompanies => 'Companies';

  @override
  String get inventorySidebarSubtitle => 'Manage assets and inventory sheets';

  @override
  String get inventoryUiGallery => 'UI Gallery';

  @override
  String get inventoryRefresh => 'Refresh';

  @override
  String get inventoryNoNumber => 'No number';

  @override
  String get inventoryDateRangeLabel => 'Range';

  @override
  String inventoryPeopleCount(int count) {
    return '$count people';
  }

  @override
  String get inventoryFetchErrorTitle => 'Fetch error';

  @override
  String inventoryActionNotConnected(Object label) {
    return 'Action \"$label\" will be connected to API.';
  }

  @override
  String get inventoryOverviewTitle => 'Asset state';

  @override
  String get inventoryOverviewSubtitle =>
      'Quick filtering and fixed assets list.';

  @override
  String get inventorySearch => 'Search';

  @override
  String get inventoryLoadingErrorTitle => 'Loading error';

  @override
  String get inventoryOverviewSearchHintName => 'Enter fixed asset name...';

  @override
  String get inventoryOverviewSearchHintRegisterNumber =>
      'Enter register number...';

  @override
  String get inventoryOverviewSearchHintBarcode => 'Enter barcode...';

  @override
  String get inventoryOverviewSearchHintGlobal =>
      'Name, register no., person, location or barcode...';

  @override
  String get inventoryCompany => 'Companies/Branches';

  @override
  String get inventoryAll => 'All';

  @override
  String get inventoryAllCompanies => 'All companies';

  @override
  String get inventorySearchBy => 'Search by';

  @override
  String get inventorySearchSheetsAction => 'Search sheets';

  @override
  String get inventorySearchSheetsTitle => 'Search across sheets';

  @override
  String inventorySearchSheetsSubtitle(Object number) {
    return 'Inventory $number';
  }

  @override
  String get inventorySearchSheetsHint =>
      'Register no., name, person or barcode...';

  @override
  String get inventorySearchSheetsSortByRegisterNumber => 'Reg. no.';

  @override
  String get inventorySearchSheetsSortByName => 'Name';

  @override
  String get inventorySearchSheetsSortByMatches => 'Matches count';

  @override
  String get inventorySearchSheetsStartTitle => 'Start searching';

  @override
  String get inventorySearchSheetsStartMessage =>
      'Type at least 2 characters to search across all sheets in this inventory.';

  @override
  String inventorySearchSheetsResultsCount(int groups, int matches) {
    return 'Groups: $groups, matches: $matches';
  }

  @override
  String inventorySearchSheetsMatchesCount(int count) {
    return '$count matches';
  }

  @override
  String get inventorySearchSheetsCurrentSheet => 'Current sheet';

  @override
  String get inventorySearchSheetsFocusCurrentAction => 'Show in sheet';

  @override
  String get inventorySearchSheetsOpenSheetAction => 'Open sheet';

  @override
  String get inventorySearchSheetsToDisposeStatus => 'To dispose';

  @override
  String get inventoryPresenceConflictsTitle => 'Presence conflicts';

  @override
  String inventoryPresenceConflictsSubtitle(Object number) {
    return 'Inventory $number';
  }

  @override
  String get inventoryPresenceConflictsLoadingLabel => 'Checking conflicts';

  @override
  String get inventoryPresenceConflictsRetryLabel => 'Show conflicts';

  @override
  String get inventoryPresenceConflictsEmptyBadge => 'No conflicts detected';

  @override
  String inventoryPresenceConflictsDetectedAction(int count) {
    return '$count conflicts';
  }

  @override
  String inventoryPresenceConflictsResultsCount(int count) {
    return 'Conflicts: $count';
  }

  @override
  String inventoryPresenceConflictsArkuszeCount(int count) {
    return '$count sheets';
  }

  @override
  String get inventoryPresenceConflictsEmptyTitle => 'No conflicts detected';

  @override
  String get inventoryPresenceConflictsEmptyMessage =>
      'This inventory currently has no fixed assets detected in multiple sheets as present entries.';

  @override
  String get inventorySurplusConflictsTitle => 'Surplus conflicts';

  @override
  String inventorySurplusConflictsSubtitle(Object number) {
    return 'Inventory $number';
  }

  @override
  String get inventorySurplusConflictsLoadingLabel =>
      'Checking surplus conflicts';

  @override
  String get inventorySurplusConflictsRetryLabel => 'Show surplus conflicts';

  @override
  String get inventorySurplusConflictsEmptyBadge => 'No surplus conflicts';

  @override
  String inventorySurplusConflictsDetectedAction(int count) {
    return '$count unpaired surpluses';
  }

  @override
  String inventorySurplusConflictsResultsCount(int count) {
    return 'Unpaired surpluses: $count';
  }

  @override
  String get inventorySurplusConflictsEmptyTitle => 'No surplus conflicts';

  @override
  String get inventorySurplusConflictsEmptyMessage =>
      'This inventory currently has no surplus entries without a matching missing item in other sheets.';

  @override
  String get inventorySurplusConflictsMatchBasisLabel => 'Matched by';

  @override
  String get inventorySurplusConflictsMatchBasisRegisterNumber =>
      'Register number';

  @override
  String get inventorySurplusConflictsMatchBasisBarcode => 'Barcode';

  @override
  String get inventoryDuplicateConflictsTitle => 'Duplicate register numbers';

  @override
  String get inventoryDuplicateConflictsSubtitle =>
      'Duplicate register numbers detected in stan_st.';

  @override
  String get inventoryDuplicateConflictsRetryLabel => 'Show duplicates';

  @override
  String inventoryDuplicateConflictsSummary(Object groups, Object records) {
    return 'Groups: $groups • Records: $records';
  }

  @override
  String inventoryDuplicateConflictsDetected(int count) {
    return 'Detected $count duplicate groups';
  }

  @override
  String inventoryDuplicateConflictsVisibleResults(int groups, int records) {
    return 'Visible: $groups groups • $records records';
  }

  @override
  String get inventoryDuplicateConflictsFetchError =>
      'Failed to fetch stan_st duplicates.';

  @override
  String get inventoryDuplicateConflictsEmptyTitle =>
      'No duplicate register numbers';

  @override
  String get inventoryDuplicateConflictsEmptyMessage =>
      'No duplicate register numbers were found in the current stan_st snapshot.';

  @override
  String inventoryDuplicateGroupRecordsCount(int count) {
    return '$count records';
  }

  @override
  String inventoryDuplicateCompaniesLabel(Object list) {
    return 'Companies: $list';
  }

  @override
  String inventoryDuplicateVariantsLabel(Object variants) {
    return 'Variants: $variants';
  }

  @override
  String get inventoryDuplicateCopiedRegisterToast => 'Register number copied.';

  @override
  String get inventoryImport => 'Import';

  @override
  String get inventoryName => 'Name';

  @override
  String get inventoryRegisterNumber => 'Register number';

  @override
  String get inventoryRegisterNumberShort => 'Reg. no.';

  @override
  String get inventoryBarcode => 'Barcode';

  @override
  String get inventoryNoName => 'No name';

  @override
  String get inventoryPerson => 'Person';

  @override
  String get inventoryLocation => 'Location';

  @override
  String get inventoryState => 'State';

  @override
  String inventoryUnknownWithCode(Object code) {
    return 'Unknown ($code)';
  }

  @override
  String get inventoryPurchaseDate => 'Purchase date';

  @override
  String get inventoryValueP => 'Value P';

  @override
  String get inventoryAssetDetailsTitle => 'Asset details';

  @override
  String get inventoryBasicInfoSection => 'Basic information';

  @override
  String get inventoryLocationSection => 'Location';

  @override
  String get inventoryFinancialSection => 'Financial and purchase data';

  @override
  String get inventoryLevel => 'Level';

  @override
  String get inventoryValueA => 'Value A';

  @override
  String get inventoryImportedAt => 'Imported';

  @override
  String get inventoryNoData => 'No data';

  @override
  String get inventoryLocationsTitle => 'Locations';

  @override
  String get inventoryLocationsSubtitle => 'Locations list';

  @override
  String get inventoryTable => 'Table';

  @override
  String get inventoryTree => 'Tree';

  @override
  String get inventoryLocationsSearchHint => 'Code, name, level...';

  @override
  String get inventoryLocationsTreeSearchHint =>
      'Company, code, name, level...';

  @override
  String get inventoryNoResultsTitle => 'No results';

  @override
  String get inventoryLocationsNoResultsMessage =>
      'No branches matching the filter were found.';

  @override
  String inventoryCompanyWithId(int id) {
    return 'Branch $id';
  }

  @override
  String inventoryLocationsCount(int count) {
    return '$count locations';
  }

  @override
  String get inventoryCode => 'Code';

  @override
  String get inventoryCompaniesTitle => 'Companies';

  @override
  String get inventoryCompaniesSubtitle =>
      'List of registered companies in inventory dictionary.';

  @override
  String get inventoryCompaniesEmptyTitle => 'No companies';

  @override
  String get inventoryCompaniesEmptyMessage =>
      'No companies were found in the dictionary.';

  @override
  String inventoryCompanyIdLabel(int id) {
    return 'Company ID: $id';
  }

  @override
  String get inventoryCompanyDeletedMessage => 'Company has been deleted.';

  @override
  String get inventoryDetailsTitle => 'Inventory details';

  @override
  String inventoryNumberLabel(Object number) {
    return 'Number: $number';
  }

  @override
  String get inventoryDetailsLoadErrorTitle =>
      'Failed to load inventory details';

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get create => 'Create';

  @override
  String get id => 'ID';

  @override
  String get inventorySheetsLabel => 'Sheets';

  @override
  String get inventoryWarehouseLabel => 'Warehouse';

  @override
  String get inventoryActionsLabel => 'Actions';

  @override
  String get inventoryReportsTitle => 'Reports';

  @override
  String inventoryReportsSubtitle(Object number) {
    return 'Inventory $number';
  }

  @override
  String get inventoryReportsIntro =>
      'Reports are calculated on all sheet items attached to the selected inventory.';

  @override
  String get inventoryReportsListTitle => 'Report list';

  @override
  String get inventoryReportsBundleTitle => 'PDF bundle';

  @override
  String get inventoryReportsBundleDescription =>
      'A merged document matching the legacy Delphi report set.';

  @override
  String get inventoryReportsPreview => 'Preview';

  @override
  String get inventoryReportsDownload => 'Download';

  @override
  String get inventoryReportsPrint => 'Print';

  @override
  String get inventoryReportsPreviewPdf => 'PDF preview';

  @override
  String get inventoryReportsBundleSubtitle => 'Report bundle';

  @override
  String get inventoryReportsSortLabel => 'Sort';

  @override
  String get inventoryReportsSortDirectionLabel => 'Direction';

  @override
  String get inventoryReportsSortById => 'ID';

  @override
  String get inventoryReportsSortByRegisterNumber => 'Reg. no.';

  @override
  String get inventoryReportsSortByLocation => 'Location';

  @override
  String get inventoryReportsSortByStatus => 'Count status';

  @override
  String get inventoryReportsSortByInventoryState => 'Inventory state';

  @override
  String get inventoryReportsRefresh => 'Refresh';

  @override
  String get inventoryReportsDownloadPdf => 'Download PDF';

  @override
  String get inventoryReportsDownloadReportPdf => 'Download report PDF';

  @override
  String get inventoryReportsDownloadProtocol => 'Download protocol';

  @override
  String get inventoryReportsPrintPdf => 'Print PDF';

  @override
  String get inventoryReportsPrintReportPdf => 'Print report PDF';

  @override
  String get inventoryReportsPrintProtocol => 'Print protocol';

  @override
  String get inventoryReportsElements => 'Items';

  @override
  String get inventoryReportsGeneratedAt => 'Generated at';

  @override
  String get inventoryReportsNotesLabel => 'Notes in bundle';

  @override
  String get inventoryReportsEnabled => 'Enabled';

  @override
  String get inventoryReportsDisabled => 'Disabled';

  @override
  String get inventoryReportsPreviewOpenError =>
      'Failed to open the PDF bundle preview.';

  @override
  String get inventoryReportsSortAscending => 'Ascending';

  @override
  String get inventoryReportsSortDescending => 'Descending';

  @override
  String get inventoryReportNoDataTitle => 'No data for this report';

  @override
  String get inventoryReportNoDataMessage =>
      'Backend returned no items for the selected type.';

  @override
  String get inventoryReportFetchErrorTitle => 'Failed to load report';

  @override
  String get inventoryReportInternalBannerTitle => 'Internal report';

  @override
  String get inventoryReportSearchHint =>
      'Search by reg. no., name, location, person, or barcode';

  @override
  String get inventoryReportRegisterNumberLabel => 'Register number';

  @override
  String get inventoryReportNameLabel => 'Name';

  @override
  String get inventoryReportLocationLabel => 'Location';

  @override
  String get inventoryReportPersonLabel => 'Person';

  @override
  String get inventoryReportBarcodeLabel => 'Barcode';

  @override
  String get inventoryReportGrossValueLabel => 'Gross value';

  @override
  String get inventoryReportNetValueLabel => 'Net value';

  @override
  String get inventoryReportPurchaseDateLabel => 'Purchase date';

  @override
  String get inventoryReportUwagiLabel => 'Notes';

  @override
  String get inventoryReportMissingLocationLabel => 'Missing location';

  @override
  String get inventoryReportMissingPersonLabel => 'Missing person';

  @override
  String get inventoryReportExcessLocationLabel => 'Excess location';

  @override
  String get inventoryReportExcessPersonLabel => 'Excess person';

  @override
  String get inventoryCountStatusMissing => 'Missing';

  @override
  String get inventoryCountStatusPresent => 'Present';

  @override
  String get inventoryCountStatusTransferred => 'Present (mismatch)';

  @override
  String get inventoryCountStatusExcess => 'Excess';

  @override
  String get inventoryCountStatusNew => 'New';

  @override
  String get inventoryCountStatusFoundInOtherCompany =>
      'Found in another company';

  @override
  String get inventoryCountStatusAmbiguousCode => 'Ambiguous code';

  @override
  String get inventoryCountStatusSoldDuringInventory => 'Sold during inventory';

  @override
  String get inventoryCountStatusPurchasedDuringInventory =>
      'Purchased during inventory';

  @override
  String get inventoryCountStatusExcessDescription =>
      'An item found during count that does not belong to the sheet.';

  @override
  String get inventoryCountStatusNewDescription =>
      'An item added as new because it was not present in the source data.';

  @override
  String get inventoryCountStatusFoundInOtherCompanyDescription =>
      'An item physically found but assigned to another company.';

  @override
  String get inventoryCountStatusAmbiguousCodeDescription =>
      'The barcode or identifier does not uniquely identify the item.';

  @override
  String get inventoryCountStatusSoldDuringInventoryDescription =>
      'The item was sold during the inventory process.';

  @override
  String get inventoryCountStatusPurchasedDuringInventoryDescription =>
      'The item was purchased during the inventory process.';

  @override
  String get inventoryAssetStateMissingDescription =>
      'No current state information is available for this item.';

  @override
  String get inventoryAssetStateUnapprovedDescription =>
      'The item status has not been approved yet.';

  @override
  String get inventoryAssetStateInUseDescription =>
      'The item is currently in use.';

  @override
  String get inventoryAssetStateDisposedDescription =>
      'The item has been disposed.';

  @override
  String get inventoryAssetStateSoldDescription => 'The item has been sold.';

  @override
  String get inventoryAssetStateTransferredDescription =>
      'The item has been transferred.';

  @override
  String get inventoryAssetStateNotInAssetsDescription =>
      'The item is not present in the current register.';

  @override
  String get inventoryCreateTitle => 'New inventory';

  @override
  String get inventoryCreateSubtitle => 'Create a new inventory record.';

  @override
  String get inventoryCreatedMessage => 'Inventory has been created.';

  @override
  String get inventoryLoadCompaniesErrorTitle => 'Failed to load companies';

  @override
  String get inventoryCompaniesListEmptyMessage => 'Companies list is empty.';

  @override
  String get inventorySelectCompanyHint => 'Select companies/branches';

  @override
  String get inventoryNumber => 'Number';

  @override
  String get inventoryNumberRequired => 'Number is required.';

  @override
  String get inventorySearchPersonHint => 'Search person...';

  @override
  String get inventoryRemarks => 'Remarks';

  @override
  String get inventoryFoundInOtherSheet => 'Found in other sheet';

  @override
  String get inventoryOptionalRemarks => 'Optional remarks';

  @override
  String get inventoryCreateDatesInfo =>
      'Start and end dates are set automatically to today. Status remains backend default.';

  @override
  String get inventorySelectCompanyError => 'Select at least one branch.';

  @override
  String get inventorySelectMinTwoCommissionUsers =>
      'Select at least two commission users.';

  @override
  String get inventoryCommissionSavedMessage => 'Commission has been saved.';

  @override
  String get inventoryNewSheet => 'New sheet';

  @override
  String get inventorySheetCreatedMessage => 'Sheet has been created.';

  @override
  String get inventoryCommissionTitle => 'Inventory commission';

  @override
  String get inventoryEditSheetDatesTitle => 'Edit sheet dates';

  @override
  String get inventoryEditSheetDatesSubtitle =>
      'Change start and end dates without opening details.';

  @override
  String get inventoryStartDateLabel => 'Start date';

  @override
  String get inventoryStartDateHelper => 'Set the sheet start day and time.';

  @override
  String get inventoryStartTimeLabel => 'Start time';

  @override
  String get inventoryEndDateLabel => 'End date';

  @override
  String get inventoryEndDateHelper => 'Set the sheet end day and time.';

  @override
  String get inventoryEndTimeLabel => 'End time';

  @override
  String get inventoryStartDateRequiredError => 'Start date is required.';

  @override
  String get inventoryEndDateBeforeStartError =>
      'End date cannot be earlier than start date.';

  @override
  String get inventoryPrint => 'Print';

  @override
  String get inventoryDates => 'Dates';

  @override
  String get inventoryStatusSpisuFieldLabel => 'Count status (options)';

  @override
  String get inventoryStatusSpisuNoOptions => 'No selected options';

  @override
  String get inventoryStatusSpisuYesMismatch => 'Yes (mismatch)';

  @override
  String get inventoryStatusSpisuExcess => 'Excess';

  @override
  String get inventoryChooseCompanyTitle => 'Choose company';

  @override
  String get inventoryChooseCompanyOutsideMessage =>
      'Choose a company outside this inventory scope, then the exact location.';

  @override
  String get inventoryChooseCompanyInsideMessage =>
      'Choose a company covered by this inventory, then the exact location.';

  @override
  String get inventoryInventoryStateAvailable => 'Available';

  @override
  String get inventoryChangeItemStatusTitle => 'Count status';

  @override
  String get inventoryChangeItemResultTitle => 'Count result';

  @override
  String get inventoryChangeItemResultLabel => 'Result';

  @override
  String get inventoryChangeItemAdditionalTitle => 'Additional findings';

  @override
  String get inventoryChangeItemMismatchDataTitle => 'Mismatch data';

  @override
  String get inventoryChangeItemCorrectionTitle => 'Data correction';

  @override
  String get inventoryChangeItemChooseResultHint => 'Choose count result';

  @override
  String get inventoryChangeItemTypeLabel => 'Change type';

  @override
  String get inventoryDeleteItemTitle => 'Delete sheet item';

  @override
  String get inventoryDeleteItemSubtitle =>
      'This operation removes the selected item from the current sheet.';

  @override
  String inventoryDeleteItemDetailsMessage(
    Object id,
    Object register,
    Object name,
  ) {
    return 'Item ID: $id\nRegister number: $register\nName: $name';
  }

  @override
  String get inventoryDeleteItemSuccessMessage =>
      'Sheet item has been deleted.';

  @override
  String get inventoryDeleteItemUnlockLabel => 'Deletion confirmation';

  @override
  String get inventoryDeleteStockTitle => 'Delete fixed asset';

  @override
  String get inventoryDeleteStockSubtitle =>
      'This operation removes the record from the fixed assets snapshot.';

  @override
  String get inventoryDeleteStockConfirmTitle =>
      'Are you sure you want to delete this record?';

  @override
  String inventoryDeleteStockConfirmBody(int id, Object register, Object name) {
    return 'Record ID: $id\nRegister number: $register\nName: $name';
  }

  @override
  String get inventoryDeleteStockHelper =>
      'Retype the register number and full name. Letter case does not matter.';

  @override
  String get inventoryDeleteStockRegisterLabel => 'Register number';

  @override
  String get inventoryDeleteStockNameLabel => 'Full name';

  @override
  String get inventoryDeleteStockSuccessMessage =>
      'Fixed asset has been removed from the snapshot.';

  @override
  String get inventorySheetDatesSavedMessage => 'Sheet dates have been saved.';

  @override
  String get inventorySheetDateSearchHint => 'sheet name, location';

  @override
  String get inventorySheetStatusesTitle => 'Sheet statuses';

  @override
  String get inventorySheetStatusesCommissionTitle => 'Commission';

  @override
  String get inventorySheetStatusesCommissionEmpty => 'None';

  @override
  String get inventorySheetManagementTitle => 'Edit sheet dates';

  @override
  String get inventorySheetManagementSubtitle =>
      'Change start and end dates without editing the commission.';

  @override
  String get inventorySheetStartTimeLabel => 'Start time';

  @override
  String get inventorySheetEndTimeLabel => 'End time';

  @override
  String get frameworkGalleryTitle => 'Framework Components Gallery';

  @override
  String frameworkActionToast(Object label) {
    return 'Action: $label';
  }

  @override
  String get frameworkNewDocumentTitle => 'New document';

  @override
  String get frameworkNewDocumentSubtitle => 'A right-side sheet variant.';

  @override
  String get frameworkClose => 'Close';

  @override
  String get frameworkError => 'Error';

  @override
  String get frameworkSave => 'Save';

  @override
  String get frameworkNewDocumentTemplateTitle => 'New document';

  @override
  String get frameworkNewDocumentTemplateSubtitle =>
      'Template for BLoC initial/loading/loaded/error.';

  @override
  String get frameworkDocumentDataTitle => 'Document data';

  @override
  String get frameworkDocumentNameHint => 'e.g. Inventory Q2';

  @override
  String get frameworkDocumentStatusOpen => 'Open';

  @override
  String get frameworkDocumentStatusClosed => 'Closed';

  @override
  String get frameworkDataTableTitle => 'Data Table';

  @override
  String get frameworkDataTableSubtitle =>
      'Table with sorting and loading/error/empty states.';

  @override
  String get frameworkStressTest => 'Stress test 100x4000';

  @override
  String get frameworkLoadingDataTitle => 'Loading data';

  @override
  String get frameworkLoadingDataMessage =>
      'Fetching records, this will take a moment.';

  @override
  String get frameworkLoadErrorTitle => 'Failed to load data';

  @override
  String get frameworkName => 'Name';

  @override
  String get frameworkStatus => 'Status';

  @override
  String get frameworkItems => 'Items';

  @override
  String get frameworkOwner => 'Owner';

  @override
  String get frameworkListTilesTitle => 'List Tiles';

  @override
  String get frameworkListTilesSubtitle =>
      'Shared AppListTile and AppExpansionListTile for menus/lists.';

  @override
  String get frameworkInbox => 'Inbox';

  @override
  String get frameworkReports => 'Reports';

  @override
  String get frameworkDaily => 'Daily';

  @override
  String get frameworkNewItemsCount => '12 new items';

  @override
  String get frameworkFavorites => 'Favorites';

  @override
  String get frameworkAnalytics => 'Analytics views';

  @override
  String get frameworkDailyReport => 'Daily report';

  @override
  String get frameworkMonthlyReport => 'Monthly report';

  @override
  String get frameworkDropdownTitle => 'Dropdown';

  @override
  String get frameworkDropdownSubtitle =>
      'Basic dropdown based on theme and shared styles.';

  @override
  String get frameworkDropdownLabel => 'Range';

  @override
  String get frameworkToday => 'Today';

  @override
  String get frameworkThisWeek => 'This week';

  @override
  String get frameworkOuterLabel => 'Outer label';

  @override
  String get frameworkStatusLabel => 'Status';

  @override
  String get frameworkChoose => 'Choose';

  @override
  String get frameworkToggleLoading => 'Show loading';

  @override
  String get frameworkHideLoading => 'Hide loading';

  @override
  String get frameworkShowError => 'Show error';

  @override
  String get frameworkHideError => 'Hide error';

  @override
  String get frameworkShowTable => 'Show table';

  @override
  String get frameworkRetry => 'Retry';

  @override
  String get frameworkLoadingText => 'Loading data';

  @override
  String get frameworkLoadingMessage =>
      'Fetching records, this will take a moment.';

  @override
  String get frameworkErrorTitle => 'Failed to load data';

  @override
  String get frameworkSearchApiError =>
      'API error: timeout while fetching the list.';

  @override
  String get frameworkListTileInboxCount => '12 new items';

  @override
  String get frameworkListTileFavorites => 'Favorites';

  @override
  String get frameworkListTileAnalytics => 'Analytics views';

  @override
  String get frameworkListTileDailyReport => 'Daily report';

  @override
  String get frameworkListTileMonthlyReport => 'Monthly report';

  @override
  String frameworkTableRowHover(Object name) {
    return 'Hover: $name';
  }

  @override
  String frameworkTableRowTap(
    int index,
    Object name,
    Object status,
    Object count,
    Object owner,
  ) {
    return 'Tapped row #$index: $name | $status | $count | $owner';
  }

  @override
  String get frameworkTableName => 'Name';

  @override
  String get frameworkTableStatus => 'Status';

  @override
  String get frameworkTableItems => 'Items';

  @override
  String get frameworkTableOwner => 'Owner';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get ordersBody =>
      'This is the second feature running in the same app.';

  @override
  String get ordersInitialRoute => 'Initial route: /orders';

  @override
  String get ordersUserId => 'User ID: n/d';

  @override
  String get ordersUser => 'User: n/d';

  @override
  String get ordersBearerPassed => 'Bearer passed: n/d';

  @override
  String get bhpModuleTitle => 'BHP';

  @override
  String get bhpSidebarSubtitle => 'Employee, position and equipment workflow';

  @override
  String get bhpSectionDashboard => 'Dashboard';

  @override
  String get bhpSectionOperations => 'Operations history';

  @override
  String get bhpSectionUsers => 'Employees';

  @override
  String get bhpSectionPositions => 'Positions';

  @override
  String get bhpSectionEquipment => 'Equipment';

  @override
  String get bhpRefreshAction => 'Refresh';

  @override
  String get bhpDashboardSectionTitle => 'BHP dashboard';

  @override
  String get bhpDashboardSectionSubtitle =>
      'Due-date alerts and basic operational signals from the BHP backend.';

  @override
  String get bhpDashboardErrorTitle => 'Failed to load dashboard';

  @override
  String get bhpDashboardRefreshingLabel => 'Refreshing';

  @override
  String get bhpDashboardRefreshInProgress => 'Refreshing data.';

  @override
  String get bhpDashboardRetryLabel => 'Try again';

  @override
  String get bhpDashboardOverdueTitle => 'Overdue';

  @override
  String get bhpDashboardOverdueSubtitle =>
      'Active issues that already require action.';

  @override
  String get bhpDashboardUpcomingTitle => 'Upcoming';

  @override
  String bhpDashboardUpcomingSubtitle(int months) {
    return 'Alerts in the next $months months.';
  }

  @override
  String get bhpDashboardSnapshotTitle => 'Snapshot';

  @override
  String get bhpDashboardSnapshotSubtitle => 'Dashboard generation timestamp.';

  @override
  String get bhpDashboardOverdueTableTitle => 'Overdue issues';

  @override
  String get bhpDashboardOverdueTableSubtitle =>
      'Records that already exceeded their usage term.';

  @override
  String get bhpDashboardNoOverdueTitle => 'No overdue issues';

  @override
  String get bhpDashboardNoOverdueMessage =>
      'There are no overdue items right now.';

  @override
  String get bhpDashboardUpcomingTableTitle => 'Issues approaching due date';

  @override
  String get bhpDashboardUpcomingTableSubtitle =>
      'Items that will soon require replacement or closure.';

  @override
  String get bhpDashboardNoUpcomingTitle => 'No upcoming alerts';

  @override
  String get bhpDashboardNoUpcomingMessage =>
      'There are no alerts in the selected time window right now.';

  @override
  String get bhpUsersTitle => 'BHP employees';

  @override
  String get bhpUsersSectionSubtitle =>
      'Employee cards and their current status.';

  @override
  String bhpUsersSubtitle(int active, int archived) {
    return 'Active: $active, archived: $archived';
  }

  @override
  String get bhpUsersErrorTitle => 'Failed to load employees';

  @override
  String get bhpUsersEmptyTitle => 'No employees';

  @override
  String get bhpUsersEmptyMessage => 'The BHP employee list is empty.';

  @override
  String get bhpUsersNoSearchResultsTitle => 'No results';

  @override
  String get bhpUsersNoSearchResultsMessage =>
      'No employee matches the current phrase. Clear the search or change the query.';

  @override
  String get bhpUsersNoActiveMessage =>
      'There are no active employees in the list right now.';

  @override
  String get bhpUsersNoArchivedMessage =>
      'There are no archived employees in the list right now.';

  @override
  String bhpUsersSearchResultsSummary(Object visible, Object total) {
    return 'Results: $visible of $total';
  }

  @override
  String get bhpUsersClearSearchAction => 'Clear search';

  @override
  String get bhpUsersBulkSelectLabel => 'Bulk Actions';

  @override
  String bhpUsersBulkSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Selected $count employees',
      one: 'Selected 1 employee',
    );
    return '$_temp0';
  }

  @override
  String get bhpUsersBulkChangePositionAction => 'Change Position';

  @override
  String get bhpUsersBulkChangePositionTitle => 'Bulk Position Change';

  @override
  String bhpUsersBulkChangePositionConfirm(int count) {
    return 'Change position for $count employees';
  }

  @override
  String bhpUsersBulkSuccessMessage(int count) {
    return 'Successfully changed position for $count employees.';
  }

  @override
  String get bhpUsersDataQualityLabel => 'Data';

  @override
  String get bhpUsersDataQualityComplete => 'Complete';

  @override
  String get bhpUsersDataQualityMissingPosition => 'Missing position';

  @override
  String get bhpUsersDataQualityMissingPesel => 'Missing PESEL';

  @override
  String get bhpUsersDataQualityMissingPhone => 'Missing phone';

  @override
  String get bhpUsersSearchHint =>
      'Search by name, registry number or position...';

  @override
  String get bhpPositionsTitle => 'BHP positions';

  @override
  String get bhpPositionsSectionSubtitle =>
      'Positions dictionary used in employee cards.';

  @override
  String bhpPositionsSubtitle(int active, int total) {
    return 'Active: $active, total: $total';
  }

  @override
  String get bhpPositionsErrorTitle => 'Failed to load positions';

  @override
  String get bhpPositionsEmptyTitle => 'No positions';

  @override
  String get bhpPositionsEmptyMessage =>
      'The positions dictionary does not contain data yet.';

  @override
  String get bhpPositionsSearchHint => 'Search by name or notes...';

  @override
  String get bhpPositionsFilterAll => 'All';

  @override
  String get bhpPositionsFilterInactive => 'Inactive';

  @override
  String get bhpPositionsRestoreAction => 'Restore';

  @override
  String get bhpPositionsRestoreTitle => 'Restore position';

  @override
  String bhpPositionsRestoreMessage(Object name) {
    return 'Position $name will be re-enabled in the active dictionary.';
  }

  @override
  String bhpPositionsRestoreSuccess(Object name) {
    return 'Position $name has been restored.';
  }

  @override
  String get bhpPositionsAddAndStandardAction => 'Add and standard';

  @override
  String get bhpPositionsEditStandardAction => 'Edit standard';

  @override
  String get bhpPositionsOpenStandardAction => 'Equipment standard';

  @override
  String get bhpPositionStandardsTitle => 'Position equipment standard';

  @override
  String get bhpPositionStandardsLoadErrorTitle =>
      'Failed to load position standard';

  @override
  String get bhpPositionStandardsPositionLabel => 'Position';

  @override
  String bhpPositionStandardsItemsCount(int count) {
    return 'Items: $count';
  }

  @override
  String bhpPositionStandardsActiveCount(int count) {
    return 'Active: $count';
  }

  @override
  String bhpPositionStandardsEquipmentPoolCount(int count) {
    return 'Available cards: $count';
  }

  @override
  String get bhpPositionStandardsEmptyTitle => 'No standard items';

  @override
  String get bhpPositionStandardsEmptyMessage =>
      'This position has no assigned equipment yet.';

  @override
  String get bhpPositionStandardsAddAction => 'Add item';

  @override
  String get bhpPositionStandardsArchiveAction => 'Set inactive';

  @override
  String get bhpPositionStandardsArchiveTitle =>
      'Set standard item as inactive';

  @override
  String bhpPositionStandardsArchiveMessage(Object symbol) {
    return 'Item $symbol will be set inactive only on this position standard card.';
  }

  @override
  String get bhpPositionStandardsArchiveSuccess =>
      'The standard item has been set as inactive.';

  @override
  String get bhpPositionStandardsRestoreAction => 'Set active';

  @override
  String get bhpPositionStandardsRestoreTitle => 'Set standard item as active';

  @override
  String bhpPositionStandardsRestoreMessage(Object symbol) {
    return 'Item $symbol will be set active only on this position standard card.';
  }

  @override
  String get bhpPositionStandardsRestoreSuccess =>
      'The standard item has been set as active.';

  @override
  String get bhpPositionStandardsDeleteTitle => 'Delete standard item';

  @override
  String bhpPositionStandardsDeleteMessage(Object symbol) {
    return 'Item $symbol will be permanently removed only from this position standard card.';
  }

  @override
  String get bhpPositionStandardsDeleteSuccess =>
      'The standard item has been deleted.';

  @override
  String get bhpPositionStandardEditorCreateTitle => 'Add standard item';

  @override
  String get bhpPositionStandardEditorEditTitle => 'Edit standard item';

  @override
  String get bhpPositionStandardEditorEquipmentLabel => 'Equipment card';

  @override
  String get bhpPositionStandardEditorEquipmentHint =>
      'Search equipment card...';

  @override
  String get bhpPositionStandardEditorEquipmentRequired =>
      'Equipment card is required.';

  @override
  String get bhpPositionStandardEditorPeriodLabel => 'Period (months)';

  @override
  String get bhpPositionStandardEditorQuantityLabel => 'Quantity';

  @override
  String get bhpPositionStandardEditorCreateSuccess =>
      'The standard item has been added.';

  @override
  String get bhpPositionStandardEditorEditSuccess =>
      'The standard item has been saved.';

  @override
  String get bhpEquipmentTitle => 'Equipment catalog';

  @override
  String get bhpEquipmentSectionSubtitle =>
      'Catalog items used in BHP standards and issues.';

  @override
  String get bhpEquipmentFilterActiveTooltip =>
      'Shows only active equipment cards.';

  @override
  String get bhpEquipmentFilterInactiveTooltip =>
      'Shows only inactive equipment cards.';

  @override
  String get bhpEquipmentFilterAllTooltip => 'Shows all equipment cards.';

  @override
  String get bhpEquipmentStatusActiveTooltip =>
      'The equipment card is active and can be used in standards.';

  @override
  String get bhpEquipmentStatusInactiveTooltip =>
      'The equipment card is inactive and is excluded from new issues.';

  @override
  String bhpEquipmentSubtitle(int active, int total) {
    return 'Active: $active, total: $total';
  }

  @override
  String get bhpEquipmentErrorTitle => 'Failed to load equipment';

  @override
  String get bhpEquipmentEmptyTitle => 'No equipment';

  @override
  String get bhpEquipmentEmptyMessage =>
      'The equipment catalog does not contain data yet.';

  @override
  String get bhpEquipmentSearchHint => 'Search by symbol, name or unit...';

  @override
  String get bhpEquipmentSetInactiveAction => 'Set inactive';

  @override
  String get bhpEquipmentSetInactiveTitle => 'Set card as inactive';

  @override
  String bhpEquipmentSetInactiveMessage(Object symbol) {
    return 'Card $symbol will be disabled in the active equipment catalog.';
  }

  @override
  String bhpEquipmentSetInactiveSuccess(Object symbol) {
    return 'Card $symbol has been set as inactive.';
  }

  @override
  String get bhpEquipmentSetActiveAction => 'Set active';

  @override
  String get bhpEquipmentSetActiveTitle => 'Set card as active';

  @override
  String bhpEquipmentSetActiveMessage(Object symbol) {
    return 'Card $symbol will return to the active equipment catalog.';
  }

  @override
  String bhpEquipmentSetActiveSuccess(Object symbol) {
    return 'Card $symbol has been set as active.';
  }

  @override
  String get bhpEquipmentImpactSetInactiveDescription =>
      'Setting this card as inactive will disable all active assignments of this equipment across positions.';

  @override
  String get bhpEquipmentImpactSetActiveDescription =>
      'You can activate the card globally only, or additionally select which inactive position assignments should be restored.';

  @override
  String bhpEquipmentImpactActiveLinksCount(int count) {
    return 'Active assignments: $count';
  }

  @override
  String bhpEquipmentImpactInactiveLinksCount(int count) {
    return 'Inactive assignments: $count';
  }

  @override
  String bhpEquipmentImpactSelectedLinksCount(int count) {
    return 'To restore: $count';
  }

  @override
  String get bhpEquipmentImpactInactiveSection =>
      'Positions that will be disabled';

  @override
  String get bhpEquipmentImpactActiveSection =>
      'Inactive assignments available to restore';

  @override
  String get bhpEquipmentImpactActiveHint =>
      'Select only the assignments that should return together with global card activation.';

  @override
  String get bhpEquipmentImpactInactiveEmptyTitle => 'No active links';

  @override
  String get bhpEquipmentImpactInactiveEmptyMessage =>
      'This card currently has no active standard assignments, so the status change will affect only the global catalog.';

  @override
  String get bhpEquipmentImpactActiveEmptyTitle => 'No assignments to restore';

  @override
  String get bhpEquipmentImpactActiveEmptyMessage =>
      'The card can be activated globally without restoring any position assignments.';

  @override
  String get bhpSearchAlertsHint =>
      'Search by employee, position or equipment...';

  @override
  String get bhpTableRegistryNumber => 'Reg. no.';

  @override
  String get bhpTableEmployee => 'Employee';

  @override
  String get bhpTablePosition => 'Position';

  @override
  String get bhpTableEquipment => 'Equipment';

  @override
  String get bhpTableEmploymentStart => 'Employed from';

  @override
  String get bhpTableEmploymentEnd => 'Employed to';

  @override
  String get bhpTableDueDate => 'Due date';

  @override
  String get bhpTableDaysToDue => 'Days';

  @override
  String get bhpTableStatus => 'Status';

  @override
  String get bhpTableNotes => 'Notes';

  @override
  String get bhpTableSymbol => 'Symbol';

  @override
  String get bhpTableUnit => 'Unit';

  @override
  String get bhpTablePeriod => 'Period';

  @override
  String get bhpTableDefaultQuantity => 'Default qty';

  @override
  String get bhpTablePrice => 'Price';

  @override
  String get bhpStatusActive => 'Active';

  @override
  String get bhpStatusActiveTooltip =>
      'The status means the item is active and available in current views.';

  @override
  String get bhpStatusInactive => 'Inactive';

  @override
  String get bhpStatusInactiveTooltip =>
      'The status means the item is inactive and should not be used for new operations.';

  @override
  String get bhpStatusArchived => 'Archived';

  @override
  String get bhpUserIssuesTitle => 'Employee issues';

  @override
  String bhpUserIssuesSubtitle(String name) {
    return 'BHP issues and equivalents history for: $name';
  }

  @override
  String get bhpUserIssuesEmptyTitle => 'No issues';

  @override
  String get bhpUserIssuesEmptyMessage =>
      'This employee has no registered equipment issues.';

  @override
  String get bhpUserIssuesErrorTitle => 'Failed to load issues';

  @override
  String get bhpUserIssuesSectionSubtitle =>
      'Employee equipment issue register.';

  @override
  String get bhpUserIssuesHideInactive => 'Hide inactive';

  @override
  String get bhpUserIssuesEmployeeLabel => 'Employee:';

  @override
  String get bhpUserIssuesPositionLabel => 'Position:';

  @override
  String get bhpUserIssuesNoPosition => 'No position';

  @override
  String get bhpUserIssuesEditEmployeeTooltip => 'Edit employee data';

  @override
  String get bhpUserIssuesSearchHint => 'Search equipment (symbol, name)...';

  @override
  String get bhpUserIssuesRowNumber => 'No.';

  @override
  String get bhpUserIssuesNoEquipmentName => 'No name';

  @override
  String get bhpUserIssuesTooltipEquipmentInfo => 'Show equipment information';

  @override
  String get bhpUserIssuesTooltipEditQuantity => 'Edit quantity';

  @override
  String get bhpUserIssuesTooltipEditIssueDate => 'Edit assignment date';

  @override
  String get bhpUserIssuesAddEquivalent => 'Add';

  @override
  String get bhpUserIssuesTooltipAddEquivalent => 'Add equivalent';

  @override
  String get bhpUserIssuesTooltipEditEquivalent => 'Edit equivalent';

  @override
  String get bhpUserIssuesTooltipEditEquivalentDate => 'Edit equivalent date';

  @override
  String get bhpUserIssuesActionDeleteEquivalent => 'Delete equivalent';

  @override
  String get bhpUserIssuesTooltipDeleteEquivalent => 'Delete equivalent';

  @override
  String get bhpUserIssuesAddNote => 'Add note';

  @override
  String get bhpUserIssuesTooltipAddNote => 'Add note to issue';

  @override
  String get bhpUserIssuesActiveStatusTooltip =>
      'The equipment is currently used by the employee.\nIt consumes the norm assigned to the position.';

  @override
  String get bhpUserIssuesInactiveStatusTooltip =>
      'The issue has been closed.\nThe equipment is no longer in use and releases the norm for the position.';

  @override
  String get bhpUserIssuesRepeatAction => 'Add again';

  @override
  String bhpUserIssuesActionsForSymbol(Object symbol) {
    return 'Actions for: $symbol';
  }

  @override
  String get bhpUserIssuesActionsForIssue => 'Issue actions';

  @override
  String get bhpUserIssuesDeleteIssueTitle => 'Delete issue';

  @override
  String bhpUserIssuesDeleteIssueMessage(Object item) {
    return 'Are you sure you want to delete issue $item? This operation cannot be undone.';
  }

  @override
  String get bhpUserIssuesDeleteIssueSuccess => 'The issue has been deleted.';

  @override
  String get bhpUserIssuesRepeatIssueTitle => 'Add again';

  @override
  String bhpUserIssuesRepeatIssueMessage(Object item) {
    return 'Are you sure you want to automatically repeat issue $item?';
  }

  @override
  String get bhpUserIssuesRepeatIssueSuccess => 'The issue has been repeated.';

  @override
  String get bhpUserIssuesBulkRepeatAction => 'Issue selected again';

  @override
  String get bhpUserIssuesBulkRepeatTitle => 'Confirm reissue';

  @override
  String get bhpUserIssuesBulkRepeatSubtitle =>
      'New issues will be created for the items selected on the active list.';

  @override
  String get bhpUserIssuesBulkRepeatDescription =>
      'Review the selected items and choose one shared assignment date for the new issues.';

  @override
  String get bhpUserIssuesBulkRepeatDateHelper =>
      'Today\'s date is selected by default, but you can change it before saving the operation.';

  @override
  String get bhpUserIssuesBulkRepeatSelectAll => 'Select all';

  @override
  String get bhpUserIssuesBulkRepeatClearSelection => 'Clear selection';

  @override
  String get bhpUserIssuesBulkRepeatEmptyTitle =>
      'No items available to repeat';

  @override
  String get bhpUserIssuesBulkRepeatEmptyMessage =>
      'No active items have been selected for reissue.';

  @override
  String bhpUserIssuesBulkRepeatSelectedCount(Object count) {
    return 'Selected: $count';
  }

  @override
  String get bhpUserIssuesBulkRepeatSubmitAction => 'Issue again';

  @override
  String get bhpUserIssuesBulkRepeatSelectionRequired =>
      'Select at least one active item to issue again.';

  @override
  String bhpUserIssuesBulkRepeatSuccess(Object count) {
    return 'Repeated $count issues.';
  }

  @override
  String bhpUserIssuesBulkRepeatItemSubtitle(
    Object assignedAt,
    Object closedAt,
    Object quantity,
  ) {
    return 'Assigned: $assignedAt • Closed: $closedAt • Quantity: $quantity';
  }

  @override
  String get bhpUserIssuesOpenPositionDetails => 'Open position details';

  @override
  String bhpUserIssuesPrintCardError(Object error) {
    return 'Error while generating the card printout: $error';
  }

  @override
  String get bhpUserIssuesActionAdd => 'Add issue';

  @override
  String get bhpUserIssuesActionFromStandard => 'Generate from standard';

  @override
  String get bhpUserIssuesActionClose => 'Close Issue';

  @override
  String get bhpUserIssuesActionEquivalent => 'Equivalent';

  @override
  String get bhpUserIssuesPrint => 'Print';

  @override
  String get bhpUserIssuesPrintOptionsTitle => 'Print options';

  @override
  String get bhpUserIssuesPrintOptionsIncludeInactive =>
      'Include inactive (closed) items';

  @override
  String get bhpUserIssuesPrintOptionsAction => 'Generate print';

  @override
  String get bhpTableEquipmentSymbol => 'Symbol';

  @override
  String get bhpTableEquipmentName => 'Equipment name';

  @override
  String get bhpTableIssueDate => 'Issue date';

  @override
  String get bhpTableEndDate => 'End date';

  @override
  String get bhpTableQuantity => 'Quantity';

  @override
  String get bhpTableEquivalentDate => 'Equiv. date';

  @override
  String get bhpTableEquivalentAmount => 'Equiv. amount';

  @override
  String get bhpIssueFormAddTitle => 'New equipment issue';

  @override
  String get bhpIssueFormCloseTitle => 'Close Issue';

  @override
  String get bhpIssueFormEquivalentTitle => 'Equivalent payout';

  @override
  String get bhpIssueFormEquipmentLabel => 'Equipment item';

  @override
  String get bhpIssueFormEquipmentHint => 'Select equipment from catalog';

  @override
  String get bhpIssueFormDateLabel => 'Issue date';

  @override
  String get bhpIssueFormQuantityLabel => 'Quantity';

  @override
  String get bhpIssueFormNotesLabel => 'Notes';

  @override
  String get bhpIssueFormEndDateLabel => 'End date';

  @override
  String get bhpIssueFormEquivalentDateLabel => 'Equivalent date';

  @override
  String get bhpIssueFormEquivalentAmountLabel => 'Equivalent amount';

  @override
  String get bhpIssueFormSuccessAdd => 'New equipment issue added.';

  @override
  String get bhpIssueFormSuccessClose => 'Equipment issue successfully closed.';

  @override
  String get bhpIssueFormSuccessEquivalent => 'Equivalent registered.';

  @override
  String get bhpIssueFormSuccessStandard =>
      'Missing equipment from standard successfully assigned.';

  @override
  String get bhpIssueEditTitle => 'Edit issue';

  @override
  String get bhpIssueEditDateTitle => 'Edit issue date';

  @override
  String get bhpIssueEditEndDateTitle => 'Edit end date';

  @override
  String get bhpIssueEditEndDateHelperText =>
      'Cannot be earlier than the issue date.';

  @override
  String get bhpIssueEditQuantityTitle => 'Edit quantity';

  @override
  String get bhpIssueEditNotesTitle => 'Edit notes';

  @override
  String get bhpIssueEditSuccess => 'Issue updated.';

  @override
  String get bhpIssueEquivalentEditTitle => 'Edit equivalent';

  @override
  String get bhpIssueEquivalentEditSuccess => 'Equivalent updated.';

  @override
  String get bhpIssueEquivalentDeleteTitle => 'Delete equivalent';

  @override
  String get bhpIssueEquivalentDeleteAction => 'Delete equivalent';

  @override
  String get bhpIssueEquivalentDeleteSuccess => 'Equivalent removed.';

  @override
  String bhpIssueEquivalentDeleteMessage(Object item) {
    return 'Delete equivalent for: $item? This clears the equivalent date and amount without removing the issue itself.';
  }

  @override
  String get bhpIssueValidationPositiveQuantity =>
      'Enter a valid quantity greater than 0.';

  @override
  String get bhpAssignFromStandardTitle => 'Assign from standard';

  @override
  String get bhpAssignFromStandardLoadErrorTitle => 'Failed to load standard';

  @override
  String get bhpAssignFromStandardDescription =>
      'Below you can see entries from the job-position standard. Selected entries will be assigned, while already active entries are locked.';

  @override
  String bhpAssignFromStandardSelectedCount(int count) {
    return 'To add: $count';
  }

  @override
  String bhpAssignFromStandardLockedCount(int count) {
    return 'Already active: $count';
  }

  @override
  String bhpAssignFromStandardInactiveCount(int count) {
    return 'Inactive: $count';
  }

  @override
  String get bhpAssignFromStandardSectionAddable => 'To add';

  @override
  String get bhpAssignFromStandardSectionLocked => 'Already active';

  @override
  String get bhpAssignFromStandardSectionInactive => 'Inactive';

  @override
  String get bhpAssignFromStandardSubmitAction => 'Assign items';

  @override
  String get bhpAssignFromStandardBlockedTitle => 'Assignment unavailable';

  @override
  String get bhpAssignFromStandardBlockedMessage =>
      'This employee has no active position or cannot receive issues.';

  @override
  String get bhpAssignFromStandardBadgeAddable => 'To add';

  @override
  String get bhpAssignFromStandardBadgeLocked => 'Already active';

  @override
  String get bhpAssignFromStandardBadgeInactive => 'Inactive';

  @override
  String get bhpAssignFromStandardBadgeInfo => 'Info';

  @override
  String get bhpAssignFromStandardBadgeWarning => 'Warning';

  @override
  String get bhpPositionStandardTitle => 'Position and standard';

  @override
  String get bhpPositionStandardSaveAction => 'Save position';

  @override
  String get bhpPositionStandardSaveSuccess => 'Position saved.';

  @override
  String get bhpPositionStandardLoadErrorTitle => 'Failed to load position';

  @override
  String get bhpPositionStandardCurrentTitle => 'Current position';

  @override
  String get bhpPositionStandardNoPosition => 'No position';

  @override
  String get bhpPositionStandardDescriptionTitle => 'Position description';

  @override
  String get bhpPositionStandardChangeTitle => 'Change position';

  @override
  String get bhpPositionStandardSelectHint => 'Select position';

  @override
  String get bhpPositionStandardSelectedStatus => 'Position selected';

  @override
  String get bhpPositionStandardUnselectedStatus => 'No selection';

  @override
  String get bhpPositionStandardLoadingStandard => 'Loading standard...';

  @override
  String bhpPositionStandardStandardCount(int count) {
    return 'Standard items: $count';
  }

  @override
  String bhpPositionStandardPreviewLabel(Object name) {
    return 'Standard preview: $name';
  }

  @override
  String get bhpPositionStandardEmptyStandardTitle => 'No standard';

  @override
  String get bhpPositionStandardEmptyStandardMessage =>
      'No items are assigned to the selected position yet.';

  @override
  String get bhpAddUserTitle => 'Add employee';

  @override
  String get bhpAddUserSubtitle =>
      'New BHP employee card with assigned position.';

  @override
  String get bhpAddUserLoadErrorTitle => 'Failed to prepare form';

  @override
  String bhpAddUserSuccessMessage(Object name) {
    return 'Employee $name has been added.';
  }

  @override
  String get bhpAddUserBaseSectionTitle => 'Basic data';

  @override
  String get bhpAddUserBaseSectionDescription =>
      'Required fields to create an employee card.';

  @override
  String get bhpAddUserFirstNameLabel => 'First name';

  @override
  String get bhpAddUserLastNameLabel => 'Last name';

  @override
  String get bhpAddUserPeselLabel => 'PESEL';

  @override
  String get bhpAddUserPhoneLabel => 'Phone number';

  @override
  String get bhpAddUserSelectPositionHint => 'Select position';

  @override
  String get bhpAddUserPositionRequiredError => 'Position is required.';

  @override
  String get bhpAddUserResidenceLabel => 'Place of residence';

  @override
  String get bhpAddUserDimensionsSectionTitle => 'BHP data';

  @override
  String get bhpAddUserDimensionsSectionDescription =>
      'Measurements used when assigning equipment.';

  @override
  String get bhpAddUserHeightLabel => 'Height';

  @override
  String get bhpAddUserChestLabel => 'Chest circumference';

  @override
  String get bhpAddUserWaistLabel => 'Waist circumference';

  @override
  String get bhpAddUserHeadLabel => 'Head circumference';

  @override
  String get bhpAddUserFootLabel => 'Foot length';

  @override
  String get bhpAddUserSubmitAction => 'Add';

  @override
  String get bhpAddUserPotentialDuplicateTitle =>
      'A similar employee already exists';

  @override
  String get bhpAddUserPotentialDuplicateMessage =>
      'Found employees with the same basic data. Review the list before saving.';

  @override
  String bhpAddUserPotentialDuplicateBannerMessage(Object users) {
    return 'Similar records: $users. You can still save, but it is worth checking.';
  }

  @override
  String get bhpAddUserPotentialDuplicateConfirmAction => 'Add anyway';

  @override
  String get bhpAddUserPotentialDuplicateCancelAction => 'Back to form';

  @override
  String get bhpAddUserInvalidEmploymentDatesMessage =>
      'Employment end date cannot be earlier than employment start date.';

  @override
  String get bhpUserEmploymentEndDatePastWarning =>
      'The selected employment end date is in the past. After saving, the employee will be marked as inactive.';

  @override
  String get bhpUserIssuesReadOnlyArchivedMessage =>
      'The employee is archived, so the issues card is read-only. Restore the employee to unlock editing.';

  @override
  String get bhpEditUserTitle => 'Edit employee';

  @override
  String get bhpEditUserLoadErrorTitle => 'Failed to prepare edit form';

  @override
  String get bhpEditUserBaseSectionTitle => 'Employee data';

  @override
  String get bhpEditUserBaseSectionDescription =>
      'Update basic data and parameters used in BHP issues.';

  @override
  String get bhpEditUserSubmitAction => 'Save changes';

  @override
  String bhpEditUserSuccessMessage(Object name) {
    return 'Employee $name has been updated.';
  }

  @override
  String get bhpPreviewNoAssignedPosition => 'No assigned position';

  @override
  String get bhpPreviewDescription =>
      'This is a temporary modal for the employee workflow. The next step is a full detail view with issues.';

  @override
  String get bhpPreviewIssuesAction => 'Issues';

  @override
  String get bhpPreviewEditPendingMessage =>
      'Employee editing is not connected yet.';

  @override
  String bhpPreviewArchivedMessage(Object name) {
    return 'Employee $name has been archived.';
  }

  @override
  String get bhpPreviewRestoreAction => 'Restore';

  @override
  String get bhpPreviewRestoreEmployeeMessage =>
      'Restoring will reactivate the employee. If the employee has a past employment end date, it will be cleared.';

  @override
  String bhpPreviewRestoredMessage(Object name) {
    return 'Employee $name has been restored.';
  }

  @override
  String get bhpPreviewForceDeleteAction => 'Delete from database';

  @override
  String get bhpForceDeleteUserConfirmTitle => 'Delete employee from database';

  @override
  String bhpForceDeleteUserConfirmBody(Object name, Object id) {
    return 'This operation will physically and irreversibly delete employee $name (ID: $id) along with all related equipment issues from the database.';
  }

  @override
  String get bhpForceDeleteUnlockLabel =>
      'To unlock deletion, type: Excellent2026';

  @override
  String get bhpForceDeleteUnlockHint =>
      'Type Excellent2026 to unlock deletion.';

  @override
  String bhpPreviewForceDeletedMessage(Object name) {
    return 'Employee $name has been deleted from the database.';
  }

  @override
  String get bhpIssueConfirmStandardTitle => 'Generate equipment from standard';

  @override
  String get bhpIssueConfirmStandardMessage =>
      'Are you sure you want to generate BHP equipment from the standard of this employee\'s job position?\n\nThe system will check the assigned standard for their position and automatically create missing, active issues. Existing active issues will not be duplicated.';

  @override
  String get bhpIssueConfirmStandardAction => 'Generate';

  @override
  String get inneTitle => 'Inne module';

  @override
  String get edit => 'Edit';

  @override
  String get inventoryEditCommissionTitle => 'Edit commission';

  @override
  String inventoryCommissionForInventory(Object number) {
    return 'Inventory commission $number';
  }

  @override
  String get inventoryNoAssignedCommissionTitle => 'No commission assigned';

  @override
  String get inventoryNoAssignedCommissionMessage =>
      'No commission has been assigned to this inventory yet.';

  @override
  String inventoryUserWithId(int id) {
    return 'User #$id';
  }

  @override
  String get inventoryNoSheetsTitle => 'No sheets';

  @override
  String get inventoryNoSheetsMessage =>
      'Add the first sheet for this inventory.';

  @override
  String inventorySheetWithId(int id) {
    return 'Sheet #$id';
  }

  @override
  String inventoryCommissionForSheet(Object label) {
    return 'Sheet commission $label';
  }

  @override
  String get inventoryNoAssignedLocation => 'No assigned location';

  @override
  String get inventoryItemsLabel => 'Items';

  @override
  String get inventoryLocationLevelLabel => 'Location level';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get inventorySheetCommissionNone => 'Sheet commission: none';

  @override
  String inventorySheetCommissionWithMembers(Object members) {
    return 'Sheet commission: $members';
  }

  @override
  String get inventoryDeleteCompanyTitle => 'Delete company';

  @override
  String get inventoryDeleteCompanySubtitle =>
      'Company deletion is irreversible.';

  @override
  String get inventoryDeleteCompanyConfirmTitle =>
      'Are you sure you want to delete this company?';

  @override
  String inventoryDeleteCompanyConfirmBody(Object name, int id) {
    return 'Company: $name\nCompany ID: $id\nThis operation cannot be undone.';
  }

  @override
  String get inventoryDeleteTitle => 'Delete inventory';

  @override
  String get inventoryDeleteSubtitle => 'Inventory deletion is irreversible.';

  @override
  String get inventoryDeleteConfirmTitle =>
      'Are you sure you want to delete this inventory?';

  @override
  String inventoryDeleteConfirmBody(Object number, int id) {
    return 'Inventory: $number\nID: $id\nThis operation cannot be undone.';
  }

  @override
  String get inventoryDeleteUnlockLabel => 'Confirmation';

  @override
  String get inventoryDeleteUnlockHint => 'Type Excellent to unlock deletion.';

  @override
  String get inventoryDeletedMessage => 'Inventory has been deleted.';

  @override
  String get inventorySnapshotRefreshButton => 'Refresh snapshot';

  @override
  String get inventorySnapshotRefreshTitle => 'ST snapshot refresh';

  @override
  String get inventorySnapshotRefreshSubtitle =>
      'ST data synchronization for all databases.';

  @override
  String get inventorySnapshotRefreshConfirmTitle => 'Snapshot refresh';

  @override
  String get inventorySnapshotRefreshConfirmSubtitle =>
      'Operation confirmation';

  @override
  String get inventorySnapshotRefreshConfirmQuestion =>
      'Are you sure you want to refresh the ST snapshot? The operation may take several dozen seconds.';

  @override
  String get inventorySnapshotRefreshUnlockLabel =>
      'To unlock refresh, type: Excellent';

  @override
  String get inventorySnapshotRefreshUnlockHint => 'Type the unlock phrase';

  @override
  String get inventorySnapshotRefreshAction => 'Refresh';

  @override
  String get inventorySnapshotRefreshInProgressTitle =>
      'ST snapshot refresh in progress';

  @override
  String get inventorySnapshotRefreshInProgressMessage =>
      'Operation is running. This may take several dozen seconds.';

  @override
  String get inventorySnapshotRefreshBlockedTitle =>
      'Snapshot refresh unavailable';

  @override
  String get inventorySnapshotRefreshBlockedMessage =>
      'There is an active inventory. Close it and try again.';

  @override
  String get inventorySnapshotRefreshFailureTitle => 'Refresh failed';

  @override
  String get inventorySnapshotRefreshSuccessTitle => 'Refresh completed';

  @override
  String inventorySnapshotRefreshSuccessMessage(int okCount, int errorCount) {
    return 'Refresh completed. Success: $okCount, errors: $errorCount.';
  }

  @override
  String get inventorySnapshotRefreshProcessingAction => 'Processing...';

  @override
  String get inventoryCloseTitle => 'Close inventory';

  @override
  String get inventoryCloseSubtitle =>
      'After closing, editing will no longer be available.';

  @override
  String get inventoryCloseConfirmTitle =>
      'Are you sure you want to close this inventory?';

  @override
  String inventoryCloseConfirmBody(Object number, int id) {
    return 'Inventory: $number\nID: $id\nStatus will be changed to finished (2).';
  }

  @override
  String get inventoryCloseDateLabel => 'End date (data_do)';

  @override
  String get inventoryCloseUnlockLabel => 'Close confirmation';

  @override
  String get inventoryCloseUnlockHint => 'Type Excellent to unlock closing.';

  @override
  String get inventoryCloseBlockedStatusMessage =>
      'Inventory can be closed only from In progress status (1).';

  @override
  String get inventoryCloseDateValidationMessage =>
      'End date must be greater than or equal to start date.';

  @override
  String get inventoryClosedMessage => 'Inventory has been closed.';

  @override
  String get inventoryDeleteSheetTitle => 'Delete sheet';

  @override
  String get inventoryDeleteSheetSubtitle => 'Sheet deletion is irreversible.';

  @override
  String get inventoryDeleteSheetConfirmTitle =>
      'Are you sure you want to delete this sheet?';

  @override
  String inventoryDeleteSheetConfirmBody(Object number, int id) {
    return 'Sheet: $number\nID: $id\nThis operation cannot be undone.';
  }

  @override
  String get inventoryDeleteSheetBlockedMessage =>
      'Cannot delete a sheet in a finished inventory (status=2).';

  @override
  String get inventorySheetDeletedMessage => 'Sheet has been deleted.';

  @override
  String get inventoryArchiveTitle => 'Archive';

  @override
  String get inventoryArchiveSubtitle => 'Archived views and supporting data.';

  @override
  String get inventoryCommissionLabel => 'Commission';

  @override
  String get inventoryReportsShowNotesLabel => 'Show notes';

  @override
  String get inventoryReportsDisposalProtocolLabel => 'Disposal protocol';

  @override
  String get inventoryReportsMacOSWorkaroundPrefix =>
      'macOS workaround: dynamicLayout disabled • ';

  @override
  String get inventoryReportsPrintStatusAvailable => 'available';

  @override
  String get inventoryReportsPrintStatusUnavailable => 'unavailable';

  @override
  String get inventoryReportsShareStatusAvailable => 'available';

  @override
  String get inventoryReportsShareStatusUnavailable => 'unavailable';

  @override
  String get inventorySearchUserHint => 'Search user...';

  @override
  String get inventorySearching => 'Searching...';

  @override
  String get inventoryTypeMinTwoChars => 'Type at least 2 characters';

  @override
  String get inventoryNoResults => 'No results';

  @override
  String get inventoryNoSelectedPeopleTitle => 'No selected people';

  @override
  String get inventoryNoSelectedPeopleMessage =>
      'Add users to commission from search.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get inventoryEditSheetItemTitle => 'Edit sheet item';

  @override
  String inventoryEditSheetItemSubtitle(
    Object name,
    Object register,
    Object barcode,
  ) {
    return '$name ($register) | BC: $barcode';
  }

  @override
  String get inventoryItemSavedMessage => 'Item changes have been saved.';

  @override
  String get inventoryInventoryStateShort => 'Inv. state';

  @override
  String get inventoryInventoryStateNone => 'Missing';

  @override
  String get inventoryInventoryStateMatching => 'Matching';

  @override
  String get inventoryInventoryStateTransferred => 'Transferred';

  @override
  String get inventoryScan => 'Scan';

  @override
  String get inventoryScannerNotRead => 'Not scanned';

  @override
  String get inventoryScannerRead => 'Scanned';

  @override
  String get inventoryLiquidation => 'Liquidation';

  @override
  String get inventorySurplus => 'Surplus';

  @override
  String get inventoryNewBarcode => 'New barcode';

  @override
  String get inventoryNewPerson => 'New person';

  @override
  String get inventoryNewName => 'New name';

  @override
  String get inventoryLocalRemarksHint => 'Remarks';

  @override
  String get inventoryNewBarcodeMaxLengthError =>
      'New barcode can contain at most 64 characters.';

  @override
  String inventoryAddSheetToInventory(int inventoryId) {
    return 'Add sheet to inventory #$inventoryId';
  }

  @override
  String get inventoryLoadLocationsErrorTitle => 'Failed to load locations';

  @override
  String get inventoryOptionalCommission => 'Commission (optional)';

  @override
  String get inventorySearchByNameOrLoginHint =>
      'Search person by name or login...';

  @override
  String get inventorySelectLocationFromTree =>
      'Select location from the tree.';

  @override
  String get inventoryScopeAutoSet =>
      'The sheet will include only the selected location.';

  @override
  String get inventoryNoLocationsTitle => 'No locations';

  @override
  String get inventoryLocationsBackendEmptyMessage =>
      'Backend did not return locations for this inventory.';

  @override
  String inventoryIdWithValue(int id) {
    return 'ID $id';
  }

  @override
  String inventoryLocationWithId(int id) {
    return 'Location: $id';
  }

  @override
  String get inventorySelectLocationBeforeCreateError =>
      'Select location in the tree before creating the sheet.';

  @override
  String get inventoryInvalidCommissionFormatError =>
      'Commission list has invalid format.';

  @override
  String get inventorySheetDetailsTitle => 'Sheet details';

  @override
  String get inventorySheetDetailsLoadErrorTitle =>
      'Failed to load sheet details';

  @override
  String get inventorySheetItemsTitle => 'Sheet items';

  @override
  String get inventorySearchSheetItemsHint =>
      'Search by ID, register no., name, person, location or barcode';

  @override
  String get inventoryAdd => 'Add';

  @override
  String get inventoryAddByRegisterNumberShort => 'Add by reg. no.';

  @override
  String get inventoryAddSheetItemTitle => 'Add sheet item';

  @override
  String get inventoryAddSheetItemSubtitle =>
      'Manually add a new item to the current sheet.';

  @override
  String get inventoryAddSheetItemBarcodeOptionalHelper =>
      'Optional field. If left empty, the backend will save 0.';

  @override
  String get inventoryAddSheetItemAtLeastOneFieldError =>
      'Fill in at least one field identifying the item.';

  @override
  String get inventoryAddSheetItemByRegisterNumberTitle =>
      'Add by register number';

  @override
  String get inventoryAddSheetItemByRegisterNumberSubtitle =>
      'Find and add an item to the sheet using its register number.';

  @override
  String get inventorySheetItemAddedMessage => 'Sheet item has been added.';

  @override
  String get inventorySheetItemAddedByRegisterNumberMessage =>
      'Item has been added to the sheet by register number.';

  @override
  String get inventoryBarcodeRequiredError => 'Barcode is required.';

  @override
  String get inventoryBarcodePositiveIntegerError =>
      'Enter a valid barcode as an integer greater than 0.';

  @override
  String get inventoryRegisterNumberRequiredError =>
      'Register number is required.';

  @override
  String get inventoryAssetStateLabel => 'Asset status';

  @override
  String inventoryResultsCount(int filtered, int total) {
    return 'Results: $filtered/$total';
  }

  @override
  String get inventoryNoItemsTitle => 'No items';

  @override
  String get inventoryNoSearchResultsTitle => 'No search results';

  @override
  String get inventoryHideFinished => 'Hide finished';

  @override
  String get inventoryHideFinishedEmptyMessage =>
      'All inventories are finished or hidden by the filter.';

  @override
  String get inventorySheetNoItemsMessage =>
      'Sheet does not contain any items.';

  @override
  String get inventoryTryAnotherPhraseMessage => 'Try another phrase.';

  @override
  String get inventorySheetLabel => 'Inventory sheet';

  @override
  String get inventoryEditSheetNumberAction => 'Change sheet number';

  @override
  String get inventoryAssetStatusNone => 'None';

  @override
  String get inventoryAssetStatusUnconfirmed => 'Unconfirmed';

  @override
  String get inventoryAssetStatusInUse => 'In use';

  @override
  String get inventoryAssetStatusDisposed => 'Disposed';

  @override
  String get inventoryAssetStatusSold => 'Sold';

  @override
  String get inventoryAssetStatusTransferred => 'Transferred';

  @override
  String get inventoryAssetStatusMissingInAssets =>
      'Not present in fixed assets';

  @override
  String get inventoryStatusNew => 'New';

  @override
  String get inventoryStatusInProgress => 'In progress';

  @override
  String get inventoryStatusFinished => 'Finished';

  @override
  String get inventoryStatusUnknown => 'Unknown';

  @override
  String get inventorySheetNumberSavedMessage => 'Sheet number has been saved.';

  @override
  String get inventoryNumberExampleHint => 'e.g. INV/2026/04/001';

  @override
  String get inventoryModuleStatusTitle => 'Module status';

  @override
  String get inventoryModuleStatusSubtitle =>
      'Current module startup parameters.';

  @override
  String get inventoryModuleInitialRoute => 'Initial route';

  @override
  String get inventoryModuleSession => 'Session';

  @override
  String get inventoryModuleSessionNoAuthContext =>
      'UI does not require auth context';

  @override
  String get bhpUsersFilterActive => 'Active';

  @override
  String get bhpUsersFilterArchived => 'Archived';

  @override
  String get bhpUsersFilterAll => 'All';

  @override
  String get bhpUsersRowNumber => 'No.';

  @override
  String get bhpUsersOverdueLabel => 'Overdue';

  @override
  String get bhpUsersUpcomingLabel => 'Upcoming';

  @override
  String get bhpUsersDaysSuffix => 'days';

  @override
  String get bhpUserIssuesViewActive => 'Active';

  @override
  String get bhpUserIssuesViewHistory => 'History';

  @override
  String get bhpUserIssuesViewStandard => 'To standard';

  @override
  String get bhpSectionStatistics => 'Statistics';

  @override
  String get bhpOperationsTitle => 'Operations history';

  @override
  String get bhpOperationsSubtitle =>
      'Full list of BHP operations for the selected year.';

  @override
  String get bhpOperationsEmptyTitle => 'No operations';

  @override
  String get bhpOperationsEmptyMessage =>
      'No BHP operations were found for the selected year.';

  @override
  String get bhpStatisticsTitle => 'Operations statistics';

  @override
  String get bhpStatisticsSubtitle => 'Monthly summary of BHP operations.';

  @override
  String get bhpStatisticsEmptyTitle => 'No statistical data';

  @override
  String get bhpStatisticsEmptyMessage =>
      'No BHP operations were found for the selected year, so statistics cannot be calculated yet.';

  @override
  String get bhpStatisticsOperationsTab => 'Operations';

  @override
  String get bhpStatisticsMonthLabel => 'Month';

  @override
  String get bhpStatisticsMonthlyTitle => 'Monthly statistics';

  @override
  String get bhpStatisticsOperationsCountLabel => 'Operations';

  @override
  String get bhpStatisticsItemsCountLabel => 'Items';

  @override
  String get bhpStatisticsUsersCountLabel => 'Employees';

  @override
  String get bhpStatisticsDominantTypeLabel => 'Dominant type';

  @override
  String get bhpStatisticsOperationsCaption => 'Events in the selected month';

  @override
  String get bhpStatisticsItemsCaption => 'Total quantity from operations';

  @override
  String get bhpStatisticsUsersCaption => 'Unique people involved';

  @override
  String get bhpStatisticsDominantTypeCaptionNone => 'No data';

  @override
  String bhpStatisticsDominantTypeCaptionMany(int count) {
    return '$count times';
  }

  @override
  String get bhpStatisticsTopEquipmentTitle => 'Most issued items';

  @override
  String get bhpStatisticsTopUsersTitle => 'Most active employees';

  @override
  String get bhpStatisticsMonthEmptyMessage =>
      'No data for the selected month.';

  @override
  String get bhpStatisticsIssuesTab => 'Issues';

  @override
  String get bhpStatisticsStructureTab => 'Structure';

  @override
  String get bhpStatisticsMissingTab => 'Missing';

  @override
  String get bhpStatisticsComparisonsTab => 'Comparisons';

  @override
  String get bhpStatisticsStructurePlaceholderTitle => 'Structure';

  @override
  String get bhpStatisticsStructurePlaceholderMessage =>
      'Operation types, positions, and equipment breakdowns will be built here.';

  @override
  String get bhpStatisticsStructureSummaryTitle => 'Operation structure';

  @override
  String get bhpStatisticsStructureSummarySubtitle =>
      'Breakdowns show which items, positions, and people generated the most operations in the selected year.';

  @override
  String get bhpStatisticsStructureEquipmentLabel => 'Distinct items';

  @override
  String get bhpStatisticsStructurePositionsLabel => 'Distinct positions';

  @override
  String get bhpStatisticsStructureTypesTitle => 'Operation types';

  @override
  String get bhpStatisticsStructureTypesSubtitle =>
      'The share of each type within the full yearly operation feed.';

  @override
  String get bhpStatisticsStructureShareLabel => 'Share';

  @override
  String get bhpStatisticsStructureEquipmentSubtitle =>
      'Equipment cards ranked by operation count and issued quantity.';

  @override
  String get bhpStatisticsStructurePositionsTitle => 'Positions';

  @override
  String get bhpStatisticsStructurePositionsSubtitle =>
      'Which positions had the most operations and the highest issued quantities.';

  @override
  String get bhpStatisticsStructureUsersSubtitle =>
      'Clicking an employee opens their issue card.';

  @override
  String get bhpStatisticsStructureIssuedCountTooltip =>
      'Sum of all individual equipment issue events this year.';

  @override
  String get bhpStatisticsStructureIssuedQuantityTooltip =>
      'Total number of pieces or pairs of equipment issued to employees.';

  @override
  String get bhpStatisticsStructureEquipmentTooltip =>
      'Number of different equipment types issued this year.';

  @override
  String get bhpStatisticsStructureUsersTooltip =>
      'Number of unique employees who received at least one issue this year.';

  @override
  String get bhpStatisticsMissingPlaceholderTitle => 'Missing';

  @override
  String get bhpStatisticsMissingPlaceholderMessage =>
      'A global view of users with incomplete equipment will be built here.';

  @override
  String get bhpStatisticsMissingSummaryTitle => 'Missing vs standard';

  @override
  String get bhpStatisticsMissingSummarySubtitle =>
      'This tab will show who is missing which items compared with their assigned equipment standard.';

  @override
  String get bhpStatisticsMissingPeopleLabel => 'People with gaps';

  @override
  String get bhpStatisticsMissingItemsLabel => 'Missing items';

  @override
  String get bhpStatisticsMissingTopItemLabel => 'Most common gap';

  @override
  String get bhpStatisticsMissingPeopleTooltip =>
      'This is the number of active employees who are currently missing at least one required item from their position standard.';

  @override
  String get bhpStatisticsMissingItemsTooltip =>
      'This is the total number of standard items that currently have no active issue assigned to employees.';

  @override
  String get bhpStatisticsMissingTopItemTooltip =>
      'This is the piece of equipment that appears most often in today\'s missing list.';

  @override
  String get bhpStatisticsMissingBackendTitle => 'What will be shown here';

  @override
  String get bhpStatisticsMissingBackendMessage =>
      'Once the data is connected, this tab will show users with incomplete equipment, missing item counts per person, and the most frequently missing items.';

  @override
  String get bhpStatisticsMissingTableTitle => 'People with missing equipment';

  @override
  String get bhpStatisticsMissingTableMessage =>
      'This table will be used operationally: sorting by missing count, person, and position.';

  @override
  String get bhpStatisticsMissingTableItemsLabel => 'Missing items list';

  @override
  String get bhpStatisticsMissingTableLatestIssueLabel => 'Last closure';

  @override
  String get bhpStatisticsMissingNoDataTitle => 'No missing equipment';

  @override
  String get bhpStatisticsMissingNoDataMessage =>
      'At the moment all active employees have complete active issues compared with their standard.';

  @override
  String get bhpStatisticsMissingEndpointTitle => 'Required backend data';

  @override
  String get bhpStatisticsMissingEndpointMessage =>
      'This tab needs a separate global missing-equipment endpoint. The current issue data is not enough to calculate this view for all employees.';

  @override
  String get bhpStatisticsComparisonsPlaceholderTitle => 'Comparisons';

  @override
  String get bhpStatisticsComparisonsPlaceholderMessage =>
      'Year-over-year and month-over-month comparisons will be built here.';

  @override
  String get bhpStatisticsIssuesSummaryTitle => 'Detailed issue statistics';

  @override
  String get bhpStatisticsIssuesSummarySubtitle =>
      'The selected year is shown first and the previous year appears in parentheses.';

  @override
  String get bhpStatisticsIssuesTableTitle => 'Issued items list';

  @override
  String get bhpStatisticsIssuesTableSubtitle =>
      'Sorted by total quantity issued in the selected year.';

  @override
  String get bhpStatisticsIssuesNoDataTitle => 'No data';

  @override
  String get bhpStatisticsIssuesNoDataMessage =>
      'There were no issues in the selected year.';

  @override
  String get bhpStatisticsIssuesIssuedQuantityLabel => 'Total issued quantity';

  @override
  String get bhpStatisticsIssuesIssuedCountLabel => 'Issue count';

  @override
  String get bhpStatisticsIssuesClosedCountLabel => 'Closed count';

  @override
  String get bhpStatisticsIssuesEquivalentCountLabel => 'Equivalent count';

  @override
  String get bhpStatisticsIssuesOperationsTooltip =>
      'This includes every event saved this year: issues, closures, and equivalents.';

  @override
  String get bhpStatisticsIssuesIssuedQuantityTooltip =>
      'This is the total number of items issued to employees during the year.';

  @override
  String get bhpStatisticsIssuesIssuedCountTooltip =>
      'This is the number of issue actions performed during the year, regardless of how many items were included in each one.';

  @override
  String get bhpStatisticsIssuesClosedCountTooltip =>
      'This is the number of issues that were closed or returned during the year.';

  @override
  String get bhpStatisticsIssuesEquivalentCountTooltip =>
      'This is the number of cases where an equivalent was registered instead of a regular issue.';

  @override
  String get bhpStatisticsIssuesComparisonLoading => 'Loading comparison...';

  @override
  String bhpStatisticsIssuesTableOperationsSuffix(int count) {
    return '$count operations';
  }

  @override
  String get bhpIssueOperationsTabOperations => 'Operations';

  @override
  String get bhpIssueOperationsTabStatistics => 'Statistics';

  @override
  String get bhpIssueOperationsStatisticsTitle => 'Monthly statistics';

  @override
  String get bhpIssueOperationsStatisticsYearLabel => 'Year';

  @override
  String get bhpIssueOperationsStatisticsNoDataTitle => 'No monthly data';

  @override
  String get bhpIssueOperationsStatisticsNoDataMessage =>
      'There are no operations in the selected year to calculate statistics from.';

  @override
  String get bhpIssueOperationsStatisticsOperationsLabel => 'Operations';

  @override
  String get bhpIssueOperationsStatisticsItemsLabel => 'Items';

  @override
  String get bhpIssueOperationsStatisticsUsersLabel => 'Employees';

  @override
  String get bhpIssueOperationsStatisticsDominantTypeLabel => 'Dominant type';

  @override
  String get bhpIssueOperationsStatisticsOperationsCaption =>
      'Events in the selected month';

  @override
  String get bhpIssueOperationsStatisticsItemsCaption =>
      'Total quantity from operations';

  @override
  String get bhpIssueOperationsStatisticsUsersCaption =>
      'Unique people involved in movement';

  @override
  String get bhpIssueOperationsStatisticsDominantTypeCaptionNone => 'No data';

  @override
  String bhpIssueOperationsStatisticsDominantTypeCaptionMany(int count) {
    return '$count times';
  }

  @override
  String get bhpIssueOperationsStatisticsTopEquipmentTitle =>
      'Most frequently issued items';

  @override
  String get bhpIssueOperationsStatisticsTopUsersTitle =>
      'Most active employees';

  @override
  String get bhpIssueOperationsStatisticsNoMonthItemsMessage =>
      'No data for the selected month.';

  @override
  String get bhpOperationsSearchHint =>
      'Search employee, equipment, or description...';

  @override
  String get bhpUserIssuesStandardTitle => 'To issue from standard';

  @override
  String get bhpUserIssuesStandardSubtitle =>
      'Missing position-standard items without an active issue.';

  @override
  String get bhpUserIssuesStandardEmptyTitle => 'No missing items';

  @override
  String get bhpUserIssuesStandardEmptyMessage =>
      'All active position-standard items are already covered by active issues.';

  @override
  String get bhpUserIssuesStandardSearchHint => 'Search standard gaps...';

  @override
  String get bhpUserIssuesHistoryTitle => 'Issue history';

  @override
  String get bhpUserIssuesHistorySubtitle =>
      'Closed issues. You can reissue them if the employee no longer has the same active card.';

  @override
  String get bhpUserIssuesHistoryEmptyTitle => 'No issue history';

  @override
  String get bhpUserIssuesHistoryEmptyMessage =>
      'This employee has no closed issues yet.';

  @override
  String get bhpUserIssuesActiveTitle => 'Active issues';

  @override
  String get bhpUserIssuesActiveSubtitle =>
      'Equipment currently issued to the employee. This is where you close or reissue items.';

  @override
  String get bhpUserIssuesActiveEmptyTitle => 'No active issues';

  @override
  String get bhpUserIssuesActiveEmptyMessage =>
      'The employee currently has no active issue.';

  @override
  String get bhpUserIssuesBlockedBannerTitle => 'Issues blocked';

  @override
  String get bhpUserIssuesBlockedBannerMessage =>
      'The employee cannot receive issues right now. Check the employee and position status.';

  @override
  String get bhpUserIssuesCompliantBannerTitle => 'Compliant with standard';

  @override
  String bhpUserIssuesCompliantBannerMessage(int count) {
    return 'All active position-standard items are covered by active issues. Active issues: $count.';
  }

  @override
  String get bhpUserIssuesMissingBannerTitle => 'Standard gaps';

  @override
  String bhpUserIssuesMissingBannerMessage(int count) {
    return 'Missing $count items required by the position standard. Add them in the \"To issue from standard\" section.';
  }

  @override
  String get bhpUserIssuesNoNameFallback => 'No name';

  @override
  String get bhpUserIssuesRenewAction => 'Reissue';

  @override
  String get bhpUserIssuesIssueStandardConfirmTitle => 'Issue standard item';

  @override
  String bhpUserIssuesIssueStandardConfirmMessage(Object item) {
    return 'Do you want to issue $item according to the position standard?';
  }

  @override
  String get bhpUserIssuesIssueStandardConfirmAction => 'Issue';

  @override
  String get bhpUserIssuesIssueStandardSuccess =>
      'The item has been issued according to the standard.';

  @override
  String get bhpUserIssuesRenewActiveTitle => 'Reissue';

  @override
  String bhpUserIssuesRenewActiveMessage(Object item) {
    return 'The previous active issue $item will be closed automatically and a new issue will be created today. Continue?';
  }

  @override
  String get bhpUserIssuesRenewActiveAction => 'Reissue';

  @override
  String get bhpUserIssuesRenewActiveSuccess =>
      'A new issue has been created and the previous one has been closed.';

  @override
  String get bhpUserIssuesPrintSelectTitle => 'Select items to print';

  @override
  String get bhpUserIssuesPrintOnlyActive => 'Active only';

  @override
  String get bhpUserIssuesPrintOnlyInactive => 'Inactive only';

  @override
  String get bhpUserIssuesPrintAll => 'All';

  @override
  String get bhpUserIssuesPrintEmptyTitle => 'No items to print';

  @override
  String get bhpUserIssuesPrintEmptyMessage =>
      'This employee has no issues to select yet.';

  @override
  String get bhpUserIssuesPrintSelectedAction => 'Print selected';

  @override
  String bhpUserIssuesPrintIssueLabelFallback(int id) {
    return 'Item #$id';
  }

  @override
  String get bhpUserIssuesLastIssueLabel => 'Last issue';

  @override
  String get bhpUserIssueInfoSubtitle => 'Equipment card';

  @override
  String get bhpUserIssueInfoNoEquipmentTitle => 'No equipment card';

  @override
  String get bhpUserIssueInfoNoEquipmentMessage =>
      'This issue has no assigned equipment card.';

  @override
  String get bhpUserIssueInfoLoadErrorTitle =>
      'Failed to load equipment details';

  @override
  String get bhpUserIssueInfoRetryAction => 'Try again';

  @override
  String get bhpUserIssueInfoDescription =>
      'Equipment card details from the BHP catalog.';

  @override
  String get bhpUserIssueInfoSymbolLabel => 'Symbol';

  @override
  String get bhpUserIssueInfoNameLabel => 'Name';

  @override
  String get bhpUserIssueInfoUnitLabel => 'Unit';

  @override
  String get bhpUserIssueInfoPeriodLabel => 'Usable period';

  @override
  String get bhpUserIssueInfoDefaultQuantityLabel => 'Default quantity';

  @override
  String get bhpUserIssueInfoEvidenceNumberLabel => 'Issue evidence no.';

  @override
  String get bhpUserIssueInfoEquivalentLabel => 'Card equivalent';

  @override
  String get bhpUserIssueInfoPriceLabel => 'Price';

  @override
  String get bhpUserIssueInfoAvailabilityLabel => 'Availability';

  @override
  String get bhpUserIssueInfoPercentLabel => 'Usability percentage';

  @override
  String get bhpUserIssueInfoStatusLabel => 'Status';

  @override
  String get bhpUserIssueInfoMonthSuffix => 'mo.';

  @override
  String get bhpUserIssuesPdfTitle => 'BHP EQUIPMENT CARD';

  @override
  String get bhpUserIssuesPdfIssuerSignatureLabel => 'Issuer signature';

  @override
  String get bhpUserIssuesPdfEmployeeSignatureLabel => 'Employee signature';

  @override
  String get bhpUserIssuesPdfDisclaimer =>
      'I confirm receipt of the above equipment in a condition suitable for use and I agree to use it according to its intended purpose.';

  @override
  String get bhpUserIssuesPdfHeightLabel => 'Height';

  @override
  String get bhpUserIssuesPdfChestLabel => 'Chest circumference';

  @override
  String get bhpUserIssuesPdfWaistLabel => 'Waist circumference';

  @override
  String get bhpUserIssuesPdfHeadLabel => 'Head circumference';

  @override
  String get bhpUserIssuesPdfFootLabel => 'Foot length';

  @override
  String bhpUserIssuesPdfPageLabel(int current, int total) {
    return 'Page $current / $total';
  }

  @override
  String get bhpIssueFormEquipmentRequired => 'Equipment is required.';

  @override
  String get bhpIssueNoEquipmentFallback => 'No equipment';

  @override
  String bhpIssueCardFallback(int id) {
    return 'Card #$id';
  }

  @override
  String get bhpIssueUnknownEquipmentFallback => 'Unknown equipment';

  @override
  String get bhpIssueEquivalentHelperExisting =>
      'You can change the equivalent date and amount. The date cannot be earlier than the issue date.';

  @override
  String get bhpIssueEquivalentHelperOpen =>
      'You can enter an equivalent even for an open issue. The date cannot be earlier than the issue date.';

  @override
  String get bhpIssueEquivalentHelperClosed =>
      'The date cannot be earlier than the issue date or the issue closing date.';

  @override
  String get bhpIssueEquivalentInvalidIssueDate =>
      'The equivalent date cannot be earlier than the issue date.';

  @override
  String get bhpIssueEquivalentInvalidCloseDate =>
      'The equivalent date cannot be earlier than the issue closing date.';

  @override
  String get bhpIssueValidationPositiveAmount =>
      'Enter a valid amount greater than 0.';

  @override
  String get bhpIssueEditInvalidDateMessage => 'Choose a valid issue date.';

  @override
  String get bhpIssueEditMissingSourceMessage =>
      'This issue cannot be edited because source data is missing.';

  @override
  String get bhpUserIssueCommandInProgress =>
      'An operation is already in progress.';

  @override
  String get bhpDeleteUserTitle => 'Delete employee';

  @override
  String get bhpDeleteUserSubtitle =>
      'This operation removes the employee from the active list by archiving them.';

  @override
  String bhpDeleteUserConfirmMessage(Object name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get bhpDeleteUserArchiveMessage =>
      'This operation irreversibly deletes the employee and all BHP history from the database.';

  @override
  String get bhpArchiveUserAction => 'Archive';

  @override
  String get bhpArchiveUserTitle => 'Archive employee';

  @override
  String get bhpArchiveUserSubtitle =>
      'This operation removes the employee from the active list, but it does not delete their BHP history.';

  @override
  String bhpArchiveUserConfirmMessage(Object name) {
    return 'Are you sure you want to archive $name?';
  }

  @override
  String get bhpArchiveUserMessage =>
      'The employee will be moved to the archive and removed from the active list. Their BHP history will remain available, and the employee can be restored later.';

  @override
  String get bhpStatisticsComparisonsTabMetrics => 'Annual indicators';

  @override
  String get bhpStatisticsComparisonsTabProducts => 'Products';

  @override
  String get bhpStatisticsComparisonsTabEquivalents => 'Equivalents';

  @override
  String get bhpStatisticsComparisonsMetricsTitle =>
      'Comparison of main annual indicators';

  @override
  String get bhpStatisticsComparisonsMetricsSubtitle =>
      'Summary of key BHP indicators for the selected year and two years back.';

  @override
  String get bhpStatisticsComparisonsTableColumnMetric => 'Indicator';

  @override
  String bhpStatisticsComparisonsYearLabel(int year) {
    return 'Year $year';
  }

  @override
  String get bhpStatisticsComparisonsProductsTitle =>
      'Comparison of product issues (BHP items)';

  @override
  String get bhpStatisticsComparisonsProductsSubtitle =>
      'Summary of demand for individual products in the format: Number of issues (Quantity).';

  @override
  String get bhpStatisticsComparisonsTableColumnProduct => 'Product / BHP item';

  @override
  String get bhpStatisticsComparisonsEquivalentsCountRow =>
      'Number of equivalents paid';

  @override
  String get bhpStatisticsComparisonsEquivalentsCountTooltip =>
      'Total number of registered monetary equivalent payments in a given year.';

  @override
  String get bhpStatisticsComparisonsEquivalentsAmountRow =>
      'Total equivalents paid';

  @override
  String get bhpStatisticsComparisonsEquivalentsAmountTooltip =>
      'Total sum of paid equivalent amounts (in PLN) in a given year.';

  @override
  String get bhpStatisticsComparisonsEquivalentsTitle =>
      'Summary of equivalents';

  @override
  String get bhpStatisticsComparisonsEquivalentsSubtitle =>
      'Summary of the number of paid equivalents and their total annual sum.';

  @override
  String get bhpStatisticsComparisonsEquivalentsProductsTitle =>
      'Equivalents by products (BHP items)';

  @override
  String get bhpStatisticsComparisonsEquivalentsProductsSubtitle =>
      'Summary of equivalent payments for individual products in the format: Number of payments (Total PLN).';

  @override
  String get bhpCurrencyPln => 'PLN';

  @override
  String get bhpStatisticsChartTitle => 'Monthly Visualization';

  @override
  String get bhpStatisticsChartToggleCount => 'Number of operations';

  @override
  String get bhpStatisticsChartToggleQuantity => 'Issued quantity';

  @override
  String get bhpStatisticsChartStructureEquipmentTitle =>
      'Most frequently issued items (Top 5)';

  @override
  String get bhpStatisticsChartStructurePositionsTitle =>
      'Issues by position (Top 5)';

  @override
  String get bhpStatisticsChartComparisonsTitle => 'Visual Metric Comparison';

  @override
  String get inventoryEditDatesAction => 'Edit dates';

  @override
  String get inventoryEditDatesTitle => 'Edit inventory dates';

  @override
  String get inventoryEditDatesSubtitle =>
      'Change the date range of the active inventory.';

  @override
  String get inventoryDatesSavedMessage => 'Inventory dates have been saved.';

  @override
  String get inventoryTreeProgressTitle => 'Sheet completion';

  @override
  String get inventoryTreeLoadErrorTitle => 'Could not load the tree';

  @override
  String get inventoryRetryAction => 'Retry';

  @override
  String get inventoryTreeNoLocationsTitle => 'No locations to display';

  @override
  String get inventoryTreeNoLocationsMessage =>
      'This inventory has no assigned locations yet.';

  @override
  String inventoryTreeNodesSummary(int count) {
    return 'Nodes: $count';
  }

  @override
  String inventoryTreeNodesAmbiguousSummary(int count, int ambiguous) {
    return 'Nodes: $count • ambiguous: $ambiguous';
  }

  @override
  String inventoryTreeCompanySummary(int places, int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      places,
      locale: localeName,
      other: '$places locations',
      one: '1 location',
    );
    return '$_temp0 • $sheets with sheets';
  }

  @override
  String get inventoryTreeCompanyAmbiguousSuffix =>
      ' • contains ambiguous locations';

  @override
  String inventoryProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String inventoryTreeIncompleteTitle(int count) {
    return 'Incomplete ($count)';
  }

  @override
  String get inventoryTreeStatusAmbiguous => 'Ambiguous';

  @override
  String get inventoryTreeStatusCompleted => 'Completed';

  @override
  String get inventoryTreeStatusMissingSheet => 'Missing sheet';

  @override
  String get inventoryTreeStatusNoProducts => 'No products';

  @override
  String get inventoryTreeAmbiguousTooltip =>
      'This location has more than one mapping for the same company and location identifier. The sheet status is uncertain.';

  @override
  String get inventoryTreeProductsTooltip =>
      'Show the product list for this location';

  @override
  String get inventoryLocationProductsTitle => 'Products in location';

  @override
  String get inventoryProductsLoadErrorTitle => 'Could not load products';

  @override
  String get inventoryProductsEmptyTitle => 'No products';

  @override
  String get inventoryProductsEmptyMessage =>
      'This location has no active products in the stan_st snapshot.';

  @override
  String inventoryProductsShownSummary(int visible, int total) {
    return 'Showing $visible of $total products';
  }

  @override
  String inventoryProductsSummary(int total) {
    return 'Products: $total';
  }

  @override
  String get inventoryShowingLastDataTitle => 'Showing the last available data';

  @override
  String get tasksBoardTitle => 'Project tasks';

  @override
  String get tasksBoardErrorTitle => 'Could not open the board';

  @override
  String get tasksBoardForbiddenTitle => 'You do not have access to this board';

  @override
  String get tasksBoardNotFoundTitle => 'The project or board was not found';

  @override
  String get tasksBoardOfflineTitle => 'No connection to the server';

  @override
  String tasksBoardSubtitle(int count) {
    return '$count tasks on the board';
  }

  @override
  String get tasksKanbanQuickFilter => 'Quick board filter';

  @override
  String get tasksKanbanQuickFilterAll => 'All tasks';

  @override
  String get tasksKanbanQuickFilterMine => 'My tasks';

  @override
  String get tasksKanbanQuickFilterUnassigned => 'Unassigned';

  @override
  String get tasksKanbanQuickFilterBlocked => 'Blocked';

  @override
  String get tasksKanbanQuickFilterDueSoon => 'Due within 7 days';

  @override
  String tasksPresenceCount(int count) {
    return 'People online: $count';
  }

  @override
  String get tasksPresenceOnline => 'Online';

  @override
  String get tasksPresenceOffline => 'Offline';

  @override
  String get tasksRealtimeConnected => 'Changes are synchronized live';

  @override
  String get tasksRealtimeConnecting => 'Reconnecting live synchronization…';

  @override
  String get tasksRealtimeOffline => 'Live synchronization is offline';

  @override
  String get tasksColumnEmpty => 'No tasks in this column';

  @override
  String get tasksQuickCreate => 'Add task';

  @override
  String get tasksQuickCreateHint => 'New task name';

  @override
  String get tasksTemplatesUse => 'Use template';

  @override
  String get tasksTemplatesTitle => 'Create from template';

  @override
  String get tasksTemplatesDescription =>
      'Choose a ready-made task layout. Use the star to set your default template.';

  @override
  String get tasksTemplatesEmpty =>
      'There are no task templates in this workspace yet.';

  @override
  String get tasksTemplatesDefault => 'Your default template';

  @override
  String get tasksTemplatesApplyHint => 'Click to create a task';

  @override
  String get tasksTemplatesSetDefault => 'Set as default template';

  @override
  String get tasksTemplatesClearDefault => 'Clear default template';

  @override
  String get tasksTemplatesNew => 'New template';

  @override
  String get tasksTemplatesNewDescription =>
      'Create a new template from scratch with custom default values.';

  @override
  String get tasksTemplateForThisTask => 'Template for this task';

  @override
  String get tasksTemplateNoTemplate => 'No template';

  @override
  String tasksTemplateDefaultChip(String name) {
    return 'Template: $name';
  }

  @override
  String get tasksTemplateUsingDefault => 'Default template';

  @override
  String tasksBulkSelected(int count) {
    return 'Selected: $count';
  }

  @override
  String get tasksBulkMove => 'Move selected tasks';

  @override
  String get tasksBulkPriority => 'Change priority of selected tasks';

  @override
  String get tasksBulkDueDate => 'Set due date for selected tasks';

  @override
  String get tasksBulkClearSelection => 'Clear selection';

  @override
  String get tasksSelectLoadedGroup => 'Select only tasks in this group';

  @override
  String get tasksSelectLoadedSubtasks => 'Select only subtasks in this branch';

  @override
  String get tasksKeyboardShortcuts =>
      'Ctrl or Command+A selects loaded tasks, Escape clears the selection, and Alt+Left or Right Arrow scrolls Kanban columns.';

  @override
  String get tasksManageLabels => 'Manage labels';

  @override
  String get tasksManageCustomFields => 'Custom fields';

  @override
  String get tasksCustomFieldsEmpty => 'This project has no custom fields yet.';

  @override
  String get tasksCustomFieldText => 'Text';

  @override
  String get tasksCustomFieldNumber => 'Number';

  @override
  String get tasksCustomFieldDate => 'Date';

  @override
  String get tasksCustomFieldBoolean => 'Yes/No';

  @override
  String get tasksCustomFieldSingleSelect => 'Single select';

  @override
  String get tasksCustomFieldMultiSelect => 'Multi-select';

  @override
  String get tasksCustomFieldUser => 'User';

  @override
  String get tasksCreateCustomField => 'Add custom field';

  @override
  String get tasksEditCustomField => 'Edit custom field';

  @override
  String get tasksArchiveCustomField => 'Archive custom field';

  @override
  String tasksArchiveCustomFieldConfirm(String name) {
    return 'Archive the “$name” field? Existing values remain in history, but the field will be removed from new tasks.';
  }

  @override
  String get tasksCustomFieldName => 'Field name';

  @override
  String get tasksCustomFieldType => 'Field type';

  @override
  String get tasksCustomFieldOptions => 'Options (one per line)';

  @override
  String get tasksCustomFieldOptionsHint =>
      'For example: To do, In progress, Done';

  @override
  String get tasksCustomFieldNameRequired => 'Enter a field name.';

  @override
  String get tasksCustomFieldOptionsRequired => 'Add at least one option.';

  @override
  String get tasksCustomFieldTypeImmutable =>
      'The field type is set on creation and cannot be changed.';

  @override
  String get tasksManageMilestones => 'Milestones';

  @override
  String get tasksManageWorkflow => 'Workflow transitions';

  @override
  String get tasksWorkflowDescription =>
      'Enable the transitions users can make on the Kanban board.';

  @override
  String get tasksWorkflowEmpty =>
      'This project has no configured workflow statuses.';

  @override
  String get tasksWorkflowAllowTransition =>
      'Allowed transitions from this status';

  @override
  String get tasksWorkflowInitial => 'Initial';

  @override
  String get tasksWorkflowTerminal => 'Terminal';

  @override
  String get tasksCustomWorkflowTitle => 'Custom statuses';

  @override
  String get tasksCustomWorkflowAddStatus => 'Add status';

  @override
  String get tasksCustomWorkflowStatusName => 'Status name';

  @override
  String get tasksCustomWorkflowCategory => 'Category';

  @override
  String get tasksCustomWorkflowColor => 'Color';

  @override
  String get tasksCustomWorkflowCategoryTodo => 'To do';

  @override
  String get tasksCustomWorkflowCategoryInProgress => 'In progress';

  @override
  String get tasksCustomWorkflowCategoryDone => 'Done';

  @override
  String get tasksCustomWorkflowCategoryCancelled => 'Cancelled';

  @override
  String get tasksCustomWorkflowDefault => 'Default status';

  @override
  String get tasksCustomWorkflowWip => 'WIP limit';

  @override
  String get tasksCustomWorkflowTemplates => 'Workflow templates';

  @override
  String get tasksCustomWorkflowReplaceWarning =>
      'Applying this template will replace the current custom statuses and their order.';

  @override
  String get tasksCustomWorkflowApply => 'Apply template';

  @override
  String get tasksAutomationsTitle => 'Automations';

  @override
  String get tasksSettings => 'Task settings';

  @override
  String get tasksSettingsHubDescription =>
      'Shared project configuration and private settings in one place.';

  @override
  String get tasksAdministration => 'Administration';

  @override
  String get tasksPersonalSettings => 'My settings';

  @override
  String get tasksPersonalSettingsDescription =>
      'This note is private and stored only on this device. Your team cannot see it.';

  @override
  String get tasksPersonalNote => 'My project note';

  @override
  String get tasksPersonalNoteHint =>
      'For example: this week\'s priorities, work context, or a reminder';

  @override
  String get tasksPersonalSettingsSaved => 'Your settings have been saved.';

  @override
  String get tasksKanbanSettingsTitle => 'Kanban settings';

  @override
  String get tasksKanbanSettingsDescription =>
      'Configure the shared board layout for the whole project.';

  @override
  String get tasksKanbanLayout => 'Board layout';

  @override
  String get tasksKanbanSwimlane => 'Horizontal grouping';

  @override
  String get tasksKanbanSwimlaneNone => 'No grouping';

  @override
  String get tasksKanbanSwimlaneAssignee => 'By assignee';

  @override
  String get tasksKanbanSwimlanePriority => 'By priority';

  @override
  String get tasksKanbanSwimlaneMilestone => 'By milestone';

  @override
  String get tasksBoardGroupBy => 'Group by';

  @override
  String get tasksBoardGroupByStatus => 'Status';

  @override
  String get tasksBoardCurrentUserBadge => 'You';

  @override
  String get tasksBoardMoveToPerson => 'Move to person';

  @override
  String get tasksBoardLoadMore => 'Load more';

  @override
  String get tasksBoardUnassignedDropTitle => 'Remove every assignee?';

  @override
  String get tasksBoardUnassignedDropBody =>
      'Dropping the card here removes all assignees from the task. The task status does not change.';

  @override
  String get tasksBoardUnassignedDropConfirm => 'Remove assignees';

  @override
  String get tasksKanbanCardDensity => 'Card density';

  @override
  String get tasksKanbanDensityCompact => 'Compact';

  @override
  String get tasksKanbanDensityComfortable => 'Comfortable';

  @override
  String get tasksKanbanDensityDetailed => 'Detailed';

  @override
  String get tasksKanbanVisibleColumns => 'Visible system columns';

  @override
  String get tasksKanbanCardFields => 'Card fields';

  @override
  String get tasksKanbanFieldAssignee => 'Assignees';

  @override
  String get tasksKanbanFieldDueDate => 'Due date';

  @override
  String get tasksKanbanFieldLabels => 'Labels';

  @override
  String get tasksKanbanFieldChecklist => 'Checklist';

  @override
  String get tasksKanbanFieldSubtasks => 'Subtasks';

  @override
  String get tasksKanbanFieldTimeTracking => 'Time tracking';

  @override
  String get tasksKanbanFieldBlockers => 'Blockers';

  @override
  String get tasksKanbanFieldCoverAttachment => 'Attachment cover';

  @override
  String get tasksKanbanFieldCustomFields => 'Custom fields';

  @override
  String get tasksKanbanWipLimits => 'Work-in-progress limits (WIP)';

  @override
  String get tasksKanbanWipLimitsDescription =>
      'Leave a field empty for no limit in that column.';

  @override
  String get tasksKanbanWipUnlimited => 'No limit';

  @override
  String get tasksAutomationsDescription =>
      'Rules perform actions in response to project events.';

  @override
  String get tasksAutomationsRules => 'Project rules';

  @override
  String get tasksAutomationsEmpty => 'This project has no automations yet.';

  @override
  String get tasksAutomationsRecipes => 'Ready-made recipes';

  @override
  String get tasksAutomationsRecipesEmpty =>
      'There are no automation recipes available.';

  @override
  String get tasksAutomationsInstall => 'Install';

  @override
  String get tasksAutomationsArchive => 'Archive';

  @override
  String tasksAutomationsArchiveConfirm(String name) {
    return 'Archive the “$name” automation? It will stop immediately, but the run history will remain available.';
  }

  @override
  String tasksAutomationsRuleSummary(String trigger, int count) {
    return 'Trigger: $trigger · runs: $count';
  }

  @override
  String get tasksAutomationTriggerTaskCreated => 'task created';

  @override
  String get tasksAutomationTriggerTaskStatusChanged => 'task status changed';

  @override
  String get tasksAutomationTriggerTaskKanbanMoved => 'Kanban moved';

  @override
  String get tasksAutomationTriggerTaskDueSoon => 'due date approaching';

  @override
  String get tasksAutomationTriggerFileUploaded => 'file uploaded';

  @override
  String get tasksAutomationTriggerWikiPublished => 'Wiki published';

  @override
  String get tasksAutomationTriggerWhiteboardExported => 'whiteboard exported';

  @override
  String get tasksAutomationTriggerSchedule => 'schedule';

  @override
  String get tasksAutomationsRuns => 'Run history';

  @override
  String get tasksAutomationsRunsEmpty => 'This automation has not run yet.';

  @override
  String get tasksAutomationRunQueued => 'Queued';

  @override
  String get tasksAutomationRunRunning => 'Running';

  @override
  String get tasksAutomationRunSucceeded => 'Succeeded';

  @override
  String get tasksAutomationRunPartiallySucceeded => 'Partially succeeded';

  @override
  String get tasksAutomationRunFailed => 'Failed';

  @override
  String get tasksAutomationRunSkippedConditions => 'Skipped: conditions';

  @override
  String get tasksAutomationRunSkippedDisabled => 'Skipped: rule disabled';

  @override
  String get tasksAutomationRunSkippedLoop => 'Skipped: loop protection';

  @override
  String get tasksAutomationsDryRun => 'Simulate';

  @override
  String get tasksAutomationsDryRunDescription =>
      'The simulation does not save changes. Choose a task to check conditions and planned actions.';

  @override
  String get tasksAutomationsSelectTask => 'Task to simulate';

  @override
  String get tasksAutomationsTasksEmpty =>
      'This project has no tasks available for simulation.';

  @override
  String get tasksAutomationsDryRunMatched => 'Conditions are met';

  @override
  String get tasksAutomationsDryRunSkipped => 'Conditions are not met';

  @override
  String get tasksPresenceAnonymousUser => 'User currently viewing this board';

  @override
  String get tasksListEmpty => 'No tasks match the selected filters.';

  @override
  String get tasksListLoadMore => 'Show more tasks';

  @override
  String get tasksListSort => 'Sort';

  @override
  String get tasksListGroupBy => 'Group by';

  @override
  String get tasksListClearAllFilters => 'Clear all';

  @override
  String get tasksListStatus => 'Status';

  @override
  String get tasksListPriority => 'Priority';

  @override
  String get tasksBoardFilterAssignee => 'Person';

  @override
  String get tasksBoardFilterAllPeople => 'All people';

  @override
  String get tasksBoardAssigneeColumns => 'People columns';

  @override
  String get tasksBoardAssigneeColumnsHideEmpty => 'Hide empty columns';

  @override
  String get tasksBoardAssigneeColumnsShowAll => 'Show all columns';

  @override
  String get tasksBoardAssigneeColumnsAllHidden =>
      'All columns hidden — show them';

  @override
  String get tasksBoardActiveFilters => 'Active filters:';

  @override
  String get tasksBoardMoveBlockedByFilter =>
      'This card cannot be moved into a column whose contents are hidden by an active filter. Clear the filters and try again.';

  @override
  String get tasksListTask => 'Task';

  @override
  String get tasksListOwner => 'Owner';

  @override
  String get tasksListDueDate => 'Due date';

  @override
  String get tasksListProgress => 'Progress';

  @override
  String get tasksListActions => 'Task actions';

  @override
  String get tasksListAll => 'All';

  @override
  String get tasksListStatusBacklog => 'Backlog';

  @override
  String get tasksListStatusTodo => 'To do';

  @override
  String get tasksListStatusInProgress => 'In progress';

  @override
  String get tasksListStatusBlocked => 'Blocked';

  @override
  String get tasksListStatusDone => 'Done';

  @override
  String get tasksListStatusCancelled => 'Cancelled';

  @override
  String get tasksViewBoard => 'Board';

  @override
  String get tasksViewRecurrence => 'Recurring';

  @override
  String get tasksViewList => 'List';

  @override
  String get tasksMilestonesEmpty => 'This project has no milestones yet.';

  @override
  String get tasksCreateMilestone => 'Add milestone';

  @override
  String get tasksEditMilestone => 'Edit milestone';

  @override
  String get tasksDeleteMilestone => 'Delete milestone';

  @override
  String tasksDeleteMilestoneConfirm(String name) {
    return 'Delete the “$name” milestone? This action cannot be undone.';
  }

  @override
  String get tasksMilestoneName => 'Milestone name';

  @override
  String get tasksMilestoneDescription => 'Description';

  @override
  String get tasksMilestoneDueDate => 'Due date';

  @override
  String get tasksMilestoneNoDueDate => 'No due date';

  @override
  String get tasksMilestoneStatus => 'Status';

  @override
  String get tasksMilestoneActive => 'Active';

  @override
  String get tasksMilestoneCompleted => 'Completed';

  @override
  String get tasksMilestoneCancelled => 'Cancelled';

  @override
  String get tasksMilestoneNameRequired => 'Enter a milestone name.';

  @override
  String get tasksMilestoneTasksEmpty => 'No assigned tasks.';

  @override
  String get taskDetailsMilestone => 'Milestone';

  @override
  String get taskDetailsNoMilestone => 'Not assigned';

  @override
  String get taskDetailsRemoveMilestone => 'Remove assignment';

  @override
  String get taskDetailsMilestoneUnavailable =>
      'Could not read the assignment — tap to try again.';

  @override
  String get taskDetailsLoading => 'Loading…';

  @override
  String get tasksLabelsSettingsDescription =>
      'Labels are available to all tasks in this project.';

  @override
  String get tasksLabelsEmpty => 'This project has no active labels yet.';

  @override
  String get tasksCreateLabel => 'Add label';

  @override
  String get tasksEditLabel => 'Edit label';

  @override
  String get tasksArchiveLabel => 'Archive label';

  @override
  String tasksArchiveLabelConfirm(String name) {
    return 'Archive the “$name” label? It will not be assignable to new tasks.';
  }

  @override
  String get tasksLabelName => 'Label name';

  @override
  String get tasksLabelColor => 'Color';

  @override
  String get tasksLabelNameRequired => 'Enter a label name.';

  @override
  String get tasksArchiveAction => 'Archive';

  @override
  String tasksSelectTask(String taskCode) {
    return 'Select task $taskCode';
  }

  @override
  String tasksOpenTask(Object taskCode, Object title) {
    return 'Open task $taskCode: $title';
  }

  @override
  String tasksExpandColumn(Object name) {
    return 'Expand $name column';
  }

  @override
  String tasksDropAtEnd(String name) {
    return 'Drop task at the end of the $name column';
  }

  @override
  String get tasksPinTask => 'Pin task';

  @override
  String get tasksUnpinTask => 'Unpin task';

  @override
  String get tasksWatchTask => 'Watch task';

  @override
  String get tasksUnwatchTask => 'Stop watching task';

  @override
  String get tasksRecurrenceSeries => 'Series';

  @override
  String get tasksRecurrenceCycle => 'Cycle';

  @override
  String get tasksAssignedToMilestone => 'Assigned to milestone';

  @override
  String tasksShowSubtasks(int count) {
    return 'Show subtasks ($count)';
  }

  @override
  String get tasksHideSubtasks => 'Hide subtasks';

  @override
  String get tasksSubtasksLoading => 'Loading subtasks…';

  @override
  String get tasksSubtasksError => 'Failed to load subtasks';

  @override
  String get tasksSubtasksEmpty => 'No subtasks';

  @override
  String tasksSubtasksMore(int count) {
    return '+$count more';
  }

  @override
  String get tasksSubtasksTitle => 'Subtasks';

  @override
  String tasksSubtasksShowMoreRemaining(int count) {
    return 'Show $count more';
  }

  @override
  String get tasksAddSubtask => 'Add subtask';

  @override
  String get tasksContextMenuOpen => 'Open details';

  @override
  String get tasksContextMenuCopyCode => 'Copy task code';

  @override
  String get tasksContextMenuCopyLink => 'Copy task link';

  @override
  String get tasksContextMenuStatus => 'Change status';

  @override
  String get tasksContextMenuPriority => 'Change priority';

  @override
  String get tasksContextMenuAssignee => 'Change assignee';

  @override
  String get tasksContextMenuDueDate => 'Change due date';

  @override
  String get tasksContextMenuAddSubtask => 'Add subtask';

  @override
  String get tasksTemplatesManage => 'Manage template';

  @override
  String get tasksTemplateLineItemsHint => 'One item per line';

  @override
  String get tasksTemplatesRename => 'Rename';

  @override
  String get tasksTemplatesDeleteTitle => 'Delete template?';

  @override
  String tasksTemplatesDeleteDescription(String name) {
    return 'The “$name” template will be permanently deleted.';
  }

  @override
  String get taskDetailsArchive => 'Archive task';

  @override
  String get taskDetailsRestore => 'Restore task';

  @override
  String get taskDetailsArchiveConfirmTitle => 'Archive task?';

  @override
  String get taskDetailsArchiveConfirmMessage =>
      'The task will leave active views, but can be restored later.';

  @override
  String get taskDetailsHistory => 'History';

  @override
  String get taskDetailsCreateTemplate => 'Save as template';

  @override
  String get taskDetailsCreateTemplateTitle => 'New task template';

  @override
  String get taskDetailsCreateTemplateDescription =>
      'The current state of this task will be saved as a template in this workspace.';

  @override
  String get taskDetailsTemplateName => 'Template name';

  @override
  String get taskDetailsTemplateCreated => 'Task template created.';

  @override
  String get taskDetailsHistoryEmpty => 'There are no recorded changes yet.';

  @override
  String get taskDetailsHistoryRetry => 'Try again';

  @override
  String get taskDetailsHistoryActorSystem => 'System';

  @override
  String get taskDetailsHistoryActorAutomation => 'Automation';

  @override
  String get taskDetailsHistoryActorUser => 'User';

  @override
  String taskDetailsHistoryVersion(int version) {
    return 'v$version';
  }

  @override
  String get taskDetailsRecurrence => 'Recurrence';

  @override
  String get taskDetailsConfigureRecurrence => 'Configure';

  @override
  String get taskDetailsRecurrenceNotConfigured =>
      'This task is not recurring.';

  @override
  String taskDetailsRecurrenceEvery(int count) {
    return 'every $count';
  }

  @override
  String get taskDetailsRecurrenceActive => 'Active';

  @override
  String get taskDetailsRecurrencePaused => 'Paused';

  @override
  String get taskDetailsRecurrenceMode => 'Schedule type';

  @override
  String get taskDetailsRecurrenceModeScheduled => 'On a schedule';

  @override
  String get taskDetailsRecurrenceModeAfterCompletion => 'After completion';

  @override
  String get taskDetailsRecurrenceFrequency => 'Frequency';

  @override
  String get taskDetailsRecurrenceFrequencyDaily => 'Daily';

  @override
  String get taskDetailsRecurrenceFrequencyWeekly => 'Weekly';

  @override
  String get taskDetailsRecurrenceFrequencyMonthly => 'Monthly';

  @override
  String get taskDetailsRecurrenceInterval => 'Every N periods';

  @override
  String get taskDetailsRecurrenceTimeZone => 'IANA time zone';

  @override
  String get taskDetailsRecurrenceOccurrenceStatus => 'New occurrence status';

  @override
  String get taskDetailsRecurrenceSkipPrevious =>
      'Skip when the previous occurrence remains open';

  @override
  String get taskDetailsRecurrenceFirstOccurrence => 'First occurrence';

  @override
  String get taskDetailsRecurrenceNextOccurrence => 'Next occurrence';

  @override
  String get taskDetailsRecurrencePause => 'Pause recurrence';

  @override
  String get taskDetailsRecurrenceResume => 'Resume recurrence';

  @override
  String get taskDetailsRecurrenceCreate => 'Create recurrence';

  @override
  String get taskDetailsRecurrenceInvalid =>
      'Enter a positive interval and a valid IANA time zone, for example Europe/Warsaw.';

  @override
  String get taskDetailsRecurrenceRetry => 'Try again';

  @override
  String get taskDetailsAttachments => 'Attachments';

  @override
  String get taskDetailsAttachmentsAdd => 'Add files';

  @override
  String get taskDetailsAttachmentsEmpty => 'No attachments yet';

  @override
  String get taskDetailsAttachmentsSelect =>
      'Select files to add them to this task.';

  @override
  String get taskDetailsAttachmentsDrop => 'Drop files here to attach them';

  @override
  String get taskDetailsAttachmentsQueued => 'Waiting to upload';

  @override
  String get taskDetailsAttachmentsUploading => 'Uploading';

  @override
  String get taskDetailsAttachmentsUploaded => 'Uploaded';

  @override
  String get taskDetailsAttachmentsFailed => 'Upload failed';

  @override
  String get taskDetailsTimeTracking => 'Time tracking';

  @override
  String get taskDetailsTimeAdd => 'Add time';

  @override
  String taskDetailsTimeTotal(String duration) {
    return 'Logged: $duration';
  }

  @override
  String get taskDetailsTimeStart => 'Start timer';

  @override
  String get taskDetailsTimeStop => 'Stop timer';

  @override
  String get taskDetailsTimeNoDescription => 'No description';

  @override
  String get taskDetailsTimeSubmit => 'Submit';

  @override
  String get taskDetailsTimeMinutes => 'Duration in minutes';

  @override
  String get taskDetailsTimeDescription => 'Description';

  @override
  String get taskDetailsTimeBillable => 'Billable';

  @override
  String get taskDetailsTimeDraft => 'Draft';

  @override
  String get taskDetailsTimeSubmitted => 'Submitted';

  @override
  String get taskDetailsTimeApproved => 'Approved';

  @override
  String get taskDetailsTimeRejected => 'Rejected';

  @override
  String get tasksBoardEmpty => 'This project has no configured columns';

  @override
  String get tasksPriorityLow => 'Low priority';

  @override
  String get tasksPriorityNormal => 'Normal priority';

  @override
  String get tasksPriorityHigh => 'High priority';

  @override
  String get tasksPriorityCritical => 'Critical priority';

  @override
  String get taskDetailsClose => 'Close task details';

  @override
  String get taskDetailsArchived => 'Archived';

  @override
  String get taskDetailsProperties => 'Properties';

  @override
  String get taskDetailsAssignees => 'Assignees';

  @override
  String get taskDetailsEditAssignees => 'Edit assignees';

  @override
  String get taskDetailsAssigneesLoadError =>
      'Project members could not be loaded.';

  @override
  String get taskDetailsNoProjectMembers => 'No project members are available.';

  @override
  String get taskDetailsProjectMember => 'Project member';

  @override
  String get taskDetailsNobody => 'Unassigned';

  @override
  String get taskDetailsWatch => 'Watch task';

  @override
  String get taskDetailsStopWatching => 'Stop watching task';

  @override
  String get taskDetailsWatchers => 'Watchers';

  @override
  String get taskDetailsNoWatchers => 'No one is watching this task yet.';

  @override
  String taskDetailsWatchersMore(int count) {
    return '+$count';
  }

  @override
  String get taskDetailsPin => 'Pin task';

  @override
  String get taskDetailsUnpin => 'Unpin task';

  @override
  String get taskDetailsLabels => 'Labels';

  @override
  String get taskDetailsEditLabels => 'Edit labels';

  @override
  String get taskDetailsNoLabels => 'No labels have been assigned yet.';

  @override
  String get taskDetailsNoProjectLabels =>
      'This project has no active labels yet.';

  @override
  String get taskDetailsCustomFields => 'Custom fields';

  @override
  String get taskDetailsEditCustomFields => 'Edit custom fields';

  @override
  String get taskDetailsNoCustomFields =>
      'This project has no custom fields configured.';

  @override
  String get taskDetailsRequiredField => 'Required';

  @override
  String get taskDetailsInvalidNumber => 'Enter a valid number.';

  @override
  String get taskDetailsUserFieldUnavailable =>
      'User selection requires the project member directory.';

  @override
  String get taskDetailsDueDate => 'Due date';

  @override
  String get tasksTemplateTaskType => 'Task type';

  @override
  String get tasksTemplateSize => 'Size';

  @override
  String get tasksTemplateComplexity => 'Complexity';

  @override
  String get tasksTemplateRisk => 'Risk';

  @override
  String get tasksTemplateBusinessValue => 'Business value';

  @override
  String get tasksTemplateAddLabel => 'Add label';

  @override
  String get tasksTemplateNoLabels => 'No labels in this template';

  @override
  String get tasksTemplateAssignees => 'Default assignees';

  @override
  String get tasksTemplateCustomValues => 'Custom fields';

  @override
  String get tasksTemplateAddCustomValue => 'Add value';

  @override
  String get tasksTemplateNoCustomValues => 'No custom-field values';

  @override
  String get tasksTemplateCustomValue => 'Value';

  @override
  String get tasksTemplateMultiValueHint => 'Separate values with commas';

  @override
  String get tasksTemplatesUnsavedTitle => 'Discard unsaved changes?';

  @override
  String get tasksTemplatesUnsavedDescription =>
      'You have unsaved changes in this template form. Are you sure you want to discard them?';

  @override
  String get tasksTemplatesDiscardChanges => 'Discard changes';

  @override
  String get tasksTemplatesKeepEditing => 'Continue editing';

  @override
  String get tasksTemplatesCreateAction => 'Create template';

  @override
  String get tasksTemplatesSaveAction => 'Save changes';

  @override
  String get tasksTemplatesFormFixErrors =>
      'Please fix the highlighted form errors.';

  @override
  String get tasksTemplatesNameRequired => 'Template name is required.';

  @override
  String get tasksTemplatesNameTooLong =>
      'Template name cannot exceed 160 characters.';

  @override
  String get tasksTemplatesTitleRequired => 'Task title is required.';

  @override
  String get tasksTemplatesTitleTooLong =>
      'Task title cannot exceed 240 characters.';

  @override
  String get tasksTemplatesDescriptionTooLong =>
      'Description cannot exceed 20,000 characters.';

  @override
  String get tasksTemplatesInvalidDueDate =>
      'Due date cannot be earlier than start date.';

  @override
  String get tasksTemplatesInvalidEstimate =>
      'Estimate must be a positive integer in minutes.';

  @override
  String get tasksTemplatesInvalidPercentage =>
      'Value must be an integer between 0 and 100.';

  @override
  String get tasksTemplatesTaskTypeTooLong =>
      'Task type cannot exceed 80 characters.';

  @override
  String get tasksTemplatesChecklistItemTooLong =>
      'Checklist item cannot exceed 500 characters.';

  @override
  String get tasksTemplatesCriteriaTooLong =>
      'Acceptance criterion cannot exceed 1,000 characters.';

  @override
  String get tasksTemplatesLabelDuplicate =>
      'A label with this name already exists.';

  @override
  String get tasksTemplatesCustomFieldDuplicate =>
      'A custom field with this name already exists.';

  @override
  String get tasksTemplatesSectionBasic => 'Basic info';

  @override
  String get tasksTemplatesSectionPlanning => 'Planning';

  @override
  String get tasksTemplatesSectionResponsibility => 'Responsibility';

  @override
  String get tasksTemplatesSectionScope => 'Scope of work';

  @override
  String get tasksTemplatesSectionClassification => 'Classification';

  @override
  String get tasksTemplatesSectionMetadata => 'Metadata';

  @override
  String get tasksTemplatesAssigneesSearchHint => 'Search people...';

  @override
  String get tasksTemplatesAssigneesEmpty => 'No matching people';

  @override
  String get tasksTemplatesAssigneesLoadError =>
      'Failed to load project members';

  @override
  String get tasksTemplatesEmptyCreateCta => 'Create first template';

  @override
  String get tasksTemplatesUseTileAction => 'Use';

  @override
  String get tasksTemplatesCustomStatus => 'Custom column';

  @override
  String get tasksTemplatesSystemStatus => 'System status';

  @override
  String get tasksAutomationsCreate => 'New automation';

  @override
  String get tasksAutomationsName => 'Rule name';

  @override
  String get tasksAutomationsEdit => 'Edit automation';

  @override
  String get tasksAutomationsConditionStatus => 'Only when task status is';

  @override
  String get tasksAutomationsConditionPriority => 'Only when task priority is';

  @override
  String get tasksAutomationsConditionDueWithinDays =>
      'Only when due within (days)';

  @override
  String get tasksAutomationsConditionTitleContains =>
      'Only when title contains';

  @override
  String get tasksAutomationsConditionOptional =>
      'Leave empty to omit this condition.';

  @override
  String get tasksAutomationsConditionAssignee => 'Only when assignee is';

  @override
  String get tasksAutomationsConditionLabel => 'Only when task has label';

  @override
  String get tasksAutomationsUnknownMember =>
      'Member unavailable in this project';

  @override
  String get tasksAutomationsUnknownLabel => 'Inactive label';

  @override
  String get tasksAutomationsNoCondition => 'No status condition';

  @override
  String get tasksAutomationsTrigger => 'When this happens';

  @override
  String get tasksAutomationsAction => 'Do this';

  @override
  String get tasksAutomationsDueWithinDays => 'Due-date horizon (days)';

  @override
  String get tasksAutomationsDaysHint => 'From 0 to 365 days';

  @override
  String get tasksAutomationsSubtaskTitle => 'Subtask title';

  @override
  String get tasksAutomationsActionSetStatus => 'Set task status';

  @override
  String get tasksAutomationsActionSetPriority => 'Set task priority';

  @override
  String get tasksAutomationsActionClearDueDate => 'Clear task due date';

  @override
  String get tasksAutomationsActionSetDueDate => 'Set or clear task due date';

  @override
  String get tasksAutomationsDueDateUnset => 'No due date (clear)';

  @override
  String get tasksAutomationsClearDueDate => 'Clear selected due date';

  @override
  String get tasksAutomationsActionCreateSubtask => 'Create subtask';

  @override
  String get tasksAutomationsActionAssignTask => 'Assign task';

  @override
  String get tasksAutomationsActionAddLabel => 'Add label';

  @override
  String get tasksAutomationsActionRemoveLabel => 'Remove label';

  @override
  String get tasksAutomationsActionAssignee => 'Target assignee';

  @override
  String get tasksAutomationsActionLabel => 'Target label';

  @override
  String get tasksAutomationsActionNotifyUser => 'Send notification';

  @override
  String get tasksAutomationsNotificationRecipient => 'Notification recipient';

  @override
  String get tasksAutomationsNotificationText => 'Notification text';

  @override
  String get tasksAutomationsBuilderInvalid =>
      'Provide a name and valid automation parameters.';

  @override
  String get taskDetailsNoDueDate => 'No due date';

  @override
  String get taskDetailsNoDate => 'No date set';

  @override
  String get taskDetailsEstimate => 'Estimate';

  @override
  String get taskDetailsNoEstimate => 'No estimate';

  @override
  String taskDetailsMinutes(int count) {
    return '$count min';
  }

  @override
  String get taskDetailsDescription => 'Description';

  @override
  String get taskDetailsEditDescription => 'Edit description';

  @override
  String get tasksCollapseColumn => 'Collapse column';

  @override
  String get taskDetailsNoDescription =>
      'This task does not have a description yet.';

  @override
  String get taskDetailsChecklist => 'Checklist';

  @override
  String get taskDetailsAddChecklistItem => 'Add checklist item';

  @override
  String get taskDetailsDeleteChecklistItem => 'Delete checklist item';

  @override
  String get taskDetailsEditChecklistItem => 'Edit checklist item';

  @override
  String get taskDetailsAcceptanceCriteria => 'Acceptance criteria';

  @override
  String get taskDetailsAddAcceptanceCriterion => 'Add acceptance criterion';

  @override
  String get taskDetailsDeleteAcceptanceCriterion =>
      'Delete acceptance criterion';

  @override
  String get taskDetailsEditAcceptanceCriterion => 'Edit acceptance criterion';

  @override
  String get taskDetailsSubtasks => 'Subtasks';

  @override
  String get taskDetailsAddSubtask => 'Add subtask';

  @override
  String get taskDetailsNoSubtasks => 'There are no subtasks yet.';

  @override
  String get taskDetailsDependencies => 'Dependencies';

  @override
  String get taskDetailsAddDependency => 'Add dependency';

  @override
  String get taskDetailsDeleteDependency => 'Delete dependency';

  @override
  String get taskDetailsNoDependencies => 'This task has no dependencies yet.';

  @override
  String get taskDetailsSearchTask => 'Search task';

  @override
  String get taskDetailsDependencyType => 'Dependency type';

  @override
  String get taskDetailsDependencyKind => 'Schedule relationship';

  @override
  String get taskDetailsDependencyLagDays => 'Lag (working days)';

  @override
  String get taskDependencyKindFinishToStart => 'Finish to start';

  @override
  String get taskDependencyKindStartToStart => 'Start to start';

  @override
  String get taskDependencyKindFinishToFinish => 'Finish to finish';

  @override
  String get taskDependencyKindStartToFinish => 'Start to finish';

  @override
  String get taskDependencyBlocks => 'Blocks';

  @override
  String get taskDependencyRelated => 'Related to';

  @override
  String get taskDependencyDuplicate => 'Duplicate';

  @override
  String get taskDetailsEditBasics => 'Edit task';

  @override
  String get taskDetailsTitleField => 'Title';

  @override
  String get taskDetailsStatusField => 'Status';

  @override
  String get taskDetailsPriorityField => 'Priority';

  @override
  String get taskDetailsEditPlanning => 'Edit dates and estimate';

  @override
  String get taskDetailsStartDate => 'Start date';

  @override
  String get taskDetailsEstimateMinutes => 'Estimate in minutes';

  @override
  String get taskDetailsClearDate => 'Clear date';

  @override
  String get taskDetailsInvalidEstimate =>
      'The estimate must be a positive number of minutes.';

  @override
  String get taskDetailsInvalidDependencyLag =>
      'Lag must be between -365 and 365 days.';

  @override
  String get taskDetailsInvalidDateRange =>
      'The due date cannot be earlier than the start date.';

  @override
  String get taskStatusBacklog => 'Backlog';

  @override
  String get taskStatusTodo => 'To do';

  @override
  String get taskStatusInProgress => 'In progress';

  @override
  String get taskStatusBlocked => 'Blocked';

  @override
  String get taskStatusDone => 'Done';

  @override
  String get taskStatusCanceled => 'Canceled';

  @override
  String get myTasksFilter => 'Filter tasks';

  @override
  String get myTasksFiltersTitle => 'Task filters';

  @override
  String get myTasksFiltersSubtitle =>
      'Customize personal task filtering criteria.';

  @override
  String get projectUserHubPinnedSuccess => 'Project pinned to favorites.';

  @override
  String get projectUserHubUnpinnedSuccess =>
      'Project unpinned from favorites.';

  @override
  String get projectUserHubHiddenSuccess => 'Project hidden from sidebar.';

  @override
  String get projectUserHubUnhiddenSuccess => 'Project restored to sidebar.';

  @override
  String get myTasksStatus => 'Status';

  @override
  String get myTasksPriority => 'Priority';

  @override
  String get myTasksInvolvement => 'My involvement';

  @override
  String get myTasksAll => 'All';

  @override
  String get myTasksAny => 'Any';

  @override
  String get myTasksDueFrom => 'Due from';

  @override
  String get myTasksDueTo => 'Due to';

  @override
  String get myTasksAnyDueDate => 'Any due date';

  @override
  String get myTasksClear => 'Clear';

  @override
  String get myTasksChooseDate => 'Choose date';

  @override
  String get myTasksApply => 'Apply';

  @override
  String get myTasksInvalidDueRange =>
      'The end date cannot be earlier than the start date.';

  @override
  String get myTasksEmpty => 'You currently have no tasks that require action.';

  @override
  String get myTasksRetry => 'Try again';

  @override
  String get myTasksPriorityLow => 'Low';

  @override
  String get myTasksPriorityNormal => 'Normal';

  @override
  String get myTasksPriorityHigh => 'High';

  @override
  String get myTasksPriorityCritical => 'Critical';

  @override
  String get myTasksInvolvementAny => 'Any';

  @override
  String get myTasksInvolvementPrimaryAssignee => 'Primary assignee';

  @override
  String get myTasksInvolvementCollaborator => 'Collaborator';

  @override
  String get myTasksInvolvementAssignee => 'Assignee';

  @override
  String get myTasksInvolvementWatcher => 'Watcher';

  @override
  String get settingsSectionProfileTitle => 'Profile';

  @override
  String get settingsSectionProfileSubtitle => 'Photo and account details';

  @override
  String get settingsProfileTitle => 'Profile photo';

  @override
  String get settingsProfileSubtitle =>
      'Your photo will be visible in Workspaces and next to your tasks.';

  @override
  String get settingsProfileChooseAvatar => 'Choose photo';

  @override
  String get settingsProfileRemoveAvatar => 'Remove photo';

  @override
  String get settingsProfileAvatarHint =>
      'PNG, JPEG, WebP or GIF. Choose a clear square photo.';

  @override
  String get settingsProfileUploadInProgress => 'Saving photo…';

  @override
  String get settingsProfileRetry => 'Try again';

  @override
  String get settingsProfileAvatarTooLarge =>
      'The selected photo is larger than 5 MB.';

  @override
  String get tasksScheduleTitle => 'Project schedule';

  @override
  String get tasksScheduleDescription =>
      'Set how deadlines cascade and manage workspace-wide non-working days.';

  @override
  String get tasksScheduleMode => 'Scheduling mode';

  @override
  String get tasksScheduleManual => 'Manual';

  @override
  String get tasksSchedulePushSuccessors => 'Push successors only';

  @override
  String get tasksScheduleStrictCascade => 'Strict cascade';

  @override
  String get tasksScheduleHolidays => 'Non-working days';

  @override
  String get tasksScheduleNoHolidays => 'No non-working days defined.';

  @override
  String get tasksScheduleAddHoliday => 'Add non-working day';

  @override
  String get tasksScheduleHolidayName => 'Name of non-working day';

  @override
  String get tasksScheduleChooseHolidayDate => 'Choose date';

  @override
  String get tasksSavedViews => 'Saved views';

  @override
  String get tasksSavedViewsCreate => 'Create view';

  @override
  String get tasksSavedViewsManage => 'Manage view';

  @override
  String get tasksSavedViewsRename => 'Rename';

  @override
  String get tasksSavedViewsDelete => 'Delete view';

  @override
  String tasksSavedViewsDeleteDescription(Object name) {
    return 'Do you really want to delete the “$name” view?';
  }

  @override
  String get tasksSavedViewsName => 'View name';

  @override
  String get tasksSavedViewsLayout => 'Layout';

  @override
  String get tasksSavedViewsSort => 'Sort';

  @override
  String get tasksSavedViewsAscending => 'Ascending';

  @override
  String get tasksSavedViewsDescending => 'Descending';

  @override
  String get tasksSavedViewsGroup => 'Group';

  @override
  String get tasksSavedViewsFilters => 'Filters';

  @override
  String get tasksSavedViewsSearch => 'Search title and description';

  @override
  String get tasksSavedViewsPinnedOnly => 'Pinned tasks only';

  @override
  String get tasksSavedViewsIncludeArchived => 'Include archived';

  @override
  String get tasksSavedViewsStatuses => 'Statuses';

  @override
  String get tasksSavedViewsPriorities => 'Priorities';

  @override
  String get tasksSavedViewsColumns => 'Visible columns';

  @override
  String get tasksSavedViewsSortPosition => 'Board position';

  @override
  String get tasksSavedViewsSortUpdated => 'Last updated';

  @override
  String get tasksSavedViewsSortDueDate => 'Due date';

  @override
  String get tasksSavedViewsSortPriority => 'Priority';

  @override
  String get tasksSavedViewsSortTitle => 'Title';

  @override
  String get tasksSavedViewsGroupNone => 'No grouping';

  @override
  String get tasksSavedViewsGroupStatus => 'By status';

  @override
  String get tasksListGroupProjectWorkflow => 'Project workflow';

  @override
  String get tasksSavedViewsGroupPriority => 'By priority';

  @override
  String get tasksSavedViewsGroupAssignee => 'By assignee';

  @override
  String get tasksSavedViewsColumnKey => 'Key';

  @override
  String get tasksSavedViewsColumnTitle => 'Title';

  @override
  String get tasksSavedViewsColumnStatus => 'Status';

  @override
  String get tasksSavedViewsColumnPriority => 'Priority';

  @override
  String get tasksSavedViewsColumnAssignees => 'Assignees';

  @override
  String get tasksSavedViewsColumnStartDate => 'Start date';

  @override
  String get tasksSavedViewsColumnDueDate => 'Due date';

  @override
  String get tasksSavedViewsColumnChecklist => 'Checklist progress';

  @override
  String get tasksSavedViewsColumnUpdated => 'Last updated';

  @override
  String get tasksSavedViewsUnassigned => 'Unassigned';

  @override
  String get tasksSavedViewsAssigned => 'Assigned tasks';

  @override
  String get tasksSavedViewsDefault => 'Default view';

  @override
  String get tasksSavedViewsSaveCurrent => 'Save current view';

  @override
  String get tasksSavedViewsSaveActiveChanges => 'Save changes to view';

  @override
  String get tasksSavedViewsModified => 'Modified';

  @override
  String get tasksSavedViewsListLoading => 'Task list is still loading';

  @override
  String get tasksCapacityTitle => 'Team availability';

  @override
  String get tasksCapacityDescription =>
      'Set the workspace default daily availability and time-bound exceptions for people in this project.';

  @override
  String get tasksCapacityDefaultDaily => 'Default daily availability';

  @override
  String get tasksCapacityMinutes => 'min';

  @override
  String get tasksCapacityOverrides => 'Availability exceptions';

  @override
  String get tasksCapacityAddOverride => 'Add exception';

  @override
  String get tasksCapacityNoOverrides => 'No availability exceptions yet.';

  @override
  String get tasksCapacityUnknownMember => 'Unavailable project member';

  @override
  String get tasksCapacityMember => 'Project member';

  @override
  String get tasksCapacityStartDate => 'Start date';

  @override
  String get tasksCapacityEndDate => 'End date';

  @override
  String get tasksCapacityReason => 'Reason (optional)';

  @override
  String get tasksViewWorkload => 'Workload';

  @override
  String get tasksWorkloadTitle => 'Team workload';

  @override
  String get tasksWorkloadRange => 'Date range';

  @override
  String get tasksWorkloadTasks => 'tasks';

  @override
  String get tasksWorkloadAvailable => 'Available';

  @override
  String get tasksWorkloadRemaining => 'Remaining';

  @override
  String get tasksWorkloadOverCapacity => 'Over capacity';

  @override
  String get tasksWorkloadEmpty => 'No workload data for the selected range.';

  @override
  String get tasksViewTimeline => 'Timeline';

  @override
  String get tasksTimelineTitle => 'Project schedule';

  @override
  String get tasksTimelineRange => 'Schedule range';

  @override
  String get tasksTimelineUndated => 'Undated';

  @override
  String get tasksTimelineDependencies => 'dependencies';

  @override
  String get taskDetailsCascadePreview => 'Preview cascade';

  @override
  String get taskDetailsCascadePreviewDescription =>
      'Review affected tasks and dates before saving.';

  @override
  String get taskDetailsCascadeChanges => 'Schedule changes';

  @override
  String get taskDetailsCascadeNoChanges =>
      'The date change does not move other tasks.';

  @override
  String get taskDetailsCascadeApply => 'Apply cascade';

  @override
  String get taskDetailsCascadeCritical => 'Critical path';

  @override
  String get taskDetailsCascadePreviewFailed =>
      'Could not prepare the cascade preview.';

  @override
  String get taskDetailsCascadeApplyFailed =>
      'Could not apply the cascade. Refresh the data and try again.';

  @override
  String get taskDetailsCascadeDatesRequired =>
      'Set both a start and due date to preview the cascade.';

  @override
  String get tasksRecurrenceTitle => 'Recurring tasks';

  @override
  String get tasksRecurrenceDescription =>
      'Manage recurrence schedules and audit past occurrences in project';

  @override
  String get tasksRecurrenceTabSchedule => 'Schedule';

  @override
  String get tasksRecurrenceTabRuns => 'Run history';

  @override
  String get tasksRecurrenceActive => 'Active';

  @override
  String get tasksRecurrencePaused => 'Paused';

  @override
  String get tasksRecurrenceEmptyTitle => 'No recurring tasks in this project';

  @override
  String get tasksRecurrenceEmptyDescription =>
      'To configure recurrence, open a task and click the recurrence icon 🔄.';

  @override
  String get tasksRecurrenceRunsEmptyTitle => 'No run history';

  @override
  String get tasksRecurrenceRunsEmptyDescription =>
      'Completed and skipped task occurrences will appear here.';

  @override
  String get tasksRecurrenceRunNow => 'Run occurrence now';

  @override
  String get tasksRecurrenceRunNowSuccess => 'New task occurrence created';

  @override
  String get tasksRecurrenceEdit => 'Edit recurrence settings';

  @override
  String get tasksRecurrenceNext => 'Next';

  @override
  String get tasksRecurrenceModeScheduled => 'Scheduled';

  @override
  String get tasksRecurrenceModeAfterCompletion => 'After completion';

  @override
  String get tasksRecurrenceOutcomeCreated => 'Occurrence created';

  @override
  String get tasksRecurrenceOutcomeSkipped =>
      'Skipped (previous task still open)';

  @override
  String get tasksRecurrenceFilterOnly => 'Recurring';

  @override
  String get tasksRecurrenceDelete => 'Delete recurrence';

  @override
  String get tasksRecurrenceDeleteConfirm =>
      'Are you sure you want to delete this recurrence rule?';

  @override
  String get tasksRecurrenceDeleteSuccess => 'Recurrence deleted successfully';

  @override
  String get taskRecurrenceIntervalDaily => 'Daily';

  @override
  String taskRecurrenceIntervalDays(int interval) {
    return 'Every $interval days';
  }

  @override
  String get taskRecurrenceIntervalWeekly => 'Weekly';

  @override
  String taskRecurrenceIntervalWeeks(int interval) {
    return 'Every $interval weeks';
  }

  @override
  String get taskRecurrenceIntervalMonthly => 'Monthly';

  @override
  String taskRecurrenceIntervalMonths(int interval) {
    return 'Every $interval months';
  }

  @override
  String get taskRecurrenceHeader => 'Task recurrence';

  @override
  String get taskRecurrenceFrequencyLabel => 'Recurrence frequency';

  @override
  String get taskRecurrencePresetWorkdays => 'On workdays';

  @override
  String get taskRecurrencePresetCustom => 'Custom...';

  @override
  String get taskRecurrenceRepeatEvery => 'Repeat every:';

  @override
  String get taskRecurrenceUnitDays => 'Days';

  @override
  String get taskRecurrenceUnitWeeks => 'Weeks';

  @override
  String get taskRecurrenceUnitMonths => 'Months';

  @override
  String get taskRecurrenceScheduleLabel => 'Recurrence occurrence schedule';

  @override
  String get taskRecurrenceModeLabel => 'Recurrence mode';

  @override
  String get taskRecurrenceOccurrenceStatus => 'Initial status for new task';

  @override
  String get taskRecurrenceSkipIfPreviousOpen =>
      'Skip creation if previous task is still open';

  @override
  String get taskRecurrenceSave => 'Save schedule';

  @override
  String get taskRecurrenceSaving => 'Saving...';

  @override
  String get taskRecurrencePauseSeries => 'Pause series';

  @override
  String get taskRecurrenceResumeSeries => 'Resume series';

  @override
  String get taskRecurrenceSaveSuccess => 'Recurrence schedule saved';

  @override
  String get tasksListEditTitleTooltip => 'Edit task title';

  @override
  String get tasksListPinTooltip => 'Pin task';

  @override
  String get tasksListUnpinTooltip => 'Unpin task';

  @override
  String get tasksListWatchTooltip => 'Watch task';

  @override
  String get tasksListUnwatchTooltip => 'Stop watching task';

  @override
  String get tasksListMoreOptionsTooltip => 'More options';

  @override
  String get tasksListKeyCopiedTooltip => 'Task key copied to clipboard';

  @override
  String tasksListAddInGroupTooltip(String group) {
    return 'Add task in group: $group';
  }

  @override
  String get tasksListQuickCreateTitle => 'New task';

  @override
  String get tasksListQuickCreateHint => 'Enter new task title...';

  @override
  String get tasksListQuickCreateButton => 'Create';

  @override
  String get tasksListQuickCreateCancel => 'Cancel';

  @override
  String get tasksListCreateTitleRequired => 'A task title is required.';

  @override
  String get tasksListCreateForbidden =>
      'You do not have permission to create a task.';

  @override
  String get tasksListCreateConflict =>
      'The data changed. Refresh the list and try again.';

  @override
  String get tasksListCreateValidation => 'The task data is invalid.';

  @override
  String get tasksListCreateDuplicate =>
      'Task creation is already in progress.';

  @override
  String get tasksListCreateUnavailable => 'The task list is not ready yet.';

  @override
  String get tasksListRecurrenceSeriesBadge => 'Series';

  @override
  String get tasksListRecurrenceCycleBadge => 'Cycle';

  @override
  String get tasksListInlineCreateKeyboardHint =>
      'Press Enter to save, Esc to cancel';

  @override
  String get tasksListInlineCreateHint => 'Task name';

  @override
  String get tasksListInlineCreateButton => 'Add task';

  @override
  String get tasksListExpandGroupTooltip => 'Expand group';

  @override
  String get tasksListCollapseGroupTooltip => 'Collapse group';

  @override
  String get tasksListClearDateButton => 'Clear';

  @override
  String get tasksListCancelButton => 'Cancel';

  @override
  String get tasksListSaveButton => 'Save';

  @override
  String get tasksListChecklistTitle => 'Checklist';

  @override
  String get tasksListChecklistEmpty => 'No checklist items';

  @override
  String get tasksListChecklistAddItem => 'Add item';

  @override
  String get tasksListChecklistNewItemHint => 'Enter new item...';

  @override
  String get tasksListChecklistAddAction => 'Add checklist';

  @override
  String get tasksListDatePresetToday => 'Today';

  @override
  String get tasksListDatePresetTomorrow => 'Tomorrow';

  @override
  String get tasksListDatePresetNextWeek => 'In a week';

  @override
  String get tasksListDatePresetNextMonth => 'In a month';

  @override
  String get tasksListCustomStatusLabel => 'Custom status';

  @override
  String get tasksListCustomStatusNone => 'No custom status';

  @override
  String get tasksListLabelsSearchHint => 'Search labels...';

  @override
  String get tasksListLabelsEmpty => 'No labels';

  @override
  String get projectSettingsTitle => 'Project settings';

  @override
  String get projectSettingsTabGeneral => 'General';

  @override
  String get projectSettingsTabMembers => 'Members & access';

  @override
  String get projectSettingsTabWorkflow => 'Statuses & workflow';

  @override
  String get projectSettingsTabCustomFields => 'Custom fields';

  @override
  String get projectSettingsTabLabels => 'Labels';

  @override
  String get projectSettingsTabMilestones => 'Milestones';

  @override
  String get projectSettingsTabAutomations => 'Automations';

  @override
  String get projectSettingsNameLabel => 'Project name';

  @override
  String get projectSettingsNameHint => 'Enter project name...';

  @override
  String get projectSettingsDescriptionLabel => 'Project description';

  @override
  String get projectSettingsDescriptionHint =>
      'Enter optional project description...';

  @override
  String get projectSettingsIconAndColorLabel => 'Icon & primary color';

  @override
  String get projectSettingsVisibilityLabel => 'Project visibility';

  @override
  String get projectSettingsVisibilityShared => 'Shared';

  @override
  String get projectSettingsVisibilitySharedDesc =>
      'Visible to all members of the workspace.';

  @override
  String get projectSettingsVisibilityPrivate => 'Private';

  @override
  String get projectSettingsVisibilityPrivateDesc =>
      'Only accessible by members explicitly added to the project.';

  @override
  String get projectSettingsSaveGeneral => 'Save changes';

  @override
  String get projectSettingsGeneralSavedSuccess =>
      'Project details updated successfully.';

  @override
  String get projectSettingsDangerZoneTitle => 'Danger zone';

  @override
  String get projectSettingsArchiveProject => 'Archive project';

  @override
  String get projectSettingsArchiveProjectConfirm =>
      'Are you sure you want to archive this project? Tasks and resources will remain in history.';

  @override
  String get projectSettingsRestoreProject => 'Restore project';

  @override
  String get projectSettingsDeleteProject => 'Delete project permanently';

  @override
  String get projectSettingsDeleteProjectConfirm =>
      'Are you sure you want to permanently delete this archived project? This action cannot be undone.';

  @override
  String get projectSettingsMembersSearchHint => 'Filter project members...';

  @override
  String get projectSettingsAddMemberButton => 'Add member';

  @override
  String get projectSettingsAddMemberDialogTitle => 'Add member to project';

  @override
  String get projectSettingsSelectWorkspaceUser => 'Select user from workspace';

  @override
  String get projectSettingsSelectRole => 'Select project role';

  @override
  String get projectSettingsMemberRoleOwner => 'Owner';

  @override
  String get projectSettingsMemberRoleAdmin => 'Admin';

  @override
  String get projectSettingsMemberRoleMember => 'Member';

  @override
  String get projectSettingsMemberRoleObserver => 'Observer';

  @override
  String get projectSettingsRemoveMemberConfirm =>
      'Are you sure you want to remove this user from the project?';

  @override
  String get projectSettingsNoMembersFound => 'No project members found';

  @override
  String get projectSettingsWorkflowColumnsHeader =>
      'Board columns and task statuses';

  @override
  String get projectSettingsWorkflowAddStatus => 'Add status';

  @override
  String get projectSettingsWorkflowEditStatus => 'Edit status';

  @override
  String get projectSettingsWorkflowDeleteStatus => 'Delete status';

  @override
  String get projectSettingsWorkflowStatusName => 'Status name';

  @override
  String get projectSettingsWorkflowStatusColor => 'Color';

  @override
  String get projectSettingsWorkflowStatusCategory => 'Category';

  @override
  String get projectSettingsWorkflowWipLimit => 'Task limit (WIP)';

  @override
  String get projectSettingsWorkflowWipLimitHint => '0 = no limit';

  @override
  String get projectSettingsWorkflowTemplatesButton => 'Workflow templates';

  @override
  String get projectSettingsWorkflowApplyTemplateConfirm =>
      'Applying template will create new workflow columns. Do you want to proceed?';

  @override
  String get projectSettingsWorkflowEmptyTitle =>
      'No workflow columns configured';

  @override
  String get projectSettingsWorkflowEmptyDesc =>
      'This project uses system default task statuses or does not have custom Kanban columns yet. Define custom statuses or select a ready workflow template.';

  @override
  String get projectSettingsCustomFieldsHeader => 'Custom field definitions';

  @override
  String get projectSettingsAddCustomField => 'Add field';

  @override
  String get projectSettingsCustomFieldName => 'Field name';

  @override
  String get projectSettingsCustomFieldType => 'Field type';

  @override
  String get projectSettingsCustomFieldRequired => 'Required field';

  @override
  String get projectSettingsCustomFieldOptions => 'Options (comma-separated)';

  @override
  String get projectSettingsCustomFieldsEmpty => 'No custom fields defined';

  @override
  String get projectSettingsLabelsHeader => 'Project labels';

  @override
  String get projectSettingsAddLabel => 'Add label';

  @override
  String get projectSettingsLabelName => 'Label name';

  @override
  String get projectSettingsLabelColor => 'Label color';

  @override
  String get projectSettingsLabelsEmpty => 'No labels created';

  @override
  String get projectSettingsMilestonesHeader => 'Milestones (Project stages)';

  @override
  String get projectSettingsAddMilestone => 'New milestone';

  @override
  String get projectSettingsMilestoneName => 'Milestone name';

  @override
  String get projectSettingsMilestoneDueDate => 'Due date';

  @override
  String get projectSettingsMilestoneProgress => 'Progress';

  @override
  String get projectSettingsMilestonesEmpty => 'No milestones defined';

  @override
  String get projectSettingsAutomationsHeader => 'Task automation rules';

  @override
  String get projectSettingsAddAutomation => 'New automation';

  @override
  String get projectSettingsAutomationTrigger => 'Trigger (When)';

  @override
  String get projectSettingsAutomationAction => 'Action (Then)';

  @override
  String get projectSettingsAutomationsEmpty => 'No automations configured';

  @override
  String get projectSettingsReadOnlyNotice =>
      'You have read-only access (Member/Observer). Project settings editing is restricted.';

  @override
  String get workspaceSettingsTitle => 'Workspace settings';

  @override
  String get workspaceSettingsTabGeneral => 'General';

  @override
  String get workspaceSettingsTabMembers => 'Members & invitations';

  @override
  String get workspaceSettingsTabNotifications => 'Notifications';

  @override
  String get workspaceSettingsTabCapacity => 'Working hours & capacity';

  @override
  String get workspaceSettingsNameLabel => 'Workspace name';

  @override
  String get workspaceSettingsNameHint => 'Enter workspace name...';

  @override
  String get workspaceSettingsDescriptionLabel => 'Workspace description';

  @override
  String get workspaceSettingsDescriptionHint =>
      'Enter optional workspace description...';

  @override
  String get workspaceSettingsSaveGeneral => 'Save workspace details';

  @override
  String get workspaceSettingsSavedSuccess =>
      'Workspace details updated successfully.';

  @override
  String get workspaceSettingsArchiveWorkspace => 'Archive workspace';

  @override
  String get workspaceSettingsArchiveConfirm =>
      'Are you sure you want to archive this workspace? It will be hidden from the active list.';

  @override
  String get workspaceSettingsRestoreWorkspace => 'Restore workspace';

  @override
  String get workspaceSettingsMembersHeader => 'Active members';

  @override
  String get workspaceSettingsInviteUserButton => 'Invite user';

  @override
  String get workspaceSettingsInviteDialogTitle =>
      'Invite local user to workspace';

  @override
  String get workspaceSettingsSearchReadyHint =>
      'Type name, login, or email to search local users...';

  @override
  String get workspaceSettingsSearchReadyMinChars =>
      'Type at least 2 characters to search the local directory.';

  @override
  String get workspaceSettingsInvitationsSentHeader => 'Pending invitations';

  @override
  String get workspaceSettingsInvitationResend => 'Resend';

  @override
  String get workspaceSettingsInvitationCancel => 'Cancel';

  @override
  String get workspaceSettingsMemberRoleOwner => 'Owner';

  @override
  String get workspaceSettingsMemberRoleAdmin => 'Admin';

  @override
  String get workspaceSettingsMemberRoleMember => 'Member';

  @override
  String get workspaceSettingsMemberRoleObserver => 'Observer';

  @override
  String get workspaceSettingsRemoveMemberConfirm =>
      'Are you sure you want to remove this member from the workspace?';

  @override
  String get workspaceSettingsNotificationsChannels => 'Delivery channels';

  @override
  String get workspaceSettingsNotificationsInApp => 'In-app notifications';

  @override
  String get workspaceSettingsNotificationsEmail => 'Email notifications';

  @override
  String get workspaceSettingsNotificationsCategories =>
      'Notification categories';

  @override
  String get workspaceSettingsCategoryTasks => 'Task updates and assignments';

  @override
  String get workspaceSettingsCategoryProjects => 'Project events';

  @override
  String get workspaceSettingsCategoryWorkspace =>
      'Workspace administration & invitations';

  @override
  String get workspaceSettingsCategoryMentions => 'Chat mentions & comments';

  @override
  String get workspaceSettingsSaveNotifications =>
      'Save notification preferences';

  @override
  String get workspaceSettingsNotificationsSaved =>
      'Notification preferences updated successfully.';

  @override
  String get workspaceSettingsReadOnlyNotice =>
      'You have read-only access in this workspace. Administrative settings are restricted.';

  @override
  String get projectSettingsTabTemplates => 'Project Templates';

  @override
  String get projectSettingsTemplatesHeader => 'Project Templates';

  @override
  String get projectSettingsCreateTemplateFromProject =>
      'Save project as template';

  @override
  String get projectSettingsCreateTemplateDialogTitle =>
      'New template from project';

  @override
  String get projectSettingsTemplateNameLabel => 'Template name *';

  @override
  String get projectSettingsTemplateDescLabel =>
      'Template description (optional)';

  @override
  String get projectSettingsTemplatesEmpty =>
      'No saved templates in this workspace.';

  @override
  String get projectSettingsTemplateApplyButton =>
      'Create project from template';

  @override
  String get projectSettingsTemplateApplyDialogTitle =>
      'Create new project from template';

  @override
  String get projectSettingsTemplateApplyNewProjectName => 'New project name *';

  @override
  String get projectSettingsTemplateDeleteConfirm =>
      'Are you sure you want to delete this project template?';

  @override
  String get projectSettingsTemplateRefreshButton =>
      'Refresh template from project';

  @override
  String get projectSettingsTemplateRefreshConfirm =>
      'Are you sure you want to update the template content with the current state of this project?';

  @override
  String get projectSettingsTemplateApplySuccess =>
      'New project successfully created from template.';

  @override
  String get projectSettingsTemplateCreatedSuccess =>
      'Template successfully created from project.';

  @override
  String get projectSettingsTemplateRefreshedSuccess =>
      'Template successfully refreshed from project.';

  @override
  String get projectSettingsTemplateDeletedSuccess =>
      'Project template successfully deleted.';

  @override
  String get projectSettingsTemplateLeaveDeleteTitle =>
      'Delete Project Template';

  @override
  String get projectSettingsTemplateLeaveDeleteAction => 'Delete template';

  @override
  String get projectSettingsTemplateDetailsTitle => 'Project Template Details';

  @override
  String get projectSettingsTemplateDetailsWorkflow => 'Workflow Statuses';

  @override
  String get projectSettingsTemplateDetailsCustomFields => 'Custom Fields';

  @override
  String get projectSettingsTemplateDetailsLabels => 'Labels';

  @override
  String projectSettingsTemplateDetailsTasks(int count) {
    return 'Starter Tasks ($count)';
  }

  @override
  String get projectSettingsTemplateDetailsNoTasks =>
      'No starter tasks defined.';

  @override
  String get projectSettingsTemplateDetailsNoFields =>
      'No custom fields defined.';

  @override
  String get projectSettingsTemplateDetailsNoLabels => 'No labels defined.';

  @override
  String get projectSettingsTemplateDetailsPreviewButton => 'Details Preview';

  @override
  String get projectSettingsTemplateDesc =>
      'Manage project templates and create repeatable structures for tasks, workflows, and configurations.';

  @override
  String get projectSettingsTemplateCreateDialogDesc =>
      'The current project, along with its workflow statuses, custom fields, and starter tasks, will be saved as a reusable template.';

  @override
  String get projectSettingsTemplateApplyDialogDesc =>
      'A new project will be created based on this template with all statuses, custom fields, and tasks.';

  @override
  String projectSettingsTemplateUpdatedLabel(String date) {
    return 'Updated: $date';
  }

  @override
  String get projectUserHubTitle => 'My Project Hub';

  @override
  String get projectUserHubTabProfile => 'My Profile';

  @override
  String get projectUserHubTabPreferences => 'My Preferences';

  @override
  String get projectUserHubProfileHeader => 'Your role in this project';

  @override
  String get projectUserHubProfileDesc =>
      'Information about your membership and assigned permissions.';

  @override
  String get projectUserHubRoleOwnerDesc =>
      'Full control over the project, member management, workflow, automations and danger zone.';

  @override
  String get projectUserHubRoleAdminDesc =>
      'Manage task configuration, statuses, custom fields and project members.';

  @override
  String get projectUserHubRoleMemberDesc =>
      'Full access to creating and editing tasks, comments and delivering work.';

  @override
  String get projectUserHubRoleObserverDesc =>
      'Read-only access to board, tasks and project resources.';

  @override
  String get projectUserHubLeaveProjectTitle => 'Leave Project';

  @override
  String get projectUserHubLeaveProjectSharedDesc =>
      'You are a member of this workspace. After leaving explicit membership, you will retain access to the project as a shared workspace project.';

  @override
  String get projectUserHubLeaveProjectPrivateDesc =>
      'Leaving will revoke your direct access to this private project.';

  @override
  String get projectUserHubLeaveProjectButton => 'Leave this project';

  @override
  String get projectUserHubLeaveConfirmTitle =>
      'Are you sure you want to leave this project?';

  @override
  String get projectUserHubLeaveConfirmContent =>
      'Your explicit membership will be revoked. In a private project you will lose access.';

  @override
  String get projectUserHubLeaveConfirmAction => 'Yes, leave project';

  @override
  String get projectUserHubPreferencesHeader => 'Project Personalization';

  @override
  String get projectUserHubPreferencesDesc =>
      'Customize how this project appears on your account.';

  @override
  String get projectUserHubPinLabel => 'Pin to favorites';

  @override
  String get projectUserHubPinDesc =>
      'The project will be displayed at the very top of the project tree.';

  @override
  String get projectUserHubHideLabel => 'Hide project from sidebar menu';

  @override
  String get projectUserHubHideDesc =>
      'The project will not be visible in the sidebar list (you can still search for it).';

  @override
  String get projectUserHubPreferenceSaved =>
      'Project preferences updated successfully.';

  @override
  String get projectUserHubLeaveSharedSuccessNotice =>
      'Left explicit project membership. As a workspace member you still have access to this project.';

  @override
  String get projectUserHubLeavePrivateSuccessNotice =>
      'Successfully left the project.';

  @override
  String get tasksListClearValue => 'Clear';

  @override
  String get tasksListCustomStatus => 'Custom status';

  @override
  String get tasksListMilestone => 'Milestone';

  @override
  String get tasksListNoDueDate => 'No due date';

  @override
  String get tasksListDefaultColor => 'Default color';

  @override
  String get tasksListNoIcon => 'No icon';

  @override
  String get tasksListMoveUp => 'Move up';

  @override
  String get tasksListMoveDown => 'Move down';

  @override
  String get tasksListRemoveOption => 'Remove option';

  @override
  String get tasksListOptionNameHint => 'Option name (e.g. High, Urgent)...';

  @override
  String get tasksListAddOptionButton => 'Add';

  @override
  String get tasksListCollaborators => 'Collaborators';

  @override
  String get tasksListWatchers => 'Watchers';

  @override
  String get tasksListCreated => 'Created';

  @override
  String get tasksListTaskType => 'Type';

  @override
  String get tasksListSize => 'Size';

  @override
  String get tasksListComplexity => 'Complexity';

  @override
  String get tasksListRisk => 'Risk';

  @override
  String get tasksListBusinessValue => 'Value';

  @override
  String get tasksListEstimatedMinutes => 'Estimate';

  @override
  String get tasksListActualMinutes => 'Actual time';

  @override
  String tasksListResizeColumnTooltip(String name) {
    return 'Resize column: $name';
  }

  @override
  String get tasksListColumnsTitle => 'Customize columns';

  @override
  String get tasksListColumnsSubtitle =>
      'Manage column visibility and order in the list';

  @override
  String get tasksListColumnsSearchHint => 'Search columns...';

  @override
  String get tasksListColumnsRequiredBadge => 'Required';

  @override
  String get tasksListColumnsRequiredTooltip =>
      'This column is required by the project administrator';

  @override
  String get tasksListColumnsDisabledBadge => 'Locked';

  @override
  String get tasksListColumnsDisabledTooltip =>
      'Disabled by the project administrator';

  @override
  String get tasksListColumnsResetButton => 'Restore defaults';

  @override
  String get tasksListColumnsResetSuccess => 'Default column layout restored';

  @override
  String get tasksListColumnsSaveAsViewButton => 'Save as new view';

  @override
  String get tasksListColumnsDoneButton => 'Done';

  @override
  String get tasksListMySettingsButton => 'My settings';

  @override
  String get tasksListAdminPanelButton => 'Admin panel';

  @override
  String get tasksListColumnsScopeUser => 'My settings';

  @override
  String get tasksListColumnsScopeProject => 'Project defaults (Admin)';

  @override
  String get tasksListSaveProjectDefaults => 'Save as project defaults';

  @override
  String get tasksListProjectDefaultsSaved =>
      'Project default columns updated successfully';

  @override
  String get tasksListManageWorkflowButton => 'Manage workflow & statuses...';

  @override
  String get tasksListManageCustomFieldsButton => 'Project custom fields...';

  @override
  String get tasksListSortAscending => 'Sort ascending';

  @override
  String get tasksListSortDescending => 'Sort descending';

  @override
  String get tasksListSortClear => 'Clear sorting';

  @override
  String get tasksListSavingPreferences => 'Saving preferences...';

  @override
  String get tasksListPreferencesConflict =>
      'View settings were changed in another session. Your change has not been saved.';

  @override
  String get tasksViewPreferencesLoadFailed =>
      'Your view settings could not be loaded. Columns and sorting may be out of date.';

  @override
  String get tasksViewErrorRetry => 'Retry';

  @override
  String get tasksViewErrorRefresh => 'Refresh';

  @override
  String get tasksViewErrorDismissTooltip => 'Dismiss message';

  @override
  String tasksViewErrorTraceId(String traceId) {
    return 'Error id: $traceId';
  }

  @override
  String get tasksListSaveViewDialogTitle => 'New saved view';

  @override
  String get tasksListSaveViewDialogHint => 'View name...';

  @override
  String get tasksListDragToReorderTooltip => 'Hold and drag to reorder';

  @override
  String get tasksListTaskCopySuffix => '(copy)';

  @override
  String get storageMyFiles => 'My files';

  @override
  String get storageSharedWithMe => 'Shared with me';

  @override
  String get storageRecent => 'Recent';

  @override
  String get storageFilterActiveLabel => 'Active filter:';

  @override
  String get storageFilterAll => 'All';

  @override
  String get storageFilterClear => 'Clear';

  @override
  String get storageFilterDateMonth => 'Last 30 days';

  @override
  String get storageFilterDateSection => 'Date added';

  @override
  String get storageFilterDateToday => 'Today';

  @override
  String get storageFilterDateWeek => 'Last 7 days';

  @override
  String get storageFilterMenuLabel => 'Filters';

  @override
  String get storageFilterStatusCompleted => 'Ready';

  @override
  String get storageFilterStatusFailed => 'Failed';

  @override
  String get storageFilterStatusNone => 'Not analysed';

  @override
  String get storageFilterStatusProcessing => 'Processing';

  @override
  String get storageFilterStatusQueued => 'Queued';

  @override
  String get storageFilterStatusSection => 'Analysis status';

  @override
  String get storageFilterTypeSection => 'File type';

  @override
  String get storageFavorites => 'Favorites';

  @override
  String get storageTrash => 'Trash';

  @override
  String get storageNewFolder => 'New folder';

  @override
  String get storageUploadFiles => 'Upload files';

  @override
  String get storageSearchHint => 'Search files and folders...';

  @override
  String get storageAllFiles => 'All files';

  @override
  String get storageSortNameAsc => 'Name (A-Z)';

  @override
  String get storageSortNameDesc => 'Name (Z-A)';

  @override
  String get storageSortDateDesc => 'Newest';

  @override
  String get storageSortDateAsc => 'Oldest';

  @override
  String get storageSortSizeDesc => 'Largest';

  @override
  String get storageSortSizeAsc => 'Smallest';

  @override
  String storageSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items selected',
      one: '1 item selected',
    );
    return '$_temp0';
  }

  @override
  String get storageDownloadZip => 'Download ZIP';

  @override
  String get storageDeleteSelected => 'Delete selected';

  @override
  String get storageRestoreSelected => 'Restore';

  @override
  String get storageRestoreConfirmTitle => 'Restore file?';

  @override
  String get storageRestoreConfirmMessage =>
      'The file will be restored from the trash.';

  @override
  String get storageRestoreSuccess => 'File restored.';

  @override
  String get storageClearSelection => 'Clear selection';

  @override
  String get storageEmptyTitle => 'Directory is empty';

  @override
  String get storageEmptySubtitle => 'No files or folders in this view.';

  @override
  String get storageUploadQueueTitle => 'Upload queue';

  @override
  String get storageUploadSuccess => 'File uploaded successfully';

  @override
  String get storageUploadFailed => 'Failed to upload file';

  @override
  String get storageDetailsTitle => 'File details';

  @override
  String get storagePreviewTitle => 'File preview';

  @override
  String get storageFileSize => 'Size';

  @override
  String get storageFileCreatedAt => 'Created';

  @override
  String get storageFileUpdatedAt => 'Updated';

  @override
  String get storageFileVersion => 'Version';

  @override
  String get storageCreateFolderDialogTitle => 'Create new folder';

  @override
  String get storageCreateFolderDialogHint => 'Folder name...';

  @override
  String get storageCreateFolderButton => 'Create';

  @override
  String get storageCreateFolderSuccess => 'Folder created successfully.';

  @override
  String get storageCreateFolderConflict =>
      'A folder with this name already exists.';

  @override
  String get storageCreateFolderValidation => 'Enter a valid folder name.';

  @override
  String get storageRenameFolderDialogTitle => 'Rename folder';

  @override
  String get storageRenameFolderButton => 'Rename';

  @override
  String get storageRenameFolderSuccess => 'Folder renamed successfully.';

  @override
  String get storageRenameFolderNotFound => 'The folder no longer exists.';

  @override
  String get storageRenameFolderConflict =>
      'A folder with this name already exists.';

  @override
  String get storageRenameFolderValidation => 'Enter a valid folder name.';

  @override
  String get storageDeleteConfirmTitle => 'Confirm deletion';

  @override
  String get storageDeleteConfirmMessage =>
      'Are you sure you want to move selected items to trash?';

  @override
  String get storageDeleteSuccess => 'Item moved to trash.';

  @override
  String get storageMutationNotFound => 'The folder no longer exists.';

  @override
  String get storageMutationConflict =>
      'A folder with this name already exists.';

  @override
  String get storageMutationValidation => 'Enter a valid folder name.';

  @override
  String storageShareTitle(String fileName) {
    return 'Share: $fileName';
  }

  @override
  String get storageActiveShares => 'Active shares';

  @override
  String get storageNoActiveShares => 'No active shares besides owner.';

  @override
  String storageShareUserLabel(String identifier) {
    return 'User: $identifier';
  }

  @override
  String storageShareWorkspaceLabel(String identifier) {
    return 'Workspace: $identifier';
  }

  @override
  String storageShareProjectLabel(String identifier) {
    return 'Project: $identifier';
  }

  @override
  String get storageUserInputHint => 'User ID / email';

  @override
  String get storageUserSearchWorkspaceRequired =>
      'Local directory search is available for workspace or project files.';

  @override
  String get storageUserSearchNoResults =>
      'No users with an active local account were found.';

  @override
  String get storageViewDensityLabel => 'Row density';

  @override
  String get storageViewDensityComfortable => 'Comfortable';

  @override
  String get storageViewDensityCompact => 'Compact';

  @override
  String get storageAddShareButton => 'Add';

  @override
  String get storagePublicLinkTitle => 'Public link';

  @override
  String get storagePublicLinkSubtitle =>
      'Allows access without login with selected permissions';

  @override
  String get storagePublicSharePageTitle => 'Shared file';

  @override
  String get storagePublicSharePageDescription =>
      'Download the file using a secure link. If the owner set a password, enter it below.';

  @override
  String get storagePublicShareUnavailable =>
      'Public sharing is temporarily unavailable.';

  @override
  String get storagePublicSharePassword => 'Password';

  @override
  String get storagePublicSharePasswordOptional =>
      'Leave empty if the link does not require a password';

  @override
  String get storageShowPassword => 'Show password';

  @override
  String get storageHidePassword => 'Hide password';

  @override
  String get storagePublicShareDownload => 'Download file';

  @override
  String storagePublicShareDownloadStarted(String fileName) {
    return 'Download started: $fileName';
  }

  @override
  String get storagePublicLinkNoExpiry => 'No expiration date';

  @override
  String storagePublicLinkExpires(String date) {
    return 'Expires $date';
  }

  @override
  String get storageCopyPublicLink => 'Copy public link';

  @override
  String get storageGenerateLinkButton => 'Generate link';

  @override
  String get storageLinkCopied => 'Link copied to clipboard';

  @override
  String get storageAccessReader => 'Viewer';

  @override
  String get storageAccessCommenter => 'Commenter';

  @override
  String get storageAccessEditor => 'Editor';

  @override
  String get storageAccessOwner => 'Owner';

  @override
  String get storageShareAction => 'Share';

  @override
  String storageShareAuthor(Object identifier) {
    return 'Author: $identifier';
  }

  @override
  String storageShareExpiresAt(Object date) {
    return 'Expires: $date';
  }

  @override
  String get storageShareLinkSection => 'Public link';

  @override
  String get storageSharePeopleSection => 'People';

  @override
  String get storageShareProjectSection => 'Project';

  @override
  String get storageShareWorkspaceSection => 'Workspace';

  @override
  String get storageAddFavoriteAction => 'Add to favorites';

  @override
  String get storageRemoveFavoriteAction => 'Remove from favorites';

  @override
  String get storageDownloadAction => 'Download';

  @override
  String storageDownloadSuccess(String fileName) {
    return 'Downloaded file: $fileName to Downloads';
  }

  @override
  String get storageDeleteAction => 'Delete';

  @override
  String get storageOpenOfficeAction => 'Open document';

  @override
  String get storageOfficeEditMode => 'Edit mode';

  @override
  String get storageOfficeViewMode => 'View only';

  @override
  String get storageOfficeActive => 'OnlyOffice Document Server session active';

  @override
  String get storageOfficeHostLoading => 'Loading the OnlyOffice editor…';

  @override
  String get storageOfficeHostFailure =>
      'The embedded OnlyOffice editor could not be loaded.';

  @override
  String get storageOfficeDownloadFailure =>
      'The document download could not be prepared. Check the OnlyOffice connection and try again.';

  @override
  String get storageOfficeCloseUnconfirmed =>
      'The editor did not confirm a safe close. Closing anyway may lose unsaved changes. Close the document?';

  @override
  String get storageOfficeCloseUnsavedBody =>
      'The document has changes that have not been confirmed by a save yet. Closing the editor may lose them.';

  @override
  String get storageOfficeCloseUnsavedTitle => 'Close without saving?';

  @override
  String get storageOfficeConnected => 'Connected';

  @override
  String get storageOfficeConnecting => 'Connecting…';

  @override
  String get storageOfficeSavedChanges => 'Saved';

  @override
  String get storageOfficeUnsavedChanges => 'Unsaved changes';

  @override
  String get storageOfficeSessionFailure =>
      'The OnlyOffice editor session could not be started';

  @override
  String get storageCloseOffice => 'Close document';

  @override
  String get storageOfficePrintAction => 'Print';

  @override
  String get storageOfficePrinting => 'Preparing print…';

  @override
  String get storageOfficePrintFailure => 'Failed to print document.';

  @override
  String storageOfficeDownloadSuccess(String fileName) {
    return 'Downloaded file: $fileName to Downloads';
  }

  @override
  String get storageOfficeSaveCopyAction => 'Save copy in Storage';

  @override
  String get storageOfficeSavingCopy => 'Saving copy in Storage…';

  @override
  String storageOfficeSaveCopySuccess(String fileName) {
    return 'Saved copy ”$fileName” in Storage';
  }

  @override
  String get storageOfficeSaveCopyFailure =>
      'Failed to save document copy in Storage.';

  @override
  String get storageSortTooltip => 'Sort';

  @override
  String get storageListViewTooltip => 'List view';

  @override
  String get storageGridViewTooltip => 'Grid view';

  @override
  String get storageMoreOptionsTooltip => 'More options';

  @override
  String get storageMoveAction => 'Move to…';

  @override
  String get storageMoveConfirm => 'Move here';

  @override
  String get storageMoveDialogNoSubfolders =>
      'No subfolders. Pick this folder or go up.';

  @override
  String get storageMoveDialogRoot => 'Root folder';

  @override
  String get storageMoveDialogTitle => 'Move to folder';

  @override
  String get storageClearCompletedTooltip => 'Clear completed';

  @override
  String get storageCancelUploadTooltip => 'Cancel upload';

  @override
  String get storageRetryUploadTooltip => 'Retry transfer';

  @override
  String get storageErrorTitle => 'Something went wrong';

  @override
  String get storageForbiddenTitle => 'Access denied';

  @override
  String storagePreviewError(String message) {
    return 'Preview error: $message';
  }

  @override
  String get storageImageLoadError => 'The image could not be loaded.';

  @override
  String get storageOfficeDescription =>
      'Office document ready to open in OnlyOffice.';

  @override
  String get storagePdfDescription =>
      'The PDF can be opened in the secure system preview.';

  @override
  String get storageVideoDescription =>
      'The video can be played in the system preview.';

  @override
  String get storageAudioDescription =>
      'The recording can be played in the system preview.';

  @override
  String get storageTextDescription => 'Text file or source code.';

  @override
  String get storageUnsupportedDescription =>
      'A direct preview is not available for this format.';

  @override
  String get storageOpenPdfPreview => 'Open PDF preview';

  @override
  String get storagePlayVideo => 'Play video';

  @override
  String get storagePlayAudio => 'Play audio';

  @override
  String get storageOpenText => 'Open content';

  @override
  String get storageRemoveShareTooltip => 'Remove permission';

  @override
  String storageShareAccessLabel(String access) {
    return 'Access: $access';
  }

  @override
  String get storageFolderTitle => 'Folder';

  @override
  String get storageWorkspaceFilesTitle => 'Workspace files';

  @override
  String get storageProjectFilesTitle => 'Project files';

  @override
  String get storageAttachmentsTitle => 'Attachments';

  @override
  String storageFilesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String get storageFoldersTitle => 'Folders';

  @override
  String storageItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get storageVersionsTitle => 'Version history';

  @override
  String get storageVersionsEmpty => 'No saved file versions.';

  @override
  String storageVersionPreviewBadge(Object version) {
    return 'Version $version — preview';
  }

  @override
  String get storageVersionPreviewAction => 'Preview version';

  @override
  String get storageVersionPreviewOfficeUnavailable =>
      'A historical version of an office document cannot be previewed in this session. Download the file to see it.';

  @override
  String storageVersionLabel(int version) {
    return 'Version $version';
  }

  @override
  String get storageUploadFileTooLarge =>
      'The file exceeds the 20 MB size limit.';

  @override
  String get storageUploadCancelledByUser => 'Cancelled by user.';

  @override
  String get storageUploadCancelled => 'Upload cancelled.';

  @override
  String get storageUploadUnsupportedScope =>
      'Files cannot be uploaded in this view.';

  @override
  String get storageUploadTicketReservationFailed =>
      'Could not reserve an upload ticket.';

  @override
  String get storageUploadTransferFailed => 'Data transfer failed.';

  @override
  String get storageUploadCompletionFailed =>
      'Could not complete the file upload.';

  @override
  String get storageUploadPlacementFailed =>
      'The file was uploaded but could not be added to the selected folder.';

  @override
  String get storagePartialDeleteFailed => 'Some items could not be deleted.';

  @override
  String get storagePartialMoveFailed => 'Some items could not be moved.';

  @override
  String get storageDeleteSelectedFailed =>
      'Could not delete the selected items.';

  @override
  String get globalChatEmptyTitle => 'No conversations';

  @override
  String get globalChatEmptyMessage =>
      'Your active conversations will appear here.';

  @override
  String get globalChatLoadFailureTitle => 'Could not load conversations';

  @override
  String globalChatConversationFallback(String identifier) {
    return 'Conversation $identifier';
  }

  @override
  String get globalChatGroupProject => 'Project';

  @override
  String get globalChatGroupWorkspace => 'Workspace';

  @override
  String get globalChatGroupPrivate => 'Private';

  @override
  String get globalChatBackToConversations => 'Back to conversations';

  @override
  String get globalChatOpenFullView => 'Open full view';

  @override
  String get globalChatComposerHint => 'Write a message…';

  @override
  String get globalChatSendMessage => 'Send message';

  @override
  String get globalChatDeletedMessage => 'Message deleted';

  @override
  String get chatComposerPlainMode => 'Plain text';

  @override
  String get chatComposerRichMode => 'Rich text';

  @override
  String chatComposerReplyTo(String message) {
    return 'Replying to: $message';
  }

  @override
  String get chatComposerCancelReply => 'Cancel reply';

  @override
  String get chatComposerReplyAction => 'Reply';

  @override
  String get chatThreadTitle => 'Thread';

  @override
  String get chatThreadClose => 'Close thread';

  @override
  String get chatThreadOpen => 'Open thread';

  @override
  String get globalNotificationsTitle => 'Notifications';

  @override
  String get globalNotificationsEmptyTitle => 'No new notifications';

  @override
  String get globalNotificationsEmptyMessage =>
      'Information about your work will appear here.';

  @override
  String get globalNotificationsSessionRequired =>
      'Your session needs refreshing';

  @override
  String get globalNotificationsAccessDenied => 'Access denied';

  @override
  String get globalNotificationsLoadFailureTitle =>
      'Could not load notifications';

  @override
  String get globalNotificationsTransportUnavailableTitle =>
      'Notifications are not available yet';

  @override
  String get globalNotificationsTransportUnavailableMessage =>
      'The standalone notifications transport is not configured yet.';

  @override
  String get globalNotificationsMarkAllRead => 'Mark all as read';

  @override
  String get globalNotificationsRefreshFailed =>
      'Could not refresh notifications';

  @override
  String get globalNotificationsConnecting =>
      'Connecting to live notifications…';

  @override
  String get globalNotificationsReconnecting =>
      'Reconnecting to live notifications…';

  @override
  String get globalNotificationsOffline => 'Live notifications are offline';

  @override
  String get globalChatConnecting => 'Connecting to live chat…';

  @override
  String get globalChatReconnecting => 'Reconnecting to live chat…';

  @override
  String get globalChatOffline => 'Live chat is offline';

  @override
  String get globalNotificationsGroups => 'Groups';

  @override
  String get globalNotificationsItems => 'Items';

  @override
  String get globalNotificationsUnreadOnly => 'Unread only';

  @override
  String get globalNotificationsAllCategories => 'All categories';

  @override
  String get globalNotificationsLoadMore => 'Load more';

  @override
  String get globalNotificationsGroupActions => 'Group actions';

  @override
  String get globalNotificationsMarkGroupRead => 'Mark group as read';

  @override
  String get globalNotificationsPin => 'Pin';

  @override
  String get globalNotificationsUnpin => 'Unpin';

  @override
  String get globalNotificationsArchive => 'Archive';

  @override
  String get globalNotificationsReply => 'Reply';

  @override
  String get globalNotificationsReplyTitle => 'Reply in Chat';

  @override
  String get globalNotificationsReplyHint => 'Write a reply…';

  @override
  String get globalNotificationsReplyPlainMode => 'Text';

  @override
  String get globalNotificationsReplyRichMode => 'Rich text';

  @override
  String get globalNotificationsReplySend => 'Send reply';

  @override
  String get globalNotificationsReplyAccessRevoked =>
      'Access to this conversation was removed. Your reply draft was cleared.';

  @override
  String get globalNotificationsReplyFailed => 'Could not send reply';

  @override
  String globalNotificationsUnreadCount(int count) {
    return '$count unread notifications';
  }

  @override
  String get notificationPreferencesOpen => 'Notification preferences';

  @override
  String get notificationPreferencesTitle => 'Notification preferences';

  @override
  String get notificationPreferencesDeliveryTitle => 'Email delivery';

  @override
  String get notificationPreferencesDeliveryDescription =>
      'Choose how each type of notification is delivered to your email.';

  @override
  String get notificationPreferencesDeliveryMode => 'Delivery mode';

  @override
  String get notificationPreferencesCategoryInvitation => 'Invitations';

  @override
  String get notificationPreferencesCategoryMembership => 'Membership';

  @override
  String get notificationPreferencesCategoryWorkspace => 'Workspaces';

  @override
  String get notificationPreferencesCategoryProject => 'Projects';

  @override
  String get notificationPreferencesCategoryTask => 'Tasks';

  @override
  String get notificationPreferencesCategoryComment => 'Comments';

  @override
  String get notificationPreferencesCategoryChat => 'Chat';

  @override
  String get notificationPreferencesCategoryStorage => 'Files';

  @override
  String get notificationPreferencesCategorySystem => 'System';

  @override
  String get notificationPreferencesModeNone => 'Do not send';

  @override
  String get notificationPreferencesModeImmediate => 'Immediately';

  @override
  String get notificationPreferencesModeDailyDigest => 'Daily digest';

  @override
  String get notificationPreferencesModeDigest => 'Digest';

  @override
  String get notificationPreferencesStorageTitle => 'File notifications';

  @override
  String get notificationPreferencesStorageDescription =>
      'Choose delivery for events related to files you can access.';

  @override
  String get notificationPreferencesStorageMode => 'File delivery mode';

  @override
  String get notificationPreferencesStorageInherited =>
      'The current setting is inherited from the default policy.';

  @override
  String get notificationPreferencesStorageImmediate => 'Immediately';

  @override
  String get notificationPreferencesStorageDigest => 'Digest';

  @override
  String get notificationPreferencesStorageMentionsOnly => 'Mentions only';

  @override
  String get notificationPreferencesStorageDisabled => 'Disabled';

  @override
  String get notificationPreferencesDigestTitle => 'Digest preview';

  @override
  String get notificationPreferencesDigestDescription =>
      'A read-only summary of currently visible notification groups.';

  @override
  String get notificationPreferencesDigestEmpty =>
      'There are no notifications in the digest.';

  @override
  String notificationPreferencesDigestSummary(int count) {
    return 'Digest contains $count notification groups';
  }

  @override
  String notificationPreferencesDigestCount(int count) {
    return '$count notifications';
  }

  @override
  String get chatNotificationSettingsGlobalTitle => 'Chat notifications';

  @override
  String get chatNotificationSettingsGlobalDescription =>
      'Choose the channels used to deliver notifications from global chat.';

  @override
  String get chatNotificationSettingsChannelInApp => 'In app';

  @override
  String get chatNotificationSettingsChannelEmail => 'Email';

  @override
  String get chatNotificationSettingsChannelPush => 'Push';

  @override
  String get chatNotificationSettingsChannelDigest => 'Digest';

  @override
  String get chatConversationNotificationSettingsOpen =>
      'Conversation notification settings';

  @override
  String get chatConversationNotificationSettingsTitle =>
      'Conversation notifications';

  @override
  String get chatConversationNotificationSettingsDescription =>
      'Set how you receive notifications from this conversation only.';

  @override
  String get chatConversationNotificationModeLabel => 'Notification mode';

  @override
  String get chatConversationNotificationModeAll => 'All messages';

  @override
  String get chatConversationNotificationModeMentionsOnly => 'Mentions only';

  @override
  String get chatConversationNotificationModeMuted => 'Muted';

  @override
  String get chatConversationNotificationModeHighOnly => 'High priority only';

  @override
  String get resourceChatFileAction => 'File chat';

  @override
  String get resourceChatFileDescription =>
      'Open the authorized conversation for this shared file.';

  @override
  String resourceChatFileHeader(
    String fileName,
    String ownerUserId,
    String accessLevel,
  ) {
    return 'File: $fileName · Owner: $ownerUserId · Access: $accessLevel';
  }

  @override
  String get chatDiscussionTitle => 'Named discussion';

  @override
  String get chatDiscussionNameLabel => 'Discussion name';

  @override
  String get chatDiscussionOpen => 'Open discussion';

  @override
  String chatDiscussionReady(String name) {
    return 'Discussion ready: $name';
  }

  @override
  String get chatMessageActionsOpen => 'Message actions';

  @override
  String get chatMessageEdit => 'Edit';

  @override
  String get chatMessageDelete => 'Delete';

  @override
  String get chatMessageRevisions => 'Edit history';

  @override
  String get chatMessageEditTitle => 'Edit message';

  @override
  String get chatMessageEditLabel => 'Message text';

  @override
  String get chatMessageCancel => 'Cancel';

  @override
  String get chatMessageSave => 'Save changes';

  @override
  String get chatMessageClose => 'Close';

  @override
  String get chatMessageRevisionsTitle => 'Edit history';

  @override
  String get chatMessageRevisionsEmpty =>
      'This message has no earlier versions.';

  @override
  String chatMessageRevisionVersion(int version, int newVersion) {
    return 'Version $version → $newVersion';
  }

  @override
  String get chatThreadLoadOlder => 'Load older replies';

  @override
  String get chatAttachmentsEmpty => 'No attachments selected';

  @override
  String get chatAttachmentsAdd => 'Add files';

  @override
  String get chatAttachmentRemove => 'Remove attachment';

  @override
  String get chatAttachmentStatusProcessing => 'Processing';

  @override
  String get chatAttachmentStatusScanning => 'Scanning';

  @override
  String get chatAttachmentStatusClean => 'Clean';

  @override
  String get chatAttachmentStatusInfected => 'Infected';

  @override
  String get chatAttachmentStatusFailed => 'Failed';

  @override
  String get meProfileTitle => 'My Profile';

  @override
  String get meProfileSubtitle =>
      'Manage your profile, password and active sessions';

  @override
  String get mePersonalSectionTitle => 'Profile Information';

  @override
  String get mePersonalSectionSubtitle =>
      'Your basic identification details in the system';

  @override
  String get meLoginLabel => 'Username';

  @override
  String get meEmailLabel => 'Email address';

  @override
  String get meDisplayNameLabel => 'Display name';

  @override
  String get meDisplayNameHint => 'Enter display name';

  @override
  String get meDisplayNameRequired => 'Display name cannot be empty';

  @override
  String get meRolesLabel => 'Assigned roles';

  @override
  String get mePermissionsLabel => 'Permissions';

  @override
  String get meSaveProfileButton => 'Save profile';

  @override
  String get meProfileUpdateSuccess => 'Profile updated successfully.';

  @override
  String get mePasswordSectionTitle => 'Change Password';

  @override
  String get mePasswordSectionSubtitle =>
      'Minimum 15 characters required for account security';

  @override
  String get meCurrentPasswordLabel => 'Current password';

  @override
  String get meCurrentPasswordHint => 'Enter current password';

  @override
  String get meCurrentPasswordRequired => 'Current password is required';

  @override
  String get meNewPasswordLabel => 'New password';

  @override
  String get meNewPasswordHint => 'At least 15 characters';

  @override
  String get meNewPasswordMinLengthError =>
      'New password must be at least 15 characters long';

  @override
  String get meNewPasswordMaxLengthError =>
      'New password can be at most 128 characters long';

  @override
  String get meNewPasswordSameAsCurrentError =>
      'New password must differ from current password';

  @override
  String get meConfirmPasswordLabel => 'Confirm new password';

  @override
  String get meConfirmPasswordHint => 'Repeat new password';

  @override
  String get mePasswordsDoNotMatchError => 'Passwords do not match';

  @override
  String get meChangePasswordButton => 'Change password';

  @override
  String get mePasswordChangeSuccess => 'Password changed successfully.';

  @override
  String get meSessionsSectionTitle => 'Active Device Sessions';

  @override
  String get meSessionsSectionSubtitle =>
      'Signed in devices and browsers linked to your account';

  @override
  String get meSessionCurrentBadge => 'Current session';

  @override
  String meSessionCreated(String date) {
    return 'Created: $date';
  }

  @override
  String meSessionLastSeen(String date) {
    return 'Last seen: $date';
  }

  @override
  String get meSessionRevokeButton => 'Revoke session';

  @override
  String get meSessionRevokeConfirmTitle => 'Revoke this session?';

  @override
  String meSessionRevokeConfirmMessage(String device) {
    return 'The session on \"$device\" will be revoked and signed out.';
  }

  @override
  String get meSessionRevokeConfirmAction => 'Revoke session';

  @override
  String get meSessionRevokedSuccess => 'Session revoked successfully.';

  @override
  String get meSessionsEmpty => 'No active sessions to display.';

  @override
  String get meSessionsRefreshTooltip => 'Refresh sessions';

  @override
  String get meProfileRetry => 'Try again';

  @override
  String get meUnavailableTitle => 'Profile unavailable';

  @override
  String get meUnavailableMessage => 'Profile service is not configured yet.';

  @override
  String get projectsTreeMenuTooltip => 'Project menu';

  @override
  String get projectsTreeDragHandle => 'Reorder project';

  @override
  String get projectsTreeLoadFailureFallback => 'Could not load projects.';

  @override
  String get projectsTreeHiddenSectionTitle => 'Hidden';

  @override
  String get projectsTreeArchiveSectionTitle => 'Archive';

  @override
  String get projectsTreeArchiveSectionNote =>
      'This section lists the projects archived in this workspace, loaded from the server.';

  @override
  String get projectsMenuOpen => 'Open';

  @override
  String get projectsMenuPin => 'Pin';

  @override
  String get projectsMenuUnpin => 'Unpin';

  @override
  String get projectsMenuHide => 'Hide for me';

  @override
  String get projectsMenuUnhide => 'Show in tree';

  @override
  String get projectsMenuRenameAppearance => 'Change name and appearance';

  @override
  String get projectsMenuSettings => 'Settings';

  @override
  String get projectsMenuCreateTemplate => 'Create template from project';

  @override
  String get projectsMenuArchive => 'Archive';

  @override
  String get projectsMenuRestore => 'Restore to tree';

  @override
  String get projectsMenuDeletePermanently => 'Delete permanently';

  @override
  String get projectsMenuMoveToWorkspace => 'Move to workspace';

  @override
  String get projectsMenuLeaveProject => 'Leave project';

  @override
  String get projectsMenuBusy => 'Saving project changes.';

  @override
  String get projectsMenuReasonNoTransport =>
      'Project mutation port is not available in this composition.';

  @override
  String get projectsMenuReasonManagePermission =>
      'Requires project owner or admin role.';

  @override
  String get projectsMenuReasonUnknownCapabilities =>
      'The backend did not return this project\'s permissions. Refresh the project list.';

  @override
  String get projectsMenuReasonDeletePermission =>
      'Permanent deletion requires the project owner role.';

  @override
  String get projectsMenuReasonNoSettings =>
      'The project settings center is not available here.';

  @override
  String get projectsMenuReasonNoTemplatePort =>
      'The project template repository is not available here.';

  @override
  String get projectsMenuReasonTransferContract =>
      'The cross-workspace project transfer contract has not been delivered yet.';

  @override
  String get projectsMenuReasonLeaveRule =>
      'The last-owner rule is not yet available in the contract.';

  @override
  String projectsNoticePinned(String projectName) {
    return 'Project $projectName pinned to the top of the tree.';
  }

  @override
  String projectsNoticeUnpinned(String projectName) {
    return 'Project $projectName unpinned.';
  }

  @override
  String projectsNoticeHidden(String projectName) {
    return 'Project $projectName hidden in the tree.';
  }

  @override
  String projectsNoticeUnhidden(String projectName) {
    return 'Project $projectName is visible again.';
  }

  @override
  String projectsNoticeArchived(String projectName) {
    return 'Project $projectName archived.';
  }

  @override
  String projectsNoticeRestored(String projectName) {
    return 'Project $projectName restored to the tree.';
  }

  @override
  String projectsNoticeDeleted(String projectName) {
    return 'Project $projectName permanently deleted.';
  }

  @override
  String projectsNoticeLeft(String projectName) {
    return 'You left project $projectName.';
  }

  @override
  String projectsNoticeTemplateCreated(String projectName) {
    return 'Template of project $projectName created.';
  }

  @override
  String get projectsNoticeUndo => 'Undo';

  @override
  String get projectsFailureTitle => 'Project operation failed';

  @override
  String get projectsFailureOperationPin => 'Pinning the project';

  @override
  String get projectsFailureOperationHide => 'Hiding the project';

  @override
  String get projectsFailureOperationPreference =>
      'Changing project preferences';

  @override
  String get projectsFailureOperationReorder => 'Saving project order';

  @override
  String get projectsFailureOperationArchive => 'Archiving the project';

  @override
  String get projectsFailureOperationRestore => 'Restoring the project';

  @override
  String get projectsFailureOperationDelete =>
      'Deleting the project permanently';

  @override
  String get projectsFailureOperationTemplate =>
      'Creating the project template';

  @override
  String get projectsFailureOperationLeave => 'Leaving the project';

  @override
  String get projectsFailureOperationSections =>
      'Loading the Hidden and Archive sections';

  @override
  String get projectsFailureRolledBack =>
      'The operation was rolled back — the previous state was restored.';

  @override
  String get projectsFailureKindUnavailable =>
      'The project mutation port is not available in this composition.';

  @override
  String get projectsFailureKindUnauthorized =>
      'Your session expired. Sign in again.';

  @override
  String get projectsFailureKindForbidden =>
      'You do not have permission to perform this operation.';

  @override
  String get projectsFailureKindNotFound =>
      'The project does not exist or is no longer available.';

  @override
  String get projectsFailureKindConflict =>
      'The project state changed on the server (conflict).';

  @override
  String get projectsFailureKindValidation =>
      'The server rejected the operation payload.';

  @override
  String get projectsFailureKindRateLimited =>
      'Too many requests. Try again in a moment.';

  @override
  String get projectsFailureKindServer =>
      'Server error. The change was not saved.';

  @override
  String get projectsFailureKindTransport =>
      'No connection to the server. The change was not saved.';

  @override
  String get projectsFailureKindInvalidIntent =>
      'The operation was incomplete and was not sent.';

  @override
  String get projectsFailureKindUnknown =>
      'An unknown operation error occurred.';

  @override
  String projectsFailureCode(String code) {
    return 'Code: $code';
  }

  @override
  String projectsFailureTraceId(String traceId) {
    return 'Diagnostic id: $traceId';
  }

  @override
  String projectsFailureBackendMessage(String message) {
    return 'Server: $message';
  }

  @override
  String get projectsFailureRetry => 'Retry';

  @override
  String get projectsFailureDismiss => 'Dismiss message';

  @override
  String get projectsArchiveConfirmTitle => 'Archive this project?';

  @override
  String projectsArchiveConfirmBody(String projectName) {
    return 'Project $projectName will disappear from the project tree. Its history, tasks and files are preserved, and the project can be restored from the Archive section.';
  }

  @override
  String get projectsArchiveConfirmAction => 'Archive project';

  @override
  String get projectsDialogCancel => 'Cancel';

  @override
  String get projectsDeleteConfirmTitle => 'Delete this project permanently?';

  @override
  String projectsDeleteConfirmBody(String projectName) {
    return 'Permanently deleting project $projectName is irreversible and removes all of its data. To confirm, type the project name.';
  }

  @override
  String get projectsDeleteConfirmFieldLabel => 'Project name';

  @override
  String get projectsDeleteConfirmMismatch =>
      'The name does not match the project name.';

  @override
  String get projectsDeleteConfirmAction => 'Delete permanently';

  @override
  String get projectsLeaveConfirmTitle => 'Leave this project?';

  @override
  String projectsLeaveConfirmBody(String projectName) {
    return 'Leaving project $projectName revokes your explicit project membership. A Shared project may remain visible, because access is inherited from the workspace.';
  }

  @override
  String get projectsLeaveConfirmAction => 'Leave project';

  @override
  String get projectsTemplateDialogTitle => 'Create template from project';

  @override
  String projectsTemplateDialogBody(String projectName) {
    return 'The template of $projectName will capture the current project configuration: workflow, labels, custom fields and active tasks.';
  }

  @override
  String get projectsTemplateNameLabel => 'Template name';

  @override
  String get projectsTemplateNameRequired => 'Enter the template name.';

  @override
  String get projectsTemplateCreateAction => 'Create template';

  @override
  String get storageOfficeSavingChanges => 'Waiting for the server…';

  @override
  String get storageOfficeSaveUnconfirmed => 'Save not confirmed';

  @override
  String get storageOfficeCloseAwaitingTitle =>
      'Wait for the save to be confirmed?';

  @override
  String get storageOfficeCloseAwaitingBody =>
      'The editor has no local changes left, but the backend has not confirmed a new version yet. Closing now may show the list with the previous version of the file.';

  @override
  String get storageOfficeCloseWaitForSave => 'Wait';

  @override
  String get chatInboxTitle => 'Messages';

  @override
  String get chatInboxSearchHint => 'Search conversations';

  @override
  String get chatInboxSearchClear => 'Clear search';

  @override
  String get chatInboxFilterAll => 'All';

  @override
  String get chatInboxFilterUnread => 'Unread';

  @override
  String get chatInboxFilterDirect => 'Direct';

  @override
  String get chatInboxFilterGroups => 'Groups';

  @override
  String get chatInboxFilterChannels => 'Channels';

  @override
  String get chatInboxFilterArchived => 'Archived';

  @override
  String get chatInboxNoResultsTitle => 'No conversations in this view';

  @override
  String get chatInboxNoResultsMessage =>
      'Change the filter or clear the search.';

  @override
  String chatInboxDraftPreview(String text) {
    return 'Draft: $text';
  }

  @override
  String get chatInboxAttachmentPreview => 'Attachment';

  @override
  String chatInboxUnreadSemantics(int count) {
    return '$count unread messages';
  }

  @override
  String get chatInboxMutedSemantics => 'Conversation muted';

  @override
  String get chatInboxTimeNow => 'now';

  @override
  String chatInboxTimeMinutes(int count) {
    return '$count min';
  }

  @override
  String chatInboxTimeHours(int count) {
    return '$count h';
  }

  @override
  String chatInboxTimeDays(int count) {
    return '$count d';
  }

  @override
  String get chatInboxLoadMoreFailed => 'Could not load more conversations';

  @override
  String get chatInboxRetry => 'Try again';

  @override
  String get chatInboxLoadMore => 'Load more';

  @override
  String get chatCreationTitle => 'New conversation';

  @override
  String get chatCreationStepChooser => 'Choose the conversation type';

  @override
  String get chatCreationStepParticipants => 'Choose people';

  @override
  String get chatCreationStepDetails => 'Conversation details';

  @override
  String get chatCreationKindDirect => 'Direct message';

  @override
  String get chatCreationKindDirectHint => 'A conversation with one person.';

  @override
  String get chatCreationKindGroup => 'Group';

  @override
  String get chatCreationKindGroupHint => 'Between two and fifty people.';

  @override
  String get chatCreationKindChannel => 'Channel';

  @override
  String get chatCreationKindChannelHint =>
      'A channel where permitted members post.';

  @override
  String get chatCreationKindBroadcast => 'Announcements';

  @override
  String get chatCreationKindBroadcastHint =>
      'Only the owner and moderators can post.';

  @override
  String get chatCreationSearchHint => 'Search people by login or name';

  @override
  String get chatCreationSearchTooShort => 'Type at least two characters.';

  @override
  String get chatCreationSearchEmpty => 'No people match this phrase.';

  @override
  String get chatCreationSelectedTitle => 'Selected people';

  @override
  String get chatCreationSelectedNone => 'No people selected yet.';

  @override
  String get chatCreationRemoveParticipant => 'Remove person';

  @override
  String get chatCreationExistingDirect =>
      'You already have a conversation with this person';

  @override
  String get chatCreationNameLabel => 'Conversation name';

  @override
  String get chatCreationNameHint => 'Name visible to members';

  @override
  String get chatCreationPostingPermission => 'Who can post';

  @override
  String get chatCreationPostingEveryone => 'All members';

  @override
  String get chatCreationPostingAdminsOnly => 'Only the owner and moderators';

  @override
  String get chatCreationNext => 'Next';

  @override
  String get chatCreationBack => 'Back';

  @override
  String get chatCreationSubmit => 'Create conversation';

  @override
  String get chatCreationCancel => 'Cancel';

  @override
  String get chatCreationExistingReused =>
      'Opening the existing conversation with this person.';

  @override
  String get chatCreationFailureTitle => 'Could not create the conversation';

  @override
  String get chatCreationRetry => 'Try again';

  @override
  String get chatCreationValidationNameRequired =>
      'Provide the conversation name.';

  @override
  String get chatCreationValidationNameTooLong =>
      'The conversation name can have at most 240 characters.';

  @override
  String get chatCreationValidationDirectOne =>
      'A direct message requires exactly one person.';

  @override
  String get chatCreationValidationGroupRequired =>
      'Select at least one person.';

  @override
  String get chatCreationValidationGroupTooMany =>
      'A group can have at most fifty people.';

  @override
  String get chatCreationNewAction => 'New conversation';

  @override
  String get chatMessageActionsTooltip => 'Message actions';

  @override
  String get chatMessageReact => 'Add reaction';

  @override
  String get chatMessageForward => 'Forward';

  @override
  String get chatMessagePin => 'Pin';

  @override
  String get chatMessageUnpin => 'Unpin';

  @override
  String get chatMessageBookmark => 'Save to bookmarks';

  @override
  String get chatMessageRemoveBookmark => 'Remove from bookmarks';

  @override
  String get chatMessageForwardTitle => 'Forward message';

  @override
  String get chatMessageForwardEmpty => 'No other conversations to forward to.';

  @override
  String get chatMessageEditSave => 'Save';

  @override
  String get chatMessageDeleteConfirmTitle => 'Delete this message?';

  @override
  String get chatMessageDeleteConfirmBody =>
      'The message will disappear for every member of the conversation.';

  @override
  String get chatMessageDeleteConfirm => 'Delete message';

  @override
  String get chatMessageReactionsEmpty => 'No reactions';

  @override
  String chatMembersTitle(String name) {
    return 'Conversation members $name';
  }

  @override
  String get chatMembersFallbackName => 'Conversation';

  @override
  String get chatMembersLoadFailureTitle => 'Could not load members';

  @override
  String get chatMembersYou => 'you';

  @override
  String get chatMembersActions => 'Member actions';

  @override
  String get chatMembersRemove => 'Remove from conversation';

  @override
  String get chatMembersLeave => 'Leave conversation';

  @override
  String get chatMembersAdd => 'Add people';

  @override
  String get chatMembersAddSearchHint => 'Search by name or login';

  @override
  String get chatMembersAddEmpty => 'No matching accounts';

  @override
  String get chatMembersAddExisting => 'Already in conversation';

  @override
  String get chatMembersAddSelected => 'Selected';

  @override
  String chatMembersAddFreeSlots(int count) {
    return '$count free';
  }

  @override
  String get chatMembersAddCapacityFull => 'The group is full';

  @override
  String get chatMembersAddConfirm => 'Add';

  @override
  String get chatMembersAddCancel => 'Cancel';

  @override
  String get chatMemberRoleOwner => 'Owner';

  @override
  String get chatMemberRoleModerator => 'Moderator';

  @override
  String get chatMemberRoleMember => 'Member';

  @override
  String get chatMemberRoleObserver => 'Read only';

  @override
  String get chatSearchHint => 'Search messages';

  @override
  String get chatSearchClose => 'Close search';

  @override
  String get chatSearchPromptTitle => 'Search messages';

  @override
  String get chatSearchPromptMessage =>
      'Type a phrase to search the conversations you can access.';

  @override
  String chatSearchTooShort(int count) {
    return 'Type at least $count characters';
  }

  @override
  String chatSearchTooShortMessage(int count) {
    return 'The phrase must have at least $count characters.';
  }

  @override
  String get chatSearchFailureTitle => 'Search failed';

  @override
  String get chatSearchRateLimitedTitle => 'Too many requests';

  @override
  String get chatSearchEmptyTitle => 'No results';

  @override
  String get chatSearchEmptyMessage => 'No messages match this phrase.';

  @override
  String get chatSearchOpen => 'Search messages';

  @override
  String get chatPinnedTitle => 'Pinned messages';

  @override
  String get chatPinnedEmpty => 'No pinned messages.';

  @override
  String chatPinnedAt(String at) {
    return 'Pinned: $at';
  }

  @override
  String get chatPinnedOpen => 'Show pinned';

  @override
  String get chatBookmarksTitle => 'Saved messages';

  @override
  String get chatBookmarksEmpty => 'No saved messages.';

  @override
  String get chatBookmarksOpen => 'Show saved';

  @override
  String get chatMuteMute => 'Mute conversation';

  @override
  String get chatMuteUnmute => 'Unmute conversation';

  @override
  String get chatStatusTitle => 'Your status';

  @override
  String get chatStatusEmoji => 'Emoji';

  @override
  String get chatStatusText => 'Status';

  @override
  String get chatStatusDnd => 'Do not disturb';

  @override
  String get chatStatusSave => 'Save status';

  @override
  String get chatStatusClear => 'Clear status';

  @override
  String get chatStatusOpen => 'Set status';

  @override
  String get chatStatusPeerView => 'Peer status';

  @override
  String get chatStatusExpiry => 'Expiry';

  @override
  String get chatStatusExpiryNone => 'No expiry';

  @override
  String get chatStatusExpiryHour => 'In 1 hour';

  @override
  String get chatStatusExpiryDay => 'In 24 hours';

  @override
  String get chatStatusLoadFailure => 'Could not load the status';

  @override
  String get chatRichTextCopy => 'Copy code';

  @override
  String get chatRichTextCopied => 'Copied';

  @override
  String get chatRichTextShowMore => 'Show all';

  @override
  String get chatRichTextShowLess => 'Collapse';

  @override
  String get chatRichTextUnsupported => '[unsupported content]';

  @override
  String get chatTypingIndicator => 'typing…';

  @override
  String get chatArchiveAction => 'Archive conversation';

  @override
  String get chatRestoreAction => 'Restore conversation';

  @override
  String get chatArchiveConfirmTitle => 'Archive this conversation?';

  @override
  String get chatArchiveConfirmBody =>
      'The conversation will leave the list and move to the archive.';

  @override
  String get chatArchiveFailure => 'Could not change the archive state.';

  @override
  String get chatPanelSectionChats => 'Chats';

  @override
  String get chatPanelSectionFiles => 'Files';

  @override
  String get chatPanelSectionTasks => 'Tasks / Kanban';

  @override
  String get chatPanelSectionSaved => 'Saved';

  @override
  String get chatPanelSectionProfile => 'Profile';

  @override
  String get chatPanelSectionSettings => 'Settings';

  @override
  String get chatPanelGlobalSettingsTitle => 'Messenger settings';

  @override
  String get chatPanelSelectConversationTitle => 'Select a conversation';

  @override
  String get chatPanelSelectConversationMessage =>
      'Pick a conversation from the list to see its history and write a message.';

  @override
  String get chatPanelListUnavailable =>
      'The conversation list is unavailable in this composition.';

  @override
  String get chatPanelResizeHandle => 'Resize the panel';

  @override
  String get chatPanelPinAction => 'Pin the panel width';

  @override
  String get chatPanelUnpinAction => 'Unpin the panel';

  @override
  String get chatInboxDraftLabel => 'Draft';

  @override
  String get chatComposeTitle => 'New chat';

  @override
  String get chatComposeNewGroup => 'New group';

  @override
  String get chatComposeNewChannel => 'New channel';

  @override
  String get chatComposeNewBroadcast => 'New announcements';

  @override
  String get chatComposeRecentTitle => 'Recent contacts';

  @override
  String get chatComposeSearchPrompt =>
      'Type at least two characters to find a person.';

  @override
  String get chatFilesNotConnectedTitle =>
      'File conversations will appear here';

  @override
  String get chatFilesNotConnectedMessage =>
      'This tab will show conversations created on a file once someone adds you or mentions you. The Files integration is not connected yet.';

  @override
  String get chatTasksNotConnectedTitle =>
      'Task conversations will appear here';

  @override
  String get chatTasksNotConnectedMessage =>
      'This tab will show conversations created on a task once someone adds you or mentions you. The Kanban integration is not connected yet.';

  @override
  String get chatContextPreviewOpen => 'UI preview';

  @override
  String get chatContextPreviewLabel => 'UI preview — sample data';

  @override
  String get chatContextSourceUnavailable => 'Source unavailable';

  @override
  String get chatSavedUnavailable =>
      'Saved messages are unavailable in this composition.';

  @override
  String get chatSavedMessageFallback => 'Saved message';

  @override
  String get chatInboxEmptyPageMore =>
      'This page has no conversations available to you, but more pages exist.';
}
