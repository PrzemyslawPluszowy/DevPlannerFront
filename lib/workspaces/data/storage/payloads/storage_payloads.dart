/// Payloady żądań modułu Storage.
library;

export '../models/storage_contract_models.dart'
    show
        BulkCompleteFileItemPayload,
        BulkCompleteUploadPayload,
        BulkTaskUploadTicketPayload,
        StorageUploadTicketItemPayload;
export '../models/storage_extended_models.dart'
    show
        AttachStorageFileToProjectPayload,
        BulkCreateStorageFilePlacementPayload,
        BulkDownloadZipPayload,
        BulkStorageUploadTicketPayload,
        CreateStorageAiReportPayload,
        CreateStorageFilePlacementPayload,
        CreateStorageFolderSharePayload,
        MoveStorageFilePlacementPayload,
        OnlyOfficeCallbackPayload,
        PublicShareAccessPayload,
        QuillCleanUnusedImagesPayload,
        RestoreStorageFileVersionPayload,
        SetStorageFileFavoritePayload,
        SetUserAvatarPayload,
        StorageScanResultPayload,
        UpdateStorageFileDescriptionPayload,
        UpdateStorageFolderPayload;
export '../models/storage_models.dart'
    show
        CompleteStorageUploadPayload,
        CreateStorageDocumentPayload,
        CreateStorageFileSharePayload,
        CreateStorageFolderPayload,
        StorageUploadTicketPayload;
