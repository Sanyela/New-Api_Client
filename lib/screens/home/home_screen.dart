import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../users/user_list_screen.dart';
import '../channels/channel_list_screen.dart';
import '../logs/log_list_screen.dart';
import '../../providers/auth_provider.dart';

/// 主页（带底部导航）
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    UserListScreen(),
    ChannelListScreen(),
    LogListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '用户管理',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.router),
            label: '渠道管理',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '使用日志',
          ),
        ],
      ),
    );
  }
}