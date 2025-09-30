/// API 配置文件
class ApiConfig {
  // 默认服务器地址（请修改为你的服务器地址）
  static const String defaultBaseUrl = 'http://localhost:3000';

  // API 端点
  static const String loginEndpoint = '/api/user/login';
  static const String logoutEndpoint = '/api/user/logout';
  static const String statusEndpoint = '/api/status';

  // 用户相关
  static const String usersEndpoint = '/api/user/';
  static const String userSearchEndpoint = '/api/user/search';

  // 渠道相关
  static const String channelsEndpoint = '/api/channel/';
  static const String channelSearchEndpoint = '/api/channel/search';
  static const String channelTestEndpoint = '/api/channel/test';

  // 日志相关
  static const String logsEndpoint = '/api/log/';
  static const String logSearchEndpoint = '/api/log/search';
  static const String logStatEndpoint = '/api/log/stat';

  // 请求超时配置
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);

  // 分页配置
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}