import '../models/channel.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// 渠道服务
class ChannelService {
  final _api = ApiService();

  /// 获取渠道列表
  Future<ChannelListResponse> getChannels({
    int page = 1,
    int pageSize = ApiConfig.defaultPageSize,
  }) async {
    try {
      final response = await _api.get(
        ApiConfig.channelsEndpoint,
        queryParameters: {
          'p': page,
          'page_size': pageSize,
        },
      );

      if (response.data['success'] == true) {
        return ChannelListResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '获取渠道列表失败');
      }
    } catch (e) {
      throw Exception('获取渠道列表失败: $e');
    }
  }

  /// 获取单个渠道
  Future<Channel> getChannel(int id) async {
    try {
      final response = await _api.get('${ApiConfig.channelsEndpoint}$id');

      if (response.data['success'] == true) {
        return Channel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '获取渠道失败');
      }
    } catch (e) {
      throw Exception('获取渠道失败: $e');
    }
  }

  /// 更新渠道
  Future<void> updateChannel(Map<String, dynamic> channelData) async {
    try {
      final response = await _api.put(
        ApiConfig.channelsEndpoint,
        data: channelData,
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '更新渠道失败');
      }
    } catch (e) {
      throw Exception('更新渠道失败: $e');
    }
  }

  /// 测试渠道
  Future<Map<String, dynamic>> testChannel(int id) async {
    try {
      final response = await _api.get('${ApiConfig.channelTestEndpoint}/$id');

      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response.data['message'] ?? '测试渠道失败');
      }
    } catch (e) {
      throw Exception('测试渠道失败: $e');
    }
  }

  /// 搜索渠道
  Future<List<Channel>> searchChannels(String keyword) async {
    try {
      final response = await _api.get(
        ApiConfig.channelSearchEndpoint,
        queryParameters: {'keyword': keyword},
      );

      if (response.data['success'] == true) {
        final items = response.data['data']['items'] as List;
        return items.map((json) => Channel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '搜索渠道失败');
      }
    } catch (e) {
      throw Exception('搜索渠道失败: $e');
    }
  }
}