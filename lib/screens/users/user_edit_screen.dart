import 'package:flutter/material.dart';

/// 用户编辑页面（占位）
class UserEditScreen extends StatelessWidget {
  final int? userId;

  const UserEditScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userId == null ? '创建用户' : '编辑用户')),
      body: Center(child: Text(userId == null ? '创建用户' : '编辑用户 - ID: $userId')),
    );
  }
}