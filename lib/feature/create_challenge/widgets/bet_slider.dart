import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/text_consts.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

class BetSlider extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final double minBet;
  final double maximum;
  final String currency;
  const BetSlider({
    super.key,
    required this.controller,
    required this.minBet,
    required this.maximum,
    required this.currency,
  });

  @override
  ConsumerState<BetSlider> createState() => _BetSliderState();
}

class _BetSliderState extends ConsumerState<BetSlider> {
  late double _sliderValue;
  final TextEditingController _percentageController = TextEditingController();

  double get minInPercentage => widget.minBet / widget.maximum * 100;

  void setDefault() {
    _sliderValue = minInPercentage;
    _percentageController.text = minInPercentage.toStringAsFixed(2);
    widget.controller.text = widget.minBet.toStringAsFixed(2);
  }

  @override
  void initState() {
    // _sliderValue = minInPercentage;
    setDefault();
    super.initState();
  }

  void _onPercentageChanged(String value) {
    double? percentage = double.tryParse(value);
    if (percentage == null) return;
    if (percentage > 100) percentage = 100;
    if (percentage > minInPercentage && percentage <= 100) {
      widget.controller.text =
          (widget.maximum * percentage / 100).toStringAsFixed(2);
      _percentageController.text = percentage.toStringAsFixed(2);
    } else {
      setDefault();
      return setState(() {});
    }
    setState(() {
      _sliderValue = percentage!;
    });
  }

  void _onResultChanged(String value) {
    double? result = double.tryParse(value);
    if (result == null) return;
    if (result <= widget.maximum && result >= widget.minBet) {
      _percentageController.text =
          (result / widget.maximum * 100).toStringAsFixed(2);
      _sliderValue = result / widget.maximum * 100;
    } else {
      setDefault();
    }
    return setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: TextField(
                controller: _percentageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      '${AppLocale.of(context).translate(mPercentage)} (%)',
                ),
                onChanged: _onPercentageChanged,
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: TextField(
                controller: widget.controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocale.of(context).translate(mCalculatedValue),
                ),
                onChanged: _onResultChanged,
              ),
            ),
            Text(widget.currency),
          ],
        ),
        const SizedBox(height: 20),
        Slider(
          divisions: 40,
          min: minInPercentage,
          max: 100,
          value: _sliderValue,
          label: widget.controller.text,
          onChanged: (double value) {
            _onPercentageChanged(value.toString());
            setState(() {});
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _percentageController.dispose();
    super.dispose();
  }
}
