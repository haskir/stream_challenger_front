class _ApiPathDebug {
  static const url = 'localhost';
  static const prefix = 'api';

  static String get http => 'http://$url/$prefix/';
  static String get ws => 'ws://$url/$prefix/';
}

class _ApiPathSecured {
  static const url = 'front-stream-challenge.vibe-coder.fun';
  static const prefix = 'api';

  static String get http => 'https://$url/$prefix/';
  static String get ws => 'wss://$url/$prefix/';
}

class ApiProvider {
  static const bool isLocal = true;

  static String get http => isLocal ? _ApiPathDebug.http : _ApiPathSecured.http;
  static String get ws => isLocal ? _ApiPathDebug.ws : _ApiPathSecured.ws;
}
