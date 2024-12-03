import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import '_actions_builder.dart';
import '_info_widget.dart';
import '_report_info_widget.dart';

class ChallengeCard extends ConsumerStatefulWidget {
  final Challenge challenge;
  final bool isAuthor;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.isAuthor,
  });

  @override
  ConsumerState<ChallengeCard> createState() => ChallengeCardState();
}

class ChallengeCardState extends ConsumerState<ChallengeCard> {
  Challenge get challenge => widget.challenge;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: 300,
        maxWidth: 700,
      ),
      child: Stack(
        children: [
          // Карточка с основной информацией
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 5,
                    child: ChallengeInfoWidget(challenge: challenge),
                  ),
                  Spacer(),
                  if (challenge.report != null)
                    Flexible(
                        child: ReportInfoWidget(report: challenge.report!)),
                  Spacer(),
                  // Кнопки действий
                  ChallengeActionsBuilder(
                    challenge: challenge,
                    isAuthor: widget.isAuthor,
                    onLoading: _toggleLoading,
                  ),
                ],
              ),
            ),
          ),

          // Блокировка интерфейса
          if (_isLoading)
            Positioned.fill(
              child: ModalBarrier(dismissible: false),
            ),

          // Индикатор загрузки в центре и непрозрачность
          if (_isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _toggleLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }
}
