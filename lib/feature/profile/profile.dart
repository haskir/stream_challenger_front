import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/auth_state.dart';
import 'package:stream_challenge/providers/providers.dart';

import 'widgets/ch_lists/challenge_list_widget.dart';
import 'widgets/profile_info_widget.dart';
import 'widgets/tr_list/transaction_list_builder.dart';

final profilePageContentProvider =
    StateNotifierProvider<ProfilePageContentNotifier, String>((ref) {
  return ProfilePageContentNotifier('/');
});

class ProfilePageContentNotifier extends StateNotifier<String> {
  ProfilePageContentNotifier(super.initialPath);

  void setContent(String path) => state = path;
}

class ProfilePage extends ConsumerStatefulWidget {
  static const Map<String, String> titleHeaders = {
    '/': 'My profile',
    '/transactions': 'Transactions',
    '/my-challenges': 'My challenges',
    '/challenges-to-me': 'Challenges to me',
  };

  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool isCollapsed = false; // Состояние сворачивания меню
  bool onAnimation = false;

  @override
  Widget build(BuildContext context) {
    final AuthedUser? user = ref.watch(authStateProvider).user;
    final currentContent = ref.watch(profilePageContentProvider);

    if (user == null) {
      return const Center(child: Text('No user'));
    }

    final contentPath = ref.watch(profilePageContentProvider);

    return Row(
      children: [
        // Боковое collapsible меню
        AnimatedContainer(
          onEnd: () => setState(() {
            onAnimation = false;
          }),
          duration: const Duration(milliseconds: 150), // Анимация
          width: isCollapsed ? 70 : 250, // Ширина меню
          child: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка сворачивания/разворачивания
                IconButton(
                  icon: Icon(
                    isCollapsed ? Icons.arrow_forward : Icons.arrow_back,
                  ),
                  onPressed: () {
                    setState(() {
                      isCollapsed = !isCollapsed;
                      onAnimation = true;
                    });
                  },
                ),
                // Меню
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildMenuItem(
                        context,
                        mMyProfile,
                        '/',
                        currentContent,
                        Icons.person,
                      ),
                      _buildMenuItem(
                        context,
                        mTransactions,
                        '/transactions',
                        currentContent,
                        Icons.payment,
                      ),
                      _buildMenuItem(
                        context,
                        mMyChallenges,
                        '/my-challenges',
                        currentContent,
                        Icons.flag,
                      ),
                      _buildMenuItem(
                        context,
                        mChallengesToMe,
                        '/challenges-to-me',
                        currentContent,
                        Icons.assignment_turned_in,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Контент
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    scrollbarOrientation: ScrollbarOrientation.right,
                    child: SingleChildScrollView(
                      primary: true,
                      child: _buildContent(contentPath, user),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Метод для создания пунктов меню
  Widget _buildMenuItem(BuildContext context, String title, String path,
      String currentContent, IconData icon) {
    return ListTile(
      leading: Icon(icon), // Иконка для компактного меню
      title: (isCollapsed || onAnimation)
          ? null
          : Text(AppLocale.of(context).translate(title)),
      selected: currentContent == path,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: () =>
          ref.read(profilePageContentProvider.notifier).setContent(path),
    );
  }
}

Widget _buildContent(String contentPath, AuthedUser user) {
  switch (contentPath) {
    case '/':
      return ProfileInfoCard();
    case '/transactions':
      return TransactionsListWidget();
    case '/my-challenges':
      return ChallengesListWidget(
        isAuthor: true,
        key: ValueKey(true),
      );
    case '/challenges-to-me':
      return ChallengesListWidget(
        isAuthor: false,
        key: ValueKey(false),
      );
    default:
      return Container();
  }
}
