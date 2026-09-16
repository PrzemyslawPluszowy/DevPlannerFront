import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';

/// Klasa pomocnicza sprawdzająca uprawnienia zarządcze użytkownika w projekcie.
///
/// Użytkownik posiada uprawnienia zarządcze (`canManageProject`), gdy jest
/// globalnym SuperAdminem albo pełni rolę `owner` lub `admin` w danym projekcie.
abstract final class TaskPermissionHelper {
  /// Zwraca `true`, jeśli zalogowany użytkownik ma uprawnienia do konfiguracji
  /// projektu, statusów, pól własnych i typów zadań.
  static bool canManageProject(
    BuildContext context, {
    required Map<String, ProjectMemberProfile> memberProfiles,
  }) {
    try {
      final authState = context.read<AuthCubit>().state;
      final authUser = switch (authState) {
        AuthAuthenticated(:final user) => user,
        _ => null,
      };
      if (authUser == null) return false;

      final isSuperAdmin =
          authUser.permissions.contains('bswfms.custom_modules.RNext-admin') ||
          authUser.permissions.contains('SuperAdmin');
      if (isSuperAdmin) return true;

      final currentUserId = authUser.coreUserId;
      final role = currentUserId == null
          ? null
          : memberProfiles[currentUserId]?.role;
      return role == ProjectRole.owner || role == ProjectRole.admin;
    } catch (_) {
      return false;
    }
  }
}
