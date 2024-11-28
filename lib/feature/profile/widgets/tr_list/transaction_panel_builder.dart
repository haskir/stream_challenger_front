import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/profile/widgets/ch_list/challenge_view_widget.dart';
import 'package:stream_challenge/providers/challenge_provider.dart';

class TransactionsPanel extends ConsumerStatefulWidget {
  final bool isAuthor;
  final Map<String, bool> expandedStates;
  late final FutureProviderFamily<List<Challenge>?, GetStruct>
      challengesProvider;

  TransactionsPanel({
    super.key,
    required this.expandedStates,
    required this.isAuthor,
  }) : challengesProvider =
            isAuthor ? authorChallengesProvider : performerChallengesProvider;

  @override
  ConsumerState<TransactionsPanel> createState() => _ChallengesPanelState();
}

class _ChallengesPanelState extends ConsumerState<TransactionsPanel> {
  final Map<String, PagingController<int, Challenge>> pagingControllers = {
    "PENDING": PagingController(firstPageKey: 1),
    "ACCEPTED": PagingController(firstPageKey: 1),
    "REJECTED": PagingController(firstPageKey: 1),
    "SUCCESSFUL": PagingController(firstPageKey: 1),
    "FAILED": PagingController(firstPageKey: 1),
    "CANCELLED": PagingController(firstPageKey: 1),
  };

  @override
  void initState() {
    super.initState();
    pagingControllers.forEach((status, controller) {
      controller.addPageRequestListener((pageKey) {
        _fetchPage(status, pageKey);
      });
    });
  }

  Future<void> _fetchPage(String status, int pageKey) async {
    final provider = ref.read(widget
        .challengesProvider(GetStruct(status: status, page: pageKey, size: 10))
        .future);

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
  void dispose() {
    pagingControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      child: ExpansionPanelList(
        elevation: 1,
        expansionCallback: (index, isExpanded) {
          final status = _ChallengesPanelBuilder.headers.keys.toList()[index];
          setState(() {
            widget.expandedStates[status] = isExpanded;
          });
        },
        children: _ChallengesPanelBuilder(
          expandedStates: widget.expandedStates,
          pagingControllers: pagingControllers,
        ).buildDynamicPanels(context, widget.isAuthor),
      ),
    );
  }
}

class _ChallengesPanelBuilder {
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

  final Map<String, bool> expandedStates;
  final Map<String, PagingController<int, Challenge>> pagingControllers;

  _ChallengesPanelBuilder({
    required this.expandedStates,
    required this.pagingControllers,
  });

  List<ExpansionPanel> buildDynamicPanels(BuildContext context, bool isAuthor) {
    return headers.entries.map((entry) {
      final status = entry.key;
      final int? chLen = pagingControllers[status]?.itemList?.length;
      String trailing = chLen != null ? "($chLen)" : "";
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(
              AppLocalizations.of(context).translate(headers[status]!),
              style: TextStyle(color: colors[status], fontSize: 18),
            ),
            trailing: Text(trailing,
                style: TextStyle(
                  color: colors[status],
                  fontSize: 18,
                )),
          );
        },
        body: SizedBox(
          height: chLen != null ? 300 : 50,
          child: PagedListView<int, Challenge>(
            pagingController: pagingControllers[status]!,
            builderDelegate: PagedChildBuilderDelegate<Challenge>(
              itemBuilder: (context, challenge, index) => ChallengeView(
                key: ValueKey(challenge.id),
                challenge: challenge,
                isAuthor: isAuthor,
              ),
              firstPageProgressIndicatorBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
              noItemsFoundIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)
                      .translate('No challenges available'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        isExpanded: expandedStates[status] ?? false,
        canTapOnHeader: true,
      );
    }).toList();
  }
}
