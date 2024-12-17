import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => context.go('/'),
        icon: Image.asset('images/logo_553.png'),
        iconSize: 60,
      ),
    );
  }
}
