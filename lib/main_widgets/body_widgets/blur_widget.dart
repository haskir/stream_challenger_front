import 'dart:ui';

import 'package:flutter/material.dart';

class BlurAndBlock extends StatelessWidget {
  final bool isLoading;
  final double blurIntensity;
  final Widget? loadingIndicator;

  const BlurAndBlock({
    super.key,
    this.isLoading = true,
    this.blurIntensity = 5.0,
    this.loadingIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isLoading,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isLoading ? 1.0 : 0.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Blur effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurIntensity,
                  sigmaY: blurIntensity,
                ),
                child: Container(color: Colors.transparent),
              ),
            ),
            // Loading indicator
            if (isLoading)
              Center(
                child: loadingIndicator ?? const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
