import 'package:flutter/material.dart';
import '../models/log.dart';

/// 日志条目组件
class LogItem extends StatelessWidget {
  final Log log;
  final VoidCallback? onTap;

  const LogItem({
    super.key,
    required this.log,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: const Icon(Icons.history, color: Colors.white, size: 20),
        ),
        title: Text(
          log.modelName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('用户: ${log.username ?? "未知"} | ${log.typeName}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.token, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${log.totalTokens} tokens',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Icon(Icons.attach_money, size: 14, color: Colors.green),
                Text(
                  '\$${log.costDollar.toStringAsFixed(4)}',
                  style: const TextStyle(fontSize: 13, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        trailing: Text(
          log.relativeTimeString,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        onTap: onTap,
      ),
    );
  }
}