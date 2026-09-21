import 'package:flutter/foundation.dart';

/// Uprawnienia kompozycji dla modułu Files.
///
/// Pliki osobiste, workspace i projektu używają jednego pełnego shella, dlatego
/// o tym, czy użytkownik widzi akcje mutujące, nie decyduje widget ani rola
/// zapisana lokalnie, lecz jawna decyzja composition rootu. Klient Web/BFF nie
/// ma bezpiecznego źródła Bearera dla bezpośrednich transferów, więc jego
/// kompozycja pozostaje read-only, a desktop otrzymuje pełny zestaw akcji.
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
    this.canCreateDocument = false,
    this.canDelete = false,
    this.canDownload = false,
    this.canShare = false,
    this.canFavorite = false,
    this.canMove = false,
    this.canManageVersions = false,
  });

  /// Kompozycja Web/BFF: przeglądanie, wyszukiwanie, sortowanie i podgląd.
  static const StorageShellCapabilities readOnly = StorageShellCapabilities();

  /// Kompozycja desktopowa z bearerem, pickerem plików i portami transferu.
  static const StorageShellCapabilities desktop = StorageShellCapabilities(
    canUpload: true,
    canCreateFolder: true,
    canRenameFolder: true,
    canCreateDocument: true,
    canDelete: true,
    canDownload: true,
    canShare: true,
    canFavorite: true,
    canMove: true,
    canManageVersions: true,
  );

  /// Czy klient może wysyłać pliki przez presigned transfer.
  final bool canUpload;

  /// Czy klient może tworzyć foldery.
  final bool canCreateFolder;

  /// Czy klient może zmieniać nazwę folderu.
  final bool canRenameFolder;

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
