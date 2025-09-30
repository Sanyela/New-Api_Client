import 'package:flutter/material.dart';
import '../models/channel.dart';
import 'status_badge.dart';

/// 渠道卡片组件
class ChannelCard extends StatelessWidget {
  final Channel channel;
  final VoidCallback? onTap;

  const ChannelCard({
    super.key,
    required this.channel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: channel.isEnabled ? Colors.blue : Colors.grey,
          child: Text(
            channel.typeName[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          channel.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${channel.typeName} | ID: ${channel.id}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.speed,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  channel.responseTimeText,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.attach_money,
                  size: 14,
                  color: Colors.green,
                ),
                Text(
                  '${channel.balance.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 13, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusBadge(
              text: channel.statusName,
              color: channel.isEnabled
                  ? Colors.green
                  : (channel.status == 2 ? Colors.orange : Colors.red),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}