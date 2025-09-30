import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/log.dart';
import '../services/log_service.dart';
import '../config/api_config.dart';

/// 日志服务 Provider
final logServiceProvider = Provider<LogService>((ref) {
  return LogService();
});

/// 日志列表状态
class LogListState {
  final List<Log> logs;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  LogListState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = true,
  });

  LogListState copyWith({
    List<Log>? logs,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return LogListState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// 日志列表 Notifier
class LogListNotifier extends StateNotifier<LogListState> {
  final LogService _logService;

  LogListNotifier(this._logService) : super(LogListState());

  /// 加载日志列表
  Future<void> loadLogs({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = LogListState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final response = await _logService.getLogs(
        page: refresh ? 1 : state.currentPage,
        pageSize: ApiConfig.defaultPageSize,
      );

      final totalPages = (response.total / response.pageSize).ceil();

      state = state.copyWith(
        logs: refresh ? response.items : [...state.logs, ...response.items],
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
    await loadLogs();
  }

  /// 刷新
  Future<void> refresh() async {
    await loadLogs(refresh: true);
  }
}

/// 日志列表 Provider
final logListProvider =
    StateNotifierProvider<LogListNotifier, LogListState>((ref) {
  final logService = ref.watch(logServiceProvider);
  return LogListNotifier(logService);
});

/// 日志统计 Provider
final logStatsProvider = FutureProvider<LogStats>((ref) async {
  final logService = ref.watch(logServiceProvider);
  return await logService.getLogStats();
});