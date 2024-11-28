import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class ChallengeView extends StatelessWidget {
  final bool isAuthor;
  final Challenge challenge;
  const ChallengeView({
    super.key,
    required this.isAuthor,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ID: ${challenge.id}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Description: ${challenge.description}'),
              Text('Conditions: ${challenge.conditions.join(',\n')}'),
              Text('Currency: ${challenge.currency}'),
              Text('Minimum Reward: ${challenge.minimumReward}'),
              Text('Bet: ${challenge.bet}'),
              Text('Status: ${challenge.status}'),
              Text('Visible: ${challenge.isVisible}'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Author: ${challenge.author.name}'),
                  Image.network(
                    challenge.author.urlImage,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                    height: 50,
                    width: 50,
                  ),
                ],
              ),
            ]),
            Text('Performer Login: ${challenge.performerLogin}'),
            Text(
                'Created At: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(challenge.createdAt)}'),
            if (challenge.status == 'PENDING' && isAuthor)
              ElevatedButton(child: const Icon(Icons.cancel), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
