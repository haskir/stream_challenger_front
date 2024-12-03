import 'package:flutter/material.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class ReportInfoWidget extends StatelessWidget {
  final Report report;
  const ReportInfoWidget({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(report.toString()),
    );
  }
}
