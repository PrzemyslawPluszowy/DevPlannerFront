import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';

/// Builds a user-facing public deep link without leaking API download tickets.
// ignore: one_member_abstracts
abstract interface class PublicShareLinkBuilder {
  Either<ApiError, String> build(String shareToken);
}
