import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Image.asset(r'assets/images/logo_553.png', width: 50, height: 50),
      const SizedBox(
        width: 8,
      ),
      const Text('STREAM-CHALLENGE')
    ]);
  }
}
