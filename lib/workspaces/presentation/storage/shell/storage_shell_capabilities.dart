import 'package:flutter/foundation.dart';

/// Uprawnienia kompozycji dla modułu Files.
///
/// Web/BFF i desktop korzystają z tych samych uwierzytelnionych operacji API.
/// Transfery binarne mają izolowane adaptery presigned; nie wymagają przekazania
/// Bearera do przeglądarki. Capability opisuje dostępność adaptera, nie grant ACL.
///
/// Brak flagi zawsze oznacza akcję ukrytą; ACL pojedynczego elementu jest
/// sprawdzane dodatkowo i niezależnie.
@immutable
final class StorageShellCapabilities {
  /// Tworzy zestaw uprawnień kompozycji.
  const StorageShellCapabilities({
    this.canUpload = false,
    this.canCreateFolder = false,
    this.canRenameFolder = false,
    this.canRenameFile = false,
    this.canCreateDocument = false,
    this.canDelete = false,
    this.canDownload = false,
    this.canShare = false,
    this.canFavorite = false,
    this.canMove = false,
    this.canManageVersions = false,
  });

  /// Brak uwierzytelnionego transportu: wyłącznie odczyt.
  static const StorageShellCapabilities readOnly = StorageShellCapabilities();

  /// Pełna kompozycja BFF/cookie lub desktop/PKCE z adapterami transferu.
  static const StorageShellCapabilities full = StorageShellCapabilities(
    canUpload: true,
    canCreateFolder: true,
    canRenameFolder: true,
    canRenameFile: true,
    canCreateDocument: true,
    canDelete: true,
    canDownload: true,
    canShare: true,
    canFavorite: true,
    canMove: true,
    canManageVersions: true,
  );

  /// Zgodność istniejących kompozycji desktopowych.
  static const StorageShellCapabilities desktop = full;

  /// Czy klient może wysyłać pliki przez presigned transfer.
  final bool canUpload;

  /// Czy klient może tworzyć foldery.
  final bool canCreateFolder;

  /// Czy klient może zmieniać nazwę folderu.
  final bool canRenameFolder;

  /// Czy kompozycja może zmieniać nazwę pliku.
  final bool canRenameFile;

  /// Czy klient może tworzyć puste dokumenty biurowe.
  final bool canCreateDocument;

  /// Czy klient może usuwać i przywracać pliki oraz foldery.
  final bool canDelete;

  /// Czy klient może pobierać pliki.
  final bool canDownload;

  /// Czy klient może udostępniać pliki.
  final bool canShare;

  /// Czy klient może przełączać stan ulubionego pliku.
  final bool canFavorite;

  /// Czy klient może przenosić pliki i foldery między folderami.
  final bool canMove;

  /// Czy klient może przeglądać i przywracać historię wersji.
  final bool canManageVersions;
}
