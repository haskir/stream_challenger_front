import 'package:flutter/material.dart';

class BalanceSlider extends StatefulWidget {
  final double balance;
  final int minPercentage;

  const BalanceSlider({
    super.key,
    required this.balance,
    required this.minPercentage,
  });

  @override
  BalanceSliderState createState() => BalanceSliderState();
}

class BalanceSliderState extends State<BalanceSlider> {
  double _sliderValue = 0.0;
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  double get _calculatedValue {
    return widget.balance * (_sliderValue / 100);
  }

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.minPercentage.toDouble();
    _updateControllers();
  }

  void _updateControllers() {
    _percentageController.text = _sliderValue.toStringAsFixed(0);
    _resultController.text = _calculatedValue.toStringAsFixed(2);
  }

  void _onPercentageChanged(String value) {
    double? percentage = double.tryParse(value);
    if (percentage != null &&
        percentage >= widget.minPercentage &&
        percentage <= 100) {
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
    return Container(
      width: 700,
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Balance: ${widget.balance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: TextField(
                  controller: _percentageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Percentage (%)',
                  ),
                  onChanged: _onPercentageChanged,
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: TextField(
                  controller: _resultController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Calculated Value',
                  ),
                  onChanged: _onResultChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Slider(
            value: _sliderValue,
            min: widget.minPercentage.toDouble(),
            max: 100,
            divisions: 100 - widget.minPercentage,
            label: _sliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _sliderValue = value;
                _updateControllers();
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Логика при нажатии на кнопку подтверждения
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Confirmed!')),
                  );
                },
                child: const Text('Confirm'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Логика при нажатии на кнопку отмены
                  setState(() {
                    _sliderValue = widget.minPercentage.toDouble();
                    _updateControllers();
                  });
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _percentageController.dispose();
    _resultController.dispose();
    super.dispose();
  }
}
