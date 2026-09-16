import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/storage/transport/public_share_link_builder_stub.dart'
    if (dart.library.js_interop) 'package:ready_next/workspaces/data/storage/transport/public_share_link_builder_web.dart'
    if (dart.library.io) 'package:ready_next/workspaces/data/storage/transport/public_share_link_builder_io.dart'
    as platform;
import 'package:ready_next/workspaces/domain/storage/ports/public_share_link_builder.dart';

final class PublicShareLinkBuilderImpl implements PublicShareLinkBuilder {
  const PublicShareLinkBuilderImpl();

  @override
  Either<ApiError, String> build(String shareToken) =>
      platform.StoragePublicShareLinkPlatform.build(shareToken);
}
