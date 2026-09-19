import 'package:bloc/bloc.dart';
import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:devplanner/admin/domain/ports/admin_user_gateway.dart';
import 'package:devplanner/admin/presentation/cubit/admin_users_state.dart';

/// Właściciel listy i paginacji kont administratora.
final class AdminUsersCubit extends Cubit<AdminUsersState> {
  AdminUsersCubit({required AdminUsersComposition composition})
    : _gateway = composition.gateway,
      super(const AdminUsersInitial());

  final AdminUserGateway _gateway;

  Future<void> load({AdminUserQuery query = const AdminUserQuery()}) async {
    final previous = _usersFromState;
    emit(AdminUsersLoading(previousUsers: previous));
    final result = await _gateway.list(query);
    if (isClosed) return;
    result.fold(
      (error) =>
          emit(AdminUsersFailure(error.message, previousUsers: previous)),
      (page) => emit(
        AdminUsersReady(
          users: page.users,
          nextCursor: page.nextCursor,
          query: query,
        ),
      ),
    );
  }

  Future<void> refresh() => load(query: _queryFromState);

  Future<void> search(String value) => load(
    query: _queryFromState.copyWith(
      search: value.trim().isEmpty ? null : value.trim(),
      clearSearch: value.trim().isEmpty,
      clearCursor: true,
    ),
  );

  Future<void> loadMore() async {
    final current = state;
    if (current is! AdminUsersReady ||
        current.nextCursor == null ||
        current.isLoadingMore) {
      return;
    }
    emit(current.copyWith(isLoadingMore: true, clearError: true));
    final result = await _gateway.list(
      current.query.copyWith(cursor: current.nextCursor),
    );
    if (isClosed) return;
    result.fold(
      (error) =>
          emit(current.copyWith(isLoadingMore: false, error: error.message)),
      (page) => emit(
        current.copyWith(
          users: [...current.users, ...page.users],
          nextCursor: page.nextCursor,
          isLoadingMore: false,
          clearNextCursor: page.nextCursor == null,
        ),
      ),
    );
  }

  List<AdminUser> get _usersFromState => switch (state) {
    AdminUsersReady(:final users) => users,
    AdminUsersLoading(:final previousUsers) => previousUsers,
    AdminUsersFailure(:final previousUsers) => previousUsers,
    AdminUsersInitial() => const [],
  };

  AdminUserQuery get _queryFromState => switch (state) {
    AdminUsersReady(:final query) => query,
    _ => const AdminUserQuery(),
  };
}
