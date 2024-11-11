import 'package:flutter/material.dart';

class ConditionsSection extends StatefulWidget {
  late final List<String> conditions;

  ConditionsSection({super.key}) {
    conditions = [];
  }

  @override
  State<ConditionsSection> createState() => _ConditionsSectionState();
}

class _ConditionsSectionState extends State<ConditionsSection> {
  final TextEditingController _conditionController = TextEditingController();

  @override
  void dispose() {
    _conditionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Условия:'),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.conditions.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.conditions.length) {
              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _conditionController,
                      decoration: const InputDecoration(
                        labelText: 'Добавить условие',
                      ),
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            widget.conditions.add(value);
                            _conditionController.clear();
                          });
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_conditionController.text.isNotEmpty) {
                        setState(() {
                          widget.conditions.add(_conditionController.text);
                          _conditionController.clear();
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              );
            } else {
              return ListTile(
                title: Text(widget.conditions[index]),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.conditions.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
