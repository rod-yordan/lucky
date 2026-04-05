class ApiConfig {
  static const String baseUrl = 'https://luck-production-2830.up.railway.app';

  static const String apiUrl = '$baseUrl/api';
  static String get broadcastAuthUrl => '$baseUrl/api/broadcasting/auth';
  static String get chatMessageUrl => '$baseUrl/api/chat/message';
}
