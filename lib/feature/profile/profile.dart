// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/auth_state.dart';
import 'package:stream_challenge/feature/profile/widgets/challenges_list_widget.dart';
import 'package:stream_challenge/feature/profile/widgets/transaction_list_widget.dart';
import 'package:stream_challenge/providers/providers.dart';

class ProfilePage extends ConsumerWidget {
  static const Map<String, String> titleHeaders = {
    '/': 'My profile',
    '/transactions': 'Transactions',
    '/my-challenges': 'My challenges',
    '/challenges': 'Challenges',
  };
  final String path;
  const ProfilePage({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthToken? user = ref.watch(authStateProvider).user;
    if (user == null) {
      return const Center(child: Text('No user'));
    }

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
                onTap: () => context.go('/profile'),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('Transactions')),
                onTap: () => context.go('/profile/transactions'),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('My challenges')),
                onTap: () => context.go('/profile/my-challenges'),
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
                Text(
                  AppLocalizations.of(context)
                      .translate(ProfilePage.titleHeaders[path] ?? path),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
                if (path == '/') ProfileInfoCard(user: user),
                if (path == '/transactions') TransactionListWidget(),
                if (path == '/my-challenges') ChallengesListWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final AuthToken user;

  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate('Main info'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 16),
            InfoRow(
              label: AppLocalizations.of(context).translate('Name'),
              value: user.display_name,
            ),
            InfoRow(
              label: AppLocalizations.of(context).translate('Login'),
              value: user.login,
            ),
            InfoRow(label: 'Email', value: user.email),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
