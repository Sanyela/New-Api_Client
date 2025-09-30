import 'package:flutter/material.dart';

/// 日志详情页面（占位）
class LogDetailScreen extends StatelessWidget {
  final int logId;

  const LogDetailScreen({super.key, required this.logId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('日志详情')),
      body: Center(child: Text('日志详情 - ID: $logId')),
    );
  }
}