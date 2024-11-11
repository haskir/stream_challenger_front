import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DueDateField extends StatefulWidget {
  final TextEditingController controller;

  const DueDateField({required this.controller, super.key});

  @override
  State<DueDateField> createState() => _DueDateFieldState();
}

class _DueDateFieldState extends State<DueDateField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    widget.controller.text = DateFormat('dd.MM.yyyy').format(_selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: 'Due Date',
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate!,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 7)),
        );

        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            widget.controller.text =
                DateFormat('dd.MM.yyyy').format(_selectedDate!);
          });
        }
      },
    );
  }
}
