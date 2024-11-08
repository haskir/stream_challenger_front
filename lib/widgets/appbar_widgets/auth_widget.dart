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
  AuthState authState = AuthState(status: AuthStatus.unauthenticated);

  @override
  void initState() {
    _loadToken();
    super.initState();
  }

  Future<void> _loadToken() async {
    authState = await authService.getState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (authState.status == AuthStatus.authenticated) {
      return Center(
        child: Row(
          children: [
            CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(authState.user!.profileImageUrl)),
            const SizedBox(width: 15),
            GestureDetector(
                onTap: () => {authService.logout()},
                child: const Icon(Icons.logout))
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
