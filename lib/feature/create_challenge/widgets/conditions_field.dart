// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ConditionsSection extends StatefulWidget {
  List<TextEditingController> controllers;
  final int max;

  ConditionsSection({
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
          const Text('Условия:'),
          const SizedBox(width: 10),
          ElevatedButton(
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
  final int maxLength = 255;

  ConditionLineEdit({
    super.key,
    super.onChanged,
    super.onFieldSubmitted,
    required super.controller,
  }) : super(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Пожалуйста, введите условие';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: "Введите условие",
          ),
        );
}
