import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/user_preferences.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'appbar_widgets/auth_widget.dart';
import 'appbar_widgets/balance_widget.dart';
import 'appbar_widgets/logo.dart';
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
            BottomPanel(), // Панель внизу
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
    final Preferences preferences = ref.watch(preferencesProvider);

    Row? titleWidget;

    if (authState.isAuthenticated) {
      titleWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => context.go('/challenge/lapkinastol'),
            child: Text(
                AppLocalizations.of(context).translate('Create Challenge')),
          ),
          TextButton(
            onPressed: () => context.go('/challenges'),
            child: Text(AppLocalizations.of(context).translate('Challenges')),
          ),
          TextButton(
              onPressed: () => context.go('/panel'),
              child: Text(AppLocalizations.of(context).translate('My Panel')))
        ],
      );
    }
    return AppBar(
      backgroundColor: Colors.blue[50],
      centerTitle: true,

      // Левые элементы
      leading: LogoWidget(onTap: () => context.go('/')),
      // Центральные элементы
      title: titleWidget,
      // Правые элементы
      actions: [
        BalanceWidget(),
        AuthWidget(),
        PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          itemBuilder: (context) {
            return [
              const PopupMenuItem(value: 'EN', child: Text('English')),
              const PopupMenuItem(value: 'RU', child: Text('Русский')),
            ];
          },
          initialValue: preferences.language,
          onSelected: (String value) async {
            await ref.read(preferencesProvider.notifier).updateLanguage(value);
          },
        ),
      ],
    );
  }
}
