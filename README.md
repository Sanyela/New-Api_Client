# New API Mobile Admin

New API 移动端管理客户端 - 轻量级管理工具

## 功能特性

- 👥 **用户管理** - 查看、创建、编辑、删除用户
- 🔌 **渠道管理** - 管理 AI 服务渠道，启用/禁用、测试连接
- 📊 **使用日志** - 查看 API 请求日志和费用统计

## 技术栈

- **框架**: Flutter 3.x
- **语言**: Dart 3.x
- **状态管理**: Riverpod
- **网络请求**: Dio
- **本地存储**: flutter_secure_storage + shared_preferences
- **路由**: go_router

## 快速开始

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- iOS 12.0+ / Android 5.0+

### 安装依赖

```bash
cd mobile
flutter pub get
```

### 配置服务器地址

编辑 `lib/config/api_config.dart`，修改服务器地址：

```dart
static const String defaultBaseUrl = 'https://your-server.com';
```

### 运行项目

```bash
# iOS 模拟器
flutter run -d iPhone

# Android 模拟器
flutter run -d emulator

# 真机调试
flutter run
```

### 构建发布版本

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── config/                      # 配置文件
│   ├── api_config.dart         # API 配置
│   ├── routes.dart             # 路由配置
│   └── theme.dart              # 主题配置
├── models/                      # 数据模型
│   ├── user.dart
│   ├── channel.dart
│   └── log.dart
├── services/                    # 服务层
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── user_service.dart
│   ├── channel_service.dart
│   └── log_service.dart
├── providers/                   # 状态管理
│   ├── auth_provider.dart
│   ├── user_provider.dart
│   ├── channel_provider.dart
│   └── log_provider.dart
├── screens/                     # 页面
│   ├── login/
│   ├── home/
│   ├── users/
│   ├── channels/
│   └── logs/
└── widgets/                     # 通用组件
    ├── user_card.dart
    ├── channel_card.dart
    ├── log_item.dart
    ├── status_badge.dart
    └── empty_state.dart
```

## API 对接

本应用对接 New API 后端的以下接口：

- `POST /api/user/login` - 用户登录
- `GET /api/user/` - 获取用户列表
- `GET /api/channel/` - 获取渠道列表
- `GET /api/log/` - 获取日志列表

详细 API 文档请参考：https://docs.newapi.pro/api

## 许可证

AGPL-3.0 License

## 作者

基于 [New API](https://github.com/Calcium-Ion/new-api) 项目开发