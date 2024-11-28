import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class TransactionView extends StatelessWidget {
  final bool isAuthor;
  final Challenge challenge;
  const TransactionView({
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
              Text('Minimum Reward: ${challenge.minimum_reward}'),
              Text('Bet: ${challenge.bet}'),
              Text('Status: ${challenge.status}'),
              Text('Visible: ${challenge.is_visible}'),
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
                'Created At: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(challenge.created_at)}'),
            if (challenge.status == 'PENDING' && isAuthor)
              ElevatedButton(child: const Icon(Icons.cancel), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
