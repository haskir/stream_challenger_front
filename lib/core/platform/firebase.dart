import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Уведомления разрешены');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Уведомления разрешены временно');
    } else {
      print('Уведомления запрещены');
    }
  }

  Future getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }
}

final firebaseProvider = Provider<FirebaseService>((ref) => FirebaseService());
