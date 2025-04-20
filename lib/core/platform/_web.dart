import 'dart:async';
import 'dart:html' as html;

import 'package:stream_challenge/utils/util.dart';

class WebPlatform {
  static Future<String> openAuthPopupAndWait(Uri authUrl) async {
    final completer = Completer<String>();
    final newWindow = openUrl(authUrl.toString(), "_blank");

    debugPrint("Opening auth URL: ${authUrl.toString()}");

    void messageHandler(html.Event event) {
      if (event is html.MessageEvent /* && event.origin == authUrl.origin*/) {
        final token = event.data;
        newWindow.close();
        completer.complete(token);
      }
    }

    html.window.addEventListener('message', messageHandler);

    return await completer.future.whenComplete(() {
      html.window.removeEventListener('message', messageHandler);
    });
  }

  static html.WindowBase openUrl(String url, [String name = "_self"]) => html.window.open(url, name);
}
