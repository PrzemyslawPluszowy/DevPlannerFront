import 'package:dartz/dartz.dart';
import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:devplanner/foundation/error/error.dart';

/// Domena administracji użytkownikami nie zna Dio, ścieżek HTTP ani sesji.
///
/// Adapter infrastruktury zostanie dostarczony dopiero po zatwierdzeniu
/// OpenAPI fazy 3A. Brak implementacji w composition nie może udawać pustej
/// listy kont ani sukcesu mutacji.
abstract interface class AdminUserGateway {
  Future<Either<ApiError, AdminUserPage>> list(AdminUserQuery query);

  Future<Either<ApiError, AdminUser>> create(AdminUserCreateCommand command);

  Future<Either<ApiError, AdminUser>> update(AdminUserUpdateCommand command);

  Future<Either<ApiError, AdminUserRolesResult>> setRoles(
    AdminUserRoleCommand command,
  );

  Future<Either<ApiError, AdminUserLifecycleResult>> lifecycle(
    AdminUserLifecycleCommand command,
  );
}
