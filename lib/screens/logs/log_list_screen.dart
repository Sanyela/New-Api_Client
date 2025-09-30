import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../providers/log_provider.dart';
import '../../widgets/log_item.dart';
import '../../widgets/empty_state.dart';

/// 日志列表页面
class LogListScreen extends ConsumerStatefulWidget {
  const LogListScreen({super.key});

  @override
  ConsumerState<LogListScreen> createState() => _LogListScreenState();
}

class _LogListScreenState extends ConsumerState<LogListScreen> {
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(logListProvider.notifier).loadLogs(refresh: true);
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(logListProvider.notifier).refresh();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await ref.read(logListProvider.notifier).loadMore();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final logListState = ref.watch(logListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('使用日志'),
      ),
      body: _buildLogList(logListState),
    );
  }

  Widget _buildLogList(LogListState state) {
    if (state.isLoading && state.logs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.logs.isEmpty) {
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
                ref.read(logListProvider.notifier).refresh();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (state.logs.isEmpty) {
      return EmptyState(
        icon: Icons.history,
        message: '暂无日志数据',
        actionText: '刷新',
        onAction: () {
          ref.read(logListProvider.notifier).refresh();
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
        itemCount: state.logs.length,
        itemBuilder: (context, index) {
          final log = state.logs[index];
          return LogItem(log: log);
        },
      ),
    );
  }
}