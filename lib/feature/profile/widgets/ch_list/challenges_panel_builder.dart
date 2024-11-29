import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers/challenge_provider.dart';

import 'challenge_view_widget.dart';

class ChallengesPanel extends ConsumerStatefulWidget {
  final bool isAuthor;
  final Map<String, bool> expandedStates;
  late final FutureProviderFamily<List<Challenge>?, GetStruct>
      challengesProvider;

  ChallengesPanel({
    super.key,
    required this.expandedStates,
    required this.isAuthor,
  }) : challengesProvider =
            isAuthor ? authorChallengesProvider : performerChallengesProvider;

  @override
  ConsumerState<ChallengesPanel> createState() => _ChallengesPanelState();
}

class _ChallengesPanelState extends ConsumerState<ChallengesPanel>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  static const Map<String, String> headers = {
    'PENDING': "New Challenges",
    'ACCEPTED': "Accepted Challenges",
    'REJECTED': "Rejected Challenges",
    'SUCCESSFUL': "Successful Challenges",
    'FAILED': "Failed Challenges",
    'CANCELLED': "Cancelled Challenges",
  };

  static const Map<String, Color> colors = {
    "PENDING": Colors.orange,
    "ACCEPTED": Colors.blue,
    "REJECTED": Colors.red,
    "SUCCESSFUL": Colors.green,
    "FAILED": Colors.black,
    "CANCELLED": Colors.grey,
  };

  final Map<String, PagingController<int, Challenge>> pagingControllers = {
    "PENDING": PagingController(firstPageKey: 1),
    "ACCEPTED": PagingController(firstPageKey: 1),
    "REJECTED": PagingController(firstPageKey: 1),
    "SUCCESSFUL": PagingController(firstPageKey: 1),
    "FAILED": PagingController(firstPageKey: 1),
    "CANCELLED": PagingController(firstPageKey: 1),
  };

  final Map<String, bool> hasLoaded = {}; // Флаг для отслеживания загрузки
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: headers.length, vsync: this);
    final firstStatus = headers.keys.first;
    _fetchPage(firstStatus, 1);
  }

  @override
  void dispose() {
    pagingControllers.forEach((_, controller) => controller.dispose());
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(String status, int pageKey) async {
    if (hasLoaded[status] == true) return;

    final provider = ref.read(widget
        .challengesProvider(GetStruct(status: status, page: pageKey, size: 10))
        .future);

    hasLoaded[status] = true;

    try {
      final challenges = await provider;

      if (challenges == null || challenges.isEmpty) {
        pagingControllers[status]!.appendLastPage([]);
      } else {
        final isLastPage = challenges.length < 10;
        if (isLastPage) {
          pagingControllers[status]!.appendLastPage(challenges);
        } else {
          pagingControllers[status]!.appendPage(challenges, pageKey + 1);
        }
      }
    } catch (error) {
      pagingControllers[status]!.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            isScrollable: true,
            tabs: headers.values
                .map((title) => Tab(
                      child: Text(
                        AppLocalizations.of(context).translate(title),
                        style: TextStyle(fontSize: 16, color: colors[title]),
                      ),
                    ))
                .toList(),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: headers.length,
            itemBuilder: (context, index) {
              final status = headers.keys.toList()[index];
              return _buildPage(status);
            },
            onPageChanged: (index) {
              final status = headers.keys.toList()[index];
              _fetchPage(status, 1); // Загружаем данные при смене страницы
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String status) {
    //return Text(status);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PagedListView<int, Challenge>(
        pagingController: pagingControllers[status]!,
        builderDelegate: PagedChildBuilderDelegate<Challenge>(
          itemBuilder: (context, challenge, index) => ChallengeView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            isAuthor: widget.isAuthor,
          ),
          firstPageProgressIndicatorBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
          newPageProgressIndicatorBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
          noItemsFoundIndicatorBuilder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context).translate('No challenges available'),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
