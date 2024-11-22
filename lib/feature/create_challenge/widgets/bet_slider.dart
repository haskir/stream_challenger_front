import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/feature/create_challenge/widgets/currency_pick_widget.dart';

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

  @override
  BetSliderState createState() => BetSliderState();
}

class BetSliderState extends ConsumerState<BetSlider> {
  double _sliderValue = 0.0;
  final TextEditingController _percentageController = TextEditingController();

  double get _calculatedValue {
    return widget.balance * (_sliderValue / 100);
  }

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  void _updateControllers() {
    _percentageController.text = _sliderValue.toStringAsFixed(0);
    widget.controller.text = _calculatedValue.toStringAsFixed(2);
  }

  void _onPercentageChanged(String value) {
    double? percentage = double.tryParse(value);
    if (percentage != null) {
      setState(() {
        _sliderValue = percentage;
        _updateControllers();
      });
    }
  }

  void _onResultChanged(String value) {
    double? result = double.tryParse(value);
    if (result != null && result <= widget.balance && result >= 0) {
      setState(() {
        _sliderValue = (result / widget.balance) * 100;
        _updateControllers();
      });
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
            CurrencyPickWidget(currency: widget.currency),
          ],
        ),
        const SizedBox(height: 20),
        Slider(
          value: _sliderValue,
          min: 0,
          max: 100,
          label: _sliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _sliderValue = value;
              _updateControllers();
            });
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
