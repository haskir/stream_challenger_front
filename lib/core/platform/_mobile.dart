import 'package:url_launcher/url_launcher.dart';

class WebPlatform {
  static Future<String> openAuthPopupAndWait(Uri authUrl) async {
    throw UnsupportedError('Web auth is not supported on this platform');
  }

  static openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
