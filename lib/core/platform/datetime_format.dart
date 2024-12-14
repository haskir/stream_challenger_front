import 'dart:convert';

import 'package:intl/intl.dart';

final dateTimeFormat = DateFormat;

String prettyJson(Map<String, dynamic> map) =>
    JsonEncoder.withIndent('  ').convert(map);
