import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const originalScreenHeight = 568;
const originalScreenWidth = 320;

Map<dynamic, double> _cachedWidths = {};
Map<dynamic, double> _cachedHeights = {};

class Ui {
  static Size _getLogicalSize(BuildContext context) {
    final view = View.of(context);
    return view.physicalSize / view.devicePixelRatio;
  }

  static void setSystemUIOverlayStyle(BuildContext context) {
    bool isBuiltForIos = Theme.of(context).platform == TargetPlatform.iOS;
    Brightness statusBarBrightness = isBuiltForIos ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: statusBarBrightness,
      ),
    );
  }

  static double getProportionalHeight(BuildContext context, double originalSize) {
    if (_cachedHeights[originalSize] != null) {
      return originalSize * _cachedHeights[context]! / originalScreenHeight;
    }
    final size = _getLogicalSize(context);
    final result = originalSize * size.height / originalScreenHeight;
    _cachedHeights[originalSize] = result;
    return result;
  }

  static double getProportionalWidth(BuildContext context, double originalSize) {
    if (_cachedWidths[originalSize] != null) {
      return originalSize * _cachedWidths[context]! / originalScreenWidth;
    }
    final size = _getLogicalSize(context);
    final result = originalSize * size.width / originalScreenWidth;
    _cachedWidths[originalSize] = result;
    return result;
  }
}
