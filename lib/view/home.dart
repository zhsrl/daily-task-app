import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskapp/view/add_task.dart';
import 'package:taskapp/constants/app_colors.dart';
import 'package:taskapp/model/task.dart';
import 'package:taskapp/task_shared_preference.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<String> filters = ['Все задачи', 'Завершенные', 'Незавершенные'];
  int filterSelectedIndex = 0;

  // Filter Item
  Widget _filterItem(String title, bool selected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Badge(
          padding: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          backgroundColor: selected == true ? AppColor.primary : Colors.white,
          label: Text(
            title,
            style: TextStyle(
              color: selected == true ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // Build Add Task (Modal)
  void _buildAddTask() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColor.background,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: AddTaskPage(),
        );
      },
    );
  }

  // Show all tasks
  Widget _buildTasks() {
    final tasksState = ref.watch(tasksProvider);

    return tasksState.when(
      data: (tasks) {
        if (tasks == null || tasks.isEmpty) {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Icon(
                  Icons.apps_outlined,
                  color: AppColor.accent1,
                ),
                Text(
                  'Пока у вас нет задачи...',
                  style: TextStyle(
                    color: AppColor.accent1,
                  ),
                ),
              ],
            ),
          );
        }

        final completedTasks = tasks
            .where(
              (task) => task.status == TaskStatus.completed,
            )
            .toList();
        final inprocessTasks = tasks
            .where(
              (task) => task.status == TaskStatus.inprocess,
            )
            .toList();

        for (var task in inprocessTasks) {
          debugPrint(task.text);
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: filterSelectedIndex == 0
              ? tasks.length
              : filterSelectedIndex == 1
              ? completedTasks.length
              : inprocessTasks.length,
          itemBuilder: (context, index) {
            final task = filterSelectedIndex == 0
                ? tasks[index]
                : filterSelectedIndex == 1
                ? completedTasks.toList()[index]
                : inprocessTasks.toList()[index];

            return Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Dismissible(
                key: UniqueKey(),
                secondaryBackground: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                background: SizedBox(),
                onDismissed: (direction) async {
                  await ref.read(
                    removeTaskProvider(
                      task,
                    ).future,
                  );
                  ref.invalidate(tasksProvider);
                },
                direction: DismissDirection.endToStart,
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task.status == TaskStatus.completed)
                        Badge(
                          backgroundColor: Colors.green.withAlpha(50),
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),

                          label: Text(
                            'Выполнена!',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      Text(
                        task.text ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: task.status == TaskStatus.inprocess
                              ? Colors.black
                              : Colors.grey,
                          decoration: task.status == TaskStatus.inprocess
                              ? TextDecoration.none
                              : TextDecoration.lineThrough,
                          decorationColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  tileColor: Colors.white,
                  minVerticalPadding: 0,
                  trailing: Checkbox.adaptive(
                    value: task.status == TaskStatus.completed ? true : false,
                    onChanged: (value) async {
                      await ref.read(changeTaskStatusProvider(task).future);
                      ref.invalidate(tasksProvider);
                    },
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(
                      15,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      error: (er, st) => Center(
        child: Text('Error: $er'),
      ),

      loading: () => Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  // Build UI
  Widget _buildUI() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: filters.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _filterItem(
                      filters[index],
                      index == filterSelectedIndex,
                      onTap: () {
                        setState(() {
                          filterSelectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildTasks(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buildAddTask();
        },
        backgroundColor: AppColor.primary,
        elevation: 0,
        child: Icon(
          Icons.add,
          color: AppColor.background,
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColor.background,

        title: Text('Daily Task'),
      ),
      body: _buildUI(),
    );
  }
}
