import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo/layout/todo_cubit/todo_cubit.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required String? Function(String? value) validator,
  required TextInputType inputType,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? onSuffixPressed,
  Function()? onTap,
  Function(String s)? onSubmit,
  bool isPassword = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPassword,
      onTap: onTap,
      onFieldSubmitted: onSubmit,
      style: const TextStyle(
          color: Colors.black,
          fontSize: 18
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(icon: Icon(suffix), onPressed: onSuffixPressed),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      validator: validator,
    );

Widget buildTasks(Map<dynamic,dynamic> model, context)=>
    Dismissible(
      key: Key(model['id'].toString()),
      child:   Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children:
          [
            CircleAvatar(
              radius: 35.0,
              child: Text('${model['time']}',
              style:const  TextStyle(
                fontSize: 14
              ),
              ),
            ),
            const SizedBox(width: 15.0,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Text('${model['title']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${model['date']}',
                    style:const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: (){
                  TodoCubit.get(context).updateDatabase(status: 'done', id: model['id']);
                },
                icon: const Icon(Icons.check_box,
                  color: Colors.green,
                )
            ),
            IconButton(
                onPressed: (){
                  TodoCubit.get(context).updateDatabase(status: 'archived', id: model['id']);
                },
                icon: const Icon(Icons.archive,
                  color: Colors.black45,
            )
        ),
      ],
    ),
  ),
      onDismissed: (direction){
        TodoCubit.get(context).deleteDatabase(id: model['id']);
      },
);


Widget buildTaskItem({
  required List<Map> tasks,
})
{
  return ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context)=>ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index)=>buildTasks(tasks[index],context),
        separatorBuilder: (context, index)=>const Divider(color: Colors.grey,),
        itemCount: tasks.length
    ),
    fallback: (context)=>Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        const [
          Icon(Icons.menu,
            color: Colors.grey,
            size: 100.0,
          ),
          Text('No Tasks, please add some tasks.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}