import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class Mixins {
  static Future<bool?> showConfDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocale.of(context).translate('Confirmation')),
          content: Text(AppLocale.of(context).translate('Are you sure?')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Отменить
              },
              child: Text(AppLocale.of(context).translate('No')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Подтвердить
              },
              child: Text(AppLocale.of(context).translate('Yes')),
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
}
