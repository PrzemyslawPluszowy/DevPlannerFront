import 'package:devplanner/workspaces/data/storage/transport/storage_upload_body_stub.dart'
    if (dart.library.js_interop) 'package:devplanner/workspaces/data/storage/transport/storage_upload_body_web.dart'
    if (dart.library.io) 'package:devplanner/workspaces/data/storage/transport/storage_upload_body_io.dart'
    as platform;
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';

/// Wybiera strumieniowe źródło uploadu właściwe dla platformy.
final class StorageUploadBody {
  const StorageUploadBody._();

  /// Zwraca dane akceptowane przez Dio bez kopiowania pliku desktopowego.
  static Object create(StorageUploadInput input) =>
      platform.StorageUploadBodyPlatform.create(input);
}
