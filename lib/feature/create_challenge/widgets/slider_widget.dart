import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/common/strings/export.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

class SliderWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final double minimum;
  final double maximum;
  final String currency;
  const SliderWidget({
    super.key,
    required this.controller,
    required this.minimum,
    required this.maximum,
    required this.currency,
  });

  @override
  ConsumerState<SliderWidget> createState() => _BetSliderState();
}

class _BetSliderState extends ConsumerState<SliderWidget> {
  late double _sliderValue;
  final TextEditingController _percentageController = TextEditingController();

  double get minInPercentage => widget.minimum / widget.maximum * 100;

  void setDefault() {
    _sliderValue = minInPercentage;
    _percentageController.text = minInPercentage.toStringAsFixed(2);
    widget.controller.text = widget.minimum.toStringAsFixed(2);
  }

  @override
  void initState() {
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
    if (result <= widget.maximum && result >= widget.minimum) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocale.of(context).translate(mCalcValue),
                    hintText: widget.currency,
                    alignLabelWithHint: true,
                    helper: Container(
                      alignment: Alignment.topRight,
                      child: Text(widget.currency),
                    ),
                  ),
                  onChanged: _onResultChanged,
                  validator: (value) {
                    if (value == null) {
                      return "Enter a value";
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) < widget.minimum ||
                        double.parse(value) > widget.maximum) {
                      return AppLocale.of(context)
                          .translate(mPleaseEnterValidValue);
                    }
                    return null;
                  }),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: Slider(
            divisions: 40,
            max: 100,
            value: _sliderValue,
            label: widget.controller.text,
            onChanged: (double value) {
              _onPercentageChanged(value.toString());
              setState(() {});
            },
          ),
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
