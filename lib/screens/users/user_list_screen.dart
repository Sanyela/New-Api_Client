import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../providers/user_provider.dart';
import '../../widgets/user_card.dart';
import '../../widgets/empty_state.dart';

/// 用户列表页面
class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final _searchController = TextEditingController();
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    // 初始加载
    Future.microtask(() {
      ref.read(userListProvider.notifier).loadUsers(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(userListProvider.notifier).refresh();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await ref.read(userListProvider.notifier).loadMore();
    _refreshController.loadComplete();
  }

  void _handleSearch(String keyword) {
    ref.read(userListProvider.notifier).searchUsers(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final userListState = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('用户管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/users/create');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索用户...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _handleSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: _handleSearch,
            ),
          ),

          // 用户列表
          Expanded(
            child: _buildUserList(userListState),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(UserListState state) {
    if (state.isLoading && state.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(userListProvider.notifier).refresh();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (state.users.isEmpty) {
      return EmptyState(
        icon: Icons.people_outline,
        message: '暂无用户数据',
        actionText: '刷新',
        onAction: () {
          ref.read(userListProvider.notifier).refresh();
        },
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: state.hasMore,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: state.users.length,
        itemBuilder: (context, index) {
          final user = state.users[index];
          return UserCard(
            user: user,
            onTap: () {
              context.push('/users/${user.id}');
            },
          );
        },
      ),
    );
  }
}