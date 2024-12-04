import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  final bool isAuthor;
  final int maxRating;
  final int? initialRating;
  final Function(int rating)? onRatingChanged;

  const StarRatingWidget({
    super.key,
    required this.isAuthor,
    this.onRatingChanged,
    this.initialRating,
    this.maxRating = 5,
  });

  @override
  StarRatingWidgetState createState() => StarRatingWidgetState();
}

class StarRatingWidgetState extends State<StarRatingWidget> {
  late int _currentRating;
  int _hoveredRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating ?? 0;
  }

  void _updateRating(int newRating) {
    if (!widget.isAuthor) return;
    setState(() {
      _currentRating = newRating;
    });
    widget.onRatingChanged!(_currentRating);
  }

  void _updateHoveredRating(int newHoveredRating) {
    if (!widget.isAuthor) return;
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
