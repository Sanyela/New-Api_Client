import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../providers/channel_provider.dart';
import '../../widgets/channel_card.dart';
import '../../widgets/empty_state.dart';

/// 渠道列表页面
class ChannelListScreen extends ConsumerStatefulWidget {
  const ChannelListScreen({super.key});

  @override
  ConsumerState<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends ConsumerState<ChannelListScreen> {
  final _searchController = TextEditingController();
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(channelListProvider.notifier).loadChannels(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(channelListProvider.notifier).refresh();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await ref.read(channelListProvider.notifier).loadMore();
    _refreshController.loadComplete();
  }

  void _handleSearch(String keyword) {
    ref.read(channelListProvider.notifier).searchChannels(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final channelListState = ref.watch(channelListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('渠道管理'),
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索渠道...',
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

          // 渠道列表
          Expanded(
            child: _buildChannelList(channelListState),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelList(ChannelListState state) {
    if (state.isLoading && state.channels.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.channels.isEmpty) {
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
                ref.read(channelListProvider.notifier).refresh();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (state.channels.isEmpty) {
      return EmptyState(
        icon: Icons.router_outlined,
        message: '暂无渠道数据',
        actionText: '刷新',
        onAction: () {
          ref.read(channelListProvider.notifier).refresh();
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
        itemCount: state.channels.length,
        itemBuilder: (context, index) {
          final channel = state.channels[index];
          return ChannelCard(
            channel: channel,
            onTap: () {
              context.push('/channels/${channel.id}');
            },
          );
        },
      ),
    );
  }
}