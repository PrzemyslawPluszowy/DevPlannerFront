import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// No description provided for @storageNewDocument.
  ///
  /// In en, this message translates to:
  /// **'New document'**
  String get storageNewDocument;

  /// No description provided for @storageCreateDocumentDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Create document'**
  String get storageCreateDocumentDialogTitle;

  /// No description provided for @storageDocumentName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get storageDocumentName;

  /// No description provided for @storageDocumentNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example: meeting notes'**
  String get storageDocumentNameHint;

  /// No description provided for @storageDocumentFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get storageDocumentFormat;

  /// No description provided for @storageCreateDocumentButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get storageCreateDocumentButton;

  /// No description provided for @storageCreateDocumentSuccess.
  ///
  /// In en, this message translates to:
  /// **'The document was created.'**
  String get storageCreateDocumentSuccess;

  /// No description provided for @storageFormatTxt.
  ///
  /// In en, this message translates to:
  /// **'Text file (.txt)'**
  String get storageFormatTxt;

  /// No description provided for @storageFormatOdt.
  ///
  /// In en, this message translates to:
  /// **'OpenDocument text (.odt)'**
  String get storageFormatOdt;

  /// No description provided for @storageFormatOds.
  ///
  /// In en, this message translates to:
  /// **'OpenDocument spreadsheet (.ods)'**
  String get storageFormatOds;

  /// No description provided for @storageFormatOdp.
  ///
  /// In en, this message translates to:
  /// **'OpenDocument presentation (.odp)'**
  String get storageFormatOdp;

  /// No description provided for @storageFormatDocx.
  ///
  /// In en, this message translates to:
  /// **'Word document (.docx)'**
  String get storageFormatDocx;

  /// No description provided for @storageFormatXlsx.
  ///
  /// In en, this message translates to:
  /// **'Excel spreadsheet (.xlsx)'**
  String get storageFormatXlsx;

  /// No description provided for @storageFormatPptx.
  ///
  /// In en, this message translates to:
  /// **'PowerPoint presentation (.pptx)'**
  String get storageFormatPptx;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Ready Custom'**
  String get appName;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access modules.'**
  String get loginSubtitle;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// No description provided for @loginUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter username.'**
  String get loginUsernameRequired;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter password.'**
  String get loginPasswordRequired;

  /// No description provided for @loginRememberCredentials.
  ///
  /// In en, this message translates to:
  /// **'Remember username and password'**
  String get loginRememberCredentials;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get loginSubmitting;

  /// No description provided for @globalUserFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get globalUserFallback;

  /// No description provided for @globalModuleDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get globalModuleDashboard;

  /// No description provided for @globalModuleInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get globalModuleInventory;

  /// No description provided for @globalModuleBhp.
  ///
  /// In en, this message translates to:
  /// **'BHP'**
  String get globalModuleBhp;

  /// No description provided for @globalModuleWorkspaces.
  ///
  /// In en, this message translates to:
  /// **'Workspaces'**
  String get globalModuleWorkspaces;

  /// No description provided for @appShellChangelogTitle.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get appShellChangelogTitle;

  /// No description provided for @appShellChangelogLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the changelog.'**
  String get appShellChangelogLoadError;

  /// No description provided for @appShellChangelogEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no changelog entries.'**
  String get appShellChangelogEmpty;

  /// No description provided for @appShellChangelogShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all entries'**
  String get appShellChangelogShowAll;

  /// No description provided for @appShellBrandName.
  ///
  /// In en, this message translates to:
  /// **'Ready Next'**
  String get appShellBrandName;

  /// No description provided for @appShellCommandPaletteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Global search is coming soon'**
  String get appShellCommandPaletteUnavailable;

  /// No description provided for @appModalDismiss.
  ///
  /// In en, this message translates to:
  /// **'Close dialog'**
  String get appModalDismiss;

  /// No description provided for @workspacesMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspaces'**
  String get workspacesMenuTitle;

  /// No description provided for @workspacesMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Spaces, projects and collaboration'**
  String get workspacesMenuSubtitle;

  /// No description provided for @workspacesSectionOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get workspacesSectionOverview;

  /// No description provided for @workspacesSectionProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get workspacesSectionProjects;

  /// No description provided for @workspacesNoProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects'**
  String get workspacesNoProjects;

  /// No description provided for @workspacesMenuCreateProject.
  ///
  /// In en, this message translates to:
  /// **'Create first project'**
  String get workspacesMenuCreateProject;

  /// No description provided for @workspacesMenuAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get workspacesMenuAdd;

  /// No description provided for @workspacesTaskList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get workspacesTaskList;

  /// No description provided for @workspacesMenuCreateTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get workspacesMenuCreateTask;

  /// No description provided for @workspacesTaskKanban.
  ///
  /// In en, this message translates to:
  /// **'Kanban'**
  String get workspacesTaskKanban;

  /// No description provided for @workspacesTaskAutomations.
  ///
  /// In en, this message translates to:
  /// **'Automations'**
  String get workspacesTaskAutomations;

  /// No description provided for @workspacesProjectCorkboard.
  ///
  /// In en, this message translates to:
  /// **'Corkboard'**
  String get workspacesProjectCorkboard;

  /// No description provided for @workspaceShellTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspaceShellTitle;

  /// No description provided for @workspaceShellSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspaceShellSubtitle;

  /// No description provided for @workspaceShellCollapseMenu.
  ///
  /// In en, this message translates to:
  /// **'Collapse menu'**
  String get workspaceShellCollapseMenu;

  /// No description provided for @workspaceShellExpandMenu.
  ///
  /// In en, this message translates to:
  /// **'Expand menu'**
  String get workspaceShellExpandMenu;

  /// No description provided for @workspaceShellNavigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspaceShellNavigationTitle;

  /// No description provided for @workspaceShellDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get workspaceShellDashboard;

  /// No description provided for @workspaceShellProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get workspaceShellProjects;

  /// No description provided for @workspaceShellProjectsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The project list will appear here'**
  String get workspaceShellProjectsPlaceholder;

  /// No description provided for @workspaceShellDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Dashboard skeleton — data and widgets will be connected after the contracts are agreed.'**
  String get workspaceShellDashboardDescription;

  /// No description provided for @workspaceShellWidgetProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get workspaceShellWidgetProjects;

  /// No description provided for @workspaceShellWidgetTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get workspaceShellWidgetTasks;

  /// No description provided for @workspaceShellWidgetActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get workspaceShellWidgetActivity;

  /// No description provided for @workspaceShellBackToDirectory.
  ///
  /// In en, this message translates to:
  /// **'Back to workspace directory'**
  String get workspaceShellBackToDirectory;

  /// No description provided for @workspacesSectionTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get workspacesSectionTasks;

  /// No description provided for @workspacesSectionFiles.
  ///
  /// In en, this message translates to:
  /// **'Files and documents'**
  String get workspacesSectionFiles;

  /// No description provided for @workspacesSectionChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get workspacesSectionChat;

  /// No description provided for @workspacesSectionWhiteboards.
  ///
  /// In en, this message translates to:
  /// **'Whiteboards'**
  String get workspacesSectionWhiteboards;

  /// No description provided for @workspacesSectionWiki.
  ///
  /// In en, this message translates to:
  /// **'Wiki'**
  String get workspacesSectionWiki;

  /// No description provided for @workspacesSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get workspacesSectionNotifications;

  /// No description provided for @workspacesSectionPending.
  ///
  /// In en, this message translates to:
  /// **'The section structure is ready. The next screen will be connected to the Workspaces backend contract.'**
  String get workspacesSectionPending;

  /// No description provided for @workspacesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You do not have a workspace yet'**
  String get workspacesEmptyTitle;

  /// No description provided for @workspacesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Workspaces available for your account will appear here.'**
  String get workspacesEmptyMessage;

  /// No description provided for @workspacesErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load workspaces'**
  String get workspacesErrorTitle;

  /// No description provided for @workspacesForbiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'No access to workspaces'**
  String get workspacesForbiddenTitle;

  /// No description provided for @workspacesSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your session requires sign-in again'**
  String get workspacesSessionTitle;

  /// No description provided for @workspacesRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get workspacesRefresh;

  /// No description provided for @workspacesRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get workspacesRetry;

  /// No description provided for @workspacesCreatePrivateWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Create private workspace'**
  String get workspacesCreatePrivateWorkspace;

  /// No description provided for @workspacesCreateWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Create workspace'**
  String get workspacesCreateWorkspace;

  /// No description provided for @workspacesCreateWorkspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'New workspace'**
  String get workspacesCreateWorkspaceTitle;

  /// No description provided for @workspacesCreateWorkspaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a name and create a new workspace.'**
  String get workspacesCreateWorkspaceSubtitle;

  /// No description provided for @workspacesEditWorkspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit workspace'**
  String get workspacesEditWorkspaceTitle;

  /// No description provided for @workspacesEditWorkspaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a new name and customize the appearance of the workspace.'**
  String get workspacesEditWorkspaceSubtitle;

  /// No description provided for @workspacesNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace name'**
  String get workspacesNameFieldLabel;

  /// No description provided for @workspacesNameFieldPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Marketing, Project A, Finance'**
  String get workspacesNameFieldPlaceholder;

  /// No description provided for @workspacesNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get workspacesNameRequiredError;

  /// No description provided for @workspacesPickIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Pick icon'**
  String get workspacesPickIconLabel;

  /// No description provided for @workspacesAccentColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get workspacesAccentColorLabel;

  /// No description provided for @workspacesCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get workspacesCancelButton;

  /// No description provided for @workspacesCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get workspacesCreateButton;

  /// No description provided for @workspacesSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get workspacesSaveButton;

  /// No description provided for @workspacesCreateProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get workspacesCreateProjectTitle;

  /// No description provided for @workspacesCreateProjectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a project and organize team work.'**
  String get workspacesCreateProjectSubtitle;

  /// No description provided for @workspacesProjectNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Project name *'**
  String get workspacesProjectNameLabel;

  /// No description provided for @workspacesProjectNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mobile App Development, ERP Deployment...'**
  String get workspacesProjectNameHint;

  /// No description provided for @workspacesProjectNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a project name'**
  String get workspacesProjectNameRequired;

  /// No description provided for @workspacesProjectDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Project description (optional)'**
  String get workspacesProjectDescriptionLabel;

  /// No description provided for @workspacesProjectDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Project goal, scope or objectives...'**
  String get workspacesProjectDescriptionHint;

  /// No description provided for @workspacesProjectVisibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Project visibility'**
  String get workspacesProjectVisibilityLabel;

  /// No description provided for @workspacesProjectVisibilityShared.
  ///
  /// In en, this message translates to:
  /// **'Shared with all workspace members'**
  String get workspacesProjectVisibilityShared;

  /// No description provided for @workspacesProjectVisibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get workspacesProjectVisibilityPrivate;

  /// No description provided for @workspacesCreateWhiteboardTitle.
  ///
  /// In en, this message translates to:
  /// **'New whiteboard'**
  String get workspacesCreateWhiteboardTitle;

  /// No description provided for @workspacesCreateWhiteboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a whiteboard for sketching, diagrams and brainstorming.'**
  String get workspacesCreateWhiteboardSubtitle;

  /// No description provided for @workspacesWhiteboardNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Whiteboard name *'**
  String get workspacesWhiteboardNameLabel;

  /// No description provided for @workspacesWhiteboardNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. System architecture, User journey map...'**
  String get workspacesWhiteboardNameHint;

  /// No description provided for @workspacesWhiteboardNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a whiteboard name'**
  String get workspacesWhiteboardNameRequired;

  /// No description provided for @workspacesWhiteboardFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'Whiteboard format'**
  String get workspacesWhiteboardFormatLabel;

  /// No description provided for @workspacesWhiteboardFormatCanvas.
  ///
  /// In en, this message translates to:
  /// **'Infinite canvas'**
  String get workspacesWhiteboardFormatCanvas;

  /// No description provided for @workspacesWhiteboardFormatA4.
  ///
  /// In en, this message translates to:
  /// **'A4 Document'**
  String get workspacesWhiteboardFormatA4;

  /// No description provided for @workspacesMenuCreateWhiteboard.
  ///
  /// In en, this message translates to:
  /// **'Create whiteboard'**
  String get workspacesMenuCreateWhiteboard;

  /// No description provided for @workspacesMenuAddAnotherWhiteboard.
  ///
  /// In en, this message translates to:
  /// **'Add another whiteboard'**
  String get workspacesMenuAddAnotherWhiteboard;

  /// No description provided for @workspacesCreateTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get workspacesCreateTaskTitle;

  /// No description provided for @workspacesCreateTaskSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a task to the project workflow.'**
  String get workspacesCreateTaskSubtitle;

  /// No description provided for @workspacesTaskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Task title *'**
  String get workspacesTaskTitleLabel;

  /// No description provided for @workspacesTaskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Task title...'**
  String get workspacesTaskTitleHint;

  /// No description provided for @workspacesTaskTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task title'**
  String get workspacesTaskTitleRequired;

  /// No description provided for @workspacesTaskDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Task description (optional)'**
  String get workspacesTaskDescriptionLabel;

  /// No description provided for @workspacesTaskDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add details, reproduction steps or criteria...'**
  String get workspacesTaskDescriptionHint;

  /// No description provided for @workspacesTaskPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get workspacesTaskPriorityLabel;

  /// No description provided for @workspacesTaskPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get workspacesTaskPriorityLow;

  /// No description provided for @workspacesTaskPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get workspacesTaskPriorityNormal;

  /// No description provided for @workspacesTaskPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get workspacesTaskPriorityHigh;

  /// No description provided for @workspacesTaskPriorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get workspacesTaskPriorityCritical;

  /// No description provided for @workspacesTaskStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial status'**
  String get workspacesTaskStatusLabel;

  /// No description provided for @workspacesTaskStatusTodo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get workspacesTaskStatusTodo;

  /// No description provided for @workspacesTaskStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get workspacesTaskStatusInProgress;

  /// No description provided for @workspacesTaskStatusBacklog.
  ///
  /// In en, this message translates to:
  /// **'Backlog'**
  String get workspacesTaskStatusBacklog;

  /// No description provided for @workspacesCreateWikiTitle.
  ///
  /// In en, this message translates to:
  /// **'New Wiki page'**
  String get workspacesCreateWikiTitle;

  /// No description provided for @workspacesCreateWikiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add an article to the project knowledge base.'**
  String get workspacesCreateWikiSubtitle;

  /// No description provided for @workspacesWikiTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Page title *'**
  String get workspacesWikiTitleLabel;

  /// No description provided for @workspacesWikiTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Technical requirements, Code standards...'**
  String get workspacesWikiTitleHint;

  /// No description provided for @workspacesWikiTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a page title'**
  String get workspacesWikiTitleRequired;

  /// No description provided for @workspacesCreateCorkboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Pin a note'**
  String get workspacesCreateCorkboardTitle;

  /// No description provided for @workspacesCreateCorkboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a note to the project corkboard.'**
  String get workspacesCreateCorkboardSubtitle;

  /// No description provided for @workspacesCorkboardTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Note title *'**
  String get workspacesCorkboardTitleLabel;

  /// No description provided for @workspacesCorkboardTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Short title...'**
  String get workspacesCorkboardTitleHint;

  /// No description provided for @workspacesCorkboardTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get workspacesCorkboardTitleRequired;

  /// No description provided for @workspacesCorkboardContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Note content (optional)'**
  String get workspacesCorkboardContentLabel;

  /// No description provided for @workspacesCorkboardContentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter note content or reminders...'**
  String get workspacesCorkboardContentHint;

  /// No description provided for @workspacesCorkboardColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Note color'**
  String get workspacesCorkboardColorLabel;

  /// No description provided for @workspacesCreateFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get workspacesCreateFolderTitle;

  /// No description provided for @workspacesCreateFolderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a folder in project files repository.'**
  String get workspacesCreateFolderSubtitle;

  /// No description provided for @workspacesFolderNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder name *'**
  String get workspacesFolderNameLabel;

  /// No description provided for @workspacesFolderNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Documentation, Attachments, Mockups...'**
  String get workspacesFolderNameHint;

  /// No description provided for @workspacesFolderNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a folder name'**
  String get workspacesFolderNameRequired;

  /// No description provided for @workspacesEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get workspacesEditAction;

  /// No description provided for @workspacesPinAction.
  ///
  /// In en, this message translates to:
  /// **'Pin to favorites'**
  String get workspacesPinAction;

  /// No description provided for @workspacesUnpinAction.
  ///
  /// In en, this message translates to:
  /// **'Unpin from favorites'**
  String get workspacesUnpinAction;

  /// No description provided for @workspacesHideAction.
  ///
  /// In en, this message translates to:
  /// **'Hide from list'**
  String get workspacesHideAction;

  /// No description provided for @workspacesShowAction.
  ///
  /// In en, this message translates to:
  /// **'Restore to list'**
  String get workspacesShowAction;

  /// No description provided for @workspacesMyTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'My tasks'**
  String get workspacesMyTasksLabel;

  /// No description provided for @workspacesMyFilesLabel.
  ///
  /// In en, this message translates to:
  /// **'My files'**
  String get workspacesMyFilesLabel;

  /// No description provided for @workspacesMyPrivateSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get workspacesMyPrivateSectionLabel;

  /// No description provided for @workspacesMyWorkspacesSection.
  ///
  /// In en, this message translates to:
  /// **'My workspaces'**
  String get workspacesMyWorkspacesSection;

  /// No description provided for @workspacesFavoritesSection.
  ///
  /// In en, this message translates to:
  /// **'Favorites ({count})'**
  String workspacesFavoritesSection(int count);

  /// No description provided for @workspacesTeamWorkspacesSection.
  ///
  /// In en, this message translates to:
  /// **'Team spaces ({count})'**
  String workspacesTeamWorkspacesSection(int count);

  /// No description provided for @workspacesAllWorkspacesSection.
  ///
  /// In en, this message translates to:
  /// **'All workspaces'**
  String get workspacesAllWorkspacesSection;

  /// No description provided for @workspacesHiddenWorkspacesLabel.
  ///
  /// In en, this message translates to:
  /// **'Hidden workspaces'**
  String get workspacesHiddenWorkspacesLabel;

  /// No description provided for @workspacesOwnerBadge.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get workspacesOwnerBadge;

  /// No description provided for @workspacesSharedBadge.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get workspacesSharedBadge;

  /// No description provided for @workspacesPersonalBadge.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get workspacesPersonalBadge;

  /// No description provided for @globalModuleOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get globalModuleOther;

  /// No description provided for @globalModuleOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get globalModuleOrders;

  /// No description provided for @globalModuleSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get globalModuleSettings;

  /// No description provided for @globalActionSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get globalActionSettings;

  /// No description provided for @globalActionLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get globalActionLogout;

  /// No description provided for @appDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get appDashboardTitle;

  /// No description provided for @appDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Main application surface that aggregates modules and future system areas.'**
  String get appDashboardSubtitle;

  /// No description provided for @appDashboardPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'New top-level module'**
  String get appDashboardPlaceholderTitle;

  /// No description provided for @appDashboardPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'This is the new parent application dashboard. In the next step, it can become a shared overview for Inventory, BHP, and future modules.'**
  String get appDashboardPlaceholderMessage;

  /// No description provided for @dashboardContextMenuChangeWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Change wallpaper'**
  String get dashboardContextMenuChangeWallpaper;

  /// No description provided for @dashboardContextMenuManageShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Manage shortcuts'**
  String get dashboardContextMenuManageShortcuts;

  /// No description provided for @dashboardContextMenuAddWidget.
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get dashboardContextMenuAddWidget;

  /// No description provided for @dashboardContextMenuAutoArrange.
  ///
  /// In en, this message translates to:
  /// **'Auto arrange'**
  String get dashboardContextMenuAutoArrange;

  /// No description provided for @dashboardContextMenuSnapToGrid.
  ///
  /// In en, this message translates to:
  /// **'Snap to grid'**
  String get dashboardContextMenuSnapToGrid;

  /// No description provided for @dashboardCollapsedTrayTitle.
  ///
  /// In en, this message translates to:
  /// **'Desktop Tray'**
  String get dashboardCollapsedTrayTitle;

  /// No description provided for @dashboardCollapsedTraySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Items hidden due to small window size. Increase the window size to automatically restore them to the desktop.'**
  String get dashboardCollapsedTraySubtitle;

  /// No description provided for @dashboardCollapsedTrayWidgets.
  ///
  /// In en, this message translates to:
  /// **'Widgets ({count})'**
  String dashboardCollapsedTrayWidgets(int count);

  /// No description provided for @dashboardCollapsedTrayShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts ({count})'**
  String dashboardCollapsedTrayShortcuts(int count);

  /// No description provided for @dashboardCollapsedTrayNoItems.
  ///
  /// In en, this message translates to:
  /// **'All items fit on the screen.'**
  String get dashboardCollapsedTrayNoItems;

  /// No description provided for @dashboardWidgetRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get dashboardWidgetRefreshTooltip;

  /// No description provided for @dashboardWidgetResizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change size'**
  String get dashboardWidgetResizeTitle;

  /// No description provided for @dashboardWidgetResizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size {size}'**
  String dashboardWidgetResizeLabel(Object size);

  /// No description provided for @dashboardWidgetRemoveAction.
  ///
  /// In en, this message translates to:
  /// **'Remove from desktop'**
  String get dashboardWidgetRemoveAction;

  /// No description provided for @dashboardWidgetBringToFront.
  ///
  /// In en, this message translates to:
  /// **'Bring to front'**
  String get dashboardWidgetBringToFront;

  /// No description provided for @dashboardWidgetSendToBack.
  ///
  /// In en, this message translates to:
  /// **'Send to back'**
  String get dashboardWidgetSendToBack;

  /// No description provided for @dashboardWidgetCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dashboardWidgetCategoryAll;

  /// No description provided for @dashboardWidgetCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get dashboardWidgetCategoryGeneral;

  /// No description provided for @dashboardWidgetPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get dashboardWidgetPickerTitle;

  /// No description provided for @dashboardWidgetPickerCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dashboardWidgetPickerCloseTooltip;

  /// No description provided for @dashboardWidgetPickerAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get dashboardWidgetPickerAddButton;

  /// No description provided for @dashboardWidgetPickerNoSpaceMessage.
  ///
  /// In en, this message translates to:
  /// **'No free space on the dashboard.'**
  String get dashboardWidgetPickerNoSpaceMessage;

  /// No description provided for @dashboardWidgetPickerPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'WIDGET PREVIEW'**
  String get dashboardWidgetPickerPreviewTitle;

  /// No description provided for @dashboardWallpaperPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Change wallpaper'**
  String get dashboardWallpaperPickerTitle;

  /// No description provided for @dashboardWallpaperPickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose one of the available desktop wallpapers.'**
  String get dashboardWallpaperPickerSubtitle;

  /// No description provided for @dashboardShortcutRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename shortcut'**
  String get dashboardShortcutRenameTitle;

  /// No description provided for @dashboardShortcutRenameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The new label will appear under the desktop icon.'**
  String get dashboardShortcutRenameSubtitle;

  /// No description provided for @dashboardShortcutRenameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get dashboardShortcutRenameFieldLabel;

  /// No description provided for @dashboardShortcutRenameCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dashboardShortcutRenameCancel;

  /// No description provided for @dashboardShortcutRenameSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get dashboardShortcutRenameSave;

  /// No description provided for @dashboardShortcutsPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Available modules'**
  String get dashboardShortcutsPanelTitle;

  /// No description provided for @dashboardShortcutsPanelCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dashboardShortcutsPanelCloseTooltip;

  /// No description provided for @dashboardShortcutsPanelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Click a module to place it in a free spot on the dashboard, or drag its icon directly onto the wallpaper.'**
  String get dashboardShortcutsPanelSubtitle;

  /// No description provided for @dashboardShortcutsPanelRenameAction.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get dashboardShortcutsPanelRenameAction;

  /// No description provided for @dashboardShortcutsPanelRemoveAction.
  ///
  /// In en, this message translates to:
  /// **'Remove from dashboard'**
  String get dashboardShortcutsPanelRemoveAction;

  /// No description provided for @dashboardShortcutsPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Available modules'**
  String get dashboardShortcutsPickerTitle;

  /// No description provided for @dashboardShortcutsPickerCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dashboardShortcutsPickerCloseTooltip;

  /// No description provided for @dashboardShortcutsPickerInstruction.
  ///
  /// In en, this message translates to:
  /// **'Click a module to add it to an empty spot on the dashboard, or drag its icon directly onto the wallpaper.'**
  String get dashboardShortcutsPickerInstruction;

  /// No description provided for @dashboardShortcutsPickerVisibleLabel.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get dashboardShortcutsPickerVisibleLabel;

  /// No description provided for @dashboardShortcutsPickerDragHint.
  ///
  /// In en, this message translates to:
  /// **'Click / drag icon'**
  String get dashboardShortcutsPickerDragHint;

  /// No description provided for @dashboardQuickActionsName.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get dashboardQuickActionsName;

  /// No description provided for @dashboardQuickActionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Gives fast access to key forms and system functions.'**
  String get dashboardQuickActionsDescription;

  /// No description provided for @dashboardQuickActionsCategory.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get dashboardQuickActionsCategory;

  /// No description provided for @dashboardQuickActionsInventoryAction.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get dashboardQuickActionsInventoryAction;

  /// No description provided for @dashboardQuickActionsBhpAction.
  ///
  /// In en, this message translates to:
  /// **'BHP issue'**
  String get dashboardQuickActionsBhpAction;

  /// No description provided for @dashboardQuickActionsSettingsAction.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get dashboardQuickActionsSettingsAction;

  /// No description provided for @dashboardStartupModuleName.
  ///
  /// In en, this message translates to:
  /// **'App Autostart'**
  String get dashboardStartupModuleName;

  /// No description provided for @dashboardStartupModuleDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose which module will open automatically when launching the app.'**
  String get dashboardStartupModuleDescription;

  /// No description provided for @dashboardStartupModuleCategory.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get dashboardStartupModuleCategory;

  /// No description provided for @dashboardActiveInventoriesName.
  ///
  /// In en, this message translates to:
  /// **'Active inventories'**
  String get dashboardActiveInventoriesName;

  /// No description provided for @dashboardActiveInventoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'List of active inventories currently in progress across branches.'**
  String get dashboardActiveInventoriesDescription;

  /// No description provided for @dashboardActiveInventoriesCategory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get dashboardActiveInventoriesCategory;

  /// No description provided for @dashboardActiveInventoriesErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get dashboardActiveInventoriesErrorTitle;

  /// No description provided for @dashboardActiveInventoriesRetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get dashboardActiveInventoriesRetryLabel;

  /// No description provided for @dashboardActiveInventoriesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No active inventories'**
  String get dashboardActiveInventoriesEmptyTitle;

  /// No description provided for @dashboardActiveInventoriesSheetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sheets: {count}'**
  String dashboardActiveInventoriesSheetsLabel(int count);

  /// No description provided for @dashboardBhpUsersName.
  ///
  /// In en, this message translates to:
  /// **'BHP: employees'**
  String get dashboardBhpUsersName;

  /// No description provided for @dashboardBhpUsersDescription.
  ///
  /// In en, this message translates to:
  /// **'Quick preview of BHP employees with a shortcut to the employee list module.'**
  String get dashboardBhpUsersDescription;

  /// No description provided for @dashboardBhpUsersCategory.
  ///
  /// In en, this message translates to:
  /// **'BHP'**
  String get dashboardBhpUsersCategory;

  /// No description provided for @dashboardBhpUsersErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load employees'**
  String get dashboardBhpUsersErrorTitle;

  /// No description provided for @dashboardBhpUsersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'BHP employees'**
  String get dashboardBhpUsersSectionTitle;

  /// No description provided for @dashboardBhpUsersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No employees'**
  String get dashboardBhpUsersEmptyTitle;

  /// No description provided for @dashboardBhpUsersEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No active employees were found.'**
  String get dashboardBhpUsersEmptyMessage;

  /// No description provided for @dashboardBhpUsersNoPositionLabel.
  ///
  /// In en, this message translates to:
  /// **'No position'**
  String get dashboardBhpUsersNoPositionLabel;

  /// No description provided for @dashboardBhpUsersDeadlineOverdueLabel.
  ///
  /// In en, this message translates to:
  /// **'{days} days overdue'**
  String dashboardBhpUsersDeadlineOverdueLabel(int days);

  /// No description provided for @dashboardBhpUsersDeadlineTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get dashboardBhpUsersDeadlineTodayLabel;

  /// No description provided for @dashboardBhpUsersDeadlineUpcomingLabel.
  ///
  /// In en, this message translates to:
  /// **'in {days} days'**
  String dashboardBhpUsersDeadlineUpcomingLabel(int days);

  /// No description provided for @dashboardBhpUsersDeadlineOverdueCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} overdue'**
  String dashboardBhpUsersDeadlineOverdueCountLabel(int count);

  /// No description provided for @dashboardBhpUsersDeadlineUpcomingCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} soon'**
  String dashboardBhpUsersDeadlineUpcomingCountLabel(int count);

  /// No description provided for @dashboardBhpUsersDeadlineOkLabel.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get dashboardBhpUsersDeadlineOkLabel;

  /// No description provided for @dashboardBhpPositionsName.
  ///
  /// In en, this message translates to:
  /// **'BHP: positions'**
  String get dashboardBhpPositionsName;

  /// No description provided for @dashboardBhpPositionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Quick preview of BHP positions with a shortcut to the full position list.'**
  String get dashboardBhpPositionsDescription;

  /// No description provided for @dashboardBhpPositionsCategory.
  ///
  /// In en, this message translates to:
  /// **'BHP'**
  String get dashboardBhpPositionsCategory;

  /// No description provided for @dashboardBhpPositionsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load positions'**
  String get dashboardBhpPositionsErrorTitle;

  /// No description provided for @dashboardBhpPositionsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'BHP positions'**
  String get dashboardBhpPositionsSectionTitle;

  /// No description provided for @dashboardBhpPositionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No positions'**
  String get dashboardBhpPositionsEmptyTitle;

  /// No description provided for @dashboardBhpPositionsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No active positions were found.'**
  String get dashboardBhpPositionsEmptyMessage;

  /// No description provided for @dashboardBhpPositionsNoNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get dashboardBhpPositionsNoNotesLabel;

  /// No description provided for @dashboardBhpPositionsActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get dashboardBhpPositionsActiveLabel;

  /// No description provided for @dashboardBhpPositionsInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'inactive'**
  String get dashboardBhpPositionsInactiveLabel;

  /// No description provided for @dashboardBhpEquipmentName.
  ///
  /// In en, this message translates to:
  /// **'BHP: equipment'**
  String get dashboardBhpEquipmentName;

  /// No description provided for @dashboardBhpEquipmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Quick preview of the BHP equipment catalog with a shortcut to the full list.'**
  String get dashboardBhpEquipmentDescription;

  /// No description provided for @dashboardBhpEquipmentCategory.
  ///
  /// In en, this message translates to:
  /// **'BHP'**
  String get dashboardBhpEquipmentCategory;

  /// No description provided for @dashboardBhpEquipmentErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load equipment'**
  String get dashboardBhpEquipmentErrorTitle;

  /// No description provided for @dashboardBhpEquipmentSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'BHP equipment'**
  String get dashboardBhpEquipmentSectionTitle;

  /// No description provided for @dashboardBhpEquipmentEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No equipment'**
  String get dashboardBhpEquipmentEmptyTitle;

  /// No description provided for @dashboardBhpEquipmentEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No active equipment was found.'**
  String get dashboardBhpEquipmentEmptyMessage;

  /// No description provided for @dashboardBhpEquipmentNoPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'No period'**
  String get dashboardBhpEquipmentNoPeriodLabel;

  /// No description provided for @dashboardBhpEquipmentActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get dashboardBhpEquipmentActiveLabel;

  /// No description provided for @dashboardBhpUpcomingName.
  ///
  /// In en, this message translates to:
  /// **'BHP: upcoming'**
  String get dashboardBhpUpcomingName;

  /// No description provided for @dashboardBhpUpcomingDescription.
  ///
  /// In en, this message translates to:
  /// **'List of BHP alerts approaching their deadline and needing preparation.'**
  String get dashboardBhpUpcomingDescription;

  /// No description provided for @dashboardBhpUpcomingCategory.
  ///
  /// In en, this message translates to:
  /// **'BHP'**
  String get dashboardBhpUpcomingCategory;

  /// No description provided for @dashboardBhpUpcomingErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load upcoming alerts'**
  String get dashboardBhpUpcomingErrorTitle;

  /// No description provided for @dashboardBhpUpcomingRefreshLabel.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get dashboardBhpUpcomingRefreshLabel;

  /// No description provided for @dashboardBhpUpcomingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get dashboardBhpUpcomingSectionTitle;

  /// No description provided for @dashboardBhpUpcomingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming alerts'**
  String get dashboardBhpUpcomingEmptyTitle;

  /// No description provided for @dashboardBhpUpcomingEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no items approaching their deadline.'**
  String get dashboardBhpUpcomingEmptyMessage;

  /// No description provided for @dashboardBhpOverdueName.
  ///
  /// In en, this message translates to:
  /// **'BHP: overdue'**
  String get dashboardBhpOverdueName;

  /// No description provided for @dashboardBhpOverdueDescription.
  ///
  /// In en, this message translates to:
  /// **'List of the most urgent BHP alerts that are already overdue.'**
  String get dashboardBhpOverdueDescription;

  /// No description provided for @dashboardBhpOverdueCategory.
  ///
  /// In en, this message translates to:
  /// **'BHP'**
  String get dashboardBhpOverdueCategory;

  /// No description provided for @dashboardBhpOverdueErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load overdue alerts'**
  String get dashboardBhpOverdueErrorTitle;

  /// No description provided for @dashboardBhpOverdueRefreshLabel.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get dashboardBhpOverdueRefreshLabel;

  /// No description provided for @dashboardBhpOverdueSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get dashboardBhpOverdueSectionTitle;

  /// No description provided for @dashboardBhpOverdueEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No overdue alerts'**
  String get dashboardBhpOverdueEmptyTitle;

  /// No description provided for @dashboardBhpOverdueEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'All BHP items are within their deadlines.'**
  String get dashboardBhpOverdueEmptyMessage;

  /// No description provided for @dashboardInventorySummaryName.
  ///
  /// In en, this message translates to:
  /// **'Inventory stats'**
  String get dashboardInventorySummaryName;

  /// No description provided for @dashboardInventorySummaryDescription.
  ///
  /// In en, this message translates to:
  /// **'Overview of inventory progress, active sheets, and latest readings.'**
  String get dashboardInventorySummaryDescription;

  /// No description provided for @dashboardInventorySummaryCategory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get dashboardInventorySummaryCategory;

  /// No description provided for @dashboardInventorySummaryActiveSheetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Active sheets'**
  String get dashboardInventorySummaryActiveSheetsLabel;

  /// No description provided for @dashboardInventorySummaryCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get dashboardInventorySummaryCompletedLabel;

  /// No description provided for @dashboardInventorySummaryProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall progress'**
  String get dashboardInventorySummaryProgressLabel;

  /// No description provided for @settingsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Application settings'**
  String get settingsHeaderTitle;

  /// No description provided for @settingsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Local configuration shared across all modules. This section will grow with language, preferences and module settings.'**
  String get settingsHeaderSubtitle;

  /// No description provided for @settingsCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get settingsCategoriesTitle;

  /// No description provided for @settingsCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a configuration area'**
  String get settingsCategoriesSubtitle;

  /// No description provided for @settingsSectionAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearanceTitle;

  /// No description provided for @settingsSectionAppearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme and color palette'**
  String get settingsSectionAppearanceSubtitle;

  /// No description provided for @settingsSectionLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguageTitle;

  /// No description provided for @settingsSectionLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Application language'**
  String get settingsSectionLanguageSubtitle;

  /// No description provided for @settingsSectionModulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get settingsSectionModulesTitle;

  /// No description provided for @settingsSectionModulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Startup and post-login behavior'**
  String get settingsSectionModulesSubtitle;

  /// No description provided for @settingsStartupModuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Module auto start'**
  String get settingsStartupModuleTitle;

  /// No description provided for @settingsStartupModuleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'After sign-in the app always shows the dashboard first and then automatically opens the selected module.'**
  String get settingsStartupModuleSubtitle;

  /// No description provided for @settingsStartupModuleDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on the dashboard after sign-in'**
  String get settingsStartupModuleDashboardSubtitle;

  /// No description provided for @settingsStartupModuleInventorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the inventory module after the dashboard'**
  String get settingsStartupModuleInventorySubtitle;

  /// No description provided for @settingsStartupModuleBhpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the BHP module after the dashboard'**
  String get settingsStartupModuleBhpSubtitle;

  /// No description provided for @settingsStartupModuleSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open application settings after the dashboard'**
  String get settingsStartupModuleSettingsSubtitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose primary interface language.'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsLanguagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polish (Polski)'**
  String get settingsLanguagePolish;

  /// No description provided for @settingsLanguagePolishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default language for your organization'**
  String get settingsLanguagePolishSubtitle;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageEnglishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Secondary language for international users'**
  String get settingsLanguageEnglishSubtitle;

  /// No description provided for @settingsAppearanceModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get settingsAppearanceModeTitle;

  /// No description provided for @settingsAppearanceModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how light and dark appearance is selected.'**
  String get settingsAppearanceModeSubtitle;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow operating system preference'**
  String get settingsThemeSystemSubtitle;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeLightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Always use light appearance'**
  String get settingsThemeLightSubtitle;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeDarkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Always use dark appearance'**
  String get settingsThemeDarkSubtitle;

  /// No description provided for @settingsPaletteTitle.
  ///
  /// In en, this message translates to:
  /// **'Color palette'**
  String get settingsPaletteTitle;

  /// No description provided for @settingsPaletteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Palette variant for the whole application.'**
  String get settingsPaletteSubtitle;

  /// No description provided for @settingsPaletteClassicTitle.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get settingsPaletteClassicTitle;

  /// No description provided for @settingsPaletteClassicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Neutral blue, default visual style'**
  String get settingsPaletteClassicSubtitle;

  /// No description provided for @settingsPaletteMaterialTitle.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get settingsPaletteMaterialTitle;

  /// No description provided for @settingsPaletteMaterialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Standard Material 3 generated by ColorScheme.fromSeed'**
  String get settingsPaletteMaterialSubtitle;

  /// No description provided for @settingsSeedColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Material seed color'**
  String get settingsSeedColorTitle;

  /// No description provided for @settingsSeedColorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the seed color for the Material palette.'**
  String get settingsSeedColorSubtitle;

  /// No description provided for @settingsSeedColorBlueTitle.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get settingsSeedColorBlueTitle;

  /// No description provided for @settingsSeedColorBlueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Closest to the current app look'**
  String get settingsSeedColorBlueSubtitle;

  /// No description provided for @settingsSeedColorEmeraldTitle.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get settingsSeedColorEmeraldTitle;

  /// No description provided for @settingsSeedColorEmeraldSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cool green-teal variant'**
  String get settingsSeedColorEmeraldSubtitle;

  /// No description provided for @settingsSeedColorAmberTitle.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get settingsSeedColorAmberTitle;

  /// No description provided for @settingsSeedColorAmberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Warm orange-gold variant'**
  String get settingsSeedColorAmberSubtitle;

  /// No description provided for @settingsSeedColorRoseTitle.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get settingsSeedColorRoseTitle;

  /// No description provided for @settingsSeedColorRoseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Soft raspberry accent'**
  String get settingsSeedColorRoseSubtitle;

  /// No description provided for @settingsSeedColorVioletTitle.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get settingsSeedColorVioletTitle;

  /// No description provided for @settingsSeedColorVioletSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cool violet variant'**
  String get settingsSeedColorVioletSubtitle;

  /// No description provided for @settingsSeedColorTealTitle.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get settingsSeedColorTealTitle;

  /// No description provided for @settingsSeedColorTealSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sea-toned, more saturated variant'**
  String get settingsSeedColorTealSubtitle;

  /// No description provided for @settingsSeedColorIndigoTitle.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get settingsSeedColorIndigoTitle;

  /// No description provided for @settingsSeedColorIndigoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deep blue-violet variant'**
  String get settingsSeedColorIndigoSubtitle;

  /// No description provided for @settingsSeedColorOrangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get settingsSeedColorOrangeTitle;

  /// No description provided for @settingsSeedColorOrangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Energetic orange variant'**
  String get settingsSeedColorOrangeSubtitle;

  /// No description provided for @settingsSeedColorCrimsonTitle.
  ///
  /// In en, this message translates to:
  /// **'Crimson'**
  String get settingsSeedColorCrimsonTitle;

  /// No description provided for @settingsSeedColorCrimsonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Strong crimson accent'**
  String get settingsSeedColorCrimsonSubtitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @inventoryModuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryModuleTitle;

  /// No description provided for @inventorySectionInventories.
  ///
  /// In en, this message translates to:
  /// **'Inventories'**
  String get inventorySectionInventories;

  /// No description provided for @inventoryInventoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'List of active and archived records.'**
  String get inventoryInventoriesSubtitle;

  /// No description provided for @inventoryNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get inventoryNew;

  /// Section title for the fixed asset state overview screen.
  ///
  /// In en, this message translates to:
  /// **'Asset state'**
  String get inventorySectionAssetState;

  /// Column label for the source current state of an inventory sheet item.
  ///
  /// In en, this message translates to:
  /// **'Current state'**
  String get inventoryCurrentState;

  /// No description provided for @inventorySectionLocations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get inventorySectionLocations;

  /// No description provided for @inventorySectionCompanies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get inventorySectionCompanies;

  /// No description provided for @inventorySidebarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage assets and inventory sheets'**
  String get inventorySidebarSubtitle;

  /// No description provided for @inventoryUiGallery.
  ///
  /// In en, this message translates to:
  /// **'UI Gallery'**
  String get inventoryUiGallery;

  /// No description provided for @inventoryRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get inventoryRefresh;

  /// No description provided for @inventoryNoNumber.
  ///
  /// In en, this message translates to:
  /// **'No number'**
  String get inventoryNoNumber;

  /// No description provided for @inventoryDateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get inventoryDateRangeLabel;

  /// No description provided for @inventoryPeopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} people'**
  String inventoryPeopleCount(int count);

  /// No description provided for @inventoryFetchErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Fetch error'**
  String get inventoryFetchErrorTitle;

  /// No description provided for @inventoryActionNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Action \"{label}\" will be connected to API.'**
  String inventoryActionNotConnected(Object label);

  /// No description provided for @inventoryOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset state'**
  String get inventoryOverviewTitle;

  /// No description provided for @inventoryOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick filtering and fixed assets list.'**
  String get inventoryOverviewSubtitle;

  /// No description provided for @inventorySearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get inventorySearch;

  /// No description provided for @inventoryLoadingErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get inventoryLoadingErrorTitle;

  /// No description provided for @inventoryOverviewSearchHintName.
  ///
  /// In en, this message translates to:
  /// **'Enter fixed asset name...'**
  String get inventoryOverviewSearchHintName;

  /// No description provided for @inventoryOverviewSearchHintRegisterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter register number...'**
  String get inventoryOverviewSearchHintRegisterNumber;

  /// No description provided for @inventoryOverviewSearchHintBarcode.
  ///
  /// In en, this message translates to:
  /// **'Enter barcode...'**
  String get inventoryOverviewSearchHintBarcode;

  /// No description provided for @inventoryOverviewSearchHintGlobal.
  ///
  /// In en, this message translates to:
  /// **'Name, register no., person, location or barcode...'**
  String get inventoryOverviewSearchHintGlobal;

  /// No description provided for @inventoryCompany.
  ///
  /// In en, this message translates to:
  /// **'Companies/Branches'**
  String get inventoryCompany;

  /// No description provided for @inventoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get inventoryAll;

  /// No description provided for @inventoryAllCompanies.
  ///
  /// In en, this message translates to:
  /// **'All companies'**
  String get inventoryAllCompanies;

  /// No description provided for @inventorySearchBy.
  ///
  /// In en, this message translates to:
  /// **'Search by'**
  String get inventorySearchBy;

  /// No description provided for @inventorySearchSheetsAction.
  ///
  /// In en, this message translates to:
  /// **'Search sheets'**
  String get inventorySearchSheetsAction;

  /// No description provided for @inventorySearchSheetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search across sheets'**
  String get inventorySearchSheetsTitle;

  /// No description provided for @inventorySearchSheetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory {number}'**
  String inventorySearchSheetsSubtitle(Object number);

  /// No description provided for @inventorySearchSheetsHint.
  ///
  /// In en, this message translates to:
  /// **'Register no., name, person or barcode...'**
  String get inventorySearchSheetsHint;

  /// No description provided for @inventorySearchSheetsSortByRegisterNumber.
  ///
  /// In en, this message translates to:
  /// **'Reg. no.'**
  String get inventorySearchSheetsSortByRegisterNumber;

  /// No description provided for @inventorySearchSheetsSortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get inventorySearchSheetsSortByName;

  /// No description provided for @inventorySearchSheetsSortByMatches.
  ///
  /// In en, this message translates to:
  /// **'Matches count'**
  String get inventorySearchSheetsSortByMatches;

  /// No description provided for @inventorySearchSheetsStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start searching'**
  String get inventorySearchSheetsStartTitle;

  /// No description provided for @inventorySearchSheetsStartMessage.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters to search across all sheets in this inventory.'**
  String get inventorySearchSheetsStartMessage;

  /// No description provided for @inventorySearchSheetsResultsCount.
  ///
  /// In en, this message translates to:
  /// **'Groups: {groups}, matches: {matches}'**
  String inventorySearchSheetsResultsCount(int groups, int matches);

  /// No description provided for @inventorySearchSheetsMatchesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} matches'**
  String inventorySearchSheetsMatchesCount(int count);

  /// No description provided for @inventorySearchSheetsCurrentSheet.
  ///
  /// In en, this message translates to:
  /// **'Current sheet'**
  String get inventorySearchSheetsCurrentSheet;

  /// No description provided for @inventorySearchSheetsFocusCurrentAction.
  ///
  /// In en, this message translates to:
  /// **'Show in sheet'**
  String get inventorySearchSheetsFocusCurrentAction;

  /// No description provided for @inventorySearchSheetsOpenSheetAction.
  ///
  /// In en, this message translates to:
  /// **'Open sheet'**
  String get inventorySearchSheetsOpenSheetAction;

  /// No description provided for @inventorySearchSheetsToDisposeStatus.
  ///
  /// In en, this message translates to:
  /// **'To dispose'**
  String get inventorySearchSheetsToDisposeStatus;

  /// No description provided for @inventoryPresenceConflictsTitle.
  ///
  /// In en, this message translates to:
  /// **'Presence conflicts'**
  String get inventoryPresenceConflictsTitle;

  /// No description provided for @inventoryPresenceConflictsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory {number}'**
  String inventoryPresenceConflictsSubtitle(Object number);

  /// No description provided for @inventoryPresenceConflictsLoadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Checking conflicts'**
  String get inventoryPresenceConflictsLoadingLabel;

  /// No description provided for @inventoryPresenceConflictsRetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Show conflicts'**
  String get inventoryPresenceConflictsRetryLabel;

  /// No description provided for @inventoryPresenceConflictsEmptyBadge.
  ///
  /// In en, this message translates to:
  /// **'No conflicts detected'**
  String get inventoryPresenceConflictsEmptyBadge;

  /// No description provided for @inventoryPresenceConflictsDetectedAction.
  ///
  /// In en, this message translates to:
  /// **'{count} conflicts'**
  String inventoryPresenceConflictsDetectedAction(int count);

  /// No description provided for @inventoryPresenceConflictsResultsCount.
  ///
  /// In en, this message translates to:
  /// **'Conflicts: {count}'**
  String inventoryPresenceConflictsResultsCount(int count);

  /// No description provided for @inventoryPresenceConflictsArkuszeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sheets'**
  String inventoryPresenceConflictsArkuszeCount(int count);

  /// No description provided for @inventoryPresenceConflictsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No conflicts detected'**
  String get inventoryPresenceConflictsEmptyTitle;

  /// No description provided for @inventoryPresenceConflictsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This inventory currently has no fixed assets detected in multiple sheets as present entries.'**
  String get inventoryPresenceConflictsEmptyMessage;

  /// No description provided for @inventorySurplusConflictsTitle.
  ///
  /// In en, this message translates to:
  /// **'Surplus conflicts'**
  String get inventorySurplusConflictsTitle;

  /// No description provided for @inventorySurplusConflictsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory {number}'**
  String inventorySurplusConflictsSubtitle(Object number);

  /// No description provided for @inventorySurplusConflictsLoadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Checking surplus conflicts'**
  String get inventorySurplusConflictsLoadingLabel;

  /// No description provided for @inventorySurplusConflictsRetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Show surplus conflicts'**
  String get inventorySurplusConflictsRetryLabel;

  /// No description provided for @inventorySurplusConflictsEmptyBadge.
  ///
  /// In en, this message translates to:
  /// **'No surplus conflicts'**
  String get inventorySurplusConflictsEmptyBadge;

  /// No description provided for @inventorySurplusConflictsDetectedAction.
  ///
  /// In en, this message translates to:
  /// **'{count} unpaired surpluses'**
  String inventorySurplusConflictsDetectedAction(int count);

  /// No description provided for @inventorySurplusConflictsResultsCount.
  ///
  /// In en, this message translates to:
  /// **'Unpaired surpluses: {count}'**
  String inventorySurplusConflictsResultsCount(int count);

  /// No description provided for @inventorySurplusConflictsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No surplus conflicts'**
  String get inventorySurplusConflictsEmptyTitle;

  /// No description provided for @inventorySurplusConflictsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This inventory currently has no surplus entries without a matching missing item in other sheets.'**
  String get inventorySurplusConflictsEmptyMessage;

  /// No description provided for @inventorySurplusConflictsMatchBasisLabel.
  ///
  /// In en, this message translates to:
  /// **'Matched by'**
  String get inventorySurplusConflictsMatchBasisLabel;

  /// No description provided for @inventorySurplusConflictsMatchBasisRegisterNumber.
  ///
  /// In en, this message translates to:
  /// **'Register number'**
  String get inventorySurplusConflictsMatchBasisRegisterNumber;

  /// No description provided for @inventorySurplusConflictsMatchBasisBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get inventorySurplusConflictsMatchBasisBarcode;

  /// No description provided for @inventoryDuplicateConflictsTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate register numbers'**
  String get inventoryDuplicateConflictsTitle;

  /// No description provided for @inventoryDuplicateConflictsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate register numbers detected in stan_st.'**
  String get inventoryDuplicateConflictsSubtitle;

  /// No description provided for @inventoryDuplicateConflictsRetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Show duplicates'**
  String get inventoryDuplicateConflictsRetryLabel;

  /// No description provided for @inventoryDuplicateConflictsSummary.
  ///
  /// In en, this message translates to:
  /// **'Groups: {groups} • Records: {records}'**
  String inventoryDuplicateConflictsSummary(Object groups, Object records);

  /// No description provided for @inventoryDuplicateConflictsDetected.
  ///
  /// In en, this message translates to:
  /// **'Detected {count} duplicate groups'**
  String inventoryDuplicateConflictsDetected(int count);

  /// No description provided for @inventoryDuplicateConflictsVisibleResults.
  ///
  /// In en, this message translates to:
  /// **'Visible: {groups} groups • {records} records'**
  String inventoryDuplicateConflictsVisibleResults(int groups, int records);

  /// No description provided for @inventoryDuplicateConflictsFetchError.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch stan_st duplicates.'**
  String get inventoryDuplicateConflictsFetchError;

  /// No description provided for @inventoryDuplicateConflictsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No duplicate register numbers'**
  String get inventoryDuplicateConflictsEmptyTitle;

  /// No description provided for @inventoryDuplicateConflictsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No duplicate register numbers were found in the current stan_st snapshot.'**
  String get inventoryDuplicateConflictsEmptyMessage;

  /// No description provided for @inventoryDuplicateGroupRecordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} records'**
  String inventoryDuplicateGroupRecordsCount(int count);

  /// No description provided for @inventoryDuplicateCompaniesLabel.
  ///
  /// In en, this message translates to:
  /// **'Companies: {list}'**
  String inventoryDuplicateCompaniesLabel(Object list);

  /// No description provided for @inventoryDuplicateVariantsLabel.
  ///
  /// In en, this message translates to:
  /// **'Variants: {variants}'**
  String inventoryDuplicateVariantsLabel(Object variants);

  /// No description provided for @inventoryDuplicateCopiedRegisterToast.
  ///
  /// In en, this message translates to:
  /// **'Register number copied.'**
  String get inventoryDuplicateCopiedRegisterToast;

  /// No description provided for @inventoryImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get inventoryImport;

  /// No description provided for @inventoryName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get inventoryName;

  /// No description provided for @inventoryRegisterNumber.
  ///
  /// In en, this message translates to:
  /// **'Register number'**
  String get inventoryRegisterNumber;

  /// No description provided for @inventoryRegisterNumberShort.
  ///
  /// In en, this message translates to:
  /// **'Reg. no.'**
  String get inventoryRegisterNumberShort;

  /// No description provided for @inventoryBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get inventoryBarcode;

  /// No description provided for @inventoryNoName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get inventoryNoName;

  /// No description provided for @inventoryPerson.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get inventoryPerson;

  /// No description provided for @inventoryLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get inventoryLocation;

  /// No description provided for @inventoryState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get inventoryState;

  /// No description provided for @inventoryUnknownWithCode.
  ///
  /// In en, this message translates to:
  /// **'Unknown ({code})'**
  String inventoryUnknownWithCode(Object code);

  /// No description provided for @inventoryPurchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get inventoryPurchaseDate;

  /// No description provided for @inventoryValueP.
  ///
  /// In en, this message translates to:
  /// **'Value P'**
  String get inventoryValueP;

  /// No description provided for @inventoryAssetDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset details'**
  String get inventoryAssetDetailsTitle;

  /// No description provided for @inventoryBasicInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get inventoryBasicInfoSection;

  /// No description provided for @inventoryLocationSection.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get inventoryLocationSection;

  /// No description provided for @inventoryFinancialSection.
  ///
  /// In en, this message translates to:
  /// **'Financial and purchase data'**
  String get inventoryFinancialSection;

  /// No description provided for @inventoryLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get inventoryLevel;

  /// No description provided for @inventoryValueA.
  ///
  /// In en, this message translates to:
  /// **'Value A'**
  String get inventoryValueA;

  /// No description provided for @inventoryImportedAt.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get inventoryImportedAt;

  /// No description provided for @inventoryNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get inventoryNoData;

  /// No description provided for @inventoryLocationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get inventoryLocationsTitle;

  /// No description provided for @inventoryLocationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Locations list'**
  String get inventoryLocationsSubtitle;

  /// No description provided for @inventoryTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get inventoryTable;

  /// No description provided for @inventoryTree.
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get inventoryTree;

  /// No description provided for @inventoryLocationsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Code, name, level...'**
  String get inventoryLocationsSearchHint;

  /// No description provided for @inventoryLocationsTreeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Company, code, name, level...'**
  String get inventoryLocationsTreeSearchHint;

  /// No description provided for @inventoryNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get inventoryNoResultsTitle;

  /// No description provided for @inventoryLocationsNoResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'No branches matching the filter were found.'**
  String get inventoryLocationsNoResultsMessage;

  /// No description provided for @inventoryCompanyWithId.
  ///
  /// In en, this message translates to:
  /// **'Branch {id}'**
  String inventoryCompanyWithId(int id);

  /// No description provided for @inventoryLocationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} locations'**
  String inventoryLocationsCount(int count);

  /// No description provided for @inventoryCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get inventoryCode;

  /// No description provided for @inventoryCompaniesTitle.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get inventoryCompaniesTitle;

  /// No description provided for @inventoryCompaniesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'List of registered companies in inventory dictionary.'**
  String get inventoryCompaniesSubtitle;

  /// No description provided for @inventoryCompaniesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No companies'**
  String get inventoryCompaniesEmptyTitle;

  /// No description provided for @inventoryCompaniesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No companies were found in the dictionary.'**
  String get inventoryCompaniesEmptyMessage;

  /// No description provided for @inventoryCompanyIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Company ID: {id}'**
  String inventoryCompanyIdLabel(int id);

  /// No description provided for @inventoryCompanyDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Company has been deleted.'**
  String get inventoryCompanyDeletedMessage;

  /// No description provided for @inventoryDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory details'**
  String get inventoryDetailsTitle;

  /// No description provided for @inventoryNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Number: {number}'**
  String inventoryNumberLabel(Object number);

  /// No description provided for @inventoryDetailsLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load inventory details'**
  String get inventoryDetailsLoadErrorTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @inventorySheetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sheets'**
  String get inventorySheetsLabel;

  /// No description provided for @inventoryWarehouseLabel.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get inventoryWarehouseLabel;

  /// No description provided for @inventoryActionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get inventoryActionsLabel;

  /// No description provided for @inventoryReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get inventoryReportsTitle;

  /// No description provided for @inventoryReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory {number}'**
  String inventoryReportsSubtitle(Object number);

  /// No description provided for @inventoryReportsIntro.
  ///
  /// In en, this message translates to:
  /// **'Reports are calculated on all sheet items attached to the selected inventory.'**
  String get inventoryReportsIntro;

  /// No description provided for @inventoryReportsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Report list'**
  String get inventoryReportsListTitle;

  /// No description provided for @inventoryReportsBundleTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF bundle'**
  String get inventoryReportsBundleTitle;

  /// No description provided for @inventoryReportsBundleDescription.
  ///
  /// In en, this message translates to:
  /// **'A merged document matching the legacy Delphi report set.'**
  String get inventoryReportsBundleDescription;

  /// No description provided for @inventoryReportsPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get inventoryReportsPreview;

  /// No description provided for @inventoryReportsDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get inventoryReportsDownload;

  /// No description provided for @inventoryReportsPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get inventoryReportsPrint;

  /// No description provided for @inventoryReportsPreviewPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF preview'**
  String get inventoryReportsPreviewPdf;

  /// No description provided for @inventoryReportsBundleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report bundle'**
  String get inventoryReportsBundleSubtitle;

  /// No description provided for @inventoryReportsSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get inventoryReportsSortLabel;

  /// No description provided for @inventoryReportsSortDirectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get inventoryReportsSortDirectionLabel;

  /// No description provided for @inventoryReportsSortById.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get inventoryReportsSortById;

  /// No description provided for @inventoryReportsSortByRegisterNumber.
  ///
  /// In en, this message translates to:
  /// **'Reg. no.'**
  String get inventoryReportsSortByRegisterNumber;

  /// No description provided for @inventoryReportsSortByLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get inventoryReportsSortByLocation;

  /// No description provided for @inventoryReportsSortByStatus.
  ///
  /// In en, this message translates to:
  /// **'Count status'**
  String get inventoryReportsSortByStatus;

  /// No description provided for @inventoryReportsSortByInventoryState.
  ///
  /// In en, this message translates to:
  /// **'Inventory state'**
  String get inventoryReportsSortByInventoryState;

  /// No description provided for @inventoryReportsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get inventoryReportsRefresh;

  /// No description provided for @inventoryReportsDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get inventoryReportsDownloadPdf;

  /// No description provided for @inventoryReportsDownloadReportPdf.
  ///
  /// In en, this message translates to:
  /// **'Download report PDF'**
  String get inventoryReportsDownloadReportPdf;

  /// No description provided for @inventoryReportsDownloadProtocol.
  ///
  /// In en, this message translates to:
  /// **'Download protocol'**
  String get inventoryReportsDownloadProtocol;

  /// No description provided for @inventoryReportsPrintPdf.
  ///
  /// In en, this message translates to:
  /// **'Print PDF'**
  String get inventoryReportsPrintPdf;

  /// No description provided for @inventoryReportsPrintReportPdf.
  ///
  /// In en, this message translates to:
  /// **'Print report PDF'**
  String get inventoryReportsPrintReportPdf;

  /// No description provided for @inventoryReportsPrintProtocol.
  ///
  /// In en, this message translates to:
  /// **'Print protocol'**
  String get inventoryReportsPrintProtocol;

  /// No description provided for @inventoryReportsElements.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get inventoryReportsElements;

  /// No description provided for @inventoryReportsGeneratedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated at'**
  String get inventoryReportsGeneratedAt;

  /// No description provided for @inventoryReportsNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes in bundle'**
  String get inventoryReportsNotesLabel;

  /// No description provided for @inventoryReportsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get inventoryReportsEnabled;

  /// No description provided for @inventoryReportsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get inventoryReportsDisabled;

  /// No description provided for @inventoryReportsPreviewOpenError.
  ///
  /// In en, this message translates to:
  /// **'Failed to open the PDF bundle preview.'**
  String get inventoryReportsPreviewOpenError;

  /// No description provided for @inventoryReportsSortAscending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get inventoryReportsSortAscending;

  /// No description provided for @inventoryReportsSortDescending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get inventoryReportsSortDescending;

  /// No description provided for @inventoryReportNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No data for this report'**
  String get inventoryReportNoDataTitle;

  /// No description provided for @inventoryReportNoDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Backend returned no items for the selected type.'**
  String get inventoryReportNoDataMessage;

  /// No description provided for @inventoryReportFetchErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load report'**
  String get inventoryReportFetchErrorTitle;

  /// No description provided for @inventoryReportInternalBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Internal report'**
  String get inventoryReportInternalBannerTitle;

  /// No description provided for @inventoryReportSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by reg. no., name, location, person, or barcode'**
  String get inventoryReportSearchHint;

  /// No description provided for @inventoryReportRegisterNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Register number'**
  String get inventoryReportRegisterNumberLabel;

  /// No description provided for @inventoryReportNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get inventoryReportNameLabel;

  /// No description provided for @inventoryReportLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get inventoryReportLocationLabel;

  /// No description provided for @inventoryReportPersonLabel.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get inventoryReportPersonLabel;

  /// No description provided for @inventoryReportBarcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get inventoryReportBarcodeLabel;

  /// No description provided for @inventoryReportGrossValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Gross value'**
  String get inventoryReportGrossValueLabel;

  /// No description provided for @inventoryReportNetValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Net value'**
  String get inventoryReportNetValueLabel;

  /// No description provided for @inventoryReportPurchaseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get inventoryReportPurchaseDateLabel;

  /// No description provided for @inventoryReportUwagiLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get inventoryReportUwagiLabel;

  /// No description provided for @inventoryReportMissingLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Missing location'**
  String get inventoryReportMissingLocationLabel;

  /// No description provided for @inventoryReportMissingPersonLabel.
  ///
  /// In en, this message translates to:
  /// **'Missing person'**
  String get inventoryReportMissingPersonLabel;

  /// No description provided for @inventoryReportExcessLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Excess location'**
  String get inventoryReportExcessLocationLabel;

  /// No description provided for @inventoryReportExcessPersonLabel.
  ///
  /// In en, this message translates to:
  /// **'Excess person'**
  String get inventoryReportExcessPersonLabel;

  /// No description provided for @inventoryCountStatusMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get inventoryCountStatusMissing;

  /// No description provided for @inventoryCountStatusPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get inventoryCountStatusPresent;

  /// No description provided for @inventoryCountStatusTransferred.
  ///
  /// In en, this message translates to:
  /// **'Present (mismatch)'**
  String get inventoryCountStatusTransferred;

  /// No description provided for @inventoryCountStatusExcess.
  ///
  /// In en, this message translates to:
  /// **'Excess'**
  String get inventoryCountStatusExcess;

  /// No description provided for @inventoryCountStatusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get inventoryCountStatusNew;

  /// No description provided for @inventoryCountStatusFoundInOtherCompany.
  ///
  /// In en, this message translates to:
  /// **'Found in another company'**
  String get inventoryCountStatusFoundInOtherCompany;

  /// No description provided for @inventoryCountStatusAmbiguousCode.
  ///
  /// In en, this message translates to:
  /// **'Ambiguous code'**
  String get inventoryCountStatusAmbiguousCode;

  /// No description provided for @inventoryCountStatusSoldDuringInventory.
  ///
  /// In en, this message translates to:
  /// **'Sold during inventory'**
  String get inventoryCountStatusSoldDuringInventory;

  /// No description provided for @inventoryCountStatusPurchasedDuringInventory.
  ///
  /// In en, this message translates to:
  /// **'Purchased during inventory'**
  String get inventoryCountStatusPurchasedDuringInventory;

  /// No description provided for @inventoryCountStatusExcessDescription.
  ///
  /// In en, this message translates to:
  /// **'An item found during count that does not belong to the sheet.'**
  String get inventoryCountStatusExcessDescription;

  /// No description provided for @inventoryCountStatusNewDescription.
  ///
  /// In en, this message translates to:
  /// **'An item added as new because it was not present in the source data.'**
  String get inventoryCountStatusNewDescription;

  /// No description provided for @inventoryCountStatusFoundInOtherCompanyDescription.
  ///
  /// In en, this message translates to:
  /// **'An item physically found but assigned to another company.'**
  String get inventoryCountStatusFoundInOtherCompanyDescription;

  /// No description provided for @inventoryCountStatusAmbiguousCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'The barcode or identifier does not uniquely identify the item.'**
  String get inventoryCountStatusAmbiguousCodeDescription;

  /// No description provided for @inventoryCountStatusSoldDuringInventoryDescription.
  ///
  /// In en, this message translates to:
  /// **'The item was sold during the inventory process.'**
  String get inventoryCountStatusSoldDuringInventoryDescription;

  /// No description provided for @inventoryCountStatusPurchasedDuringInventoryDescription.
  ///
  /// In en, this message translates to:
  /// **'The item was purchased during the inventory process.'**
  String get inventoryCountStatusPurchasedDuringInventoryDescription;

  /// No description provided for @inventoryAssetStateMissingDescription.
  ///
  /// In en, this message translates to:
  /// **'No current state information is available for this item.'**
  String get inventoryAssetStateMissingDescription;

  /// No description provided for @inventoryAssetStateUnapprovedDescription.
  ///
  /// In en, this message translates to:
  /// **'The item status has not been approved yet.'**
  String get inventoryAssetStateUnapprovedDescription;

  /// No description provided for @inventoryAssetStateInUseDescription.
  ///
  /// In en, this message translates to:
  /// **'The item is currently in use.'**
  String get inventoryAssetStateInUseDescription;

  /// No description provided for @inventoryAssetStateDisposedDescription.
  ///
  /// In en, this message translates to:
  /// **'The item has been disposed.'**
  String get inventoryAssetStateDisposedDescription;

  /// No description provided for @inventoryAssetStateSoldDescription.
  ///
  /// In en, this message translates to:
  /// **'The item has been sold.'**
  String get inventoryAssetStateSoldDescription;

  /// No description provided for @inventoryAssetStateTransferredDescription.
  ///
  /// In en, this message translates to:
  /// **'The item has been transferred.'**
  String get inventoryAssetStateTransferredDescription;

  /// No description provided for @inventoryAssetStateNotInAssetsDescription.
  ///
  /// In en, this message translates to:
  /// **'The item is not present in the current register.'**
  String get inventoryAssetStateNotInAssetsDescription;

  /// No description provided for @inventoryCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New inventory'**
  String get inventoryCreateTitle;

  /// No description provided for @inventoryCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new inventory record.'**
  String get inventoryCreateSubtitle;

  /// No description provided for @inventoryCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Inventory has been created.'**
  String get inventoryCreatedMessage;

  /// No description provided for @inventoryLoadCompaniesErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load companies'**
  String get inventoryLoadCompaniesErrorTitle;

  /// No description provided for @inventoryCompaniesListEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Companies list is empty.'**
  String get inventoryCompaniesListEmptyMessage;

  /// No description provided for @inventorySelectCompanyHint.
  ///
  /// In en, this message translates to:
  /// **'Select companies/branches'**
  String get inventorySelectCompanyHint;

  /// No description provided for @inventoryNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get inventoryNumber;

  /// No description provided for @inventoryNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Number is required.'**
  String get inventoryNumberRequired;

  /// No description provided for @inventorySearchPersonHint.
  ///
  /// In en, this message translates to:
  /// **'Search person...'**
  String get inventorySearchPersonHint;

  /// No description provided for @inventoryRemarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get inventoryRemarks;

  /// No description provided for @inventoryFoundInOtherSheet.
  ///
  /// In en, this message translates to:
  /// **'Found in other sheet'**
  String get inventoryFoundInOtherSheet;

  /// No description provided for @inventoryOptionalRemarks.
  ///
  /// In en, this message translates to:
  /// **'Optional remarks'**
  String get inventoryOptionalRemarks;

  /// No description provided for @inventoryCreateDatesInfo.
  ///
  /// In en, this message translates to:
  /// **'Start and end dates are set automatically to today. Status remains backend default.'**
  String get inventoryCreateDatesInfo;

  /// No description provided for @inventorySelectCompanyError.
  ///
  /// In en, this message translates to:
  /// **'Select at least one branch.'**
  String get inventorySelectCompanyError;

  /// No description provided for @inventorySelectMinTwoCommissionUsers.
  ///
  /// In en, this message translates to:
  /// **'Select at least two commission users.'**
  String get inventorySelectMinTwoCommissionUsers;

  /// No description provided for @inventoryCommissionSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Commission has been saved.'**
  String get inventoryCommissionSavedMessage;

  /// No description provided for @inventoryNewSheet.
  ///
  /// In en, this message translates to:
  /// **'New sheet'**
  String get inventoryNewSheet;

  /// No description provided for @inventorySheetCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sheet has been created.'**
  String get inventorySheetCreatedMessage;

  /// No description provided for @inventoryCommissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory commission'**
  String get inventoryCommissionTitle;

  /// No description provided for @inventoryEditSheetDatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit sheet dates'**
  String get inventoryEditSheetDatesTitle;

  /// No description provided for @inventoryEditSheetDatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change start and end dates without opening details.'**
  String get inventoryEditSheetDatesSubtitle;

  /// No description provided for @inventoryStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get inventoryStartDateLabel;

  /// No description provided for @inventoryStartDateHelper.
  ///
  /// In en, this message translates to:
  /// **'Set the sheet start day and time.'**
  String get inventoryStartDateHelper;

  /// No description provided for @inventoryStartTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get inventoryStartTimeLabel;

  /// No description provided for @inventoryEndDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get inventoryEndDateLabel;

  /// No description provided for @inventoryEndDateHelper.
  ///
  /// In en, this message translates to:
  /// **'Set the sheet end day and time.'**
  String get inventoryEndDateHelper;

  /// No description provided for @inventoryEndTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get inventoryEndTimeLabel;

  /// No description provided for @inventoryStartDateRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Start date is required.'**
  String get inventoryStartDateRequiredError;

  /// No description provided for @inventoryEndDateBeforeStartError.
  ///
  /// In en, this message translates to:
  /// **'End date cannot be earlier than start date.'**
  String get inventoryEndDateBeforeStartError;

  /// No description provided for @inventoryPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get inventoryPrint;

  /// No description provided for @inventoryDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get inventoryDates;

  /// No description provided for @inventoryStatusSpisuFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Count status (options)'**
  String get inventoryStatusSpisuFieldLabel;

  /// No description provided for @inventoryStatusSpisuNoOptions.
  ///
  /// In en, this message translates to:
  /// **'No selected options'**
  String get inventoryStatusSpisuNoOptions;

  /// No description provided for @inventoryStatusSpisuYesMismatch.
  ///
  /// In en, this message translates to:
  /// **'Yes (mismatch)'**
  String get inventoryStatusSpisuYesMismatch;

  /// No description provided for @inventoryStatusSpisuExcess.
  ///
  /// In en, this message translates to:
  /// **'Excess'**
  String get inventoryStatusSpisuExcess;

  /// No description provided for @inventoryChooseCompanyTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose company'**
  String get inventoryChooseCompanyTitle;

  /// No description provided for @inventoryChooseCompanyOutsideMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a company outside this inventory scope, then the exact location.'**
  String get inventoryChooseCompanyOutsideMessage;

  /// No description provided for @inventoryChooseCompanyInsideMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a company covered by this inventory, then the exact location.'**
  String get inventoryChooseCompanyInsideMessage;

  /// No description provided for @inventoryInventoryStateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get inventoryInventoryStateAvailable;

  /// No description provided for @inventoryChangeItemStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Count status'**
  String get inventoryChangeItemStatusTitle;

  /// No description provided for @inventoryChangeItemResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Count result'**
  String get inventoryChangeItemResultTitle;

  /// No description provided for @inventoryChangeItemResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get inventoryChangeItemResultLabel;

  /// No description provided for @inventoryChangeItemAdditionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional findings'**
  String get inventoryChangeItemAdditionalTitle;

  /// No description provided for @inventoryChangeItemMismatchDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Mismatch data'**
  String get inventoryChangeItemMismatchDataTitle;

  /// No description provided for @inventoryChangeItemCorrectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data correction'**
  String get inventoryChangeItemCorrectionTitle;

  /// No description provided for @inventoryChangeItemChooseResultHint.
  ///
  /// In en, this message translates to:
  /// **'Choose count result'**
  String get inventoryChangeItemChooseResultHint;

  /// No description provided for @inventoryChangeItemTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Change type'**
  String get inventoryChangeItemTypeLabel;

  /// No description provided for @inventoryDeleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete sheet item'**
  String get inventoryDeleteItemTitle;

  /// No description provided for @inventoryDeleteItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This operation removes the selected item from the current sheet.'**
  String get inventoryDeleteItemSubtitle;

  /// No description provided for @inventoryDeleteItemDetailsMessage.
  ///
  /// In en, this message translates to:
  /// **'Item ID: {id}\nRegister number: {register}\nName: {name}'**
  String inventoryDeleteItemDetailsMessage(
    Object id,
    Object register,
    Object name,
  );

  /// No description provided for @inventoryDeleteItemSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Sheet item has been deleted.'**
  String get inventoryDeleteItemSuccessMessage;

  /// No description provided for @inventoryDeleteItemUnlockLabel.
  ///
  /// In en, this message translates to:
  /// **'Deletion confirmation'**
  String get inventoryDeleteItemUnlockLabel;

  /// No description provided for @inventoryDeleteStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete fixed asset'**
  String get inventoryDeleteStockTitle;

  /// No description provided for @inventoryDeleteStockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This operation removes the record from the fixed assets snapshot.'**
  String get inventoryDeleteStockSubtitle;

  /// No description provided for @inventoryDeleteStockConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record?'**
  String get inventoryDeleteStockConfirmTitle;

  /// No description provided for @inventoryDeleteStockConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Record ID: {id}\nRegister number: {register}\nName: {name}'**
  String inventoryDeleteStockConfirmBody(int id, Object register, Object name);

  /// No description provided for @inventoryDeleteStockHelper.
  ///
  /// In en, this message translates to:
  /// **'Retype the register number and full name. Letter case does not matter.'**
  String get inventoryDeleteStockHelper;

  /// No description provided for @inventoryDeleteStockRegisterLabel.
  ///
  /// In en, this message translates to:
  /// **'Register number'**
  String get inventoryDeleteStockRegisterLabel;

  /// No description provided for @inventoryDeleteStockNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get inventoryDeleteStockNameLabel;

  /// No description provided for @inventoryDeleteStockSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Fixed asset has been removed from the snapshot.'**
  String get inventoryDeleteStockSuccessMessage;

  /// No description provided for @inventorySheetDatesSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sheet dates have been saved.'**
  String get inventorySheetDatesSavedMessage;

  /// No description provided for @inventorySheetDateSearchHint.
  ///
  /// In en, this message translates to:
  /// **'sheet name, location'**
  String get inventorySheetDateSearchHint;

  /// No description provided for @inventorySheetStatusesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sheet statuses'**
  String get inventorySheetStatusesTitle;

  /// No description provided for @inventorySheetStatusesCommissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get inventorySheetStatusesCommissionTitle;

  /// No description provided for @inventorySheetStatusesCommissionEmpty.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get inventorySheetStatusesCommissionEmpty;

  /// No description provided for @inventorySheetManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit sheet dates'**
  String get inventorySheetManagementTitle;

  /// No description provided for @inventorySheetManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change start and end dates without editing the commission.'**
  String get inventorySheetManagementSubtitle;

  /// No description provided for @inventorySheetStartTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get inventorySheetStartTimeLabel;

  /// No description provided for @inventorySheetEndTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get inventorySheetEndTimeLabel;

  /// No description provided for @frameworkGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Framework Components Gallery'**
  String get frameworkGalleryTitle;

  /// No description provided for @frameworkActionToast.
  ///
  /// In en, this message translates to:
  /// **'Action: {label}'**
  String frameworkActionToast(Object label);

  /// No description provided for @frameworkNewDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'New document'**
  String get frameworkNewDocumentTitle;

  /// No description provided for @frameworkNewDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A right-side sheet variant.'**
  String get frameworkNewDocumentSubtitle;

  /// No description provided for @frameworkClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get frameworkClose;

  /// No description provided for @frameworkError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get frameworkError;

  /// No description provided for @frameworkSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get frameworkSave;

  /// No description provided for @frameworkNewDocumentTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'New document'**
  String get frameworkNewDocumentTemplateTitle;

  /// No description provided for @frameworkNewDocumentTemplateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Template for BLoC initial/loading/loaded/error.'**
  String get frameworkNewDocumentTemplateSubtitle;

  /// No description provided for @frameworkDocumentDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Document data'**
  String get frameworkDocumentDataTitle;

  /// No description provided for @frameworkDocumentNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Inventory Q2'**
  String get frameworkDocumentNameHint;

  /// No description provided for @frameworkDocumentStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get frameworkDocumentStatusOpen;

  /// No description provided for @frameworkDocumentStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get frameworkDocumentStatusClosed;

  /// No description provided for @frameworkDataTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Table'**
  String get frameworkDataTableTitle;

  /// No description provided for @frameworkDataTableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Table with sorting and loading/error/empty states.'**
  String get frameworkDataTableSubtitle;

  /// No description provided for @frameworkStressTest.
  ///
  /// In en, this message translates to:
  /// **'Stress test 100x4000'**
  String get frameworkStressTest;

  /// No description provided for @frameworkLoadingDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading data'**
  String get frameworkLoadingDataTitle;

  /// No description provided for @frameworkLoadingDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Fetching records, this will take a moment.'**
  String get frameworkLoadingDataMessage;

  /// No description provided for @frameworkLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get frameworkLoadErrorTitle;

  /// No description provided for @frameworkName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get frameworkName;

  /// No description provided for @frameworkStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get frameworkStatus;

  /// No description provided for @frameworkItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get frameworkItems;

  /// No description provided for @frameworkOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get frameworkOwner;

  /// No description provided for @frameworkListTilesTitle.
  ///
  /// In en, this message translates to:
  /// **'List Tiles'**
  String get frameworkListTilesTitle;

  /// No description provided for @frameworkListTilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shared AppListTile and AppExpansionListTile for menus/lists.'**
  String get frameworkListTilesSubtitle;

  /// No description provided for @frameworkInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get frameworkInbox;

  /// No description provided for @frameworkReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get frameworkReports;

  /// No description provided for @frameworkDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get frameworkDaily;

  /// No description provided for @frameworkNewItemsCount.
  ///
  /// In en, this message translates to:
  /// **'12 new items'**
  String get frameworkNewItemsCount;

  /// No description provided for @frameworkFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get frameworkFavorites;

  /// No description provided for @frameworkAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics views'**
  String get frameworkAnalytics;

  /// No description provided for @frameworkDailyReport.
  ///
  /// In en, this message translates to:
  /// **'Daily report'**
  String get frameworkDailyReport;

  /// No description provided for @frameworkMonthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly report'**
  String get frameworkMonthlyReport;

  /// No description provided for @frameworkDropdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Dropdown'**
  String get frameworkDropdownTitle;

  /// No description provided for @frameworkDropdownSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Basic dropdown based on theme and shared styles.'**
  String get frameworkDropdownSubtitle;

  /// No description provided for @frameworkDropdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get frameworkDropdownLabel;

  /// No description provided for @frameworkToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get frameworkToday;

  /// No description provided for @frameworkThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get frameworkThisWeek;

  /// No description provided for @frameworkOuterLabel.
  ///
  /// In en, this message translates to:
  /// **'Outer label'**
  String get frameworkOuterLabel;

  /// No description provided for @frameworkStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get frameworkStatusLabel;

  /// No description provided for @frameworkChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get frameworkChoose;

  /// No description provided for @frameworkToggleLoading.
  ///
  /// In en, this message translates to:
  /// **'Show loading'**
  String get frameworkToggleLoading;

  /// No description provided for @frameworkHideLoading.
  ///
  /// In en, this message translates to:
  /// **'Hide loading'**
  String get frameworkHideLoading;

  /// No description provided for @frameworkShowError.
  ///
  /// In en, this message translates to:
  /// **'Show error'**
  String get frameworkShowError;

  /// No description provided for @frameworkHideError.
  ///
  /// In en, this message translates to:
  /// **'Hide error'**
  String get frameworkHideError;

  /// No description provided for @frameworkShowTable.
  ///
  /// In en, this message translates to:
  /// **'Show table'**
  String get frameworkShowTable;

  /// No description provided for @frameworkRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get frameworkRetry;

  /// No description provided for @frameworkLoadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading data'**
  String get frameworkLoadingText;

  /// No description provided for @frameworkLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Fetching records, this will take a moment.'**
  String get frameworkLoadingMessage;

  /// No description provided for @frameworkErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get frameworkErrorTitle;

  /// No description provided for @frameworkSearchApiError.
  ///
  /// In en, this message translates to:
  /// **'API error: timeout while fetching the list.'**
  String get frameworkSearchApiError;

  /// No description provided for @frameworkListTileInboxCount.
  ///
  /// In en, this message translates to:
  /// **'12 new items'**
  String get frameworkListTileInboxCount;

  /// No description provided for @frameworkListTileFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get frameworkListTileFavorites;

  /// No description provided for @frameworkListTileAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics views'**
  String get frameworkListTileAnalytics;

  /// No description provided for @frameworkListTileDailyReport.
  ///
  /// In en, this message translates to:
  /// **'Daily report'**
  String get frameworkListTileDailyReport;

  /// No description provided for @frameworkListTileMonthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly report'**
  String get frameworkListTileMonthlyReport;

  /// No description provided for @frameworkTableRowHover.
  ///
  /// In en, this message translates to:
  /// **'Hover: {name}'**
  String frameworkTableRowHover(Object name);

  /// No description provided for @frameworkTableRowTap.
  ///
  /// In en, this message translates to:
  /// **'Tapped row #{index}: {name} | {status} | {count} | {owner}'**
  String frameworkTableRowTap(
    int index,
    Object name,
    Object status,
    Object count,
    Object owner,
  );

  /// No description provided for @frameworkTableName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get frameworkTableName;

  /// No description provided for @frameworkTableStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get frameworkTableStatus;

  /// No description provided for @frameworkTableItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get frameworkTableItems;

  /// No description provided for @frameworkTableOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get frameworkTableOwner;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @ordersBody.
  ///
  /// In en, this message translates to:
  /// **'This is the second feature running in the same app.'**
  String get ordersBody;

  /// No description provided for @ordersInitialRoute.
  ///
  /// In en, this message translates to:
  /// **'Initial route: /orders'**
  String get ordersInitialRoute;

  /// No description provided for @ordersUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID: n/d'**
  String get ordersUserId;

  /// No description provided for @ordersUser.
  ///
  /// In en, this message translates to:
  /// **'User: n/d'**
  String get ordersUser;

  /// No description provided for @ordersBearerPassed.
  ///
  /// In en, this message translates to:
  /// **'Bearer passed: n/d'**
  String get ordersBearerPassed;

  /// No description provided for @bhpModuleTitle.
  ///
  /// In en, this message translates to:
  /// **'BHP'**
  String get bhpModuleTitle;

  /// No description provided for @bhpSidebarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Employee, position and equipment workflow'**
  String get bhpSidebarSubtitle;

  /// No description provided for @bhpSectionDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get bhpSectionDashboard;

  /// No description provided for @bhpSectionOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations history'**
  String get bhpSectionOperations;

  /// No description provided for @bhpSectionUsers.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get bhpSectionUsers;

  /// No description provided for @bhpSectionPositions.
  ///
  /// In en, this message translates to:
  /// **'Positions'**
  String get bhpSectionPositions;

  /// No description provided for @bhpSectionEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get bhpSectionEquipment;

  /// No description provided for @bhpRefreshAction.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get bhpRefreshAction;

  /// No description provided for @bhpDashboardSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'BHP dashboard'**
  String get bhpDashboardSectionTitle;

  /// No description provided for @bhpDashboardSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Due-date alerts and basic operational signals from the BHP backend.'**
  String get bhpDashboardSectionSubtitle;

  /// No description provided for @bhpDashboardErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard'**
  String get bhpDashboardErrorTitle;

  /// No description provided for @bhpDashboardRefreshingLabel.
  ///
  /// In en, this message translates to:
  /// **'Refreshing'**
  String get bhpDashboardRefreshingLabel;

  /// No description provided for @bhpDashboardRefreshInProgress.
  ///
  /// In en, this message translates to:
  /// **'Refreshing data.'**
  String get bhpDashboardRefreshInProgress;

  /// No description provided for @bhpDashboardRetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get bhpDashboardRetryLabel;

  /// No description provided for @bhpDashboardOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get bhpDashboardOverdueTitle;

  /// No description provided for @bhpDashboardOverdueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active issues that already require action.'**
  String get bhpDashboardOverdueSubtitle;

  /// No description provided for @bhpDashboardUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get bhpDashboardUpcomingTitle;

  /// No description provided for @bhpDashboardUpcomingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts in the next {months} months.'**
  String bhpDashboardUpcomingSubtitle(int months);

  /// No description provided for @bhpDashboardSnapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Snapshot'**
  String get bhpDashboardSnapshotTitle;

  /// No description provided for @bhpDashboardSnapshotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard generation timestamp.'**
  String get bhpDashboardSnapshotSubtitle;

  /// No description provided for @bhpDashboardOverdueTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Overdue issues'**
  String get bhpDashboardOverdueTableTitle;

  /// No description provided for @bhpDashboardOverdueTableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Records that already exceeded their usage term.'**
  String get bhpDashboardOverdueTableSubtitle;

  /// No description provided for @bhpDashboardNoOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'No overdue issues'**
  String get bhpDashboardNoOverdueTitle;

  /// No description provided for @bhpDashboardNoOverdueMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no overdue items right now.'**
  String get bhpDashboardNoOverdueMessage;

  /// No description provided for @bhpDashboardUpcomingTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Issues approaching due date'**
  String get bhpDashboardUpcomingTableTitle;

  /// No description provided for @bhpDashboardUpcomingTableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Items that will soon require replacement or closure.'**
  String get bhpDashboardUpcomingTableSubtitle;

  /// No description provided for @bhpDashboardNoUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming alerts'**
  String get bhpDashboardNoUpcomingTitle;

  /// No description provided for @bhpDashboardNoUpcomingMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no alerts in the selected time window right now.'**
  String get bhpDashboardNoUpcomingMessage;

  /// No description provided for @bhpUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'BHP employees'**
  String get bhpUsersTitle;

  /// No description provided for @bhpUsersSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Employee cards and their current status.'**
  String get bhpUsersSectionSubtitle;

  /// No description provided for @bhpUsersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active: {active}, archived: {archived}'**
  String bhpUsersSubtitle(int active, int archived);

  /// No description provided for @bhpUsersErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load employees'**
  String get bhpUsersErrorTitle;

  /// No description provided for @bhpUsersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No employees'**
  String get bhpUsersEmptyTitle;

  /// No description provided for @bhpUsersEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'The BHP employee list is empty.'**
  String get bhpUsersEmptyMessage;

  /// No description provided for @bhpUsersNoSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get bhpUsersNoSearchResultsTitle;

  /// No description provided for @bhpUsersNoSearchResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'No employee matches the current phrase. Clear the search or change the query.'**
  String get bhpUsersNoSearchResultsMessage;

  /// No description provided for @bhpUsersNoActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no active employees in the list right now.'**
  String get bhpUsersNoActiveMessage;

  /// No description provided for @bhpUsersNoArchivedMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no archived employees in the list right now.'**
  String get bhpUsersNoArchivedMessage;

  /// No description provided for @bhpUsersSearchResultsSummary.
  ///
  /// In en, this message translates to:
  /// **'Results: {visible} of {total}'**
  String bhpUsersSearchResultsSummary(Object visible, Object total);

  /// No description provided for @bhpUsersClearSearchAction.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get bhpUsersClearSearchAction;

  /// No description provided for @bhpUsersBulkSelectLabel.
  ///
  /// In en, this message translates to:
  /// **'Bulk Actions'**
  String get bhpUsersBulkSelectLabel;

  /// No description provided for @bhpUsersBulkSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Selected 1 employee} other{Selected {count} employees}}'**
  String bhpUsersBulkSelectedCount(int count);

  /// No description provided for @bhpUsersBulkChangePositionAction.
  ///
  /// In en, this message translates to:
  /// **'Change Position'**
  String get bhpUsersBulkChangePositionAction;

  /// No description provided for @bhpUsersBulkChangePositionTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk Position Change'**
  String get bhpUsersBulkChangePositionTitle;

  /// No description provided for @bhpUsersBulkChangePositionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Change position for {count} employees'**
  String bhpUsersBulkChangePositionConfirm(int count);

  /// No description provided for @bhpUsersBulkSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Successfully changed position for {count} employees.'**
  String bhpUsersBulkSuccessMessage(int count);

  /// No description provided for @bhpUsersDataQualityLabel.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get bhpUsersDataQualityLabel;

  /// No description provided for @bhpUsersDataQualityComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get bhpUsersDataQualityComplete;

  /// No description provided for @bhpUsersDataQualityMissingPosition.
  ///
  /// In en, this message translates to:
  /// **'Missing position'**
  String get bhpUsersDataQualityMissingPosition;

  /// No description provided for @bhpUsersDataQualityMissingPesel.
  ///
  /// In en, this message translates to:
  /// **'Missing PESEL'**
  String get bhpUsersDataQualityMissingPesel;

  /// No description provided for @bhpUsersDataQualityMissingPhone.
  ///
  /// In en, this message translates to:
  /// **'Missing phone'**
  String get bhpUsersDataQualityMissingPhone;

  /// No description provided for @bhpUsersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, registry number or position...'**
  String get bhpUsersSearchHint;

  /// No description provided for @bhpPositionsTitle.
  ///
  /// In en, this message translates to:
  /// **'BHP positions'**
  String get bhpPositionsTitle;

  /// No description provided for @bhpPositionsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Positions dictionary used in employee cards.'**
  String get bhpPositionsSectionSubtitle;

  /// No description provided for @bhpPositionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active: {active}, total: {total}'**
  String bhpPositionsSubtitle(int active, int total);

  /// No description provided for @bhpPositionsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load positions'**
  String get bhpPositionsErrorTitle;

  /// No description provided for @bhpPositionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No positions'**
  String get bhpPositionsEmptyTitle;

  /// No description provided for @bhpPositionsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'The positions dictionary does not contain data yet.'**
  String get bhpPositionsEmptyMessage;

  /// No description provided for @bhpPositionsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or notes...'**
  String get bhpPositionsSearchHint;

  /// No description provided for @bhpPositionsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bhpPositionsFilterAll;

  /// No description provided for @bhpPositionsFilterInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get bhpPositionsFilterInactive;

  /// No description provided for @bhpPositionsRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get bhpPositionsRestoreAction;

  /// No description provided for @bhpPositionsRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore position'**
  String get bhpPositionsRestoreTitle;

  /// No description provided for @bhpPositionsRestoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Position {name} will be re-enabled in the active dictionary.'**
  String bhpPositionsRestoreMessage(Object name);

  /// No description provided for @bhpPositionsRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Position {name} has been restored.'**
  String bhpPositionsRestoreSuccess(Object name);

  /// No description provided for @bhpPositionsAddAndStandardAction.
  ///
  /// In en, this message translates to:
  /// **'Add and standard'**
  String get bhpPositionsAddAndStandardAction;

  /// No description provided for @bhpPositionsEditStandardAction.
  ///
  /// In en, this message translates to:
  /// **'Edit standard'**
  String get bhpPositionsEditStandardAction;

  /// No description provided for @bhpPositionsOpenStandardAction.
  ///
  /// In en, this message translates to:
  /// **'Equipment standard'**
  String get bhpPositionsOpenStandardAction;

  /// No description provided for @bhpPositionStandardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Position equipment standard'**
  String get bhpPositionStandardsTitle;

  /// No description provided for @bhpPositionStandardsLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load position standard'**
  String get bhpPositionStandardsLoadErrorTitle;

  /// No description provided for @bhpPositionStandardsPositionLabel.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get bhpPositionStandardsPositionLabel;

  /// No description provided for @bhpPositionStandardsItemsCount.
  ///
  /// In en, this message translates to:
  /// **'Items: {count}'**
  String bhpPositionStandardsItemsCount(int count);

  /// No description provided for @bhpPositionStandardsActiveCount.
  ///
  /// In en, this message translates to:
  /// **'Active: {count}'**
  String bhpPositionStandardsActiveCount(int count);

  /// No description provided for @bhpPositionStandardsEquipmentPoolCount.
  ///
  /// In en, this message translates to:
  /// **'Available cards: {count}'**
  String bhpPositionStandardsEquipmentPoolCount(int count);

  /// No description provided for @bhpPositionStandardsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No standard items'**
  String get bhpPositionStandardsEmptyTitle;

  /// No description provided for @bhpPositionStandardsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This position has no assigned equipment yet.'**
  String get bhpPositionStandardsEmptyMessage;

  /// No description provided for @bhpPositionStandardsAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get bhpPositionStandardsAddAction;

  /// No description provided for @bhpPositionStandardsArchiveAction.
  ///
  /// In en, this message translates to:
  /// **'Set inactive'**
  String get bhpPositionStandardsArchiveAction;

  /// No description provided for @bhpPositionStandardsArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Set standard item as inactive'**
  String get bhpPositionStandardsArchiveTitle;

  /// No description provided for @bhpPositionStandardsArchiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Item {symbol} will be set inactive only on this position standard card.'**
  String bhpPositionStandardsArchiveMessage(Object symbol);

  /// No description provided for @bhpPositionStandardsArchiveSuccess.
  ///
  /// In en, this message translates to:
  /// **'The standard item has been set as inactive.'**
  String get bhpPositionStandardsArchiveSuccess;

  /// No description provided for @bhpPositionStandardsRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Set active'**
  String get bhpPositionStandardsRestoreAction;

  /// No description provided for @bhpPositionStandardsRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Set standard item as active'**
  String get bhpPositionStandardsRestoreTitle;

  /// No description provided for @bhpPositionStandardsRestoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Item {symbol} will be set active only on this position standard card.'**
  String bhpPositionStandardsRestoreMessage(Object symbol);

  /// No description provided for @bhpPositionStandardsRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'The standard item has been set as active.'**
  String get bhpPositionStandardsRestoreSuccess;

  /// No description provided for @bhpPositionStandardsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete standard item'**
  String get bhpPositionStandardsDeleteTitle;

  /// No description provided for @bhpPositionStandardsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Item {symbol} will be permanently removed only from this position standard card.'**
  String bhpPositionStandardsDeleteMessage(Object symbol);

  /// No description provided for @bhpPositionStandardsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'The standard item has been deleted.'**
  String get bhpPositionStandardsDeleteSuccess;

  /// No description provided for @bhpPositionStandardEditorCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Add standard item'**
  String get bhpPositionStandardEditorCreateTitle;

  /// No description provided for @bhpPositionStandardEditorEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit standard item'**
  String get bhpPositionStandardEditorEditTitle;

  /// No description provided for @bhpPositionStandardEditorEquipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Equipment card'**
  String get bhpPositionStandardEditorEquipmentLabel;

  /// No description provided for @bhpPositionStandardEditorEquipmentHint.
  ///
  /// In en, this message translates to:
  /// **'Search equipment card...'**
  String get bhpPositionStandardEditorEquipmentHint;

  /// No description provided for @bhpPositionStandardEditorEquipmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Equipment card is required.'**
  String get bhpPositionStandardEditorEquipmentRequired;

  /// No description provided for @bhpPositionStandardEditorPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period (months)'**
  String get bhpPositionStandardEditorPeriodLabel;

  /// No description provided for @bhpPositionStandardEditorQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get bhpPositionStandardEditorQuantityLabel;

  /// No description provided for @bhpPositionStandardEditorCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'The standard item has been added.'**
  String get bhpPositionStandardEditorCreateSuccess;

  /// No description provided for @bhpPositionStandardEditorEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'The standard item has been saved.'**
  String get bhpPositionStandardEditorEditSuccess;

  /// No description provided for @bhpEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Equipment catalog'**
  String get bhpEquipmentTitle;

  /// No description provided for @bhpEquipmentSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog items used in BHP standards and issues.'**
  String get bhpEquipmentSectionSubtitle;

  /// No description provided for @bhpEquipmentFilterActiveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Shows only active equipment cards.'**
  String get bhpEquipmentFilterActiveTooltip;

  /// No description provided for @bhpEquipmentFilterInactiveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Shows only inactive equipment cards.'**
  String get bhpEquipmentFilterInactiveTooltip;

  /// No description provided for @bhpEquipmentFilterAllTooltip.
  ///
  /// In en, this message translates to:
  /// **'Shows all equipment cards.'**
  String get bhpEquipmentFilterAllTooltip;

  /// No description provided for @bhpEquipmentStatusActiveTooltip.
  ///
  /// In en, this message translates to:
  /// **'The equipment card is active and can be used in standards.'**
  String get bhpEquipmentStatusActiveTooltip;

  /// No description provided for @bhpEquipmentStatusInactiveTooltip.
  ///
  /// In en, this message translates to:
  /// **'The equipment card is inactive and is excluded from new issues.'**
  String get bhpEquipmentStatusInactiveTooltip;

  /// No description provided for @bhpEquipmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active: {active}, total: {total}'**
  String bhpEquipmentSubtitle(int active, int total);

  /// No description provided for @bhpEquipmentErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load equipment'**
  String get bhpEquipmentErrorTitle;

  /// No description provided for @bhpEquipmentEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No equipment'**
  String get bhpEquipmentEmptyTitle;

  /// No description provided for @bhpEquipmentEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'The equipment catalog does not contain data yet.'**
  String get bhpEquipmentEmptyMessage;

  /// No description provided for @bhpEquipmentSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by symbol, name or unit...'**
  String get bhpEquipmentSearchHint;

  /// No description provided for @bhpEquipmentSetInactiveAction.
  ///
  /// In en, this message translates to:
  /// **'Set inactive'**
  String get bhpEquipmentSetInactiveAction;

  /// No description provided for @bhpEquipmentSetInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Set card as inactive'**
  String get bhpEquipmentSetInactiveTitle;

  /// No description provided for @bhpEquipmentSetInactiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Card {symbol} will be disabled in the active equipment catalog.'**
  String bhpEquipmentSetInactiveMessage(Object symbol);

  /// No description provided for @bhpEquipmentSetInactiveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card {symbol} has been set as inactive.'**
  String bhpEquipmentSetInactiveSuccess(Object symbol);

  /// No description provided for @bhpEquipmentSetActiveAction.
  ///
  /// In en, this message translates to:
  /// **'Set active'**
  String get bhpEquipmentSetActiveAction;

  /// No description provided for @bhpEquipmentSetActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Set card as active'**
  String get bhpEquipmentSetActiveTitle;

  /// No description provided for @bhpEquipmentSetActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Card {symbol} will return to the active equipment catalog.'**
  String bhpEquipmentSetActiveMessage(Object symbol);

  /// No description provided for @bhpEquipmentSetActiveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card {symbol} has been set as active.'**
  String bhpEquipmentSetActiveSuccess(Object symbol);

  /// No description provided for @bhpEquipmentImpactSetInactiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Setting this card as inactive will disable all active assignments of this equipment across positions.'**
  String get bhpEquipmentImpactSetInactiveDescription;

  /// No description provided for @bhpEquipmentImpactSetActiveDescription.
  ///
  /// In en, this message translates to:
  /// **'You can activate the card globally only, or additionally select which inactive position assignments should be restored.'**
  String get bhpEquipmentImpactSetActiveDescription;

  /// No description provided for @bhpEquipmentImpactActiveLinksCount.
  ///
  /// In en, this message translates to:
  /// **'Active assignments: {count}'**
  String bhpEquipmentImpactActiveLinksCount(int count);

  /// No description provided for @bhpEquipmentImpactInactiveLinksCount.
  ///
  /// In en, this message translates to:
  /// **'Inactive assignments: {count}'**
  String bhpEquipmentImpactInactiveLinksCount(int count);

  /// No description provided for @bhpEquipmentImpactSelectedLinksCount.
  ///
  /// In en, this message translates to:
  /// **'To restore: {count}'**
  String bhpEquipmentImpactSelectedLinksCount(int count);

  /// No description provided for @bhpEquipmentImpactInactiveSection.
  ///
  /// In en, this message translates to:
  /// **'Positions that will be disabled'**
  String get bhpEquipmentImpactInactiveSection;

  /// No description provided for @bhpEquipmentImpactActiveSection.
  ///
  /// In en, this message translates to:
  /// **'Inactive assignments available to restore'**
  String get bhpEquipmentImpactActiveSection;

  /// No description provided for @bhpEquipmentImpactActiveHint.
  ///
  /// In en, this message translates to:
  /// **'Select only the assignments that should return together with global card activation.'**
  String get bhpEquipmentImpactActiveHint;

  /// No description provided for @bhpEquipmentImpactInactiveEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No active links'**
  String get bhpEquipmentImpactInactiveEmptyTitle;

  /// No description provided for @bhpEquipmentImpactInactiveEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This card currently has no active standard assignments, so the status change will affect only the global catalog.'**
  String get bhpEquipmentImpactInactiveEmptyMessage;

  /// No description provided for @bhpEquipmentImpactActiveEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No assignments to restore'**
  String get bhpEquipmentImpactActiveEmptyTitle;

  /// No description provided for @bhpEquipmentImpactActiveEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'The card can be activated globally without restoring any position assignments.'**
  String get bhpEquipmentImpactActiveEmptyMessage;

  /// No description provided for @bhpSearchAlertsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by employee, position or equipment...'**
  String get bhpSearchAlertsHint;

  /// No description provided for @bhpTableRegistryNumber.
  ///
  /// In en, this message translates to:
  /// **'Reg. no.'**
  String get bhpTableRegistryNumber;

  /// No description provided for @bhpTableEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get bhpTableEmployee;

  /// No description provided for @bhpTablePosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get bhpTablePosition;

  /// No description provided for @bhpTableEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get bhpTableEquipment;

  /// No description provided for @bhpTableEmploymentStart.
  ///
  /// In en, this message translates to:
  /// **'Employed from'**
  String get bhpTableEmploymentStart;

  /// No description provided for @bhpTableEmploymentEnd.
  ///
  /// In en, this message translates to:
  /// **'Employed to'**
  String get bhpTableEmploymentEnd;

  /// No description provided for @bhpTableDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get bhpTableDueDate;

  /// No description provided for @bhpTableDaysToDue.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get bhpTableDaysToDue;

  /// No description provided for @bhpTableStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bhpTableStatus;

  /// No description provided for @bhpTableNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get bhpTableNotes;

  /// No description provided for @bhpTableSymbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get bhpTableSymbol;

  /// No description provided for @bhpTableUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get bhpTableUnit;

  /// No description provided for @bhpTablePeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get bhpTablePeriod;

  /// No description provided for @bhpTableDefaultQuantity.
  ///
  /// In en, this message translates to:
  /// **'Default qty'**
  String get bhpTableDefaultQuantity;

  /// No description provided for @bhpTablePrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get bhpTablePrice;

  /// No description provided for @bhpStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get bhpStatusActive;

  /// No description provided for @bhpStatusActiveTooltip.
  ///
  /// In en, this message translates to:
  /// **'The status means the item is active and available in current views.'**
  String get bhpStatusActiveTooltip;

  /// No description provided for @bhpStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get bhpStatusInactive;

  /// No description provided for @bhpStatusInactiveTooltip.
  ///
  /// In en, this message translates to:
  /// **'The status means the item is inactive and should not be used for new operations.'**
  String get bhpStatusInactiveTooltip;

  /// No description provided for @bhpStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get bhpStatusArchived;

  /// No description provided for @bhpUserIssuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee issues'**
  String get bhpUserIssuesTitle;

  /// No description provided for @bhpUserIssuesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'BHP issues and equivalents history for: {name}'**
  String bhpUserIssuesSubtitle(String name);

  /// No description provided for @bhpUserIssuesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No issues'**
  String get bhpUserIssuesEmptyTitle;

  /// No description provided for @bhpUserIssuesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This employee has no registered equipment issues.'**
  String get bhpUserIssuesEmptyMessage;

  /// No description provided for @bhpUserIssuesErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load issues'**
  String get bhpUserIssuesErrorTitle;

  /// No description provided for @bhpUserIssuesSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Employee equipment issue register.'**
  String get bhpUserIssuesSectionSubtitle;

  /// No description provided for @bhpUserIssuesHideInactive.
  ///
  /// In en, this message translates to:
  /// **'Hide inactive'**
  String get bhpUserIssuesHideInactive;

  /// No description provided for @bhpUserIssuesEmployeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee:'**
  String get bhpUserIssuesEmployeeLabel;

  /// No description provided for @bhpUserIssuesPositionLabel.
  ///
  /// In en, this message translates to:
  /// **'Position:'**
  String get bhpUserIssuesPositionLabel;

  /// No description provided for @bhpUserIssuesNoPosition.
  ///
  /// In en, this message translates to:
  /// **'No position'**
  String get bhpUserIssuesNoPosition;

  /// No description provided for @bhpUserIssuesEditEmployeeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit employee data'**
  String get bhpUserIssuesEditEmployeeTooltip;

  /// No description provided for @bhpUserIssuesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search equipment (symbol, name)...'**
  String get bhpUserIssuesSearchHint;

  /// No description provided for @bhpUserIssuesRowNumber.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get bhpUserIssuesRowNumber;

  /// No description provided for @bhpUserIssuesNoEquipmentName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get bhpUserIssuesNoEquipmentName;

  /// No description provided for @bhpUserIssuesTooltipEquipmentInfo.
  ///
  /// In en, this message translates to:
  /// **'Show equipment information'**
  String get bhpUserIssuesTooltipEquipmentInfo;

  /// No description provided for @bhpUserIssuesTooltipEditQuantity.
  ///
  /// In en, this message translates to:
  /// **'Edit quantity'**
  String get bhpUserIssuesTooltipEditQuantity;

  /// No description provided for @bhpUserIssuesTooltipEditIssueDate.
  ///
  /// In en, this message translates to:
  /// **'Edit assignment date'**
  String get bhpUserIssuesTooltipEditIssueDate;

  /// No description provided for @bhpUserIssuesAddEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get bhpUserIssuesAddEquivalent;

  /// No description provided for @bhpUserIssuesTooltipAddEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Add equivalent'**
  String get bhpUserIssuesTooltipAddEquivalent;

  /// No description provided for @bhpUserIssuesTooltipEditEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Edit equivalent'**
  String get bhpUserIssuesTooltipEditEquivalent;

  /// No description provided for @bhpUserIssuesTooltipEditEquivalentDate.
  ///
  /// In en, this message translates to:
  /// **'Edit equivalent date'**
  String get bhpUserIssuesTooltipEditEquivalentDate;

  /// No description provided for @bhpUserIssuesActionDeleteEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Delete equivalent'**
  String get bhpUserIssuesActionDeleteEquivalent;

  /// No description provided for @bhpUserIssuesTooltipDeleteEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Delete equivalent'**
  String get bhpUserIssuesTooltipDeleteEquivalent;

  /// No description provided for @bhpUserIssuesAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get bhpUserIssuesAddNote;

  /// No description provided for @bhpUserIssuesTooltipAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add note to issue'**
  String get bhpUserIssuesTooltipAddNote;

  /// No description provided for @bhpUserIssuesActiveStatusTooltip.
  ///
  /// In en, this message translates to:
  /// **'The equipment is currently used by the employee.\nIt consumes the norm assigned to the position.'**
  String get bhpUserIssuesActiveStatusTooltip;

  /// No description provided for @bhpUserIssuesInactiveStatusTooltip.
  ///
  /// In en, this message translates to:
  /// **'The issue has been closed.\nThe equipment is no longer in use and releases the norm for the position.'**
  String get bhpUserIssuesInactiveStatusTooltip;

  /// No description provided for @bhpUserIssuesRepeatAction.
  ///
  /// In en, this message translates to:
  /// **'Add again'**
  String get bhpUserIssuesRepeatAction;

  /// No description provided for @bhpUserIssuesActionsForSymbol.
  ///
  /// In en, this message translates to:
  /// **'Actions for: {symbol}'**
  String bhpUserIssuesActionsForSymbol(Object symbol);

  /// No description provided for @bhpUserIssuesActionsForIssue.
  ///
  /// In en, this message translates to:
  /// **'Issue actions'**
  String get bhpUserIssuesActionsForIssue;

  /// No description provided for @bhpUserIssuesDeleteIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete issue'**
  String get bhpUserIssuesDeleteIssueTitle;

  /// No description provided for @bhpUserIssuesDeleteIssueMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete issue {item}? This operation cannot be undone.'**
  String bhpUserIssuesDeleteIssueMessage(Object item);

  /// No description provided for @bhpUserIssuesDeleteIssueSuccess.
  ///
  /// In en, this message translates to:
  /// **'The issue has been deleted.'**
  String get bhpUserIssuesDeleteIssueSuccess;

  /// No description provided for @bhpUserIssuesRepeatIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Add again'**
  String get bhpUserIssuesRepeatIssueTitle;

  /// No description provided for @bhpUserIssuesRepeatIssueMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to automatically repeat issue {item}?'**
  String bhpUserIssuesRepeatIssueMessage(Object item);

  /// No description provided for @bhpUserIssuesRepeatIssueSuccess.
  ///
  /// In en, this message translates to:
  /// **'The issue has been repeated.'**
  String get bhpUserIssuesRepeatIssueSuccess;

  /// No description provided for @bhpUserIssuesBulkRepeatAction.
  ///
  /// In en, this message translates to:
  /// **'Issue selected again'**
  String get bhpUserIssuesBulkRepeatAction;

  /// No description provided for @bhpUserIssuesBulkRepeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm reissue'**
  String get bhpUserIssuesBulkRepeatTitle;

  /// No description provided for @bhpUserIssuesBulkRepeatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New issues will be created for the items selected on the active list.'**
  String get bhpUserIssuesBulkRepeatSubtitle;

  /// No description provided for @bhpUserIssuesBulkRepeatDescription.
  ///
  /// In en, this message translates to:
  /// **'Review the selected items and choose one shared assignment date for the new issues.'**
  String get bhpUserIssuesBulkRepeatDescription;

  /// No description provided for @bhpUserIssuesBulkRepeatDateHelper.
  ///
  /// In en, this message translates to:
  /// **'Today\'s date is selected by default, but you can change it before saving the operation.'**
  String get bhpUserIssuesBulkRepeatDateHelper;

  /// No description provided for @bhpUserIssuesBulkRepeatSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get bhpUserIssuesBulkRepeatSelectAll;

  /// No description provided for @bhpUserIssuesBulkRepeatClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get bhpUserIssuesBulkRepeatClearSelection;

  /// No description provided for @bhpUserIssuesBulkRepeatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No items available to repeat'**
  String get bhpUserIssuesBulkRepeatEmptyTitle;

  /// No description provided for @bhpUserIssuesBulkRepeatEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No active items have been selected for reissue.'**
  String get bhpUserIssuesBulkRepeatEmptyMessage;

  /// No description provided for @bhpUserIssuesBulkRepeatSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'Selected: {count}'**
  String bhpUserIssuesBulkRepeatSelectedCount(Object count);

  /// No description provided for @bhpUserIssuesBulkRepeatSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Issue again'**
  String get bhpUserIssuesBulkRepeatSubmitAction;

  /// No description provided for @bhpUserIssuesBulkRepeatSelectionRequired.
  ///
  /// In en, this message translates to:
  /// **'Select at least one active item to issue again.'**
  String get bhpUserIssuesBulkRepeatSelectionRequired;

  /// No description provided for @bhpUserIssuesBulkRepeatSuccess.
  ///
  /// In en, this message translates to:
  /// **'Repeated {count} issues.'**
  String bhpUserIssuesBulkRepeatSuccess(Object count);

  /// No description provided for @bhpUserIssuesBulkRepeatItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assigned: {assignedAt} • Closed: {closedAt} • Quantity: {quantity}'**
  String bhpUserIssuesBulkRepeatItemSubtitle(
    Object assignedAt,
    Object closedAt,
    Object quantity,
  );

  /// No description provided for @bhpUserIssuesOpenPositionDetails.
  ///
  /// In en, this message translates to:
  /// **'Open position details'**
  String get bhpUserIssuesOpenPositionDetails;

  /// No description provided for @bhpUserIssuesPrintCardError.
  ///
  /// In en, this message translates to:
  /// **'Error while generating the card printout: {error}'**
  String bhpUserIssuesPrintCardError(Object error);

  /// No description provided for @bhpUserIssuesActionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add issue'**
  String get bhpUserIssuesActionAdd;

  /// No description provided for @bhpUserIssuesActionFromStandard.
  ///
  /// In en, this message translates to:
  /// **'Generate from standard'**
  String get bhpUserIssuesActionFromStandard;

  /// No description provided for @bhpUserIssuesActionClose.
  ///
  /// In en, this message translates to:
  /// **'Close Issue'**
  String get bhpUserIssuesActionClose;

  /// No description provided for @bhpUserIssuesActionEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Equivalent'**
  String get bhpUserIssuesActionEquivalent;

  /// No description provided for @bhpUserIssuesPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get bhpUserIssuesPrint;

  /// No description provided for @bhpUserIssuesPrintOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Print options'**
  String get bhpUserIssuesPrintOptionsTitle;

  /// No description provided for @bhpUserIssuesPrintOptionsIncludeInactive.
  ///
  /// In en, this message translates to:
  /// **'Include inactive (closed) items'**
  String get bhpUserIssuesPrintOptionsIncludeInactive;

  /// No description provided for @bhpUserIssuesPrintOptionsAction.
  ///
  /// In en, this message translates to:
  /// **'Generate print'**
  String get bhpUserIssuesPrintOptionsAction;

  /// No description provided for @bhpTableEquipmentSymbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get bhpTableEquipmentSymbol;

  /// No description provided for @bhpTableEquipmentName.
  ///
  /// In en, this message translates to:
  /// **'Equipment name'**
  String get bhpTableEquipmentName;

  /// No description provided for @bhpTableIssueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue date'**
  String get bhpTableIssueDate;

  /// No description provided for @bhpTableEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get bhpTableEndDate;

  /// No description provided for @bhpTableQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get bhpTableQuantity;

  /// No description provided for @bhpTableEquivalentDate.
  ///
  /// In en, this message translates to:
  /// **'Equiv. date'**
  String get bhpTableEquivalentDate;

  /// No description provided for @bhpTableEquivalentAmount.
  ///
  /// In en, this message translates to:
  /// **'Equiv. amount'**
  String get bhpTableEquivalentAmount;

  /// No description provided for @bhpIssueFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'New equipment issue'**
  String get bhpIssueFormAddTitle;

  /// No description provided for @bhpIssueFormCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close Issue'**
  String get bhpIssueFormCloseTitle;

  /// No description provided for @bhpIssueFormEquivalentTitle.
  ///
  /// In en, this message translates to:
  /// **'Equivalent payout'**
  String get bhpIssueFormEquivalentTitle;

  /// No description provided for @bhpIssueFormEquipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Equipment item'**
  String get bhpIssueFormEquipmentLabel;

  /// No description provided for @bhpIssueFormEquipmentHint.
  ///
  /// In en, this message translates to:
  /// **'Select equipment from catalog'**
  String get bhpIssueFormEquipmentHint;

  /// No description provided for @bhpIssueFormDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue date'**
  String get bhpIssueFormDateLabel;

  /// No description provided for @bhpIssueFormQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get bhpIssueFormQuantityLabel;

  /// No description provided for @bhpIssueFormNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get bhpIssueFormNotesLabel;

  /// No description provided for @bhpIssueFormEndDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get bhpIssueFormEndDateLabel;

  /// No description provided for @bhpIssueFormEquivalentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Equivalent date'**
  String get bhpIssueFormEquivalentDateLabel;

  /// No description provided for @bhpIssueFormEquivalentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Equivalent amount'**
  String get bhpIssueFormEquivalentAmountLabel;

  /// No description provided for @bhpIssueFormSuccessAdd.
  ///
  /// In en, this message translates to:
  /// **'New equipment issue added.'**
  String get bhpIssueFormSuccessAdd;

  /// No description provided for @bhpIssueFormSuccessClose.
  ///
  /// In en, this message translates to:
  /// **'Equipment issue successfully closed.'**
  String get bhpIssueFormSuccessClose;

  /// No description provided for @bhpIssueFormSuccessEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Equivalent registered.'**
  String get bhpIssueFormSuccessEquivalent;

  /// No description provided for @bhpIssueFormSuccessStandard.
  ///
  /// In en, this message translates to:
  /// **'Missing equipment from standard successfully assigned.'**
  String get bhpIssueFormSuccessStandard;

  /// No description provided for @bhpIssueEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit issue'**
  String get bhpIssueEditTitle;

  /// No description provided for @bhpIssueEditDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit issue date'**
  String get bhpIssueEditDateTitle;

  /// No description provided for @bhpIssueEditEndDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit end date'**
  String get bhpIssueEditEndDateTitle;

  /// No description provided for @bhpIssueEditEndDateHelperText.
  ///
  /// In en, this message translates to:
  /// **'Cannot be earlier than the issue date.'**
  String get bhpIssueEditEndDateHelperText;

  /// No description provided for @bhpIssueEditQuantityTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit quantity'**
  String get bhpIssueEditQuantityTitle;

  /// No description provided for @bhpIssueEditNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit notes'**
  String get bhpIssueEditNotesTitle;

  /// No description provided for @bhpIssueEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Issue updated.'**
  String get bhpIssueEditSuccess;

  /// No description provided for @bhpIssueEquivalentEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit equivalent'**
  String get bhpIssueEquivalentEditTitle;

  /// No description provided for @bhpIssueEquivalentEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Equivalent updated.'**
  String get bhpIssueEquivalentEditSuccess;

  /// No description provided for @bhpIssueEquivalentDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete equivalent'**
  String get bhpIssueEquivalentDeleteTitle;

  /// No description provided for @bhpIssueEquivalentDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete equivalent'**
  String get bhpIssueEquivalentDeleteAction;

  /// No description provided for @bhpIssueEquivalentDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Equivalent removed.'**
  String get bhpIssueEquivalentDeleteSuccess;

  /// No description provided for @bhpIssueEquivalentDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete equivalent for: {item}? This clears the equivalent date and amount without removing the issue itself.'**
  String bhpIssueEquivalentDeleteMessage(Object item);

  /// No description provided for @bhpIssueValidationPositiveQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid quantity greater than 0.'**
  String get bhpIssueValidationPositiveQuantity;

  /// No description provided for @bhpAssignFromStandardTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign from standard'**
  String get bhpAssignFromStandardTitle;

  /// No description provided for @bhpAssignFromStandardLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load standard'**
  String get bhpAssignFromStandardLoadErrorTitle;

  /// No description provided for @bhpAssignFromStandardDescription.
  ///
  /// In en, this message translates to:
  /// **'Below you can see entries from the job-position standard. Selected entries will be assigned, while already active entries are locked.'**
  String get bhpAssignFromStandardDescription;

  /// No description provided for @bhpAssignFromStandardSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'To add: {count}'**
  String bhpAssignFromStandardSelectedCount(int count);

  /// No description provided for @bhpAssignFromStandardLockedCount.
  ///
  /// In en, this message translates to:
  /// **'Already active: {count}'**
  String bhpAssignFromStandardLockedCount(int count);

  /// No description provided for @bhpAssignFromStandardInactiveCount.
  ///
  /// In en, this message translates to:
  /// **'Inactive: {count}'**
  String bhpAssignFromStandardInactiveCount(int count);

  /// No description provided for @bhpAssignFromStandardSectionAddable.
  ///
  /// In en, this message translates to:
  /// **'To add'**
  String get bhpAssignFromStandardSectionAddable;

  /// No description provided for @bhpAssignFromStandardSectionLocked.
  ///
  /// In en, this message translates to:
  /// **'Already active'**
  String get bhpAssignFromStandardSectionLocked;

  /// No description provided for @bhpAssignFromStandardSectionInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get bhpAssignFromStandardSectionInactive;

  /// No description provided for @bhpAssignFromStandardSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Assign items'**
  String get bhpAssignFromStandardSubmitAction;

  /// No description provided for @bhpAssignFromStandardBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignment unavailable'**
  String get bhpAssignFromStandardBlockedTitle;

  /// No description provided for @bhpAssignFromStandardBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'This employee has no active position or cannot receive issues.'**
  String get bhpAssignFromStandardBlockedMessage;

  /// No description provided for @bhpAssignFromStandardBadgeAddable.
  ///
  /// In en, this message translates to:
  /// **'To add'**
  String get bhpAssignFromStandardBadgeAddable;

  /// No description provided for @bhpAssignFromStandardBadgeLocked.
  ///
  /// In en, this message translates to:
  /// **'Already active'**
  String get bhpAssignFromStandardBadgeLocked;

  /// No description provided for @bhpAssignFromStandardBadgeInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get bhpAssignFromStandardBadgeInactive;

  /// No description provided for @bhpAssignFromStandardBadgeInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get bhpAssignFromStandardBadgeInfo;

  /// No description provided for @bhpAssignFromStandardBadgeWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get bhpAssignFromStandardBadgeWarning;

  /// No description provided for @bhpPositionStandardTitle.
  ///
  /// In en, this message translates to:
  /// **'Position and standard'**
  String get bhpPositionStandardTitle;

  /// No description provided for @bhpPositionStandardSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save position'**
  String get bhpPositionStandardSaveAction;

  /// No description provided for @bhpPositionStandardSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Position saved.'**
  String get bhpPositionStandardSaveSuccess;

  /// No description provided for @bhpPositionStandardLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load position'**
  String get bhpPositionStandardLoadErrorTitle;

  /// No description provided for @bhpPositionStandardCurrentTitle.
  ///
  /// In en, this message translates to:
  /// **'Current position'**
  String get bhpPositionStandardCurrentTitle;

  /// No description provided for @bhpPositionStandardNoPosition.
  ///
  /// In en, this message translates to:
  /// **'No position'**
  String get bhpPositionStandardNoPosition;

  /// No description provided for @bhpPositionStandardDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Position description'**
  String get bhpPositionStandardDescriptionTitle;

  /// No description provided for @bhpPositionStandardChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change position'**
  String get bhpPositionStandardChangeTitle;

  /// No description provided for @bhpPositionStandardSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Select position'**
  String get bhpPositionStandardSelectHint;

  /// No description provided for @bhpPositionStandardSelectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Position selected'**
  String get bhpPositionStandardSelectedStatus;

  /// No description provided for @bhpPositionStandardUnselectedStatus.
  ///
  /// In en, this message translates to:
  /// **'No selection'**
  String get bhpPositionStandardUnselectedStatus;

  /// No description provided for @bhpPositionStandardLoadingStandard.
  ///
  /// In en, this message translates to:
  /// **'Loading standard...'**
  String get bhpPositionStandardLoadingStandard;

  /// No description provided for @bhpPositionStandardStandardCount.
  ///
  /// In en, this message translates to:
  /// **'Standard items: {count}'**
  String bhpPositionStandardStandardCount(int count);

  /// No description provided for @bhpPositionStandardPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Standard preview: {name}'**
  String bhpPositionStandardPreviewLabel(Object name);

  /// No description provided for @bhpPositionStandardEmptyStandardTitle.
  ///
  /// In en, this message translates to:
  /// **'No standard'**
  String get bhpPositionStandardEmptyStandardTitle;

  /// No description provided for @bhpPositionStandardEmptyStandardMessage.
  ///
  /// In en, this message translates to:
  /// **'No items are assigned to the selected position yet.'**
  String get bhpPositionStandardEmptyStandardMessage;

  /// No description provided for @bhpAddUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Add employee'**
  String get bhpAddUserTitle;

  /// No description provided for @bhpAddUserSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New BHP employee card with assigned position.'**
  String get bhpAddUserSubtitle;

  /// No description provided for @bhpAddUserLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to prepare form'**
  String get bhpAddUserLoadErrorTitle;

  /// No description provided for @bhpAddUserSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Employee {name} has been added.'**
  String bhpAddUserSuccessMessage(Object name);

  /// No description provided for @bhpAddUserBaseSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic data'**
  String get bhpAddUserBaseSectionTitle;

  /// No description provided for @bhpAddUserBaseSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Required fields to create an employee card.'**
  String get bhpAddUserBaseSectionDescription;

  /// No description provided for @bhpAddUserFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get bhpAddUserFirstNameLabel;

  /// No description provided for @bhpAddUserLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get bhpAddUserLastNameLabel;

  /// No description provided for @bhpAddUserPeselLabel.
  ///
  /// In en, this message translates to:
  /// **'PESEL'**
  String get bhpAddUserPeselLabel;

  /// No description provided for @bhpAddUserPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get bhpAddUserPhoneLabel;

  /// No description provided for @bhpAddUserSelectPositionHint.
  ///
  /// In en, this message translates to:
  /// **'Select position'**
  String get bhpAddUserSelectPositionHint;

  /// No description provided for @bhpAddUserPositionRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Position is required.'**
  String get bhpAddUserPositionRequiredError;

  /// No description provided for @bhpAddUserResidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Place of residence'**
  String get bhpAddUserResidenceLabel;

  /// No description provided for @bhpAddUserDimensionsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'BHP data'**
  String get bhpAddUserDimensionsSectionTitle;

  /// No description provided for @bhpAddUserDimensionsSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Measurements used when assigning equipment.'**
  String get bhpAddUserDimensionsSectionDescription;

  /// No description provided for @bhpAddUserHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get bhpAddUserHeightLabel;

  /// No description provided for @bhpAddUserChestLabel.
  ///
  /// In en, this message translates to:
  /// **'Chest circumference'**
  String get bhpAddUserChestLabel;

  /// No description provided for @bhpAddUserWaistLabel.
  ///
  /// In en, this message translates to:
  /// **'Waist circumference'**
  String get bhpAddUserWaistLabel;

  /// No description provided for @bhpAddUserHeadLabel.
  ///
  /// In en, this message translates to:
  /// **'Head circumference'**
  String get bhpAddUserHeadLabel;

  /// No description provided for @bhpAddUserFootLabel.
  ///
  /// In en, this message translates to:
  /// **'Foot length'**
  String get bhpAddUserFootLabel;

  /// No description provided for @bhpAddUserSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get bhpAddUserSubmitAction;

  /// No description provided for @bhpAddUserPotentialDuplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'A similar employee already exists'**
  String get bhpAddUserPotentialDuplicateTitle;

  /// No description provided for @bhpAddUserPotentialDuplicateMessage.
  ///
  /// In en, this message translates to:
  /// **'Found employees with the same basic data. Review the list before saving.'**
  String get bhpAddUserPotentialDuplicateMessage;

  /// No description provided for @bhpAddUserPotentialDuplicateBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'Similar records: {users}. You can still save, but it is worth checking.'**
  String bhpAddUserPotentialDuplicateBannerMessage(Object users);

  /// No description provided for @bhpAddUserPotentialDuplicateConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Add anyway'**
  String get bhpAddUserPotentialDuplicateConfirmAction;

  /// No description provided for @bhpAddUserPotentialDuplicateCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Back to form'**
  String get bhpAddUserPotentialDuplicateCancelAction;

  /// No description provided for @bhpAddUserInvalidEmploymentDatesMessage.
  ///
  /// In en, this message translates to:
  /// **'Employment end date cannot be earlier than employment start date.'**
  String get bhpAddUserInvalidEmploymentDatesMessage;

  /// No description provided for @bhpUserEmploymentEndDatePastWarning.
  ///
  /// In en, this message translates to:
  /// **'The selected employment end date is in the past. After saving, the employee will be marked as inactive.'**
  String get bhpUserEmploymentEndDatePastWarning;

  /// No description provided for @bhpUserIssuesReadOnlyArchivedMessage.
  ///
  /// In en, this message translates to:
  /// **'The employee is archived, so the issues card is read-only. Restore the employee to unlock editing.'**
  String get bhpUserIssuesReadOnlyArchivedMessage;

  /// No description provided for @bhpEditUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit employee'**
  String get bhpEditUserTitle;

  /// No description provided for @bhpEditUserLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to prepare edit form'**
  String get bhpEditUserLoadErrorTitle;

  /// No description provided for @bhpEditUserBaseSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee data'**
  String get bhpEditUserBaseSectionTitle;

  /// No description provided for @bhpEditUserBaseSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Update basic data and parameters used in BHP issues.'**
  String get bhpEditUserBaseSectionDescription;

  /// No description provided for @bhpEditUserSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get bhpEditUserSubmitAction;

  /// No description provided for @bhpEditUserSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Employee {name} has been updated.'**
  String bhpEditUserSuccessMessage(Object name);

  /// No description provided for @bhpPreviewNoAssignedPosition.
  ///
  /// In en, this message translates to:
  /// **'No assigned position'**
  String get bhpPreviewNoAssignedPosition;

  /// No description provided for @bhpPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a temporary modal for the employee workflow. The next step is a full detail view with issues.'**
  String get bhpPreviewDescription;

  /// No description provided for @bhpPreviewIssuesAction.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get bhpPreviewIssuesAction;

  /// No description provided for @bhpPreviewEditPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Employee editing is not connected yet.'**
  String get bhpPreviewEditPendingMessage;

  /// No description provided for @bhpPreviewArchivedMessage.
  ///
  /// In en, this message translates to:
  /// **'Employee {name} has been archived.'**
  String bhpPreviewArchivedMessage(Object name);

  /// No description provided for @bhpPreviewRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get bhpPreviewRestoreAction;

  /// No description provided for @bhpPreviewRestoreEmployeeMessage.
  ///
  /// In en, this message translates to:
  /// **'Restoring will reactivate the employee. If the employee has a past employment end date, it will be cleared.'**
  String get bhpPreviewRestoreEmployeeMessage;

  /// No description provided for @bhpPreviewRestoredMessage.
  ///
  /// In en, this message translates to:
  /// **'Employee {name} has been restored.'**
  String bhpPreviewRestoredMessage(Object name);

  /// No description provided for @bhpPreviewForceDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete from database'**
  String get bhpPreviewForceDeleteAction;

  /// No description provided for @bhpForceDeleteUserConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete employee from database'**
  String get bhpForceDeleteUserConfirmTitle;

  /// No description provided for @bhpForceDeleteUserConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This operation will physically and irreversibly delete employee {name} (ID: {id}) along with all related equipment issues from the database.'**
  String bhpForceDeleteUserConfirmBody(Object name, Object id);

  /// No description provided for @bhpForceDeleteUnlockLabel.
  ///
  /// In en, this message translates to:
  /// **'To unlock deletion, type: Excellent2026'**
  String get bhpForceDeleteUnlockLabel;

  /// No description provided for @bhpForceDeleteUnlockHint.
  ///
  /// In en, this message translates to:
  /// **'Type Excellent2026 to unlock deletion.'**
  String get bhpForceDeleteUnlockHint;

  /// No description provided for @bhpPreviewForceDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Employee {name} has been deleted from the database.'**
  String bhpPreviewForceDeletedMessage(Object name);

  /// No description provided for @bhpIssueConfirmStandardTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate equipment from standard'**
  String get bhpIssueConfirmStandardTitle;

  /// No description provided for @bhpIssueConfirmStandardMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to generate BHP equipment from the standard of this employee\'s job position?\n\nThe system will check the assigned standard for their position and automatically create missing, active issues. Existing active issues will not be duplicated.'**
  String get bhpIssueConfirmStandardMessage;

  /// No description provided for @bhpIssueConfirmStandardAction.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get bhpIssueConfirmStandardAction;

  /// No description provided for @inneTitle.
  ///
  /// In en, this message translates to:
  /// **'Inne module'**
  String get inneTitle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @inventoryEditCommissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit commission'**
  String get inventoryEditCommissionTitle;

  /// No description provided for @inventoryCommissionForInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory commission {number}'**
  String inventoryCommissionForInventory(Object number);

  /// No description provided for @inventoryNoAssignedCommissionTitle.
  ///
  /// In en, this message translates to:
  /// **'No commission assigned'**
  String get inventoryNoAssignedCommissionTitle;

  /// No description provided for @inventoryNoAssignedCommissionMessage.
  ///
  /// In en, this message translates to:
  /// **'No commission has been assigned to this inventory yet.'**
  String get inventoryNoAssignedCommissionMessage;

  /// No description provided for @inventoryUserWithId.
  ///
  /// In en, this message translates to:
  /// **'User #{id}'**
  String inventoryUserWithId(int id);

  /// No description provided for @inventoryNoSheetsTitle.
  ///
  /// In en, this message translates to:
  /// **'No sheets'**
  String get inventoryNoSheetsTitle;

  /// No description provided for @inventoryNoSheetsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the first sheet for this inventory.'**
  String get inventoryNoSheetsMessage;

  /// No description provided for @inventorySheetWithId.
  ///
  /// In en, this message translates to:
  /// **'Sheet #{id}'**
  String inventorySheetWithId(int id);

  /// No description provided for @inventoryCommissionForSheet.
  ///
  /// In en, this message translates to:
  /// **'Sheet commission {label}'**
  String inventoryCommissionForSheet(Object label);

  /// No description provided for @inventoryNoAssignedLocation.
  ///
  /// In en, this message translates to:
  /// **'No assigned location'**
  String get inventoryNoAssignedLocation;

  /// No description provided for @inventoryItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get inventoryItemsLabel;

  /// No description provided for @inventoryLocationLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Location level'**
  String get inventoryLocationLevelLabel;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @inventorySheetCommissionNone.
  ///
  /// In en, this message translates to:
  /// **'Sheet commission: none'**
  String get inventorySheetCommissionNone;

  /// No description provided for @inventorySheetCommissionWithMembers.
  ///
  /// In en, this message translates to:
  /// **'Sheet commission: {members}'**
  String inventorySheetCommissionWithMembers(Object members);

  /// No description provided for @inventoryDeleteCompanyTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete company'**
  String get inventoryDeleteCompanyTitle;

  /// No description provided for @inventoryDeleteCompanySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Company deletion is irreversible.'**
  String get inventoryDeleteCompanySubtitle;

  /// No description provided for @inventoryDeleteCompanyConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this company?'**
  String get inventoryDeleteCompanyConfirmTitle;

  /// No description provided for @inventoryDeleteCompanyConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Company: {name}\nCompany ID: {id}\nThis operation cannot be undone.'**
  String inventoryDeleteCompanyConfirmBody(Object name, int id);

  /// No description provided for @inventoryDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete inventory'**
  String get inventoryDeleteTitle;

  /// No description provided for @inventoryDeleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory deletion is irreversible.'**
  String get inventoryDeleteSubtitle;

  /// No description provided for @inventoryDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this inventory?'**
  String get inventoryDeleteConfirmTitle;

  /// No description provided for @inventoryDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Inventory: {number}\nID: {id}\nThis operation cannot be undone.'**
  String inventoryDeleteConfirmBody(Object number, int id);

  /// No description provided for @inventoryDeleteUnlockLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get inventoryDeleteUnlockLabel;

  /// No description provided for @inventoryDeleteUnlockHint.
  ///
  /// In en, this message translates to:
  /// **'Type Excellent to unlock deletion.'**
  String get inventoryDeleteUnlockHint;

  /// No description provided for @inventoryDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Inventory has been deleted.'**
  String get inventoryDeletedMessage;

  /// No description provided for @inventorySnapshotRefreshButton.
  ///
  /// In en, this message translates to:
  /// **'Refresh snapshot'**
  String get inventorySnapshotRefreshButton;

  /// No description provided for @inventorySnapshotRefreshTitle.
  ///
  /// In en, this message translates to:
  /// **'ST snapshot refresh'**
  String get inventorySnapshotRefreshTitle;

  /// No description provided for @inventorySnapshotRefreshSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ST data synchronization for all databases.'**
  String get inventorySnapshotRefreshSubtitle;

  /// No description provided for @inventorySnapshotRefreshConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Snapshot refresh'**
  String get inventorySnapshotRefreshConfirmTitle;

  /// No description provided for @inventorySnapshotRefreshConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Operation confirmation'**
  String get inventorySnapshotRefreshConfirmSubtitle;

  /// No description provided for @inventorySnapshotRefreshConfirmQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to refresh the ST snapshot? The operation may take several dozen seconds.'**
  String get inventorySnapshotRefreshConfirmQuestion;

  /// No description provided for @inventorySnapshotRefreshUnlockLabel.
  ///
  /// In en, this message translates to:
  /// **'To unlock refresh, type: Excellent'**
  String get inventorySnapshotRefreshUnlockLabel;

  /// No description provided for @inventorySnapshotRefreshUnlockHint.
  ///
  /// In en, this message translates to:
  /// **'Type the unlock phrase'**
  String get inventorySnapshotRefreshUnlockHint;

  /// No description provided for @inventorySnapshotRefreshAction.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get inventorySnapshotRefreshAction;

  /// No description provided for @inventorySnapshotRefreshInProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'ST snapshot refresh in progress'**
  String get inventorySnapshotRefreshInProgressTitle;

  /// No description provided for @inventorySnapshotRefreshInProgressMessage.
  ///
  /// In en, this message translates to:
  /// **'Operation is running. This may take several dozen seconds.'**
  String get inventorySnapshotRefreshInProgressMessage;

  /// No description provided for @inventorySnapshotRefreshBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Snapshot refresh unavailable'**
  String get inventorySnapshotRefreshBlockedTitle;

  /// No description provided for @inventorySnapshotRefreshBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'There is an active inventory. Close it and try again.'**
  String get inventorySnapshotRefreshBlockedMessage;

  /// No description provided for @inventorySnapshotRefreshFailureTitle.
  ///
  /// In en, this message translates to:
  /// **'Refresh failed'**
  String get inventorySnapshotRefreshFailureTitle;

  /// No description provided for @inventorySnapshotRefreshSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Refresh completed'**
  String get inventorySnapshotRefreshSuccessTitle;

  /// No description provided for @inventorySnapshotRefreshSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Refresh completed. Success: {okCount}, errors: {errorCount}.'**
  String inventorySnapshotRefreshSuccessMessage(int okCount, int errorCount);

  /// No description provided for @inventorySnapshotRefreshProcessingAction.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get inventorySnapshotRefreshProcessingAction;

  /// No description provided for @inventoryCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close inventory'**
  String get inventoryCloseTitle;

  /// No description provided for @inventoryCloseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'After closing, editing will no longer be available.'**
  String get inventoryCloseSubtitle;

  /// No description provided for @inventoryCloseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close this inventory?'**
  String get inventoryCloseConfirmTitle;

  /// No description provided for @inventoryCloseConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Inventory: {number}\nID: {id}\nStatus will be changed to finished (2).'**
  String inventoryCloseConfirmBody(Object number, int id);

  /// No description provided for @inventoryCloseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End date (data_do)'**
  String get inventoryCloseDateLabel;

  /// No description provided for @inventoryCloseUnlockLabel.
  ///
  /// In en, this message translates to:
  /// **'Close confirmation'**
  String get inventoryCloseUnlockLabel;

  /// No description provided for @inventoryCloseUnlockHint.
  ///
  /// In en, this message translates to:
  /// **'Type Excellent to unlock closing.'**
  String get inventoryCloseUnlockHint;

  /// No description provided for @inventoryCloseBlockedStatusMessage.
  ///
  /// In en, this message translates to:
  /// **'Inventory can be closed only from In progress status (1).'**
  String get inventoryCloseBlockedStatusMessage;

  /// No description provided for @inventoryCloseDateValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'End date must be greater than or equal to start date.'**
  String get inventoryCloseDateValidationMessage;

  /// No description provided for @inventoryClosedMessage.
  ///
  /// In en, this message translates to:
  /// **'Inventory has been closed.'**
  String get inventoryClosedMessage;

  /// No description provided for @inventoryDeleteSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete sheet'**
  String get inventoryDeleteSheetTitle;

  /// No description provided for @inventoryDeleteSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sheet deletion is irreversible.'**
  String get inventoryDeleteSheetSubtitle;

  /// No description provided for @inventoryDeleteSheetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this sheet?'**
  String get inventoryDeleteSheetConfirmTitle;

  /// No description provided for @inventoryDeleteSheetConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Sheet: {number}\nID: {id}\nThis operation cannot be undone.'**
  String inventoryDeleteSheetConfirmBody(Object number, int id);

  /// No description provided for @inventoryDeleteSheetBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete a sheet in a finished inventory (status=2).'**
  String get inventoryDeleteSheetBlockedMessage;

  /// No description provided for @inventorySheetDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sheet has been deleted.'**
  String get inventorySheetDeletedMessage;

  /// No description provided for @inventoryArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get inventoryArchiveTitle;

  /// No description provided for @inventoryArchiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Archived views and supporting data.'**
  String get inventoryArchiveSubtitle;

  /// No description provided for @inventoryCommissionLabel.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get inventoryCommissionLabel;

  /// No description provided for @inventoryReportsShowNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Show notes'**
  String get inventoryReportsShowNotesLabel;

  /// No description provided for @inventoryReportsDisposalProtocolLabel.
  ///
  /// In en, this message translates to:
  /// **'Disposal protocol'**
  String get inventoryReportsDisposalProtocolLabel;

  /// No description provided for @inventoryReportsMacOSWorkaroundPrefix.
  ///
  /// In en, this message translates to:
  /// **'macOS workaround: dynamicLayout disabled • '**
  String get inventoryReportsMacOSWorkaroundPrefix;

  /// No description provided for @inventoryReportsPrintStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get inventoryReportsPrintStatusAvailable;

  /// No description provided for @inventoryReportsPrintStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'unavailable'**
  String get inventoryReportsPrintStatusUnavailable;

  /// No description provided for @inventoryReportsShareStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get inventoryReportsShareStatusAvailable;

  /// No description provided for @inventoryReportsShareStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'unavailable'**
  String get inventoryReportsShareStatusUnavailable;

  /// No description provided for @inventorySearchUserHint.
  ///
  /// In en, this message translates to:
  /// **'Search user...'**
  String get inventorySearchUserHint;

  /// No description provided for @inventorySearching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get inventorySearching;

  /// No description provided for @inventoryTypeMinTwoChars.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters'**
  String get inventoryTypeMinTwoChars;

  /// No description provided for @inventoryNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get inventoryNoResults;

  /// No description provided for @inventoryNoSelectedPeopleTitle.
  ///
  /// In en, this message translates to:
  /// **'No selected people'**
  String get inventoryNoSelectedPeopleTitle;

  /// No description provided for @inventoryNoSelectedPeopleMessage.
  ///
  /// In en, this message translates to:
  /// **'Add users to commission from search.'**
  String get inventoryNoSelectedPeopleMessage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @inventoryEditSheetItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit sheet item'**
  String get inventoryEditSheetItemTitle;

  /// No description provided for @inventoryEditSheetItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{name} ({register}) | BC: {barcode}'**
  String inventoryEditSheetItemSubtitle(
    Object name,
    Object register,
    Object barcode,
  );

  /// No description provided for @inventoryItemSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Item changes have been saved.'**
  String get inventoryItemSavedMessage;

  /// No description provided for @inventoryInventoryStateShort.
  ///
  /// In en, this message translates to:
  /// **'Inv. state'**
  String get inventoryInventoryStateShort;

  /// No description provided for @inventoryInventoryStateNone.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get inventoryInventoryStateNone;

  /// No description provided for @inventoryInventoryStateMatching.
  ///
  /// In en, this message translates to:
  /// **'Matching'**
  String get inventoryInventoryStateMatching;

  /// No description provided for @inventoryInventoryStateTransferred.
  ///
  /// In en, this message translates to:
  /// **'Transferred'**
  String get inventoryInventoryStateTransferred;

  /// No description provided for @inventoryScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get inventoryScan;

  /// No description provided for @inventoryScannerNotRead.
  ///
  /// In en, this message translates to:
  /// **'Not scanned'**
  String get inventoryScannerNotRead;

  /// No description provided for @inventoryScannerRead.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get inventoryScannerRead;

  /// No description provided for @inventoryLiquidation.
  ///
  /// In en, this message translates to:
  /// **'Liquidation'**
  String get inventoryLiquidation;

  /// No description provided for @inventorySurplus.
  ///
  /// In en, this message translates to:
  /// **'Surplus'**
  String get inventorySurplus;

  /// No description provided for @inventoryNewBarcode.
  ///
  /// In en, this message translates to:
  /// **'New barcode'**
  String get inventoryNewBarcode;

  /// No description provided for @inventoryNewPerson.
  ///
  /// In en, this message translates to:
  /// **'New person'**
  String get inventoryNewPerson;

  /// No description provided for @inventoryNewName.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get inventoryNewName;

  /// Placeholder for sheet item remarks backed by uwagi_loc from the API.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get inventoryLocalRemarksHint;

  /// No description provided for @inventoryNewBarcodeMaxLengthError.
  ///
  /// In en, this message translates to:
  /// **'New barcode can contain at most 64 characters.'**
  String get inventoryNewBarcodeMaxLengthError;

  /// No description provided for @inventoryAddSheetToInventory.
  ///
  /// In en, this message translates to:
  /// **'Add sheet to inventory #{inventoryId}'**
  String inventoryAddSheetToInventory(int inventoryId);

  /// No description provided for @inventoryLoadLocationsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load locations'**
  String get inventoryLoadLocationsErrorTitle;

  /// No description provided for @inventoryOptionalCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission (optional)'**
  String get inventoryOptionalCommission;

  /// No description provided for @inventorySearchByNameOrLoginHint.
  ///
  /// In en, this message translates to:
  /// **'Search person by name or login...'**
  String get inventorySearchByNameOrLoginHint;

  /// No description provided for @inventorySelectLocationFromTree.
  ///
  /// In en, this message translates to:
  /// **'Select location from the tree.'**
  String get inventorySelectLocationFromTree;

  /// No description provided for @inventoryScopeAutoSet.
  ///
  /// In en, this message translates to:
  /// **'The sheet will include only the selected location.'**
  String get inventoryScopeAutoSet;

  /// No description provided for @inventoryNoLocationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No locations'**
  String get inventoryNoLocationsTitle;

  /// No description provided for @inventoryLocationsBackendEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Backend did not return locations for this inventory.'**
  String get inventoryLocationsBackendEmptyMessage;

  /// No description provided for @inventoryIdWithValue.
  ///
  /// In en, this message translates to:
  /// **'ID {id}'**
  String inventoryIdWithValue(int id);

  /// No description provided for @inventoryLocationWithId.
  ///
  /// In en, this message translates to:
  /// **'Location: {id}'**
  String inventoryLocationWithId(int id);

  /// No description provided for @inventorySelectLocationBeforeCreateError.
  ///
  /// In en, this message translates to:
  /// **'Select location in the tree before creating the sheet.'**
  String get inventorySelectLocationBeforeCreateError;

  /// No description provided for @inventoryInvalidCommissionFormatError.
  ///
  /// In en, this message translates to:
  /// **'Commission list has invalid format.'**
  String get inventoryInvalidCommissionFormatError;

  /// No description provided for @inventorySheetDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sheet details'**
  String get inventorySheetDetailsTitle;

  /// No description provided for @inventorySheetDetailsLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load sheet details'**
  String get inventorySheetDetailsLoadErrorTitle;

  /// No description provided for @inventorySheetItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sheet items'**
  String get inventorySheetItemsTitle;

  /// No description provided for @inventorySearchSheetItemsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by ID, register no., name, person, location or barcode'**
  String get inventorySearchSheetItemsHint;

  /// No description provided for @inventoryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get inventoryAdd;

  /// No description provided for @inventoryAddByRegisterNumberShort.
  ///
  /// In en, this message translates to:
  /// **'Add by reg. no.'**
  String get inventoryAddByRegisterNumberShort;

  /// No description provided for @inventoryAddSheetItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Add sheet item'**
  String get inventoryAddSheetItemTitle;

  /// No description provided for @inventoryAddSheetItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manually add a new item to the current sheet.'**
  String get inventoryAddSheetItemSubtitle;

  /// No description provided for @inventoryAddSheetItemBarcodeOptionalHelper.
  ///
  /// In en, this message translates to:
  /// **'Optional field. If left empty, the backend will save 0.'**
  String get inventoryAddSheetItemBarcodeOptionalHelper;

  /// No description provided for @inventoryAddSheetItemAtLeastOneFieldError.
  ///
  /// In en, this message translates to:
  /// **'Fill in at least one field identifying the item.'**
  String get inventoryAddSheetItemAtLeastOneFieldError;

  /// No description provided for @inventoryAddSheetItemByRegisterNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add by register number'**
  String get inventoryAddSheetItemByRegisterNumberTitle;

  /// No description provided for @inventoryAddSheetItemByRegisterNumberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find and add an item to the sheet using its register number.'**
  String get inventoryAddSheetItemByRegisterNumberSubtitle;

  /// No description provided for @inventorySheetItemAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sheet item has been added.'**
  String get inventorySheetItemAddedMessage;

  /// No description provided for @inventorySheetItemAddedByRegisterNumberMessage.
  ///
  /// In en, this message translates to:
  /// **'Item has been added to the sheet by register number.'**
  String get inventorySheetItemAddedByRegisterNumberMessage;

  /// No description provided for @inventoryBarcodeRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Barcode is required.'**
  String get inventoryBarcodeRequiredError;

  /// No description provided for @inventoryBarcodePositiveIntegerError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid barcode as an integer greater than 0.'**
  String get inventoryBarcodePositiveIntegerError;

  /// No description provided for @inventoryRegisterNumberRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Register number is required.'**
  String get inventoryRegisterNumberRequiredError;

  /// No description provided for @inventoryAssetStateLabel.
  ///
  /// In en, this message translates to:
  /// **'Asset status'**
  String get inventoryAssetStateLabel;

  /// No description provided for @inventoryResultsCount.
  ///
  /// In en, this message translates to:
  /// **'Results: {filtered}/{total}'**
  String inventoryResultsCount(int filtered, int total);

  /// No description provided for @inventoryNoItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get inventoryNoItemsTitle;

  /// No description provided for @inventoryNoSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No search results'**
  String get inventoryNoSearchResultsTitle;

  /// No description provided for @inventoryHideFinished.
  ///
  /// In en, this message translates to:
  /// **'Hide finished'**
  String get inventoryHideFinished;

  /// No description provided for @inventoryHideFinishedEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'All inventories are finished or hidden by the filter.'**
  String get inventoryHideFinishedEmptyMessage;

  /// No description provided for @inventorySheetNoItemsMessage.
  ///
  /// In en, this message translates to:
  /// **'Sheet does not contain any items.'**
  String get inventorySheetNoItemsMessage;

  /// No description provided for @inventoryTryAnotherPhraseMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another phrase.'**
  String get inventoryTryAnotherPhraseMessage;

  /// No description provided for @inventorySheetLabel.
  ///
  /// In en, this message translates to:
  /// **'Inventory sheet'**
  String get inventorySheetLabel;

  /// No description provided for @inventoryEditSheetNumberAction.
  ///
  /// In en, this message translates to:
  /// **'Change sheet number'**
  String get inventoryEditSheetNumberAction;

  /// No description provided for @inventoryAssetStatusNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get inventoryAssetStatusNone;

  /// No description provided for @inventoryAssetStatusUnconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Unconfirmed'**
  String get inventoryAssetStatusUnconfirmed;

  /// No description provided for @inventoryAssetStatusInUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get inventoryAssetStatusInUse;

  /// No description provided for @inventoryAssetStatusDisposed.
  ///
  /// In en, this message translates to:
  /// **'Disposed'**
  String get inventoryAssetStatusDisposed;

  /// No description provided for @inventoryAssetStatusSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get inventoryAssetStatusSold;

  /// No description provided for @inventoryAssetStatusTransferred.
  ///
  /// In en, this message translates to:
  /// **'Transferred'**
  String get inventoryAssetStatusTransferred;

  /// No description provided for @inventoryAssetStatusMissingInAssets.
  ///
  /// In en, this message translates to:
  /// **'Not present in fixed assets'**
  String get inventoryAssetStatusMissingInAssets;

  /// No description provided for @inventoryStatusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get inventoryStatusNew;

  /// No description provided for @inventoryStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inventoryStatusInProgress;

  /// No description provided for @inventoryStatusFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get inventoryStatusFinished;

  /// No description provided for @inventoryStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get inventoryStatusUnknown;

  /// No description provided for @inventorySheetNumberSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sheet number has been saved.'**
  String get inventorySheetNumberSavedMessage;

  /// No description provided for @inventoryNumberExampleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. INV/2026/04/001'**
  String get inventoryNumberExampleHint;

  /// No description provided for @inventoryModuleStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Module status'**
  String get inventoryModuleStatusTitle;

  /// No description provided for @inventoryModuleStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current module startup parameters.'**
  String get inventoryModuleStatusSubtitle;

  /// No description provided for @inventoryModuleInitialRoute.
  ///
  /// In en, this message translates to:
  /// **'Initial route'**
  String get inventoryModuleInitialRoute;

  /// No description provided for @inventoryModuleSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get inventoryModuleSession;

  /// No description provided for @inventoryModuleSessionNoAuthContext.
  ///
  /// In en, this message translates to:
  /// **'UI does not require auth context'**
  String get inventoryModuleSessionNoAuthContext;

  /// No description provided for @bhpUsersFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get bhpUsersFilterActive;

  /// No description provided for @bhpUsersFilterArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get bhpUsersFilterArchived;

  /// No description provided for @bhpUsersFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bhpUsersFilterAll;

  /// No description provided for @bhpUsersRowNumber.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get bhpUsersRowNumber;

  /// No description provided for @bhpUsersOverdueLabel.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get bhpUsersOverdueLabel;

  /// No description provided for @bhpUsersUpcomingLabel.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get bhpUsersUpcomingLabel;

  /// No description provided for @bhpUsersDaysSuffix.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get bhpUsersDaysSuffix;

  /// No description provided for @bhpUserIssuesViewActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get bhpUserIssuesViewActive;

  /// No description provided for @bhpUserIssuesViewHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get bhpUserIssuesViewHistory;

  /// No description provided for @bhpUserIssuesViewStandard.
  ///
  /// In en, this message translates to:
  /// **'To standard'**
  String get bhpUserIssuesViewStandard;

  /// No description provided for @bhpSectionStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get bhpSectionStatistics;

  /// No description provided for @bhpOperationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Operations history'**
  String get bhpOperationsTitle;

  /// No description provided for @bhpOperationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full list of BHP operations for the selected year.'**
  String get bhpOperationsSubtitle;

  /// No description provided for @bhpOperationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No operations'**
  String get bhpOperationsEmptyTitle;

  /// No description provided for @bhpOperationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No BHP operations were found for the selected year.'**
  String get bhpOperationsEmptyMessage;

  /// No description provided for @bhpStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Operations statistics'**
  String get bhpStatisticsTitle;

  /// No description provided for @bhpStatisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly summary of BHP operations.'**
  String get bhpStatisticsSubtitle;

  /// No description provided for @bhpStatisticsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No statistical data'**
  String get bhpStatisticsEmptyTitle;

  /// No description provided for @bhpStatisticsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No BHP operations were found for the selected year, so statistics cannot be calculated yet.'**
  String get bhpStatisticsEmptyMessage;

  /// No description provided for @bhpStatisticsOperationsTab.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get bhpStatisticsOperationsTab;

  /// No description provided for @bhpStatisticsMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get bhpStatisticsMonthLabel;

  /// No description provided for @bhpStatisticsMonthlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly statistics'**
  String get bhpStatisticsMonthlyTitle;

  /// No description provided for @bhpStatisticsOperationsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get bhpStatisticsOperationsCountLabel;

  /// No description provided for @bhpStatisticsItemsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get bhpStatisticsItemsCountLabel;

  /// No description provided for @bhpStatisticsUsersCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get bhpStatisticsUsersCountLabel;

  /// No description provided for @bhpStatisticsDominantTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dominant type'**
  String get bhpStatisticsDominantTypeLabel;

  /// No description provided for @bhpStatisticsOperationsCaption.
  ///
  /// In en, this message translates to:
  /// **'Events in the selected month'**
  String get bhpStatisticsOperationsCaption;

  /// No description provided for @bhpStatisticsItemsCaption.
  ///
  /// In en, this message translates to:
  /// **'Total quantity from operations'**
  String get bhpStatisticsItemsCaption;

  /// No description provided for @bhpStatisticsUsersCaption.
  ///
  /// In en, this message translates to:
  /// **'Unique people involved'**
  String get bhpStatisticsUsersCaption;

  /// No description provided for @bhpStatisticsDominantTypeCaptionNone.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get bhpStatisticsDominantTypeCaptionNone;

  /// No description provided for @bhpStatisticsDominantTypeCaptionMany.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String bhpStatisticsDominantTypeCaptionMany(int count);

  /// No description provided for @bhpStatisticsTopEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Most issued items'**
  String get bhpStatisticsTopEquipmentTitle;

  /// No description provided for @bhpStatisticsTopUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'Most active employees'**
  String get bhpStatisticsTopUsersTitle;

  /// No description provided for @bhpStatisticsMonthEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No data for the selected month.'**
  String get bhpStatisticsMonthEmptyMessage;

  /// No description provided for @bhpStatisticsIssuesTab.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get bhpStatisticsIssuesTab;

  /// No description provided for @bhpStatisticsStructureTab.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get bhpStatisticsStructureTab;

  /// No description provided for @bhpStatisticsMissingTab.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get bhpStatisticsMissingTab;

  /// No description provided for @bhpStatisticsComparisonsTab.
  ///
  /// In en, this message translates to:
  /// **'Comparisons'**
  String get bhpStatisticsComparisonsTab;

  /// No description provided for @bhpStatisticsStructurePlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get bhpStatisticsStructurePlaceholderTitle;

  /// No description provided for @bhpStatisticsStructurePlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Operation types, positions, and equipment breakdowns will be built here.'**
  String get bhpStatisticsStructurePlaceholderMessage;

  /// No description provided for @bhpStatisticsStructureSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Operation structure'**
  String get bhpStatisticsStructureSummaryTitle;

  /// No description provided for @bhpStatisticsStructureSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Breakdowns show which items, positions, and people generated the most operations in the selected year.'**
  String get bhpStatisticsStructureSummarySubtitle;

  /// No description provided for @bhpStatisticsStructureEquipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Distinct items'**
  String get bhpStatisticsStructureEquipmentLabel;

  /// No description provided for @bhpStatisticsStructurePositionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Distinct positions'**
  String get bhpStatisticsStructurePositionsLabel;

  /// No description provided for @bhpStatisticsStructureTypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Operation types'**
  String get bhpStatisticsStructureTypesTitle;

  /// No description provided for @bhpStatisticsStructureTypesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The share of each type within the full yearly operation feed.'**
  String get bhpStatisticsStructureTypesSubtitle;

  /// No description provided for @bhpStatisticsStructureShareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get bhpStatisticsStructureShareLabel;

  /// No description provided for @bhpStatisticsStructureEquipmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Equipment cards ranked by operation count and issued quantity.'**
  String get bhpStatisticsStructureEquipmentSubtitle;

  /// No description provided for @bhpStatisticsStructurePositionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Positions'**
  String get bhpStatisticsStructurePositionsTitle;

  /// No description provided for @bhpStatisticsStructurePositionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which positions had the most operations and the highest issued quantities.'**
  String get bhpStatisticsStructurePositionsSubtitle;

  /// No description provided for @bhpStatisticsStructureUsersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clicking an employee opens their issue card.'**
  String get bhpStatisticsStructureUsersSubtitle;

  /// No description provided for @bhpStatisticsStructureIssuedCountTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sum of all individual equipment issue events this year.'**
  String get bhpStatisticsStructureIssuedCountTooltip;

  /// No description provided for @bhpStatisticsStructureIssuedQuantityTooltip.
  ///
  /// In en, this message translates to:
  /// **'Total number of pieces or pairs of equipment issued to employees.'**
  String get bhpStatisticsStructureIssuedQuantityTooltip;

  /// No description provided for @bhpStatisticsStructureEquipmentTooltip.
  ///
  /// In en, this message translates to:
  /// **'Number of different equipment types issued this year.'**
  String get bhpStatisticsStructureEquipmentTooltip;

  /// No description provided for @bhpStatisticsStructureUsersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Number of unique employees who received at least one issue this year.'**
  String get bhpStatisticsStructureUsersTooltip;

  /// No description provided for @bhpStatisticsMissingPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get bhpStatisticsMissingPlaceholderTitle;

  /// No description provided for @bhpStatisticsMissingPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'A global view of users with incomplete equipment will be built here.'**
  String get bhpStatisticsMissingPlaceholderMessage;

  /// No description provided for @bhpStatisticsMissingSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Missing vs standard'**
  String get bhpStatisticsMissingSummaryTitle;

  /// No description provided for @bhpStatisticsMissingSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This tab will show who is missing which items compared with their assigned equipment standard.'**
  String get bhpStatisticsMissingSummarySubtitle;

  /// No description provided for @bhpStatisticsMissingPeopleLabel.
  ///
  /// In en, this message translates to:
  /// **'People with gaps'**
  String get bhpStatisticsMissingPeopleLabel;

  /// No description provided for @bhpStatisticsMissingItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Missing items'**
  String get bhpStatisticsMissingItemsLabel;

  /// No description provided for @bhpStatisticsMissingTopItemLabel.
  ///
  /// In en, this message translates to:
  /// **'Most common gap'**
  String get bhpStatisticsMissingTopItemLabel;

  /// No description provided for @bhpStatisticsMissingPeopleTooltip.
  ///
  /// In en, this message translates to:
  /// **'This is the number of active employees who are currently missing at least one required item from their position standard.'**
  String get bhpStatisticsMissingPeopleTooltip;

  /// No description provided for @bhpStatisticsMissingItemsTooltip.
  ///
  /// In en, this message translates to:
  /// **'This is the total number of standard items that currently have no active issue assigned to employees.'**
  String get bhpStatisticsMissingItemsTooltip;

  /// No description provided for @bhpStatisticsMissingTopItemTooltip.
  ///
  /// In en, this message translates to:
  /// **'This is the piece of equipment that appears most often in today\'s missing list.'**
  String get bhpStatisticsMissingTopItemTooltip;

  /// No description provided for @bhpStatisticsMissingBackendTitle.
  ///
  /// In en, this message translates to:
  /// **'What will be shown here'**
  String get bhpStatisticsMissingBackendTitle;

  /// No description provided for @bhpStatisticsMissingBackendMessage.
  ///
  /// In en, this message translates to:
  /// **'Once the data is connected, this tab will show users with incomplete equipment, missing item counts per person, and the most frequently missing items.'**
  String get bhpStatisticsMissingBackendMessage;

  /// No description provided for @bhpStatisticsMissingTableTitle.
  ///
  /// In en, this message translates to:
  /// **'People with missing equipment'**
  String get bhpStatisticsMissingTableTitle;

  /// No description provided for @bhpStatisticsMissingTableMessage.
  ///
  /// In en, this message translates to:
  /// **'This table will be used operationally: sorting by missing count, person, and position.'**
  String get bhpStatisticsMissingTableMessage;

  /// No description provided for @bhpStatisticsMissingTableItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Missing items list'**
  String get bhpStatisticsMissingTableItemsLabel;

  /// No description provided for @bhpStatisticsMissingTableLatestIssueLabel.
  ///
  /// In en, this message translates to:
  /// **'Last closure'**
  String get bhpStatisticsMissingTableLatestIssueLabel;

  /// No description provided for @bhpStatisticsMissingNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No missing equipment'**
  String get bhpStatisticsMissingNoDataTitle;

  /// No description provided for @bhpStatisticsMissingNoDataMessage.
  ///
  /// In en, this message translates to:
  /// **'At the moment all active employees have complete active issues compared with their standard.'**
  String get bhpStatisticsMissingNoDataMessage;

  /// No description provided for @bhpStatisticsMissingEndpointTitle.
  ///
  /// In en, this message translates to:
  /// **'Required backend data'**
  String get bhpStatisticsMissingEndpointTitle;

  /// No description provided for @bhpStatisticsMissingEndpointMessage.
  ///
  /// In en, this message translates to:
  /// **'This tab needs a separate global missing-equipment endpoint. The current issue data is not enough to calculate this view for all employees.'**
  String get bhpStatisticsMissingEndpointMessage;

  /// No description provided for @bhpStatisticsComparisonsPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Comparisons'**
  String get bhpStatisticsComparisonsPlaceholderTitle;

  /// No description provided for @bhpStatisticsComparisonsPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Year-over-year and month-over-month comparisons will be built here.'**
  String get bhpStatisticsComparisonsPlaceholderMessage;

  /// No description provided for @bhpStatisticsIssuesSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed issue statistics'**
  String get bhpStatisticsIssuesSummaryTitle;

  /// No description provided for @bhpStatisticsIssuesSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'The selected year is shown first and the previous year appears in parentheses.'**
  String get bhpStatisticsIssuesSummarySubtitle;

  /// No description provided for @bhpStatisticsIssuesTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Issued items list'**
  String get bhpStatisticsIssuesTableTitle;

  /// No description provided for @bhpStatisticsIssuesTableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sorted by total quantity issued in the selected year.'**
  String get bhpStatisticsIssuesTableSubtitle;

  /// No description provided for @bhpStatisticsIssuesNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get bhpStatisticsIssuesNoDataTitle;

  /// No description provided for @bhpStatisticsIssuesNoDataMessage.
  ///
  /// In en, this message translates to:
  /// **'There were no issues in the selected year.'**
  String get bhpStatisticsIssuesNoDataMessage;

  /// No description provided for @bhpStatisticsIssuesIssuedQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Total issued quantity'**
  String get bhpStatisticsIssuesIssuedQuantityLabel;

  /// No description provided for @bhpStatisticsIssuesIssuedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue count'**
  String get bhpStatisticsIssuesIssuedCountLabel;

  /// No description provided for @bhpStatisticsIssuesClosedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Closed count'**
  String get bhpStatisticsIssuesClosedCountLabel;

  /// No description provided for @bhpStatisticsIssuesEquivalentCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Equivalent count'**
  String get bhpStatisticsIssuesEquivalentCountLabel;

  /// No description provided for @bhpStatisticsIssuesOperationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'This includes every event saved this year: issues, closures, and equivalents.'**
  String get bhpStatisticsIssuesOperationsTooltip;

  /// No description provided for @bhpStatisticsIssuesIssuedQuantityTooltip.
  ///
  /// In en, this message translates to:
  /// **'This is the total number of items issued to employees during the year.'**
  String get bhpStatisticsIssuesIssuedQuantityTooltip;

  /// No description provided for @bhpStatisticsIssuesIssuedCountTooltip.
  ///
  /// In en, this message translates to:
  /// **'This is the number of issue actions performed during the year, regardless of how many items were included in each one.'**
  String get bhpStatisticsIssuesIssuedCountTooltip;

  /// No description provided for @bhpStatisticsIssuesClosedCountTooltip.
  ///
  /// In en, this message translates to:
  /// **'This is the number of issues that were closed or returned during the year.'**
  String get bhpStatisticsIssuesClosedCountTooltip;

  /// No description provided for @bhpStatisticsIssuesEquivalentCountTooltip.
  ///
  /// In en, this message translates to:
  /// **'This is the number of cases where an equivalent was registered instead of a regular issue.'**
  String get bhpStatisticsIssuesEquivalentCountTooltip;

  /// No description provided for @bhpStatisticsIssuesComparisonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading comparison...'**
  String get bhpStatisticsIssuesComparisonLoading;

  /// No description provided for @bhpStatisticsIssuesTableOperationsSuffix.
  ///
  /// In en, this message translates to:
  /// **'{count} operations'**
  String bhpStatisticsIssuesTableOperationsSuffix(int count);

  /// No description provided for @bhpIssueOperationsTabOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get bhpIssueOperationsTabOperations;

  /// No description provided for @bhpIssueOperationsTabStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get bhpIssueOperationsTabStatistics;

  /// No description provided for @bhpIssueOperationsStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly statistics'**
  String get bhpIssueOperationsStatisticsTitle;

  /// No description provided for @bhpIssueOperationsStatisticsYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get bhpIssueOperationsStatisticsYearLabel;

  /// No description provided for @bhpIssueOperationsStatisticsNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No monthly data'**
  String get bhpIssueOperationsStatisticsNoDataTitle;

  /// No description provided for @bhpIssueOperationsStatisticsNoDataMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no operations in the selected year to calculate statistics from.'**
  String get bhpIssueOperationsStatisticsNoDataMessage;

  /// No description provided for @bhpIssueOperationsStatisticsOperationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get bhpIssueOperationsStatisticsOperationsLabel;

  /// No description provided for @bhpIssueOperationsStatisticsItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get bhpIssueOperationsStatisticsItemsLabel;

  /// No description provided for @bhpIssueOperationsStatisticsUsersLabel.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get bhpIssueOperationsStatisticsUsersLabel;

  /// No description provided for @bhpIssueOperationsStatisticsDominantTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dominant type'**
  String get bhpIssueOperationsStatisticsDominantTypeLabel;

  /// No description provided for @bhpIssueOperationsStatisticsOperationsCaption.
  ///
  /// In en, this message translates to:
  /// **'Events in the selected month'**
  String get bhpIssueOperationsStatisticsOperationsCaption;

  /// No description provided for @bhpIssueOperationsStatisticsItemsCaption.
  ///
  /// In en, this message translates to:
  /// **'Total quantity from operations'**
  String get bhpIssueOperationsStatisticsItemsCaption;

  /// No description provided for @bhpIssueOperationsStatisticsUsersCaption.
  ///
  /// In en, this message translates to:
  /// **'Unique people involved in movement'**
  String get bhpIssueOperationsStatisticsUsersCaption;

  /// No description provided for @bhpIssueOperationsStatisticsDominantTypeCaptionNone.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get bhpIssueOperationsStatisticsDominantTypeCaptionNone;

  /// No description provided for @bhpIssueOperationsStatisticsDominantTypeCaptionMany.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String bhpIssueOperationsStatisticsDominantTypeCaptionMany(int count);

  /// No description provided for @bhpIssueOperationsStatisticsTopEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Most frequently issued items'**
  String get bhpIssueOperationsStatisticsTopEquipmentTitle;

  /// No description provided for @bhpIssueOperationsStatisticsTopUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'Most active employees'**
  String get bhpIssueOperationsStatisticsTopUsersTitle;

  /// No description provided for @bhpIssueOperationsStatisticsNoMonthItemsMessage.
  ///
  /// In en, this message translates to:
  /// **'No data for the selected month.'**
  String get bhpIssueOperationsStatisticsNoMonthItemsMessage;

  /// No description provided for @bhpOperationsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search employee, equipment, or description...'**
  String get bhpOperationsSearchHint;

  /// No description provided for @bhpUserIssuesStandardTitle.
  ///
  /// In en, this message translates to:
  /// **'To issue from standard'**
  String get bhpUserIssuesStandardTitle;

  /// No description provided for @bhpUserIssuesStandardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Missing position-standard items without an active issue.'**
  String get bhpUserIssuesStandardSubtitle;

  /// No description provided for @bhpUserIssuesStandardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No missing items'**
  String get bhpUserIssuesStandardEmptyTitle;

  /// No description provided for @bhpUserIssuesStandardEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'All active position-standard items are already covered by active issues.'**
  String get bhpUserIssuesStandardEmptyMessage;

  /// No description provided for @bhpUserIssuesStandardSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search standard gaps...'**
  String get bhpUserIssuesStandardSearchHint;

  /// No description provided for @bhpUserIssuesHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Issue history'**
  String get bhpUserIssuesHistoryTitle;

  /// No description provided for @bhpUserIssuesHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Closed issues. You can reissue them if the employee no longer has the same active card.'**
  String get bhpUserIssuesHistorySubtitle;

  /// No description provided for @bhpUserIssuesHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No issue history'**
  String get bhpUserIssuesHistoryEmptyTitle;

  /// No description provided for @bhpUserIssuesHistoryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This employee has no closed issues yet.'**
  String get bhpUserIssuesHistoryEmptyMessage;

  /// No description provided for @bhpUserIssuesActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active issues'**
  String get bhpUserIssuesActiveTitle;

  /// No description provided for @bhpUserIssuesActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Equipment currently issued to the employee. This is where you close or reissue items.'**
  String get bhpUserIssuesActiveSubtitle;

  /// No description provided for @bhpUserIssuesActiveEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No active issues'**
  String get bhpUserIssuesActiveEmptyTitle;

  /// No description provided for @bhpUserIssuesActiveEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'The employee currently has no active issue.'**
  String get bhpUserIssuesActiveEmptyMessage;

  /// No description provided for @bhpUserIssuesBlockedBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Issues blocked'**
  String get bhpUserIssuesBlockedBannerTitle;

  /// No description provided for @bhpUserIssuesBlockedBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'The employee cannot receive issues right now. Check the employee and position status.'**
  String get bhpUserIssuesBlockedBannerMessage;

  /// No description provided for @bhpUserIssuesCompliantBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Compliant with standard'**
  String get bhpUserIssuesCompliantBannerTitle;

  /// No description provided for @bhpUserIssuesCompliantBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'All active position-standard items are covered by active issues. Active issues: {count}.'**
  String bhpUserIssuesCompliantBannerMessage(int count);

  /// No description provided for @bhpUserIssuesMissingBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Standard gaps'**
  String get bhpUserIssuesMissingBannerTitle;

  /// No description provided for @bhpUserIssuesMissingBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'Missing {count} items required by the position standard. Add them in the \"To issue from standard\" section.'**
  String bhpUserIssuesMissingBannerMessage(int count);

  /// No description provided for @bhpUserIssuesNoNameFallback.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get bhpUserIssuesNoNameFallback;

  /// No description provided for @bhpUserIssuesRenewAction.
  ///
  /// In en, this message translates to:
  /// **'Reissue'**
  String get bhpUserIssuesRenewAction;

  /// No description provided for @bhpUserIssuesIssueStandardConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Issue standard item'**
  String get bhpUserIssuesIssueStandardConfirmTitle;

  /// No description provided for @bhpUserIssuesIssueStandardConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to issue {item} according to the position standard?'**
  String bhpUserIssuesIssueStandardConfirmMessage(Object item);

  /// No description provided for @bhpUserIssuesIssueStandardConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get bhpUserIssuesIssueStandardConfirmAction;

  /// No description provided for @bhpUserIssuesIssueStandardSuccess.
  ///
  /// In en, this message translates to:
  /// **'The item has been issued according to the standard.'**
  String get bhpUserIssuesIssueStandardSuccess;

  /// No description provided for @bhpUserIssuesRenewActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Reissue'**
  String get bhpUserIssuesRenewActiveTitle;

  /// No description provided for @bhpUserIssuesRenewActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'The previous active issue {item} will be closed automatically and a new issue will be created today. Continue?'**
  String bhpUserIssuesRenewActiveMessage(Object item);

  /// No description provided for @bhpUserIssuesRenewActiveAction.
  ///
  /// In en, this message translates to:
  /// **'Reissue'**
  String get bhpUserIssuesRenewActiveAction;

  /// No description provided for @bhpUserIssuesRenewActiveSuccess.
  ///
  /// In en, this message translates to:
  /// **'A new issue has been created and the previous one has been closed.'**
  String get bhpUserIssuesRenewActiveSuccess;

  /// No description provided for @bhpUserIssuesPrintSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select items to print'**
  String get bhpUserIssuesPrintSelectTitle;

  /// No description provided for @bhpUserIssuesPrintOnlyActive.
  ///
  /// In en, this message translates to:
  /// **'Active only'**
  String get bhpUserIssuesPrintOnlyActive;

  /// No description provided for @bhpUserIssuesPrintOnlyInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive only'**
  String get bhpUserIssuesPrintOnlyInactive;

  /// No description provided for @bhpUserIssuesPrintAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bhpUserIssuesPrintAll;

  /// No description provided for @bhpUserIssuesPrintEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No items to print'**
  String get bhpUserIssuesPrintEmptyTitle;

  /// No description provided for @bhpUserIssuesPrintEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This employee has no issues to select yet.'**
  String get bhpUserIssuesPrintEmptyMessage;

  /// No description provided for @bhpUserIssuesPrintSelectedAction.
  ///
  /// In en, this message translates to:
  /// **'Print selected'**
  String get bhpUserIssuesPrintSelectedAction;

  /// No description provided for @bhpUserIssuesPrintIssueLabelFallback.
  ///
  /// In en, this message translates to:
  /// **'Item #{id}'**
  String bhpUserIssuesPrintIssueLabelFallback(int id);

  /// No description provided for @bhpUserIssuesLastIssueLabel.
  ///
  /// In en, this message translates to:
  /// **'Last issue'**
  String get bhpUserIssuesLastIssueLabel;

  /// No description provided for @bhpUserIssueInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Equipment card'**
  String get bhpUserIssueInfoSubtitle;

  /// No description provided for @bhpUserIssueInfoNoEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'No equipment card'**
  String get bhpUserIssueInfoNoEquipmentTitle;

  /// No description provided for @bhpUserIssueInfoNoEquipmentMessage.
  ///
  /// In en, this message translates to:
  /// **'This issue has no assigned equipment card.'**
  String get bhpUserIssueInfoNoEquipmentMessage;

  /// No description provided for @bhpUserIssueInfoLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load equipment details'**
  String get bhpUserIssueInfoLoadErrorTitle;

  /// No description provided for @bhpUserIssueInfoRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get bhpUserIssueInfoRetryAction;

  /// No description provided for @bhpUserIssueInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'Equipment card details from the BHP catalog.'**
  String get bhpUserIssueInfoDescription;

  /// No description provided for @bhpUserIssueInfoSymbolLabel.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get bhpUserIssueInfoSymbolLabel;

  /// No description provided for @bhpUserIssueInfoNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get bhpUserIssueInfoNameLabel;

  /// No description provided for @bhpUserIssueInfoUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get bhpUserIssueInfoUnitLabel;

  /// No description provided for @bhpUserIssueInfoPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Usable period'**
  String get bhpUserIssueInfoPeriodLabel;

  /// No description provided for @bhpUserIssueInfoDefaultQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Default quantity'**
  String get bhpUserIssueInfoDefaultQuantityLabel;

  /// No description provided for @bhpUserIssueInfoEvidenceNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue evidence no.'**
  String get bhpUserIssueInfoEvidenceNumberLabel;

  /// No description provided for @bhpUserIssueInfoEquivalentLabel.
  ///
  /// In en, this message translates to:
  /// **'Card equivalent'**
  String get bhpUserIssueInfoEquivalentLabel;

  /// No description provided for @bhpUserIssueInfoPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get bhpUserIssueInfoPriceLabel;

  /// No description provided for @bhpUserIssueInfoAvailabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get bhpUserIssueInfoAvailabilityLabel;

  /// No description provided for @bhpUserIssueInfoPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Usability percentage'**
  String get bhpUserIssueInfoPercentLabel;

  /// No description provided for @bhpUserIssueInfoStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bhpUserIssueInfoStatusLabel;

  /// No description provided for @bhpUserIssueInfoMonthSuffix.
  ///
  /// In en, this message translates to:
  /// **'mo.'**
  String get bhpUserIssueInfoMonthSuffix;

  /// No description provided for @bhpUserIssuesPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'BHP EQUIPMENT CARD'**
  String get bhpUserIssuesPdfTitle;

  /// No description provided for @bhpUserIssuesPdfIssuerSignatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Issuer signature'**
  String get bhpUserIssuesPdfIssuerSignatureLabel;

  /// No description provided for @bhpUserIssuesPdfEmployeeSignatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee signature'**
  String get bhpUserIssuesPdfEmployeeSignatureLabel;

  /// No description provided for @bhpUserIssuesPdfDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'I confirm receipt of the above equipment in a condition suitable for use and I agree to use it according to its intended purpose.'**
  String get bhpUserIssuesPdfDisclaimer;

  /// No description provided for @bhpUserIssuesPdfHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get bhpUserIssuesPdfHeightLabel;

  /// No description provided for @bhpUserIssuesPdfChestLabel.
  ///
  /// In en, this message translates to:
  /// **'Chest circumference'**
  String get bhpUserIssuesPdfChestLabel;

  /// No description provided for @bhpUserIssuesPdfWaistLabel.
  ///
  /// In en, this message translates to:
  /// **'Waist circumference'**
  String get bhpUserIssuesPdfWaistLabel;

  /// No description provided for @bhpUserIssuesPdfHeadLabel.
  ///
  /// In en, this message translates to:
  /// **'Head circumference'**
  String get bhpUserIssuesPdfHeadLabel;

  /// No description provided for @bhpUserIssuesPdfFootLabel.
  ///
  /// In en, this message translates to:
  /// **'Foot length'**
  String get bhpUserIssuesPdfFootLabel;

  /// No description provided for @bhpUserIssuesPdfPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {current} / {total}'**
  String bhpUserIssuesPdfPageLabel(int current, int total);

  /// No description provided for @bhpIssueFormEquipmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Equipment is required.'**
  String get bhpIssueFormEquipmentRequired;

  /// No description provided for @bhpIssueNoEquipmentFallback.
  ///
  /// In en, this message translates to:
  /// **'No equipment'**
  String get bhpIssueNoEquipmentFallback;

  /// No description provided for @bhpIssueCardFallback.
  ///
  /// In en, this message translates to:
  /// **'Card #{id}'**
  String bhpIssueCardFallback(int id);

  /// No description provided for @bhpIssueUnknownEquipmentFallback.
  ///
  /// In en, this message translates to:
  /// **'Unknown equipment'**
  String get bhpIssueUnknownEquipmentFallback;

  /// No description provided for @bhpIssueEquivalentHelperExisting.
  ///
  /// In en, this message translates to:
  /// **'You can change the equivalent date and amount. The date cannot be earlier than the issue date.'**
  String get bhpIssueEquivalentHelperExisting;

  /// No description provided for @bhpIssueEquivalentHelperOpen.
  ///
  /// In en, this message translates to:
  /// **'You can enter an equivalent even for an open issue. The date cannot be earlier than the issue date.'**
  String get bhpIssueEquivalentHelperOpen;

  /// No description provided for @bhpIssueEquivalentHelperClosed.
  ///
  /// In en, this message translates to:
  /// **'The date cannot be earlier than the issue date or the issue closing date.'**
  String get bhpIssueEquivalentHelperClosed;

  /// No description provided for @bhpIssueEquivalentInvalidIssueDate.
  ///
  /// In en, this message translates to:
  /// **'The equivalent date cannot be earlier than the issue date.'**
  String get bhpIssueEquivalentInvalidIssueDate;

  /// No description provided for @bhpIssueEquivalentInvalidCloseDate.
  ///
  /// In en, this message translates to:
  /// **'The equivalent date cannot be earlier than the issue closing date.'**
  String get bhpIssueEquivalentInvalidCloseDate;

  /// No description provided for @bhpIssueValidationPositiveAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount greater than 0.'**
  String get bhpIssueValidationPositiveAmount;

  /// No description provided for @bhpIssueEditInvalidDateMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a valid issue date.'**
  String get bhpIssueEditInvalidDateMessage;

  /// No description provided for @bhpIssueEditMissingSourceMessage.
  ///
  /// In en, this message translates to:
  /// **'This issue cannot be edited because source data is missing.'**
  String get bhpIssueEditMissingSourceMessage;

  /// No description provided for @bhpUserIssueCommandInProgress.
  ///
  /// In en, this message translates to:
  /// **'An operation is already in progress.'**
  String get bhpUserIssueCommandInProgress;

  /// No description provided for @bhpDeleteUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete employee'**
  String get bhpDeleteUserTitle;

  /// No description provided for @bhpDeleteUserSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This operation removes the employee from the active list by archiving them.'**
  String get bhpDeleteUserSubtitle;

  /// No description provided for @bhpDeleteUserConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String bhpDeleteUserConfirmMessage(Object name);

  /// No description provided for @bhpDeleteUserArchiveMessage.
  ///
  /// In en, this message translates to:
  /// **'This operation irreversibly deletes the employee and all BHP history from the database.'**
  String get bhpDeleteUserArchiveMessage;

  /// No description provided for @bhpArchiveUserAction.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get bhpArchiveUserAction;

  /// No description provided for @bhpArchiveUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive employee'**
  String get bhpArchiveUserTitle;

  /// No description provided for @bhpArchiveUserSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This operation removes the employee from the active list, but it does not delete their BHP history.'**
  String get bhpArchiveUserSubtitle;

  /// No description provided for @bhpArchiveUserConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to archive {name}?'**
  String bhpArchiveUserConfirmMessage(Object name);

  /// No description provided for @bhpArchiveUserMessage.
  ///
  /// In en, this message translates to:
  /// **'The employee will be moved to the archive and removed from the active list. Their BHP history will remain available, and the employee can be restored later.'**
  String get bhpArchiveUserMessage;

  /// No description provided for @bhpStatisticsComparisonsTabMetrics.
  ///
  /// In en, this message translates to:
  /// **'Annual indicators'**
  String get bhpStatisticsComparisonsTabMetrics;

  /// No description provided for @bhpStatisticsComparisonsTabProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get bhpStatisticsComparisonsTabProducts;

  /// No description provided for @bhpStatisticsComparisonsTabEquivalents.
  ///
  /// In en, this message translates to:
  /// **'Equivalents'**
  String get bhpStatisticsComparisonsTabEquivalents;

  /// No description provided for @bhpStatisticsComparisonsMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comparison of main annual indicators'**
  String get bhpStatisticsComparisonsMetricsTitle;

  /// No description provided for @bhpStatisticsComparisonsMetricsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summary of key BHP indicators for the selected year and two years back.'**
  String get bhpStatisticsComparisonsMetricsSubtitle;

  /// No description provided for @bhpStatisticsComparisonsTableColumnMetric.
  ///
  /// In en, this message translates to:
  /// **'Indicator'**
  String get bhpStatisticsComparisonsTableColumnMetric;

  /// No description provided for @bhpStatisticsComparisonsYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year {year}'**
  String bhpStatisticsComparisonsYearLabel(int year);

  /// No description provided for @bhpStatisticsComparisonsProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comparison of product issues (BHP items)'**
  String get bhpStatisticsComparisonsProductsTitle;

  /// No description provided for @bhpStatisticsComparisonsProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summary of demand for individual products in the format: Number of issues (Quantity).'**
  String get bhpStatisticsComparisonsProductsSubtitle;

  /// No description provided for @bhpStatisticsComparisonsTableColumnProduct.
  ///
  /// In en, this message translates to:
  /// **'Product / BHP item'**
  String get bhpStatisticsComparisonsTableColumnProduct;

  /// No description provided for @bhpStatisticsComparisonsEquivalentsCountRow.
  ///
  /// In en, this message translates to:
  /// **'Number of equivalents paid'**
  String get bhpStatisticsComparisonsEquivalentsCountRow;

  /// No description provided for @bhpStatisticsComparisonsEquivalentsCountTooltip.
  ///
  /// In en, this message translates to:
  /// **'Total number of registered monetary equivalent payments in a given year.'**
  String get bhpStatisticsComparisonsEquivalentsCountTooltip;

  /// No description provided for @bhpStatisticsComparisonsEquivalentsAmountRow.
  ///
  /// In en, this message translates to:
  /// **'Total equivalents paid'**
  String get bhpStatisticsComparisonsEquivalentsAmountRow;

  /// No description provided for @bhpStatisticsComparisonsEquivalentsAmountTooltip.
  ///
  /// In en, this message translates to:
  /// **'Total sum of paid equivalent amounts (in PLN) in a given year.'**
  String get bhpStatisticsComparisonsEquivalentsAmountTooltip;

  /// No description provided for @bhpStatisticsComparisonsEquivalentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary of equivalents'**
  String get bhpStatisticsComparisonsEquivalentsTitle;

  /// No description provided for @bhpStatisticsComparisonsEquivalentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summary of the number of paid equivalents and their total annual sum.'**
  String get bhpStatisticsComparisonsEquivalentsSubtitle;

  /// No description provided for @bhpStatisticsComparisonsEquivalentsProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Equivalents by products (BHP items)'**
  String get bhpStatisticsComparisonsEquivalentsProductsTitle;

  /// No description provided for @bhpStatisticsComparisonsEquivalentsProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summary of equivalent payments for individual products in the format: Number of payments (Total PLN).'**
  String get bhpStatisticsComparisonsEquivalentsProductsSubtitle;

  /// No description provided for @bhpCurrencyPln.
  ///
  /// In en, this message translates to:
  /// **'PLN'**
  String get bhpCurrencyPln;

  /// No description provided for @bhpStatisticsChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Visualization'**
  String get bhpStatisticsChartTitle;

  /// No description provided for @bhpStatisticsChartToggleCount.
  ///
  /// In en, this message translates to:
  /// **'Number of operations'**
  String get bhpStatisticsChartToggleCount;

  /// No description provided for @bhpStatisticsChartToggleQuantity.
  ///
  /// In en, this message translates to:
  /// **'Issued quantity'**
  String get bhpStatisticsChartToggleQuantity;

  /// No description provided for @bhpStatisticsChartStructureEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Most frequently issued items (Top 5)'**
  String get bhpStatisticsChartStructureEquipmentTitle;

  /// No description provided for @bhpStatisticsChartStructurePositionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Issues by position (Top 5)'**
  String get bhpStatisticsChartStructurePositionsTitle;

  /// No description provided for @bhpStatisticsChartComparisonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Visual Metric Comparison'**
  String get bhpStatisticsChartComparisonsTitle;

  /// No description provided for @inventoryEditDatesAction.
  ///
  /// In en, this message translates to:
  /// **'Edit dates'**
  String get inventoryEditDatesAction;

  /// No description provided for @inventoryEditDatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit inventory dates'**
  String get inventoryEditDatesTitle;

  /// No description provided for @inventoryEditDatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change the date range of the active inventory.'**
  String get inventoryEditDatesSubtitle;

  /// No description provided for @inventoryDatesSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Inventory dates have been saved.'**
  String get inventoryDatesSavedMessage;

  /// No description provided for @inventoryTreeProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Sheet completion'**
  String get inventoryTreeProgressTitle;

  /// No description provided for @inventoryTreeLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load the tree'**
  String get inventoryTreeLoadErrorTitle;

  /// No description provided for @inventoryRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get inventoryRetryAction;

  /// No description provided for @inventoryTreeNoLocationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No locations to display'**
  String get inventoryTreeNoLocationsTitle;

  /// No description provided for @inventoryTreeNoLocationsMessage.
  ///
  /// In en, this message translates to:
  /// **'This inventory has no assigned locations yet.'**
  String get inventoryTreeNoLocationsMessage;

  /// No description provided for @inventoryTreeNodesSummary.
  ///
  /// In en, this message translates to:
  /// **'Nodes: {count}'**
  String inventoryTreeNodesSummary(int count);

  /// No description provided for @inventoryTreeNodesAmbiguousSummary.
  ///
  /// In en, this message translates to:
  /// **'Nodes: {count} • ambiguous: {ambiguous}'**
  String inventoryTreeNodesAmbiguousSummary(int count, int ambiguous);

  /// No description provided for @inventoryTreeCompanySummary.
  ///
  /// In en, this message translates to:
  /// **'{places, plural, =1{1 location} other{{places} locations}} • {sheets} with sheets'**
  String inventoryTreeCompanySummary(int places, int sheets);

  /// No description provided for @inventoryTreeCompanyAmbiguousSuffix.
  ///
  /// In en, this message translates to:
  /// **' • contains ambiguous locations'**
  String get inventoryTreeCompanyAmbiguousSuffix;

  /// No description provided for @inventoryProductsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}}'**
  String inventoryProductsCount(int count);

  /// No description provided for @inventoryTreeIncompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Incomplete ({count})'**
  String inventoryTreeIncompleteTitle(int count);

  /// No description provided for @inventoryTreeStatusAmbiguous.
  ///
  /// In en, this message translates to:
  /// **'Ambiguous'**
  String get inventoryTreeStatusAmbiguous;

  /// No description provided for @inventoryTreeStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get inventoryTreeStatusCompleted;

  /// No description provided for @inventoryTreeStatusMissingSheet.
  ///
  /// In en, this message translates to:
  /// **'Missing sheet'**
  String get inventoryTreeStatusMissingSheet;

  /// No description provided for @inventoryTreeStatusNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products'**
  String get inventoryTreeStatusNoProducts;

  /// No description provided for @inventoryTreeAmbiguousTooltip.
  ///
  /// In en, this message translates to:
  /// **'This location has more than one mapping for the same company and location identifier. The sheet status is uncertain.'**
  String get inventoryTreeAmbiguousTooltip;

  /// No description provided for @inventoryTreeProductsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show the product list for this location'**
  String get inventoryTreeProductsTooltip;

  /// No description provided for @inventoryLocationProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products in location'**
  String get inventoryLocationProductsTitle;

  /// No description provided for @inventoryProductsLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load products'**
  String get inventoryProductsLoadErrorTitle;

  /// No description provided for @inventoryProductsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No products'**
  String get inventoryProductsEmptyTitle;

  /// No description provided for @inventoryProductsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This location has no active products in the stan_st snapshot.'**
  String get inventoryProductsEmptyMessage;

  /// No description provided for @inventoryProductsShownSummary.
  ///
  /// In en, this message translates to:
  /// **'Showing {visible} of {total} products'**
  String inventoryProductsShownSummary(int visible, int total);

  /// No description provided for @inventoryProductsSummary.
  ///
  /// In en, this message translates to:
  /// **'Products: {total}'**
  String inventoryProductsSummary(int total);

  /// No description provided for @inventoryShowingLastDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Showing the last available data'**
  String get inventoryShowingLastDataTitle;

  /// No description provided for @tasksBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Project tasks'**
  String get tasksBoardTitle;

  /// No description provided for @tasksBoardErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not open the board'**
  String get tasksBoardErrorTitle;

  /// No description provided for @tasksBoardForbiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this board'**
  String get tasksBoardForbiddenTitle;

  /// No description provided for @tasksBoardNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'The project or board was not found'**
  String get tasksBoardNotFoundTitle;

  /// No description provided for @tasksBoardOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'No connection to the server'**
  String get tasksBoardOfflineTitle;

  /// No description provided for @tasksBoardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks on the board'**
  String tasksBoardSubtitle(int count);

  /// No description provided for @tasksKanbanQuickFilter.
  ///
  /// In en, this message translates to:
  /// **'Quick board filter'**
  String get tasksKanbanQuickFilter;

  /// No description provided for @tasksKanbanQuickFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All tasks'**
  String get tasksKanbanQuickFilterAll;

  /// No description provided for @tasksKanbanQuickFilterMine.
  ///
  /// In en, this message translates to:
  /// **'My tasks'**
  String get tasksKanbanQuickFilterMine;

  /// No description provided for @tasksKanbanQuickFilterUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get tasksKanbanQuickFilterUnassigned;

  /// No description provided for @tasksKanbanQuickFilterBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get tasksKanbanQuickFilterBlocked;

  /// No description provided for @tasksKanbanQuickFilterDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due within 7 days'**
  String get tasksKanbanQuickFilterDueSoon;

  /// No description provided for @tasksPresenceCount.
  ///
  /// In en, this message translates to:
  /// **'People online: {count}'**
  String tasksPresenceCount(int count);

  /// No description provided for @tasksPresenceOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get tasksPresenceOnline;

  /// No description provided for @tasksPresenceOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get tasksPresenceOffline;

  /// No description provided for @tasksRealtimeConnected.
  ///
  /// In en, this message translates to:
  /// **'Changes are synchronized live'**
  String get tasksRealtimeConnected;

  /// No description provided for @tasksRealtimeConnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting live synchronization…'**
  String get tasksRealtimeConnecting;

  /// No description provided for @tasksRealtimeOffline.
  ///
  /// In en, this message translates to:
  /// **'Live synchronization is offline'**
  String get tasksRealtimeOffline;

  /// No description provided for @tasksColumnEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks in this column'**
  String get tasksColumnEmpty;

  /// No description provided for @tasksQuickCreate.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get tasksQuickCreate;

  /// No description provided for @tasksQuickCreateHint.
  ///
  /// In en, this message translates to:
  /// **'New task name'**
  String get tasksQuickCreateHint;

  /// No description provided for @tasksTemplatesUse.
  ///
  /// In en, this message translates to:
  /// **'Use template'**
  String get tasksTemplatesUse;

  /// No description provided for @tasksTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Create from template'**
  String get tasksTemplatesTitle;

  /// No description provided for @tasksTemplatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a ready-made task layout. Use the star to set your default template.'**
  String get tasksTemplatesDescription;

  /// No description provided for @tasksTemplatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no task templates in this workspace yet.'**
  String get tasksTemplatesEmpty;

  /// No description provided for @tasksTemplatesDefault.
  ///
  /// In en, this message translates to:
  /// **'Your default template'**
  String get tasksTemplatesDefault;

  /// No description provided for @tasksTemplatesApplyHint.
  ///
  /// In en, this message translates to:
  /// **'Click to create a task'**
  String get tasksTemplatesApplyHint;

  /// No description provided for @tasksTemplatesSetDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default template'**
  String get tasksTemplatesSetDefault;

  /// No description provided for @tasksTemplatesClearDefault.
  ///
  /// In en, this message translates to:
  /// **'Clear default template'**
  String get tasksTemplatesClearDefault;

  /// No description provided for @tasksTemplatesNew.
  ///
  /// In en, this message translates to:
  /// **'New template'**
  String get tasksTemplatesNew;

  /// No description provided for @tasksTemplatesNewDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new template from scratch with custom default values.'**
  String get tasksTemplatesNewDescription;

  /// No description provided for @tasksTemplateForThisTask.
  ///
  /// In en, this message translates to:
  /// **'Template for this task'**
  String get tasksTemplateForThisTask;

  /// No description provided for @tasksTemplateNoTemplate.
  ///
  /// In en, this message translates to:
  /// **'No template'**
  String get tasksTemplateNoTemplate;

  /// No description provided for @tasksTemplateDefaultChip.
  ///
  /// In en, this message translates to:
  /// **'Template: {name}'**
  String tasksTemplateDefaultChip(String name);

  /// No description provided for @tasksTemplateUsingDefault.
  ///
  /// In en, this message translates to:
  /// **'Default template'**
  String get tasksTemplateUsingDefault;

  /// No description provided for @tasksBulkSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected: {count}'**
  String tasksBulkSelected(int count);

  /// No description provided for @tasksBulkMove.
  ///
  /// In en, this message translates to:
  /// **'Move selected tasks'**
  String get tasksBulkMove;

  /// No description provided for @tasksBulkPriority.
  ///
  /// In en, this message translates to:
  /// **'Change priority of selected tasks'**
  String get tasksBulkPriority;

  /// No description provided for @tasksBulkDueDate.
  ///
  /// In en, this message translates to:
  /// **'Set due date for selected tasks'**
  String get tasksBulkDueDate;

  /// No description provided for @tasksBulkClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get tasksBulkClearSelection;

  /// No description provided for @tasksSelectLoadedGroup.
  ///
  /// In en, this message translates to:
  /// **'Select only tasks in this group'**
  String get tasksSelectLoadedGroup;

  /// No description provided for @tasksSelectLoadedSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Select only subtasks in this branch'**
  String get tasksSelectLoadedSubtasks;

  /// No description provided for @tasksKeyboardShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Ctrl or Command+A selects loaded tasks, Escape clears the selection, and Alt+Left or Right Arrow scrolls Kanban columns.'**
  String get tasksKeyboardShortcuts;

  /// No description provided for @tasksManageLabels.
  ///
  /// In en, this message translates to:
  /// **'Manage labels'**
  String get tasksManageLabels;

  /// No description provided for @tasksManageCustomFields.
  ///
  /// In en, this message translates to:
  /// **'Custom fields'**
  String get tasksManageCustomFields;

  /// No description provided for @tasksCustomFieldsEmpty.
  ///
  /// In en, this message translates to:
  /// **'This project has no custom fields yet.'**
  String get tasksCustomFieldsEmpty;

  /// No description provided for @tasksCustomFieldText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get tasksCustomFieldText;

  /// No description provided for @tasksCustomFieldNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get tasksCustomFieldNumber;

  /// No description provided for @tasksCustomFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get tasksCustomFieldDate;

  /// No description provided for @tasksCustomFieldBoolean.
  ///
  /// In en, this message translates to:
  /// **'Yes/No'**
  String get tasksCustomFieldBoolean;

  /// No description provided for @tasksCustomFieldSingleSelect.
  ///
  /// In en, this message translates to:
  /// **'Single select'**
  String get tasksCustomFieldSingleSelect;

  /// No description provided for @tasksCustomFieldMultiSelect.
  ///
  /// In en, this message translates to:
  /// **'Multi-select'**
  String get tasksCustomFieldMultiSelect;

  /// No description provided for @tasksCustomFieldUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get tasksCustomFieldUser;

  /// No description provided for @tasksCreateCustomField.
  ///
  /// In en, this message translates to:
  /// **'Add custom field'**
  String get tasksCreateCustomField;

  /// No description provided for @tasksEditCustomField.
  ///
  /// In en, this message translates to:
  /// **'Edit custom field'**
  String get tasksEditCustomField;

  /// No description provided for @tasksArchiveCustomField.
  ///
  /// In en, this message translates to:
  /// **'Archive custom field'**
  String get tasksArchiveCustomField;

  /// No description provided for @tasksArchiveCustomFieldConfirm.
  ///
  /// In en, this message translates to:
  /// **'Archive the “{name}” field? Existing values remain in history, but the field will be removed from new tasks.'**
  String tasksArchiveCustomFieldConfirm(String name);

  /// No description provided for @tasksCustomFieldName.
  ///
  /// In en, this message translates to:
  /// **'Field name'**
  String get tasksCustomFieldName;

  /// No description provided for @tasksCustomFieldType.
  ///
  /// In en, this message translates to:
  /// **'Field type'**
  String get tasksCustomFieldType;

  /// No description provided for @tasksCustomFieldOptions.
  ///
  /// In en, this message translates to:
  /// **'Options (one per line)'**
  String get tasksCustomFieldOptions;

  /// No description provided for @tasksCustomFieldOptionsHint.
  ///
  /// In en, this message translates to:
  /// **'For example: To do, In progress, Done'**
  String get tasksCustomFieldOptionsHint;

  /// No description provided for @tasksCustomFieldNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a field name.'**
  String get tasksCustomFieldNameRequired;

  /// No description provided for @tasksCustomFieldOptionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one option.'**
  String get tasksCustomFieldOptionsRequired;

  /// No description provided for @tasksCustomFieldTypeImmutable.
  ///
  /// In en, this message translates to:
  /// **'The field type is set on creation and cannot be changed.'**
  String get tasksCustomFieldTypeImmutable;

  /// No description provided for @tasksManageMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get tasksManageMilestones;

  /// No description provided for @tasksManageWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Workflow transitions'**
  String get tasksManageWorkflow;

  /// No description provided for @tasksWorkflowDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable the transitions users can make on the Kanban board.'**
  String get tasksWorkflowDescription;

  /// No description provided for @tasksWorkflowEmpty.
  ///
  /// In en, this message translates to:
  /// **'This project has no configured workflow statuses.'**
  String get tasksWorkflowEmpty;

  /// No description provided for @tasksWorkflowAllowTransition.
  ///
  /// In en, this message translates to:
  /// **'Allowed transitions from this status'**
  String get tasksWorkflowAllowTransition;

  /// No description provided for @tasksWorkflowInitial.
  ///
  /// In en, this message translates to:
  /// **'Initial'**
  String get tasksWorkflowInitial;

  /// No description provided for @tasksWorkflowTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get tasksWorkflowTerminal;

  /// No description provided for @tasksCustomWorkflowTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom statuses'**
  String get tasksCustomWorkflowTitle;

  /// No description provided for @tasksCustomWorkflowAddStatus.
  ///
  /// In en, this message translates to:
  /// **'Add status'**
  String get tasksCustomWorkflowAddStatus;

  /// No description provided for @tasksCustomWorkflowStatusName.
  ///
  /// In en, this message translates to:
  /// **'Status name'**
  String get tasksCustomWorkflowStatusName;

  /// No description provided for @tasksCustomWorkflowCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get tasksCustomWorkflowCategory;

  /// No description provided for @tasksCustomWorkflowColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get tasksCustomWorkflowColor;

  /// No description provided for @tasksCustomWorkflowCategoryTodo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get tasksCustomWorkflowCategoryTodo;

  /// No description provided for @tasksCustomWorkflowCategoryInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get tasksCustomWorkflowCategoryInProgress;

  /// No description provided for @tasksCustomWorkflowCategoryDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksCustomWorkflowCategoryDone;

  /// No description provided for @tasksCustomWorkflowCategoryCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tasksCustomWorkflowCategoryCancelled;

  /// No description provided for @tasksCustomWorkflowDefault.
  ///
  /// In en, this message translates to:
  /// **'Default status'**
  String get tasksCustomWorkflowDefault;

  /// No description provided for @tasksCustomWorkflowWip.
  ///
  /// In en, this message translates to:
  /// **'WIP limit'**
  String get tasksCustomWorkflowWip;

  /// No description provided for @tasksCustomWorkflowTemplates.
  ///
  /// In en, this message translates to:
  /// **'Workflow templates'**
  String get tasksCustomWorkflowTemplates;

  /// No description provided for @tasksCustomWorkflowReplaceWarning.
  ///
  /// In en, this message translates to:
  /// **'Applying this template will replace the current custom statuses and their order.'**
  String get tasksCustomWorkflowReplaceWarning;

  /// No description provided for @tasksCustomWorkflowApply.
  ///
  /// In en, this message translates to:
  /// **'Apply template'**
  String get tasksCustomWorkflowApply;

  /// No description provided for @tasksAutomationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Automations'**
  String get tasksAutomationsTitle;

  /// No description provided for @tasksSettings.
  ///
  /// In en, this message translates to:
  /// **'Task settings'**
  String get tasksSettings;

  /// No description provided for @tasksSettingsHubDescription.
  ///
  /// In en, this message translates to:
  /// **'Shared project configuration and private settings in one place.'**
  String get tasksSettingsHubDescription;

  /// No description provided for @tasksAdministration.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get tasksAdministration;

  /// No description provided for @tasksPersonalSettings.
  ///
  /// In en, this message translates to:
  /// **'My settings'**
  String get tasksPersonalSettings;

  /// No description provided for @tasksPersonalSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'This note is private and stored only on this device. Your team cannot see it.'**
  String get tasksPersonalSettingsDescription;

  /// No description provided for @tasksPersonalNote.
  ///
  /// In en, this message translates to:
  /// **'My project note'**
  String get tasksPersonalNote;

  /// No description provided for @tasksPersonalNoteHint.
  ///
  /// In en, this message translates to:
  /// **'For example: this week\'s priorities, work context, or a reminder'**
  String get tasksPersonalNoteHint;

  /// No description provided for @tasksPersonalSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Your settings have been saved.'**
  String get tasksPersonalSettingsSaved;

  /// No description provided for @tasksKanbanSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Kanban settings'**
  String get tasksKanbanSettingsTitle;

  /// No description provided for @tasksKanbanSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure the shared board layout for the whole project.'**
  String get tasksKanbanSettingsDescription;

  /// No description provided for @tasksKanbanLayout.
  ///
  /// In en, this message translates to:
  /// **'Board layout'**
  String get tasksKanbanLayout;

  /// No description provided for @tasksKanbanSwimlane.
  ///
  /// In en, this message translates to:
  /// **'Horizontal grouping'**
  String get tasksKanbanSwimlane;

  /// No description provided for @tasksKanbanSwimlaneNone.
  ///
  /// In en, this message translates to:
  /// **'No grouping'**
  String get tasksKanbanSwimlaneNone;

  /// No description provided for @tasksKanbanSwimlaneAssignee.
  ///
  /// In en, this message translates to:
  /// **'By assignee'**
  String get tasksKanbanSwimlaneAssignee;

  /// No description provided for @tasksKanbanSwimlanePriority.
  ///
  /// In en, this message translates to:
  /// **'By priority'**
  String get tasksKanbanSwimlanePriority;

  /// No description provided for @tasksKanbanSwimlaneMilestone.
  ///
  /// In en, this message translates to:
  /// **'By milestone'**
  String get tasksKanbanSwimlaneMilestone;

  /// No description provided for @tasksKanbanCardDensity.
  ///
  /// In en, this message translates to:
  /// **'Card density'**
  String get tasksKanbanCardDensity;

  /// No description provided for @tasksKanbanDensityCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get tasksKanbanDensityCompact;

  /// No description provided for @tasksKanbanDensityComfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get tasksKanbanDensityComfortable;

  /// No description provided for @tasksKanbanDensityDetailed.
  ///
  /// In en, this message translates to:
  /// **'Detailed'**
  String get tasksKanbanDensityDetailed;

  /// No description provided for @tasksKanbanVisibleColumns.
  ///
  /// In en, this message translates to:
  /// **'Visible system columns'**
  String get tasksKanbanVisibleColumns;

  /// No description provided for @tasksKanbanCardFields.
  ///
  /// In en, this message translates to:
  /// **'Card fields'**
  String get tasksKanbanCardFields;

  /// No description provided for @tasksKanbanFieldAssignee.
  ///
  /// In en, this message translates to:
  /// **'Assignees'**
  String get tasksKanbanFieldAssignee;

  /// No description provided for @tasksKanbanFieldDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get tasksKanbanFieldDueDate;

  /// No description provided for @tasksKanbanFieldLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get tasksKanbanFieldLabels;

  /// No description provided for @tasksKanbanFieldChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get tasksKanbanFieldChecklist;

  /// No description provided for @tasksKanbanFieldSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get tasksKanbanFieldSubtasks;

  /// No description provided for @tasksKanbanFieldTimeTracking.
  ///
  /// In en, this message translates to:
  /// **'Time tracking'**
  String get tasksKanbanFieldTimeTracking;

  /// No description provided for @tasksKanbanFieldBlockers.
  ///
  /// In en, this message translates to:
  /// **'Blockers'**
  String get tasksKanbanFieldBlockers;

  /// No description provided for @tasksKanbanFieldCoverAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment cover'**
  String get tasksKanbanFieldCoverAttachment;

  /// No description provided for @tasksKanbanFieldCustomFields.
  ///
  /// In en, this message translates to:
  /// **'Custom fields'**
  String get tasksKanbanFieldCustomFields;

  /// No description provided for @tasksKanbanWipLimits.
  ///
  /// In en, this message translates to:
  /// **'Work-in-progress limits (WIP)'**
  String get tasksKanbanWipLimits;

  /// No description provided for @tasksKanbanWipLimitsDescription.
  ///
  /// In en, this message translates to:
  /// **'Leave a field empty for no limit in that column.'**
  String get tasksKanbanWipLimitsDescription;

  /// No description provided for @tasksKanbanWipUnlimited.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get tasksKanbanWipUnlimited;

  /// No description provided for @tasksAutomationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Rules perform actions in response to project events.'**
  String get tasksAutomationsDescription;

  /// No description provided for @tasksAutomationsRules.
  ///
  /// In en, this message translates to:
  /// **'Project rules'**
  String get tasksAutomationsRules;

  /// No description provided for @tasksAutomationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'This project has no automations yet.'**
  String get tasksAutomationsEmpty;

  /// No description provided for @tasksAutomationsRecipes.
  ///
  /// In en, this message translates to:
  /// **'Ready-made recipes'**
  String get tasksAutomationsRecipes;

  /// No description provided for @tasksAutomationsRecipesEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no automation recipes available.'**
  String get tasksAutomationsRecipesEmpty;

  /// No description provided for @tasksAutomationsInstall.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get tasksAutomationsInstall;

  /// No description provided for @tasksAutomationsArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get tasksAutomationsArchive;

  /// No description provided for @tasksAutomationsArchiveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Archive the “{name}” automation? It will stop immediately, but the run history will remain available.'**
  String tasksAutomationsArchiveConfirm(String name);

  /// No description provided for @tasksAutomationsRuleSummary.
  ///
  /// In en, this message translates to:
  /// **'Trigger: {trigger} · runs: {count}'**
  String tasksAutomationsRuleSummary(String trigger, int count);

  /// No description provided for @tasksAutomationTriggerTaskCreated.
  ///
  /// In en, this message translates to:
  /// **'task created'**
  String get tasksAutomationTriggerTaskCreated;

  /// No description provided for @tasksAutomationTriggerTaskStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'task status changed'**
  String get tasksAutomationTriggerTaskStatusChanged;

  /// No description provided for @tasksAutomationTriggerTaskKanbanMoved.
  ///
  /// In en, this message translates to:
  /// **'Kanban moved'**
  String get tasksAutomationTriggerTaskKanbanMoved;

  /// No description provided for @tasksAutomationTriggerTaskDueSoon.
  ///
  /// In en, this message translates to:
  /// **'due date approaching'**
  String get tasksAutomationTriggerTaskDueSoon;

  /// No description provided for @tasksAutomationTriggerFileUploaded.
  ///
  /// In en, this message translates to:
  /// **'file uploaded'**
  String get tasksAutomationTriggerFileUploaded;

  /// No description provided for @tasksAutomationTriggerWikiPublished.
  ///
  /// In en, this message translates to:
  /// **'Wiki published'**
  String get tasksAutomationTriggerWikiPublished;

  /// No description provided for @tasksAutomationTriggerWhiteboardExported.
  ///
  /// In en, this message translates to:
  /// **'whiteboard exported'**
  String get tasksAutomationTriggerWhiteboardExported;

  /// No description provided for @tasksAutomationTriggerSchedule.
  ///
  /// In en, this message translates to:
  /// **'schedule'**
  String get tasksAutomationTriggerSchedule;

  /// No description provided for @tasksAutomationsRuns.
  ///
  /// In en, this message translates to:
  /// **'Run history'**
  String get tasksAutomationsRuns;

  /// No description provided for @tasksAutomationsRunsEmpty.
  ///
  /// In en, this message translates to:
  /// **'This automation has not run yet.'**
  String get tasksAutomationsRunsEmpty;

  /// No description provided for @tasksAutomationRunQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get tasksAutomationRunQueued;

  /// No description provided for @tasksAutomationRunRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get tasksAutomationRunRunning;

  /// No description provided for @tasksAutomationRunSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Succeeded'**
  String get tasksAutomationRunSucceeded;

  /// No description provided for @tasksAutomationRunPartiallySucceeded.
  ///
  /// In en, this message translates to:
  /// **'Partially succeeded'**
  String get tasksAutomationRunPartiallySucceeded;

  /// No description provided for @tasksAutomationRunFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get tasksAutomationRunFailed;

  /// No description provided for @tasksAutomationRunSkippedConditions.
  ///
  /// In en, this message translates to:
  /// **'Skipped: conditions'**
  String get tasksAutomationRunSkippedConditions;

  /// No description provided for @tasksAutomationRunSkippedDisabled.
  ///
  /// In en, this message translates to:
  /// **'Skipped: rule disabled'**
  String get tasksAutomationRunSkippedDisabled;

  /// No description provided for @tasksAutomationRunSkippedLoop.
  ///
  /// In en, this message translates to:
  /// **'Skipped: loop protection'**
  String get tasksAutomationRunSkippedLoop;

  /// No description provided for @tasksAutomationsDryRun.
  ///
  /// In en, this message translates to:
  /// **'Simulate'**
  String get tasksAutomationsDryRun;

  /// No description provided for @tasksAutomationsDryRunDescription.
  ///
  /// In en, this message translates to:
  /// **'The simulation does not save changes. Choose a task to check conditions and planned actions.'**
  String get tasksAutomationsDryRunDescription;

  /// No description provided for @tasksAutomationsSelectTask.
  ///
  /// In en, this message translates to:
  /// **'Task to simulate'**
  String get tasksAutomationsSelectTask;

  /// No description provided for @tasksAutomationsTasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'This project has no tasks available for simulation.'**
  String get tasksAutomationsTasksEmpty;

  /// No description provided for @tasksAutomationsDryRunMatched.
  ///
  /// In en, this message translates to:
  /// **'Conditions are met'**
  String get tasksAutomationsDryRunMatched;

  /// No description provided for @tasksAutomationsDryRunSkipped.
  ///
  /// In en, this message translates to:
  /// **'Conditions are not met'**
  String get tasksAutomationsDryRunSkipped;

  /// No description provided for @tasksPresenceAnonymousUser.
  ///
  /// In en, this message translates to:
  /// **'User currently viewing this board'**
  String get tasksPresenceAnonymousUser;

  /// No description provided for @tasksListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks match the selected filters.'**
  String get tasksListEmpty;

  /// No description provided for @tasksListLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Show more tasks'**
  String get tasksListLoadMore;

  /// No description provided for @tasksListStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tasksListStatus;

  /// No description provided for @tasksListPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get tasksListPriority;

  /// No description provided for @tasksListTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get tasksListTask;

  /// No description provided for @tasksListOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get tasksListOwner;

  /// No description provided for @tasksListDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get tasksListDueDate;

  /// No description provided for @tasksListProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get tasksListProgress;

  /// No description provided for @tasksListActions.
  ///
  /// In en, this message translates to:
  /// **'Task actions'**
  String get tasksListActions;

  /// No description provided for @tasksListAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tasksListAll;

  /// No description provided for @tasksListStatusBacklog.
  ///
  /// In en, this message translates to:
  /// **'Backlog'**
  String get tasksListStatusBacklog;

  /// No description provided for @tasksListStatusTodo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get tasksListStatusTodo;

  /// No description provided for @tasksListStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get tasksListStatusInProgress;

  /// No description provided for @tasksListStatusBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get tasksListStatusBlocked;

  /// No description provided for @tasksListStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksListStatusDone;

  /// No description provided for @tasksListStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tasksListStatusCancelled;

  /// No description provided for @tasksViewBoard.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get tasksViewBoard;

  /// No description provided for @tasksViewRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get tasksViewRecurrence;

  /// No description provided for @tasksViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get tasksViewList;

  /// No description provided for @tasksMilestonesEmpty.
  ///
  /// In en, this message translates to:
  /// **'This project has no milestones yet.'**
  String get tasksMilestonesEmpty;

  /// No description provided for @tasksCreateMilestone.
  ///
  /// In en, this message translates to:
  /// **'Add milestone'**
  String get tasksCreateMilestone;

  /// No description provided for @tasksEditMilestone.
  ///
  /// In en, this message translates to:
  /// **'Edit milestone'**
  String get tasksEditMilestone;

  /// No description provided for @tasksDeleteMilestone.
  ///
  /// In en, this message translates to:
  /// **'Delete milestone'**
  String get tasksDeleteMilestone;

  /// No description provided for @tasksDeleteMilestoneConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete the “{name}” milestone? This action cannot be undone.'**
  String tasksDeleteMilestoneConfirm(String name);

  /// No description provided for @tasksMilestoneName.
  ///
  /// In en, this message translates to:
  /// **'Milestone name'**
  String get tasksMilestoneName;

  /// No description provided for @tasksMilestoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get tasksMilestoneDescription;

  /// No description provided for @tasksMilestoneDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get tasksMilestoneDueDate;

  /// No description provided for @tasksMilestoneNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get tasksMilestoneNoDueDate;

  /// No description provided for @tasksMilestoneStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tasksMilestoneStatus;

  /// No description provided for @tasksMilestoneActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tasksMilestoneActive;

  /// No description provided for @tasksMilestoneCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tasksMilestoneCompleted;

  /// No description provided for @tasksMilestoneCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tasksMilestoneCancelled;

  /// No description provided for @tasksMilestoneNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a milestone name.'**
  String get tasksMilestoneNameRequired;

  /// No description provided for @tasksMilestoneTasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No assigned tasks.'**
  String get tasksMilestoneTasksEmpty;

  /// No description provided for @taskDetailsMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get taskDetailsMilestone;

  /// No description provided for @taskDetailsNoMilestone.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get taskDetailsNoMilestone;

  /// No description provided for @taskDetailsRemoveMilestone.
  ///
  /// In en, this message translates to:
  /// **'Remove assignment'**
  String get taskDetailsRemoveMilestone;

  /// No description provided for @taskDetailsMilestoneUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not read the assignment — tap to try again.'**
  String get taskDetailsMilestoneUnavailable;

  /// No description provided for @taskDetailsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get taskDetailsLoading;

  /// No description provided for @tasksLabelsSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Labels are available to all tasks in this project.'**
  String get tasksLabelsSettingsDescription;

  /// No description provided for @tasksLabelsEmpty.
  ///
  /// In en, this message translates to:
  /// **'This project has no active labels yet.'**
  String get tasksLabelsEmpty;

  /// No description provided for @tasksCreateLabel.
  ///
  /// In en, this message translates to:
  /// **'Add label'**
  String get tasksCreateLabel;

  /// No description provided for @tasksEditLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit label'**
  String get tasksEditLabel;

  /// No description provided for @tasksArchiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Archive label'**
  String get tasksArchiveLabel;

  /// No description provided for @tasksArchiveLabelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Archive the “{name}” label? It will not be assignable to new tasks.'**
  String tasksArchiveLabelConfirm(String name);

  /// No description provided for @tasksLabelName.
  ///
  /// In en, this message translates to:
  /// **'Label name'**
  String get tasksLabelName;

  /// No description provided for @tasksLabelColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get tasksLabelColor;

  /// No description provided for @tasksLabelNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a label name.'**
  String get tasksLabelNameRequired;

  /// No description provided for @tasksArchiveAction.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get tasksArchiveAction;

  /// No description provided for @tasksSelectTask.
  ///
  /// In en, this message translates to:
  /// **'Select task {taskCode}'**
  String tasksSelectTask(String taskCode);

  /// No description provided for @tasksOpenTask.
  ///
  /// In en, this message translates to:
  /// **'Open task {taskCode}: {title}'**
  String tasksOpenTask(Object taskCode, Object title);

  /// No description provided for @tasksExpandColumn.
  ///
  /// In en, this message translates to:
  /// **'Expand {name} column'**
  String tasksExpandColumn(Object name);

  /// No description provided for @tasksDropAtEnd.
  ///
  /// In en, this message translates to:
  /// **'Drop task at the end of the {name} column'**
  String tasksDropAtEnd(String name);

  /// No description provided for @tasksPinTask.
  ///
  /// In en, this message translates to:
  /// **'Pin task'**
  String get tasksPinTask;

  /// No description provided for @tasksUnpinTask.
  ///
  /// In en, this message translates to:
  /// **'Unpin task'**
  String get tasksUnpinTask;

  /// No description provided for @tasksWatchTask.
  ///
  /// In en, this message translates to:
  /// **'Watch task'**
  String get tasksWatchTask;

  /// No description provided for @tasksUnwatchTask.
  ///
  /// In en, this message translates to:
  /// **'Stop watching task'**
  String get tasksUnwatchTask;

  /// No description provided for @tasksRecurrenceSeries.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get tasksRecurrenceSeries;

  /// No description provided for @tasksRecurrenceCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get tasksRecurrenceCycle;

  /// No description provided for @tasksAssignedToMilestone.
  ///
  /// In en, this message translates to:
  /// **'Assigned to milestone'**
  String get tasksAssignedToMilestone;

  /// No description provided for @tasksShowSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Show subtasks ({count})'**
  String tasksShowSubtasks(int count);

  /// No description provided for @tasksHideSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Hide subtasks'**
  String get tasksHideSubtasks;

  /// No description provided for @tasksSubtasksLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading subtasks…'**
  String get tasksSubtasksLoading;

  /// No description provided for @tasksSubtasksError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load subtasks'**
  String get tasksSubtasksError;

  /// No description provided for @tasksSubtasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No subtasks'**
  String get tasksSubtasksEmpty;

  /// No description provided for @tasksSubtasksMore.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String tasksSubtasksMore(int count);

  /// No description provided for @tasksSubtasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get tasksSubtasksTitle;

  /// No description provided for @tasksSubtasksShowMoreRemaining.
  ///
  /// In en, this message translates to:
  /// **'Show {count} more'**
  String tasksSubtasksShowMoreRemaining(int count);

  /// No description provided for @tasksAddSubtask.
  ///
  /// In en, this message translates to:
  /// **'Add subtask'**
  String get tasksAddSubtask;

  /// No description provided for @tasksContextMenuOpen.
  ///
  /// In en, this message translates to:
  /// **'Open details'**
  String get tasksContextMenuOpen;

  /// No description provided for @tasksContextMenuCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy task code'**
  String get tasksContextMenuCopyCode;

  /// No description provided for @tasksContextMenuCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy task link'**
  String get tasksContextMenuCopyLink;

  /// No description provided for @tasksContextMenuStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get tasksContextMenuStatus;

  /// No description provided for @tasksContextMenuPriority.
  ///
  /// In en, this message translates to:
  /// **'Change priority'**
  String get tasksContextMenuPriority;

  /// No description provided for @tasksContextMenuAssignee.
  ///
  /// In en, this message translates to:
  /// **'Change assignee'**
  String get tasksContextMenuAssignee;

  /// No description provided for @tasksContextMenuDueDate.
  ///
  /// In en, this message translates to:
  /// **'Change due date'**
  String get tasksContextMenuDueDate;

  /// No description provided for @tasksContextMenuAddSubtask.
  ///
  /// In en, this message translates to:
  /// **'Add subtask'**
  String get tasksContextMenuAddSubtask;

  /// No description provided for @tasksTemplatesManage.
  ///
  /// In en, this message translates to:
  /// **'Manage template'**
  String get tasksTemplatesManage;

  /// No description provided for @tasksTemplateLineItemsHint.
  ///
  /// In en, this message translates to:
  /// **'One item per line'**
  String get tasksTemplateLineItemsHint;

  /// No description provided for @tasksTemplatesRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get tasksTemplatesRename;

  /// No description provided for @tasksTemplatesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete template?'**
  String get tasksTemplatesDeleteTitle;

  /// No description provided for @tasksTemplatesDeleteDescription.
  ///
  /// In en, this message translates to:
  /// **'The “{name}” template will be permanently deleted.'**
  String tasksTemplatesDeleteDescription(String name);

  /// No description provided for @taskDetailsArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive task'**
  String get taskDetailsArchive;

  /// No description provided for @taskDetailsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore task'**
  String get taskDetailsRestore;

  /// No description provided for @taskDetailsArchiveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive task?'**
  String get taskDetailsArchiveConfirmTitle;

  /// No description provided for @taskDetailsArchiveConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'The task will leave active views, but can be restored later.'**
  String get taskDetailsArchiveConfirmMessage;

  /// No description provided for @taskDetailsHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get taskDetailsHistory;

  /// No description provided for @taskDetailsCreateTemplate.
  ///
  /// In en, this message translates to:
  /// **'Save as template'**
  String get taskDetailsCreateTemplate;

  /// No description provided for @taskDetailsCreateTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'New task template'**
  String get taskDetailsCreateTemplateTitle;

  /// No description provided for @taskDetailsCreateTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'The current state of this task will be saved as a template in this workspace.'**
  String get taskDetailsCreateTemplateDescription;

  /// No description provided for @taskDetailsTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get taskDetailsTemplateName;

  /// No description provided for @taskDetailsTemplateCreated.
  ///
  /// In en, this message translates to:
  /// **'Task template created.'**
  String get taskDetailsTemplateCreated;

  /// No description provided for @taskDetailsHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no recorded changes yet.'**
  String get taskDetailsHistoryEmpty;

  /// No description provided for @taskDetailsHistoryRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get taskDetailsHistoryRetry;

  /// No description provided for @taskDetailsHistoryActorSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get taskDetailsHistoryActorSystem;

  /// No description provided for @taskDetailsHistoryActorAutomation.
  ///
  /// In en, this message translates to:
  /// **'Automation'**
  String get taskDetailsHistoryActorAutomation;

  /// No description provided for @taskDetailsHistoryActorUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get taskDetailsHistoryActorUser;

  /// No description provided for @taskDetailsHistoryVersion.
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String taskDetailsHistoryVersion(int version);

  /// No description provided for @taskDetailsRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get taskDetailsRecurrence;

  /// No description provided for @taskDetailsConfigureRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get taskDetailsConfigureRecurrence;

  /// No description provided for @taskDetailsRecurrenceNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'This task is not recurring.'**
  String get taskDetailsRecurrenceNotConfigured;

  /// No description provided for @taskDetailsRecurrenceEvery.
  ///
  /// In en, this message translates to:
  /// **'every {count}'**
  String taskDetailsRecurrenceEvery(int count);

  /// No description provided for @taskDetailsRecurrenceActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get taskDetailsRecurrenceActive;

  /// No description provided for @taskDetailsRecurrencePaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get taskDetailsRecurrencePaused;

  /// No description provided for @taskDetailsRecurrenceMode.
  ///
  /// In en, this message translates to:
  /// **'Schedule type'**
  String get taskDetailsRecurrenceMode;

  /// No description provided for @taskDetailsRecurrenceModeScheduled.
  ///
  /// In en, this message translates to:
  /// **'On a schedule'**
  String get taskDetailsRecurrenceModeScheduled;

  /// No description provided for @taskDetailsRecurrenceModeAfterCompletion.
  ///
  /// In en, this message translates to:
  /// **'After completion'**
  String get taskDetailsRecurrenceModeAfterCompletion;

  /// No description provided for @taskDetailsRecurrenceFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get taskDetailsRecurrenceFrequency;

  /// No description provided for @taskDetailsRecurrenceFrequencyDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get taskDetailsRecurrenceFrequencyDaily;

  /// No description provided for @taskDetailsRecurrenceFrequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get taskDetailsRecurrenceFrequencyWeekly;

  /// No description provided for @taskDetailsRecurrenceFrequencyMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get taskDetailsRecurrenceFrequencyMonthly;

  /// No description provided for @taskDetailsRecurrenceInterval.
  ///
  /// In en, this message translates to:
  /// **'Every N periods'**
  String get taskDetailsRecurrenceInterval;

  /// No description provided for @taskDetailsRecurrenceTimeZone.
  ///
  /// In en, this message translates to:
  /// **'IANA time zone'**
  String get taskDetailsRecurrenceTimeZone;

  /// No description provided for @taskDetailsRecurrenceOccurrenceStatus.
  ///
  /// In en, this message translates to:
  /// **'New occurrence status'**
  String get taskDetailsRecurrenceOccurrenceStatus;

  /// No description provided for @taskDetailsRecurrenceSkipPrevious.
  ///
  /// In en, this message translates to:
  /// **'Skip when the previous occurrence remains open'**
  String get taskDetailsRecurrenceSkipPrevious;

  /// No description provided for @taskDetailsRecurrenceFirstOccurrence.
  ///
  /// In en, this message translates to:
  /// **'First occurrence'**
  String get taskDetailsRecurrenceFirstOccurrence;

  /// No description provided for @taskDetailsRecurrenceNextOccurrence.
  ///
  /// In en, this message translates to:
  /// **'Next occurrence'**
  String get taskDetailsRecurrenceNextOccurrence;

  /// No description provided for @taskDetailsRecurrencePause.
  ///
  /// In en, this message translates to:
  /// **'Pause recurrence'**
  String get taskDetailsRecurrencePause;

  /// No description provided for @taskDetailsRecurrenceResume.
  ///
  /// In en, this message translates to:
  /// **'Resume recurrence'**
  String get taskDetailsRecurrenceResume;

  /// No description provided for @taskDetailsRecurrenceCreate.
  ///
  /// In en, this message translates to:
  /// **'Create recurrence'**
  String get taskDetailsRecurrenceCreate;

  /// No description provided for @taskDetailsRecurrenceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive interval and a valid IANA time zone, for example Europe/Warsaw.'**
  String get taskDetailsRecurrenceInvalid;

  /// No description provided for @taskDetailsRecurrenceRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get taskDetailsRecurrenceRetry;

  /// No description provided for @taskDetailsAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get taskDetailsAttachments;

  /// No description provided for @taskDetailsAttachmentsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add files'**
  String get taskDetailsAttachmentsAdd;

  /// No description provided for @taskDetailsAttachmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No attachments yet'**
  String get taskDetailsAttachmentsEmpty;

  /// No description provided for @taskDetailsAttachmentsSelect.
  ///
  /// In en, this message translates to:
  /// **'Select files to add them to this task.'**
  String get taskDetailsAttachmentsSelect;

  /// No description provided for @taskDetailsAttachmentsDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop files here to attach them'**
  String get taskDetailsAttachmentsDrop;

  /// No description provided for @taskDetailsAttachmentsQueued.
  ///
  /// In en, this message translates to:
  /// **'Waiting to upload'**
  String get taskDetailsAttachmentsQueued;

  /// No description provided for @taskDetailsAttachmentsUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get taskDetailsAttachmentsUploading;

  /// No description provided for @taskDetailsAttachmentsUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get taskDetailsAttachmentsUploaded;

  /// No description provided for @taskDetailsAttachmentsFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get taskDetailsAttachmentsFailed;

  /// No description provided for @taskDetailsTimeTracking.
  ///
  /// In en, this message translates to:
  /// **'Time tracking'**
  String get taskDetailsTimeTracking;

  /// No description provided for @taskDetailsTimeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get taskDetailsTimeAdd;

  /// No description provided for @taskDetailsTimeTotal.
  ///
  /// In en, this message translates to:
  /// **'Logged: {duration}'**
  String taskDetailsTimeTotal(String duration);

  /// No description provided for @taskDetailsTimeStart.
  ///
  /// In en, this message translates to:
  /// **'Start timer'**
  String get taskDetailsTimeStart;

  /// No description provided for @taskDetailsTimeStop.
  ///
  /// In en, this message translates to:
  /// **'Stop timer'**
  String get taskDetailsTimeStop;

  /// No description provided for @taskDetailsTimeNoDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get taskDetailsTimeNoDescription;

  /// No description provided for @taskDetailsTimeSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get taskDetailsTimeSubmit;

  /// No description provided for @taskDetailsTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration in minutes'**
  String get taskDetailsTimeMinutes;

  /// No description provided for @taskDetailsTimeDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get taskDetailsTimeDescription;

  /// No description provided for @taskDetailsTimeBillable.
  ///
  /// In en, this message translates to:
  /// **'Billable'**
  String get taskDetailsTimeBillable;

  /// No description provided for @taskDetailsTimeDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get taskDetailsTimeDraft;

  /// No description provided for @taskDetailsTimeSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get taskDetailsTimeSubmitted;

  /// No description provided for @taskDetailsTimeApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get taskDetailsTimeApproved;

  /// No description provided for @taskDetailsTimeRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get taskDetailsTimeRejected;

  /// No description provided for @tasksBoardEmpty.
  ///
  /// In en, this message translates to:
  /// **'This project has no configured columns'**
  String get tasksBoardEmpty;

  /// No description provided for @tasksPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low priority'**
  String get tasksPriorityLow;

  /// No description provided for @tasksPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal priority'**
  String get tasksPriorityNormal;

  /// No description provided for @tasksPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High priority'**
  String get tasksPriorityHigh;

  /// No description provided for @tasksPriorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical priority'**
  String get tasksPriorityCritical;

  /// No description provided for @taskDetailsClose.
  ///
  /// In en, this message translates to:
  /// **'Close task details'**
  String get taskDetailsClose;

  /// No description provided for @taskDetailsArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get taskDetailsArchived;

  /// No description provided for @taskDetailsProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get taskDetailsProperties;

  /// No description provided for @taskDetailsAssignees.
  ///
  /// In en, this message translates to:
  /// **'Assignees'**
  String get taskDetailsAssignees;

  /// No description provided for @taskDetailsEditAssignees.
  ///
  /// In en, this message translates to:
  /// **'Edit assignees'**
  String get taskDetailsEditAssignees;

  /// No description provided for @taskDetailsAssigneesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Project members could not be loaded.'**
  String get taskDetailsAssigneesLoadError;

  /// No description provided for @taskDetailsNoProjectMembers.
  ///
  /// In en, this message translates to:
  /// **'No project members are available.'**
  String get taskDetailsNoProjectMembers;

  /// No description provided for @taskDetailsProjectMember.
  ///
  /// In en, this message translates to:
  /// **'Project member'**
  String get taskDetailsProjectMember;

  /// No description provided for @taskDetailsNobody.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get taskDetailsNobody;

  /// No description provided for @taskDetailsWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch task'**
  String get taskDetailsWatch;

  /// No description provided for @taskDetailsStopWatching.
  ///
  /// In en, this message translates to:
  /// **'Stop watching task'**
  String get taskDetailsStopWatching;

  /// No description provided for @taskDetailsWatchers.
  ///
  /// In en, this message translates to:
  /// **'Watchers'**
  String get taskDetailsWatchers;

  /// No description provided for @taskDetailsNoWatchers.
  ///
  /// In en, this message translates to:
  /// **'No one is watching this task yet.'**
  String get taskDetailsNoWatchers;

  /// No description provided for @taskDetailsWatchersMore.
  ///
  /// In en, this message translates to:
  /// **'+{count}'**
  String taskDetailsWatchersMore(int count);

  /// No description provided for @taskDetailsPin.
  ///
  /// In en, this message translates to:
  /// **'Pin task'**
  String get taskDetailsPin;

  /// No description provided for @taskDetailsUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin task'**
  String get taskDetailsUnpin;

  /// No description provided for @taskDetailsLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get taskDetailsLabels;

  /// No description provided for @taskDetailsEditLabels.
  ///
  /// In en, this message translates to:
  /// **'Edit labels'**
  String get taskDetailsEditLabels;

  /// No description provided for @taskDetailsNoLabels.
  ///
  /// In en, this message translates to:
  /// **'No labels have been assigned yet.'**
  String get taskDetailsNoLabels;

  /// No description provided for @taskDetailsNoProjectLabels.
  ///
  /// In en, this message translates to:
  /// **'This project has no active labels yet.'**
  String get taskDetailsNoProjectLabels;

  /// No description provided for @taskDetailsCustomFields.
  ///
  /// In en, this message translates to:
  /// **'Custom fields'**
  String get taskDetailsCustomFields;

  /// No description provided for @taskDetailsEditCustomFields.
  ///
  /// In en, this message translates to:
  /// **'Edit custom fields'**
  String get taskDetailsEditCustomFields;

  /// No description provided for @taskDetailsNoCustomFields.
  ///
  /// In en, this message translates to:
  /// **'This project has no custom fields configured.'**
  String get taskDetailsNoCustomFields;

  /// No description provided for @taskDetailsRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get taskDetailsRequiredField;

  /// No description provided for @taskDetailsInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number.'**
  String get taskDetailsInvalidNumber;

  /// No description provided for @taskDetailsUserFieldUnavailable.
  ///
  /// In en, this message translates to:
  /// **'User selection requires the project member directory.'**
  String get taskDetailsUserFieldUnavailable;

  /// No description provided for @taskDetailsDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get taskDetailsDueDate;

  /// No description provided for @tasksTemplateTaskType.
  ///
  /// In en, this message translates to:
  /// **'Task type'**
  String get tasksTemplateTaskType;

  /// No description provided for @tasksTemplateSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get tasksTemplateSize;

  /// No description provided for @tasksTemplateComplexity.
  ///
  /// In en, this message translates to:
  /// **'Complexity'**
  String get tasksTemplateComplexity;

  /// No description provided for @tasksTemplateRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get tasksTemplateRisk;

  /// No description provided for @tasksTemplateBusinessValue.
  ///
  /// In en, this message translates to:
  /// **'Business value'**
  String get tasksTemplateBusinessValue;

  /// No description provided for @tasksTemplateAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add label'**
  String get tasksTemplateAddLabel;

  /// No description provided for @tasksTemplateNoLabels.
  ///
  /// In en, this message translates to:
  /// **'No labels in this template'**
  String get tasksTemplateNoLabels;

  /// No description provided for @tasksTemplateAssignees.
  ///
  /// In en, this message translates to:
  /// **'Default assignees'**
  String get tasksTemplateAssignees;

  /// No description provided for @tasksTemplateCustomValues.
  ///
  /// In en, this message translates to:
  /// **'Custom fields'**
  String get tasksTemplateCustomValues;

  /// No description provided for @tasksTemplateAddCustomValue.
  ///
  /// In en, this message translates to:
  /// **'Add value'**
  String get tasksTemplateAddCustomValue;

  /// No description provided for @tasksTemplateNoCustomValues.
  ///
  /// In en, this message translates to:
  /// **'No custom-field values'**
  String get tasksTemplateNoCustomValues;

  /// No description provided for @tasksTemplateCustomValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get tasksTemplateCustomValue;

  /// No description provided for @tasksTemplateMultiValueHint.
  ///
  /// In en, this message translates to:
  /// **'Separate values with commas'**
  String get tasksTemplateMultiValueHint;

  /// No description provided for @tasksTemplatesUnsavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved changes?'**
  String get tasksTemplatesUnsavedTitle;

  /// No description provided for @tasksTemplatesUnsavedDescription.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes in this template form. Are you sure you want to discard them?'**
  String get tasksTemplatesUnsavedDescription;

  /// No description provided for @tasksTemplatesDiscardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get tasksTemplatesDiscardChanges;

  /// No description provided for @tasksTemplatesKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Continue editing'**
  String get tasksTemplatesKeepEditing;

  /// No description provided for @tasksTemplatesCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create template'**
  String get tasksTemplatesCreateAction;

  /// No description provided for @tasksTemplatesSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get tasksTemplatesSaveAction;

  /// No description provided for @tasksTemplatesFormFixErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the highlighted form errors.'**
  String get tasksTemplatesFormFixErrors;

  /// No description provided for @tasksTemplatesNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Template name is required.'**
  String get tasksTemplatesNameRequired;

  /// No description provided for @tasksTemplatesNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Template name cannot exceed 160 characters.'**
  String get tasksTemplatesNameTooLong;

  /// No description provided for @tasksTemplatesTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Task title is required.'**
  String get tasksTemplatesTitleRequired;

  /// No description provided for @tasksTemplatesTitleTooLong.
  ///
  /// In en, this message translates to:
  /// **'Task title cannot exceed 240 characters.'**
  String get tasksTemplatesTitleTooLong;

  /// No description provided for @tasksTemplatesDescriptionTooLong.
  ///
  /// In en, this message translates to:
  /// **'Description cannot exceed 20,000 characters.'**
  String get tasksTemplatesDescriptionTooLong;

  /// No description provided for @tasksTemplatesInvalidDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date cannot be earlier than start date.'**
  String get tasksTemplatesInvalidDueDate;

  /// No description provided for @tasksTemplatesInvalidEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimate must be a positive integer in minutes.'**
  String get tasksTemplatesInvalidEstimate;

  /// No description provided for @tasksTemplatesInvalidPercentage.
  ///
  /// In en, this message translates to:
  /// **'Value must be an integer between 0 and 100.'**
  String get tasksTemplatesInvalidPercentage;

  /// No description provided for @tasksTemplatesTaskTypeTooLong.
  ///
  /// In en, this message translates to:
  /// **'Task type cannot exceed 80 characters.'**
  String get tasksTemplatesTaskTypeTooLong;

  /// No description provided for @tasksTemplatesChecklistItemTooLong.
  ///
  /// In en, this message translates to:
  /// **'Checklist item cannot exceed 500 characters.'**
  String get tasksTemplatesChecklistItemTooLong;

  /// No description provided for @tasksTemplatesCriteriaTooLong.
  ///
  /// In en, this message translates to:
  /// **'Acceptance criterion cannot exceed 1,000 characters.'**
  String get tasksTemplatesCriteriaTooLong;

  /// No description provided for @tasksTemplatesLabelDuplicate.
  ///
  /// In en, this message translates to:
  /// **'A label with this name already exists.'**
  String get tasksTemplatesLabelDuplicate;

  /// No description provided for @tasksTemplatesCustomFieldDuplicate.
  ///
  /// In en, this message translates to:
  /// **'A custom field with this name already exists.'**
  String get tasksTemplatesCustomFieldDuplicate;

  /// No description provided for @tasksTemplatesSectionBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic info'**
  String get tasksTemplatesSectionBasic;

  /// No description provided for @tasksTemplatesSectionPlanning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get tasksTemplatesSectionPlanning;

  /// No description provided for @tasksTemplatesSectionResponsibility.
  ///
  /// In en, this message translates to:
  /// **'Responsibility'**
  String get tasksTemplatesSectionResponsibility;

  /// No description provided for @tasksTemplatesSectionScope.
  ///
  /// In en, this message translates to:
  /// **'Scope of work'**
  String get tasksTemplatesSectionScope;

  /// No description provided for @tasksTemplatesSectionClassification.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get tasksTemplatesSectionClassification;

  /// No description provided for @tasksTemplatesSectionMetadata.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get tasksTemplatesSectionMetadata;

  /// No description provided for @tasksTemplatesAssigneesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search people...'**
  String get tasksTemplatesAssigneesSearchHint;

  /// No description provided for @tasksTemplatesAssigneesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No matching people'**
  String get tasksTemplatesAssigneesEmpty;

  /// No description provided for @tasksTemplatesAssigneesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load project members'**
  String get tasksTemplatesAssigneesLoadError;

  /// No description provided for @tasksTemplatesEmptyCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Create first template'**
  String get tasksTemplatesEmptyCreateCta;

  /// No description provided for @tasksTemplatesUseTileAction.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get tasksTemplatesUseTileAction;

  /// No description provided for @tasksTemplatesCustomStatus.
  ///
  /// In en, this message translates to:
  /// **'Custom column'**
  String get tasksTemplatesCustomStatus;

  /// No description provided for @tasksTemplatesSystemStatus.
  ///
  /// In en, this message translates to:
  /// **'System status'**
  String get tasksTemplatesSystemStatus;

  /// No description provided for @tasksAutomationsCreate.
  ///
  /// In en, this message translates to:
  /// **'New automation'**
  String get tasksAutomationsCreate;

  /// No description provided for @tasksAutomationsName.
  ///
  /// In en, this message translates to:
  /// **'Rule name'**
  String get tasksAutomationsName;

  /// No description provided for @tasksAutomationsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit automation'**
  String get tasksAutomationsEdit;

  /// No description provided for @tasksAutomationsConditionStatus.
  ///
  /// In en, this message translates to:
  /// **'Only when task status is'**
  String get tasksAutomationsConditionStatus;

  /// No description provided for @tasksAutomationsConditionPriority.
  ///
  /// In en, this message translates to:
  /// **'Only when task priority is'**
  String get tasksAutomationsConditionPriority;

  /// No description provided for @tasksAutomationsConditionDueWithinDays.
  ///
  /// In en, this message translates to:
  /// **'Only when due within (days)'**
  String get tasksAutomationsConditionDueWithinDays;

  /// No description provided for @tasksAutomationsConditionTitleContains.
  ///
  /// In en, this message translates to:
  /// **'Only when title contains'**
  String get tasksAutomationsConditionTitleContains;

  /// No description provided for @tasksAutomationsConditionOptional.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to omit this condition.'**
  String get tasksAutomationsConditionOptional;

  /// No description provided for @tasksAutomationsConditionAssignee.
  ///
  /// In en, this message translates to:
  /// **'Only when assignee is'**
  String get tasksAutomationsConditionAssignee;

  /// No description provided for @tasksAutomationsConditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Only when task has label'**
  String get tasksAutomationsConditionLabel;

  /// No description provided for @tasksAutomationsUnknownMember.
  ///
  /// In en, this message translates to:
  /// **'Member unavailable in this project'**
  String get tasksAutomationsUnknownMember;

  /// No description provided for @tasksAutomationsUnknownLabel.
  ///
  /// In en, this message translates to:
  /// **'Inactive label'**
  String get tasksAutomationsUnknownLabel;

  /// No description provided for @tasksAutomationsNoCondition.
  ///
  /// In en, this message translates to:
  /// **'No status condition'**
  String get tasksAutomationsNoCondition;

  /// No description provided for @tasksAutomationsTrigger.
  ///
  /// In en, this message translates to:
  /// **'When this happens'**
  String get tasksAutomationsTrigger;

  /// No description provided for @tasksAutomationsAction.
  ///
  /// In en, this message translates to:
  /// **'Do this'**
  String get tasksAutomationsAction;

  /// No description provided for @tasksAutomationsDueWithinDays.
  ///
  /// In en, this message translates to:
  /// **'Due-date horizon (days)'**
  String get tasksAutomationsDueWithinDays;

  /// No description provided for @tasksAutomationsDaysHint.
  ///
  /// In en, this message translates to:
  /// **'From 0 to 365 days'**
  String get tasksAutomationsDaysHint;

  /// No description provided for @tasksAutomationsSubtaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Subtask title'**
  String get tasksAutomationsSubtaskTitle;

  /// No description provided for @tasksAutomationsActionSetStatus.
  ///
  /// In en, this message translates to:
  /// **'Set task status'**
  String get tasksAutomationsActionSetStatus;

  /// No description provided for @tasksAutomationsActionSetPriority.
  ///
  /// In en, this message translates to:
  /// **'Set task priority'**
  String get tasksAutomationsActionSetPriority;

  /// No description provided for @tasksAutomationsActionClearDueDate.
  ///
  /// In en, this message translates to:
  /// **'Clear task due date'**
  String get tasksAutomationsActionClearDueDate;

  /// No description provided for @tasksAutomationsActionSetDueDate.
  ///
  /// In en, this message translates to:
  /// **'Set or clear task due date'**
  String get tasksAutomationsActionSetDueDate;

  /// No description provided for @tasksAutomationsDueDateUnset.
  ///
  /// In en, this message translates to:
  /// **'No due date (clear)'**
  String get tasksAutomationsDueDateUnset;

  /// No description provided for @tasksAutomationsClearDueDate.
  ///
  /// In en, this message translates to:
  /// **'Clear selected due date'**
  String get tasksAutomationsClearDueDate;

  /// No description provided for @tasksAutomationsActionCreateSubtask.
  ///
  /// In en, this message translates to:
  /// **'Create subtask'**
  String get tasksAutomationsActionCreateSubtask;

  /// No description provided for @tasksAutomationsActionAssignTask.
  ///
  /// In en, this message translates to:
  /// **'Assign task'**
  String get tasksAutomationsActionAssignTask;

  /// No description provided for @tasksAutomationsActionAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add label'**
  String get tasksAutomationsActionAddLabel;

  /// No description provided for @tasksAutomationsActionRemoveLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove label'**
  String get tasksAutomationsActionRemoveLabel;

  /// No description provided for @tasksAutomationsActionAssignee.
  ///
  /// In en, this message translates to:
  /// **'Target assignee'**
  String get tasksAutomationsActionAssignee;

  /// No description provided for @tasksAutomationsActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Target label'**
  String get tasksAutomationsActionLabel;

  /// No description provided for @tasksAutomationsActionNotifyUser.
  ///
  /// In en, this message translates to:
  /// **'Send notification'**
  String get tasksAutomationsActionNotifyUser;

  /// No description provided for @tasksAutomationsNotificationRecipient.
  ///
  /// In en, this message translates to:
  /// **'Notification recipient'**
  String get tasksAutomationsNotificationRecipient;

  /// No description provided for @tasksAutomationsNotificationText.
  ///
  /// In en, this message translates to:
  /// **'Notification text'**
  String get tasksAutomationsNotificationText;

  /// No description provided for @tasksAutomationsBuilderInvalid.
  ///
  /// In en, this message translates to:
  /// **'Provide a name and valid automation parameters.'**
  String get tasksAutomationsBuilderInvalid;

  /// No description provided for @taskDetailsNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get taskDetailsNoDueDate;

  /// No description provided for @taskDetailsNoDate.
  ///
  /// In en, this message translates to:
  /// **'No date set'**
  String get taskDetailsNoDate;

  /// No description provided for @taskDetailsEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get taskDetailsEstimate;

  /// No description provided for @taskDetailsNoEstimate.
  ///
  /// In en, this message translates to:
  /// **'No estimate'**
  String get taskDetailsNoEstimate;

  /// No description provided for @taskDetailsMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String taskDetailsMinutes(int count);

  /// No description provided for @taskDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get taskDetailsDescription;

  /// No description provided for @taskDetailsEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit description'**
  String get taskDetailsEditDescription;

  /// No description provided for @tasksCollapseColumn.
  ///
  /// In en, this message translates to:
  /// **'Collapse column'**
  String get tasksCollapseColumn;

  /// No description provided for @taskDetailsNoDescription.
  ///
  /// In en, this message translates to:
  /// **'This task does not have a description yet.'**
  String get taskDetailsNoDescription;

  /// No description provided for @taskDetailsChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get taskDetailsChecklist;

  /// No description provided for @taskDetailsAddChecklistItem.
  ///
  /// In en, this message translates to:
  /// **'Add checklist item'**
  String get taskDetailsAddChecklistItem;

  /// No description provided for @taskDetailsDeleteChecklistItem.
  ///
  /// In en, this message translates to:
  /// **'Delete checklist item'**
  String get taskDetailsDeleteChecklistItem;

  /// No description provided for @taskDetailsEditChecklistItem.
  ///
  /// In en, this message translates to:
  /// **'Edit checklist item'**
  String get taskDetailsEditChecklistItem;

  /// No description provided for @taskDetailsAcceptanceCriteria.
  ///
  /// In en, this message translates to:
  /// **'Acceptance criteria'**
  String get taskDetailsAcceptanceCriteria;

  /// No description provided for @taskDetailsAddAcceptanceCriterion.
  ///
  /// In en, this message translates to:
  /// **'Add acceptance criterion'**
  String get taskDetailsAddAcceptanceCriterion;

  /// No description provided for @taskDetailsDeleteAcceptanceCriterion.
  ///
  /// In en, this message translates to:
  /// **'Delete acceptance criterion'**
  String get taskDetailsDeleteAcceptanceCriterion;

  /// No description provided for @taskDetailsEditAcceptanceCriterion.
  ///
  /// In en, this message translates to:
  /// **'Edit acceptance criterion'**
  String get taskDetailsEditAcceptanceCriterion;

  /// No description provided for @taskDetailsSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get taskDetailsSubtasks;

  /// No description provided for @taskDetailsAddSubtask.
  ///
  /// In en, this message translates to:
  /// **'Add subtask'**
  String get taskDetailsAddSubtask;

  /// No description provided for @taskDetailsNoSubtasks.
  ///
  /// In en, this message translates to:
  /// **'There are no subtasks yet.'**
  String get taskDetailsNoSubtasks;

  /// No description provided for @taskDetailsDependencies.
  ///
  /// In en, this message translates to:
  /// **'Dependencies'**
  String get taskDetailsDependencies;

  /// No description provided for @taskDetailsAddDependency.
  ///
  /// In en, this message translates to:
  /// **'Add dependency'**
  String get taskDetailsAddDependency;

  /// No description provided for @taskDetailsDeleteDependency.
  ///
  /// In en, this message translates to:
  /// **'Delete dependency'**
  String get taskDetailsDeleteDependency;

  /// No description provided for @taskDetailsNoDependencies.
  ///
  /// In en, this message translates to:
  /// **'This task has no dependencies yet.'**
  String get taskDetailsNoDependencies;

  /// No description provided for @taskDetailsSearchTask.
  ///
  /// In en, this message translates to:
  /// **'Search task'**
  String get taskDetailsSearchTask;

  /// No description provided for @taskDetailsDependencyType.
  ///
  /// In en, this message translates to:
  /// **'Dependency type'**
  String get taskDetailsDependencyType;

  /// No description provided for @taskDetailsDependencyKind.
  ///
  /// In en, this message translates to:
  /// **'Schedule relationship'**
  String get taskDetailsDependencyKind;

  /// No description provided for @taskDetailsDependencyLagDays.
  ///
  /// In en, this message translates to:
  /// **'Lag (working days)'**
  String get taskDetailsDependencyLagDays;

  /// No description provided for @taskDependencyKindFinishToStart.
  ///
  /// In en, this message translates to:
  /// **'Finish to start'**
  String get taskDependencyKindFinishToStart;

  /// No description provided for @taskDependencyKindStartToStart.
  ///
  /// In en, this message translates to:
  /// **'Start to start'**
  String get taskDependencyKindStartToStart;

  /// No description provided for @taskDependencyKindFinishToFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish to finish'**
  String get taskDependencyKindFinishToFinish;

  /// No description provided for @taskDependencyKindStartToFinish.
  ///
  /// In en, this message translates to:
  /// **'Start to finish'**
  String get taskDependencyKindStartToFinish;

  /// No description provided for @taskDependencyBlocks.
  ///
  /// In en, this message translates to:
  /// **'Blocks'**
  String get taskDependencyBlocks;

  /// No description provided for @taskDependencyRelated.
  ///
  /// In en, this message translates to:
  /// **'Related to'**
  String get taskDependencyRelated;

  /// No description provided for @taskDependencyDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get taskDependencyDuplicate;

  /// No description provided for @taskDetailsEditBasics.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskDetailsEditBasics;

  /// No description provided for @taskDetailsTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get taskDetailsTitleField;

  /// No description provided for @taskDetailsStatusField.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get taskDetailsStatusField;

  /// No description provided for @taskDetailsPriorityField.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get taskDetailsPriorityField;

  /// No description provided for @taskDetailsEditPlanning.
  ///
  /// In en, this message translates to:
  /// **'Edit dates and estimate'**
  String get taskDetailsEditPlanning;

  /// No description provided for @taskDetailsStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get taskDetailsStartDate;

  /// No description provided for @taskDetailsEstimateMinutes.
  ///
  /// In en, this message translates to:
  /// **'Estimate in minutes'**
  String get taskDetailsEstimateMinutes;

  /// No description provided for @taskDetailsClearDate.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get taskDetailsClearDate;

  /// No description provided for @taskDetailsInvalidEstimate.
  ///
  /// In en, this message translates to:
  /// **'The estimate must be a positive number of minutes.'**
  String get taskDetailsInvalidEstimate;

  /// No description provided for @taskDetailsInvalidDependencyLag.
  ///
  /// In en, this message translates to:
  /// **'Lag must be between -365 and 365 days.'**
  String get taskDetailsInvalidDependencyLag;

  /// No description provided for @taskDetailsInvalidDateRange.
  ///
  /// In en, this message translates to:
  /// **'The due date cannot be earlier than the start date.'**
  String get taskDetailsInvalidDateRange;

  /// No description provided for @taskStatusBacklog.
  ///
  /// In en, this message translates to:
  /// **'Backlog'**
  String get taskStatusBacklog;

  /// No description provided for @taskStatusTodo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get taskStatusTodo;

  /// No description provided for @taskStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get taskStatusInProgress;

  /// No description provided for @taskStatusBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get taskStatusBlocked;

  /// No description provided for @taskStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskStatusDone;

  /// No description provided for @taskStatusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get taskStatusCanceled;

  /// No description provided for @myTasksFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter tasks'**
  String get myTasksFilter;

  /// No description provided for @myTasksFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Task filters'**
  String get myTasksFiltersTitle;

  /// No description provided for @myTasksFiltersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize personal task filtering criteria.'**
  String get myTasksFiltersSubtitle;

  /// No description provided for @projectUserHubPinnedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project pinned to favorites.'**
  String get projectUserHubPinnedSuccess;

  /// No description provided for @projectUserHubUnpinnedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project unpinned from favorites.'**
  String get projectUserHubUnpinnedSuccess;

  /// No description provided for @projectUserHubHiddenSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project hidden from sidebar.'**
  String get projectUserHubHiddenSuccess;

  /// No description provided for @projectUserHubUnhiddenSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project restored to sidebar.'**
  String get projectUserHubUnhiddenSuccess;

  /// No description provided for @myTasksStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get myTasksStatus;

  /// No description provided for @myTasksPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get myTasksPriority;

  /// No description provided for @myTasksInvolvement.
  ///
  /// In en, this message translates to:
  /// **'My involvement'**
  String get myTasksInvolvement;

  /// No description provided for @myTasksAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get myTasksAll;

  /// No description provided for @myTasksAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get myTasksAny;

  /// No description provided for @myTasksDueFrom.
  ///
  /// In en, this message translates to:
  /// **'Due from'**
  String get myTasksDueFrom;

  /// No description provided for @myTasksDueTo.
  ///
  /// In en, this message translates to:
  /// **'Due to'**
  String get myTasksDueTo;

  /// No description provided for @myTasksAnyDueDate.
  ///
  /// In en, this message translates to:
  /// **'Any due date'**
  String get myTasksAnyDueDate;

  /// No description provided for @myTasksClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get myTasksClear;

  /// No description provided for @myTasksChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get myTasksChooseDate;

  /// No description provided for @myTasksApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get myTasksApply;

  /// No description provided for @myTasksInvalidDueRange.
  ///
  /// In en, this message translates to:
  /// **'The end date cannot be earlier than the start date.'**
  String get myTasksInvalidDueRange;

  /// No description provided for @myTasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'You currently have no tasks that require action.'**
  String get myTasksEmpty;

  /// No description provided for @myTasksRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get myTasksRetry;

  /// No description provided for @myTasksPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get myTasksPriorityLow;

  /// No description provided for @myTasksPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get myTasksPriorityNormal;

  /// No description provided for @myTasksPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get myTasksPriorityHigh;

  /// No description provided for @myTasksPriorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get myTasksPriorityCritical;

  /// No description provided for @myTasksInvolvementAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get myTasksInvolvementAny;

  /// No description provided for @myTasksInvolvementPrimaryAssignee.
  ///
  /// In en, this message translates to:
  /// **'Primary assignee'**
  String get myTasksInvolvementPrimaryAssignee;

  /// No description provided for @myTasksInvolvementCollaborator.
  ///
  /// In en, this message translates to:
  /// **'Collaborator'**
  String get myTasksInvolvementCollaborator;

  /// No description provided for @myTasksInvolvementAssignee.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get myTasksInvolvementAssignee;

  /// No description provided for @myTasksInvolvementWatcher.
  ///
  /// In en, this message translates to:
  /// **'Watcher'**
  String get myTasksInvolvementWatcher;

  /// No description provided for @settingsSectionProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsSectionProfileTitle;

  /// No description provided for @settingsSectionProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Photo and account details'**
  String get settingsSectionProfileSubtitle;

  /// No description provided for @settingsProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile photo'**
  String get settingsProfileTitle;

  /// No description provided for @settingsProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your photo will be visible in Workspaces and next to your tasks.'**
  String get settingsProfileSubtitle;

  /// No description provided for @settingsProfileChooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get settingsProfileChooseAvatar;

  /// No description provided for @settingsProfileRemoveAvatar.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get settingsProfileRemoveAvatar;

  /// No description provided for @settingsProfileAvatarHint.
  ///
  /// In en, this message translates to:
  /// **'PNG, JPEG, WebP or GIF. Choose a clear square photo.'**
  String get settingsProfileAvatarHint;

  /// No description provided for @settingsProfileUploadInProgress.
  ///
  /// In en, this message translates to:
  /// **'Saving photo…'**
  String get settingsProfileUploadInProgress;

  /// No description provided for @settingsProfileRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get settingsProfileRetry;

  /// No description provided for @settingsProfileAvatarTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The selected photo is larger than 5 MB.'**
  String get settingsProfileAvatarTooLarge;

  /// No description provided for @tasksScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Project schedule'**
  String get tasksScheduleTitle;

  /// No description provided for @tasksScheduleDescription.
  ///
  /// In en, this message translates to:
  /// **'Set how deadlines cascade and manage workspace-wide non-working days.'**
  String get tasksScheduleDescription;

  /// No description provided for @tasksScheduleMode.
  ///
  /// In en, this message translates to:
  /// **'Scheduling mode'**
  String get tasksScheduleMode;

  /// No description provided for @tasksScheduleManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get tasksScheduleManual;

  /// No description provided for @tasksSchedulePushSuccessors.
  ///
  /// In en, this message translates to:
  /// **'Push successors only'**
  String get tasksSchedulePushSuccessors;

  /// No description provided for @tasksScheduleStrictCascade.
  ///
  /// In en, this message translates to:
  /// **'Strict cascade'**
  String get tasksScheduleStrictCascade;

  /// No description provided for @tasksScheduleHolidays.
  ///
  /// In en, this message translates to:
  /// **'Non-working days'**
  String get tasksScheduleHolidays;

  /// No description provided for @tasksScheduleNoHolidays.
  ///
  /// In en, this message translates to:
  /// **'No non-working days defined.'**
  String get tasksScheduleNoHolidays;

  /// No description provided for @tasksScheduleAddHoliday.
  ///
  /// In en, this message translates to:
  /// **'Add non-working day'**
  String get tasksScheduleAddHoliday;

  /// No description provided for @tasksScheduleHolidayName.
  ///
  /// In en, this message translates to:
  /// **'Name of non-working day'**
  String get tasksScheduleHolidayName;

  /// No description provided for @tasksScheduleChooseHolidayDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get tasksScheduleChooseHolidayDate;

  /// No description provided for @tasksSavedViews.
  ///
  /// In en, this message translates to:
  /// **'Saved views'**
  String get tasksSavedViews;

  /// No description provided for @tasksSavedViewsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create view'**
  String get tasksSavedViewsCreate;

  /// No description provided for @tasksSavedViewsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage view'**
  String get tasksSavedViewsManage;

  /// No description provided for @tasksSavedViewsRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get tasksSavedViewsRename;

  /// No description provided for @tasksSavedViewsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete view'**
  String get tasksSavedViewsDelete;

  /// No description provided for @tasksSavedViewsDeleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete the “{name}” view?'**
  String tasksSavedViewsDeleteDescription(Object name);

  /// No description provided for @tasksSavedViewsName.
  ///
  /// In en, this message translates to:
  /// **'View name'**
  String get tasksSavedViewsName;

  /// No description provided for @tasksSavedViewsLayout.
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get tasksSavedViewsLayout;

  /// No description provided for @tasksSavedViewsSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get tasksSavedViewsSort;

  /// No description provided for @tasksSavedViewsAscending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get tasksSavedViewsAscending;

  /// No description provided for @tasksSavedViewsDescending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get tasksSavedViewsDescending;

  /// No description provided for @tasksSavedViewsGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get tasksSavedViewsGroup;

  /// No description provided for @tasksSavedViewsFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get tasksSavedViewsFilters;

  /// No description provided for @tasksSavedViewsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search title and description'**
  String get tasksSavedViewsSearch;

  /// No description provided for @tasksSavedViewsPinnedOnly.
  ///
  /// In en, this message translates to:
  /// **'Pinned tasks only'**
  String get tasksSavedViewsPinnedOnly;

  /// No description provided for @tasksSavedViewsIncludeArchived.
  ///
  /// In en, this message translates to:
  /// **'Include archived'**
  String get tasksSavedViewsIncludeArchived;

  /// No description provided for @tasksSavedViewsStatuses.
  ///
  /// In en, this message translates to:
  /// **'Statuses'**
  String get tasksSavedViewsStatuses;

  /// No description provided for @tasksSavedViewsPriorities.
  ///
  /// In en, this message translates to:
  /// **'Priorities'**
  String get tasksSavedViewsPriorities;

  /// No description provided for @tasksSavedViewsColumns.
  ///
  /// In en, this message translates to:
  /// **'Visible columns'**
  String get tasksSavedViewsColumns;

  /// No description provided for @tasksSavedViewsSortPosition.
  ///
  /// In en, this message translates to:
  /// **'Board position'**
  String get tasksSavedViewsSortPosition;

  /// No description provided for @tasksSavedViewsSortUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get tasksSavedViewsSortUpdated;

  /// No description provided for @tasksSavedViewsSortDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get tasksSavedViewsSortDueDate;

  /// No description provided for @tasksSavedViewsSortPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get tasksSavedViewsSortPriority;

  /// No description provided for @tasksSavedViewsSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tasksSavedViewsSortTitle;

  /// No description provided for @tasksSavedViewsGroupNone.
  ///
  /// In en, this message translates to:
  /// **'No grouping'**
  String get tasksSavedViewsGroupNone;

  /// No description provided for @tasksSavedViewsGroupStatus.
  ///
  /// In en, this message translates to:
  /// **'By status'**
  String get tasksSavedViewsGroupStatus;

  /// No description provided for @tasksListGroupProjectWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Project workflow'**
  String get tasksListGroupProjectWorkflow;

  /// No description provided for @tasksSavedViewsGroupPriority.
  ///
  /// In en, this message translates to:
  /// **'By priority'**
  String get tasksSavedViewsGroupPriority;

  /// No description provided for @tasksSavedViewsGroupAssignee.
  ///
  /// In en, this message translates to:
  /// **'By assignee'**
  String get tasksSavedViewsGroupAssignee;

  /// No description provided for @tasksSavedViewsColumnKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get tasksSavedViewsColumnKey;

  /// No description provided for @tasksSavedViewsColumnTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tasksSavedViewsColumnTitle;

  /// No description provided for @tasksSavedViewsColumnStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tasksSavedViewsColumnStatus;

  /// No description provided for @tasksSavedViewsColumnPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get tasksSavedViewsColumnPriority;

  /// No description provided for @tasksSavedViewsColumnAssignees.
  ///
  /// In en, this message translates to:
  /// **'Assignees'**
  String get tasksSavedViewsColumnAssignees;

  /// No description provided for @tasksSavedViewsColumnStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get tasksSavedViewsColumnStartDate;

  /// No description provided for @tasksSavedViewsColumnDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get tasksSavedViewsColumnDueDate;

  /// No description provided for @tasksSavedViewsColumnChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist progress'**
  String get tasksSavedViewsColumnChecklist;

  /// No description provided for @tasksSavedViewsColumnUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get tasksSavedViewsColumnUpdated;

  /// No description provided for @tasksSavedViewsUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get tasksSavedViewsUnassigned;

  /// No description provided for @tasksSavedViewsAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned tasks'**
  String get tasksSavedViewsAssigned;

  /// No description provided for @tasksSavedViewsDefault.
  ///
  /// In en, this message translates to:
  /// **'Default view'**
  String get tasksSavedViewsDefault;

  /// No description provided for @tasksSavedViewsSaveCurrent.
  ///
  /// In en, this message translates to:
  /// **'Save current view'**
  String get tasksSavedViewsSaveCurrent;

  /// No description provided for @tasksSavedViewsSaveActiveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes to view'**
  String get tasksSavedViewsSaveActiveChanges;

  /// No description provided for @tasksSavedViewsModified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get tasksSavedViewsModified;

  /// No description provided for @tasksSavedViewsListLoading.
  ///
  /// In en, this message translates to:
  /// **'Task list is still loading'**
  String get tasksSavedViewsListLoading;

  /// No description provided for @tasksCapacityTitle.
  ///
  /// In en, this message translates to:
  /// **'Team availability'**
  String get tasksCapacityTitle;

  /// No description provided for @tasksCapacityDescription.
  ///
  /// In en, this message translates to:
  /// **'Set the workspace default daily availability and time-bound exceptions for people in this project.'**
  String get tasksCapacityDescription;

  /// No description provided for @tasksCapacityDefaultDaily.
  ///
  /// In en, this message translates to:
  /// **'Default daily availability'**
  String get tasksCapacityDefaultDaily;

  /// No description provided for @tasksCapacityMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get tasksCapacityMinutes;

  /// No description provided for @tasksCapacityOverrides.
  ///
  /// In en, this message translates to:
  /// **'Availability exceptions'**
  String get tasksCapacityOverrides;

  /// No description provided for @tasksCapacityAddOverride.
  ///
  /// In en, this message translates to:
  /// **'Add exception'**
  String get tasksCapacityAddOverride;

  /// No description provided for @tasksCapacityNoOverrides.
  ///
  /// In en, this message translates to:
  /// **'No availability exceptions yet.'**
  String get tasksCapacityNoOverrides;

  /// No description provided for @tasksCapacityUnknownMember.
  ///
  /// In en, this message translates to:
  /// **'Unavailable project member'**
  String get tasksCapacityUnknownMember;

  /// No description provided for @tasksCapacityMember.
  ///
  /// In en, this message translates to:
  /// **'Project member'**
  String get tasksCapacityMember;

  /// No description provided for @tasksCapacityStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get tasksCapacityStartDate;

  /// No description provided for @tasksCapacityEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get tasksCapacityEndDate;

  /// No description provided for @tasksCapacityReason.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get tasksCapacityReason;

  /// No description provided for @tasksViewWorkload.
  ///
  /// In en, this message translates to:
  /// **'Workload'**
  String get tasksViewWorkload;

  /// No description provided for @tasksWorkloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Team workload'**
  String get tasksWorkloadTitle;

  /// No description provided for @tasksWorkloadRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get tasksWorkloadRange;

  /// No description provided for @tasksWorkloadTasks.
  ///
  /// In en, this message translates to:
  /// **'tasks'**
  String get tasksWorkloadTasks;

  /// No description provided for @tasksWorkloadAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get tasksWorkloadAvailable;

  /// No description provided for @tasksWorkloadRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get tasksWorkloadRemaining;

  /// No description provided for @tasksWorkloadOverCapacity.
  ///
  /// In en, this message translates to:
  /// **'Over capacity'**
  String get tasksWorkloadOverCapacity;

  /// No description provided for @tasksWorkloadEmpty.
  ///
  /// In en, this message translates to:
  /// **'No workload data for the selected range.'**
  String get tasksWorkloadEmpty;

  /// No description provided for @tasksViewTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get tasksViewTimeline;

  /// No description provided for @tasksTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Project schedule'**
  String get tasksTimelineTitle;

  /// No description provided for @tasksTimelineRange.
  ///
  /// In en, this message translates to:
  /// **'Schedule range'**
  String get tasksTimelineRange;

  /// No description provided for @tasksTimelineUndated.
  ///
  /// In en, this message translates to:
  /// **'Undated'**
  String get tasksTimelineUndated;

  /// No description provided for @tasksTimelineDependencies.
  ///
  /// In en, this message translates to:
  /// **'dependencies'**
  String get tasksTimelineDependencies;

  /// No description provided for @taskDetailsCascadePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview cascade'**
  String get taskDetailsCascadePreview;

  /// No description provided for @taskDetailsCascadePreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Review affected tasks and dates before saving.'**
  String get taskDetailsCascadePreviewDescription;

  /// No description provided for @taskDetailsCascadeChanges.
  ///
  /// In en, this message translates to:
  /// **'Schedule changes'**
  String get taskDetailsCascadeChanges;

  /// No description provided for @taskDetailsCascadeNoChanges.
  ///
  /// In en, this message translates to:
  /// **'The date change does not move other tasks.'**
  String get taskDetailsCascadeNoChanges;

  /// No description provided for @taskDetailsCascadeApply.
  ///
  /// In en, this message translates to:
  /// **'Apply cascade'**
  String get taskDetailsCascadeApply;

  /// No description provided for @taskDetailsCascadeCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical path'**
  String get taskDetailsCascadeCritical;

  /// No description provided for @taskDetailsCascadePreviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare the cascade preview.'**
  String get taskDetailsCascadePreviewFailed;

  /// No description provided for @taskDetailsCascadeApplyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not apply the cascade. Refresh the data and try again.'**
  String get taskDetailsCascadeApplyFailed;

  /// No description provided for @taskDetailsCascadeDatesRequired.
  ///
  /// In en, this message translates to:
  /// **'Set both a start and due date to preview the cascade.'**
  String get taskDetailsCascadeDatesRequired;

  /// No description provided for @tasksRecurrenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring tasks'**
  String get tasksRecurrenceTitle;

  /// No description provided for @tasksRecurrenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage recurrence schedules and audit past occurrences in project'**
  String get tasksRecurrenceDescription;

  /// No description provided for @tasksRecurrenceTabSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get tasksRecurrenceTabSchedule;

  /// No description provided for @tasksRecurrenceTabRuns.
  ///
  /// In en, this message translates to:
  /// **'Run history'**
  String get tasksRecurrenceTabRuns;

  /// No description provided for @tasksRecurrenceActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tasksRecurrenceActive;

  /// No description provided for @tasksRecurrencePaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get tasksRecurrencePaused;

  /// No description provided for @tasksRecurrenceEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recurring tasks in this project'**
  String get tasksRecurrenceEmptyTitle;

  /// No description provided for @tasksRecurrenceEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'To configure recurrence, open a task and click the recurrence icon 🔄.'**
  String get tasksRecurrenceEmptyDescription;

  /// No description provided for @tasksRecurrenceRunsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No run history'**
  String get tasksRecurrenceRunsEmptyTitle;

  /// No description provided for @tasksRecurrenceRunsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Completed and skipped task occurrences will appear here.'**
  String get tasksRecurrenceRunsEmptyDescription;

  /// No description provided for @tasksRecurrenceRunNow.
  ///
  /// In en, this message translates to:
  /// **'Run occurrence now'**
  String get tasksRecurrenceRunNow;

  /// No description provided for @tasksRecurrenceRunNowSuccess.
  ///
  /// In en, this message translates to:
  /// **'New task occurrence created'**
  String get tasksRecurrenceRunNowSuccess;

  /// No description provided for @tasksRecurrenceEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit recurrence settings'**
  String get tasksRecurrenceEdit;

  /// No description provided for @tasksRecurrenceNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tasksRecurrenceNext;

  /// No description provided for @tasksRecurrenceModeScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get tasksRecurrenceModeScheduled;

  /// No description provided for @tasksRecurrenceModeAfterCompletion.
  ///
  /// In en, this message translates to:
  /// **'After completion'**
  String get tasksRecurrenceModeAfterCompletion;

  /// No description provided for @tasksRecurrenceOutcomeCreated.
  ///
  /// In en, this message translates to:
  /// **'Occurrence created'**
  String get tasksRecurrenceOutcomeCreated;

  /// No description provided for @tasksRecurrenceOutcomeSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped (previous task still open)'**
  String get tasksRecurrenceOutcomeSkipped;

  /// No description provided for @tasksRecurrenceFilterOnly.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get tasksRecurrenceFilterOnly;

  /// No description provided for @tasksRecurrenceDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete recurrence'**
  String get tasksRecurrenceDelete;

  /// No description provided for @tasksRecurrenceDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this recurrence rule?'**
  String get tasksRecurrenceDeleteConfirm;

  /// No description provided for @tasksRecurrenceDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recurrence deleted successfully'**
  String get tasksRecurrenceDeleteSuccess;

  /// No description provided for @taskRecurrenceIntervalDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get taskRecurrenceIntervalDaily;

  /// No description provided for @taskRecurrenceIntervalDays.
  ///
  /// In en, this message translates to:
  /// **'Every {interval} days'**
  String taskRecurrenceIntervalDays(int interval);

  /// No description provided for @taskRecurrenceIntervalWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get taskRecurrenceIntervalWeekly;

  /// No description provided for @taskRecurrenceIntervalWeeks.
  ///
  /// In en, this message translates to:
  /// **'Every {interval} weeks'**
  String taskRecurrenceIntervalWeeks(int interval);

  /// No description provided for @taskRecurrenceIntervalMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get taskRecurrenceIntervalMonthly;

  /// No description provided for @taskRecurrenceIntervalMonths.
  ///
  /// In en, this message translates to:
  /// **'Every {interval} months'**
  String taskRecurrenceIntervalMonths(int interval);

  /// No description provided for @taskRecurrenceHeader.
  ///
  /// In en, this message translates to:
  /// **'Task recurrence'**
  String get taskRecurrenceHeader;

  /// No description provided for @taskRecurrenceFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Recurrence frequency'**
  String get taskRecurrenceFrequencyLabel;

  /// No description provided for @taskRecurrencePresetWorkdays.
  ///
  /// In en, this message translates to:
  /// **'On workdays'**
  String get taskRecurrencePresetWorkdays;

  /// No description provided for @taskRecurrencePresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom...'**
  String get taskRecurrencePresetCustom;

  /// No description provided for @taskRecurrenceRepeatEvery.
  ///
  /// In en, this message translates to:
  /// **'Repeat every:'**
  String get taskRecurrenceRepeatEvery;

  /// No description provided for @taskRecurrenceUnitDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get taskRecurrenceUnitDays;

  /// No description provided for @taskRecurrenceUnitWeeks.
  ///
  /// In en, this message translates to:
  /// **'Weeks'**
  String get taskRecurrenceUnitWeeks;

  /// No description provided for @taskRecurrenceUnitMonths.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get taskRecurrenceUnitMonths;

  /// No description provided for @taskRecurrenceScheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Recurrence occurrence schedule'**
  String get taskRecurrenceScheduleLabel;

  /// No description provided for @taskRecurrenceModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Recurrence mode'**
  String get taskRecurrenceModeLabel;

  /// No description provided for @taskRecurrenceOccurrenceStatus.
  ///
  /// In en, this message translates to:
  /// **'Initial status for new task'**
  String get taskRecurrenceOccurrenceStatus;

  /// No description provided for @taskRecurrenceSkipIfPreviousOpen.
  ///
  /// In en, this message translates to:
  /// **'Skip creation if previous task is still open'**
  String get taskRecurrenceSkipIfPreviousOpen;

  /// No description provided for @taskRecurrenceSave.
  ///
  /// In en, this message translates to:
  /// **'Save schedule'**
  String get taskRecurrenceSave;

  /// No description provided for @taskRecurrenceSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get taskRecurrenceSaving;

  /// No description provided for @taskRecurrencePauseSeries.
  ///
  /// In en, this message translates to:
  /// **'Pause series'**
  String get taskRecurrencePauseSeries;

  /// No description provided for @taskRecurrenceResumeSeries.
  ///
  /// In en, this message translates to:
  /// **'Resume series'**
  String get taskRecurrenceResumeSeries;

  /// No description provided for @taskRecurrenceSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recurrence schedule saved'**
  String get taskRecurrenceSaveSuccess;

  /// No description provided for @tasksListEditTitleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit task title'**
  String get tasksListEditTitleTooltip;

  /// No description provided for @tasksListPinTooltip.
  ///
  /// In en, this message translates to:
  /// **'Pin task'**
  String get tasksListPinTooltip;

  /// No description provided for @tasksListUnpinTooltip.
  ///
  /// In en, this message translates to:
  /// **'Unpin task'**
  String get tasksListUnpinTooltip;

  /// No description provided for @tasksListWatchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Watch task'**
  String get tasksListWatchTooltip;

  /// No description provided for @tasksListUnwatchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stop watching task'**
  String get tasksListUnwatchTooltip;

  /// No description provided for @tasksListMoreOptionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get tasksListMoreOptionsTooltip;

  /// No description provided for @tasksListKeyCopiedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Task key copied to clipboard'**
  String get tasksListKeyCopiedTooltip;

  /// No description provided for @tasksListAddInGroupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add task in group: {group}'**
  String tasksListAddInGroupTooltip(String group);

  /// No description provided for @tasksListQuickCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get tasksListQuickCreateTitle;

  /// No description provided for @tasksListQuickCreateHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new task title...'**
  String get tasksListQuickCreateHint;

  /// No description provided for @tasksListQuickCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get tasksListQuickCreateButton;

  /// No description provided for @tasksListQuickCreateCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tasksListQuickCreateCancel;

  /// No description provided for @tasksListRecurrenceSeriesBadge.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get tasksListRecurrenceSeriesBadge;

  /// No description provided for @tasksListRecurrenceCycleBadge.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get tasksListRecurrenceCycleBadge;

  /// No description provided for @tasksListInlineCreateKeyboardHint.
  ///
  /// In en, this message translates to:
  /// **'Press Enter to save, Esc to cancel'**
  String get tasksListInlineCreateKeyboardHint;

  /// No description provided for @tasksListInlineCreateHint.
  ///
  /// In en, this message translates to:
  /// **'Task name'**
  String get tasksListInlineCreateHint;

  /// No description provided for @tasksListInlineCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get tasksListInlineCreateButton;

  /// No description provided for @tasksListExpandGroupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Expand group'**
  String get tasksListExpandGroupTooltip;

  /// No description provided for @tasksListCollapseGroupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Collapse group'**
  String get tasksListCollapseGroupTooltip;

  /// No description provided for @tasksListClearDateButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get tasksListClearDateButton;

  /// No description provided for @tasksListCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tasksListCancelButton;

  /// No description provided for @tasksListSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get tasksListSaveButton;

  /// No description provided for @tasksListChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get tasksListChecklistTitle;

  /// No description provided for @tasksListChecklistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No checklist items'**
  String get tasksListChecklistEmpty;

  /// No description provided for @tasksListChecklistAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get tasksListChecklistAddItem;

  /// No description provided for @tasksListChecklistNewItemHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new item...'**
  String get tasksListChecklistNewItemHint;

  /// No description provided for @tasksListChecklistAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add checklist'**
  String get tasksListChecklistAddAction;

  /// No description provided for @tasksListDatePresetToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tasksListDatePresetToday;

  /// No description provided for @tasksListDatePresetTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tasksListDatePresetTomorrow;

  /// No description provided for @tasksListDatePresetNextWeek.
  ///
  /// In en, this message translates to:
  /// **'In a week'**
  String get tasksListDatePresetNextWeek;

  /// No description provided for @tasksListDatePresetNextMonth.
  ///
  /// In en, this message translates to:
  /// **'In a month'**
  String get tasksListDatePresetNextMonth;

  /// No description provided for @tasksListCustomStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom status'**
  String get tasksListCustomStatusLabel;

  /// No description provided for @tasksListCustomStatusNone.
  ///
  /// In en, this message translates to:
  /// **'No custom status'**
  String get tasksListCustomStatusNone;

  /// No description provided for @tasksListLabelsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search labels...'**
  String get tasksListLabelsSearchHint;

  /// No description provided for @tasksListLabelsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No labels'**
  String get tasksListLabelsEmpty;

  /// No description provided for @projectSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Project settings'**
  String get projectSettingsTitle;

  /// No description provided for @projectSettingsTabGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get projectSettingsTabGeneral;

  /// No description provided for @projectSettingsTabMembers.
  ///
  /// In en, this message translates to:
  /// **'Members & access'**
  String get projectSettingsTabMembers;

  /// No description provided for @projectSettingsTabWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Statuses & workflow'**
  String get projectSettingsTabWorkflow;

  /// No description provided for @projectSettingsTabCustomFields.
  ///
  /// In en, this message translates to:
  /// **'Custom fields'**
  String get projectSettingsTabCustomFields;

  /// No description provided for @projectSettingsTabLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get projectSettingsTabLabels;

  /// No description provided for @projectSettingsTabMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get projectSettingsTabMilestones;

  /// No description provided for @projectSettingsTabAutomations.
  ///
  /// In en, this message translates to:
  /// **'Automations'**
  String get projectSettingsTabAutomations;

  /// No description provided for @projectSettingsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get projectSettingsNameLabel;

  /// No description provided for @projectSettingsNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter project name...'**
  String get projectSettingsNameHint;

  /// No description provided for @projectSettingsDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Project description'**
  String get projectSettingsDescriptionLabel;

  /// No description provided for @projectSettingsDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter optional project description...'**
  String get projectSettingsDescriptionHint;

  /// No description provided for @projectSettingsIconAndColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon & primary color'**
  String get projectSettingsIconAndColorLabel;

  /// No description provided for @projectSettingsVisibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Project visibility'**
  String get projectSettingsVisibilityLabel;

  /// No description provided for @projectSettingsVisibilityShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get projectSettingsVisibilityShared;

  /// No description provided for @projectSettingsVisibilitySharedDesc.
  ///
  /// In en, this message translates to:
  /// **'Visible to all members of the workspace.'**
  String get projectSettingsVisibilitySharedDesc;

  /// No description provided for @projectSettingsVisibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get projectSettingsVisibilityPrivate;

  /// No description provided for @projectSettingsVisibilityPrivateDesc.
  ///
  /// In en, this message translates to:
  /// **'Only accessible by members explicitly added to the project.'**
  String get projectSettingsVisibilityPrivateDesc;

  /// No description provided for @projectSettingsSaveGeneral.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get projectSettingsSaveGeneral;

  /// No description provided for @projectSettingsGeneralSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project details updated successfully.'**
  String get projectSettingsGeneralSavedSuccess;

  /// No description provided for @projectSettingsDangerZoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get projectSettingsDangerZoneTitle;

  /// No description provided for @projectSettingsArchiveProject.
  ///
  /// In en, this message translates to:
  /// **'Archive project'**
  String get projectSettingsArchiveProject;

  /// No description provided for @projectSettingsArchiveProjectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to archive this project? Tasks and resources will remain in history.'**
  String get projectSettingsArchiveProjectConfirm;

  /// No description provided for @projectSettingsRestoreProject.
  ///
  /// In en, this message translates to:
  /// **'Restore project'**
  String get projectSettingsRestoreProject;

  /// No description provided for @projectSettingsDeleteProject.
  ///
  /// In en, this message translates to:
  /// **'Delete project permanently'**
  String get projectSettingsDeleteProject;

  /// No description provided for @projectSettingsDeleteProjectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this archived project? This action cannot be undone.'**
  String get projectSettingsDeleteProjectConfirm;

  /// No description provided for @projectSettingsMembersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Filter project members...'**
  String get projectSettingsMembersSearchHint;

  /// No description provided for @projectSettingsAddMemberButton.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get projectSettingsAddMemberButton;

  /// No description provided for @projectSettingsAddMemberDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add member to project'**
  String get projectSettingsAddMemberDialogTitle;

  /// No description provided for @projectSettingsSelectWorkspaceUser.
  ///
  /// In en, this message translates to:
  /// **'Select user from workspace'**
  String get projectSettingsSelectWorkspaceUser;

  /// No description provided for @projectSettingsSelectRole.
  ///
  /// In en, this message translates to:
  /// **'Select project role'**
  String get projectSettingsSelectRole;

  /// No description provided for @projectSettingsMemberRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get projectSettingsMemberRoleOwner;

  /// No description provided for @projectSettingsMemberRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get projectSettingsMemberRoleAdmin;

  /// No description provided for @projectSettingsMemberRoleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get projectSettingsMemberRoleMember;

  /// No description provided for @projectSettingsMemberRoleObserver.
  ///
  /// In en, this message translates to:
  /// **'Observer'**
  String get projectSettingsMemberRoleObserver;

  /// No description provided for @projectSettingsRemoveMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this user from the project?'**
  String get projectSettingsRemoveMemberConfirm;

  /// No description provided for @projectSettingsNoMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No project members found'**
  String get projectSettingsNoMembersFound;

  /// No description provided for @projectSettingsWorkflowColumnsHeader.
  ///
  /// In en, this message translates to:
  /// **'Board columns and task statuses'**
  String get projectSettingsWorkflowColumnsHeader;

  /// No description provided for @projectSettingsWorkflowAddStatus.
  ///
  /// In en, this message translates to:
  /// **'Add status'**
  String get projectSettingsWorkflowAddStatus;

  /// No description provided for @projectSettingsWorkflowEditStatus.
  ///
  /// In en, this message translates to:
  /// **'Edit status'**
  String get projectSettingsWorkflowEditStatus;

  /// No description provided for @projectSettingsWorkflowDeleteStatus.
  ///
  /// In en, this message translates to:
  /// **'Delete status'**
  String get projectSettingsWorkflowDeleteStatus;

  /// No description provided for @projectSettingsWorkflowStatusName.
  ///
  /// In en, this message translates to:
  /// **'Status name'**
  String get projectSettingsWorkflowStatusName;

  /// No description provided for @projectSettingsWorkflowStatusColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get projectSettingsWorkflowStatusColor;

  /// No description provided for @projectSettingsWorkflowStatusCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get projectSettingsWorkflowStatusCategory;

  /// No description provided for @projectSettingsWorkflowWipLimit.
  ///
  /// In en, this message translates to:
  /// **'Task limit (WIP)'**
  String get projectSettingsWorkflowWipLimit;

  /// No description provided for @projectSettingsWorkflowWipLimitHint.
  ///
  /// In en, this message translates to:
  /// **'0 = no limit'**
  String get projectSettingsWorkflowWipLimitHint;

  /// No description provided for @projectSettingsWorkflowTemplatesButton.
  ///
  /// In en, this message translates to:
  /// **'Workflow templates'**
  String get projectSettingsWorkflowTemplatesButton;

  /// No description provided for @projectSettingsWorkflowApplyTemplateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Applying template will create new workflow columns. Do you want to proceed?'**
  String get projectSettingsWorkflowApplyTemplateConfirm;

  /// No description provided for @projectSettingsWorkflowEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No workflow columns configured'**
  String get projectSettingsWorkflowEmptyTitle;

  /// No description provided for @projectSettingsWorkflowEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'This project uses system default task statuses or does not have custom Kanban columns yet. Define custom statuses or select a ready workflow template.'**
  String get projectSettingsWorkflowEmptyDesc;

  /// No description provided for @projectSettingsCustomFieldsHeader.
  ///
  /// In en, this message translates to:
  /// **'Custom field definitions'**
  String get projectSettingsCustomFieldsHeader;

  /// No description provided for @projectSettingsAddCustomField.
  ///
  /// In en, this message translates to:
  /// **'Add field'**
  String get projectSettingsAddCustomField;

  /// No description provided for @projectSettingsCustomFieldName.
  ///
  /// In en, this message translates to:
  /// **'Field name'**
  String get projectSettingsCustomFieldName;

  /// No description provided for @projectSettingsCustomFieldType.
  ///
  /// In en, this message translates to:
  /// **'Field type'**
  String get projectSettingsCustomFieldType;

  /// No description provided for @projectSettingsCustomFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get projectSettingsCustomFieldRequired;

  /// No description provided for @projectSettingsCustomFieldOptions.
  ///
  /// In en, this message translates to:
  /// **'Options (comma-separated)'**
  String get projectSettingsCustomFieldOptions;

  /// No description provided for @projectSettingsCustomFieldsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No custom fields defined'**
  String get projectSettingsCustomFieldsEmpty;

  /// No description provided for @projectSettingsLabelsHeader.
  ///
  /// In en, this message translates to:
  /// **'Project labels'**
  String get projectSettingsLabelsHeader;

  /// No description provided for @projectSettingsAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add label'**
  String get projectSettingsAddLabel;

  /// No description provided for @projectSettingsLabelName.
  ///
  /// In en, this message translates to:
  /// **'Label name'**
  String get projectSettingsLabelName;

  /// No description provided for @projectSettingsLabelColor.
  ///
  /// In en, this message translates to:
  /// **'Label color'**
  String get projectSettingsLabelColor;

  /// No description provided for @projectSettingsLabelsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No labels created'**
  String get projectSettingsLabelsEmpty;

  /// No description provided for @projectSettingsMilestonesHeader.
  ///
  /// In en, this message translates to:
  /// **'Milestones (Project stages)'**
  String get projectSettingsMilestonesHeader;

  /// No description provided for @projectSettingsAddMilestone.
  ///
  /// In en, this message translates to:
  /// **'New milestone'**
  String get projectSettingsAddMilestone;

  /// No description provided for @projectSettingsMilestoneName.
  ///
  /// In en, this message translates to:
  /// **'Milestone name'**
  String get projectSettingsMilestoneName;

  /// No description provided for @projectSettingsMilestoneDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get projectSettingsMilestoneDueDate;

  /// No description provided for @projectSettingsMilestoneProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get projectSettingsMilestoneProgress;

  /// No description provided for @projectSettingsMilestonesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No milestones defined'**
  String get projectSettingsMilestonesEmpty;

  /// No description provided for @projectSettingsAutomationsHeader.
  ///
  /// In en, this message translates to:
  /// **'Task automation rules'**
  String get projectSettingsAutomationsHeader;

  /// No description provided for @projectSettingsAddAutomation.
  ///
  /// In en, this message translates to:
  /// **'New automation'**
  String get projectSettingsAddAutomation;

  /// No description provided for @projectSettingsAutomationTrigger.
  ///
  /// In en, this message translates to:
  /// **'Trigger (When)'**
  String get projectSettingsAutomationTrigger;

  /// No description provided for @projectSettingsAutomationAction.
  ///
  /// In en, this message translates to:
  /// **'Action (Then)'**
  String get projectSettingsAutomationAction;

  /// No description provided for @projectSettingsAutomationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No automations configured'**
  String get projectSettingsAutomationsEmpty;

  /// No description provided for @projectSettingsReadOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'You have read-only access (Member/Observer). Project settings editing is restricted.'**
  String get projectSettingsReadOnlyNotice;

  /// No description provided for @workspaceSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace settings'**
  String get workspaceSettingsTitle;

  /// No description provided for @workspaceSettingsTabGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get workspaceSettingsTabGeneral;

  /// No description provided for @workspaceSettingsTabMembers.
  ///
  /// In en, this message translates to:
  /// **'Members & invitations'**
  String get workspaceSettingsTabMembers;

  /// No description provided for @workspaceSettingsTabNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get workspaceSettingsTabNotifications;

  /// No description provided for @workspaceSettingsTabCapacity.
  ///
  /// In en, this message translates to:
  /// **'Working hours & capacity'**
  String get workspaceSettingsTabCapacity;

  /// No description provided for @workspaceSettingsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace name'**
  String get workspaceSettingsNameLabel;

  /// No description provided for @workspaceSettingsNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter workspace name...'**
  String get workspaceSettingsNameHint;

  /// No description provided for @workspaceSettingsDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace description'**
  String get workspaceSettingsDescriptionLabel;

  /// No description provided for @workspaceSettingsDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter optional workspace description...'**
  String get workspaceSettingsDescriptionHint;

  /// No description provided for @workspaceSettingsSaveGeneral.
  ///
  /// In en, this message translates to:
  /// **'Save workspace details'**
  String get workspaceSettingsSaveGeneral;

  /// No description provided for @workspaceSettingsSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Workspace details updated successfully.'**
  String get workspaceSettingsSavedSuccess;

  /// No description provided for @workspaceSettingsArchiveWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Archive workspace'**
  String get workspaceSettingsArchiveWorkspace;

  /// No description provided for @workspaceSettingsArchiveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to archive this workspace? It will be hidden from the active list.'**
  String get workspaceSettingsArchiveConfirm;

  /// No description provided for @workspaceSettingsRestoreWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Restore workspace'**
  String get workspaceSettingsRestoreWorkspace;

  /// No description provided for @workspaceSettingsMembersHeader.
  ///
  /// In en, this message translates to:
  /// **'Active members'**
  String get workspaceSettingsMembersHeader;

  /// No description provided for @workspaceSettingsInviteUserButton.
  ///
  /// In en, this message translates to:
  /// **'Invite user'**
  String get workspaceSettingsInviteUserButton;

  /// No description provided for @workspaceSettingsInviteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite Ready user to workspace'**
  String get workspaceSettingsInviteDialogTitle;

  /// No description provided for @workspaceSettingsSearchReadyHint.
  ///
  /// In en, this message translates to:
  /// **'Type name or email to search in Ready...'**
  String get workspaceSettingsSearchReadyHint;

  /// No description provided for @workspaceSettingsSearchReadyMinChars.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters to search in Ready directory.'**
  String get workspaceSettingsSearchReadyMinChars;

  /// No description provided for @workspaceSettingsInvitationsSentHeader.
  ///
  /// In en, this message translates to:
  /// **'Pending invitations'**
  String get workspaceSettingsInvitationsSentHeader;

  /// No description provided for @workspaceSettingsInvitationResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get workspaceSettingsInvitationResend;

  /// No description provided for @workspaceSettingsInvitationCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get workspaceSettingsInvitationCancel;

  /// No description provided for @workspaceSettingsMemberRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get workspaceSettingsMemberRoleOwner;

  /// No description provided for @workspaceSettingsMemberRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get workspaceSettingsMemberRoleAdmin;

  /// No description provided for @workspaceSettingsMemberRoleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get workspaceSettingsMemberRoleMember;

  /// No description provided for @workspaceSettingsMemberRoleObserver.
  ///
  /// In en, this message translates to:
  /// **'Observer'**
  String get workspaceSettingsMemberRoleObserver;

  /// No description provided for @workspaceSettingsRemoveMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this member from the workspace?'**
  String get workspaceSettingsRemoveMemberConfirm;

  /// No description provided for @workspaceSettingsNotificationsChannels.
  ///
  /// In en, this message translates to:
  /// **'Delivery channels'**
  String get workspaceSettingsNotificationsChannels;

  /// No description provided for @workspaceSettingsNotificationsInApp.
  ///
  /// In en, this message translates to:
  /// **'In-app notifications'**
  String get workspaceSettingsNotificationsInApp;

  /// No description provided for @workspaceSettingsNotificationsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email notifications'**
  String get workspaceSettingsNotificationsEmail;

  /// No description provided for @workspaceSettingsNotificationsCategories.
  ///
  /// In en, this message translates to:
  /// **'Notification categories'**
  String get workspaceSettingsNotificationsCategories;

  /// No description provided for @workspaceSettingsCategoryTasks.
  ///
  /// In en, this message translates to:
  /// **'Task updates and assignments'**
  String get workspaceSettingsCategoryTasks;

  /// No description provided for @workspaceSettingsCategoryProjects.
  ///
  /// In en, this message translates to:
  /// **'Project events'**
  String get workspaceSettingsCategoryProjects;

  /// No description provided for @workspaceSettingsCategoryWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace administration & invitations'**
  String get workspaceSettingsCategoryWorkspace;

  /// No description provided for @workspaceSettingsCategoryMentions.
  ///
  /// In en, this message translates to:
  /// **'Chat mentions & comments'**
  String get workspaceSettingsCategoryMentions;

  /// No description provided for @workspaceSettingsSaveNotifications.
  ///
  /// In en, this message translates to:
  /// **'Save notification preferences'**
  String get workspaceSettingsSaveNotifications;

  /// No description provided for @workspaceSettingsNotificationsSaved.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences updated successfully.'**
  String get workspaceSettingsNotificationsSaved;

  /// No description provided for @workspaceSettingsReadOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'You have read-only access in this workspace. Administrative settings are restricted.'**
  String get workspaceSettingsReadOnlyNotice;

  /// No description provided for @projectSettingsTabTemplates.
  ///
  /// In en, this message translates to:
  /// **'Project Templates'**
  String get projectSettingsTabTemplates;

  /// No description provided for @projectSettingsTemplatesHeader.
  ///
  /// In en, this message translates to:
  /// **'Project Templates'**
  String get projectSettingsTemplatesHeader;

  /// No description provided for @projectSettingsCreateTemplateFromProject.
  ///
  /// In en, this message translates to:
  /// **'Save project as template'**
  String get projectSettingsCreateTemplateFromProject;

  /// No description provided for @projectSettingsCreateTemplateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'New template from project'**
  String get projectSettingsCreateTemplateDialogTitle;

  /// No description provided for @projectSettingsTemplateNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Template name *'**
  String get projectSettingsTemplateNameLabel;

  /// No description provided for @projectSettingsTemplateDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Template description (optional)'**
  String get projectSettingsTemplateDescLabel;

  /// No description provided for @projectSettingsTemplatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved templates in this workspace.'**
  String get projectSettingsTemplatesEmpty;

  /// No description provided for @projectSettingsTemplateApplyButton.
  ///
  /// In en, this message translates to:
  /// **'Create project from template'**
  String get projectSettingsTemplateApplyButton;

  /// No description provided for @projectSettingsTemplateApplyDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new project from template'**
  String get projectSettingsTemplateApplyDialogTitle;

  /// No description provided for @projectSettingsTemplateApplyNewProjectName.
  ///
  /// In en, this message translates to:
  /// **'New project name *'**
  String get projectSettingsTemplateApplyNewProjectName;

  /// No description provided for @projectSettingsTemplateDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this project template?'**
  String get projectSettingsTemplateDeleteConfirm;

  /// No description provided for @projectSettingsTemplateRefreshButton.
  ///
  /// In en, this message translates to:
  /// **'Refresh template from project'**
  String get projectSettingsTemplateRefreshButton;

  /// No description provided for @projectSettingsTemplateRefreshConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to update the template content with the current state of this project?'**
  String get projectSettingsTemplateRefreshConfirm;

  /// No description provided for @projectSettingsTemplateApplySuccess.
  ///
  /// In en, this message translates to:
  /// **'New project successfully created from template.'**
  String get projectSettingsTemplateApplySuccess;

  /// No description provided for @projectSettingsTemplateCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template successfully created from project.'**
  String get projectSettingsTemplateCreatedSuccess;

  /// No description provided for @projectSettingsTemplateRefreshedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template successfully refreshed from project.'**
  String get projectSettingsTemplateRefreshedSuccess;

  /// No description provided for @projectSettingsTemplateDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project template successfully deleted.'**
  String get projectSettingsTemplateDeletedSuccess;

  /// No description provided for @projectSettingsTemplateLeaveDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Project Template'**
  String get projectSettingsTemplateLeaveDeleteTitle;

  /// No description provided for @projectSettingsTemplateLeaveDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete template'**
  String get projectSettingsTemplateLeaveDeleteAction;

  /// No description provided for @projectSettingsTemplateDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Template Details'**
  String get projectSettingsTemplateDetailsTitle;

  /// No description provided for @projectSettingsTemplateDetailsWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Workflow Statuses'**
  String get projectSettingsTemplateDetailsWorkflow;

  /// No description provided for @projectSettingsTemplateDetailsCustomFields.
  ///
  /// In en, this message translates to:
  /// **'Custom Fields'**
  String get projectSettingsTemplateDetailsCustomFields;

  /// No description provided for @projectSettingsTemplateDetailsLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get projectSettingsTemplateDetailsLabels;

  /// No description provided for @projectSettingsTemplateDetailsTasks.
  ///
  /// In en, this message translates to:
  /// **'Starter Tasks ({count})'**
  String projectSettingsTemplateDetailsTasks(int count);

  /// No description provided for @projectSettingsTemplateDetailsNoTasks.
  ///
  /// In en, this message translates to:
  /// **'No starter tasks defined.'**
  String get projectSettingsTemplateDetailsNoTasks;

  /// No description provided for @projectSettingsTemplateDetailsNoFields.
  ///
  /// In en, this message translates to:
  /// **'No custom fields defined.'**
  String get projectSettingsTemplateDetailsNoFields;

  /// No description provided for @projectSettingsTemplateDetailsNoLabels.
  ///
  /// In en, this message translates to:
  /// **'No labels defined.'**
  String get projectSettingsTemplateDetailsNoLabels;

  /// No description provided for @projectSettingsTemplateDetailsPreviewButton.
  ///
  /// In en, this message translates to:
  /// **'Details Preview'**
  String get projectSettingsTemplateDetailsPreviewButton;

  /// No description provided for @projectSettingsTemplateDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage project templates and create repeatable structures for tasks, workflows, and configurations.'**
  String get projectSettingsTemplateDesc;

  /// No description provided for @projectSettingsTemplateCreateDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'The current project, along with its workflow statuses, custom fields, and starter tasks, will be saved as a reusable template.'**
  String get projectSettingsTemplateCreateDialogDesc;

  /// No description provided for @projectSettingsTemplateApplyDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'A new project will be created based on this template with all statuses, custom fields, and tasks.'**
  String get projectSettingsTemplateApplyDialogDesc;

  /// No description provided for @projectSettingsTemplateUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated: {date}'**
  String projectSettingsTemplateUpdatedLabel(String date);

  /// No description provided for @projectUserHubTitle.
  ///
  /// In en, this message translates to:
  /// **'My Project Hub'**
  String get projectUserHubTitle;

  /// No description provided for @projectUserHubTabProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get projectUserHubTabProfile;

  /// No description provided for @projectUserHubTabPreferences.
  ///
  /// In en, this message translates to:
  /// **'My Preferences'**
  String get projectUserHubTabPreferences;

  /// No description provided for @projectUserHubProfileHeader.
  ///
  /// In en, this message translates to:
  /// **'Your role in this project'**
  String get projectUserHubProfileHeader;

  /// No description provided for @projectUserHubProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Information about your membership and assigned permissions.'**
  String get projectUserHubProfileDesc;

  /// No description provided for @projectUserHubRoleOwnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Full control over the project, member management, workflow, automations and danger zone.'**
  String get projectUserHubRoleOwnerDesc;

  /// No description provided for @projectUserHubRoleAdminDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage task configuration, statuses, custom fields and project members.'**
  String get projectUserHubRoleAdminDesc;

  /// No description provided for @projectUserHubRoleMemberDesc.
  ///
  /// In en, this message translates to:
  /// **'Full access to creating and editing tasks, comments and delivering work.'**
  String get projectUserHubRoleMemberDesc;

  /// No description provided for @projectUserHubRoleObserverDesc.
  ///
  /// In en, this message translates to:
  /// **'Read-only access to board, tasks and project resources.'**
  String get projectUserHubRoleObserverDesc;

  /// No description provided for @projectUserHubLeaveProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Project'**
  String get projectUserHubLeaveProjectTitle;

  /// No description provided for @projectUserHubLeaveProjectSharedDesc.
  ///
  /// In en, this message translates to:
  /// **'You are a member of this workspace. After leaving explicit membership, you will retain access to the project as a shared workspace project.'**
  String get projectUserHubLeaveProjectSharedDesc;

  /// No description provided for @projectUserHubLeaveProjectPrivateDesc.
  ///
  /// In en, this message translates to:
  /// **'Leaving will revoke your direct access to this private project.'**
  String get projectUserHubLeaveProjectPrivateDesc;

  /// No description provided for @projectUserHubLeaveProjectButton.
  ///
  /// In en, this message translates to:
  /// **'Leave this project'**
  String get projectUserHubLeaveProjectButton;

  /// No description provided for @projectUserHubLeaveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this project?'**
  String get projectUserHubLeaveConfirmTitle;

  /// No description provided for @projectUserHubLeaveConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Your explicit membership will be revoked. In a private project you will lose access.'**
  String get projectUserHubLeaveConfirmContent;

  /// No description provided for @projectUserHubLeaveConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Yes, leave project'**
  String get projectUserHubLeaveConfirmAction;

  /// No description provided for @projectUserHubPreferencesHeader.
  ///
  /// In en, this message translates to:
  /// **'Project Personalization'**
  String get projectUserHubPreferencesHeader;

  /// No description provided for @projectUserHubPreferencesDesc.
  ///
  /// In en, this message translates to:
  /// **'Customize how this project appears on your account.'**
  String get projectUserHubPreferencesDesc;

  /// No description provided for @projectUserHubPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Pin to favorites'**
  String get projectUserHubPinLabel;

  /// No description provided for @projectUserHubPinDesc.
  ///
  /// In en, this message translates to:
  /// **'The project will be displayed at the very top of the project tree.'**
  String get projectUserHubPinDesc;

  /// No description provided for @projectUserHubHideLabel.
  ///
  /// In en, this message translates to:
  /// **'Hide project from sidebar menu'**
  String get projectUserHubHideLabel;

  /// No description provided for @projectUserHubHideDesc.
  ///
  /// In en, this message translates to:
  /// **'The project will not be visible in the sidebar list (you can still search for it).'**
  String get projectUserHubHideDesc;

  /// No description provided for @projectUserHubPreferenceSaved.
  ///
  /// In en, this message translates to:
  /// **'Project preferences updated successfully.'**
  String get projectUserHubPreferenceSaved;

  /// No description provided for @projectUserHubLeaveSharedSuccessNotice.
  ///
  /// In en, this message translates to:
  /// **'Left explicit project membership. As a workspace member you still have access to this project.'**
  String get projectUserHubLeaveSharedSuccessNotice;

  /// No description provided for @projectUserHubLeavePrivateSuccessNotice.
  ///
  /// In en, this message translates to:
  /// **'Successfully left the project.'**
  String get projectUserHubLeavePrivateSuccessNotice;

  /// No description provided for @tasksListClearValue.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get tasksListClearValue;

  /// No description provided for @tasksListCustomStatus.
  ///
  /// In en, this message translates to:
  /// **'Custom status'**
  String get tasksListCustomStatus;

  /// No description provided for @tasksListMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get tasksListMilestone;

  /// No description provided for @tasksListNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get tasksListNoDueDate;

  /// No description provided for @tasksListDefaultColor.
  ///
  /// In en, this message translates to:
  /// **'Default color'**
  String get tasksListDefaultColor;

  /// No description provided for @tasksListNoIcon.
  ///
  /// In en, this message translates to:
  /// **'No icon'**
  String get tasksListNoIcon;

  /// No description provided for @tasksListMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get tasksListMoveUp;

  /// No description provided for @tasksListMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get tasksListMoveDown;

  /// No description provided for @tasksListRemoveOption.
  ///
  /// In en, this message translates to:
  /// **'Remove option'**
  String get tasksListRemoveOption;

  /// No description provided for @tasksListOptionNameHint.
  ///
  /// In en, this message translates to:
  /// **'Option name (e.g. High, Urgent)...'**
  String get tasksListOptionNameHint;

  /// No description provided for @tasksListAddOptionButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get tasksListAddOptionButton;

  /// No description provided for @tasksListCollaborators.
  ///
  /// In en, this message translates to:
  /// **'Collaborators'**
  String get tasksListCollaborators;

  /// No description provided for @tasksListWatchers.
  ///
  /// In en, this message translates to:
  /// **'Watchers'**
  String get tasksListWatchers;

  /// No description provided for @tasksListCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get tasksListCreated;

  /// No description provided for @tasksListTaskType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tasksListTaskType;

  /// No description provided for @tasksListSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get tasksListSize;

  /// No description provided for @tasksListComplexity.
  ///
  /// In en, this message translates to:
  /// **'Complexity'**
  String get tasksListComplexity;

  /// No description provided for @tasksListRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get tasksListRisk;

  /// No description provided for @tasksListBusinessValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get tasksListBusinessValue;

  /// No description provided for @tasksListEstimatedMinutes.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get tasksListEstimatedMinutes;

  /// No description provided for @tasksListActualMinutes.
  ///
  /// In en, this message translates to:
  /// **'Actual time'**
  String get tasksListActualMinutes;

  /// No description provided for @tasksListResizeColumnTooltip.
  ///
  /// In en, this message translates to:
  /// **'Resize column: {name}'**
  String tasksListResizeColumnTooltip(String name);

  /// No description provided for @tasksListColumnsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize columns'**
  String get tasksListColumnsTitle;

  /// No description provided for @tasksListColumnsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage column visibility and order in the list'**
  String get tasksListColumnsSubtitle;

  /// No description provided for @tasksListColumnsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search columns...'**
  String get tasksListColumnsSearchHint;

  /// No description provided for @tasksListColumnsRequiredBadge.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get tasksListColumnsRequiredBadge;

  /// No description provided for @tasksListColumnsRequiredTooltip.
  ///
  /// In en, this message translates to:
  /// **'This column is required by the project administrator'**
  String get tasksListColumnsRequiredTooltip;

  /// No description provided for @tasksListColumnsDisabledBadge.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get tasksListColumnsDisabledBadge;

  /// No description provided for @tasksListColumnsDisabledTooltip.
  ///
  /// In en, this message translates to:
  /// **'Disabled by the project administrator'**
  String get tasksListColumnsDisabledTooltip;

  /// No description provided for @tasksListColumnsResetButton.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get tasksListColumnsResetButton;

  /// No description provided for @tasksListColumnsResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Default column layout restored'**
  String get tasksListColumnsResetSuccess;

  /// No description provided for @tasksListColumnsSaveAsViewButton.
  ///
  /// In en, this message translates to:
  /// **'Save as new view'**
  String get tasksListColumnsSaveAsViewButton;

  /// No description provided for @tasksListColumnsDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksListColumnsDoneButton;

  /// No description provided for @tasksListMySettingsButton.
  ///
  /// In en, this message translates to:
  /// **'My settings'**
  String get tasksListMySettingsButton;

  /// No description provided for @tasksListAdminPanelButton.
  ///
  /// In en, this message translates to:
  /// **'Admin panel'**
  String get tasksListAdminPanelButton;

  /// No description provided for @tasksListColumnsScopeUser.
  ///
  /// In en, this message translates to:
  /// **'My settings'**
  String get tasksListColumnsScopeUser;

  /// No description provided for @tasksListColumnsScopeProject.
  ///
  /// In en, this message translates to:
  /// **'Project defaults (Admin)'**
  String get tasksListColumnsScopeProject;

  /// No description provided for @tasksListSaveProjectDefaults.
  ///
  /// In en, this message translates to:
  /// **'Save as project defaults'**
  String get tasksListSaveProjectDefaults;

  /// No description provided for @tasksListProjectDefaultsSaved.
  ///
  /// In en, this message translates to:
  /// **'Project default columns updated successfully'**
  String get tasksListProjectDefaultsSaved;

  /// No description provided for @tasksListManageWorkflowButton.
  ///
  /// In en, this message translates to:
  /// **'Manage workflow & statuses...'**
  String get tasksListManageWorkflowButton;

  /// No description provided for @tasksListManageCustomFieldsButton.
  ///
  /// In en, this message translates to:
  /// **'Project custom fields...'**
  String get tasksListManageCustomFieldsButton;

  /// No description provided for @tasksListSortAscending.
  ///
  /// In en, this message translates to:
  /// **'Sort ascending'**
  String get tasksListSortAscending;

  /// No description provided for @tasksListSortDescending.
  ///
  /// In en, this message translates to:
  /// **'Sort descending'**
  String get tasksListSortDescending;

  /// No description provided for @tasksListSortClear.
  ///
  /// In en, this message translates to:
  /// **'Clear sorting'**
  String get tasksListSortClear;

  /// No description provided for @tasksListSavingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Saving preferences...'**
  String get tasksListSavingPreferences;

  /// No description provided for @tasksListPreferencesConflict.
  ///
  /// In en, this message translates to:
  /// **'Column layout was updated in another session. View refreshed.'**
  String get tasksListPreferencesConflict;

  /// No description provided for @tasksListSaveViewDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'New saved view'**
  String get tasksListSaveViewDialogTitle;

  /// No description provided for @tasksListSaveViewDialogHint.
  ///
  /// In en, this message translates to:
  /// **'View name...'**
  String get tasksListSaveViewDialogHint;

  /// No description provided for @tasksListDragToReorderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hold and drag to reorder'**
  String get tasksListDragToReorderTooltip;

  /// No description provided for @tasksListTaskCopySuffix.
  ///
  /// In en, this message translates to:
  /// **'(copy)'**
  String get tasksListTaskCopySuffix;

  /// No description provided for @storageMyFiles.
  ///
  /// In en, this message translates to:
  /// **'My files'**
  String get storageMyFiles;

  /// No description provided for @storageSharedWithMe.
  ///
  /// In en, this message translates to:
  /// **'Shared with me'**
  String get storageSharedWithMe;

  /// No description provided for @storageRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get storageRecent;

  /// No description provided for @storageFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get storageFavorites;

  /// No description provided for @storageTrash.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get storageTrash;

  /// No description provided for @storageNewFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get storageNewFolder;

  /// No description provided for @storageUploadFiles.
  ///
  /// In en, this message translates to:
  /// **'Upload files'**
  String get storageUploadFiles;

  /// No description provided for @storageSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search files and folders...'**
  String get storageSearchHint;

  /// No description provided for @storageAllFiles.
  ///
  /// In en, this message translates to:
  /// **'All files'**
  String get storageAllFiles;

  /// No description provided for @storageSortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get storageSortNameAsc;

  /// No description provided for @storageSortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get storageSortNameDesc;

  /// No description provided for @storageSortDateDesc.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get storageSortDateDesc;

  /// No description provided for @storageSortDateAsc.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get storageSortDateAsc;

  /// No description provided for @storageSortSizeDesc.
  ///
  /// In en, this message translates to:
  /// **'Largest'**
  String get storageSortSizeDesc;

  /// No description provided for @storageSortSizeAsc.
  ///
  /// In en, this message translates to:
  /// **'Smallest'**
  String get storageSortSizeAsc;

  /// No description provided for @storageSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item selected} other{{count} items selected}}'**
  String storageSelectedCount(int count);

  /// No description provided for @storageDownloadZip.
  ///
  /// In en, this message translates to:
  /// **'Download ZIP'**
  String get storageDownloadZip;

  /// No description provided for @storageDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get storageDeleteSelected;

  /// No description provided for @storageRestoreSelected.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get storageRestoreSelected;

  /// No description provided for @storageClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get storageClearSelection;

  /// No description provided for @storageEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Directory is empty'**
  String get storageEmptyTitle;

  /// No description provided for @storageEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No files or folders in this view.'**
  String get storageEmptySubtitle;

  /// No description provided for @storageUploadQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload queue'**
  String get storageUploadQueueTitle;

  /// No description provided for @storageUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'File uploaded successfully'**
  String get storageUploadSuccess;

  /// No description provided for @storageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload file'**
  String get storageUploadFailed;

  /// No description provided for @storageDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'File details'**
  String get storageDetailsTitle;

  /// No description provided for @storagePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'File preview'**
  String get storagePreviewTitle;

  /// No description provided for @storageFileSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get storageFileSize;

  /// No description provided for @storageFileCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get storageFileCreatedAt;

  /// No description provided for @storageFileUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get storageFileUpdatedAt;

  /// No description provided for @storageFileVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get storageFileVersion;

  /// No description provided for @storageCreateFolderDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new folder'**
  String get storageCreateFolderDialogTitle;

  /// No description provided for @storageCreateFolderDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Folder name...'**
  String get storageCreateFolderDialogHint;

  /// No description provided for @storageCreateFolderButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get storageCreateFolderButton;

  /// No description provided for @storageRenameFolderDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get storageRenameFolderDialogTitle;

  /// No description provided for @storageDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get storageDeleteConfirmTitle;

  /// No description provided for @storageDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to move selected items to trash?'**
  String get storageDeleteConfirmMessage;

  /// No description provided for @storageShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share: {fileName}'**
  String storageShareTitle(String fileName);

  /// No description provided for @storageActiveShares.
  ///
  /// In en, this message translates to:
  /// **'Active shares'**
  String get storageActiveShares;

  /// No description provided for @storageNoActiveShares.
  ///
  /// In en, this message translates to:
  /// **'No active shares besides owner.'**
  String get storageNoActiveShares;

  /// No description provided for @storageShareUserLabel.
  ///
  /// In en, this message translates to:
  /// **'User: {identifier}'**
  String storageShareUserLabel(String identifier);

  /// No description provided for @storageShareWorkspaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace: {identifier}'**
  String storageShareWorkspaceLabel(String identifier);

  /// No description provided for @storageShareProjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Project: {identifier}'**
  String storageShareProjectLabel(String identifier);

  /// No description provided for @storageUserInputHint.
  ///
  /// In en, this message translates to:
  /// **'User ID / email'**
  String get storageUserInputHint;

  /// No description provided for @storageUserSearchWorkspaceRequired.
  ///
  /// In en, this message translates to:
  /// **'Ready directory search is available for workspace or project files.'**
  String get storageUserSearchWorkspaceRequired;

  /// No description provided for @storageUserSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No users with an active Core account were found.'**
  String get storageUserSearchNoResults;

  /// No description provided for @storageAddShareButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get storageAddShareButton;

  /// No description provided for @storagePublicLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Public link'**
  String get storagePublicLinkTitle;

  /// No description provided for @storagePublicLinkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allows access without login with selected permissions'**
  String get storagePublicLinkSubtitle;

  /// No description provided for @storagePublicSharePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared file'**
  String get storagePublicSharePageTitle;

  /// No description provided for @storagePublicSharePageDescription.
  ///
  /// In en, this message translates to:
  /// **'Download the file using a secure link. If the owner set a password, enter it below.'**
  String get storagePublicSharePageDescription;

  /// No description provided for @storagePublicSharePassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get storagePublicSharePassword;

  /// No description provided for @storagePublicSharePasswordOptional.
  ///
  /// In en, this message translates to:
  /// **'Leave empty if the link does not require a password'**
  String get storagePublicSharePasswordOptional;

  /// No description provided for @storageShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get storageShowPassword;

  /// No description provided for @storageHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get storageHidePassword;

  /// No description provided for @storagePublicShareDownload.
  ///
  /// In en, this message translates to:
  /// **'Download file'**
  String get storagePublicShareDownload;

  /// No description provided for @storagePublicShareDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Download started: {fileName}'**
  String storagePublicShareDownloadStarted(String fileName);

  /// No description provided for @storagePublicLinkNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiration date'**
  String get storagePublicLinkNoExpiry;

  /// No description provided for @storagePublicLinkExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String storagePublicLinkExpires(String date);

  /// No description provided for @storageCopyPublicLink.
  ///
  /// In en, this message translates to:
  /// **'Copy public link'**
  String get storageCopyPublicLink;

  /// No description provided for @storageGenerateLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Generate link'**
  String get storageGenerateLinkButton;

  /// No description provided for @storageLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get storageLinkCopied;

  /// No description provided for @storageAccessReader.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get storageAccessReader;

  /// No description provided for @storageAccessCommenter.
  ///
  /// In en, this message translates to:
  /// **'Commenter'**
  String get storageAccessCommenter;

  /// No description provided for @storageAccessEditor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get storageAccessEditor;

  /// No description provided for @storageAccessOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get storageAccessOwner;

  /// No description provided for @storageShareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get storageShareAction;

  /// No description provided for @storageAddFavoriteAction.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get storageAddFavoriteAction;

  /// No description provided for @storageRemoveFavoriteAction.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get storageRemoveFavoriteAction;

  /// No description provided for @storageDownloadAction.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get storageDownloadAction;

  /// No description provided for @storageDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get storageDeleteAction;

  /// No description provided for @storageOpenOfficeAction.
  ///
  /// In en, this message translates to:
  /// **'Open document'**
  String get storageOpenOfficeAction;

  /// No description provided for @storageOfficeEditMode.
  ///
  /// In en, this message translates to:
  /// **'Edit mode'**
  String get storageOfficeEditMode;

  /// No description provided for @storageOfficeViewMode.
  ///
  /// In en, this message translates to:
  /// **'View only'**
  String get storageOfficeViewMode;

  /// No description provided for @storageOfficeActive.
  ///
  /// In en, this message translates to:
  /// **'OnlyOffice Document Server session active'**
  String get storageOfficeActive;

  /// No description provided for @storageOfficeHostLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading the OnlyOffice editor…'**
  String get storageOfficeHostLoading;

  /// No description provided for @storageOfficeHostFailure.
  ///
  /// In en, this message translates to:
  /// **'The embedded OnlyOffice editor could not be loaded.'**
  String get storageOfficeHostFailure;

  /// No description provided for @storageOfficeDownloadFailure.
  ///
  /// In en, this message translates to:
  /// **'The document download could not be prepared. Check the OnlyOffice connection and try again.'**
  String get storageOfficeDownloadFailure;

  /// No description provided for @storageOfficeCloseUnconfirmed.
  ///
  /// In en, this message translates to:
  /// **'The editor did not confirm a safe close. Closing anyway may lose unsaved changes. Close the document?'**
  String get storageOfficeCloseUnconfirmed;

  /// No description provided for @storageOfficeSessionFailure.
  ///
  /// In en, this message translates to:
  /// **'The OnlyOffice editor session could not be started'**
  String get storageOfficeSessionFailure;

  /// No description provided for @storageCloseOffice.
  ///
  /// In en, this message translates to:
  /// **'Close document'**
  String get storageCloseOffice;

  /// No description provided for @storageOfficePrintAction.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get storageOfficePrintAction;

  /// No description provided for @storageOfficePrinting.
  ///
  /// In en, this message translates to:
  /// **'Preparing print…'**
  String get storageOfficePrinting;

  /// No description provided for @storageOfficePrintFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to print document.'**
  String get storageOfficePrintFailure;

  /// No description provided for @storageOfficeDownloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Downloaded file: {fileName} to Downloads'**
  String storageOfficeDownloadSuccess(String fileName);

  /// No description provided for @storageOfficeSaveCopyAction.
  ///
  /// In en, this message translates to:
  /// **'Save copy in Storage'**
  String get storageOfficeSaveCopyAction;

  /// No description provided for @storageOfficeSavingCopy.
  ///
  /// In en, this message translates to:
  /// **'Saving copy in Storage…'**
  String get storageOfficeSavingCopy;

  /// No description provided for @storageOfficeSaveCopySuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved copy ”{fileName}” in Storage'**
  String storageOfficeSaveCopySuccess(String fileName);

  /// No description provided for @storageOfficeSaveCopyFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to save document copy in Storage.'**
  String get storageOfficeSaveCopyFailure;

  /// No description provided for @storageSortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get storageSortTooltip;

  /// No description provided for @storageListViewTooltip.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get storageListViewTooltip;

  /// No description provided for @storageGridViewTooltip.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get storageGridViewTooltip;

  /// No description provided for @storageMoreOptionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get storageMoreOptionsTooltip;

  /// No description provided for @storageClearCompletedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear completed'**
  String get storageClearCompletedTooltip;

  /// No description provided for @storageCancelUploadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Cancel upload'**
  String get storageCancelUploadTooltip;

  /// No description provided for @storageRetryUploadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Retry transfer'**
  String get storageRetryUploadTooltip;

  /// No description provided for @storageErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get storageErrorTitle;

  /// No description provided for @storageForbiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get storageForbiddenTitle;

  /// No description provided for @storagePreviewError.
  ///
  /// In en, this message translates to:
  /// **'Preview error: {message}'**
  String storagePreviewError(String message);

  /// No description provided for @storageImageLoadError.
  ///
  /// In en, this message translates to:
  /// **'The image could not be loaded.'**
  String get storageImageLoadError;

  /// No description provided for @storageOfficeDescription.
  ///
  /// In en, this message translates to:
  /// **'Office document ready to open in OnlyOffice.'**
  String get storageOfficeDescription;

  /// No description provided for @storagePdfDescription.
  ///
  /// In en, this message translates to:
  /// **'The PDF can be opened in the secure system preview.'**
  String get storagePdfDescription;

  /// No description provided for @storageVideoDescription.
  ///
  /// In en, this message translates to:
  /// **'The video can be played in the system preview.'**
  String get storageVideoDescription;

  /// No description provided for @storageAudioDescription.
  ///
  /// In en, this message translates to:
  /// **'The recording can be played in the system preview.'**
  String get storageAudioDescription;

  /// No description provided for @storageTextDescription.
  ///
  /// In en, this message translates to:
  /// **'Text file or source code.'**
  String get storageTextDescription;

  /// No description provided for @storageUnsupportedDescription.
  ///
  /// In en, this message translates to:
  /// **'A direct preview is not available for this format.'**
  String get storageUnsupportedDescription;

  /// No description provided for @storageOpenPdfPreview.
  ///
  /// In en, this message translates to:
  /// **'Open PDF preview'**
  String get storageOpenPdfPreview;

  /// No description provided for @storagePlayVideo.
  ///
  /// In en, this message translates to:
  /// **'Play video'**
  String get storagePlayVideo;

  /// No description provided for @storagePlayAudio.
  ///
  /// In en, this message translates to:
  /// **'Play audio'**
  String get storagePlayAudio;

  /// No description provided for @storageOpenText.
  ///
  /// In en, this message translates to:
  /// **'Open content'**
  String get storageOpenText;

  /// No description provided for @storageRemoveShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove permission'**
  String get storageRemoveShareTooltip;

  /// No description provided for @storageShareAccessLabel.
  ///
  /// In en, this message translates to:
  /// **'Access: {access}'**
  String storageShareAccessLabel(String access);

  /// No description provided for @storageFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get storageFolderTitle;

  /// No description provided for @storageWorkspaceFilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace files'**
  String get storageWorkspaceFilesTitle;

  /// No description provided for @storageProjectFilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Project files'**
  String get storageProjectFilesTitle;

  /// No description provided for @storageAttachmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get storageAttachmentsTitle;

  /// No description provided for @storageFilesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file} other{{count} files}}'**
  String storageFilesCount(int count);

  /// No description provided for @storageFoldersTitle.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get storageFoldersTitle;

  /// No description provided for @storageItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String storageItemsCount(int count);

  /// No description provided for @storageVersionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Version history'**
  String get storageVersionsTitle;

  /// No description provided for @storageVersionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved file versions.'**
  String get storageVersionsEmpty;

  /// No description provided for @storageVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String storageVersionLabel(int version);

  /// No description provided for @storageUploadFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The file exceeds the 20 MB size limit.'**
  String get storageUploadFileTooLarge;

  /// No description provided for @storageUploadCancelledByUser.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by user.'**
  String get storageUploadCancelledByUser;

  /// No description provided for @storageUploadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Upload cancelled.'**
  String get storageUploadCancelled;

  /// No description provided for @storageUploadUnsupportedScope.
  ///
  /// In en, this message translates to:
  /// **'Files cannot be uploaded in this view.'**
  String get storageUploadUnsupportedScope;

  /// No description provided for @storageUploadTicketReservationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reserve an upload ticket.'**
  String get storageUploadTicketReservationFailed;

  /// No description provided for @storageUploadTransferFailed.
  ///
  /// In en, this message translates to:
  /// **'Data transfer failed.'**
  String get storageUploadTransferFailed;

  /// No description provided for @storageUploadCompletionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the file upload.'**
  String get storageUploadCompletionFailed;

  /// No description provided for @storageUploadPlacementFailed.
  ///
  /// In en, this message translates to:
  /// **'The file was uploaded but could not be added to the selected folder.'**
  String get storageUploadPlacementFailed;

  /// No description provided for @storagePartialDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Some items could not be deleted.'**
  String get storagePartialDeleteFailed;

  /// No description provided for @storageDeleteSelectedFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the selected items.'**
  String get storageDeleteSelectedFailed;

  /// No description provided for @globalChatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No conversations'**
  String get globalChatEmptyTitle;

  /// No description provided for @globalChatEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your active conversations will appear here.'**
  String get globalChatEmptyMessage;

  /// No description provided for @globalChatLoadFailureTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load conversations'**
  String get globalChatLoadFailureTitle;

  /// No description provided for @globalChatConversationFallback.
  ///
  /// In en, this message translates to:
  /// **'Conversation {identifier}'**
  String globalChatConversationFallback(String identifier);

  /// No description provided for @globalChatGroupProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get globalChatGroupProject;

  /// No description provided for @globalChatGroupWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get globalChatGroupWorkspace;

  /// No description provided for @globalChatGroupPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get globalChatGroupPrivate;

  /// No description provided for @globalChatBackToConversations.
  ///
  /// In en, this message translates to:
  /// **'Back to conversations'**
  String get globalChatBackToConversations;

  /// No description provided for @globalChatOpenFullView.
  ///
  /// In en, this message translates to:
  /// **'Open full view'**
  String get globalChatOpenFullView;

  /// No description provided for @globalChatComposerHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message…'**
  String get globalChatComposerHint;

  /// No description provided for @globalChatSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get globalChatSendMessage;

  /// No description provided for @globalChatDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Message deleted'**
  String get globalChatDeletedMessage;

  /// No description provided for @chatComposerPlainMode.
  ///
  /// In en, this message translates to:
  /// **'Plain text'**
  String get chatComposerPlainMode;

  /// No description provided for @chatComposerRichMode.
  ///
  /// In en, this message translates to:
  /// **'Rich text'**
  String get chatComposerRichMode;

  /// No description provided for @chatComposerReplyTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to: {message}'**
  String chatComposerReplyTo(String message);

  /// No description provided for @chatComposerCancelReply.
  ///
  /// In en, this message translates to:
  /// **'Cancel reply'**
  String get chatComposerCancelReply;

  /// No description provided for @chatComposerReplyAction.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get chatComposerReplyAction;

  /// No description provided for @chatThreadTitle.
  ///
  /// In en, this message translates to:
  /// **'Thread'**
  String get chatThreadTitle;

  /// No description provided for @chatThreadClose.
  ///
  /// In en, this message translates to:
  /// **'Close thread'**
  String get chatThreadClose;

  /// No description provided for @chatThreadOpen.
  ///
  /// In en, this message translates to:
  /// **'Open thread'**
  String get chatThreadOpen;

  /// No description provided for @globalNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get globalNotificationsTitle;

  /// No description provided for @globalNotificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get globalNotificationsEmptyTitle;

  /// No description provided for @globalNotificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Information about your work will appear here.'**
  String get globalNotificationsEmptyMessage;

  /// No description provided for @globalNotificationsSessionRequired.
  ///
  /// In en, this message translates to:
  /// **'Your session needs refreshing'**
  String get globalNotificationsSessionRequired;

  /// No description provided for @globalNotificationsAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get globalNotificationsAccessDenied;

  /// No description provided for @globalNotificationsLoadFailureTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load notifications'**
  String get globalNotificationsLoadFailureTitle;

  /// No description provided for @globalNotificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get globalNotificationsMarkAllRead;

  /// No description provided for @globalNotificationsRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh notifications'**
  String get globalNotificationsRefreshFailed;

  /// No description provided for @globalNotificationsConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to live notifications…'**
  String get globalNotificationsConnecting;

  /// No description provided for @globalNotificationsReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting to live notifications…'**
  String get globalNotificationsReconnecting;

  /// No description provided for @globalNotificationsOffline.
  ///
  /// In en, this message translates to:
  /// **'Live notifications are offline'**
  String get globalNotificationsOffline;

  /// No description provided for @globalChatConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to live chat…'**
  String get globalChatConnecting;

  /// No description provided for @globalChatReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting to live chat…'**
  String get globalChatReconnecting;

  /// No description provided for @globalChatOffline.
  ///
  /// In en, this message translates to:
  /// **'Live chat is offline'**
  String get globalChatOffline;

  /// No description provided for @globalNotificationsGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get globalNotificationsGroups;

  /// No description provided for @globalNotificationsItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get globalNotificationsItems;

  /// No description provided for @globalNotificationsUnreadOnly.
  ///
  /// In en, this message translates to:
  /// **'Unread only'**
  String get globalNotificationsUnreadOnly;

  /// No description provided for @globalNotificationsAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get globalNotificationsAllCategories;

  /// No description provided for @globalNotificationsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get globalNotificationsLoadMore;

  /// No description provided for @globalNotificationsGroupActions.
  ///
  /// In en, this message translates to:
  /// **'Group actions'**
  String get globalNotificationsGroupActions;

  /// No description provided for @globalNotificationsMarkGroupRead.
  ///
  /// In en, this message translates to:
  /// **'Mark group as read'**
  String get globalNotificationsMarkGroupRead;

  /// No description provided for @globalNotificationsPin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get globalNotificationsPin;

  /// No description provided for @globalNotificationsUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get globalNotificationsUnpin;

  /// No description provided for @globalNotificationsArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get globalNotificationsArchive;

  /// No description provided for @globalNotificationsReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get globalNotificationsReply;

  /// No description provided for @globalNotificationsReplyTitle.
  ///
  /// In en, this message translates to:
  /// **'Reply in Chat'**
  String get globalNotificationsReplyTitle;

  /// No description provided for @globalNotificationsReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Write a reply…'**
  String get globalNotificationsReplyHint;

  /// No description provided for @globalNotificationsReplyPlainMode.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get globalNotificationsReplyPlainMode;

  /// No description provided for @globalNotificationsReplyRichMode.
  ///
  /// In en, this message translates to:
  /// **'Rich text'**
  String get globalNotificationsReplyRichMode;

  /// No description provided for @globalNotificationsReplySend.
  ///
  /// In en, this message translates to:
  /// **'Send reply'**
  String get globalNotificationsReplySend;

  /// No description provided for @globalNotificationsReplyAccessRevoked.
  ///
  /// In en, this message translates to:
  /// **'Access to this conversation was removed. Your reply draft was cleared.'**
  String get globalNotificationsReplyAccessRevoked;

  /// No description provided for @globalNotificationsReplyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send reply'**
  String get globalNotificationsReplyFailed;

  /// No description provided for @globalNotificationsUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread notifications'**
  String globalNotificationsUnreadCount(int count);

  /// No description provided for @notificationPreferencesOpen.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get notificationPreferencesOpen;

  /// No description provided for @notificationPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get notificationPreferencesTitle;

  /// No description provided for @notificationPreferencesDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Email delivery'**
  String get notificationPreferencesDeliveryTitle;

  /// No description provided for @notificationPreferencesDeliveryDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how each type of notification is delivered to your email.'**
  String get notificationPreferencesDeliveryDescription;

  /// No description provided for @notificationPreferencesDeliveryMode.
  ///
  /// In en, this message translates to:
  /// **'Delivery mode'**
  String get notificationPreferencesDeliveryMode;

  /// No description provided for @notificationPreferencesCategoryInvitation.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get notificationPreferencesCategoryInvitation;

  /// No description provided for @notificationPreferencesCategoryMembership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get notificationPreferencesCategoryMembership;

  /// No description provided for @notificationPreferencesCategoryWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Workspaces'**
  String get notificationPreferencesCategoryWorkspace;

  /// No description provided for @notificationPreferencesCategoryProject.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get notificationPreferencesCategoryProject;

  /// No description provided for @notificationPreferencesCategoryTask.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get notificationPreferencesCategoryTask;

  /// No description provided for @notificationPreferencesCategoryComment.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get notificationPreferencesCategoryComment;

  /// No description provided for @notificationPreferencesCategoryChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get notificationPreferencesCategoryChat;

  /// No description provided for @notificationPreferencesCategoryStorage.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get notificationPreferencesCategoryStorage;

  /// No description provided for @notificationPreferencesCategorySystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notificationPreferencesCategorySystem;

  /// No description provided for @notificationPreferencesModeNone.
  ///
  /// In en, this message translates to:
  /// **'Do not send'**
  String get notificationPreferencesModeNone;

  /// No description provided for @notificationPreferencesModeImmediate.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get notificationPreferencesModeImmediate;

  /// No description provided for @notificationPreferencesModeDailyDigest.
  ///
  /// In en, this message translates to:
  /// **'Daily digest'**
  String get notificationPreferencesModeDailyDigest;

  /// No description provided for @notificationPreferencesModeDigest.
  ///
  /// In en, this message translates to:
  /// **'Digest'**
  String get notificationPreferencesModeDigest;

  /// No description provided for @notificationPreferencesStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'File notifications'**
  String get notificationPreferencesStorageTitle;

  /// No description provided for @notificationPreferencesStorageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose delivery for events related to files you can access.'**
  String get notificationPreferencesStorageDescription;

  /// No description provided for @notificationPreferencesStorageMode.
  ///
  /// In en, this message translates to:
  /// **'File delivery mode'**
  String get notificationPreferencesStorageMode;

  /// No description provided for @notificationPreferencesStorageInherited.
  ///
  /// In en, this message translates to:
  /// **'The current setting is inherited from the default policy.'**
  String get notificationPreferencesStorageInherited;

  /// No description provided for @notificationPreferencesStorageImmediate.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get notificationPreferencesStorageImmediate;

  /// No description provided for @notificationPreferencesStorageDigest.
  ///
  /// In en, this message translates to:
  /// **'Digest'**
  String get notificationPreferencesStorageDigest;

  /// No description provided for @notificationPreferencesStorageMentionsOnly.
  ///
  /// In en, this message translates to:
  /// **'Mentions only'**
  String get notificationPreferencesStorageMentionsOnly;

  /// No description provided for @notificationPreferencesStorageDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get notificationPreferencesStorageDisabled;

  /// No description provided for @notificationPreferencesDigestTitle.
  ///
  /// In en, this message translates to:
  /// **'Digest preview'**
  String get notificationPreferencesDigestTitle;

  /// No description provided for @notificationPreferencesDigestDescription.
  ///
  /// In en, this message translates to:
  /// **'A read-only summary of currently visible notification groups.'**
  String get notificationPreferencesDigestDescription;

  /// No description provided for @notificationPreferencesDigestEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no notifications in the digest.'**
  String get notificationPreferencesDigestEmpty;

  /// No description provided for @notificationPreferencesDigestSummary.
  ///
  /// In en, this message translates to:
  /// **'Digest contains {count} notification groups'**
  String notificationPreferencesDigestSummary(int count);

  /// No description provided for @notificationPreferencesDigestCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notifications'**
  String notificationPreferencesDigestCount(int count);

  /// No description provided for @chatNotificationSettingsGlobalTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat notifications'**
  String get chatNotificationSettingsGlobalTitle;

  /// No description provided for @chatNotificationSettingsGlobalDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the channels used to deliver notifications from global chat.'**
  String get chatNotificationSettingsGlobalDescription;

  /// No description provided for @chatNotificationSettingsChannelInApp.
  ///
  /// In en, this message translates to:
  /// **'In app'**
  String get chatNotificationSettingsChannelInApp;

  /// No description provided for @chatNotificationSettingsChannelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get chatNotificationSettingsChannelEmail;

  /// No description provided for @chatNotificationSettingsChannelPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get chatNotificationSettingsChannelPush;

  /// No description provided for @chatNotificationSettingsChannelDigest.
  ///
  /// In en, this message translates to:
  /// **'Digest'**
  String get chatNotificationSettingsChannelDigest;

  /// No description provided for @chatConversationNotificationSettingsOpen.
  ///
  /// In en, this message translates to:
  /// **'Conversation notification settings'**
  String get chatConversationNotificationSettingsOpen;

  /// No description provided for @chatConversationNotificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation notifications'**
  String get chatConversationNotificationSettingsTitle;

  /// No description provided for @chatConversationNotificationSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Set how you receive notifications from this conversation only.'**
  String get chatConversationNotificationSettingsDescription;

  /// No description provided for @chatConversationNotificationModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification mode'**
  String get chatConversationNotificationModeLabel;

  /// No description provided for @chatConversationNotificationModeAll.
  ///
  /// In en, this message translates to:
  /// **'All messages'**
  String get chatConversationNotificationModeAll;

  /// No description provided for @chatConversationNotificationModeMentionsOnly.
  ///
  /// In en, this message translates to:
  /// **'Mentions only'**
  String get chatConversationNotificationModeMentionsOnly;

  /// No description provided for @chatConversationNotificationModeMuted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get chatConversationNotificationModeMuted;

  /// No description provided for @chatConversationNotificationModeHighOnly.
  ///
  /// In en, this message translates to:
  /// **'High priority only'**
  String get chatConversationNotificationModeHighOnly;

  /// No description provided for @resourceChatFileAction.
  ///
  /// In en, this message translates to:
  /// **'File chat'**
  String get resourceChatFileAction;

  /// No description provided for @resourceChatFileDescription.
  ///
  /// In en, this message translates to:
  /// **'Open the authorized conversation for this shared file.'**
  String get resourceChatFileDescription;

  /// No description provided for @resourceChatFileHeader.
  ///
  /// In en, this message translates to:
  /// **'File: {fileName} · Owner: {ownerUserId} · Access: {accessLevel}'**
  String resourceChatFileHeader(
    String fileName,
    String ownerUserId,
    String accessLevel,
  );

  /// No description provided for @chatDiscussionTitle.
  ///
  /// In en, this message translates to:
  /// **'Named discussion'**
  String get chatDiscussionTitle;

  /// No description provided for @chatDiscussionNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Discussion name'**
  String get chatDiscussionNameLabel;

  /// No description provided for @chatDiscussionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open discussion'**
  String get chatDiscussionOpen;

  /// No description provided for @chatDiscussionReady.
  ///
  /// In en, this message translates to:
  /// **'Discussion ready: {name}'**
  String chatDiscussionReady(String name);

  /// No description provided for @chatMessageActionsOpen.
  ///
  /// In en, this message translates to:
  /// **'Message actions'**
  String get chatMessageActionsOpen;

  /// No description provided for @chatMessageEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit message'**
  String get chatMessageEdit;

  /// No description provided for @chatMessageDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get chatMessageDelete;

  /// No description provided for @chatMessageRevisions.
  ///
  /// In en, this message translates to:
  /// **'Edit history'**
  String get chatMessageRevisions;

  /// No description provided for @chatMessageEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit message'**
  String get chatMessageEditTitle;

  /// No description provided for @chatMessageEditLabel.
  ///
  /// In en, this message translates to:
  /// **'Message text'**
  String get chatMessageEditLabel;

  /// No description provided for @chatMessageCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chatMessageCancel;

  /// No description provided for @chatMessageSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get chatMessageSave;

  /// No description provided for @chatMessageClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get chatMessageClose;

  /// No description provided for @chatMessageRevisionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit history'**
  String get chatMessageRevisionsTitle;

  /// No description provided for @chatMessageRevisionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'This message has no earlier versions.'**
  String get chatMessageRevisionsEmpty;

  /// No description provided for @chatMessageRevisionVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version} → {newVersion}'**
  String chatMessageRevisionVersion(int version, int newVersion);

  /// No description provided for @chatThreadLoadOlder.
  ///
  /// In en, this message translates to:
  /// **'Load older replies'**
  String get chatThreadLoadOlder;

  /// No description provided for @chatAttachmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No attachments selected'**
  String get chatAttachmentsEmpty;

  /// No description provided for @chatAttachmentsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add files'**
  String get chatAttachmentsAdd;

  /// No description provided for @chatAttachmentRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove attachment'**
  String get chatAttachmentRemove;

  /// No description provided for @chatAttachmentStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get chatAttachmentStatusProcessing;

  /// No description provided for @chatAttachmentStatusScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get chatAttachmentStatusScanning;

  /// No description provided for @chatAttachmentStatusClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get chatAttachmentStatusClean;

  /// No description provided for @chatAttachmentStatusInfected.
  ///
  /// In en, this message translates to:
  /// **'Infected'**
  String get chatAttachmentStatusInfected;

  /// No description provided for @chatAttachmentStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get chatAttachmentStatusFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
