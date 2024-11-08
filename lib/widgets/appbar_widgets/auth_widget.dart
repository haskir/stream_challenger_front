import 'package:flutter/material.dart';
import 'package:stream_challenge/core/auth_client.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/auth_state.dart';

class AuthWidget extends StatefulWidget {
  final Function(String) onLocaleChange;

  const AuthWidget({super.key, required this.onLocaleChange});

  @override
  AuthWidgetState createState() => AuthWidgetState();
}

class AuthWidgetState extends State<AuthWidget> {
  final AuthServiceHTML authService = AuthServiceHTML();

  @override
  void initState() {
    super.initState();
    _loadToken();

    authService.authStateNotifier.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadToken() async {
    AuthState initialState = await authService.getState();
    authService.authStateNotifier.value = initialState;
  }

  @override
  void dispose() {
    authService.authStateNotifier.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthState authState = authService.authStateNotifier.value;

    if (authState.status == AuthStatus.authenticated) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(authState.user!.profileImageUrl),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () async {
                await authService.logout();
                setState(() {});
              },
              child: const Icon(Icons.logout),
            )
          ],
        ),
      );
    }

    return Center(
      child: TextButton(
        child: Text(AppLocalizations.of(context).translate('Auth')),
        onPressed: () async {
          await authService.auth(context);
        },
      ),
    );
  }
}
