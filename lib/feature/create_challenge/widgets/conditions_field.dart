// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';

class ConditionsSection extends StatefulWidget {
  final List<TextEditingController> controllers;
  final int max;

  const ConditionsSection({
    super.key,
    required this.controllers,
    required this.max,
  });

  @override
  State<ConditionsSection> createState() => _ConditionsSectionState();
}

class _ConditionsSectionState extends State<ConditionsSection> {
  List<ConditionLineEdit> lines = [];

  @override
  void dispose() {
    for (var controller in widget.controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addCondition() {
    setState(() {
      if (lines.length == widget.max) {
        return;
      }
      TextEditingController controller = TextEditingController();
      widget.controllers.add(controller);
      lines.add(ConditionLineEdit(
        controller: controller,
        onFieldSubmitted: (_) => _removeCondition,
        context: context,
      ));
    });
  }

  void _removeCondition(ConditionLineEdit line) {
    setState(() {
      int index = lines.indexOf(line);
      if (index != -1) {
        lines.removeAt(index);
        widget.controllers[index].dispose();
        widget.controllers.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('${AppLocale.of(context).translate('Conditions')}:'),
          TextButton(
            onPressed: _addCondition,
            child: Icon(Icons.add),
          ),
        ]),
        ...lines.map((line) => Row(
              children: [
                Expanded(child: line),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeCondition(line),
                ),
              ],
            )),
      ],
    );
  }
}

class ConditionLineEdit extends TextFormField {
  ConditionLineEdit({
    super.key,
    super.onChanged,
    super.onFieldSubmitted,
    required super.controller,
    context,
  }) : super(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocale.of(context).translate('Please enter condition');
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: AppLocale.of(context).translate('Condition'),
          ),
          maxLength: 127,
        );
}
