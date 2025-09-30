import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/users/user_list_screen.dart';
import '../screens/users/user_detail_screen.dart';
import '../screens/users/user_edit_screen.dart';
import '../screens/channels/channel_list_screen.dart';
import '../screens/channels/channel_detail_screen.dart';
import '../screens/channels/channel_edit_screen.dart';
import '../screens/logs/log_list_screen.dart';
import '../screens/logs/log_detail_screen.dart';

/// 路由配置
class AppRoutes {
  // 路由路径
  static const String login = '/login';
  static const String home = '/';
  static const String users = '/users';
  static const String userDetail = '/users/:id';
  static const String userEdit = '/users/:id/edit';
  static const String userCreate = '/users/create';
  static const String channels = '/channels';
  static const String channelDetail = '/channels/:id';
  static const String channelEdit = '/channels/:id/edit';
  static const String logs = '/logs';
  static const String logDetail = '/logs/:id';

  // 路由配置
  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      // 登录页
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),

      // 主页（包含底部导航）
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),

      // 用户管理
      GoRoute(
        path: users,
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: userDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return UserDetailScreen(userId: id);
        },
      ),
      GoRoute(
        path: userEdit,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return UserEditScreen(userId: id);
        },
      ),
      GoRoute(
        path: userCreate,
        builder: (context, state) => const UserEditScreen(),
      ),

      // 渠道管理
      GoRoute(
        path: channels,
        builder: (context, state) => const ChannelListScreen(),
      ),
      GoRoute(
        path: channelDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ChannelDetailScreen(channelId: id);
        },
      ),
      GoRoute(
        path: channelEdit,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ChannelEditScreen(channelId: id);
        },
      ),

      // 日志管理
      GoRoute(
        path: logs,
        builder: (context, state) => const LogListScreen(),
      ),
      GoRoute(
        path: logDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LogDetailScreen(logId: id);
        },
      ),
    ],

    // 错误页面
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('页面未找到')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('路径不存在: ${state.uri}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    ),
  );
}