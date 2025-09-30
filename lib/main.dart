import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 API 服务
  await ApiService().init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro 设计尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'New API Admin',
          debugShowCheckedModeBanner: false,

          // 主题
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,

          // 路由
          routerConfig: AppRoutes.router,

          // 国际化（可选）
          // locale: const Locale('zh', 'CN'),
          // localizationsDelegates: const [],
          // supportedLocales: const [
          //   Locale('zh', 'CN'),
          //   Locale('en', 'US'),
          // ],
        );
      },
    );
  }
}