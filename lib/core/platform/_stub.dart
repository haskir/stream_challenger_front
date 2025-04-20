class WebPlatform {
  static Future<String> openAuthPopupAndWait(Uri authUrl) async {
    throw UnsupportedError('Web auth is not supported on this platform');
  }

  static dynamic openUrl(String url) {
    throw UnsupportedError('openUrl is not supported on this platform');
  }
}
