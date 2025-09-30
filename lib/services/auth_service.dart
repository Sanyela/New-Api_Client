import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// 认证服务
class AuthService {
  final _api = ApiService();
  final _storage = const FlutterSecureStorage();

  /// 登录
  Future<User> login(String username, String password) async {
    try {
      final response = await _api.post(
        ApiConfig.loginEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.data['success'] == true) {
        final user = User.fromJson(response.data['data']);

        // 保存用户信息
        await _storage.write(key: 'user_info', value: jsonEncode(user.toJson()));
        await _api.saveUserId(user.id.toString());

        // 从响应头中提取 Session Cookie
        final setCookie = response.headers['set-cookie'];
        if (setCookie != null && setCookie.isNotEmpty) {
          final sessionToken = _extractSessionToken(setCookie.first);
          if (sessionToken != null) {
            await _api.saveSessionToken(sessionToken);
          }
        }

        return user;
      } else {
        throw Exception(response.data['message'] ?? '登录失败');
      }
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  /// 登出
  Future<void> logout() async {
    try {
      await _api.get(ApiConfig.logoutEndpoint);
    } catch (e) {
      print('登出请求失败: $e');
    } finally {
      // 清除本地存储
      await _api.clearAuth();
    }
  }

  /// 获取当前用户
  Future<User?> getCurrentUser() async {
    try {
      final userInfo = await _storage.read(key: 'user_info');
      if (userInfo == null) return null;

      return User.fromJson(jsonDecode(userInfo));
    } catch (e) {
      print('获取用户信息失败: $e');
      return null;
    }
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    return await _api.isLoggedIn();
  }

  /// 提取 Session Token
  String? _extractSessionToken(String setCookie) {
    final regex = RegExp(r'session=([^;]+)');
    final match = regex.firstMatch(setCookie);
    return match?.group(1);
  }

  /// 验证管理员权限
  Future<bool> isAdmin() async {
    final user = await getCurrentUser();
    return user?.isAdmin ?? false;
  }

  /// 验证超级管理员权限
  Future<bool> isRoot() async {
    final user = await getCurrentUser();
    return user?.isRoot ?? false;
  }
}