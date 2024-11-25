import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

class BetSlider extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final double minBet;
  final double balance;
  final String currency;
  const BetSlider({
    super.key,
    required this.controller,
    required this.minBet,
    required this.balance,
    required this.currency,
  });

  double get minInPercentage => minBet / balance * 100;

  @override
  BetSliderState createState() => BetSliderState();
}

class BetSliderState extends ConsumerState<BetSlider> {
  late double _sliderValue;
  final TextEditingController _percentageController = TextEditingController();

  void setDefault() {
    _sliderValue = widget.minInPercentage;
    _percentageController.text = widget.minInPercentage.toString();
    widget.controller.text = widget.minBet.toString();
  }

  @override
  void initState() {
    _sliderValue = widget.minInPercentage;
    setDefault();
    super.initState();
  }

  void _onPercentageChanged(String value) {
    double? percentage = double.tryParse(value);
    if (percentage == null) return;
    if (percentage > 100) percentage = 100;
    if (percentage > widget.minInPercentage && percentage <= 100) {
      widget.controller.text = (widget.balance * percentage / 100).toString();
      _percentageController.text = percentage.toString();
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
    if (result <= widget.balance && result >= widget.minBet) {
      _percentageController.text = (result / widget.balance * 100).toString();
    } else {
      setDefault();
    }
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
                      '${AppLocalizations.of(context).translate('Percentage')} (%)',
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
                  labelText: AppLocalizations.of(context)
                      .translate('Calculated value'),
                ),
                onChanged: _onResultChanged,
              ),
            ),
            Text(widget.currency),
          ],
        ),
        const SizedBox(height: 20),
        Slider(
            min: widget.minInPercentage,
            max: 100,
            value: _sliderValue,
            label: widget.controller.text,
            onChanged: (double value) {
              _onPercentageChanged(value.toString());
              setState(() {});
            }),
      ],
    );
  }

  @override
  void dispose() {
    _percentageController.dispose();
    super.dispose();
  }
}
