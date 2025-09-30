# New API Mobile Admin - 快速开始指南

## 📱 项目说明

这是 New API 的移动端管理客户端，使用 Flutter 开发，支持 iOS 和 Android 平台。

## ✨ 已实现功能

### ✅ 基础框架
- [x] 项目结构搭建
- [x] 依赖配置（pubspec.yaml）
- [x] 主题配置（亮色/暗色主题）
- [x] 路由配置（go_router）
- [x] API 服务封装

### ✅ 数据模型
- [x] User（用户模型）
- [x] Channel（渠道模型）
- [x] Log（日志模型）

### ✅ 服务层
- [x] ApiService（基础 HTTP 服务）
- [x] AuthService（认证服务）
- [x] UserService（用户 API）
- [x] ChannelService（渠道 API）
- [x] LogService（日志 API）

### ⏳ 待完善功能
- [ ] 登录页面 UI
- [ ] 主页底部导航
- [ ] 用户管理页面（列表、详情、编辑）
- [ ] 渠道管理页面（列表、详情、编辑、测试）
- [ ] 日志管理页面（列表、详情、统计）
- [ ] 状态管理（Riverpod Providers）
- [ ] 通用 UI 组件（卡片、徽章、空状态等）

---

## 🚀 快速开始

### 1. 环境要求

```bash
flutter --version
# Flutter SDK >= 3.0.0
# Dart SDK >= 3.0.0
```

### 2. 安装依赖

```bash
cd mobile
flutter pub get
```

### 3. 配置服务器地址

编辑 `lib/config/api_config.dart`：

```dart
static const String defaultBaseUrl = 'http://your-server.com';
// 例如: 'http://192.168.1.100:3000' 或 'https://api.example.com'
```

### 4. 运行项目

```bash
# iOS 模拟器
flutter run -d iPhone

# Android 模拟器
flutter run -d emulator-5554

# 真机
flutter devices  # 查看设备列表
flutter run -d <device-id>
```

### 5. 构建发布版本

```bash
# Android APK
flutter build apk --release
# 输出: build/app/outputs/flutter-apk/app-release.apk

# iOS (需要 macOS + Xcode)
flutter build ios --release
```

---

## 📂 项目结构

```
mobile/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── config/                      # 配置文件
│   │   ├── api_config.dart         # API 端点配置
│   │   ├── routes.dart             # 路由配置
│   │   └── theme.dart              # 主题配置
│   ├── models/                      # 数据模型
│   │   ├── user.dart               # 用户模型
│   │   ├── channel.dart            # 渠道模型
│   │   └── log.dart                # 日志模型
│   ├── services/                    # 服务层
│   │   ├── api_service.dart        # HTTP 基础服务
│   │   ├── auth_service.dart       # 认证服务
│   │   ├── user_service.dart       # 用户 API
│   │   ├── channel_service.dart    # 渠道 API
│   │   └── log_service.dart        # 日志 API
│   ├── providers/                   # 状态管理（待实现）
│   ├── screens/                     # 页面（占位中）
│   │   ├── login/
│   │   ├── home/
│   │   ├── users/
│   │   ├── channels/
│   │   └── logs/
│   └── widgets/                     # 通用组件（待实现）
├── pubspec.yaml                     # 依赖配置
└── README.md
```

---

## 🔧 开发说明

### 修改 API 地址

1. 打开 `lib/config/api_config.dart`
2. 修改 `defaultBaseUrl` 为你的服务器地址

### 添加新功能

1. 在 `lib/models/` 中定义数据模型
2. 在 `lib/services/` 中实现 API 调用
3. 在 `lib/screens/` 中创建页面
4. 在 `lib/config/routes.dart` 中配置路由

### 调试技巧

```bash
# 热重载（修改代码后立即生效）
按 r 键

# 热重启（重新启动应用）
按 R 键

# 查看日志
flutter logs

# 性能分析
flutter run --profile
```

---

## 📦 核心依赖说明

| 依赖 | 版本 | 用途 |
|-----|------|-----|
| flutter_riverpod | ^2.5.1 | 状态管理 |
| dio | ^5.4.3 | HTTP 网络请求 |
| flutter_secure_storage | ^9.0.0 | 安全存储（Token）|
| go_router | ^14.0.2 | 路由管理 |
| flutter_screenutil | ^5.9.0 | 屏幕适配 |
| fluttertoast | ^8.2.4 | Toast 提示 |

---

## 🐛 常见问题

### 1. 无法连接服务器

- 检查 `api_config.dart` 中的 `defaultBaseUrl`
- 确保移动设备和服务器在同一网络
- iOS 模拟器使用 `localhost`，Android 模拟器使用 `10.0.2.2`
- 真机使用局域网 IP（如 `192.168.1.100`）

### 2. 依赖安装失败

```bash
flutter clean
flutter pub get
```

### 3. iOS 编译错误

```bash
cd ios
pod install
cd ..
flutter run
```

### 4. Android 编译错误

- 检查 `android/app/build.gradle` 中的 `minSdkVersion >= 21`
- 确保安装了 Android SDK

---

## 🎨 下一步计划

1. **完善登录页面** - 实现美观的登录界面和表单验证
2. **实现用户管理** - 完整的用户 CRUD 功能
3. **实现渠道管理** - 渠道列表、测试、启用/禁用
4. **实现日志查看** - 日志列表、筛选、统计图表
5. **添加下拉刷新** - 所有列表页支持下拉刷新
6. **添加分页加载** - 滚动加载更多数据
7. **添加搜索功能** - 用户、渠道、日志搜索
8. **优化 UI/UX** - 提升用户体验和视觉效果

---

## 📞 技术支持

如有问题，请提交 Issue：https://github.com/Calcium-Ion/new-api/issues

---

## 📄 许可证

AGPL-3.0 License