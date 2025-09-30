import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/channel.dart';
import '../services/channel_service.dart';
import '../config/api_config.dart';

/// 渠道服务 Provider
final channelServiceProvider = Provider<ChannelService>((ref) {
  return ChannelService();
});

/// 渠道列表状态
class ChannelListState {
  final List<Channel> channels;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  ChannelListState({
    this.channels = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = true,
  });

  ChannelListState copyWith({
    List<Channel>? channels,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return ChannelListState(
      channels: channels ?? this.channels,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// 渠道列表 Notifier
class ChannelListNotifier extends StateNotifier<ChannelListState> {
  final ChannelService _channelService;

  ChannelListNotifier(this._channelService) : super(ChannelListState());

  /// 加载渠道列表
  Future<void> loadChannels({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = ChannelListState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final response = await _channelService.getChannels(
        page: refresh ? 1 : state.currentPage,
        pageSize: ApiConfig.defaultPageSize,
      );

      final totalPages = (response.total / response.pageSize).ceil();

      state = state.copyWith(
        channels:
            refresh ? response.items : [...state.channels, ...response.items],
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
    await loadChannels();
  }

  /// 刷新
  Future<void> refresh() async {
    await loadChannels(refresh: true);
  }

  /// 搜索渠道
  Future<void> searchChannels(String keyword) async {
    if (keyword.isEmpty) {
      await refresh();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final channels = await _channelService.searchChannels(keyword);
      state = state.copyWith(
        channels: channels,
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
}

/// 渠道列表 Provider
final channelListProvider =
    StateNotifierProvider<ChannelListNotifier, ChannelListState>((ref) {
  final channelService = ref.watch(channelServiceProvider);
  return ChannelListNotifier(channelService);
});

/// 单个渠道详情 Provider
final channelDetailProvider =
    FutureProvider.family<Channel, int>((ref, channelId) async {
  final channelService = ref.watch(channelServiceProvider);
  return await channelService.getChannel(channelId);
});