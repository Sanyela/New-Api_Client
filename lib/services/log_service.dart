import '../models/log.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// 日志服务
class LogService {
  final _api = ApiService();

  /// 获取日志列表
  Future<LogListResponse> getLogs({
    int page = 1,
    int pageSize = ApiConfig.defaultPageSize,
  }) async {
    try {
      final response = await _api.get(
        ApiConfig.logsEndpoint,
        queryParameters: {
          'p': page,
          'page_size': pageSize,
        },
      );

      if (response.data['success'] == true) {
        return LogListResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '获取日志列表失败');
      }
    } catch (e) {
      throw Exception('获取日志列表失败: $e');
    }
  }

  /// 获取日志统计
  Future<LogStats> getLogStats() async {
    try {
      final response = await _api.get(ApiConfig.logStatEndpoint);

      if (response.data['success'] == true) {
        return LogStats.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '获取日志统计失败');
      }
    } catch (e) {
      throw Exception('获取日志统计失败: $e');
    }
  }

  /// 搜索日志
  Future<List<Log>> searchLogs({
    String? keyword,
    String? model,
    int? userId,
    int? startTime,
    int? endTime,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (keyword != null) params['keyword'] = keyword;
      if (model != null) params['model'] = model;
      if (userId != null) params['user_id'] = userId;
      if (startTime != null) params['start_time'] = startTime;
      if (endTime != null) params['end_time'] = endTime;

      final response = await _api.get(
        ApiConfig.logSearchEndpoint,
        queryParameters: params,
      );

      if (response.data['success'] == true) {
        final items = response.data['data'] as List;
        return items.map((json) => Log.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '搜索日志失败');
      }
    } catch (e) {
      throw Exception('搜索日志失败: $e');
    }
  }
}