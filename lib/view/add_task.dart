import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskapp/constants/screen_size.dart';
import 'package:taskapp/model/task.dart';
import 'package:taskapp/task_shared_preference.dart';
import 'package:taskapp/widgets/app_button.dart';
import 'package:taskapp/widgets/app_textfield.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String generateId() {
    Random random = Random();
    int generated = random.nextInt(999999);

    debugPrint('new task id: $generated');

    return generated.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.fullWidth,
      height: 230,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Новая задача',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AppTextField(
              hintText: 'Напиши что-нибудь',
              controller: _controller,
            ),
            const SizedBox(
              height: 10,
            ),
            AppButton(
              onPressed: () async {
                String text = _controller.text;
                String id = generateId();
                Task task = Task(
                  text: text,
                  status: TaskStatus.inprocess,
                  id: id,
                );
                await ref.read(addTaskProvider(task).future);

                ref.invalidate(tasksProvider);

                _controller.clear();
                Navigator.pop(context);
              },
              title: 'Добавить задачу',
            ),
          ],
        ),
      ),
    );
  }
}
