import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'appbar_widgets/auth_widget.dart';
import 'appbar_widgets/balance_widget.dart';
import 'appbar_widgets/locale_widget.dart';
import 'appbar_widgets/logo.dart';
import 'appbar_widgets/theme_widget.dart';
// ignore: unused_import
import 'body_widgets/bottom_panel.dart';

class MainWidget extends ConsumerStatefulWidget {
  final Widget child;

  const MainWidget({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MainWidgetState();
  }
}

class _MainWidgetState extends ConsumerState<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
        child: Column(
          children: [
            Expanded(child: widget.child), // Основной контент
            //BottomPanel(), // Панель внизу
          ],
        ),
      ),
    );
  }
}

class _AppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<_AppBar> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    Row? titleWidget;

    if (authState.isAuthenticated) {
      titleWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => context.go('/challenge/lapkinastol'),
            child: Text(
              AppLocale.of(context).translate(mCreateChallenge),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
          TextButton(
            onPressed: () => context.go('/panel'),
            child: Text(
              AppLocale.of(context).translate(mMyPanel),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
          TextButton(
            onPressed: () => context.go('/profile'),
            child: Text(
              AppLocale.of(context).translate(mProfile),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
        ],
      );
    }
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,

      // Левые элементы
      leading: LogoWidget(),
      // Центральные элементы
      title: titleWidget,
      // Правые элементы
      actions: [
        BalanceWidget(),
        LocaleWidget(),
        const SizedBox(width: 8),
        ThemeWidget(),
        const SizedBox(width: 8),
        AuthWidget(),
        const SizedBox(width: 8),
      ],
    );
  }
}
