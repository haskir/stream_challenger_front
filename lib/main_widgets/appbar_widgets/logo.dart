import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.go('/'),
      icon: Image.asset('images/logo_553.png'),
      iconSize: 70,
    );
  }
}
