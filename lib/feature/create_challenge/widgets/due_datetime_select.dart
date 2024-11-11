import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DueDateTimeField extends StatefulWidget {
  final TextEditingController controller;

  const DueDateTimeField({required this.controller, super.key});

  @override
  State<DueDateTimeField> createState() => _DueDateTimeFieldState();
}

class _DueDateTimeFieldState extends State<DueDateTimeField> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    widget.controller.text =
        DateFormat('dd.MM.yyyy HH:mm').format(_selectedDateTime!);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: 'Due Date & Time',
      ),
      readOnly: true,
      onTap: () async {
        // Выбор даты
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDateTime!,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 7)),
        );

        if (pickedDate != null) {
          // Выбор времени
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_selectedDateTime!),
          );

          if (pickedTime != null) {
            setState(() {
              // Объединяем выбранные дату и время
              _selectedDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              widget.controller.text =
                  DateFormat('dd.MM.yyyy HH:mm').format(_selectedDateTime!);
            });
          }
        }
      },
    );
  }
}
