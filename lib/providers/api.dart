class _ApiPathDebug {
  static const url = 'localhost';
  static const prefix = 'api';
  static const port = 8400;

  static String get http => 'http://$url:$port/$prefix/';
  static String get ws => 'ws://$url:$port/$prefix/';
}

class _ApiPathSecured {
  static const url = 'stream-challenge-api.haskir.keenetic.link';
  static const prefix = 'api';

  static String get http => 'https://$url/$prefix/';
  static String get ws => 'wss://$url/$prefix/';
}

class ApiProvider {
  static const bool isLocal = true;

  static String get http => isLocal ? _ApiPathDebug.http : _ApiPathSecured.http;
  static String get ws => isLocal ? _ApiPathDebug.ws : _ApiPathSecured.ws;
}
