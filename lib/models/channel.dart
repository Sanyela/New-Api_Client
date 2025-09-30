/// 渠道模型
class Channel {
  final int id;
  final String name;
  final int type;
  final int status;
  final String? models;
  final String? group;
  final int? priority;
  final int? weight;
  final int createdTime;
  final int? testTime;
  final int? responseTime;
  final double balance;
  final int usedQuota;
  final String? baseUrl;
  final String? modelMapping;
  final String? tag;

  Channel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.models,
    this.group,
    this.priority,
    this.weight,
    required this.createdTime,
    this.testTime,
    this.responseTime,
    required this.balance,
    required this.usedQuota,
    this.baseUrl,
    this.modelMapping,
    this.tag,
  });

  /// 从 JSON 解析
  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as int,
      status: json['status'] as int,
      models: json['models'] as String?,
      group: json['group'] as String?,
      priority: json['priority'] as int?,
      weight: json['weight'] as int?,
      createdTime: json['created_time'] as int,
      testTime: json['test_time'] as int?,
      responseTime: json['response_time'] as int?,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      usedQuota: json['used_quota'] as int? ?? 0,
      baseUrl: json['base_url'] as String?,
      modelMapping: json['model_mapping'] as String?,
      tag: json['tag'] as String?,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'models': models,
      'group': group,
      'priority': priority,
      'weight': weight,
      'created_time': createdTime,
      'test_time': testTime,
      'response_time': responseTime,
      'balance': balance,
      'used_quota': usedQuota,
      'base_url': baseUrl,
      'model_mapping': modelMapping,
      'tag': tag,
    };
  }

  /// 渠道类型名称
  String get typeName {
    const typeNames = {
      1: 'OpenAI',
      2: 'Midjourney',
      3: 'Azure OpenAI',
      4: 'Claude',
      5: 'PaLM',
      6: 'Gemini',
      7: 'Baidu',
      8: 'Zhipu',
      9: 'Ali',
      10: 'Xunfei',
      11: 'AI360',
      12: 'Tencent',
      13: 'Minimax',
      14: 'DeepSeek',
      15: 'Moonshot',
      16: 'Mistral',
      17: 'Groq',
      18: 'Ollama',
      19: 'Lingyiwanwu',
      20: 'Zhipu V4',
      21: 'AWS',
      22: 'Cohere',
      23: 'Coze',
      24: 'Doubao',
      25: 'Hunyuan',
      26: 'Cloudflare',
      27: 'Anthropic',
      28: 'Vertex AI',
      29: 'Suno',
      30: 'Dify',
      31: 'Novita',
    };
    return typeNames[type] ?? '未知类型';
  }

  /// 状态名称
  String get statusName {
    switch (status) {
      case 1:
        return '已启用';
      case 2:
        return '手动禁用';
      case 3:
        return '自动禁用';
      default:
        return '未知';
    }
  }

  /// 是否启用
  bool get isEnabled => status == 1;

  /// 是否禁用
  bool get isDisabled => status != 1;

  /// 响应时间（毫秒）
  String get responseTimeText {
    if (responseTime == null || responseTime == 0) {
      return '未测试';
    }
    return '${responseTime}ms';
  }

  /// 已使用额度（美元）
  double get usedQuotaDollar {
    return usedQuota / 500000.0;
  }

  /// 模型列表
  List<String> get modelList {
    if (models == null || models!.isEmpty) return [];
    return models!.split(',').map((e) => e.trim()).toList();
  }

  /// 分组列表
  List<String> get groupList {
    if (group == null || group!.isEmpty) return ['default'];
    return group!.split(',').map((e) => e.trim()).toList();
  }

  /// 复制对象
  Channel copyWith({
    int? id,
    String? name,
    int? type,
    int? status,
    String? models,
    String? group,
    int? priority,
    int? weight,
    int? createdTime,
    int? testTime,
    int? responseTime,
    double? balance,
    int? usedQuota,
    String? baseUrl,
    String? modelMapping,
    String? tag,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      models: models ?? this.models,
      group: group ?? this.group,
      priority: priority ?? this.priority,
      weight: weight ?? this.weight,
      createdTime: createdTime ?? this.createdTime,
      testTime: testTime ?? this.testTime,
      responseTime: responseTime ?? this.responseTime,
      balance: balance ?? this.balance,
      usedQuota: usedQuota ?? this.usedQuota,
      baseUrl: baseUrl ?? this.baseUrl,
      modelMapping: modelMapping ?? this.modelMapping,
      tag: tag ?? this.tag,
    );
  }
}

/// 渠道列表响应
class ChannelListResponse {
  final List<Channel> items;
  final int total;
  final int page;
  final int pageSize;

  ChannelListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory ChannelListResponse.fromJson(Map<String, dynamic> json) {
    return ChannelListResponse(
      items: (json['items'] as List)
          .map((item) => Channel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
    );
  }
}