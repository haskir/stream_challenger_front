import 'package:flutter/material.dart';

class CreateChallengeWidget extends StatefulWidget {
  const CreateChallengeWidget({super.key});

  @override
  State<CreateChallengeWidget> createState() => _CreateChallengeWidgetState();
}

class _CreateChallengeWidgetState extends State<CreateChallengeWidget> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _performerIdController = TextEditingController();
  final _minimumRewardController = TextEditingController();
  final _betController = TextEditingController();
  final _currencyController = TextEditingController();
  final _dueAtController = TextEditingController();
  final List<String> _conditions = [];

  @override
  void dispose() {
    _descriptionController.dispose();
    _performerIdController.dispose();
    _minimumRewardController.dispose();
    _betController.dispose();
    _currencyController.dispose();
    _dueAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите описание';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _performerIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ID исполнителя',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите ID исполнителя';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _minimumRewardController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Минимальное вознаграждение (0-1)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите минимальное вознаграждение';
                }
                if (double.tryParse(value) == null ||
                    double.parse(value) < 0 ||
                    double.parse(value) > 1) {
                  return 'Минимальное вознаграждение должно быть от 0 до 1';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _betController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ставка',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите ставку';
                }
                if (double.tryParse(value) == null ||
                    double.parse(value) <= 0) {
                  return 'Ставка должна быть больше 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _currencyController,
              decoration: const InputDecoration(
                labelText: 'Валюта',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите валюту';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dueAtController,
              decoration: const InputDecoration(
                labelText: 'Срок выполнения',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите срок выполнения';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Условия:'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _conditions.length + 1,
              itemBuilder: (context, index) {
                if (index == _conditions.length) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Добавить условие',
                          ),
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty) {
                              setState(() {
                                _conditions.add(value);
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _conditions.add('');
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  );
                } else {
                  return ListTile(
                    title: Text(_conditions[index]),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _conditions.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Send data to server here
                  // ...
                }
              },
              child: const Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }
}
