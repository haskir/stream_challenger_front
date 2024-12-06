import 'package:flutter/material.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/data/models/steamer_info.dart';
import 'dart:html' as html;

class Mixins {
  static Future<bool?> showConfDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocale.of(context).translate(mConfirmation)),
          content: Text(AppLocale.of(context).translate(mAreYouSure)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Отменить
              },
              child: Text(AppLocale.of(context).translate(mNo)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Подтвердить
              },
              child: Text(AppLocale.of(context).translate(mYes)),
            ),
          ],
        );
      },
    );
  }

  static Widget personInfo(ChallengePerson person, BuildContext context,
      [double radius = 15]) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: radius,
              backgroundImage: NetworkImage(person.urlImage),
            ),
            const SizedBox(width: 5),
            Text(
              person.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  static Widget streamerInfo(StreamerInfo streamerInfo, BuildContext context) {
/*     Widget isOnline(bool isOnline) {
      if (isOnline) {
        return Row(
          children: [
            Icon(Icons.circle, color: Colors.green, size: 14),
            const SizedBox(width: 5),
            Text(AppLocale.of(context).translate(mOnline)),
          ],
        );
      } else {
        return Row(
          children: [
            Icon(Icons.circle, color: Colors.red, size: 14),
            const SizedBox(width: 5),
            Text(AppLocale.of(context).translate(mOffline)),
          ],
        );
      }
    } */

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(streamerInfo.urlImage),
        ),
        const SizedBox(width: 5),
        Text(streamerInfo.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        //isOnline(streamerInfo),
      ],
    );
  }

  static Future showOpenURLDialog(BuildContext context, String url) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocale.of(context).translate(mOpenURL)),
          content: Text(url),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocale.of(context).translate(mCancel)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocale.of(context).translate(mOpen)),
              onPressed: () {
                openURL(url);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static String buildURLFromLogin(String login) => "https://twitch.tv/$login";
  static void openURL(String url) {
    html.window.open(url, "_blank");
  }
}
