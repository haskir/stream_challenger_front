import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/models/challenge.dart';

import '_author_actions.dart';
import '_performer_actions.dart';
import '_staring_widget.dart';

class ActionsBuilder extends ConsumerStatefulWidget {
  final Challenge challenge;
  final Function(bool isLoading) onLoading;

  const ActionsBuilder({
    super.key,
    required this.challenge,
    required this.onLoading,
  });

  @override
  createState() => ActionState();
}

class ActionState extends ConsumerState<ActionsBuilder> {
  @override
  Widget build(BuildContext context) => StarRatingWidget(
        isAuthor: false,
        initialRating: widget.challenge.rating,
      );
}

class PerfomerActionsBuilder extends ActionsBuilder {
  const PerfomerActionsBuilder({
    super.key,
    required super.challenge,
    required super.onLoading,
  });

  @override
  createState() => PerformerActionsState();
}

class AuthorActionsBuilder extends ActionsBuilder {
  const AuthorActionsBuilder({
    super.key,
    required super.challenge,
    required super.onLoading,
  });

  @override
  createState() => AuthorActionsState();
}
