import 'package:flutter/material.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/models/challenge.dart';

class ReportDialog extends StatefulWidget {
  final int challengeId;

  const ReportDialog({
    super.key,
    required this.challengeId,
  });

  @override
  ReportDialogState createState() => ReportDialogState();
}

class ReportDialogState extends State<ReportDialog> {
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
      title: Text(AppLocale.of(context).translate(mReportChallenge)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: RadioListTile<String>(
                  title: Text(AppLocale.of(context).translate(mSpam)),
                  value: "Spam",
                  groupValue: _selectedReason,
                  onChanged: (value) => setState(() => _selectedReason = value),
                ),
              ),
              Flexible(
                child: RadioListTile<String>(
                  title: Text(AppLocale.of(context).translate(mHarassment)),
                  value: "Harassment",
                  groupValue: _selectedReason,
                  onChanged: (value) => setState(() => _selectedReason = value),
                ),
              ),
              Flexible(
                child: RadioListTile<String>(
                  title: Text(AppLocale.of(context).translate(mOther)),
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
                labelText: AppLocale.of(context).translate(mPleaseSpecify),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(AppLocale.of(context).translate(mCancel)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedReason != null) {
              final dto = CreateReportDTO(
                challengeId: widget.challengeId,
                reason: _selectedReason!,
                comment: _selectedReason == "Other" ? _textController.text : null,
              );
              Navigator.of(context).pop(dto);
            }
          },
          child: Text(AppLocale.of(context).translate(mReport)),
        ),
      ],
    );
  }
}
