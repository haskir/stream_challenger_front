import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

class Mixins {
  static Future<bool?> showConfDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('Confirmation')),
          content:
              Text(AppLocalizations.of(context).translate('Are you sure?')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Отменить
              },
              child: Text(AppLocalizations.of(context).translate('No')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Подтвердить
              },
              child: Text(AppLocalizations.of(context).translate('Yes')),
            ),
          ],
        );
      },
    );
  }
}
