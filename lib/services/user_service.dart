import '../models/user.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// 用户服务
class UserService {
  final _api = ApiService();

  /// 获取用户列表
  Future<UserListResponse> getUsers({
    int page = 1,
    int pageSize = ApiConfig.defaultPageSize,
  }) async {
    try {
      final response = await _api.get(
        ApiConfig.usersEndpoint,
        queryParameters: {
          'p': page,
          'page_size': pageSize,
        },
      );

      if (response.data['success'] == true) {
        return UserListResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '获取用户列表失败');
      }
    } catch (e) {
      throw Exception('获取用户列表失败: $e');
    }
  }

  /// 获取单个用户
  Future<User> getUser(int id) async {
    try {
      final response = await _api.get('${ApiConfig.usersEndpoint}$id');

      if (response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '获取用户失败');
      }
    } catch (e) {
      throw Exception('获取用户失败: $e');
    }
  }

  /// 创建用户
  Future<User> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _api.post(
        ApiConfig.usersEndpoint,
        data: userData,
      );

      if (response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '创建用户失败');
      }
    } catch (e) {
      throw Exception('创建用户失败: $e');
    }
  }

  /// 更新用户
  Future<void> updateUser(Map<String, dynamic> userData) async {
    try {
      final response = await _api.put(
        ApiConfig.usersEndpoint,
        data: userData,
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '更新用户失败');
      }
    } catch (e) {
      throw Exception('更新用户失败: $e');
    }
  }

  /// 删除用户
  Future<void> deleteUser(int id) async {
    try {
      final response = await _api.delete('${ApiConfig.usersEndpoint}$id');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '删除用户失败');
      }
    } catch (e) {
      throw Exception('删除用户失败: $e');
    }
  }

  /// 搜索用户
  Future<List<User>> searchUsers(String keyword) async {
    try {
      final response = await _api.get(
        ApiConfig.userSearchEndpoint,
        queryParameters: {'keyword': keyword},
      );

      if (response.data['success'] == true) {
        final items = response.data['data'] as List;
        return items.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '搜索用户失败');
      }
    } catch (e) {
      throw Exception('搜索用户失败: $e');
    }
  }
}