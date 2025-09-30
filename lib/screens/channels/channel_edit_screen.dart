import 'package:flutter/material.dart';

/// 渠道编辑页面（占位）
class ChannelEditScreen extends StatelessWidget {
  final int channelId;

  const ChannelEditScreen({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('编辑渠道')),
      body: Center(child: Text('编辑渠道 - ID: $channelId')),
    );
  }
}