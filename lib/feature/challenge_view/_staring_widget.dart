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
  int _hoveredRating = 0; // Рейтинг при наведении мыши

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

  void _updateHoveredRating(int newHoveredRating) {
    setState(() {
      _hoveredRating = newHoveredRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        final starIndex = index + 1;
        final isHighlighted =
            starIndex <= (_hoveredRating > 0 ? _hoveredRating : _currentRating);
        return MouseRegion(
          onEnter: (_) => _updateHoveredRating(starIndex),
          onExit: (_) => _updateHoveredRating(0),
          child: GestureDetector(
            onTap: () => _updateRating(starIndex),
            child: Icon(
              isHighlighted ? Icons.star : Icons.star_border,
              color: isHighlighted ? Colors.amber : Colors.grey,
              size: 40,
            ),
          ),
        );
      }),
    );
  }
}
