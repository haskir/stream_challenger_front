import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/models/challenge.dart';
import 'package:stream_challenge/feature/challenge_view/challenge_card.dart';
import 'package:stream_challenge/providers/challenge_provider.dart';

class ChallengesPanel extends ConsumerStatefulWidget {
  final bool isAuthor;
  final Map<String, bool> expandedStates;

  const ChallengesPanel({
    super.key,
    required this.expandedStates,
    required this.isAuthor,
  });

  @override
  ConsumerState<ChallengesPanel> createState() => _ChallengesPanelState();
}

class _ChallengesPanelState extends ConsumerState<ChallengesPanel> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final Map<String, List<int>> hasLoaded = {}; // Для отслеживания загрузки
  final PageController _pageController = PageController();

  FutureProviderFamily<List<Challenge>?, GetStruct> get challengesProvider {
    return widget.isAuthor ? authorChallengesProvider : performerChallengesProvider;
  }

  static Map<String, String> headers = {
    'PENDING': mNewChallenges,
    'ACCEPTED': mAcceptedChallenges,
    'REJECTED': mRejectedChallenges,
    'SUCCESSFUL': mSuccessfulChallenges,
    'FAILED': mFailedChallenges,
    'CANCELLED': mCancelledChallenges,
    'REPORTED': mReportedChallenges,
  };

  static const Map<String, Color> colors = {
    "PENDING": Colors.orange,
    "ACCEPTED": Colors.blue,
    "REJECTED": Colors.red,
    "SUCCESSFUL": Colors.green,
    "FAILED": Colors.black,
    "CANCELLED": Colors.grey,
    "REPORTED": Colors.purple
  };

  final Map<String, PagingController<int, Challenge>> pagingControllers = {
    "PENDING": PagingController(firstPageKey: 1),
    "ACCEPTED": PagingController(firstPageKey: 1),
    "REJECTED": PagingController(firstPageKey: 1),
    "SUCCESSFUL": PagingController(firstPageKey: 1),
    "FAILED": PagingController(firstPageKey: 1),
    "CANCELLED": PagingController(firstPageKey: 1),
    "REPORTED": PagingController(firstPageKey: 1),
  };

  @override
  void initState() {
    tabController = TabController(length: headers.length, vsync: this);
    for (String status in headers.keys) {
      hasLoaded[status] = [];
    }
    pagingControllers.forEach((status, controller) {
      pagingControllers[status]!.addPageRequestListener((pageKey) {
        _fetchPage(status, pageKey);
      });
    });
    final firstStatus = headers.keys.first;
    _fetchPage(firstStatus, 1);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    hasLoaded.clear();
    pagingControllers.forEach((_, controller) => controller.dispose());
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(String status, int pageKey) async {
    if (hasLoaded[status]!.contains(pageKey)) return;

    final provider = ref.read(challengesProvider(
      GetStruct(
        statuses: [status],
        page: pageKey,
        size: 10,
        isAuthor: widget.isAuthor,
      ),
    ).future);

    hasLoaded[status]!.add(pageKey);

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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: headers.values
              .map((title) => Tab(
                    child: Text(
                      AppLocale.of(context).translate(title),
                      style: TextStyle(fontSize: 16, color: colors[title]),
                    ),
                  ))
              .toList(),
          onTap: (index) => _pageController.jumpToPage(index),
        ),
        Container(
          alignment: Alignment.topCenter,
          height: 600,
          child: PageView(
            controller: _pageController,
            children: headers.keys.map((status) => _buildPage(status)).toList(),
            onPageChanged: (index) {
              final status = headers.keys.toList()[index];
              tabController.animateTo(index);
              _fetchPage(status, 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPage(String status) {
    bool isRefreshing = false;
    return RefreshIndicator(
      onRefresh: () async {
        isRefreshing = true;
        pagingControllers[status]!.refresh();
        hasLoaded[status] = [];
        await _fetchPage(status, 1);
      },
      child: PagedListView<int, Challenge>(
        pagingController: pagingControllers[status]!,
        builderDelegate: PagedChildBuilderDelegate<Challenge>(
          animateTransitions: true,
          itemBuilder: (context, challenge, index) {
            return ChallengeCard(
              challenge: challenge,
              isAuthor: widget.isAuthor,
              key: ValueKey(challenge.id),
            );
          },
          firstPageProgressIndicatorBuilder: (context) => Center(
            child: !isRefreshing ? CircularProgressIndicator() : Text(""),
          ),
          newPageProgressIndicatorBuilder: (context) => const Center(child: CircularProgressIndicator()),
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text(
              AppLocale.of(context).translate(mNoChallengesAvailable),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
