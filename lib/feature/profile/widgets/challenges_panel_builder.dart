import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/profile/widgets/challenge_view_widget.dart';
import 'package:stream_challenge/providers/challenge_provider.dart';

class ChallengesPanel extends ConsumerStatefulWidget {
  final Map<String, bool> expandedStates;
  final FutureProviderFamily<List<Challenge>?, GetStruct> challengesProvider;

  const ChallengesPanel({
    super.key,
    required this.expandedStates,
    required this.challengesProvider,
  });

  @override
  ConsumerState<ChallengesPanel> createState() => _ChallengesPanelState();
}

class _ChallengesPanelState extends ConsumerState<ChallengesPanel> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        elevation: 1,
        expansionCallback: (index, isExpanded) {
          setState(() {
            final status = ChallengesPanelBuilder.headers.keys.toList()[index];
            widget.expandedStates[status] = !isExpanded;

            // Загружаем данные только при открытии панели
            if (!widget.expandedStates[status]!) {
              ref.read(widget.challengesProvider(
                  GetStruct(status: status, page: 1, size: 10)));
            }
          });
        },
        children: ChallengesPanelBuilder(
          expandedStates: widget.expandedStates,
        ).buildDynamicPanels(context, widget.challengesProvider, ref),
      ),
    );
  }
}

class ChallengesPanelBuilder {
  static const Map<String, String> headers = {
    //'ACCEPTED': "Accepted Challenges",
    'PENDING': "New Challenges",
    'REJECTED': "Rejected Challenges",
    //'FAILED': "Failed Challenges",
    //'CANCELLED': "Cancelled Challenges",
    //'SUCCESSFUL': "Successful Challenges",
  };

  static const Map<String, Color> colors = {
    //'ACCEPTED': Colors.blue,
    'PENDING': Colors.orange,
    'REJECTED': Colors.red,
    //'FAILED': Colors.black,
    //'CANCELLED': Colors.grey,
    //'SUCCESSFUL': Colors.green,
  };

  final Map<String, bool> expandedStates;

  ChallengesPanelBuilder({
    required this.expandedStates,
  });

  List<ExpansionPanel> buildDynamicPanels(
    BuildContext context,
    FutureProviderFamily challengesProvider,
    WidgetRef ref,
  ) {
    return headers.entries.map((entry) {
      final status = entry.key;

      // Используем watch, чтобы слушать асинхронное состояние
      final challengesAsyncValue = ref.watch(
          challengesProvider(GetStruct(status: status, page: 1, size: 10)));

      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(
              AppLocalizations.of(context).translate(headers[status]!),
            ),
            trailing: challengesAsyncValue.when(
              data: (challenges) => Text('(${challenges.length})'),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error'),
            ),
          );
        },
        body: challengesAsyncValue.when(
          data: (challenges) => Column(
            children: challenges
                .map((challenge) => ChallengeView(
                    key: ObjectKey(challenge), challenge: challenge))
                .toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Center(child: Text('Failed to load challenges')),
        ),
        isExpanded: expandedStates[status]!,
        canTapOnHeader: true,
      );
    }).toList();
  }
}
