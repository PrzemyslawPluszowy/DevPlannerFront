import 'package:json_annotation/json_annotation.dart';

/// Moduł będący właścicielem pliku.
@JsonEnum()
enum StorageModule {
  @JsonValue('Workspaces')
  workspaces,
  @JsonValue('Inventory')
  inventory,
  @JsonValue('Bhp')
  bhp,
  @JsonValue('Iqc')
  iqc,
  @JsonValue('Fleet')
  fleet,
  @JsonValue('Shared')
  shared,
}

/// Formaty pustych dokumentów obsługiwane przez backend Workspaces.
@JsonEnum()
enum StorageDocumentFormat {
  @JsonValue('Txt')
  txt,
  @JsonValue('Odt')
  odt,
  @JsonValue('Ods')
  ods,
  @JsonValue('Odp')
  odp,
  @JsonValue('Docx')
  docx,
  @JsonValue('Xlsx')
  xlsx,
  @JsonValue('Pptx')
  pptx,
}

/// Rozszerzenie pliku dla formatu tworzonego dokumentu.
extension StorageDocumentFormatExtension on StorageDocumentFormat {
  String get extension => switch (this) {
    StorageDocumentFormat.txt => '.txt',
    StorageDocumentFormat.odt => '.odt',
    StorageDocumentFormat.ods => '.ods',
    StorageDocumentFormat.odp => '.odp',
    StorageDocumentFormat.docx => '.docx',
    StorageDocumentFormat.xlsx => '.xlsx',
    StorageDocumentFormat.pptx => '.pptx',
  };
}

/// Wartość kontraktu HTTP używana w parametrach query Storage.
extension StorageModuleApiValue on StorageModule {
  String get apiValue => switch (this) {
    StorageModule.workspaces => 'Workspaces',
    StorageModule.inventory => 'Inventory',
    StorageModule.bhp => 'Bhp',
    StorageModule.iqc => 'Iqc',
    StorageModule.fleet => 'Fleet',
    StorageModule.shared => 'Shared',
  };
}

/// Typ zasobu powiązanego z plikiem.
@JsonEnum()
enum StorageResourceType {
  @JsonValue('Task')
  task,
  @JsonValue('Comment')
  comment,
  @JsonValue('Project')
  project,
  @JsonValue('Document')
  document,
  @JsonValue('Sheet')
  sheet,
  @JsonValue('AccidentProtocol')
  accidentProtocol,
  @JsonValue('UserAvatar')
  userAvatar,
  @JsonValue('Private')
  privateFile,
  @JsonValue('OkrObjective')
  okrObjective,
  @JsonValue('Portfolio')
  portfolio,
}

/// Wartość kontraktu HTTP używana w parametrach query Storage.
extension StorageResourceTypeApiValue on StorageResourceType {
  String get apiValue => switch (this) {
    StorageResourceType.task => 'Task',
    StorageResourceType.comment => 'Comment',
    StorageResourceType.project => 'Project',
    StorageResourceType.document => 'Document',
    StorageResourceType.sheet => 'Sheet',
    StorageResourceType.accidentProtocol => 'AccidentProtocol',
    StorageResourceType.userAvatar => 'UserAvatar',
    StorageResourceType.privateFile => 'Private',
    StorageResourceType.okrObjective => 'OkrObjective',
    StorageResourceType.portfolio => 'Portfolio',
  };
}

/// Status skanowania antywirusowego.
@JsonEnum()
enum StorageScanStatus {
  @JsonValue('Pending')
  pending,
  @JsonValue('Clean')
  clean,
  @JsonValue('Infected')
  infected,
  @JsonValue('Skipped')
  skipped,
}

/// Status przetwarzania pliku.
@JsonEnum()
enum StorageProcessingStatus {
  @JsonValue('None')
  none,
  @JsonValue('Queued')
  queued,
  @JsonValue('Processing')
  processing,
  @JsonValue('Ready')
  ready,
  @JsonValue('Failed')
  failed,
}

/// Status analizy AI pliku.
@JsonEnum()
enum StorageAiStatus {
  @JsonValue('None')
  none,
  @JsonValue('Queued')
  queued,
  @JsonValue('Processing')
  processing,
  @JsonValue('Completed')
  completed,
  @JsonValue('Failed')
  failed,
}

/// Wartość kontraktu HTTP używana w parametrach query Storage.
extension StorageAiStatusApiValue on StorageAiStatus {
  String get apiValue => switch (this) {
    StorageAiStatus.none => 'None',
    StorageAiStatus.queued => 'Queued',
    StorageAiStatus.processing => 'Processing',
    StorageAiStatus.completed => 'Completed',
    StorageAiStatus.failed => 'Failed',
  };
}

/// Efektywny poziom dostępu do pliku.
@JsonEnum()
enum StorageEffectiveAccessLevel {
  @JsonValue('None')
  none,
  @JsonValue('Reader')
  reader,
  @JsonValue('Commenter')
  commenter,
  @JsonValue('Editor')
  editor,
  @JsonValue('Owner')
  owner,
}

/// Typ udostępnienia pliku.
@JsonEnum()
enum StorageShareType {
  @JsonValue('User')
  user,
  @JsonValue('PublicLink')
  publicLink,
  @JsonValue('Workspace')
  workspace,
  @JsonValue('Project')
  project,
}

/// Poziom uprawnień nadany przez udostępnienie.
@JsonEnum()
enum StorageShareAccessLevel {
  @JsonValue('Read')
  read,
  @JsonValue('Write')
  write,
  @JsonValue('Owner')
  owner,
  @JsonValue('Editor')
  editor,
  @JsonValue('Commenter')
  commenter,
  @JsonValue('Reader')
  reader,
}

/// Kontekst wirtualnego folderu.
@JsonEnum()
enum StorageFolderType {
  @JsonValue('Personal')
  personal,
  @JsonValue('Workspace')
  workspace,
  @JsonValue('Project')
  project,
  @JsonValue('Shared')
  shared,
}

/// Wartość kontraktu HTTP używana w parametrach query Storage.
extension StorageFolderTypeApiValue on StorageFolderType {
  String get apiValue => switch (this) {
    StorageFolderType.personal => 'Personal',
    StorageFolderType.workspace => 'Workspace',
    StorageFolderType.project => 'Project',
    StorageFolderType.shared => 'Shared',
  };
}

/// Systemowy widok listy plików.
@JsonEnum()
enum StorageListView {
  @JsonValue('My')
  my,
  @JsonValue('Shared')
  shared,
  @JsonValue('Recent')
  recent,
  @JsonValue('Favorites')
  favorites,
  @JsonValue('Trash')
  trash,
}

/// Wartość kontraktu HTTP używana w parametrach query Storage.
extension StorageListViewApiValue on StorageListView {
  String get apiValue => switch (this) {
    StorageListView.my => 'My',
    StorageListView.shared => 'Shared',
    StorageListView.recent => 'Recent',
    StorageListView.favorites => 'Favorites',
    StorageListView.trash => 'Trash',
  };
}

/// Status zadania analizy AI pliku.
@JsonEnum()
enum StorageFileAnalysisJobStatus {
  @JsonValue('Pending')
  pending,
  @JsonValue('Processing')
  processing,
  @JsonValue('Completed')
  completed,
  @JsonValue('Failed')
  failed,
}

/// Provider użyty przez operację AI.
@JsonEnum()
enum AiProviderKind {
  disabled,
  aifastApi,
  openAi,
  azureOpenAi,
  anthropic,
  ollama,
  custom,
}

/// Wartość kontraktu HTTP używana w parametrach query audytu AI.
extension AiProviderKindApiValue on AiProviderKind {
  String get apiValue => switch (this) {
    AiProviderKind.disabled => 'disabled',
    AiProviderKind.aifastApi => 'aifastApi',
    AiProviderKind.openAi => 'openAi',
    AiProviderKind.azureOpenAi => 'azureOpenAi',
    AiProviderKind.anthropic => 'anthropic',
    AiProviderKind.ollama => 'ollama',
    AiProviderKind.custom => 'custom',
  };
}

/// Stan dostępności providera AI.
@JsonEnum()
enum AiProviderStatus { unknown, healthy, degraded, unavailable, disabled }

/// Wspólny cykl życia operacji AI.
@JsonEnum()
enum AiOperationStatus {
  queued,
  processing,
  completed,
  degraded,
  failedRetryable,
  failedTerminal,
  cancelled,
}

/// Status harmonogramu raportu AI.
@JsonEnum()
enum AiReportScheduleCadence { daily, weekly, monthly }

/// Kanał dostarczenia raportu AI.
@JsonEnum()
enum AiReportDeliveryChannel { email, inApp }

/// Wartość kontraktu HTTP używana w parametrach query raportów AI.
extension AiReportDeliveryChannelApiValue on AiReportDeliveryChannel {
  String get apiValue => switch (this) {
    AiReportDeliveryChannel.email => 'email',
    AiReportDeliveryChannel.inApp => 'inApp',
  };
}

/// Status uruchomienia harmonogramu raportu.
@JsonEnum()
enum AiReportScheduleRunStatus { pending, reportCreated, completed, failed }

/// Wartość kontraktu HTTP używana w parametrach query raportów AI.
extension AiReportScheduleRunStatusApiValue on AiReportScheduleRunStatus {
  String get apiValue => switch (this) {
    AiReportScheduleRunStatus.pending => 'pending',
    AiReportScheduleRunStatus.reportCreated => 'reportCreated',
    AiReportScheduleRunStatus.completed => 'completed',
    AiReportScheduleRunStatus.failed => 'failed',
  };
}

/// Status dostarczenia raportu AI.
@JsonEnum()
enum AiReportDeliveryStatus {
  pending,
  processing,
  delivered,
  failed,
  skipped,
  sentUnknown,
}

/// Wartość kontraktu HTTP używana w parametrach query raportów AI.
extension AiReportDeliveryStatusApiValue on AiReportDeliveryStatus {
  String get apiValue => switch (this) {
    AiReportDeliveryStatus.pending => 'pending',
    AiReportDeliveryStatus.processing => 'processing',
    AiReportDeliveryStatus.delivered => 'delivered',
    AiReportDeliveryStatus.failed => 'failed',
    AiReportDeliveryStatus.skipped => 'skipped',
    AiReportDeliveryStatus.sentUnknown => 'sentUnknown',
  };
}

/// Docelowy status ręcznej rekonsyliacji dostarczenia.
@JsonEnum()
enum AiReportDeliveryResolutionStatus { delivered, failed }

/// Status zakresu raportu AI.
@JsonEnum()
enum StorageAiReportScopeType { project }

/// Status joba raportu AI.
@JsonEnum()
enum StorageAiReportJobStatus { pending, processing, completed, failed }

/// Typ zdarzenia audytu operacji AI.
@JsonEnum()
enum AiOperationAuditEventType { started, completed, failed, reconciled }

/// Wartość kontraktu HTTP używana w parametrach query audytu AI.
extension AiOperationAuditEventTypeApiValue on AiOperationAuditEventType {
  String get apiValue => switch (this) {
    AiOperationAuditEventType.started => 'started',
    AiOperationAuditEventType.completed => 'completed',
    AiOperationAuditEventType.failed => 'failed',
    AiOperationAuditEventType.reconciled => 'reconciled',
  };
}

/// Stabilny kod błędu raportu AI.
@JsonEnum()
enum StorageAiReportFailureCode {
  unknown,
  sourceAccessRevoked,
  sourceSnapshotEmpty,
  unsupportedProvider,
  invalidProviderResponse,
  providerUnauthorized,
  providerRateLimited,
  providerUnavailable,
  circuitOpen,
  disabled,
  outputStorageFailed,
  sourceContentMismatch,
  deadlineExceeded,
  sourceChanged,
}

/// Stabilny kod błędu analizy pliku.
@JsonEnum()
enum StorageAnalysisFailureCode {
  unknown,
  sourceVersionMissing,
  storageContentMismatch,
  unsupportedMedia,
  invalidProviderResponse,
  providerUnauthorized,
  providerRateLimited,
  providerUnavailable,
  circuitOpen,
  disabled,
  deadlineExceeded,
  sourceDeleted,
  sourceNotReady,
  sourceInfected,
}

/// Wartość kontraktu HTTP używana w parametrach query audytu AI.
extension StorageAnalysisFailureCodeApiValue on StorageAnalysisFailureCode {
  String get apiValue => switch (this) {
    StorageAnalysisFailureCode.unknown => 'unknown',
    StorageAnalysisFailureCode.sourceVersionMissing => 'sourceVersionMissing',
    StorageAnalysisFailureCode.storageContentMismatch =>
      'storageContentMismatch',
    StorageAnalysisFailureCode.unsupportedMedia => 'unsupportedMedia',
    StorageAnalysisFailureCode.invalidProviderResponse =>
      'invalidProviderResponse',
    StorageAnalysisFailureCode.providerUnauthorized => 'providerUnauthorized',
    StorageAnalysisFailureCode.providerRateLimited => 'providerRateLimited',
    StorageAnalysisFailureCode.providerUnavailable => 'providerUnavailable',
    StorageAnalysisFailureCode.circuitOpen => 'circuitOpen',
    StorageAnalysisFailureCode.disabled => 'disabled',
    StorageAnalysisFailureCode.deadlineExceeded => 'deadlineExceeded',
    StorageAnalysisFailureCode.sourceDeleted => 'sourceDeleted',
    StorageAnalysisFailureCode.sourceNotReady => 'sourceNotReady',
    StorageAnalysisFailureCode.sourceInfected => 'sourceInfected',
  };
}
