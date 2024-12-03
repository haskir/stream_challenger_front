import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int maxRating;
  final int initialRating;
  final Function(int rating) onRatingChanged;

  const StarRating({
    super.key,
    required this.onRatingChanged,
    this.maxRating = 5,
    this.initialRating = 0,
  });

  @override
  StarRatingState createState() => StarRatingState();
}

class StarRatingState extends State<StarRating> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _updateRating(int newRating) {
    setState(() {
      _currentRating = newRating;
    });
    widget.onRatingChanged(_currentRating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () => _updateRating(starIndex),
          child: Icon(
              starIndex <= _currentRating ? Icons.star : Icons.star_border,
              color: starIndex <= _currentRating ? Colors.amber : Colors.grey,
              size: 40),
        );
      }),
    );
  }
}
