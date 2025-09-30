/// 用户模型
class User {
  final int id;
  final String username;
  final String? displayName;
  final int role;
  final int status;
  final int quota;
  final int usedQuota;
  final String? email;
  final String? group;
  final int? affCode;
  final int createdTime;

  User({
    required this.id,
    required this.username,
    this.displayName,
    required this.role,
    required this.status,
    required this.quota,
    required this.usedQuota,
    this.email,
    this.group,
    this.affCode,
    required this.createdTime,
  });

  /// 从 JSON 解析
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      role: json['role'] as int,
      status: json['status'] as int,
      quota: json['quota'] as int? ?? 0,
      usedQuota: json['used_quota'] as int? ?? 0,
      email: json['email'] as String?,
      group: json['group'] as String?,
      affCode: json['aff_code'] as int?,
      createdTime: json['created_time'] as int,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'role': role,
      'status': status,
      'quota': quota,
      'used_quota': usedQuota,
      'email': email,
      'group': group,
      'aff_code': affCode,
      'created_time': createdTime,
    };
  }

  /// 角色名称
  String get roleName {
    switch (role) {
      case 1:
        return '普通用户';
      case 10:
        return '管理员';
      case 100:
        return '超级管理员';
      default:
        return '未知';
    }
  }

  /// 状态名称
  String get statusName {
    return status == 1 ? '已启用' : '已禁用';
  }

  /// 是否启用
  bool get isEnabled => status == 1;

  /// 剩余额度（美元）
  double get remainingQuota {
    return (quota - usedQuota) / 500000.0;
  }

  /// 已使用额度（美元）
  double get usedQuotaDollar {
    return usedQuota / 500000.0;
  }

  /// 总额度（美元）
  double get totalQuotaDollar {
    return quota / 500000.0;
  }

  /// 使用百分比
  double get usagePercentage {
    if (quota == 0) return 0;
    return (usedQuota / quota * 100).clamp(0, 100);
  }

  /// 是否是管理员
  bool get isAdmin => role >= 10;

  /// 是否是超级管理员
  bool get isRoot => role >= 100;

  /// 复制对象
  User copyWith({
    int? id,
    String? username,
    String? displayName,
    int? role,
    int? status,
    int? quota,
    int? usedQuota,
    String? email,
    String? group,
    int? affCode,
    int? createdTime,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      status: status ?? this.status,
      quota: quota ?? this.quota,
      usedQuota: usedQuota ?? this.usedQuota,
      email: email ?? this.email,
      group: group ?? this.group,
      affCode: affCode ?? this.affCode,
      createdTime: createdTime ?? this.createdTime,
    );
  }
}

/// 用户列表响应
class UserListResponse {
  final List<User> items;
  final int total;
  final int page;
  final int pageSize;

  UserListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    return UserListResponse(
      items: (json['items'] as List)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
    );
  }
}