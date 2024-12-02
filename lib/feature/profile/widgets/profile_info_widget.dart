import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/auth_state.dart';

import 'user_edit_widget.dart';

class ProfileInfoCard extends StatelessWidget {
  final AuthToken user;

  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocale.of(context).translate('Main info'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => UserEditDialog(),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            InfoRow(
              label: AppLocale.of(context).translate('Login'),
              value: user.login,
            ),
            InfoRow(label: 'Email', value: user.email),
            InfoRow(
              label: AppLocale.of(context).translate('Broadcaster type'),
              value: user.broadcasterType,
            ),
            if (kDebugMode) InfoRow(label: 'ID', value: user.id.toString()),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(
              child:
                  Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
