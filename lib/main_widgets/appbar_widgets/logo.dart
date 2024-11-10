import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final VoidCallback onTap;
  const LogoWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child:
            Image.asset('assets/images/logo_553.png', width: 50, height: 50));
  }
}
