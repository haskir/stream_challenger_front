import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/auth_state.dart';
import 'package:stream_challenge/feature/profile/widgets/challenge_list_widget.dart';
import 'package:stream_challenge/feature/profile/widgets/transaction_list_widget.dart';
import 'package:stream_challenge/providers/providers.dart';

import 'widgets/profile_info_widget.dart';

final profilePageContentProvider =
    StateNotifierProvider<ProfilePageContentNotifier, String>((ref) {
  return ProfilePageContentNotifier('/');
});

class ProfilePageContentNotifier extends StateNotifier<String> {
  ProfilePageContentNotifier(super.initialPath);

  void setContent(String path) => state = path;
}

class ProfilePage extends ConsumerWidget {
  static const Map<String, String> titleHeaders = {
    '/': 'My profile',
    '/transactions': 'Transactions',
    '/my-challenges': 'My challenges',
    '/challenges-to-me': 'Challenges to me',
  };

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthToken? user = ref.watch(authStateProvider).user;
    if (user == null) {
      return const Center(child: Text('No user'));
    }

    final contentPath = ref.watch(profilePageContentProvider);
    // Левая панель-меню
    return Row(
      children: [
        Drawer(
          width: 250,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user.display_name),
                accountEmail: Text(user.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(user.profile_image_url),
                ),
              ),
              ListTile(
                title:
                    Text(AppLocalizations.of(context).translate('My profile')),
                onTap: () => ref
                    .read(profilePageContentProvider.notifier)
                    .setContent('/'),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('Transactions')),
                onTap: () => ref
                    .read(profilePageContentProvider.notifier)
                    .setContent('/transactions'),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('My challenges')),
                onTap: () => ref
                    .read(profilePageContentProvider.notifier)
                    .setContent('/my-challenges'),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('Challenges to me')),
                onTap: () => ref
                    .read(profilePageContentProvider.notifier)
                    .setContent('/challenges-to-me'),
              ),
            ],
          ),
        ),
        // Контент-панелька
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate(
                      ProfilePage.titleHeaders[contentPath] ?? contentPath),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    scrollbarOrientation: ScrollbarOrientation.right,
                    child: SingleChildScrollView(
                      primary: true, // Это важное изменение
                      child: _buildContent(contentPath, user),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContent(String contentPath, AuthToken user) {
    switch (contentPath) {
      case '/':
        return ProfileInfoCard(user: user);
      case '/transactions':
        return TransactionListWidget();
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
}
