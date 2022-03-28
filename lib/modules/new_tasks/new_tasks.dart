import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/todo_cubit/todo_cubit.dart';
import 'package:todo/layout/todo_cubit/todo_sates.dart';
import 'package:todo/shared/component/component.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        var tasks = TodoCubit.get(context).newTasks;
        return buildTaskItem(tasks:  tasks!);
      },
    );
  }
}
