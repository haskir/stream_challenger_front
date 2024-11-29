import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "images/gifs/stray228-tinker.gif",
        height: 500,
        width: 500,
      ),
    );
  }
}
