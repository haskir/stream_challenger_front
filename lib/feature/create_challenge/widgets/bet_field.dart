import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

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
    widget.controller.text = widget.minimumBet.toString();
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      maxLength: widget.maximumBet.toString().length,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('Bet'),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context).translate("Please enter bet");
        }
        final double? parsedValue = double.tryParse(value);
        if (parsedValue == null) {
          return AppLocalizations.of(context).translate("Bet must be a number");
        }
        if (parsedValue < widget.minimumBet) {
          return '${AppLocalizations.of(context).translate("Bet must be at least")} ${widget.minimumBet}';
        }
        if (parsedValue > widget.maximumBet) {
          return '${AppLocalizations.of(context).translate("Bet must be at most")} ${widget.maximumBet}';
        }
        return null;
      },
    );
  }
}
