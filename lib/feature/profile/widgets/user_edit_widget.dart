import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/consts.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/auth_state.dart';
import 'package:stream_challenge/data/models/user_preferences.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';
import 'package:stream_challenge/providers/providers.dart';

class UserEditDialog extends ConsumerStatefulWidget {
  const UserEditDialog({super.key});

  @override
  UserEditDialogState createState() => UserEditDialogState();
}

class UserEditDialogState extends ConsumerState<UserEditDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authStateProvider);
    Preferences preferences = ref.watch(preferencesProvider);

    return AlertDialog(
      title: Center(
        child: Text(AppLocale.of(context).translate(mSettingsEdit)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Поле для редактирования minimumInUSD
          if (["affiliate", "partner"]
              .contains(authState.user?.broadcasterType))
            TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocale.of(context).translate(mMinimumInUSD),
                hintText: preferences.minimumRewardInDollars.toString(),
              ),
            ),
          const SizedBox(height: 16),
          // Dropdown для выбора временной зоны
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocale.of(context).translate(mSelectTimezone)),
              DropdownButton<String>(
                value: preferences.timezone,
                onChanged: (String? newValue) {
                  setState(() {
                    preferences.timezone = newValue!;
                  });
                },
                items:
                    timezones.map<DropdownMenuItem<String>>((String timezone) {
                  return DropdownMenuItem<String>(
                    value: timezone,
                    child: Text(timezone),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocale.of(context).translate(mCancel)),
        ),
        ElevatedButton(
          onPressed: () {
            // Обновляем Preferences
            /* ref.read(preferencesProvider.notifier).update(
                  Preferences(
                    minimumInUSD: minimumInUSD,
                    timezone: _selectedTimezone, // Используем строку с временной зоной
                  ),
                ); */

            Navigator.of(context).pop();
          },
          child: Text(AppLocale.of(context).translate(mConfirm)),
        ),
      ],
    );
  }
}
