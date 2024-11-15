import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/providers.dart';
import 'appbar_widgets/auth_widget.dart';
import 'appbar_widgets/balance_widget.dart';
import 'appbar_widgets/logo.dart';

class MainWidget extends ConsumerStatefulWidget {
  final Widget child;
  final Function(String) onLocaleChange;

  const MainWidget({
    super.key,
    required this.child,
    required this.onLocaleChange,
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
      body: widget.child,
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
            onPressed: () => context.go('/challenge_create'),
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
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'ru', child: Text('Русский')),
            ];
          },
          onSelected: (String value) =>
              ref.read(localeProvider.notifier).state = Locale(value),
        ),
      ],
    );
  }
}
