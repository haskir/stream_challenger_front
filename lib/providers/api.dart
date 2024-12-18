class _ApiPathDebug {
  static const url = 'localhost';
  static const prefix = 'api';
  static const port = 80;

  static String get http => 'http://$url:$port/$prefix/';
  static String get ws => 'ws://$url:$port/$prefix/';
}

class _ApiPathSecured {
  static const url = 'direct-api.haskir.keenetic.link';
  static const prefix = 'api';

  static String get http => 'https://$url/$prefix/';
  static String get ws => 'wss://$url/$prefix/';
}

class ApiProvider {
  static const bool debug = true;

  static String get http => debug ? _ApiPathDebug.http : _ApiPathSecured.http;
  static String get ws => debug ? _ApiPathDebug.ws : _ApiPathSecured.ws;
}
