import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/todo_cubit/todo_cubit.dart';
import 'package:todo/layout/todo_cubit/todo_sates.dart';
import 'package:todo/shared/component/component.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        var tasks = TodoCubit.get(context).archivedTasks;
        return buildTaskItem(tasks:  tasks!);
      },
    );
  }
}
