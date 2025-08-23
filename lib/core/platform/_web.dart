import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

import 'package:stream_challenge/utils/util.dart';

class Web {
  static Future<String> openAuthPopupAndWait(Uri authUrl) async {
    final completer = Completer<String>();
    final newWindow = openUrl(authUrl.toString(), "_blank");

    debugPrint("Opening auth URL: ${authUrl.toString()}");

    // Обработчик событий
    void messageHandler(web.MessageEvent event) {
      final token = event.data?.dartify() as String?;
      if (token != null) {
        newWindow?.close();
        completer.complete(token);
      }
    }

    // Добавляем listener
    void jsCallback(web.Event event) {
      if (event.instanceOfString("MessageEvent")) {
        messageHandler(event as web.MessageEvent);
      }
    }

    JSExportedDartFunction jsFn = jsCallback.toJS;
    web.window.addEventListener('message', jsFn);
    return await completer.future.whenComplete(() {
      web.window.removeEventListener('message', jsFn);
    });
  }

  static web.Window? openUrl(String url, [String name = "_self"]) => web.window.open(url, name);
}
