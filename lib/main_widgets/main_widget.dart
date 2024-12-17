import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'appbar_widgets/settings_widget.dart';
import 'appbar_widgets/balance_widget.dart';
import 'appbar_widgets/logo.dart';
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
  bool isEnoughSpace = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    Widget? titleWidget;

    if (authState.isAuthenticated) {
      titleWidget = isEnoughSpace
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            )
          : null;
    }
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,

      // Левые элементы
      leading: LogoWidget(),

      // Центральные элементы с прокруткой
      title: titleWidget,

      // Правые элементы
      actions: [
        BalanceWidget(),
        AuthWidget(),
        const SizedBox(width: 8),
      ],
    );
  }
}
