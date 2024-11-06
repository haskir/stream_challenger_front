import 'package:flutter/material.dart';
import 'package:stream_challenge/feature/presentation/widgets/locale_widget.dart';
import 'package:stream_challenge/feature/presentation/widgets/logo.dart';

class TopBarWidget extends StatefulWidget {
  final ValueChanged<String> onLocaleChange;
  const TopBarWidget({super.key, required this.onLocaleChange});

  @override
  // ignore: no_logic_in_create_state
  TopBarWidgetState createState() => TopBarWidgetState();
}

class TopBarWidgetState extends State<TopBarWidget> {
  bool isUserLoggedIn = false;

  TopBarWidgetState();

  @override
  void initState() {
    super.initState();
    // Здесь можно добавить логику для проверки авторизации
    checkUserAuthStatus();
  }

  void checkUserAuthStatus() {
    // Пример проверки авторизации пользователя
    // Допустим, статус передается откуда-то, например, через Provider или напрямую
    setState(() {
      isUserLoggedIn = false; // или false в зависимости от логики авторизации
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const LogoWidget(),
        const Spacer(),
        LocaleWidget(onLocaleChange: widget.onLocaleChange),
      ],
    );
  }
}
