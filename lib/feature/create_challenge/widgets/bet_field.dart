import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BetField extends StatefulWidget {
  final TextEditingController controller;
  final double minimumBet;
  final double maximumBet;

  const BetField({
    super.key,
    required this.controller,
    required this.minimumBet,
    required this.maximumBet,
  });

  @override
  State<StatefulWidget> createState() => _BetFieldState();
}

class _BetFieldState extends State<BetField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      maxLength: widget.maximumBet.toString().length,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: 'Ставка',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите ставку';
        }
        final double? parsedValue = double.tryParse(value);
        if (parsedValue == null) {
          return 'Ставка должна быть числом';
        }
        if (parsedValue < widget.minimumBet) {
          return 'Ставка должна быть не меньше ${widget.minimumBet}';
        }
        if (parsedValue > widget.maximumBet) {
          return 'Ставка не должна превышать ${widget.maximumBet}';
        }
        return null;
      },
    );
  }
}
