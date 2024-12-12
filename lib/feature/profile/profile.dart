import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/feature/profile/widgets/challenge_list_widget.dart';
import 'package:stream_challenge/feature/profile/widgets/transaction_list_widget.dart';

import 'widgets/profile_info_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const Map<String, String> titleHeaders = {
    '/profile': 'My profile',
    '/profile/transactions': 'Transactions',
    '/profile/my-challenges': 'My challenges',
    '/profile/challenges-to-me': 'Challenges to me',
  };

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, int> _pathToIndex = {
    '/profile': 0,
    '/profile/transactions': 1,
    '/profile/my-challenges': 2,
    '/profile/challenges-to-me': 3,
  };

  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Сопоставляем текущий путь с индексом
    final currentPath = GoRouter.of(context).state!.fullPath;
    _currentIndex = _pathToIndex[currentPath] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Drawer(
          width: 250,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerItem(
                context,
                title: AppLocale.of(context).translate(mMyProfile),
                path: '/profile',
                index: 0,
              ),
              _buildDrawerItem(
                context,
                title: AppLocale.of(context).translate(mTransactions),
                path: '/profile/transactions',
                index: 1,
              ),
              _buildDrawerItem(
                context,
                title: AppLocale.of(context).translate(mMyChallenges),
                path: '/profile/my-challenges',
                index: 2,
              ),
              _buildDrawerItem(
                context,
                title: AppLocale.of(context).translate(mChallengesToMe),
                path: '/profile/challenges-to-me',
                index: 3,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      const ProfileInfoCard(),
                      const TransactionListWidget(),
                      const ChallengesListWidget(
                        isAuthor: true,
                        key: ValueKey(true),
                      ),
                      const ChallengesListWidget(
                        isAuthor: false,
                        key: ValueKey(false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required String title, required String path, required int index}) {
    return ListTile(
      title: Text(title),
      selected: _currentIndex == index,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: () {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
          context.go(path);
        }
      },
    );
  }
}
