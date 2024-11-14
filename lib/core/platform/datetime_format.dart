import 'dart:convert';

import 'package:intl/intl.dart';

final dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");

String prettyJson(Map<String, dynamic> map) =>
    JsonEncoder.withIndent('  ').convert(map);
