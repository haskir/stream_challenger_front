import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';

class IsOnlineStatusWidget extends ConsumerStatefulWidget {
  final String login;

  const IsOnlineStatusWidget({super.key, required this.login});

  @override
  createState() => _IsOnlineStatusWidgetState();
}

class _IsOnlineStatusWidgetState extends ConsumerState<IsOnlineStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ref.read(isOnlineProvider(widget.login).future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          print(snapshot.data);
          print("Error: ${snapshot.error.toString()}");
          return Container();
        } else if (snapshot.hasData) {
          final isOnline = snapshot.data!;
          return Row(
            children: [
              Icon(
                Icons.circle,
                color: isOnline ? Colors.green : Colors.red,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                isOnline
                    ? AppLocale.of(context).translate(mOnline)
                    : AppLocale.of(context).translate(mOffline),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
