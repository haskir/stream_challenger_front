import 'package:flutter/foundation.dart';

void debugPrint(dynamic message) {
  if (kDebugMode) print(message.toString());
}

class Util {}
