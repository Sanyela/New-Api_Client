import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../models/user.dart';
import '../../widgets/status_badge.dart';

/// 用户详情页面
class UserDetailScreen extends ConsumerWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('用户详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/users/$userId/edit');
            },
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) => _buildUserDetail(context, user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('加载失败: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(userDetailProvider(userId));
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetail(BuildContext context, User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户头像和基本信息
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        user.isEnabled ? Colors.green : Colors.grey,
                    child: Text(
                      user.username[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName ?? user.username,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${user.username}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        StatusBadge(
                          text: user.statusName,
                          color: user.isEnabled ? Colors.green : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 详细信息
          Card(
            child: Column(
              children: [
                _buildInfoRow('用户 ID', user.id.toString()),
                const Divider(),
                _buildInfoRow('用户名', user.username),
                const Divider(),
                _buildInfoRow('显示名称', user.displayName ?? '-'),
                const Divider(),
                _buildInfoRow('角色', user.roleName),
                const Divider(),
                _buildInfoRow('邮箱', user.email ?? '-'),
                const Divider(),
                _buildInfoRow('分组', user.group ?? 'default'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 额度信息
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '额度信息',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuotaRow(
                    '总额度',
                    '\$${user.totalQuotaDollar.toStringAsFixed(2)}',
                    Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  _buildQuotaRow(
                    '已使用',
                    '\$${user.usedQuotaDollar.toStringAsFixed(2)}',
                    Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  _buildQuotaRow(
                    '剩余额度',
                    '\$${user.remainingQuota.toStringAsFixed(2)}',
                    user.remainingQuota > 0 ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: user.usagePercentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      user.usagePercentage > 90
                          ? Colors.red
                          : user.usagePercentage > 70
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '使用率: ${user.usagePercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}