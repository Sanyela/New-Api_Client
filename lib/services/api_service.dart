import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

/// API 基础服务
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final _storage = const FlutterSecureStorage();
  String? _baseUrl;

  /// 初始化
  Future<void> init({String? baseUrl}) async {
    _baseUrl = baseUrl ?? ApiConfig.defaultBaseUrl;

    _dio = Dio(BaseOptions(
      baseURL: _baseUrl!,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-store',
      },
    ));

    // 请求拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 添加 Session Cookie
        final sessionToken = await _storage.read(key: 'session_token');
        if (sessionToken != null) {
          options.headers['Cookie'] = 'session=$sessionToken';
        }

        // 添加用户 ID
        final userId = await _storage.read(key: 'user_id');
        if (userId != null) {
          options.headers['New-API-User'] = userId;
        }

        print('[API Request] ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('[API Response] ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        print('[API Error] ${e.requestOptions.path}: ${e.message}');

        // 401 未授权，清除登录信息
        if (e.response?.statusCode == 401) {
          await _handleUnauthorized();
        }

        return handler.next(e);
      },
    ));
  }

  /// 处理未授权
  Future<void> _handleUnauthorized() async {
    await _storage.delete(key: 'session_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'user_info');
    // 这里需要配合路由跳转到登录页
    // 可以通过全局事件总线或路由配置实现
  }

  /// GET 请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST 请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT 请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE 请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// 保存 Session Token
  Future<void> saveSessionToken(String token) async {
    await _storage.write(key: 'session_token', value: token);
  }

  /// 保存用户 ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  /// 清除认证信息
  Future<void> clearAuth() async {
    await _storage.delete(key: 'session_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'user_info');
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'session_token');
    return token != null;
  }

  /// 获取当前 BaseURL
  String? get baseUrl => _baseUrl;
}