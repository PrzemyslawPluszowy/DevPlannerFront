import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/storage/transport/public_share_link_builder_stub.dart'
    if (dart.library.js_interop) 'package:devplanner/workspaces/data/storage/transport/public_share_link_builder_web.dart'
    if (dart.library.io) 'package:devplanner/workspaces/data/storage/transport/public_share_link_builder_io.dart'
    as platform;
import 'package:devplanner/workspaces/domain/storage/ports/public_share_link_builder.dart';

final class PublicShareLinkBuilderImpl implements PublicShareLinkBuilder {
  const PublicShareLinkBuilderImpl();

  @override
  Either<ApiError, String> build(String shareToken) =>
      platform.StoragePublicShareLinkPlatform.build(shareToken);
}
