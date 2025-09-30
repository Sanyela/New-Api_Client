import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../config/api_config.dart';

/// 用户服务 Provider
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

/// 用户列表状态
class UserListState {
  final List<User> users;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  UserListState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = true,
  });

  UserListState copyWith({
    List<User>? users,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return UserListState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// 用户列表 Notifier
class UserListNotifier extends StateNotifier<UserListState> {
  final UserService _userService;

  UserListNotifier(this._userService) : super(UserListState());

  /// 加载用户列表
  Future<void> loadUsers({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = UserListState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final response = await _userService.getUsers(
        page: refresh ? 1 : state.currentPage,
        pageSize: ApiConfig.defaultPageSize,
      );

      final totalPages = (response.total / response.pageSize).ceil();

      state = state.copyWith(
        users: refresh ? response.items : [...state.users, ...response.items],
        isLoading: false,
        currentPage: response.page,
        totalPages: totalPages,
        hasMore: response.page < totalPages,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(currentPage: state.currentPage + 1);
    await loadUsers();
  }

  /// 刷新
  Future<void> refresh() async {
    await loadUsers(refresh: true);
  }

  /// 搜索用户
  Future<void> searchUsers(String keyword) async {
    if (keyword.isEmpty) {
      await refresh();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = await _userService.searchUsers(keyword);
      state = state.copyWith(
        users: users,
        isLoading: false,
        hasMore: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 删除用户
  Future<bool> deleteUser(int userId) async {
    try {
      await _userService.deleteUser(userId);
      state = state.copyWith(
        users: state.users.where((u) => u.id != userId).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// 用户列表 Provider
final userListProvider =
    StateNotifierProvider<UserListNotifier, UserListState>((ref) {
  final userService = ref.watch(userServiceProvider);
  return UserListNotifier(userService);
});

/// 单个用户详情 Provider
final userDetailProvider =
    FutureProvider.family<User, int>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getUser(userId);
});