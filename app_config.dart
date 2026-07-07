class AppConfig {
  static const String serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'http://YOUR_SERVER_IP:3000',
  );
}
