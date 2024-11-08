import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_challenge/data/models/challenge.dart';

class ChallengeWidget extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onReport;

  const ChallengeWidget({
    super.key,
    required this.challenge,
    required this.onAccept,
    required this.onReject,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.description,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Автор: ${challenge.author}'),
            Text('Сумма: ${challenge.bet}'),
            Text('Срок: ${challenge.due_at.toLocal()}'.split(' ')[0]),
            const SizedBox(height: 8),
            Text('Условия:', style: Theme.of(context).textTheme.titleMedium),
            ...challenge.conditions.map((condition) => Text('- $condition')),
            const SizedBox(height: 16),
            if (challenge.status == ChallengeStatus.pending) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: onAccept,
                    child: const Text("Принять"),
                  ),
                  ElevatedButton(
                    onPressed: onReject,
                    child: const Text("Отклонить"),
                  ),
                  ElevatedButton(
                    onPressed: onReport,
                    child: const Text("Пожаловаться"),
                  ),
                ],
              ),
            ] else if (challenge.status == ChallengeStatus.completed)
              const Text("Статус: Выполнено",
                  style: TextStyle(color: Colors.green))
            else if (challenge.status == ChallengeStatus.rejected)
              const Text("Статус: Отклонено",
                  style: TextStyle(color: Colors.red))
            else if (challenge.status == ChallengeStatus.accepted)
              const Text("Статус: В процессе выполнения",
                  style: TextStyle(color: Colors.blue))
            else if (challenge.status == ChallengeStatus.reported)
              const Text("Статус: Скрыто",
                  style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
