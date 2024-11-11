import 'package:flutter/material.dart';

class ConditionsSection extends StatefulWidget {
  final List<String> conditions = [];
  static const int max = 3;

  ConditionsSection({super.key});

  @override
  State<ConditionsSection> createState() => _ConditionsSectionState();
}

class _ConditionsSectionState extends State<ConditionsSection> {
  final TextEditingController _conditionController = TextEditingController();
  final List<TextEditingController> _controllers = [];

  @override
  void dispose() {
    _conditionController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addCondition(String value) {
    if (value.isNotEmpty) {
      setState(() {
        widget.conditions.add(value);
        _controllers.add(TextEditingController(text: value));
        _conditionController.clear();
      });
    }
  }

  void _removeCondition(int index) {
    print('index: $index');
    print("conditions: ${widget.conditions}");
    setState(() {
      widget.conditions.removeAt(index);
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Условия:'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.conditions.asMap().entries.map((entry) {
              int index = entry.key;
              return Row(
                children: [
                  Expanded(
                    child: ConditionLineEdit(
                      controller: _controllers[index],
                      onChanged: (value) {
                        setState(() {
                          widget.conditions[index] = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeCondition(index),
                    icon: const Icon(Icons.remove),
                  ),
                ],
              );
            }),
            if (widget.conditions.length <
                ConditionsSection.max) // Ограничение до трех условий
              Row(
                children: [
                  Expanded(
                    child: ConditionLineEdit(
                      controller: _conditionController,
                      onFieldSubmitted: _addCondition,
                    ),
                  ),
                  if (widget.conditions.length < ConditionsSection.max - 1)
                    IconButton(
                      onPressed: () => _addCondition(_conditionController.text),
                      icon: const Icon(Icons.add),
                    ),
                  if (widget.conditions.length == ConditionsSection.max - 1)
                    IconButton(
                      onPressed: () =>
                          _removeCondition(widget.conditions.length),
                      icon: const Icon(Icons.remove),
                    ),
                ],
              ),
          ],
        ),
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
