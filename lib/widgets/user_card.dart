import 'package:flutter/material.dart';
import '../models/user.dart';
import 'status_badge.dart';

/// 用户卡片组件
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: user.isEnabled ? Colors.green : Colors.grey,
          child: Text(
            user.username[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          user.displayName ?? user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('ID: ${user.id} | ${user.roleName}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 14,
                  color: user.remainingQuota > 0 ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '剩余额度: \$${user.remainingQuota.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: user.remainingQuota > 0 ? Colors.green : Colors.red,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusBadge(
              text: user.statusName,
              color: user.isEnabled ? Colors.green : Colors.grey,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}