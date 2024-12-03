import 'package:flutter/material.dart';

const Set<String> timezones = {
  'UTC+0',
  'UTC+1',
  'UTC+2',
  'UTC+3',
  'UTC+4',
  'UTC+5',
  'UTC+6',
  'UTC+7',
  'UTC+8',
  'UTC+9',
  'UTC+10',
  'UTC+11',
  'UTC+12',
  'UTC-1',
  'UTC-2',
  'UTC-3',
  'UTC-4',
  'UTC-5',
  'UTC-6',
  'UTC-7',
  'UTC-8',
  'UTC-9',
  'UTC-10',
  'UTC-11',
  'UTC-12',
};

const Map<String, String> challengesStatusHeaders = {
  'ACCEPTED': "Accepted Challenges",
  "ENDED": "Waiting for voting",
  'PENDING': "New Challenges",
  'REJECTED': "Rejected Challenges",
  'FAILED': "Failed Challenges",
  'HIDDEN': "Hidden Challenges",
  'SUCCESSFUL': "Successful Challenges",
};
const Map<String, Color> challengesStatusColors = {
  'ACCEPTED': Colors.blue,
  'ENDED': Colors.yellow,
  'PENDING': Colors.orange,
  'REJECTED': Colors.red,
  'FAILED': Colors.black,
  'HIDDEN': Colors.grey,
  'SUCCESSFUL': Colors.green,
};
