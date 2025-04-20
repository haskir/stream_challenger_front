import 'dart:async';

import 'package:stream_challenge/utils/util.dart';
import 'package:url_launcher/url_launcher.dart';

class Web {
  static Future<String> openAuthPopupAndWait(Uri authUrl) async {
    final completer = Completer<String>();

    debugPrint("Opening auth URL: ${authUrl.toString()}");

    // Launch the URL in the default browser
    if (await canLaunchUrl(authUrl)) {
      await launchUrl(
        authUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception('Could not launch $authUrl');
    }

    // For mobile, you'll need to handle the callback differently
    // Typically this would be done via deep links or universal links
    // Here we just complete with a placeholder since mobile auth flows
    // usually require additional setup
    completer.complete("mobile_auth_token_placeholder");

    return completer.future;
  }

  static Future<void> openUrl(String url, [String name = "_self"]) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
