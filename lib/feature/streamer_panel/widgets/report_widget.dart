import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class ReportWidget extends StatefulWidget {
  final int challengeId;

  const ReportWidget({
    super.key,
    required this.challengeId,
  });

  @override
  ReportWidgetState createState() => ReportWidgetState();
}

class ReportWidgetState extends State<ReportWidget> {
  String? _selectedReason;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocale.of(context).translate("Report Challenge")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: RadioListTile<String>(
                  title: Text(AppLocale.of(context).translate("Spam")),
                  value: "Spam",
                  groupValue: _selectedReason,
                  onChanged: (value) => setState(() => _selectedReason = value),
                ),
              ),
              Flexible(
                child: RadioListTile<String>(
                  title: Text(AppLocale.of(context).translate("Harassment")),
                  value: "Harassment",
                  groupValue: _selectedReason,
                  onChanged: (value) => setState(() => _selectedReason = value),
                ),
              ),
              Flexible(
                child: RadioListTile<String>(
                  title: Text(AppLocale.of(context).translate("Other")),
                  value: "Other",
                  groupValue: _selectedReason,
                  onChanged: (value) => setState(() => _selectedReason = value),
                ),
              ),
            ],
          ),
          if (_selectedReason == "Other") ...[
            SizedBox(height: 10),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: AppLocale.of(context).translate("Please specify"),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(AppLocale.of(context).translate("Cancel")),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedReason != null) {
              final dto = CreateReportDTO(
                challengeId: widget.challengeId,
                reason: _selectedReason!,
                comment:
                    _selectedReason == "Other" ? _textController.text : null,
              );
              Navigator.of(context).pop(dto);
            }
          },
          child: Text(AppLocale.of(context).translate("Confirm")),
        ),
      ],
    );
  }
}
