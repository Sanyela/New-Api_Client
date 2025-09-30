import 'package:flutter/material.dart';

/// 渠道详情页面（占位）
class ChannelDetailScreen extends StatelessWidget {
  final int channelId;

  const ChannelDetailScreen({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('渠道详情')),
      body: Center(child: Text('渠道详情 - ID: $channelId')),
    );
  }
}