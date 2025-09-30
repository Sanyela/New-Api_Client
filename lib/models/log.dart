/// 日志模型
class Log {
  final int id;
  final int userId;
  final String? username;
  final int? tokenId;
  final String? tokenName;
  final String type;
  final String modelName;
  final int? channelId;
  final int createdTime;
  final int promptTokens;
  final int completionTokens;
  final int quota;
  final String? content;
  final bool useStreaming;

  Log({
    required this.id,
    required this.userId,
    this.username,
    this.tokenId,
    this.tokenName,
    required this.type,
    required this.modelName,
    this.channelId,
    required this.createdTime,
    required this.promptTokens,
    required this.completionTokens,
    required this.quota,
    this.content,
    required this.useStreaming,
  });

  /// 从 JSON 解析
  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      username: json['username'] as String?,
      tokenId: json['token_id'] as int?,
      tokenName: json['token_name'] as String?,
      type: json['type'] as String? ?? 'unknown',
      modelName: json['model_name'] as String,
      channelId: json['channel_id'] as int?,
      createdTime: json['created_time'] as int,
      promptTokens: json['prompt_tokens'] as int? ?? 0,
      completionTokens: json['completion_tokens'] as int? ?? 0,
      quota: json['quota'] as int? ?? 0,
      content: json['content'] as String?,
      useStreaming: json['use_streaming'] as bool? ?? false,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'token_id': tokenId,
      'token_name': tokenName,
      'type': type,
      'model_name': modelName,
      'channel_id': channelId,
      'created_time': createdTime,
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'quota': quota,
      'content': content,
      'use_streaming': useStreaming,
    };
  }

  /// 总 token 数
  int get totalTokens => promptTokens + completionTokens;

  /// 费用（美元）
  double get costDollar {
    return quota / 500000.0;
  }

  /// 日期时间字符串
  String get dateTimeString {
    final date = DateTime.fromMillisecondsSinceEpoch(createdTime * 1000);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  /// 相对时间字符串
  String get relativeTimeString {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(createdTime * 1000);
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}秒前';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return dateTimeString;
    }
  }

  /// 类型名称
  String get typeName {
    switch (type) {
      case 'chat':
        return '聊天';
      case 'embedding':
        return '嵌入';
      case 'image':
        return '图像';
      case 'audio':
        return '音频';
      case 'moderation':
        return '审核';
      default:
        return type;
    }
  }

  /// 流式标识
  String get streamingText => useStreaming ? '流式' : '非流式';
}

/// 日志列表响应
class LogListResponse {
  final List<Log> items;
  final int total;
  final int page;
  final int pageSize;

  LogListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory LogListResponse.fromJson(Map<String, dynamic> json) {
    return LogListResponse(
      items: (json['items'] as List)
          .map((item) => Log.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
    );
  }
}

/// 日志统计
class LogStats {
  final double totalCost;
  final int totalRequests;
  final int totalTokens;
  final Map<String, int> modelUsage;
  final Map<String, double> dailyCost;

  LogStats({
    required this.totalCost,
    required this.totalRequests,
    required this.totalTokens,
    required this.modelUsage,
    required this.dailyCost,
  });

  factory LogStats.fromJson(Map<String, dynamic> json) {
    return LogStats(
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0.0,
      totalRequests: json['total_requests'] as int? ?? 0,
      totalTokens: json['total_tokens'] as int? ?? 0,
      modelUsage: Map<String, int>.from(json['model_usage'] as Map? ?? {}),
      dailyCost: Map<String, double>.from(
        (json['daily_cost'] as Map? ?? {}).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
    );
  }
}